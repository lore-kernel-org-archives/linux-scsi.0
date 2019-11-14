Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5823C432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 10:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC471206DC
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 10:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfKNKIn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 05:08:43 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:31166 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfKNKIn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2019 05:08:43 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa3.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa3.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: TjCwea8zmO7uzu8c/psKPrxpR9s0p9HvstO69/BPVtji1/4To5wmTHIGSohjOLYBKOFjdKtFN+
 UQQ/WBcH1Jh6I8EFN5mwbRkpNOZH/gsfG4AbNQM0B/06YRc6S0DyPpTrZoh6RBxjxfS13e2V9O
 KLCNhuvY6hr56G9nsUj35RcsxPv3K5EfTOOOIYamz7lurmCMsfCNUiKKeUTlFhZlFdnOelpAWk
 PHy6gbb6+jRv9msfqn4itii+CXe3Q0pekrjby0TOPKn6fy5I7uE4jftbiSdIAjdjjnVMZhgu7x
 36s=
X-IronPort-AV: E=Sophos;i="5.68,304,1569308400"; 
   d="scan'208";a="57056470"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Nov 2019 03:08:42 -0700
Received: from AVMBX2.microsemi.net (10.100.34.32) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Thu, 14 Nov
 2019 02:08:42 -0800
Received: from localhost (10.41.130.49) by avmbx2.microsemi.net (10.100.34.32)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Thu, 14 Nov
 2019 02:08:41 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <jsperbeck@google.com>, <auradkar@google.com>,
        <ianyar@google.com>
Subject: [PATCH V2 07/13] pm80xx : Fix dereferencing dangling pointer.
Date:   Thu, 14 Nov 2019 15:39:04 +0530
Message-ID: <20191114100910.6153-8-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20191114100910.6153-1-deepak.ukey@microchip.com>
References: <20191114100910.6153-1-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Vikram Auradkar <auradkar@google.com>

sas_task structure should not be used after task_done is called.
If the device is gone or not attached, we call task_done on t and
continue to use in the sas_task in rest of the function. task_done
is pointing to sas_ata_task_done, may free the memory associated
with the task before returning.

Signed-off-by: Vikram Auradkar <auradkar@google.com>
Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 447a66d60275..4491de8d40fc 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -388,6 +388,7 @@ static int pm8001_task_exec(struct sas_task *task,
 	struct pm8001_ccb_info *ccb;
 	u32 tag = 0xdeadbeef, rc = 0, n_elem = 0;
 	unsigned long flags = 0;
+	enum sas_protocol task_proto = t->task_proto;
 
 	if (!dev->port) {
 		struct task_status_struct *tsm = &t->task_status;
@@ -412,7 +413,7 @@ static int pm8001_task_exec(struct sas_task *task,
 		pm8001_dev = dev->lldd_dev;
 		port = &pm8001_ha->port[sas_find_local_port_id(dev)];
 		if (DEV_IS_GONE(pm8001_dev) || !port->port_attached) {
-			if (sas_protocol_ata(t->task_proto)) {
+			if (sas_protocol_ata(task_proto)) {
 				struct task_status_struct *ts = &t->task_status;
 				ts->resp = SAS_TASK_UNDELIVERED;
 				ts->stat = SAS_PHY_DOWN;
@@ -434,7 +435,7 @@ static int pm8001_task_exec(struct sas_task *task,
 			goto err_out;
 		ccb = &pm8001_ha->ccb_info[tag];
 
-		if (!sas_protocol_ata(t->task_proto)) {
+		if (!sas_protocol_ata(task_proto)) {
 			if (t->num_scatter) {
 				n_elem = dma_map_sg(pm8001_ha->dev,
 					t->scatter,
@@ -454,7 +455,7 @@ static int pm8001_task_exec(struct sas_task *task,
 		ccb->ccb_tag = tag;
 		ccb->task = t;
 		ccb->device = pm8001_dev;
-		switch (t->task_proto) {
+		switch (task_proto) {
 		case SAS_PROTOCOL_SMP:
 			rc = pm8001_task_prep_smp(pm8001_ha, ccb);
 			break;
@@ -471,8 +472,7 @@ static int pm8001_task_exec(struct sas_task *task,
 			break;
 		default:
 			dev_printk(KERN_ERR, pm8001_ha->dev,
-				"unknown sas_task proto: 0x%x\n",
-				t->task_proto);
+				"unknown sas_task proto: 0x%x\n", task_proto);
 			rc = -EINVAL;
 			break;
 		}
@@ -495,7 +495,7 @@ static int pm8001_task_exec(struct sas_task *task,
 	pm8001_tag_free(pm8001_ha, tag);
 err_out:
 	dev_printk(KERN_ERR, pm8001_ha->dev, "pm8001 exec failed[%d]!\n", rc);
-	if (!sas_protocol_ata(t->task_proto))
+	if (!sas_protocol_ata(task_proto))
 		if (n_elem)
 			dma_unmap_sg(pm8001_ha->dev, t->scatter, t->num_scatter,
 				t->data_dir);
-- 
2.16.3

