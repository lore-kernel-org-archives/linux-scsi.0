Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7374C627
	for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2024 16:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709052127; cv=none; b=PNM0kOC2eqwOCjN3YJ14VqGy1EwlGfXlY58wPKWsOfxzMEwVlNQaZqCzl1re9n9zvyTmSP9zaZVrTt1FOU00PxcBAG/TrpBC83tVWrbpfb8cMk1PIZYqLEKvU8HyHu18DH41/aqL4HgLo1pWNkK4uiPk1PgITQGpaRvElMWfL8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709052127; c=relaxed/simple;
	bh=Du57OgPxUoFd3QpBkeTIdM4JSKvEcto8spRfm04YJ/U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M2z/u974CcDMA8ZCX+4ah/dCWalidmi17vzeu2iSR6yGlyfV2ra0E1WGCmBpzxnsADIpLdiMzhuyGVVJlSojn7KYiJ9e/jtz/bRLDPt2dzBrma4wWHk9RP/aXYgU4NGKYDSYQtNlIqe/7rnoaLihWf/DlcfIsg3aE1hUDck/OKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Rze1tGp5; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Rze1tGp5"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41RFgm8T005633;
	Tue, 27 Feb 2024 08:41:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=tIvzhocMPjp16fac54TIcBdPxVlU11jO17/8+MoVFoE=; b=Rze
	1tGp5oWHUkQ+HP6zUgIvCx6A1jBLsudbdV0GBfeVQzh76DeVkPpYgyiN3XjJ9M9L
	m+PrM39SfCd3IAFjP+d2IoROvWs0KhpC1q0mamfi11kg4WXlQKsY4g4lrK6Kut8m
	FuSCbEtzKKN/kR7rceJWvUvPJPUbItEDsv8NSU25JrW7TmP0iHN/zb0yEhsKPwU4
	2zq11+Mupldx+vXWmEdNy5135Y6VKcarFSR2+ml4+d1JMPHALTEuneyF/0UOCLEs
	AYdQs1nHOKgFt1+e/DH6zTtejB2woXUXzKQeHtroWhPADSfft3aM+xZD7MY1Os9/
	taFYZp+SyWlQWC8dKxw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3whjm689h9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Feb 2024 08:41:57 -0800 (PST)
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Tue, 27 Feb
 2024 08:41:56 -0800
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Tue, 27 Feb 2024 08:41:55 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1258.12 via Frontend
 Transport; Tue, 27 Feb 2024 08:41:55 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 34B6C3F70A9;
	Tue, 27 Feb 2024 08:41:52 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 06/11] qla2xxx: Fix command flush on cable pull
Date: Tue, 27 Feb 2024 22:11:22 +0530
Message-ID: <20240227164127.36465-7-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240227164127.36465-1-njavali@marvell.com>
References: <20240227164127.36465-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: neInFvZQ1ePSYSK9owZtNQwN09OGsiEa
X-Proofpoint-GUID: neInFvZQ1ePSYSK9owZtNQwN09OGsiEa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-27_03,2024-02-27_01,2023-05-22_02

From: Quinn Tran <qutran@marvell.com>

System crash due to command failed to flush back
to scsi layer.

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
 PGD 0 P4D 0
 Oops: 0000 [#1] SMP NOPTI
 CPU: 27 PID: 793455 Comm: kworker/u130:6 Kdump: loaded Tainted: G           OE    --------- -  - 4.18.0-372.9.1.el8.x86_64 #1
 Hardware name: HPE ProLiant DL360 Gen10/ProLiant DL360 Gen10, BIOS U32 09/03/2021
 Workqueue: nvme-wq nvme_fc_connect_ctrl_work [nvme_fc]
 RIP: 0010:__wake_up_common+0x4c/0x190
 Code: 24 10 4d 85 c9 74 0a 41 f6 01 04 0f 85 9d 00 00 00 48 8b 43 08 48 83 c3 08 4c 8d 48 e8 49 8d 41 18 48 39 c3 0f 84 f0 00 00 00 <49> 8b 41 18 89 54 24 08 31 ed 4c 8d 70 e8 45 8b 29 41 f6 c5 04 75
 RSP: 0018:ffff95f3e0cb7cd0 EFLAGS: 00010086
 RAX: 0000000000000000 RBX: ffff8b08d3b26328 RCX: 0000000000000000
 RDX: 0000000000000001 RSI: 0000000000000003 RDI: ffff8b08d3b26320
 RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffffffffffe8
 R10: 0000000000000000 R11: ffff95f3e0cb7a60 R12: ffff95f3e0cb7d20
 R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffff8b2fdf6c0000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000000 CR3: 0000002f1e410002 CR4: 00000000007706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  __wake_up_common_lock+0x7c/0xc0
  qla_nvme_ls_req+0x355/0x4c0 [qla2xxx]
 qla2xxx [0000:12:00.1]-f084:3: qlt_free_session_done: se_sess 0000000000000000 / sess ffff8ae1407ca000 from port 21:32:00:02:ac:07:ee:b8 loop_id 0x02 s_id 01:02:00 logout 1 keep 0 els_logo 0
 ? __nvme_fc_send_ls_req+0x260/0x380 [nvme_fc]
 qla2xxx [0000:12:00.1]-207d:3: FCPort 21:32:00:02:ac:07:ee:b8 state transitioned from ONLINE to LOST - portid=010200.
  ? nvme_fc_send_ls_req.constprop.42+0x1a/0x45 [nvme_fc]
 qla2xxx [0000:12:00.1]-2109:3: qla2x00_schedule_rport_del 21320002ac07eeb8. rport ffff8ae598122000 roles 1
 ? nvme_fc_connect_ctrl_work.cold.63+0x1e3/0xa7d [nvme_fc]
 qla2xxx [0000:12:00.1]-f084:3: qlt_free_session_done: se_sess 0000000000000000 / sess ffff8ae14801e000 from port 21:32:01:02:ad:f7:ee:b8 loop_id 0x04 s_id 01:02:01 logout 1 keep 0 els_logo 0
  ? __switch_to+0x10c/0x450
 ? process_one_work+0x1a7/0x360
 qla2xxx [0000:12:00.1]-207d:3: FCPort 21:32:01:02:ad:f7:ee:b8 state transitioned from ONLINE to LOST - portid=010201.
  ? worker_thread+0x1ce/0x390
  ? create_worker+0x1a0/0x1a0
 qla2xxx [0000:12:00.1]-2109:3: qla2x00_schedule_rport_del 21320102adf7eeb8. rport ffff8ae3b2312800 roles 70
  ? kthread+0x10a/0x120
 qla2xxx [0000:12:00.1]-2112:3: qla_nvme_unregister_remote_port: unregister remoteport on ffff8ae14801e000 21320102adf7eeb8
  ? set_kthread_struct+0x40/0x40
 qla2xxx [0000:12:00.1]-2110:3: remoteport_delete of ffff8ae14801e000 21320102adf7eeb8 completed.
  ? ret_from_fork+0x1f/0x40
 qla2xxx [0000:12:00.1]-f086:3: qlt_free_session_done: waiting for sess ffff8ae14801e000 logout

The system was under memory stress where driver was not
able to allocate a srb to carry out error recovery of cable pull.
The failure to flush cause upper layer to start modifying scsi_cmnd.
When the system free up some memory, the subsequent cable
pull trigger another command flush. At this point the
driver access a null pointer when attempting to dma unmap
the SGL.

Add a check to make sure commands are flush back on session tear
down to prevent the null pointer access.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 2ef2dbac0db2..d7551b1443e4 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1062,6 +1062,16 @@ void qlt_free_session_done(struct work_struct *work)
 		    "%s: sess %p logout completed\n", __func__, sess);
 	}
 
+	/* check for any straggling io left behind */
+	if (!(sess->flags & FCF_FCP2_DEVICE) &&
+	    qla2x00_eh_wait_for_pending_commands(sess->vha, sess->d_id.b24, 0, WAIT_TARGET)) {
+		ql_log(ql_log_warn, vha, 0x3027,
+		    "IO not return. Resetting.\n");
+		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		qla2xxx_wake_dpc(vha);
+		qla2x00_wait_for_chip_reset(vha);
+	}
+
 	if (sess->logo_ack_needed) {
 		sess->logo_ack_needed = 0;
 		qla24xx_async_notify_ack(vha, sess,
-- 
2.23.1

