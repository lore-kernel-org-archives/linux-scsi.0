Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00146C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Dec 2021 07:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351785AbhLXHIC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:08:02 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52700 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351759AbhLXHHx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Dec 2021 02:07:53 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BO2o6Ad008389
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Qgr5qWxP81OKBMhsqfNoSOHuvWYc+CS34bKj2sUq98s=;
 b=dcFnr6GjpWja1C/bi4Gz4YmjnyAk+9N0z0chSP9E0VkRxEullJaYMRH7yBD0YuQvkn9u
 EITDb3Sgv0kJlMHCphbetxNzLLtu54jM8zWsFMd3cgJ4k5Q7jP5286U/PsfB8VNC7P8s
 qewGwJ8Rs7Q1KNkYlI+x8DOe+Ounh1IjR+IrqYHQoAAAo9d9S4LLpaGyUp/I+oGwjvYH
 f3ZH2VRhsVjdZLbkzCvrOsKQcVqJ6D7fRfvYKPcEKajZflX5N094xBKLau2xEajkL4g1
 kmDie1qeh+e9h5eKCuFrXIHUOk8ItFcR1QutgPGXKGz0n+x+RgYzs1SCnayvZX4vUghK yA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3d4t6kjua3-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:52 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Dec
 2021 23:07:49 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 23 Dec 2021 23:07:49 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3F58C3F7088;
        Thu, 23 Dec 2021 23:07:49 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1BO77nN4017972;
        Thu, 23 Dec 2021 23:07:49 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1BO77n9K017971;
        Thu, 23 Dec 2021 23:07:49 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 06/16] qla2xxx: Fix scheduling while atomic
Date:   Thu, 23 Dec 2021 23:07:02 -0800
Message-ID: <20211224070712.17905-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211224070712.17905-1-njavali@marvell.com>
References: <20211224070712.17905-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: BDnwgxPBn8uO4fdUw8d5LNNbQAYqdsvm
X-Proofpoint-ORIG-GUID: BDnwgxPBn8uO4fdUw8d5LNNbQAYqdsvm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-24_02,2021-12-24_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

QLA makes a call into midlayer (fc_remote_port_delete) which
can put the thread to sleep. The thread that originate the call
is in interrupt context. The combination of the 2 trigger a
crash. This patch schedule the call in non-interrupt context
where it is more safe.

kernel: BUG: scheduling while atomic: swapper/7/0/0x00010000
kernel: Call Trace:
kernel:  <IRQ>
kernel:  dump_stack+0x66/0x81
kernel:  __schedule_bug.cold.90+0x5/0x1d
kernel:  __schedule+0x7af/0x960
kernel:  schedule+0x28/0x80
kernel:  schedule_timeout+0x26d/0x3b0
kernel:  wait_for_completion+0xb4/0x140
kernel:  ? wake_up_q+0x70/0x70
kernel:  __wait_rcu_gp+0x12c/0x160
kernel:  ? sdev_evt_alloc+0xc0/0x180 [scsi_mod]
kernel:  synchronize_sched+0x6c/0x80
kernel:  ? call_rcu_bh+0x20/0x20
kernel:  ? __bpf_trace_rcu_invoke_callback+0x10/0x10
kernel:  sdev_evt_alloc+0xfd/0x180 [scsi_mod]
kernel:  starget_for_each_device+0x85/0xb0 [scsi_mod]
kernel:  ? scsi_init_io+0x360/0x3d0 [scsi_mod]
kernel:  scsi_init_io+0x388/0x3d0 [scsi_mod]
kernel:  device_for_each_child+0x54/0x90
kernel:  fc_remote_port_delete+0x70/0xe0 [scsi_transport_fc]
kernel:  qla2x00_schedule_rport_del+0x62/0xf0 [qla2xxx]
kernel:  qla2x00_mark_device_lost+0x9c/0xd0 [qla2xxx]
kernel:  qla24xx_handle_plogi_done_event+0x55f/0x570 [qla2xxx]
kernel:  qla2x00_async_login_sp_done+0xd2/0x100 [qla2xxx]
kernel:  qla24xx_logio_entry+0x13a/0x3c0 [qla2xxx]
kernel:  qla24xx_process_response_queue+0x306/0x400 [qla2xxx]
kernel:  qla24xx_msix_rsp_q+0x3f/0xb0 [qla2xxx]
kernel:  __handle_irq_event_percpu+0x40/0x180
kernel:  handle_irq_event_percpu+0x30/0x80
kernel:  handle_irq_event+0x36/0x60

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e54c31296fab..ac25d2bfa90b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2231,12 +2231,7 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 		ql_dbg(ql_dbg_disc, vha, 0x20eb, "%s %d %8phC cmd error %x\n",
 		    __func__, __LINE__, ea->fcport->port_name, ea->data[1]);
 
-		ea->fcport->flags &= ~FCF_ASYNC_SENT;
-		qla2x00_set_fcport_disc_state(ea->fcport, DSC_LOGIN_FAILED);
-		if (ea->data[1] & QLA_LOGIO_LOGIN_RETRIED)
-			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
-		else
-			qla2x00_mark_device_lost(vha, ea->fcport, 1);
+		qlt_schedule_sess_for_deletion(ea->fcport);
 		break;
 	case MBS_LOOP_ID_USED:
 		/* data[1] = IO PARAM 1 = nport ID  */
-- 
2.23.1

