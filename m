From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: 2.6.12-mm2: 3ware SATA RAID inaccessible
Date: Tue, 28 Jun 2005 09:18:21 -0500
Message-ID: <1119968301.4997.6.camel@mulgrave>
References: <20050626153941.456543d6.akpm@osdl.org>
	 <1119829031.5038.15.camel@mulgrave> <20050627044647.GA4104@nikolas.hn.org>
	 <1119882142.5175.11.camel@mulgrave> <20050628020858.GA4111@nikolas.hn.org>
	 <1119931541.5573.3.camel@mulgrave> <20050628110209.GA5392@nikolas.hn.org>
	 <20050628120953.GJ4410@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:12261 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261461AbVF1OSi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2005 10:18:38 -0400
In-Reply-To: <20050628120953.GJ4410@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Nick Orlov <bugfixer@list.ru>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Tue, 2005-06-28 at 14:09 +0200, Jens Axboe wrote:
> > Hard to say. Kernel panics right after the small pause during detection.
> > And scroll back does not work. I don't really know what it prints before.
> 
> Try this variant, fixes the mapping type and kunmap_atomic().

Actually, I suspect the problem is the BUG_ON(len < 7).  The mode sense
routines have to be really careful for USB, so we request 4 bytes at
first to get the true mode length, hence I think this trips.

The solution, I think is to obey the minimum transfer requests. Note
that 3w-xxxx was always technically overwriting the buffer before, also
note that it always fills in the caching mode page regardless of the
mode page it was actually asked for ...

Anyway, the attached should fix all of these issues (including the ones
Jens pointed out).

James

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1499,22 +1499,43 @@ static int tw_scsiop_inquiry(TW_Device_E
 	return 0;
 } /* End tw_scsiop_inquiry() */
 
+static void tw_transfer_internal(TW_Device_Extension *tw_dev, int request_id,
+				 void *data, unsigned int len)
+{
+	struct scsi_cmnd *cmd = tw_dev->srb[request_id];
+	void *buf;
+	unsigned int transfer_len;
+
+	if (cmd->use_sg) {
+		struct scatterlist *sg =
+			(struct scatterlist *)cmd->request_buffer;
+		buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+		transfer_len = min(sg->length, len);
+	} else {
+		buf = cmd->request_buffer;
+		transfer_len = min(cmd->request_bufflen, len);
+	}
+
+	memcpy(buf, data, transfer_len);
+	
+	if (cmd->use_sg) {
+		struct scatterlist *sg;
+
+		sg = (struct scatterlist *)cmd->request_buffer;
+		kunmap_atomic(buf - sg->offset, KM_IRQ0);
+	}
+}
+
 /* This function is called by the isr to complete an inquiry command */
 static int tw_scsiop_inquiry_complete(TW_Device_Extension *tw_dev, int request_id)
 {
 	unsigned char *is_unit_present;
-	unsigned char *request_buffer;
+	unsigned char request_buffer[36];
 	TW_Param *param;
 
 	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_inquiry_complete()\n");
 
-	/* Fill request buffer */
-	if (tw_dev->srb[request_id]->request_buffer == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_inquiry_complete(): Request buffer NULL.\n");
-		return 1;
-	}
-	request_buffer = tw_dev->srb[request_id]->request_buffer;
-	memset(request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
+	memset(request_buffer, 0, sizeof(request_buffer));
 	request_buffer[0] = TYPE_DISK; /* Peripheral device type */
 	request_buffer[1] = 0;	       /* Device type modifier */
 	request_buffer[2] = 0;	       /* No ansi/iso compliance */
@@ -1522,6 +1543,8 @@ static int tw_scsiop_inquiry_complete(TW
 	memcpy(&request_buffer[8], "3ware   ", 8);	 /* Vendor ID */
 	sprintf(&request_buffer[16], "Logical Disk %-2d ", tw_dev->srb[request_id]->device->id);
 	memcpy(&request_buffer[32], TW_DRIVER_VERSION, 3);
+	tw_transfer_internal(tw_dev, request_id, request_buffer,
+			     sizeof(request_buffer));
 
 	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
 	if (param == NULL) {
@@ -1612,7 +1635,7 @@ static int tw_scsiop_mode_sense_complete
 {
 	TW_Param *param;
 	unsigned char *flags;
-	unsigned char *request_buffer;
+	unsigned char request_buffer[8];
 
 	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_mode_sense_complete()\n");
 
@@ -1622,8 +1645,7 @@ static int tw_scsiop_mode_sense_complete
 		return 1;
 	}
 	flags = (char *)&(param->data[0]);
-	request_buffer = tw_dev->srb[request_id]->buffer;
-	memset(request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
+	memset(request_buffer, 0, sizeof(request_buffer));
 
 	request_buffer[0] = 0xf;        /* mode data length */
 	request_buffer[1] = 0;          /* default medium type */
@@ -1635,6 +1657,8 @@ static int tw_scsiop_mode_sense_complete
 		request_buffer[6] = 0x4;        /* WCE on */
 	else
 		request_buffer[6] = 0x0;        /* WCE off */
+	tw_transfer_internal(tw_dev, request_id, request_buffer,
+			     sizeof(request_buffer));
 
 	return 0;
 } /* End tw_scsiop_mode_sense_complete() */
@@ -1701,17 +1725,12 @@ static int tw_scsiop_read_capacity_compl
 {
 	unsigned char *param_data;
 	u32 capacity;
-	char *buff;
+	char buff[8];
 	TW_Param *param;
 
 	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_capacity_complete()\n");
 
-	buff = tw_dev->srb[request_id]->request_buffer;
-	if (buff == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_scsiop_read_capacity_complete(): Request buffer NULL.\n");
-		return 1;
-	}
-	memset(buff, 0, tw_dev->srb[request_id]->request_bufflen);
+	memset(buff, 0, sizeof(buff));
 	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
 	if (param == NULL) {
 		printk(KERN_WARNING "3w-xxxx: tw_scsiop_read_capacity_complete(): Bad alignment virtual address.\n");
@@ -1739,6 +1758,8 @@ static int tw_scsiop_read_capacity_compl
 	buff[6] = (TW_BLOCK_SIZE >> 8) & 0xff;
 	buff[7] = TW_BLOCK_SIZE & 0xff;
 
+	tw_transfer_internal(tw_dev, request_id, buff, sizeof(buff));
+
 	return 0;
 } /* End tw_scsiop_read_capacity_complete() */
 


