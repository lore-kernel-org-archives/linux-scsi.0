Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1226FC7619A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjCVT75 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbjCVT72 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:59:28 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810AD5CC3D
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:05 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id ix20so20300655plb.3
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wHkDbF0/Z1JjMYvDeydty31pm3qJrqFiajGlMun4cOw=;
        b=FikP7bkTEUpGdjTOqnKnjvnjFfmctpUYL7njxb6AXhWmpg5XixWOLDCQgJEZ0BJSE1
         ELU90DQZafkkPeD+zug6M4x5n0cwNmk9TWUWCkz+HaBVYvtm4BTa4bNoC8c+Cb1nJdWs
         Uxczrd8uczmfFr7rAq1E9jQDbw77v5ex+jCnr4ncX/GtJy9H2KXjblDib88XC3wfFyU/
         UtesjEEJX3FWcBddHyuCiQ7DQWAb5NutUDC94QKnUSJ5iS2cKMLZl2tChir1Pl/+ZjxV
         ftY+TXQlr+Sjw+O1ZV9QZ0+DyIJz2WNfS7dOKn6yWqeBPX1jbR5OfoqrNEEfFLI4XeEk
         /5KA==
X-Gm-Message-State: AO0yUKXrNdNLYE1eHGekAGo9xWklgHkQ2HutS0phx1cZAFUWwVqBHyys
        vox297nK+8nqAQCnuXHgYZk=
X-Google-Smtp-Source: AK7set/rEBSgbTRdt6SyyAGwwZ+TsbypvvXqrfv428YYi5NmOCd2eja0Vg2t7+tzPtuu39SiT11BYA==
X-Received: by 2002:a17:90b:4acf:b0:23f:3539:d326 with SMTP id mh15-20020a17090b4acf00b0023f3539d326mr5095252pjb.0.1679515082385;
        Wed, 22 Mar 2023 12:58:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Varun Prakash <varun@chelsio.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Wu Bo <wubo40@huawei.com>, Jesper Juhl <jesperjuhl76@gmail.com>
Subject: [PATCH v3 49/80] scsi: iscsi: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:44 -0700
Message-Id: <20230322195515.1267197-50-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 4 ++--
 drivers/scsi/be2iscsi/be_main.c          | 2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c         | 4 ++--
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c       | 2 +-
 drivers/scsi/cxgbi/libcxgbi.c            | 2 +-
 drivers/scsi/cxgbi/libcxgbi.h            | 2 +-
 drivers/scsi/iscsi_tcp.c                 | 4 ++--
 drivers/scsi/libiscsi.c                  | 2 +-
 drivers/scsi/qedi/qedi_gbl.h             | 2 +-
 drivers/scsi/qedi/qedi_iscsi.c           | 2 +-
 include/scsi/libiscsi.h                  | 2 +-
 11 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 6b7603765383..bb9aaff92ca3 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -78,7 +78,7 @@ MODULE_DESCRIPTION("iSER (iSCSI Extensions for RDMA) Datamover");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Alex Nezhinsky, Dan Bar Dov, Or Gerlitz");
 
-static struct scsi_host_template iscsi_iser_sht;
+static const struct scsi_host_template iscsi_iser_sht;
 static struct iscsi_transport iscsi_iser_transport;
 static struct scsi_transport_template *iscsi_iser_scsi_transport;
 static struct workqueue_struct *release_wq;
@@ -956,7 +956,7 @@ static umode_t iser_attr_is_visible(int param_type, int param)
 	return 0;
 }
 
-static struct scsi_host_template iscsi_iser_sht = {
+static const struct scsi_host_template iscsi_iser_sht = {
 	.module                 = THIS_MODULE,
 	.name                   = "iSCSI Initiator over iSER",
 	.queuecommand           = iscsi_queuecommand,
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 08920f5f4217..e48f14ad6dfd 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -398,7 +398,7 @@ static const struct pci_device_id beiscsi_pci_id_table[] = {
 MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
 
 
-static struct scsi_host_template beiscsi_sht = {
+static const struct scsi_host_template beiscsi_sht = {
 	.module = THIS_MODULE,
 	.name = "Emulex 10Gbe open-iscsi Initiator Driver",
 	.proc_name = DRV_NAME,
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index a3c800e04a2e..9971f32a663c 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -22,7 +22,7 @@
 
 struct scsi_transport_template *bnx2i_scsi_xport_template;
 struct iscsi_transport bnx2i_iscsi_transport;
-static struct scsi_host_template bnx2i_host_template;
+static const struct scsi_host_template bnx2i_host_template;
 
 /*
  * Global endpoint resource info
@@ -2250,7 +2250,7 @@ static umode_t bnx2i_attr_is_visible(int param_type, int param)
  * 'Scsi_Host_Template' structure and 'iscsi_tranport' structure template
  * used while registering with the scsi host and iSCSI transport module.
  */
-static struct scsi_host_template bnx2i_host_template = {
+static const struct scsi_host_template bnx2i_host_template = {
 	.module			= THIS_MODULE,
 	.name			= "QLogic Offload iSCSI Initiator",
 	.proc_name		= "bnx2i",
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index ff9d4287937a..ec6530240707 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -80,7 +80,7 @@ static struct cxgb3_client t3_client = {
 	.event_handler = cxgb3i_dev_event_handler,
 };
 
-static struct scsi_host_template cxgb3i_host_template = {
+static const struct scsi_host_template cxgb3i_host_template = {
 	.module		= THIS_MODULE,
 	.name		= DRV_MODULE_NAME,
 	.proc_name	= DRV_MODULE_NAME,
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index af281e271f88..eb47c8c96d0e 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -337,7 +337,7 @@ void cxgbi_hbas_remove(struct cxgbi_device *cdev)
 EXPORT_SYMBOL_GPL(cxgbi_hbas_remove);
 
 int cxgbi_hbas_add(struct cxgbi_device *cdev, u64 max_lun,
-		unsigned int max_conns, struct scsi_host_template *sht,
+		unsigned int max_conns, const struct scsi_host_template *sht,
 		struct scsi_transport_template *stt)
 {
 	struct cxgbi_hba *chba;
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index d8fc7beafa20..d92cf1dccc2f 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -591,7 +591,7 @@ struct cxgbi_device *cxgbi_device_find_by_netdev(struct net_device *, int *);
 struct cxgbi_device *cxgbi_device_find_by_netdev_rcu(struct net_device *,
 						     int *);
 int cxgbi_hbas_add(struct cxgbi_device *, u64, unsigned int,
-			struct scsi_host_template *,
+			const struct scsi_host_template *,
 			struct scsi_transport_template *);
 void cxgbi_hbas_remove(struct cxgbi_device *);
 
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index c76f82fb8b63..6df2f4041f12 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -47,7 +47,7 @@ MODULE_DESCRIPTION("iSCSI/TCP data-path");
 MODULE_LICENSE("GPL");
 
 static struct scsi_transport_template *iscsi_sw_tcp_scsi_transport;
-static struct scsi_host_template iscsi_sw_tcp_sht;
+static const struct scsi_host_template iscsi_sw_tcp_sht;
 static struct iscsi_transport iscsi_sw_tcp_transport;
 
 static unsigned int iscsi_max_lun = ~0;
@@ -1072,7 +1072,7 @@ static int iscsi_sw_tcp_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
-static struct scsi_host_template iscsi_sw_tcp_sht = {
+static const struct scsi_host_template iscsi_sw_tcp_sht = {
 	.module			= THIS_MODULE,
 	.name			= "iSCSI Initiator over TCP/IP",
 	.queuecommand           = iscsi_queuecommand,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 127f3d7f19dc..0fda8905eabd 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2895,7 +2895,7 @@ EXPORT_SYMBOL_GPL(iscsi_host_add);
  * This should be called by partial offload and software iscsi drivers.
  * To access the driver specific memory use the iscsi_host_priv() macro.
  */
-struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
+struct Scsi_Host *iscsi_host_alloc(const struct scsi_host_template *sht,
 				   int dd_data_size, bool xmit_can_sleep)
 {
 	struct Scsi_Host *shost;
diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h
index 72942772b198..0e316cc24b19 100644
--- a/drivers/scsi/qedi/qedi_gbl.h
+++ b/drivers/scsi/qedi/qedi_gbl.h
@@ -17,7 +17,7 @@ extern int qedi_do_not_recover;
 
 extern uint qedi_io_tracing;
 
-extern struct scsi_host_template qedi_host_template;
+extern const struct scsi_host_template qedi_host_template;
 extern struct iscsi_transport qedi_iscsi_transport;
 extern const struct qed_iscsi_ops *qedi_ops;
 extern const struct qedi_debugfs_ops qedi_debugfs_ops[];
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 31ec429104e2..6ed8ef97642c 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -40,7 +40,7 @@ static int qedi_eh_host_reset(struct scsi_cmnd *cmd)
 	return qedi_recover_all_conns(qedi);
 }
 
-struct scsi_host_template qedi_host_template = {
+const struct scsi_host_template qedi_host_template = {
 	.module = THIS_MODULE,
 	.name = "QLogic QEDI 25/40/100Gb iSCSI Initiator Driver",
 	.proc_name = QEDI_MODULE_NAME,
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index e39fb0736ade..7282555adfd5 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -407,7 +407,7 @@ extern int iscsi_host_set_param(struct Scsi_Host *shost,
 extern int iscsi_host_get_param(struct Scsi_Host *shost,
 				enum iscsi_host_param param, char *buf);
 extern int iscsi_host_add(struct Scsi_Host *shost, struct device *pdev);
-extern struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
+extern struct Scsi_Host *iscsi_host_alloc(const struct scsi_host_template *sht,
 					  int dd_data_size,
 					  bool xmit_can_sleep);
 extern void iscsi_host_remove(struct Scsi_Host *shost, bool is_shutdown);
