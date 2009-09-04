From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 1/3][RESUBMIT] scsi_dh_rdac: move the init code from
 rdac_activate to rdac_bus_attach
Date: Thu, 3 Sep 2009 21:42:15 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474CCD1BA@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:44333 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbZIDDmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2009 23:42:19 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: 'device mapper development' <dm-devel@redhat.com>, "'sekharan@linux.vnet.ibm.com'" <sekharan@linux.vnet.ibm.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

Moving the initialization code from rdac_activate to rdac_bus_attach which is more efficient.
We don't have to collect all the information during every activate. 

Signed-off-by: Babu Moger <babu.moger@lsi.com>
Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>

---
--- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-09-03 13:39:52.000000000 -0500
+++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-09-03 14:10:40.000000000 -0500
@@ -525,17 +525,6 @@ static int rdac_activate(struct scsi_dev
 	if (err != SCSI_DH_OK)
 		goto done;
 
-	if (!h->ctlr) {
-		err = initialize_controller(sdev, h);
-		if (err != SCSI_DH_OK)
-			goto done;
-	}
-
-	if (h->ctlr->use_ms10 == -1) {
-		err = set_mode_select(sdev, h);
-		if (err != SCSI_DH_OK)
-			goto done;
-	}
 	if (h->lun_state == RDAC_LUN_UNOWNED)
 		err = send_mode_select(sdev, h);
 done:
@@ -674,12 +663,20 @@ static int rdac_bus_attach(struct scsi_d
 	if (err != SCSI_DH_OK)
 		goto failed;
 
-	err = check_ownership(sdev, h);
+	err = initialize_controller(sdev, h);
 	if (err != SCSI_DH_OK)
 		goto failed;
 
+	err = check_ownership(sdev, h);
+	if (err != SCSI_DH_OK)
+		goto clean_ctlr;
+
+	err = set_mode_select(sdev, h);
+	if (err != SCSI_DH_OK)
+		goto clean_ctlr;
+
 	if (!try_module_get(THIS_MODULE))
-		goto failed;
+		goto clean_ctlr;
 
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	sdev->scsi_dh_data = scsi_dh_data;
@@ -691,6 +688,9 @@ static int rdac_bus_attach(struct scsi_d
 
 	return 0;
 
+clean_ctlr:
+	kref_put(&h->ctlr->kref, release_controller);
+
 failed:
 	kfree(scsi_dh_data);
 	sdev_printk(KERN_ERR, sdev, "%s: not attached\n",


