From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: 2.6.12-mm2: 3ware SATA RAID inaccessible
Date: Sun, 26 Jun 2005 18:37:11 -0500
Message-ID: <1119829031.5038.15.camel@mulgrave>
References: <20050626153941.456543d6.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:41938 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261658AbVFZXhW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Jun 2005 19:37:22 -0400
In-Reply-To: <20050626153941.456543d6.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, aradford@amcc.com, Nick Orlov <bugfixer@list.ru>

On Sun, 2005-06-26 at 15:39 -0700, Andrew Morton wrote:
> : OK ... I looked ... and it's not pretty.  The problem is that the 3ware
> : assumes certain commands (INQUIRY, READ_CAPACITY, MODE_SENSE + a few
> : others) are only generated internally and thus only have use_sg == 0.
> : The scsi-block-tree breaks this assumption because we're trying to
> : eliminate the use_sg == 0 special case.
> : 
> : It's important to note that this behaviour is already broken, as anyone
> : using SG_IO to send commands to the device would have discovered.

OK, I think the attached is the fix.  It makes the 3w-xxxx routines
handle sg data.  Can we verify it works first, and then we'll worry
about how many other internal command processing devices are broken in
this way.

Thanks,

James

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1499,22 +1499,53 @@ static int tw_scsiop_inquiry(TW_Device_E
 	return 0;
 } /* End tw_scsiop_inquiry() */
 
+static void *tw_map_internal(TW_Device_Extension *tw_dev, int request_id,
+			     int *len)
+{
+	struct scsi_cmnd *cmd = tw_dev->srb[request_id];
+	void *buf;
+
+	if (cmd->use_sg) {
+		struct scatterlist *sg =
+			(struct scatterlist *)cmd->request_buffer;
+		buf = kmap_atomic(sg->page, KM_USER0) + sg->offset;
+		*len = sg->length;
+	} else {
+		buf = cmd->request_buffer;
+		*len = cmd->request_bufflen;
+	}
+	return buf;
+}
+
+static void tw_unmap_internal(TW_Device_Extension *tw_dev, int request_id)
+{
+	struct scsi_cmnd *cmd = tw_dev->srb[request_id];
+
+	if (cmd->use_sg) {
+		struct scatterlist *sg;
+
+		sg = (struct scatterlist *)cmd->request_buffer;
+		kunmap_atomic(sg->page, KM_USER0);
+	}
+}
+
 /* This function is called by the isr to complete an inquiry command */
 static int tw_scsiop_inquiry_complete(TW_Device_Extension *tw_dev, int request_id)
 {
 	unsigned char *is_unit_present;
 	unsigned char *request_buffer;
+	int len;
 	TW_Param *param;
 
 	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_inquiry_complete()\n");
 
 	/* Fill request buffer */
-	if (tw_dev->srb[request_id]->request_buffer == NULL) {
+	request_buffer = tw_map_internal(tw_dev, request_id, &len);
+	if (request_buffer == NULL || len < 36) {
 		printk(KERN_WARNING "3w-xxxx: tw_scsiop_inquiry_complete(): Request buffer NULL.\n");
 		return 1;
 	}
-	request_buffer = tw_dev->srb[request_id]->request_buffer;
-	memset(request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
+	memset(request_buffer, 0, len);
 	request_buffer[0] = TYPE_DISK; /* Peripheral device type */
 	request_buffer[1] = 0;	       /* Device type modifier */
 	request_buffer[2] = 0;	       /* No ansi/iso compliance */
@@ -1522,6 +1553,7 @@ static int tw_scsiop_inquiry_complete(TW
 	memcpy(&request_buffer[8], "3ware   ", 8);	 /* Vendor ID */
 	sprintf(&request_buffer[16], "Logical Disk %-2d ", tw_dev->srb[request_id]->device->id);
 	memcpy(&request_buffer[32], TW_DRIVER_VERSION, 3);
+	tw_unmap_internal(tw_dev, request_id);
 
 	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
 	if (param == NULL) {
@@ -1613,6 +1645,7 @@ static int tw_scsiop_mode_sense_complete
 	TW_Param *param;
 	unsigned char *flags;
 	unsigned char *request_buffer;
+	int len;
 
 	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_mode_sense_complete()\n");
 
@@ -1622,8 +1655,9 @@ static int tw_scsiop_mode_sense_complete
 		return 1;
 	}
 	flags = (char *)&(param->data[0]);
-	request_buffer = tw_dev->srb[request_id]->buffer;
-	memset(request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
+	request_buffer = tw_map_internal(tw_dev, request_id, &len);
+	memset(request_buffer, 0, len);
+	BUG_ON(len < 7);
 
 	request_buffer[0] = 0xf;        /* mode data length */
 	request_buffer[1] = 0;          /* default medium type */
@@ -1635,6 +1669,7 @@ static int tw_scsiop_mode_sense_complete
 		request_buffer[6] = 0x4;        /* WCE on */
 	else
 		request_buffer[6] = 0x0;        /* WCE off */
+	tw_unmap_internal(tw_dev, request_id);
 
 	return 0;
 } /* End tw_scsiop_mode_sense_complete() */
@@ -1703,15 +1738,16 @@ static int tw_scsiop_read_capacity_compl
 	u32 capacity;
 	char *buff;
 	TW_Param *param;
+	int len;
 
 	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_read_capacity_complete()\n");
 
-	buff = tw_dev->srb[request_id]->request_buffer;
-	if (buff == NULL) {
+	buff = tw_map_internal(tw_dev, request_id, &len);
+	if (buff == NULL || len < 8) {
 		printk(KERN_WARNING "3w-xxxx: tw_scsiop_read_capacity_complete(): Request buffer NULL.\n");
 		return 1;
 	}
-	memset(buff, 0, tw_dev->srb[request_id]->request_bufflen);
+	memset(buff, 0, len);
 	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
 	if (param == NULL) {
 		printk(KERN_WARNING "3w-xxxx: tw_scsiop_read_capacity_complete(): Bad alignment virtual address.\n");
@@ -1739,6 +1775,8 @@ static int tw_scsiop_read_capacity_compl
 	buff[6] = (TW_BLOCK_SIZE >> 8) & 0xff;
 	buff[7] = TW_BLOCK_SIZE & 0xff;
 
+	tw_unmap_internal(tw_dev, request_id);
+
 	return 0;
 } /* End tw_scsiop_read_capacity_complete() */
 


