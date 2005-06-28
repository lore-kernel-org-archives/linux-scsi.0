From: Jens Axboe <axboe@suse.de>
Subject: Re: Fw: 2.6.12-mm2: 3ware SATA RAID inaccessible
Date: Tue, 28 Jun 2005 14:09:54 +0200
Message-ID: <20050628120953.GJ4410@suse.de>
References: <20050626153941.456543d6.akpm@osdl.org> <1119829031.5038.15.camel@mulgrave> <20050627044647.GA4104@nikolas.hn.org> <1119882142.5175.11.camel@mulgrave> <20050628020858.GA4111@nikolas.hn.org> <1119931541.5573.3.camel@mulgrave> <20050628110209.GA5392@nikolas.hn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:47806 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261437AbVF1MIp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2005 08:08:45 -0400
Content-Disposition: inline
In-Reply-To: <20050628110209.GA5392@nikolas.hn.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Orlov <bugfixer@list.ru>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Tue, Jun 28 2005, Nick Orlov wrote:
> On Mon, Jun 27, 2005 at 11:05:41PM -0500, James Bottomley wrote:
> > On Mon, 2005-06-27 at 22:08 -0400, Nick Orlov wrote:
> > > EIP is at tw_scsiop_mode_sense_complete+0xc7/0xe0
> > 
> > OK, so it got to the mode sense.  What happened to the preceeding
> > INQUIRY?  Did it produce correct values or did it trip the error
> > condition?
> 
> Hard to say. Kernel panics right after the small pause during detection.
> And scroll back does not work. I don't really know what it prints before.

Try this variant, fixes the mapping type and kunmap_atomic().

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1499,22 +1499,50 @@ static int tw_scsiop_inquiry(TW_Device_E
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
+		buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+		*len = sg->length;
+	} else {
+		buf = cmd->request_buffer;
+		*len = cmd->request_bufflen;
+	}
+	return buf;
+}
+
+static void tw_unmap_internal(TW_Device_Extension *tw_dev, char *ptr,
+			      int request_id)
+{
+	struct scsi_cmnd *cmd = tw_dev->srb[request_id];
+
+	if (cmd->use_sg)
+		kunmap_atomic(ptr, KM_IRQ0);
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
@@ -1522,6 +1550,7 @@ static int tw_scsiop_inquiry_complete(TW
 	memcpy(&request_buffer[8], "3ware   ", 8);	 /* Vendor ID */
 	sprintf(&request_buffer[16], "Logical Disk %-2d ", tw_dev->srb[request_id]->device->id);
 	memcpy(&request_buffer[32], TW_DRIVER_VERSION, 3);
+	tw_unmap_internal(tw_dev, request_buffer, request_id);
 
 	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
 	if (param == NULL) {
@@ -1613,6 +1642,7 @@ static int tw_scsiop_mode_sense_complete
 	TW_Param *param;
 	unsigned char *flags;
 	unsigned char *request_buffer;
+	int len;
 
 	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_mode_sense_complete()\n");
 
@@ -1622,8 +1652,9 @@ static int tw_scsiop_mode_sense_complete
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
@@ -1635,6 +1666,7 @@ static int tw_scsiop_mode_sense_complete
 		request_buffer[6] = 0x4;        /* WCE on */
 	else
 		request_buffer[6] = 0x0;        /* WCE off */
+	tw_unmap_internal(tw_dev, request_buffer, request_id);
 
 	return 0;
 } /* End tw_scsiop_mode_sense_complete() */
@@ -1703,15 +1735,16 @@ static int tw_scsiop_read_capacity_compl
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
@@ -1739,6 +1772,8 @@ static int tw_scsiop_read_capacity_compl
 	buff[6] = (TW_BLOCK_SIZE >> 8) & 0xff;
 	buff[7] = TW_BLOCK_SIZE & 0xff;
 
+	tw_unmap_internal(tw_dev, buff, request_id);
+
 	return 0;
 } /* End tw_scsiop_read_capacity_complete() */
 

-- 
Jens Axboe

