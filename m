Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4691DDC15;
	Fri,  4 Oct 2024 18:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066401; cv=none; b=MSHRnsNhHRCNzBJf51AUvbEpXcjFJdfK6bZBEh6BAnCYtBJ2youeREDNqAQpnIt9FeT5vTBVPYmnTYR/X7P2KTjCHMTci0Z/YV+zrXv45/sTQ164xD7PEhAm4L8p0PX95mSvcMWZxml9hh3Mdps6+FfIfBi4H9rEpWJ7/yuJr+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066401; c=relaxed/simple;
	bh=abpQkeMqybEUeWSd7Mi93Hyf525dUxEFXAVtKYDpVII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JW9y8Jk42mrv0ycYp30/Jij40fWLHdLOABj0O/FNtX1znndjOWlfbMsKdbUfP5C/GMBuvvdJxIQFIitaA2NjI5DXGGNHN3Tda5/hbXijvn0ASCV63R6i5UEAvIz22lzZBOWUKhzjVuZSo9BHvwSgpm0dMpRebY5hHfnXjTB/pfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JX7Z+yj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JX7Z+yj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B58C4CECE;
	Fri,  4 Oct 2024 18:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066401;
	bh=abpQkeMqybEUeWSd7Mi93Hyf525dUxEFXAVtKYDpVII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JX7Z+yj3nS58SbYYyT/JzJDc2ecOOFheOroi+/uzBt9pisoEyDYvP8LIuAihLgcMO
	 zIPSHpIltJ+QO9LGd16dsFXZFqmT+vGb93CttA9ZzVcyMuieRir4wY2IK4McW3WkHm
	 8d00nD7sBIeTtp7bASOIIDT4VqYU2pE0ynn2x978xLhEnw5PFIGGihaHdGuttjWNGc
	 lG9si/XLB4MR2pXym+nms6w2LfBwXqHQYhvwDgn8NlY9W1SmVg2TYp617/GC2Jo5Mz
	 vPIl+tNCGKZp3CKp2cAHFP7DjY2BjpTvvBUXBqBxxU9BPAJbgcNnd1FElK5/hWTE/0
	 FJZdedg+/ggJA==
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
Subject: [PATCH AUTOSEL 6.6 54/58] scsi: lpfc: Ensure DA_ID handling completion before deleting an NPIV instance
Date: Fri,  4 Oct 2024 14:24:27 -0400
Message-ID: <20241004182503.3672477-54-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004182503.3672477-1-sashal@kernel.org>
References: <20241004182503.3672477-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.54
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 0a3c84f71680684c1d41abb92db05f95c09111e8 ]

Deleting an NPIV instance requires all fabric ndlps to be released before
an NPIV's resources can be torn down.  Failure to release fabric ndlps
beforehand opens kref imbalance race conditions.  Fix by forcing the DA_ID
to complete synchronously with usage of wait_queue.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240912232447.45607-6-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_ct.c    | 12 ++++++++++
 drivers/scsi/lpfc/lpfc_disc.h  |  7 ++++++
 drivers/scsi/lpfc/lpfc_vport.c | 43 ++++++++++++++++++++++++++++------
 3 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index baae1f8279e0c..1775115239860 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1671,6 +1671,18 @@ lpfc_cmpl_ct(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	}
 
 out:
+	/* If the caller wanted a synchronous DA_ID completion, signal the
+	 * wait obj and clear flag to reset the vport.
+	 */
+	if (ndlp->save_flags & NLP_WAIT_FOR_DA_ID) {
+		if (ndlp->da_id_waitq)
+			wake_up(ndlp->da_id_waitq);
+	}
+
+	spin_lock_irq(&ndlp->lock);
+	ndlp->save_flags &= ~NLP_WAIT_FOR_DA_ID;
+	spin_unlock_irq(&ndlp->lock);
+
 	lpfc_ct_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ndlp);
 	return;
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index f82615d87c4bb..f5ae8cc158205 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -90,6 +90,8 @@ enum lpfc_nlp_save_flags {
 	NLP_IN_RECOV_POST_DEV_LOSS	= 0x1,
 	/* wait for outstanding LOGO to cmpl */
 	NLP_WAIT_FOR_LOGO		= 0x2,
+	/* wait for outstanding DA_ID to finish */
+	NLP_WAIT_FOR_DA_ID              = 0x4
 };
 
 struct lpfc_nodelist {
@@ -159,7 +161,12 @@ struct lpfc_nodelist {
 	uint32_t nvme_fb_size; /* NVME target's supported byte cnt */
 #define NVME_FB_BIT_SHIFT 9    /* PRLI Rsp first burst in 512B units. */
 	uint32_t nlp_defer_did;
+
+	/* These wait objects are NPIV specific.  These IOs must complete
+	 * synchronously.
+	 */
 	wait_queue_head_t *logo_waitq;
+	wait_queue_head_t *da_id_waitq;
 };
 
 struct lpfc_node_rrq {
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 9e0e9e02d2c47..256ee797adb30 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -633,6 +633,7 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
 	int rc;
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
 	if (vport->port_type == LPFC_PHYSICAL_PORT) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
@@ -688,21 +689,49 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 	if (!ndlp)
 		goto skip_logo;
 
+	/* Send the DA_ID and Fabric LOGO to cleanup the NPIV fabric entries. */
 	if (ndlp && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE &&
 	    phba->link_state >= LPFC_LINK_UP &&
 	    phba->fc_topology != LPFC_TOPOLOGY_LOOP) {
 		if (vport->cfg_enable_da_id) {
-			/* Send DA_ID and wait for a completion. */
+			/* Send DA_ID and wait for a completion.  This is best
+			 * effort.  If the DA_ID fails, likely the fabric will
+			 * "leak" NportIDs but at least the driver issued the
+			 * command.
+			 */
+			ndlp = lpfc_findnode_did(vport, NameServer_DID);
+			if (!ndlp)
+				goto issue_logo;
+
+			spin_lock_irq(&ndlp->lock);
+			ndlp->da_id_waitq = &waitq;
+			ndlp->save_flags |= NLP_WAIT_FOR_DA_ID;
+			spin_unlock_irq(&ndlp->lock);
+
 			rc = lpfc_ns_cmd(vport, SLI_CTNS_DA_ID, 0, 0);
-			if (rc) {
-				lpfc_printf_log(vport->phba, KERN_WARNING,
-						LOG_VPORT,
-						"1829 CT command failed to "
-						"delete objects on fabric, "
-						"rc %d\n", rc);
+			if (!rc) {
+				wait_event_timeout(waitq,
+				   !(ndlp->save_flags & NLP_WAIT_FOR_DA_ID),
+				   msecs_to_jiffies(phba->fc_ratov * 2000));
 			}
+
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_VPORT | LOG_ELS,
+					 "1829 DA_ID issue status %d. "
+					 "SFlag x%x NState x%x, NFlag x%x "
+					 "Rpi x%x\n",
+					 rc, ndlp->save_flags, ndlp->nlp_state,
+					 ndlp->nlp_flag, ndlp->nlp_rpi);
+
+			/* Remove the waitq and save_flags.  It no
+			 * longer matters if the wake happened.
+			 */
+			spin_lock_irq(&ndlp->lock);
+			ndlp->da_id_waitq = NULL;
+			ndlp->save_flags &= ~NLP_WAIT_FOR_DA_ID;
+			spin_unlock_irq(&ndlp->lock);
 		}
 
+issue_logo:
 		/*
 		 * If the vpi is not registered, then a valid FDISC doesn't
 		 * exist and there is no need for a ELS LOGO.  Just cleanup
-- 
2.43.0

