From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: PATCH [5/15] qla2xxx:  SG tablesize update
Date: Tue, 16 Mar 2004 14:09:03 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060EE3B@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:64440 "EHLO avexch01.qlogic.org")
	by vger.kernel.org with ESMTP id S261750AbUCPWIg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Mar 2004 17:08:36 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Anton Blanchard <anton@samba.org>, JensAxboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tuesday, March 16, 2004 1:50 PM, James Bottomley wrote:
> So, did you want me to apply the sg_tablesize lowering patch?
> 
> I really think performance may suffer from it but, hey, I'm not the
> one who has to justify the figures.
> 

For now, I'd say keep everything in the original patch except the 
hunk that changes SG_ALL -> 32, revised patch attached.

The larger pending_q tear-down patch will follow shortly.

Thanks,
Andrew

diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	Fri Mar 12 17:07:22 2004
+++ b/drivers/scsi/qla2xxx/qla_def.h	Fri Mar 12 17:07:22 2004
@@ -209,7 +209,7 @@
 #define MAX_OUTSTANDING_COMMANDS	1024
 
 /* ISP request and response entry counts (37-65535) */
-#define REQUEST_ENTRY_CNT		1024	/* Number of request entries. */
+#define REQUEST_ENTRY_CNT		2048	/* Number of request entries. */
 #define RESPONSE_ENTRY_CNT_2100		64	/* Number of response entries.*/
 #define RESPONSE_ENTRY_CNT_2300		512	/* Number of response entries.*/
 
diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	Fri Mar 12 17:07:22 2004
+++ b/drivers/scsi/qla2xxx/qla_init.c	Fri Mar 12 17:07:22 2004
@@ -603,7 +603,10 @@
 	ha->product_id[3] = mb[4];
 
 	/* Adjust fw RISC transfer size */
-	ha->fw_transfer_size = REQUEST_ENTRY_SIZE * REQUEST_ENTRY_CNT;
+	if (REQUEST_ENTRY_CNT > 1024)
+		ha->fw_transfer_size = REQUEST_ENTRY_SIZE * 1024;
+	else
+		ha->fw_transfer_size = REQUEST_ENTRY_SIZE * REQUEST_ENTRY_CNT;
 
 	if (IS_QLA2200(ha) &&
 	    RD_MAILBOX_REG(ha, reg, 7) == QLA2200A_RISC_ROM_VER) {
