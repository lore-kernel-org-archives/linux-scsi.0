Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF648C3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:41:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DC8E233A2
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:41:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389214AbfHVNln (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 09:41:43 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:48588 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732117AbfHVNln (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Aug 2019 09:41:43 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CA30E8EEDB6AE337A521;
        Thu, 22 Aug 2019 21:41:39 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 21:41:31 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <QLogic-Storage-Upstream@qlogic.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH 3/3] scsi: qla4xxx: remove set but not used variables 'sess','dst_addr','db_base','db_len','ha'
Date:   Thu, 22 Aug 2019 21:48:01 +0800
Message-ID: <1566481681-92765-4-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566481681-92765-1-git-send-email-zhengbin13@huawei.com>
References: <1566481681-92765-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/qla4xxx/ql4_os.c: In function qla4xxx_eh_cmd_timed_out:
drivers/scsi/qla4xxx/ql4_os.c:1848:24: warning: variable sess set but not used [-Wunused-but-set-variable]
drivers/scsi/qla4xxx/ql4_os.c: In function qla4xxx_session_create:
drivers/scsi/qla4xxx/ql4_os.c:3062:19: warning: variable dst_addr set but not used [-Wunused-but-set-variable]
drivers/scsi/qla4xxx/ql4_os.c: In function qla4_8xxx_iospace_config:
drivers/scsi/qla4xxx/ql4_os.c:5496:44: warning: variable db_len set but not used [-Wunused-but-set-variable]
drivers/scsi/qla4xxx/ql4_os.c: In function qla4_8xxx_iospace_config:
drivers/scsi/qla4xxx/ql4_os.c:5496:35: warning: variable db_base set but not used [-Wunused-but-set-variable]
drivers/scsi/qla4xxx/ql4_os.c: In function qla4xxx_get_param_ddb:
drivers/scsi/qla4xxx/ql4_os.c:6253:24: warning: variable ha set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 8c674ec..49c87b0 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1845,12 +1845,10 @@ static void qla4xxx_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc)
 {
 	struct iscsi_cls_session *session;
-	struct iscsi_session *sess;
 	unsigned long flags;
 	enum blk_eh_timer_return ret = BLK_EH_DONE;

 	session = starget_to_session(scsi_target(sc->device));
-	sess = session->dd_data;

 	spin_lock_irqsave(&session->lock, flags);
 	if (session->state == ISCSI_SESSION_FAILED)
@@ -3059,7 +3057,6 @@ qla4xxx_session_create(struct iscsi_endpoint *ep,
 	struct ddb_entry *ddb_entry;
 	uint16_t ddb_index;
 	struct iscsi_session *sess;
-	struct sockaddr *dst_addr;
 	int ret;

 	if (!ep) {
@@ -3068,7 +3065,6 @@ qla4xxx_session_create(struct iscsi_endpoint *ep,
 	}

 	qla_ep = ep->dd_data;
-	dst_addr = (struct sockaddr *)&qla_ep->dst_addr;
 	ha = to_qla_host(qla_ep->host);
 	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: host: %ld\n", __func__,
 			  ha->host_no));
@@ -5493,7 +5489,7 @@ static void qla4xxx_free_adapter(struct scsi_qla_host *ha)
 int qla4_8xxx_iospace_config(struct scsi_qla_host *ha)
 {
 	int status = 0;
-	unsigned long mem_base, mem_len, db_base, db_len;
+	unsigned long mem_base, mem_len;
 	struct pci_dev *pdev = ha->pdev;

 	status = pci_request_regions(pdev, DRIVER_NAME);
@@ -5537,9 +5533,6 @@ int qla4_8xxx_iospace_config(struct scsi_qla_host *ha)
 				    ((uint8_t *)ha->nx_pcibase);
 	}

-	db_base = pci_resource_start(pdev, 4);  /* doorbell is on bar 4 */
-	db_len = pci_resource_len(pdev, 4);
-
 	return 0;
 iospace_error_exit:
 	return -ENOMEM;
@@ -6250,14 +6243,12 @@ static int qla4xxx_setup_boot_info(struct scsi_qla_host *ha)
 static void qla4xxx_get_param_ddb(struct ddb_entry *ddb_entry,
 				  struct ql4_tuple_ddb *tddb)
 {
-	struct scsi_qla_host *ha;
 	struct iscsi_cls_session *cls_sess;
 	struct iscsi_cls_conn *cls_conn;
 	struct iscsi_session *sess;
 	struct iscsi_conn *conn;

 	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
-	ha = ddb_entry->ha;
 	cls_sess = ddb_entry->sess;
 	sess = cls_sess->dd_data;
 	cls_conn = ddb_entry->conn;
--
2.7.4

