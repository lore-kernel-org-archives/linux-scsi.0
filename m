Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565412749F8;
	Tue,  5 Aug 2025 13:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399434; cv=none; b=ix8SBZoWLxkIwgnvFe+oijNvOhIHxZyoKWEuqmD/GWQgo3s9Njg8PC8tA5CqoB6pg0H3wesebzQ5KqsbpR4OzgJmLET9dLoS0Rz4451Z6EXtS3Hg4eNzKg1fTdtAXRsO9iJheGM0zvcmccVr9lXVUHhRLZqZNrTpN3ZDtNG9Ado=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399434; c=relaxed/simple;
	bh=KL2jZGvWvIE/86rXTa23d+VCwi3rbmqkj5Jqt1n0jgs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bg/I2DkIM3IdSrVDmzHuDdLNbP018EPfNgRcxuWno+sisR9kt1sCtNhB8f8SDx+YFzrae8l1sA0dLzrQmf+sk4/VTi6qAoLxRrBvOHDqWSw6qKm1m5O8FEA3Q+k/0kYlYu/2vqxZ3l0Cy7LIWr6lgNpv8aBdcGFivl0s78QEGe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qhcwx+vK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qhcwx+vK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D33C4CEF7;
	Tue,  5 Aug 2025 13:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399434;
	bh=KL2jZGvWvIE/86rXTa23d+VCwi3rbmqkj5Jqt1n0jgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qhcwx+vKpOLAtJOgTzoDZ8Ys8Ee47rTrRG2hEcxKHzEvjgn2voUb7lwwsoKej6GK9
	 g41Zjw00Gmt0jeQeE2hczVOWLfqcGmD/2h7bLvrphf9v3WE5RqyNvvR8h7W+viRns5
	 BIeSjh0clhk6LbNrdUzspJ/z3Q8168ug46BsRJtenho5s21ijcXFrWtx4FZztxMIYX
	 sZVpBo7sZHQwp0BZ+0yVhbfMJdkl9VfcuKQN0kHo7NbqBYFO7Hvoq0xe8ySuockVXF
	 OHncVfwabf9DmJoiwAoF+p1PxsJY+S4R0HGjG0RTqrkhrUuKaTIn+Lkp+SK1XQfDhn
	 cNNN/c8bGYeUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-6.12] scsi: lpfc: Ensure HBA_SETUP flag is used only for SLI4 in dev_loss_tmo_callbk
Date: Tue,  5 Aug 2025 09:08:56 -0400
Message-Id: <20250805130945.471732-21-sashal@kernel.org>
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

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 1cced5779e7a3ff7ec025fc47c76a7bd3bb38877 ]

For SLI3, the HBA_SETUP flag is never set so the lpfc_dev_loss_tmo_callbk
always early returns.  Add a phba->sli_rev check for SLI4 mode so that
the SLI3 path can flow through the original dev_loss_tmo worker thread
design to lpfc_dev_loss_tmo_handler instead of early return.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20250618192138.124116-9-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough context. Let me analyze the commit thoroughly.

**Backport Status: YES**

This commit fixes a significant bug in the lpfc SCSI driver that causes
SLI3 mode HBAs to completely bypass dev_loss_tmo handling, which is a
critical issue for device loss timeout processing.

## Analysis:

### 1. **Bug Description:**
The commit fixes a bug where `lpfc_dev_loss_tmo_callbk()` always returns
early for SLI3 HBAs because the `HBA_SETUP` flag is never set for SLI3
mode. The code at line 186 checks:
```c
if (test_bit(FC_UNLOADING, &vport->load_flag) ||
    !test_bit(HBA_SETUP, &phba->hba_flag))
```

### 2. **Root Cause:**
- The `HBA_SETUP` flag is only set in `lpfc_sli4_hba_setup()` function
  (drivers/scsi/lpfc/lpfc_sli.c:8850)
- For SLI3, the initialization function is `lpfc_sli_hba_setup()` which
  never sets this flag
- This check was incorrectly added in commit 2be1d4f11944c (July 2024)
  without considering SLI3 mode

### 3. **Impact:**
- **SLI3 HBAs completely lose dev_loss_tmo functionality**: The early
  return prevents the worker thread event from being scheduled (lines
  277-289), which means `lpfc_dev_loss_tmo_handler()` is never called
- **Device removal handling is broken**: Without proper dev_loss_tmo
  processing, devices that disappear from the fabric won't be properly
  cleaned up
- **Memory leaks and stale references**: Node references won't be
  properly released, potentially causing memory leaks

### 4. **The Fix:**
The fix adds a proper SLI revision check:
```c
if (test_bit(FC_UNLOADING, &vport->load_flag) ||
    (phba->sli_rev == LPFC_SLI_REV4 &&
    !test_bit(HBA_SETUP, &phba->hba_flag)))
```
This ensures the HBA_SETUP check only applies to SLI4, allowing SLI3 to
flow through to the original worker thread design.

### 5. **Stable Backport Criteria:**
✓ **Fixes a real bug**: Completely broken dev_loss_tmo for SLI3 HBAs
✓ **Small and contained**: Single-line logic fix with minimal risk
✓ **No architectural changes**: Simply corrects a logic error
✓ **Critical functionality**: dev_loss_tmo is essential for proper SCSI
device management
✓ **Regression fix**: This fixes a regression introduced by commit
2be1d4f11944c

### 6. **Risk Assessment:**
- **Very low risk**: The change only adds a SLI revision check before an
  existing condition
- **Well-tested code path**: Restores SLI3 to use the original, well-
  tested dev_loss_tmo path
- **No new functionality**: Simply fixes broken existing functionality

This is a textbook example of a stable backport candidate - it fixes a
serious regression that completely breaks essential functionality for
SLI3 HBAs with a minimal, safe change.

 drivers/scsi/lpfc/lpfc_hbadisc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index b88e54a7e65c..3962f07c9140 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -183,7 +183,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 
 	/* Don't schedule a worker thread event if the vport is going down. */
 	if (test_bit(FC_UNLOADING, &vport->load_flag) ||
-	    !test_bit(HBA_SETUP, &phba->hba_flag)) {
+	    (phba->sli_rev == LPFC_SLI_REV4 &&
+	    !test_bit(HBA_SETUP, &phba->hba_flag))) {
 
 		spin_lock_irqsave(&ndlp->lock, iflags);
 		ndlp->rport = NULL;
-- 
2.39.5

