Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1616D226CF1;
	Wed, 10 Dec 2025 03:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765338599; cv=none; b=SWkapK3X1RMvKE0n1fjheCiNQs2PsI5KUGSkQaNVyXwHMPGjCDDquPNQY0phaKg+4m3jw7WqiM7c57fFzaTMbUKC/D4GMrNJRVjdWStzlxq8UU8mO/AqTeb/JISrXfX0+rl3TG5tv/Hhdiql2WaKzcokxTAvr0Gm/pF0Waml+AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765338599; c=relaxed/simple;
	bh=dpB/3BjoLjxJJsEzxAOAynX03jBs1JS7bEBTr4QXpOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u4RNfnxsLxrRevbs8Cnw5bW169E7S6vW1NvO6iRvUxZx1fiG2U3uMJlGJrZ0D64AD7fe+t4FTy4iS3J4pfIOI7GVWP86TQ3PWwCJkjqXPunV9bV3ywioM3iByrS2jYCrWSYI8nKWaN8blr+VpeycB5bPUqU75DXdwGGWNggO/zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lyTdniub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lyTdniub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D17C4CEF1;
	Wed, 10 Dec 2025 03:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765338598;
	bh=dpB/3BjoLjxJJsEzxAOAynX03jBs1JS7bEBTr4QXpOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lyTdniub3V9JhuafKB/WYoy00ddNgQRHhO2LBmMIr7gR8bKjyIRi7j9T9P3Rwp5fH
	 g+B9WPnj+1jl+4/6VoY2OQVWj8gTutEyFJ2JA+KQSlAXkhiGGNNtcLixbM9LRH2t62
	 vewCNrqoB0An3UABc0tiVPHWjaHeHL3JbB7xtO0dkyM1LoqaZKiwaXoBZ34zar61SH
	 VjALmzWQaGrao6XrvwVHiBb0j8WuJeSecRBlFB8eHR5jzZLh7tDPdJbe/RvXqy1BRX
	 PUS2V6GQG/5nGVYlrpUIMRFXB9jT85QzGEUCK1XVPU1iUyR4oGsIikjPjR6CHxOWqd
	 mpPqGYGPECtDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	paul.ely@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.17] scsi: lpfc: Fix reusing an ndlp that is marked NLP_DROPPED during FLOGI
Date: Tue,  9 Dec 2025 22:48:59 -0500
Message-ID: <20251210034915.2268617-18-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251210034915.2268617-1-sashal@kernel.org>
References: <20251210034915.2268617-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 07caedc6a3887938813727beafea40f07c497705 ]

It's possible for an unstable link to repeatedly bounce allowing a FLOGI
retry, but then bounce again forcing an abort of the FLOGI.  Ensure that
the initial reference count on the FLOGI ndlp is restored in this faulty
link scenario.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://patch.msgid.link/20251106224639.139176-8-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Looking at this commit, I need to analyze it thoroughly to determine if
it's suitable for stable backporting.

## Commit Analysis

### 1. Problem Being Fixed

This commit fixes a **reference counting bug** in the lpfc (Broadcom
Fibre Channel) driver. The issue occurs when:

1. A FLOGI (Fabric Login) is issued on an unstable link
2. The link bounces, causing the FLOGI to abort
3. The ndlp (node list pointer) gets marked `NLP_DROPPED` and its
   reference count is decremented via `lpfc_nlp_put()`
4. The link comes back and lpfc tries to reuse the same ndlp for a new
   FLOGI retry
5. The ndlp is still marked `NLP_DROPPED` with a decremented refcount,
   causing reference count imbalances

This can lead to **use-after-free** or **double-free** conditions -
serious kernel stability and security issues.

### 2. Code Changes Analysis

The fix is surgical and well-designed:

**In `lpfc_issue_els_flogi()`:**
- Adds a check: if ndlp is marked `NLP_DROPPED`, clear the flag and
  restore the reference count with `lpfc_nlp_get()`
- This is the core fix - properly restoring state when retrying with a
  previously-dropped ndlp

**In `lpfc_cmpl_els_flogi()`:**
- Before calling `lpfc_nlp_put()`, now checks if `NLP_DROPPED` is
  already set
- Sets `NLP_DROPPED` atomically before decrementing to prevent double-
  decrement

**In `lpfc_dev_loss_tmo_handler()`:**
- Uses `test_and_set_bit(NLP_DROPPED, ...)` to atomically check and set,
  preventing races

**In `lpfc_check_nlp_post_devloss()`:**
- Clears `NLP_DROPPED` when restoring the ndlp reference

### 3. Scope and Risk Assessment

- **Files changed:** 2 files in lpfc driver only
- **Lines changed:** ~50 lines of code
- **Scope:** Limited to lpfc FLOGI handling and devloss timeout paths
- **Risk:** MEDIUM - Reference counting changes require care, but these
  use proper atomic operations (`test_and_set_bit`,
  `test_and_clear_bit`)

### 4. Stable Criteria Evaluation

**Meets stable criteria:**
- ✅ Fixes a real bug (reference count corruption causing potential use-
  after-free)
- ✅ Small and contained to specific driver (lpfc)
- ✅ No new features added
- ✅ Clear mechanism: adds proper NLP_DROPPED flag tracking to prevent
  refcount imbalance
- ✅ Affects real-world scenarios: unstable FC links occur in enterprise
  environments

**Concerns:**
- ❌ No "Fixes:" tag indicating when bug was introduced
- ❌ No "Cc: stable@vger.kernel.org" tag
- The `NLP_DROPPED` flag usage appears to exist in older kernels already

### 5. User Impact

- **Who is affected:** Users with Broadcom lpfc Fibre Channel HBAs in
  enterprise storage environments
- **Severity:** HIGH - Reference count bugs can cause kernel crashes,
  data corruption, or security vulnerabilities
- **Likelihood:** MODERATE - Requires unstable FC link conditions, but
  these occur in real deployments

### 6. Backport Feasibility

The changes use standard kernel primitives (`test_and_set_bit`,
`test_and_clear_bit`). The `NLP_DROPPED` flag and the functions being
modified (`lpfc_nlp_put`, `lpfc_nlp_get`, `lpfc_check_nlp_post_devloss`)
appear to exist in stable kernels. The patch should apply cleanly or
with minor adjustments.

## Conclusion

This is a legitimate bug fix for a reference counting issue that can
cause serious problems (use-after-free, crashes) in enterprise Fibre
Channel environments. The fix is well-designed with proper atomic
operations and is contained to the lpfc driver. While there's no
explicit stable tag, the nature of the bug (reference counting
corruption in a widely-used enterprise driver) makes it appropriate for
stable backporting.

The fix is small, surgical, and addresses a real stability/potential
security issue. Enterprise users with lpfc HBAs who experience link
instability would benefit from this fix.

**YES**

 drivers/scsi/lpfc/lpfc_els.c     | 36 +++++++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_hbadisc.c |  4 +++-
 2 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b71db7d7d747d..c08237f04bce2 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -934,10 +934,15 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(vport)) {
 		/* One additional decrement on node reference count to
-		 * trigger the release of the node
+		 * trigger the release of the node.  Make sure the ndlp
+		 * is marked NLP_DROPPED.
 		 */
-		if (!(ndlp->fc4_xpt_flags & SCSI_XPT_REGD))
+		if (!test_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag) &&
+		    !test_bit(NLP_DROPPED, &ndlp->nlp_flag) &&
+		    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD)) {
+			set_bit(NLP_DROPPED, &ndlp->nlp_flag);
 			lpfc_nlp_put(ndlp);
+		}
 		goto out;
 	}
 
@@ -995,9 +1000,10 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					IOERR_LOOP_OPEN_FAILURE)))
 			lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
 				      "2858 FLOGI Status:x%x/x%x TMO"
-				      ":x%x Data x%lx x%x\n",
+				      ":x%x Data x%lx x%x x%lx x%x\n",
 				      ulp_status, ulp_word4, tmo,
-				      phba->hba_flag, phba->fcf.fcf_flag);
+				      phba->hba_flag, phba->fcf.fcf_flag,
+				      ndlp->nlp_flag, ndlp->fc4_xpt_flags);
 
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
@@ -1015,14 +1021,17 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		 * reference to trigger node release.
 		 */
 		if (!test_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag) &&
-		    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD))
+		    !test_bit(NLP_DROPPED, &ndlp->nlp_flag) &&
+		    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD)) {
+			set_bit(NLP_DROPPED, &ndlp->nlp_flag);
 			lpfc_nlp_put(ndlp);
+		}
 
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
 				 "0150 FLOGI Status:x%x/x%x "
-				 "xri x%x TMO:x%x refcnt %d\n",
+				 "xri x%x iotag x%x TMO:x%x refcnt %d\n",
 				 ulp_status, ulp_word4, cmdiocb->sli4_xritag,
-				 tmo, kref_read(&ndlp->kref));
+				 cmdiocb->iotag, tmo, kref_read(&ndlp->kref));
 
 		/* If this is not a loop open failure, bail out */
 		if (!(ulp_status == IOSTAT_LOCAL_REJECT &&
@@ -1279,6 +1288,19 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	uint32_t tmo, did;
 	int rc;
 
+	/* It's possible for lpfc to reissue a FLOGI on an ndlp that is marked
+	 * NLP_DROPPED.  This happens when the FLOGI completed with the XB bit
+	 * set causing lpfc to reference the ndlp until the XRI_ABORTED CQE is
+	 * issued. The time window for the XRI_ABORTED CQE can be as much as
+	 * 2*2*RA_TOV allowing for ndlp reuse of this type when the link is
+	 * cycling quickly.  When true, restore the initial reference and remove
+	 * the NLP_DROPPED flag as lpfc is retrying.
+	 */
+	if (test_and_clear_bit(NLP_DROPPED, &ndlp->nlp_flag)) {
+		if (!lpfc_nlp_get(ndlp))
+			return 1;
+	}
+
 	cmdsize = (sizeof(uint32_t) + sizeof(struct serv_parm));
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_FLOGI);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 43d246c5c049c..717ae56c8e4bd 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -424,6 +424,7 @@ lpfc_check_nlp_post_devloss(struct lpfc_vport *vport,
 			    struct lpfc_nodelist *ndlp)
 {
 	if (test_and_clear_bit(NLP_IN_RECOV_POST_DEV_LOSS, &ndlp->save_flags)) {
+		clear_bit(NLP_DROPPED, &ndlp->nlp_flag);
 		lpfc_nlp_get(ndlp);
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY | LOG_NODE,
 				 "8438 Devloss timeout reversed on DID x%x "
@@ -566,7 +567,8 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 			return fcf_inuse;
 		}
 
-		lpfc_nlp_put(ndlp);
+		if (!test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
+			lpfc_nlp_put(ndlp);
 		return fcf_inuse;
 	}
 
-- 
2.51.0

