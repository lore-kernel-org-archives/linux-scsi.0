From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] libata SATL: WWN for device id VPD page
Date: Fri, 13 May 2011 23:16:50 -0400
Message-ID: <4DCDF422.5060109@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010408060008000106000901"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:43176 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758621Ab1ENDRL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2011 23:17:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, jgarzik@redhat.com, Tejun Heo <tj@kernel.org>

This is a multi-part message in MIME format.
--------------010408060008000106000901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

libata implements a SCSI to ATA Translation Layer and
should comply with the SAT (ANSI INCITS 431-2007) and
SAT-2 (ANSI INCITS 465-2010).

Both standards require that if an ATA device supplies
a World Wide Name (WWN) then it should appear in the
corresponding SCSI device identification VPD page.

Changelog:
   - add NAA descriptor to the device identification VPD
     page for the addressed logical unit. ATA's WWN is
     in NAA(5) format.

The attached patch is against lk 2.6.38 .


Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------010408060008000106000901
Content-Type: text/x-patch;
 name="libata-scsi_vpd83.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="libata-scsi_vpd83.patch"

--- linux/drivers/ata/libata-scsi.c	2011-03-16 06:47:24.647997871 -0400
+++ linux/drivers/ata/libata-scsi.c_vpd83a	2011-05-13 19:35:40.601635269 -0400
@@ -2028,12 +2028,29 @@ static unsigned int ata_scsiop_inq_80(st
 static unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf)
 {
 	const int sat_model_serial_desc_len = 68;
-	int num;
+	int num, k;
+	unsigned char wwn_arr[8];
 
 	rbuf[1] = 0x83;			/* this page code */
 	num = 4;
 
-	/* piv=0, assoc=lu, code_set=ACSII, designator=vendor */
+	/* WWN starts at word 108 in IDENTIFY response */
+	ata_id_string(args->id, wwn_arr, 108, 8);
+	/* SPL(SAS-2.1) checks for zeros rather than checking supported bit */
+	for (k = 0; (k < 8) && (0 == wwn_arr[k]); ++k)
+		;
+	if (k < 8) {	/* found non-zero WWN */
+		/* piv=0, assoc=lu, code_set=binary, designator=naa */
+		rbuf[num + 0] = 1;
+		rbuf[num + 1] = 3;
+		rbuf[num + 2] = 0;
+		rbuf[num + 3] = 8;
+		num += 4;
+		memcpy(rbuf + num, wwn_arr, 8);
+		num += 8;
+	}
+
+	/* piv=0, assoc=lu, code_set=ASCII, designator=vendor */
 	rbuf[num + 0] = 2;
 	rbuf[num + 3] = ATA_ID_SERNO_LEN;
 	num += 4;

--------------010408060008000106000901--
