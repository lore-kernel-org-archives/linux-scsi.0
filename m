Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E86821767D;
	Wed,  4 Dec 2024 16:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331511; cv=none; b=rdXe4xMS8gZLb/UmtwUEGgAkNMxam8OnkWld1eJ5Tuv3qt5yWjJhCpd3D5nKDKFebwzoEH18ZOb67blmSAghbK5yfKKynqRNxVkUsyyQLuuTMJ9l5xFco9vdKYVtIDzdrVD79RhDVmvnJSihxW5F7z8tru65g+rBlskogPCzdqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331511; c=relaxed/simple;
	bh=vj4xuSl0a78ioYTZvBCPNYu++sqzDjCITwySP4nkO9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hztHj12sXsSRP3ckcxomOVC80U/Z+yimeMbXB9+T8r5ytaUYaAFHX2MED2eQo1AsTQD5qBBWLWDl0N9jNq1VrnY9Q9es219xErhawwEFc4gEcwxOUqhDcnbiHyaJDwg21PNuGrzMPE3tyErsIUP4GZRucvM0XO5P/YfPZqcENus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TUEUWiO9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TUEUWiO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF892C4CECD;
	Wed,  4 Dec 2024 16:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331510;
	bh=vj4xuSl0a78ioYTZvBCPNYu++sqzDjCITwySP4nkO9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUEUWiO95PH/lHJqA4QfPvIS9cnNjqZx+1vv0gBXxmJdk93j0VD0eDdgWlsGOVKQn
	 eA3ZOC8cTNwIBFu5n5RqpMPMKh8jWEo0J/rdbg0jt1MLk5H4G82hptCA/LkjgY13/p
	 Fe1rhrNR917nXc0jiDDqPG3gGHbSGmW7oXVtvdN/UoJZ4ml/Zmm7llIiE06+343dRQ
	 0anBwAvFeRH1aQDV6JrspbHfr+xUevsxWFTwMzJYUUZxgfmjKf2UVCfWLJxC9yRew3
	 MQuLxQr9YQvASZVPPfYgaHcmofs8nwVGX4YHuejyoozHvObWXpZAvJWUs4rB334T3N
	 c0giBqaL5Cd6w==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 19/36] scsi: lpfc: Prevent NDLP reference count underflow in dev_loss_tmo callback
Date: Wed,  4 Dec 2024 10:45:35 -0500
Message-ID: <20241204154626.2211476-19-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204154626.2211476-1-sashal@kernel.org>
References: <20241204154626.2211476-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.1
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 4281f44ea8bfedd25938a0031bebba1473ece9ad ]

Current dev_loss_tmo handling checks whether there has been a previous
call to unregister with SCSI transport.  If so, the NDLP kref count is
decremented a second time in dev_loss_tmo as the final kref release.
However, this can sometimes result in a reference count underflow if
there is also a race to unregister with NVMe transport as well.  Add a
check for NVMe transport registration before decrementing the final
kref.  If NVMe transport is still registered, then the NVMe transport
unregistration is designated as the final kref decrement.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20241031223219.152342-8-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 36 +++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 9241075f72fa4..6e8d8a96c54fb 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -155,6 +155,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	struct lpfc_hba   *phba;
 	struct lpfc_work_evt *evtp;
 	unsigned long iflags;
+	bool nvme_reg = false;
 
 	ndlp = ((struct lpfc_rport_data *)rport->dd_data)->pnode;
 	if (!ndlp)
@@ -177,38 +178,49 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	/* Don't schedule a worker thread event if the vport is going down. */
 	if (test_bit(FC_UNLOADING, &vport->load_flag) ||
 	    !test_bit(HBA_SETUP, &phba->hba_flag)) {
+
 		spin_lock_irqsave(&ndlp->lock, iflags);
 		ndlp->rport = NULL;
 
+		if (ndlp->fc4_xpt_flags & NVME_XPT_REGD)
+			nvme_reg = true;
+
 		/* The scsi_transport is done with the rport so lpfc cannot
-		 * call to unregister. Remove the scsi transport reference
-		 * and clean up the SCSI transport node details.
+		 * call to unregister.
 		 */
-		if (ndlp->fc4_xpt_flags & (NLP_XPT_REGD | SCSI_XPT_REGD)) {
+		if (ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
 			ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
 
-			/* NVME transport-registered rports need the
-			 * NLP_XPT_REGD flag to complete an unregister.
+			/* If NLP_XPT_REGD was cleared in lpfc_nlp_unreg_node,
+			 * unregister calls were made to the scsi and nvme
+			 * transports and refcnt was already decremented. Clear
+			 * the NLP_XPT_REGD flag only if the NVME Rport is
+			 * confirmed unregistered.
 			 */
-			if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
+			if (!nvme_reg && ndlp->fc4_xpt_flags & NLP_XPT_REGD) {
 				ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
+				spin_unlock_irqrestore(&ndlp->lock, iflags);
+				lpfc_nlp_put(ndlp); /* may free ndlp */
+			} else {
+				spin_unlock_irqrestore(&ndlp->lock, iflags);
+			}
+		} else {
 			spin_unlock_irqrestore(&ndlp->lock, iflags);
-			lpfc_nlp_put(ndlp);
-			spin_lock_irqsave(&ndlp->lock, iflags);
 		}
 
+		spin_lock_irqsave(&ndlp->lock, iflags);
+
 		/* Only 1 thread can drop the initial node reference.  If
 		 * another thread has set NLP_DROPPED, this thread is done.
 		 */
-		if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD) &&
-		    !(ndlp->nlp_flag & NLP_DROPPED)) {
-			ndlp->nlp_flag |= NLP_DROPPED;
+		if (nvme_reg || (ndlp->nlp_flag & NLP_DROPPED)) {
 			spin_unlock_irqrestore(&ndlp->lock, iflags);
-			lpfc_nlp_put(ndlp);
 			return;
 		}
 
+		ndlp->nlp_flag |= NLP_DROPPED;
 		spin_unlock_irqrestore(&ndlp->lock, iflags);
+		lpfc_nlp_put(ndlp);
 		return;
 	}
 
-- 
2.43.0

