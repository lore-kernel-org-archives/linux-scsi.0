From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill reamining scsi_scan.c typedef abuse
Date: Tue, 3 Jun 2003 23:05:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030603210538.GC9336@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:17065 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261222AbTFCUwN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2003 16:52:13 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org


diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Sun Jun  1 21:27:34 2003
+++ b/drivers/scsi/scsi_scan.c	Sun Jun  1 21:27:34 2003
@@ -141,7 +141,8 @@
  *     @sreq to unlock a device, storing the (unused) results into result.
  *     Called for BLIST_KEY devices.
  **/
-static void scsi_unlock_floptical(Scsi_Request *sreq, unsigned char *result)
+static void scsi_unlock_floptical(struct scsi_request *sreq,
+				  unsigned char *result)
 {
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 
@@ -154,8 +155,7 @@
 	scsi_cmd[5] = 0;
 	sreq->sr_cmd_len = 0;
 	sreq->sr_data_direction = SCSI_DATA_READ;
-	scsi_wait_req(sreq, (void *) scsi_cmd, (void *) result, 0x2a /* size */,
-		      SCSI_TIMEOUT, 3);
+	scsi_wait_req(sreq, scsi_cmd, result, 0x2a /* size */, SCSI_TIMEOUT, 3);
 }
 
 /**
@@ -354,10 +354,10 @@
  *     are copied to the Scsi_Device at @sreq->sr_device (sdev);
  *     any flags value is stored in *@bflags.
  **/
-static void scsi_probe_lun(Scsi_Request *sreq, char *inq_result,
+static void scsi_probe_lun(struct scsi_request *sreq, char *inq_result,
 			   int *bflags)
 {
-	Scsi_Device *sdev = sreq->sr_device;	/* a bit ugly */
+	struct scsi_device *sdev = sreq->sr_device;	/* a bit ugly */
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int possible_inq_resp_len;
 
@@ -522,7 +522,7 @@
  *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a Scsi_Device
  *     SCSI_SCAN_LUN_PRESENT: a new Scsi_Device was allocated and initialized
  **/
-static int scsi_add_lun(Scsi_Device *sdev, char *inq_result, int *bflags)
+static int scsi_add_lun(struct scsi_device *sdev, char *inq_result, int *bflags)
 {
 	struct scsi_device *sdev_sibling;
 	struct scsi_target *starget;
