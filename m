From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] remove sr_host
Date: Wed, 16 Oct 2002 17:44:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021016174450.A10308@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay03.boulder.ibm.com (westrelay03.boulder.ibm.com [9.17.194.24])
	by e32.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id g9H0iu1q044346
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2002 20:44:56 -0400
Received: from gateway.beaverton.ibm.com (gateway.beaverton.ibm.com [138.95.180.1])
	by westrelay03.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id g9H0itBw095184
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2002 18:44:55 -0600
Received: from eng2.beaverton.ibm.com (eng2.beaverton.ibm.com [9.47.57.17])
	by gateway.beaverton.ibm.com (8.10.0.Beta10/8.11.6) with ESMTP id g9H0iqv19259
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2002 17:44:52 -0700 (PDT)
Received: (from patman@localhost)
	by eng2.beaverton.ibm.com (8.10.0.Beta10/8.8.5/token.aware-1.2) id g9H0ioq10335
	for linux-scsi@vger.kernel.org; Wed, 16 Oct 2002 17:44:50 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This simple patch removes sr_host and replaces its only use
in sr_ioctl.c with SDev->host.

diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Wed Oct 16 17:40:00 2002
+++ b/drivers/scsi/scsi.c	Wed Oct 16 17:40:00 2002
@@ -318,7 +318,6 @@
 	memset(SRpnt, 0, size);
         SRpnt->sr_request = (struct request *)(((char *)SRpnt) + offset);
 	SRpnt->sr_device = device;
-	SRpnt->sr_host = device->host;
 	SRpnt->sr_magic = SCSI_REQ_MAGIC;
 	SRpnt->sr_data_direction = SCSI_DATA_UNKNOWN;
 
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Wed Oct 16 17:40:00 2002
+++ b/drivers/scsi/scsi.h	Wed Oct 16 17:40:00 2002
@@ -678,7 +678,6 @@
 						 * received on original command 
 						 * (auto-sense) */
 
-	struct Scsi_Host *sr_host;
 	Scsi_Device *sr_device;
 	Scsi_Cmnd *sr_command;
 	struct request *sr_request;	/* A copy of the command we are
diff -Nru a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
--- a/drivers/scsi/sr_ioctl.c	Wed Oct 16 17:40:00 2002
+++ b/drivers/scsi/sr_ioctl.c	Wed Oct 16 17:40:00 2002
@@ -93,7 +93,7 @@
 
 	/* use ISA DMA buffer if necessary */
 	SRpnt->sr_request->buffer = cgc->buffer;
-	if (cgc->buffer && SRpnt->sr_host->unchecked_isa_dma &&
+	if (cgc->buffer && SDev->host->unchecked_isa_dma &&
 	    (virt_to_phys(cgc->buffer) + cgc->buflen - 1 > ISA_DMA_THRESHOLD)) {
 		bounce_buffer = (char *) kmalloc(cgc->buflen, GFP_DMA);
 		if (bounce_buffer == NULL) {
