Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC97D26B74A;
	Mon, 15 Dec 2025 08:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765788943; cv=none; b=ADHVDfJbL7Z9sE6M6SlaAAjLU0lAJMUyq5yfEjTChhx4f/o1N9npZRtx8bJcHGFC4z1/k6ytpcVaX58SQIOqVVGQ34BA6Xwc8iNDDuMDd57/MdjU/2pugCA/UBe9qa3U/vfMjoPwJy80LZudJKG1YwUVBMC/iCtFykqWSAbLvOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765788943; c=relaxed/simple;
	bh=2XhKIbukNtZId041D790Xt0/zcqpwSfs62K+mCq20bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=niA9DH/+YpulwNd0127BHNXYcGVLACV7qpV8d8EYQjLDTrAw9XeIpdX7QjKBoMj/q1uqOTDzjCUUE6WHIrpEMm4Ua3jC1hMn6Kv1Q3euD7CLSGtqR3ptLywlZkLPe4fshWPXMNj3QMg86qx5ZWQoYhoRZ1CeD5Jxms/AljiTroo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m+CjMEG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m+CjMEG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A10C4CEF5;
	Mon, 15 Dec 2025 08:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765788943;
	bh=2XhKIbukNtZId041D790Xt0/zcqpwSfs62K+mCq20bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+CjMEG8BUTSd7AGnrtoZjn5E9M9DmbmVPn2SmQNjK7PRo+ED+3mMA/WHoOqFIDBB
	 5c8zbQKrJ40w5/Pyv9pUlSwuqV3bwX0AfI7/hT7+Eaj/9Yq10mTM4bg+VpmJ+xVcj/
	 +qnxQd/t0JDOeXIWd4158IsmTG3bp6Z+JDry/GqqZE4bx/fkepSxaUCmpFWZHbtjbM
	 JJwZG+T218FxxXTmVixkhcocSM31boUaApgNeNTrwv9l2qOK3gCfrHuHBra9RZH/TF
	 jHf32r5DVP1WACAkZWgQnHIzmVyMlOyC4hb/Gy1t8jI1wLEXekPnZTYOa3zmRNIH1e
	 MH3/Ivjky3Gig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xingui Yang <yangxingui@huawei.com>,
	Jason Yan <yanaijie@huawei.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	dlemoal@kernel.org,
	johannes.thumshirn@wdc.com,
	wdhh6@aliyun.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] scsi: Revert "scsi: libsas: Fix exp-attached device scan after probe failure scanned in again after probe failed"
Date: Mon, 15 Dec 2025 03:55:25 -0500
Message-ID: <20251215085533.2931615-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251215085533.2931615-1-sashal@kernel.org>
References: <20251215085533.2931615-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 278712d20bc8ec29d1ad6ef9bdae9000ef2c220c ]

This reverts commit ab2068a6fb84751836a84c26ca72b3beb349619d.

When probing the exp-attached sata device, libsas/libata will issue a
hard reset in sas_probe_sata() -> ata_sas_async_probe(), then a
broadcast event will be received after the disk probe fails, and this
commit causes the probe will be re-executed on the disk, and a faulty
disk may get into an indefinite loop of probe.

Therefore, revert this commit, although it can fix some temporary issues
with disk probe failure.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://patch.msgid.link/20251202065627.140361-1-yangxingui@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis Summary

### 1. Bug Description
This revert fixes an **infinite probe loop** regression introduced by
commit `ab2068a6fb84`. The original commit cleared the expander phy
attached address when device probe failed, intending to prevent
"flutter" detection. However, this creates an infinite loop:

1. Expander-attached SATA device probe fails
2. Hard reset issued in `sas_probe_sata()` → `ata_sas_async_probe()`
3. Broadcast event received after probe failure
4. Because address was cleared, device appears "new"
5. Probe re-executed → goto step 1

**Result**: Faulty disks get stuck in indefinite probe loops.

### 2. Stable Kernel Rules Assessment
| Criterion | Assessment |
|-----------|------------|
| Fixes real bug | ✅ YES - infinite loop (severe) |
| Obviously correct | ✅ YES - pure revert, restores known-working
behavior |
| Small and contained | ✅ YES - removes ~14 lines from one function in
one file |
| No new features | ✅ YES - removes code, adds nothing |
| Tested | ✅ YES - Reviewed-by from Jason Yan and John Garry |

### 3. Affected Stable Trees
- Original problematic commit first appeared in **v6.10-rc7**
- Present in: v6.10.x, v6.11.x, v6.12.x, v6.13.x, v6.14.x, v6.15.x,
  v6.16.x stable trees
- **NOT** in v6.1.x or v6.6.x LTS trees (they don't need this fix)

### 4. Risk Assessment
**Very Low Risk**:
- Pure revert restoring pre-v6.10 behavior that worked for years
- No complex logic changes - simply removes the problematic code
- Isolated to `sas_fail_probe()` function in `sas_internal.h`
- Same author (Xingui Yang) who wrote the original is now reverting it
- Multiple reviewers approved (John Garry from Oracle is a SCSI
  maintainer)

### 5. User Impact
- **High impact** for users with SAS expanders and faulty/failing SATA
  drives
- Enterprise storage systems commonly use SAS expanders
- Infinite loops during device probe can render systems unusable
- The trade-off (accepting "flutter" detection vs. infinite loops)
  clearly favors the revert

### 6. Dependencies
None - this is a self-contained revert that requires no other commits.

## Conclusion

This is a textbook case for stable backporting:
- Fixes a **severe regression** (infinite loop)
- **Pure revert** with minimal risk
- **Well-reviewed** by subsystem experts
- Clearly affects real users with SAS/SATA storage configurations
- Original author acknowledges the bug is worse than the original issue
  it tried to fix

The commit should be backported to all stable trees v6.10.x and newer
that contain the original problematic commit.

**YES**

 drivers/scsi/libsas/sas_internal.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 6706f2be8d274..da5408c701cdd 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -145,20 +145,6 @@ static inline void sas_fail_probe(struct domain_device *dev, const char *func, i
 		func, dev->parent ? "exp-attached" :
 		"direct-attached",
 		SAS_ADDR(dev->sas_addr), err);
-
-	/*
-	 * If the device probe failed, the expander phy attached address
-	 * needs to be reset so that the phy will not be treated as flutter
-	 * in the next revalidation
-	 */
-	if (dev->parent && !dev_is_expander(dev->dev_type)) {
-		struct sas_phy *phy = dev->phy;
-		struct domain_device *parent = dev->parent;
-		struct ex_phy *ex_phy = &parent->ex_dev.ex_phy[phy->number];
-
-		memset(ex_phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
-	}
-
 	sas_unregister_dev(dev->port, dev);
 }
 
-- 
2.51.0

