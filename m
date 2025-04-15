Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B5283CC7;
	Tue, 15 Apr 2025 00:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744676935; cv=none; b=IZKhaI4Jvhf3jaGlf2q2soSx24iSRtTNbLHVG2trwg9Jb2I3WLKcs8uJy04rJBjuyVEAmVcOPFOytZ1XspoPbZpEVqqB2buYT5XBXGhPhVbzl4dMxhYokRZ3Ta/k8PjBTgB+/KjoG2TwQk9ipc4hnzuB+rufkNtI3D+6yuUcGRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744676935; c=relaxed/simple;
	bh=Uttts7JdIDrS240v6la2tV+Xo9cNQsrjszR7r06AUcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDDEFQUFT0hrFx+VqQ5y7o+SskVSP2t0sqtCBiVVSvOH+YjMPyhmbBSefuDqAO6Wu6caotgf1UkJclpK2BYJuSXA1Hs9noz0LGBqH9/QXMsvmSxLTDWMAYxsnLBy03tYzzJh3sOCpeclV/8NwC4LXokFPs1KGygWauidjeIHZBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=MLlRtVRl; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="MLlRtVRl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=PJJjmrX1+5lAxe602v8oNDShkEnAk+8W379Gwb8stBI=; b=MLlRtVRlFHDggqcX
	YmnLzvN/jpEnkHqVH1qtlrlyXPHT3CXuJRvJDM8kZzlnahA/7FlVFjOuw+UB4tG6Jk/uqpMJzNoR0
	eQHsz0BSXve6Tz01TFZ4wnJDsNh0YoaHNxcAxqTa6xJlOfRKz7pvpFO6ZhFmrYOI4u6RZHczrDFev
	HV1QOGm0Qv/KO0L6io0ssU8Bhb6fGeXuPAgbOUtELJVgQuJ38Nrm1gtHuCvpyHMyaR77pC79amJPH
	PruqSrgwtVWVgwjKEGk/yq8RkG9kR3a3G7bLAO0cR2+5bBdrUrBol6G5KBlq2eJnayPTyJ++YusyL
	dNiAY32opTPAMPVHuw==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1u4U9l-00BSPG-0p;
	Tue, 15 Apr 2025 00:28:05 +0000
From: linux@treblig.org
To: njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 1/8] scsi: qla2xxx: Remove unused qlt_free_qfull_cmds
Date: Tue, 15 Apr 2025 01:27:56 +0100
Message-ID: <20250415002803.135909-2-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250415002803.135909-1-linux@treblig.org>
References: <20250415002803.135909-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

qlt_free_qfull_cmds() was added in 2014 as part of
commit 33e799775593 ("qla2xxx: Add support for QFull throttling and Term
Exchange retry")
but has remained unused.

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 75 -------------------------------
 drivers/scsi/qla2xxx/qla_target.h |  1 -
 2 files changed, 76 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 11eadb3bd36e..8a892ac95417 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5539,81 +5539,6 @@ qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 	spin_unlock_irqrestore(&vha->hw->tgt.q_full_lock, flags);
 }
 
-int
-qlt_free_qfull_cmds(struct qla_qpair *qpair)
-{
-	struct scsi_qla_host *vha = qpair->vha;
-	struct qla_hw_data *ha = vha->hw;
-	unsigned long flags;
-	struct qla_tgt_cmd *cmd, *tcmd;
-	struct list_head free_list, q_full_list;
-	int rc = 0;
-
-	if (list_empty(&ha->tgt.q_full_list))
-		return 0;
-
-	INIT_LIST_HEAD(&free_list);
-	INIT_LIST_HEAD(&q_full_list);
-
-	spin_lock_irqsave(&vha->hw->tgt.q_full_lock, flags);
-	if (list_empty(&ha->tgt.q_full_list)) {
-		spin_unlock_irqrestore(&vha->hw->tgt.q_full_lock, flags);
-		return 0;
-	}
-
-	list_splice_init(&vha->hw->tgt.q_full_list, &q_full_list);
-	spin_unlock_irqrestore(&vha->hw->tgt.q_full_lock, flags);
-
-	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
-	list_for_each_entry_safe(cmd, tcmd, &q_full_list, cmd_list) {
-		if (cmd->q_full)
-			/* cmd->state is a borrowed field to hold status */
-			rc = __qlt_send_busy(qpair, &cmd->atio, cmd->state);
-		else if (cmd->term_exchg)
-			rc = __qlt_send_term_exchange(qpair, NULL, &cmd->atio);
-
-		if (rc == -ENOMEM)
-			break;
-
-		if (cmd->q_full)
-			ql_dbg(ql_dbg_io, vha, 0x3006,
-			    "%s: busy sent for ox_id[%04x]\n", __func__,
-			    be16_to_cpu(cmd->atio.u.isp24.fcp_hdr.ox_id));
-		else if (cmd->term_exchg)
-			ql_dbg(ql_dbg_io, vha, 0x3007,
-			    "%s: Term exchg sent for ox_id[%04x]\n", __func__,
-			    be16_to_cpu(cmd->atio.u.isp24.fcp_hdr.ox_id));
-		else
-			ql_dbg(ql_dbg_io, vha, 0x3008,
-			    "%s: Unexpected cmd in QFull list %p\n", __func__,
-			    cmd);
-
-		list_move_tail(&cmd->cmd_list, &free_list);
-
-		/* piggy back on hardware_lock for protection */
-		vha->hw->tgt.num_qfull_cmds_alloc--;
-	}
-	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
-
-	cmd = NULL;
-
-	list_for_each_entry_safe(cmd, tcmd, &free_list, cmd_list) {
-		list_del(&cmd->cmd_list);
-		/* This cmd was never sent to TCM.  There is no need
-		 * to schedule free or call free_cmd
-		 */
-		qlt_free_cmd(cmd);
-	}
-
-	if (!list_empty(&q_full_list)) {
-		spin_lock_irqsave(&vha->hw->tgt.q_full_lock, flags);
-		list_splice(&q_full_list, &vha->hw->tgt.q_full_list);
-		spin_unlock_irqrestore(&vha->hw->tgt.q_full_lock, flags);
-	}
-
-	return rc;
-}
-
 static void
 qlt_send_busy(struct qla_qpair *qpair, struct atio_from_isp *atio,
     uint16_t status)
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 354fca2e7feb..71cf0236ea7d 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -1083,7 +1083,6 @@ extern int qlt_stop_phase1(struct qla_tgt *);
 extern void qlt_stop_phase2(struct qla_tgt *);
 extern irqreturn_t qla83xx_msix_atio_q(int, void *);
 extern void qlt_83xx_iospace_config(struct qla_hw_data *);
-extern int qlt_free_qfull_cmds(struct qla_qpair *);
 extern void qlt_logo_completion_handler(fc_port_t *, int);
 extern void qlt_do_generation_tick(struct scsi_qla_host *, int *);
 
-- 
2.49.0

