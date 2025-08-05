Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639B62737F8;
	Tue,  5 Aug 2025 13:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399478; cv=none; b=clIHTLL0YR+mGCXRkIlffbXBphg9KilUis8UjHBSrgNxtMd7Pdd5SE/y/1J+McsFwkjmJfz5vmkkUf2Pvfe8qjZJhP6sRle782hM2CIxsQ8YXdxPVct2LWrTpwrdmZof99ni/Drr0cztVjLfGlPLu2E+bHlS8w/M0zrMEN3fYqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399478; c=relaxed/simple;
	bh=latZ4hFb/UMwTCp9lrxxZL3jFuxO8nc28l+KNSGjrLQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oZ+Q9DrCQy/4J/y2pHvBRWmWb2owv5pDkBWNfD95K5onp5/NjWR99s3QBQmSMEOGAFPJup8zUg3y8BpPRYaQPHwEjiLG0EIT8LT6vCoB+HGKtkWCtwZCA+tfb8/UQQHfOB6TSZn9w0QtDhsNEfX8httWtLAulpyT1EEcCwOna0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xs8C7PVY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xs8C7PVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F97C4CEF0;
	Tue,  5 Aug 2025 13:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399478;
	bh=latZ4hFb/UMwTCp9lrxxZL3jFuxO8nc28l+KNSGjrLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xs8C7PVY85w2nLBr2bpWOsOz+pc29gavHfaDlaX4JC0tRtCBE3i1DvkEfaS8VjCsK
	 rkYnWSM39oY8gfLC31O1gx8HDg3wjfgjTWO7BjojyaJqVedCZwjcMnuXYOFuCNawtf
	 JFDfDx4hXRLXf+jaPzowXMrvLj1vrky2XI8rA15VNoV7luxELEWvlHY04fJubW+9dR
	 gMlR8sZj0RFdAwnrzKAmA5DGWU9WCrW0EosZSpkktvppIyAEQOPVWEOlzthiTqmrBK
	 9BQh0aAajyk2i3zbHQcQVt1bR7z0LclG6SPVAa7NVW9C/+YWIXjjwARItID87WHyFf
	 pdJnqsVhl2H8A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-5.4] scsi: mpt3sas: Correctly handle ATA device errors
Date: Tue,  5 Aug 2025 09:09:17 -0400
Message-Id: <20250805130945.471732-42-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 15592a11d5a5c8411ac8494ec49736b658f6fbff ]

With the ATA error model, an NCQ command failure always triggers an abort
(termination) of all NCQ commands queued on the device. In such case, the
SAT or the host must handle the failed command according to the command
sense data and immediately retry all other NCQ commands that were aborted
due to the failed NCQ command.

For SAS HBAs controlled by the mpt3sas driver, NCQ command aborts are not
handled by the HBA SAT and sent back to the host, with an ioc log
information equal to 0x31080000 (IOC_LOGINFO_PREFIX_PL with the PL code
PL_LOGINFO_CODE_SATA_NCQ_FAIL_ALL_CMDS_AFTR_ERR). The function
_scsih_io_done() always forces a retry of commands terminated with the
status MPI2_IOCSTATUS_SCSI_IOC_TERMINATED using the SCSI result
DID_SOFT_ERROR, regardless of the log_info for the command.  This
correctly forces the retry of collateral NCQ abort commands, but with the
retry counter for the command being incremented. If a command to an ATA
device is subject to too many retries due to other NCQ commands failing
(e.g. read commands trying to access unreadable sectors), the collateral
NCQ abort commands may be terminated with an error as they run out of
retries. This violates the SAT specification and causes hard-to-debug
command errors.

Solve this issue by modifying the handling of the
MPI2_IOCSTATUS_SCSI_IOC_TERMINATED status to check if a command is for an
ATA device and if the command loginfo indicates an NCQ collateral
abort. If that is the case, force the command retry using the SCSI result
DID_IMM_RETRY to avoid incrementing the command retry count.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250606052747.742998-3-dlemoal@kernel.org
Tested-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and examination of the kernel
repository, here is my assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Bug Fix Analysis

1. **Fixes a Significant Bug**: The commit fixes a violation of the SAT
   (SCSI ATA Translation) specification that causes incorrect error
   handling for NCQ (Native Command Queuing) commands on SATA devices.
   When one NCQ command fails, all other NCQ commands get aborted as
   collateral damage, which is expected ATA behavior. However, the
   driver was incorrectly incrementing retry counters for these
   collateral aborts, eventually causing them to fail with errors.

2. **Real User Impact**: The commit message explicitly states this
   causes "hard-to-debug command errors" and includes a "Tested-by" tag
   from another developer (Yafang Shao), indicating this was a real
   problem affecting users in production.

3. **Small and Contained Fix**: The change is minimal - it only adds:
   - A new constant definition `IOC_LOGINFO_SATA_NCQ_FAIL_AFTER_ERR`
     (0x31080000)
   - A small conditional block (lines 5817-5829 in the new code) that
     checks for this specific log_info value and uses `DID_IMM_RETRY`
     instead of `DID_SOFT_ERROR`

4. **Low Risk of Regression**:
   - The fix is highly targeted - it only affects the specific case
     where `log_info == IOC_LOGINFO_SATA_NCQ_FAIL_AFTER_ERR`
   - It uses an existing SCSI mechanism (`DID_IMM_RETRY`) that's already
     well-established in the kernel (used in 30+ places across SCSI
     drivers)
   - The change preserves all existing behavior for other error
     conditions

5. **Fixes Specification Compliance**: The bug violates the SAT
   specification, which is important for interoperability and correct
   SATA device operation through SAS HBAs.

## Code Analysis

The key change is in the `MPI2_IOCSTATUS_SCSI_IOC_TERMINATED` case
handling:

```c
+if (log_info == IOC_LOGINFO_SATA_NCQ_FAIL_AFTER_ERR) {
+    /*
+     * This is a ATA NCQ command aborted due to another NCQ
+     * command failure. We must retry this command
+     * immediately but without incrementing its retry
+     * counter.
+     */
+    WARN_ON_ONCE(xfer_cnt != 0);
+    scmd->result = DID_IMM_RETRY << 16;
+    break;
+}
```

This specifically handles the NCQ collateral abort case (identified by
the log_info value 0x31080000) by using `DID_IMM_RETRY` which retries
the command without incrementing the retry counter, instead of the
default `DID_SOFT_ERROR` which would increment the counter.

## Stable Tree Criteria Met

- ✓ Fixes a real bug that affects users
- ✓ No new features added
- ✓ Minimal architectural changes
- ✓ Low risk of regression
- ✓ Confined to a specific subsystem (mpt3sas driver)
- ✓ Clear problem and solution

The commit meets all the criteria for stable tree backporting as it's a
targeted bug fix that resolves a specification compliance issue with
minimal risk.

 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 508861e88d9f..d7d8244dfedc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -195,6 +195,14 @@ struct sense_info {
 #define MPT3SAS_PORT_ENABLE_COMPLETE (0xFFFD)
 #define MPT3SAS_ABRT_TASK_SET (0xFFFE)
 #define MPT3SAS_REMOVE_UNRESPONDING_DEVICES (0xFFFF)
+
+/*
+ * SAS Log info code for a NCQ collateral abort after an NCQ error:
+ * IOC_LOGINFO_PREFIX_PL | PL_LOGINFO_CODE_SATA_NCQ_FAIL_ALL_CMDS_AFTR_ERR
+ * See: drivers/message/fusion/lsi/mpi_log_sas.h
+ */
+#define IOC_LOGINFO_SATA_NCQ_FAIL_AFTER_ERR	0x31080000
+
 /**
  * struct fw_event_work - firmware event struct
  * @list: link list framework
@@ -5814,6 +5822,17 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 			scmd->result = DID_TRANSPORT_DISRUPTED << 16;
 			goto out;
 		}
+		if (log_info == IOC_LOGINFO_SATA_NCQ_FAIL_AFTER_ERR) {
+			/*
+			 * This is a ATA NCQ command aborted due to another NCQ
+			 * command failure. We must retry this command
+			 * immediately but without incrementing its retry
+			 * counter.
+			 */
+			WARN_ON_ONCE(xfer_cnt != 0);
+			scmd->result = DID_IMM_RETRY << 16;
+			break;
+		}
 		if (log_info == 0x31110630) {
 			if (scmd->retries > 2) {
 				scmd->result = DID_NO_CONNECT << 16;
-- 
2.39.5

