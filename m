From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] REQUEST SENSE 254->252 byte response
Date: Tue, 24 Jun 2003 18:37:48 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EF80DDC.5080903@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050102060407050509030005"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:28947 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261151AbTFXIXp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2003 04:23:45 -0400
Received: from torque.net (d-241-87.stlucia.uq.net.au [203.101.241.87])
	by bunyip.cc.uq.edu.au (8.12.9/8.12.9) with ESMTP id h5O8bohp020760
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2003 18:37:51 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050102060407050509030005
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

SPC-3 (rev 13) says that 252 bytes in the maximum (and
recommended) length for a REQUEST SENSE reponse.

Linux asks for 254 bytes in scsi_error.c .

That number was not specified in SPC-2 (although the
allocation length field is 1 byte thus limiting it to
255). Seems as though some numbers are being rounded
down to be multiples of 4.

Doug Gilbert

--------------050102060407050509030005
Content-Type: text/plain;
 name="scsi_error_2573.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_error_2573.diff"

--- linux/drivers/scsi/scsi_error.c	2003-06-23 17:52:25.000000000 +1000
+++ linux/drivers/scsi/scsi_error.c2573dpg	2003-06-24 18:21:24.999076832 +1000
@@ -532,14 +532,14 @@
 static int scsi_request_sense(struct scsi_cmnd *scmd)
 {
 	static unsigned char generic_sense[6] =
-	{REQUEST_SENSE, 0, 0, 0, 254, 0};
+	{REQUEST_SENSE, 0, 0, 0, 252, 0};
 	unsigned char *scsi_result;
 	int saved_result;
 	int rtn;
 
 	memcpy(scmd->cmnd, generic_sense, sizeof(generic_sense));
 
-	scsi_result = kmalloc(254, GFP_ATOMIC | (scmd->device->host->hostt->unchecked_isa_dma) ? __GFP_DMA : 0);
+	scsi_result = kmalloc(252, GFP_ATOMIC | (scmd->device->host->hostt->unchecked_isa_dma) ? __GFP_DMA : 0);
 
 
 	if (unlikely(!scsi_result)) {
@@ -555,11 +555,11 @@
 	 * address (db).  0 is not a valid sense code. 
 	 */
 	memset(scmd->sense_buffer, 0, sizeof(scmd->sense_buffer));
-	memset(scsi_result, 0, 254);
+	memset(scsi_result, 0, 252);
 
 	saved_result = scmd->result;
 	scmd->request_buffer = scsi_result;
-	scmd->request_bufflen = 254;
+	scmd->request_bufflen = 252;
 	scmd->use_sg = 0;
 	scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
 	scmd->sc_data_direction = SCSI_DATA_READ;

--------------050102060407050509030005--

