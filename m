Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3CF270ED2
	for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2025 16:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762790860; cv=none; b=Daltzt3zi+BWtnAnmgtF4+rQHSCHMRh8topFHyiLQRtZyJDgFpqP416tugDWENHGT0roHQInSrhbdHaASBZig6t1oi04b63wkxbJFebfJsG2jaLQm8oOkqKrUl66Kp3DMX7XTekeUZroLKPzgfeZ92obbDk/S2cVHNbjPPJcvdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762790860; c=relaxed/simple;
	bh=lXO9DupS+4T46HArb030FjuM8yTb39HpUvWvwihutRA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=B2G6QlasPbYi17jSR5Bxvh1cBmeLuMdqleoiWI0l2tS9kNwZ6/++NvUhknFuLGeljwXJqO9KtwQ02W7IO25ljxMpWsUWdIq9QPrz5yPCmBtodFy9hJf96cMgXPf1fEgWJyyBUbz31Pihn4rD9DwUhgh5lN5mv1WUD3+Kc7NaQZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=P1xGl5XN; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="P1xGl5XN"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id 6FQUcIu7d07VVBPc; Mon, 10 Nov 2025 11:07:37 -0500 (EST)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=7J0+/76MVsWm73gx/FbY9QMdNv2poNYNZtlcfogECYo=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=P1xGl5XNELvwEktOiegp
	mt9iI3Td9/pa+TUxiqzTyGhfl48gaKEtb14LOtOapLtteVTSAmMTZlcW6flKRUq2GV1HNkN0GkrNp
	QZtpUQgBkzqLYo2byZXC1+Mnm8Bb/FcWkZDzbkNibS/06FqbEARB8iUsD2UF1pLChtf9HuK7xw=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14272504; Mon, 10 Nov 2025 11:07:37 -0500
Message-ID: <0e7e5d26-e7a0-42d1-8235-40eeb27f3e98@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 10 Nov 2025 11:07:37 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v3 08/16] scsi: qla2xxx: clear cmds after chip reset
Content-Language: en-US
X-ASG-Orig-Subj: [PATCH v3 08/16] scsi: qla2xxx: clear cmds after chip reset
From: Tony Battersby <tonyb@cybernetics.com>
To: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Dmitry Bogdanov <d.bogdanov@yadro.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>
References: <aaea0ab0-da8b-4153-9369-60db7507ff7a@cybernetics.com>
In-Reply-To: <aaea0ab0-da8b-4153-9369-60db7507ff7a@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1762790857
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 0
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 3932
X-ASG-Debug-ID: 1762790857-1cf439139110d0f0001-ziuLRu

Commit aefed3e5548f ("scsi: qla2xxx: target: Fix offline port handling
and host reset handling") caused two problems:

1. Commands sent to FW, after chip reset got stuck and never freed as FW
   is not going to respond to them anymore.

2. BUG_ON(cmd->sg_mapped) in qlt_free_cmd().  Commit 26f9ce53817a
   ("scsi: qla2xxx: Fix missed DMA unmap for aborted commands")
   attempted to fix this, but introduced another bug under different
   circumstances when two different CPUs were racing to call
   qlt_unmap_sg() at the same time: BUG_ON(!valid_dma_direction(dir)) in
   dma_unmap_sg_attrs().

So revert "scsi: qla2xxx: Fix missed DMA unmap for aborted commands" and
partially revert "scsi: qla2xxx: target: Fix offline port handling and
host reset handling" at __qla2x00_abort_all_cmds.

Fixes: aefed3e5548f ("scsi: qla2xxx: target: Fix offline port handling and host reset handling")
Fixes: 26f9ce53817a ("scsi: qla2xxx: Fix missed DMA unmap for aborted commands")
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---

v2 -> v3: no changes

v1 -> v2: This patch is a new addition in v2.

 drivers/scsi/qla2xxx/qla_os.c     | 20 ++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_target.c |  5 +----
 drivers/scsi/qla2xxx/qla_target.h |  1 +
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f0b77f13628d..739137ddfd68 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1875,10 +1875,26 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 					continue;
 				}
 				cmd = (struct qla_tgt_cmd *)sp;
-				cmd->aborted = 1;
+
+				if (cmd->sg_mapped)
+					qlt_unmap_sg(vha, cmd);
+
+				if (cmd->state == QLA_TGT_STATE_NEED_DATA) {
+					cmd->aborted = 1;
+					cmd->write_data_transferred = 0;
+					cmd->state = QLA_TGT_STATE_DATA_IN;
+					ha->tgt.tgt_ops->handle_data(cmd);
+				} else {
+					ha->tgt.tgt_ops->free_cmd(cmd);
+				}
 				break;
 			case TYPE_TGT_TMCMD:
-				/* Skip task management functions. */
+				/*
+				 * Currently, only ABTS response gets on the
+				 * outstanding_cmds[]
+				 */
+				ha->tgt.tgt_ops->free_mcmd(
+					(struct qla_tgt_mgmt_cmd *) sp);
 				break;
 			default:
 				break;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b700bfc642b3..2abdb8ce0302 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2447,7 +2447,7 @@ static int qlt_pci_map_calc_cnt(struct qla_tgt_prm *prm)
 	return -1;
 }
 
-static void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
+void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
 {
 	struct qla_hw_data *ha;
 	struct qla_qpair *qpair;
@@ -3795,9 +3795,6 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 
 	spin_lock_irqsave(&cmd->cmd_lock, flags);
 	if (cmd->aborted) {
-		if (cmd->sg_mapped)
-			qlt_unmap_sg(vha, cmd);
-
 		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 		/*
 		 * It's normal to see 2 calls in this path:
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 15a59c125c53..c483966d0a84 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -1058,6 +1058,7 @@ extern int qlt_abort_cmd(struct qla_tgt_cmd *);
 extern void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *);
 extern void qlt_free_mcmd(struct qla_tgt_mgmt_cmd *);
 extern void qlt_free_cmd(struct qla_tgt_cmd *cmd);
+extern void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd);
 extern void qlt_async_event(uint16_t, struct scsi_qla_host *, uint16_t *);
 extern void qlt_enable_vha(struct scsi_qla_host *);
 extern void qlt_vport_create(struct scsi_qla_host *, struct qla_hw_data *);
-- 
2.43.0


