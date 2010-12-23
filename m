From: Chuck Tuffli <ctuffli@gmail.com>
Subject: [RFC] lldd_I_T_nexus_reset use in sas_ata.c
Date: Thu, 23 Dec 2010 11:34:12 -0800
Message-ID: <AANLkTimTDLOv8A7Vq3y6-8L4VA8PpU135fSQZH8SgaKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61764 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab0LWTeO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Dec 2010 14:34:14 -0500
Received: by wyb28 with SMTP id 28so6399768wyb.19
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2010 11:34:12 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Can some shed light on why sas_ata_phy_reset() does an I_T nexus
reset? It seems like calling sas_phy_reset() might be more accurate in
this case. Thanks.

---chuck

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index e1a395b..b012d15 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -241,15 +241,11 @@ static bool sas_ata_qc_fill_rtf(struct ata_queued_cmd *qc)
 static void sas_ata_phy_reset(struct ata_port *ap)
 {
 	struct domain_device *dev = ap->private_data;
-	struct sas_internal *i =
-		to_sas_internal(dev->port->ha->core.shost->transportt);
-	int res = TMF_RESP_FUNC_FAILED;
-
-	if (i->dft->lldd_I_T_nexus_reset)
-		res = i->dft->lldd_I_T_nexus_reset(dev);
+	int res;

-	if (res != TMF_RESP_FUNC_COMPLETE)
-		SAS_DPRINTK("%s: Unable to reset I T nexus?\n", __func__);
+	res = sas_phy_reset(sas_find_local_phy(dev), 0);
+	if (res)
+		SAS_DPRINTK("%s: Unable to reset phy 0x%x\n", __func__, res);

 	switch (dev->sata_dev.command_set) {
 		case ATA_COMMAND_SET:
