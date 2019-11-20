Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F009FC43141
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 22:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C842520872
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 22:27:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="LsujtCqt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfKTW1o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 17:27:44 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:51280 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726658AbfKTW1n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 17:27:43 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 28F7642004;
        Wed, 20 Nov 2019 22:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1574288860; x=1576103261; bh=ATTKVf3A7Bd7aCGacapEQlVHTfGwIRao2f/
        c1INGfYY=; b=LsujtCqtBeHnurfnmn9cu3KiPjs3JI9i5sl3ZtJ4yyug4Fz93fa
        pWV85Vj+adt1naSRPsrncW47tXFHD2RGC/ZmwLES97GLDP+8n1EclmntltUU5kIo
        Y2V4AdwRkl4CH9zwl7rXd0ur9BOl9Kd0x8DWpHz+YnryMedx9Z97itWY=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MRuHGdyV6Hz8; Thu, 21 Nov 2019 01:27:40 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id A3C4243597;
        Thu, 21 Nov 2019 01:27:37 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 21
 Nov 2019 01:27:37 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
CC:     <linux@yadro.com>, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 12/15] scsi: qla2xxx: Use explicit LOGO in target mode
Date:   Thu, 21 Nov 2019 01:27:20 +0300
Message-ID: <20191120222723.27779-13-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191120222723.27779-1-r.bolshakov@yadro.com>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Target makes implicit LOGO on session teardown. LOGO ELS is not send on
the wire and initiator is not aware that target no longer wants talking
to it. Initiator keeps sending I/O requests, target responds with
BA_RJT, they time out and then initiator sends ABORT TASK (ABTS-LS).

Current behaviour incurs unneeded I/O timeout and can be fixed by making
explicit LOGO on session deletion.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_def.h     |  1 +
 drivers/scsi/qla2xxx/qla_iocb.c    | 16 ++++++++++++----
 drivers/scsi/qla2xxx/qla_target.c  |  1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  1 +
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 460f443f6471..2edd9f7b3074 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2401,6 +2401,7 @@ typedef struct fc_port {
 	unsigned int id_changed:1;
 	unsigned int scan_needed:1;
 	unsigned int n2n_flag:1;
+	unsigned int explicit_logout:1;
 
 	struct completion nvme_del_done;
 	uint32_t nvme_prli_service_param;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index bd8160fddcd3..53ccbd6b71ed 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2405,11 +2405,19 @@ qla2x00_login_iocb(srb_t *sp, struct mbx_entry *mbx)
 static void
 qla24xx_logout_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 {
+	u16 control_flags = LCF_COMMAND_LOGO;
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
-	logio->control_flags =
-	    cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO);
-	if (!sp->fcport->keep_nport_handle)
-		logio->control_flags |= cpu_to_le16(LCF_FREE_NPORT);
+
+	if (sp->fcport->explicit_logout) {
+		control_flags |= LCF_EXPL_LOGO|LCF_FREE_NPORT;
+	} else {
+		control_flags |= LCF_IMPL_LOGO;
+
+		if (!sp->fcport->keep_nport_handle)
+			control_flags |= LCF_FREE_NPORT;
+	}
+
+	logio->control_flags = cpu_to_le16(control_flags);
 	logio->nport_handle = cpu_to_le16(sp->fcport->loop_id);
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
 	logio->port_id[1] = sp->fcport->d_id.b.area;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 853fa187d827..68c14143e50e 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1104,6 +1104,7 @@ void qlt_free_session_done(struct work_struct *work)
 		}
 	}
 
+	sess->explicit_logout = 0;
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	sess->free_pending = 0;
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index bab2073c1f72..abe7f79bb789 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -350,6 +350,7 @@ static void tcm_qla2xxx_close_session(struct se_session *se_sess)
 	target_sess_cmd_list_set_waiting(se_sess);
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
+	sess->explicit_logout = 1;
 	tcm_qla2xxx_put_sess(sess);
 }
 
-- 
2.24.0

