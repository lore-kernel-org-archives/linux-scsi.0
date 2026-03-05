Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D7B3CA4B9;
	Thu,  5 Mar 2026 15:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772725034; cv=none; b=qL8mcFIz/99lNMr5aWkCDLkOBAKy+pEhljQiHbVYFqJx5xZHNxjCRW2L3Pcb8Y3tQd1jNDkIIQH2Efv8GSs+08Bs3R0WsnjCnz4sQw3yzaj+2nd93ggHrJEyKatFAkRBkNAyK9wXfFtiVaFiP3sNsJMRQ8HGjrjTE+wOZfo48gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772725034; c=relaxed/simple;
	bh=iQ0yLgTGAJZgiDZIOQexcimPC6Gs/WY2/5Nfp5GgG2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=grmjem5kqyp08Q52NKWs5QKyfQqmW0V7HxCTdqPLFJrJsJGNF9Fb3OGa8GRC3h7Ae/hlNByyZspUaCAKskMHAUB0xS9kMXNqeirLxSnR5OnH+4gqnZjCKxggsTTu8oL7dvTDqV/wbw/UCQr/DWhb1Nhv88Jp5rF5iSZWETkx5hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BPCjtOsh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BPCjtOsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73271C19423;
	Thu,  5 Mar 2026 15:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772725034;
	bh=iQ0yLgTGAJZgiDZIOQexcimPC6Gs/WY2/5Nfp5GgG2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPCjtOshOzcviEsHmW6Gu1mbDrDMgdtNPs9RFAqW5oK8sz3LbcmU7HABW9KLmaqwu
	 guFaJ5gy1t4jLPQu9r3BTrSO794eI24oQLtOtCsGr//NiN4OClS9u1ScB2TLpLQRoY
	 iLH1A/OIzWD9FG12jPMtUsTDjKeGz1G0Ru+3M749xZs7doZ5cfrgkHi4QQbmVSN4ak
	 Y1OjfLyyIaM9Wanq5iiprHLbOFF1JW3gU/Ahw0WiZB1oCP01VKVPIEgtSKcBWe75Sd
	 KQ4PF1DFVNTuLZx/Mzd76duN7rYAbWfCmaF8D/2hg+8tVOXsFDgi3d2F2gxoy/F51O
	 opUEesr7l0UsA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tomas Henzl <thenzl@redhat.com>,
	David Jeffery <djeffery@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] scsi: ses: Fix devices attaching to different hosts
Date: Thu,  5 Mar 2026 10:36:49 -0500
Message-ID: <20260305153704.106918-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260305153704.106918-1-sashal@kernel.org>
References: <20260305153704.106918-1-sashal@kernel.org>
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

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 70ca8caa96ce473647054f5c7b9dab5423902402 ]

On a multipath SAS system some devices don't end up with correct symlinks
from the SCSI device to its enclosure. Some devices even have enclosure
links pointing to enclosures attached to different SCSI hosts.

ses_match_to_enclosure() calls enclosure_for_each_device() which iterates
over all enclosures on the system, not just enclosures attached to the
current SCSI host.

Replace the iteration with a direct call to ses_enclosure_find_by_addr().

Reviewed-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://patch.msgid.link/20260210191850.36784-1-thenzl@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Problem Description
On multipath SAS systems, `ses_match_to_enclosure()` calls
`enclosure_for_each_device(ses_enclosure_find_by_addr, &efd)` at line
687, which iterates over **all** enclosures registered system-wide via
`container_list`. This means a SCSI device can be incorrectly matched to
an enclosure on a completely different SCSI host, resulting in wrong
sysfs symlinks from devices to enclosures.

### The Fix
The fix replaces the global iteration with a direct call:
`ses_enclosure_find_by_addr(edev, &efd)`, which searches only the
specific `edev` enclosure device already passed into
`ses_match_to_enclosure()`. The function signature also changes from
`void *data` to `struct efd *efd` for type safety (since it's no longer
used as a callback for `enclosure_for_each_device`).

### Stable Kernel Criteria Assessment

1. **Obviously correct and tested**: Yes. The `edev` is already the
   correct enclosure for the current host — using the global iterator
   was simply wrong. Reviewed-by David Jeffery (Red Hat), Signed-off-by
   Martin K. Petersen (SCSI maintainer).

2. **Fixes a real bug**: Yes. Incorrect device-to-enclosure associations
   cause wrong symlinks, which breaks storage management tools that rely
   on enclosure topology on multipath SAS systems (enterprise storage
   environments).

3. **Important issue**: Yes. Enterprise SAS multipath setups are common
   in production servers. Incorrect enclosure associations can lead to
   operators targeting wrong devices during maintenance.

4. **Small and contained**: Yes. Single file change
   (`drivers/scsi/ses.c`), ~10 meaningful lines changed. The core fix is
   replacing one function call.

5. **No new features**: Correct. Pure bug fix.

6. **Self-contained**: Yes. No dependencies on other patches.
   `ses_enclosure_find_by_addr` is only called from this one site, and
   it's a static function within ses.c.

### Risk Assessment
**Very low risk.** The fix narrows the search scope from all enclosures
to just the relevant one. The matching logic within
`ses_enclosure_find_by_addr` is completely unchanged. The only
behavioral difference is that devices will no longer be incorrectly
associated with enclosures on different hosts.

### Bug Age
The buggy code was introduced in commit `c38c007af04b92` ("[SCSI] ses:
Use vpd information from scsi_device") by Hannes Reinecke in v3.15-rc1
(2014). This bug affects **all** current stable trees.

### Verification

- **git blame** confirmed line 687
  (`enclosure_for_each_device(ses_enclosure_find_by_addr, &efd)`) was
  introduced in commit `c38c007af04b92` (v3.15-rc1)
- **git describe --contains c38c007af04b92** confirmed version:
  `v3.15-rc1~136^2~4`
- **Read of `drivers/misc/enclosure.c:85-101`** confirmed
  `enclosure_for_each_device()` iterates over ALL entries in
  `container_list` (global list of all enclosures)
- **Grep for `ses_enclosure_find_by_addr`** confirmed it is only
  referenced at two locations in ses.c: its definition (line 531) and
  the single call site (line 687) — no other callers exist
- **Grep for `enclosure_for_each_device`** confirmed the SES driver at
  line 687 is the ONLY caller outside of enclosure.c itself — so this
  change has no impact on other subsystems
- **Read of `ses_match_to_enclosure()`** (lines 669-689) confirmed
  `edev` is already passed as a parameter but was ignored in favor of
  global iteration
- **lore.kernel.org search** found the patch was reviewed by Martin K.
  Petersen and included in multiple stable releases (6.1.165, 6.6.128,
  6.12.75, 6.18.16, 6.19.6), indicating broad acceptance

### Conclusion
This is a clear, surgical fix for a real bug affecting enterprise
multipath SAS systems. The bug has existed since v3.15 (2014). The fix
is small, self-contained, obviously correct, low-risk, and has been
reviewed by the SCSI maintainer.

**YES**

 drivers/scsi/ses.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 2c61624cb4b03..50e744e891295 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -529,9 +529,8 @@ struct efd {
 };
 
 static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
-				      void *data)
+				      struct efd *efd)
 {
-	struct efd *efd = data;
 	int i;
 	struct ses_component *scomp;
 
@@ -684,7 +683,7 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 	if (efd.addr) {
 		efd.dev = &sdev->sdev_gendev;
 
-		enclosure_for_each_device(ses_enclosure_find_by_addr, &efd);
+		ses_enclosure_find_by_addr(edev, &efd);
 	}
 }
 
-- 
2.51.0

