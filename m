Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74252274651;
	Tue,  5 Aug 2025 13:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399444; cv=none; b=Jt0V+SRIU7bdqq0Aew6mTJXH2oxGlcQcd1DH/Z5XUUZArCxr+HYboG6ya9KhHKRxUjCt6l2yu6QZLZow7NgyXVuX50kpEi+fkFmfhqWbnkdf7aH8N3wksIuUGayai3la2b6PrlYt2pN0clMfc5pqCAM/J8squjjf5Jp9mUAH/Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399444; c=relaxed/simple;
	bh=RPLYFw87xRFzFOY2foOyT+uHWsKDa7jdOzKw1GAFObY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nTMHI+Kl+SlcULmyaNCz6KsqPlgnabNY8N74NNZGe8wiKJA030zaGRMiqwIbKTGtlEV9kTAuGQjjZvOmr4S5hYrBpxPDquNswimGim87fh1cPKvfz2TlzV5AIOIg4X4+zmrWAccCjJ8zGcvEhHMWL7Oxio1UGMulnzvyBb4Lexk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gKMmO/Xj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gKMmO/Xj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AB1C4CEF7;
	Tue,  5 Aug 2025 13:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399444;
	bh=RPLYFw87xRFzFOY2foOyT+uHWsKDa7jdOzKw1GAFObY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gKMmO/XjlR+lsij5p16dzxZFs9tcyV/ac1oMBgTr7kXhCHqJNCjSq1orn9ZbBcC2W
	 FXu/PNQf/aWv4I7XmpMa1O/1yRnaQZstKTMZfHLbW3ogYzth8ATC0xXT0ShCsJwoAx
	 KWb53sCAxGRRuaXuhhnvvQat7akdEcF6F0xitInsVvL6DjlHWGEVJP+deAHccd6XTP
	 7edxwaa2NAmFkBbqPXE1z88on4+N2lk9LvHL2bu64Ssrfl/D0ABmAeDg+cPiczihua
	 g+cQFYqe9tvWBANO7fGyHO8Yf3WLSio18OR42TYvF+EIKg2ubP7ymsAp0E45+mB+wn
	 OO3d3w+PT79FA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-5.4] scsi: lpfc: Check for hdwq null ptr when cleaning up lpfc_vport structure
Date: Tue,  5 Aug 2025 09:09:01 -0400
Message-Id: <20250805130945.471732-26-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 6698796282e828733cde3329c887b4ae9e5545e9 ]

If a call to lpfc_sli4_read_rev() from lpfc_sli4_hba_setup() fails, the
resultant cleanup routine lpfc_sli4_vport_delete_fcp_xri_aborted() may
occur before sli4_hba.hdwqs are allocated.  This may result in a null
pointer dereference when attempting to take the abts_io_buf_list_lock for
the first hardware queue.  Fix by adding a null ptr check on
phba->sli4_hba.hdwq and early return because this situation means there
must have been an error during port initialization.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20250618192138.124116-4-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

So, the issue is:
1. During driver initialization in `lpfc_sli4_pci_probe()` (around line
   14868), `lpfc_sli4_hba_setup()` is called
2. Inside `lpfc_sli4_hba_setup()` at line 8517, `lpfc_sli4_read_rev()`
   is called
3. If `lpfc_sli4_read_rev()` fails, we goto `out_free_mbox` which
   returns error
4. The queue creation (`lpfc_sli4_queue_create()` at line 8811) that
   allocates `hdwq` is never reached
5. When the error is returned to `lpfc_sli4_pci_probe()`, it goes to
   `out_free_sysfs_attr`
6. This error path calls `lpfc_destroy_shost()` -> `destroy_port()` ->
   `lpfc_cleanup()` -> `lpfc_cleanup_vports_rrqs()` ->
   `lpfc_sli4_vport_delete_fcp_xri_aborted()`
7. `lpfc_sli4_vport_delete_fcp_xri_aborted()` tries to access
   `phba->sli4_hba.hdwq[idx]` which is NULL, causing a null pointer
   dereference

## Backport Analysis

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Critical Bug Fix**: The commit fixes a NULL pointer dereference
   that can cause a kernel crash. This is a serious bug that affects
   system stability when the lpfc driver fails to initialize properly.

2. **Clear Error Path Issue**: The bug occurs in a well-defined error
   handling path - when `lpfc_sli4_read_rev()` fails during HBA setup.
   This is not a theoretical issue but can happen in real-world
   scenarios when hardware initialization fails.

3. **Small and Contained Fix**: The fix is minimal - just adding a NULL
   check with early return (4 lines of code). This follows the stable
   kernel criteria of being a small, focused fix that addresses a
   specific issue.

4. **No Architectural Changes**: The fix doesn't introduce any new
   features or change the driver architecture. It simply adds defensive
   programming to prevent accessing unallocated memory.

5. **Low Risk of Regression**: The added check `if
   (!phba->sli4_hba.hdwq) return;` is safe - if hdwq is NULL, the
   function cannot proceed anyway. The early return prevents the crash
   without affecting normal operation when hdwq is properly allocated.

6. **Matches Stable Rules**: According to stable kernel rules, fixes for
   kernel crashes and oopses are prime candidates for backporting. This
   commit specifically prevents a NULL pointer dereference that would
   result in a kernel oops.

7. **Driver Initialization Robustness**: The issue affects error
   handling during driver initialization, which is a critical path.
   Failures during initialization should be handled gracefully without
   causing system crashes.

The commit message clearly describes the problem scenario and the
solution, making it easy for stable maintainers to understand the
importance of this fix. The fact that it adds a defensive check before
dereferencing a pointer that may not be allocated in error paths is
exactly the type of robustness improvement that stable kernels should
receive.

 drivers/scsi/lpfc/lpfc_scsi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 8acb744febcd..31a9f142bcb9 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -390,6 +390,10 @@ lpfc_sli4_vport_delete_fcp_xri_aborted(struct lpfc_vport *vport)
 	if (!(vport->cfg_enable_fc4_type & LPFC_ENABLE_FCP))
 		return;
 
+	/* may be called before queues established if hba_setup fails */
+	if (!phba->sli4_hba.hdwq)
+		return;
+
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	for (idx = 0; idx < phba->cfg_hdw_queue; idx++) {
 		qp = &phba->sli4_hba.hdwq[idx];
-- 
2.39.5

