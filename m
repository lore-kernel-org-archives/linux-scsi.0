Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D9CC432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 22:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CF2F20857
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 22:27:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="ksbB5AXO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfKTW1r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 17:27:47 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:51266 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726690AbfKTW1o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 17:27:44 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 1174A43B0D;
        Wed, 20 Nov 2019 22:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1574288860; x=1576103261; bh=jloE1NEzU0EsbDq+VlO3WcdFCA4IyqNf6BD
        qrxCrTgg=; b=ksbB5AXOkU/dzA0Etm+yIu+Awqqry5ZF8vw2vW6GO3H5NhMypQQ
        pE6I6HUheyao9G1uObrmRdGaRJHTMG7O6n2YNobzVF9qqjjkXhdU+FyIij2F3qaK
        aYC+Pw4WUc8q1w7Cnvvd10zRahkEVrytyYhM6+cwVCWzfWvqhZD5A/Vw=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rZ8d_zxLz-RI; Thu, 21 Nov 2019 01:27:40 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 2496943E03;
        Thu, 21 Nov 2019 01:27:38 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 21
 Nov 2019 01:27:37 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
CC:     <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>
Subject: [PATCH v2 13/15] scsi: qla2xxx: Add async mode for qla24xx_els_dcmd_iocb
Date:   Thu, 21 Nov 2019 01:27:21 +0300
Message-ID: <20191120222723.27779-14-r.bolshakov@yadro.com>
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

qla24xx_els_dcmd_iocb() performs LOGO and might be invoked in contexts where it
is prohibited to sleep. The new wait parameter provides a way to use the
function in such context, similarly to qla24xx_els_dcmd2_iocb().

Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_attr.c   |  2 +-
 drivers/scsi/qla2xxx/qla_gbl.h    |  2 +-
 drivers/scsi/qla2xxx/qla_iocb.c   | 11 +++++++++--
 drivers/scsi/qla2xxx/qla_target.c |  2 +-
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 481c05dbea06..35c703ec59ad 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -828,7 +828,7 @@ qla2x00_issue_logo(struct file *filp, struct kobject *kobj,
 
 	ql_log(ql_log_info, vha, 0x70e4, "%s: %d\n", __func__, type);
 
-	qla24xx_els_dcmd_iocb(vha, ELS_DCMD_LOGO, did);
+	qla24xx_els_dcmd_iocb(vha, ELS_DCMD_LOGO, did, true);
 	return count;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 5b163ad85c34..df0f3421e3bb 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -43,7 +43,7 @@ extern void qla2x00_clear_loop_id(fc_port_t *fcport);
 extern int qla2x00_fabric_login(scsi_qla_host_t *, fc_port_t *, uint16_t *);
 extern int qla2x00_local_device_login(scsi_qla_host_t *, fc_port_t *);
 
-extern int qla24xx_els_dcmd_iocb(scsi_qla_host_t *, int, port_id_t);
+extern int qla24xx_els_dcmd_iocb(scsi_qla_host_t *, int, port_id_t, bool);
 extern int qla24xx_els_dcmd2_iocb(scsi_qla_host_t *, int, fc_port_t *, bool);
 extern void qla2x00_els_dcmd2_free(scsi_qla_host_t *vha,
 				   struct els_plogi *els_plogi);
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 53ccbd6b71ed..12b37b711ae8 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2562,7 +2562,7 @@ static void qla2x00_els_dcmd_sp_done(srb_t *sp, int res)
 
 int
 qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
-    port_id_t remote_did)
+    port_id_t remote_did, bool wait)
 {
 	srb_t *sp;
 	fc_port_t *fcport = NULL;
@@ -2601,6 +2601,8 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	elsio->timeout = qla2x00_els_dcmd_iocb_timeout;
 	qla2x00_init_timer(sp, ELS_DCMD_TIMEOUT);
 	init_completion(&sp->u.iocb_cmd.u.els_logo.comp);
+	if (wait)
+		sp->flags = SRB_WAKEUP_ON_COMP;
 	sp->done = qla2x00_els_dcmd_sp_done;
 	sp->free = qla2x00_els_dcmd_sp_free;
 
@@ -2637,9 +2639,14 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	    sp->name, sp->handle, fcport->loop_id, fcport->d_id.b.domain,
 	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
 
-	wait_for_completion(&elsio->u.els_logo.comp);
+	if (wait) {
+		wait_for_completion(&elsio->u.els_logo.comp);
+	} else {
+		goto done;
+	}
 
 	sp->free(sp);
+done:
 	return rval;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 68c14143e50e..0f2bc4cd562f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -932,7 +932,7 @@ qlt_send_first_logo(struct scsi_qla_host *vha, qlt_port_logo_t *logo)
 
 	mutex_unlock(&vha->vha_tgt.tgt_mutex);
 
-	res = qla24xx_els_dcmd_iocb(vha, ELS_DCMD_LOGO, logo->id);
+	res = qla24xx_els_dcmd_iocb(vha, ELS_DCMD_LOGO, logo->id, true);
 
 	mutex_lock(&vha->vha_tgt.tgt_mutex);
 	list_del(&logo->list);
-- 
2.24.0

