Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 981A1C4CEC7
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 18:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 654F62084F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 18:09:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="MBTXYNZR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfILSJh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 14:09:37 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10440 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726894AbfILSJg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 14:09:36 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CI5CGw006870;
        Thu, 12 Sep 2019 11:09:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Y+ASFHxAy3qJTqHZce3Cx+P+c870xc6k34X5DbydT5c=;
 b=MBTXYNZREdzcFe8SFm2cRbMMzTHdxxqUr/v2isoaWVkK1JVJyfL3WDs4hAic+zliEjYX
 H1NrANvCSKA9ZVmXb6vb1WrRqcZCYGdDRWCt6qmk+4rW35U7mmCAUvLDNTcwRhNcvATB
 DuOvN8AhTYFTzTQgYSWVuAj17iHl4yfB3X40jOx+Nnl1GOCFvY0r4yjGm0F5QphAi/8i
 kMAX53yA7sWinj3In3dxtSyO1T3P5eTUwBafIjxsEO1v6Lude/on6dCMu0SV9g6SCVKz
 fQFxliS5bsRTTUG+Qmji/NVM7AbJwJ6yt5wGk5EKhnydRyDXvj1caRxB79GnL1pyYgMs Jw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uytdh066f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 11:09:33 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 12 Sep
 2019 11:09:32 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 12 Sep 2019 11:09:31 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id CF7003F703F;
        Thu, 12 Sep 2019 11:09:31 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x8CI9VIG006487;
        Thu, 12 Sep 2019 11:09:31 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x8CI9VNf006486;
        Thu, 12 Sep 2019 11:09:31 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 04/14] qla2xxx: Optimize NPIV tear down process
Date:   Thu, 12 Sep 2019 11:09:08 -0700
Message-ID: <20190912180918.6436-5-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190912180918.6436-1-hmadhani@marvell.com>
References: <20190912180918.6436-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_09:2019-09-11,2019-09-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

In the case of NPIV port is being torn down, this patch will
set a flag to indicate VPORT_DELETE. This would prevent relogin
to be triggered.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c   |  2 ++
 drivers/scsi/qla2xxx/qla_def.h    |  1 +
 drivers/scsi/qla2xxx/qla_gs.c     |  3 ++-
 drivers/scsi/qla2xxx/qla_mid.c    | 32 ++++++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_os.c     |  7 ++++++-
 drivers/scsi/qla2xxx/qla_target.c |  1 +
 6 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index e9c449ef515c..8b3015361428 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2920,6 +2920,8 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t id = vha->vp_idx;
 
+	set_bit(VPORT_DELETE, &vha->dpc_flags);
+
 	while (test_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags) ||
 	    test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags))
 		msleep(1000);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 873a6aef1c5c..fa038568beb6 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4394,6 +4394,7 @@ typedef struct scsi_qla_host {
 #define IOCB_WORK_ACTIVE	31
 #define SET_ZIO_THRESHOLD_NEEDED 32
 #define ISP_ABORT_TO_ROM	33
+#define VPORT_DELETE		34
 
 	unsigned long	pci_flags;
 #define PFLG_DISCONNECTED	0	/* PCI device removed */
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index dc0e36676313..5298ed10059f 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3102,7 +3102,8 @@ int qla24xx_post_gpnid_work(struct scsi_qla_host *vha, port_id_t *id)
 {
 	struct qla_work_evt *e;
 
-	if (test_bit(UNLOADING, &vha->dpc_flags))
+	if (test_bit(UNLOADING, &vha->dpc_flags) ||
+	    (vha->vp_idx && test_bit(VPORT_DELETE, &vha->dpc_flags)))
 		return 0;
 
 	e = qla2x00_alloc_work(vha, QLA_EVT_GPNID);
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 1a9a11ae7285..6afad68e5ba2 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -66,6 +66,7 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 	uint16_t vp_id;
 	struct qla_hw_data *ha = vha->hw;
 	unsigned long flags = 0;
+	u8 i;
 
 	mutex_lock(&ha->vport_lock);
 	/*
@@ -75,8 +76,9 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 	 * ensures no active vp_list traversal while the vport is removed
 	 * from the queue)
 	 */
-	wait_event_timeout(vha->vref_waitq, !atomic_read(&vha->vref_count),
-	    10*HZ);
+	for (i = 0; i < 10 && atomic_read(&vha->vref_count); i++)
+		wait_event_timeout(vha->vref_waitq,
+		    atomic_read(&vha->vref_count), HZ);
 
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	if (atomic_read(&vha->vref_count)) {
@@ -262,6 +264,9 @@ qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	list_for_each_entry(vha, &ha->vp_list, list) {
 		if (vha->vp_idx) {
+			if (test_bit(VPORT_DELETE, &vha->dpc_flags))
+				continue;
+
 			atomic_inc(&vha->vref_count);
 			spin_unlock_irqrestore(&ha->vport_slock, flags);
 
@@ -300,6 +305,20 @@ qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 int
 qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
 {
+	fc_port_t *fcport;
+
+	/*
+	 * To exclusively reset vport, we need to log it out first.
+	 * Note: This control_vp can fail if ISP reset is already
+	 * issued, this is expected, as the vp would be already
+	 * logged out due to ISP reset.
+	 */
+	if (!test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags)) {
+		qla24xx_control_vp(vha, VCE_COMMAND_DISABLE_VPS_LOGO_ALL);
+		list_for_each_entry(fcport, &vha->vp_fcports, list)
+			fcport->logout_on_delete = 0;
+	}
+
 	/*
 	 * Physical port will do most of the abort and recovery work. We can
 	 * just treat it as a loop down
@@ -312,16 +331,9 @@ qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
 			atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 	}
 
-	/*
-	 * To exclusively reset vport, we need to log it out first.  Note: this
-	 * control_vp can fail if ISP reset is already issued, this is
-	 * expected, as the vp would be already logged out due to ISP reset.
-	 */
-	if (!test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
-		qla24xx_control_vp(vha, VCE_COMMAND_DISABLE_VPS_LOGO_ALL);
-
 	ql_dbg(ql_dbg_taskm, vha, 0x801d,
 	    "Scheduling enable of Vport %d.\n", vha->vp_idx);
+
 	return qla24xx_enable_vp(vha);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 42980e52fb41..5eda86ff6606 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1115,9 +1115,14 @@ static inline int test_fcport_count(scsi_qla_host_t *vha)
 void
 qla2x00_wait_for_sess_deletion(scsi_qla_host_t *vha)
 {
+	u8 i;
+
 	qla2x00_mark_all_devices_lost(vha, 0);
 
-	wait_event_timeout(vha->fcport_waitQ, test_fcport_count(vha), 10*HZ);
+	for (i = 0; i < 10; i++)
+		wait_event_timeout(vha->fcport_waitQ, test_fcport_count(vha),
+		    HZ);
+
 	flush_workqueue(vha->hw->wq);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b5315be00b4d..a06e56224a55 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1115,6 +1115,7 @@ void qlt_free_session_done(struct work_struct *work)
 		wake_up_all(&tgt->waitQ);
 
 	if (!test_bit(PFLG_DRIVER_REMOVING, &base_vha->pci_flags) &&
+	    !(vha->vp_idx && test_bit(VPORT_DELETE, &vha->dpc_flags)) &&
 	    (!tgt || !tgt->tgt_stop) && !LOOP_TRANSITION(vha)) {
 		switch (vha->host->active_mode) {
 		case MODE_INITIATOR:
-- 
2.12.0

