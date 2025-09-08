Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E049023817D
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 19:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757358875; cv=none; b=bcaek3vfQJOivqnu+O+VnyETAfJ1vL+qk+OjDdw1MNiUvHSKwSAsIVC0RTjZIf1TiDIWPtuzjcA7CF2om0GX9H+AoQHYEDqcRZJllZPS3sArFD2uylBS008ofAfkCEZwWToqdbo7AtJAM3XdMoWMWYOKVsEwA+d1YU2rc5xyx9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757358875; c=relaxed/simple;
	bh=m9Tmo1alBNSq12nOWoyg4oli2lSpZELuM72iGV8P75o=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=o/7ajADI9mv8MIJ2zj+ArrKr8bt3UJy2roSicLdKlXGOhFLb6zjFfjD4m9GFAXAt6JAIlLbRBYf/iRF/0dME/IAvun5tLU+ub6LcLU04WLfeR9T3e0/lBWsWPvR3Br10eeYg1SBsvW6rf1Vgr0Oc/NNa0LJYl+V5w6WEMvhCukc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=YBaX1QVL; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="YBaX1QVL"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id 6Sup7jlleNCiPoZE; Mon, 08 Sep 2025 15:14:32 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=o845yKcCavjgQhO4zXmQrIY6so63ORQ6IIblbQOdUtQ=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=YBaX1QVLxN20MCbXptE5
	qoKifjyTmqhTgzkx+ykU/97O5gJWSvUL9mEaZqKWU/r8EDGQ7fKyz7MR/Rebkh3x6CLkJdYDoJLb1
	PZ5dO61lLvCfQJWrCk6XZlfqCVI5WimxgrSPPABoOSoiaZOBoTwugoeyX3xLCqzU0aoZHXGDBo=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14189178; Mon, 08 Sep 2025 15:14:32 -0400
Message-ID: <919c102c-db75-40c3-b571-ffd3b8180d7f@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 8 Sep 2025 15:14:32 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [SCST PATCH] qla2x00t-32gbit: add on_abort_cmd callback
Content-Language: en-US
X-ASG-Orig-Subj: [SCST PATCH] qla2x00t-32gbit: add on_abort_cmd callback
From: Tony Battersby <tonyb@cybernetics.com>
To: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
In-Reply-To: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1757358872
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 0
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 2830
X-ASG-Debug-ID: 1757358872-1cf43947df30c860001-ziuLRu

This enables the initiator to abort commands that are stuck pending in
the HW without waiting for a timeout.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

This patch applies to the out-of-tree SCST project, not to the Linux
kernel.  Apply after all the other qla2xxx patches.

 qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c b/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c
index 9371dad06..76d3685a4 100644
--- a/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c
+++ b/qla2x00t-32gbit/qla2x00-target/scst_qla2xxx.c
@@ -81,6 +81,7 @@ static int sqa_xmit_response(struct scst_cmd *scst_cmd);
 static int sqa_rdy_to_xfer(struct scst_cmd *scst_cmd);
 static void sqa_on_free_cmd(struct scst_cmd *scst_cmd);
 static void sqa_task_mgmt_fn_done(struct scst_mgmt_cmd *mcmd);
+static void sqa_on_abort_cmd(struct scst_cmd *scst_cmd);
 static int sqa_get_initiator_port_transport_id(struct scst_tgt *tgt,
 					       struct scst_session *scst_sess,
 					       uint8_t **transport_id);
@@ -1255,6 +1256,7 @@ static struct scst_tgt_template sqa_scst_template = {
 
 	.on_free_cmd			 = sqa_on_free_cmd,
 	.task_mgmt_fn_done		 = sqa_task_mgmt_fn_done,
+	.on_abort_cmd			 = sqa_on_abort_cmd,
 	.close_session			 = sqa_close_session,
 
 	.get_initiator_port_transport_id = sqa_get_initiator_port_transport_id,
@@ -1982,6 +1984,46 @@ out_unlock:
 	TRACE_EXIT();
 }
 
+struct sqa_abort_work {
+	struct scst_cmd *scst_cmd;
+	struct work_struct abort_work;
+};
+
+static void sqa_on_abort_cmd_work(struct work_struct *work)
+{
+	struct sqa_abort_work *abort_work =
+		container_of(work, struct sqa_abort_work, abort_work);
+	struct scst_cmd *scst_cmd = abort_work->scst_cmd;
+	struct qla_tgt_cmd *cmd = scst_cmd_get_tgt_priv(scst_cmd);
+
+	TRACE_ENTRY();
+
+	kfree(abort_work);
+	qlt_abort_cmd(cmd);
+	scst_cmd_put(scst_cmd);
+
+	TRACE_EXIT();
+}
+
+static void sqa_on_abort_cmd(struct scst_cmd *scst_cmd)
+{
+	struct sqa_abort_work *abort_work;
+
+	/*
+	 * The caller holds sess->sess_list_lock, but qlt_abort_cmd() needs to
+	 * acquire qpair->qp_lock_ptr (ha->hardware_lock); these locks are
+	 * acquired in the reverse order elsewhere.  Use a workqueue to avoid
+	 * acquiring the locks in the wrong order here.
+	 */
+	abort_work = kmalloc(sizeof(*abort_work), GFP_ATOMIC);
+	if (!abort_work)
+		return;
+	scst_cmd_get(scst_cmd);
+	abort_work->scst_cmd = scst_cmd;
+	INIT_WORK(&abort_work->abort_work, sqa_on_abort_cmd_work);
+	schedule_work(&abort_work->abort_work);
+}
+
 /*
  * The following structure defines the callbacks which will be executed
  * from functions in the qla_target.c file back to this interface
-- 
2.43.0


