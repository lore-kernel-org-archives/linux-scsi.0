From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 2/3][RESUBMIT] scsi_dh_rdac: move the init code from
 rdac_activate to rdac_bus_attach
Date: Fri, 28 Aug 2009 08:22:49 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474C65F3E@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og121.obsmtp.com ([64.18.2.20]:49669 "EHLO
	exprod7og121.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbZH1OW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2009 10:22:57 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: 'device mapper development' <dm-devel@redhat.com>, "'sekharan@linux.vnet.ibm.com'" <sekharan@linux.vnet.ibm.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

Moving the initialization code from rdac_activate to rdac_bus_attach which is more efficient. We don't have to collect all these information during every activate.


Signed-off-by: Babu Moger <babu.moger@lsi.com>
Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>

---

--- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-08-27 18:30:24.000000000 -0500
+++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-08-27 18:31:31.000000000 -0500
@@ -555,21 +555,6 @@ static int rdac_activate(struct scsi_dev
 	if (err != SCSI_DH_OK)
 		goto done;
 
-	if (!h->ctlr) {
-		err = initialize_controller(sdev, h);
-		if (err != SCSI_DH_OK)
-			goto done;
-
-		err = get_array_name(sdev, h);
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
@@ -712,6 +697,18 @@ static int rdac_bus_attach(struct scsi_d
 	if (err != SCSI_DH_OK)
 		goto failed;
 
+	err = initialize_controller(sdev, h);
+	if (err != SCSI_DH_OK)
+		goto failed;
+
+	err = get_array_name(sdev, h);
+	if (err != SCSI_DH_OK)
+		goto failed;
+		
+	err = set_mode_select(sdev, h);
+	if (err != SCSI_DH_OK)
+		goto failed;
+
 	if (!try_module_get(THIS_MODULE))
 		goto failed;
 


