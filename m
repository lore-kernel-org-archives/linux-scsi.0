Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71EF43DA23;
	Tue, 10 Mar 2026 09:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133318; cv=none; b=T29jsmW0riaU1o/dtX+siFZ+YGEovk/pBwXGsOfE7C9SA0ATuIq7q5wxFTJ41IpUtutH/CEgViAEcpOs/aitOPsP65n2AXydmMHbbObzh+Po9aM7gOq9M7du0Z+lz7UjORXGoF/16emyEgDE8mhEMK27T1pAcMyEcCdbmvcFJA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133318; c=relaxed/simple;
	bh=COcWvrJGOCmTBGybONxgRxL/UPPPPzAx7FrDI1oNTMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gr53jDVOL3g9w4SZhyb3q1lqAUf2mh0+AdwnW3iW1z40Be6UDKrK5wGcDQaEIrQZiwshwPYSRUyoXA4R8ZjDPTeKsnGtXsemyGg1S+CDBg1+XCB0qnROdvj3qsrR3dwM+5ptFMkMuuV5Rg15W8WiSjLvS1z6ssyDkO26zrKRfkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XWdbdgBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XWdbdgBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9122BC2BCB5;
	Tue, 10 Mar 2026 09:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133318;
	bh=COcWvrJGOCmTBGybONxgRxL/UPPPPzAx7FrDI1oNTMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWdbdgBB0elkh5wHp9dpNL3YKGT0sprQql1jC1WHhnr1jbcAlMTvHXtO1d/3wGV/z
	 Z0SvFlIhVWtEv5XMWijVcoAU9kkHUnblf2rrDu1daj91OPt0ymIeSFoF/z71UmRjNd
	 x+MWH8yt/5lbtpYDEeh9YR4Hjz85WNu9lM9m2qV+ZgWxtt6y+gOEgGHIqHbksx6YNj
	 FU6Ry1XWKcvhmZXA3iUXPEIRADdr8LAym9LwkFYYlY+cdX3T0u8GtSjNTHnPrnX0zR
	 sl71JRbp8HWGKc5hezVjUl4Z6A9p7JtEDrlx9is2XQZVk55KKHUaSDp31N344MyJ8l
	 S1q6CbOKx60jw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Florian Fuchs <fuchsfl@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] scsi: devinfo: Add BLIST_SKIP_IO_HINTS for Iomega ZIP
Date: Tue, 10 Mar 2026 05:01:08 -0400
Message-ID: <20260310090145.2709021-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Fuchs <fuchsfl@gmail.com>

[ Upstream commit 80bf3b28d32b431f84f244a8469488eb6d96afbb ]

The Iomega ZIP 100 (Z100P2) can't process IO Advice Hints Grouping mode
page query. It immediately switches to the status phase 0xb8 after
receiving the subpage code 0x05 of MODE_SENSE_10 command, which fails
imm_out() and turns into DID_ERROR of this command, which leads to unusable
device. This was tested with an Iomega ZIP 100 (Z100P2) connected with a
StarTech PEX1P2 AX99100 PCIe parallel port card.

Prior to this fix, Test Unit Ready fails and the drive can't be used:
        IMM: returned SCSI status b8
        sd 7:0:6:0: [sdh] Test Unit Ready failed: Result: hostbyte=0x01 driverbyte=DRIVER_OK

Signed-off-by: Florian Fuchs <fuchsfl@gmail.com>
Link: https://patch.msgid.link/20260227181823.892932-1-fuchsfl@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The IO Advice Hints feature (the source of the bug) was only introduced
in v6.10, and `BLIST_SKIP_IO_HINTS` was also only in v6.10+. The older
stable trees (6.6.y, 6.1.y, 5.15.y) don't have this code path, so they
wouldn't need this fix.

For stable trees that DO have this code (6.10.y, 6.11.y, 6.12.y, etc.),
this is a straightforward one-line quirk addition.

### Analysis Summary

**What the commit fixes:** The Iomega ZIP 100 drive becomes completely
unusable because the IO Advice Hints mode page query causes the device
to error out. The commit message includes specific error output showing
the device fails "Test Unit Ready" with a SCSI status of 0xb8.

**Type of change:** Hardware quirk addition — adding one flag
(`BLIST_SKIP_IO_HINTS`) to an existing device entry in the SCSI device
info table. This is a textbook example of a device-specific workaround.

**Scope and risk:**
- One-line change: adds `| BLIST_SKIP_IO_HINTS` to an existing entry
- Zero risk to other devices — only affects IOMEGA ZIP drives
- The `BLIST_SKIP_IO_HINTS` flag is already well-established and used by
  USB storage devices
- The existing IOMEGA ZIP entry already existed; only the flag set is
  expanded

**User impact:** Without this fix, the Iomega ZIP 100 drive is
completely unusable on kernels v6.10+. The device was tested and
confirmed to work with the fix.

**Dependencies:** Requires `BLIST_SKIP_IO_HINTS` flag definition (commit
`633aeefafc9c2`, present since v6.10). This is already in all stable
trees that have the IO hints feature.

**Stable criteria met:**
1. Obviously correct — adds a quirk flag to skip a mode page query the
   device can't handle
2. Fixes a real bug — device is completely unusable without it
3. Small and contained — single flag addition to one line
4. No new features — uses existing quirk infrastructure

### Verification

- Verified `BLIST_SKIP_IO_HINTS` was introduced in commit
  `633aeefafc9c2` (v6.10) via `git log` and `git tag --contains`
- Verified the Fixes: target `4f53138fffc2` (IO hints feature) was
  introduced in v6.10 via `git tag --contains`
- Verified older stable trees (6.6.y, 6.1.y, 5.15.y) do NOT contain
  either the IO hints feature or the BLIST_SKIP_IO_HINTS flag — so they
  are unaffected
- Verified via grep that `BLIST_SKIP_IO_HINTS` is already used in USB
  storage drivers (`uas.c`, `scsiglue.c`) and checked in `sd.c:3275`
- Verified the change is a single flag addition to an existing device
  entry in `scsi_devinfo.c`
- The IOMEGA ZIP entry already existed in the table (just missing the
  new flag)

**YES**

 drivers/scsi/scsi_devinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 78346b2b69c91..c51146882a1fa 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -190,7 +190,7 @@ static struct {
 	{"IBM", "2076", NULL, BLIST_NO_VPD_SIZE},
 	{"IBM", "2105", NULL, BLIST_RETRY_HWERROR},
 	{"iomega", "jaz 1GB", "J.86", BLIST_NOTQ | BLIST_NOLUN},
-	{"IOMEGA", "ZIP", NULL, BLIST_NOTQ | BLIST_NOLUN},
+	{"IOMEGA", "ZIP", NULL, BLIST_NOTQ | BLIST_NOLUN | BLIST_SKIP_IO_HINTS},
 	{"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
 	{"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
 	{"INSITE", "I325VM", NULL, BLIST_KEY},
-- 
2.51.0

