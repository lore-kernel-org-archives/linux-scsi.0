From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] aacraid 2.6: Fix aacraid probe breakage in
	scsi-block-2.6.git
Date: Mon, 15 Aug 2005 09:53:42 -0700
Message-ID: <1124124823.12657.12.camel@markh1.pdx.osdl.net>
References: <1123694406.30596.10.camel@markh1.pdx.osdl.net>
	 <1123694836.5134.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:57825 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S964824AbVHOQxr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 12:53:47 -0400
In-Reply-To: <1123694836.5134.14.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Wed, 2005-08-10 at 12:27 -0500, James Bottomley wrote:
> On Wed, 2005-08-10 at 10:20 -0700, Mark Haverkamp wrote:
> > While trying out a recent mm kernel I noticed that when I loaded the
> > aacraid  driver I saw errors probing the disks:
> > 
> > sdc : sector size 0 reported, assuming 512.
> > SCSI device sdc: 1 512-byte hdwr sectors (0 MB)
> 
> Sigh, I guess this is because aacraid is making illegal assumptions
> about the format of certain commands it emulates?
> 
> We had a similar issue with 3w-xxxx which assumed commands like INQUIRY,
> READ_CAPACITY and MODE_SENSE only came from the kernel, so would never
> have use_sg != 0.  This is, of course, wrong, since such commands can
> and do come from SG_IO.
> 
> The fix is probably similar to the 3w-xxxx one.
> 
> James

This patch fixes the bad assumption of the aacraid driver with use_sg.
I used the 3w-xxxx driver fix as a guide for this.

The patch applies to the scsi-block-2.6 git tree. Is that the right
place for the patch?  Should it be applied to the scsi-misc or the scsi-
rc-fixes tree instead?

Signed-off-by: Mark Haverkamp <markh@osdl.org>

Index: scsi-block-2.6/drivers/scsi/aacraid/aachba.c
===================================================================
--- scsi-block-2.6.orig/drivers/scsi/aacraid/aachba.c	2005-08-10 09:10:56.000000000 -0700
+++ scsi-block-2.6/drivers/scsi/aacraid/aachba.c	2005-08-12 14:20:32.000000000 -0700
@@ -348,6 +348,27 @@
 	spin_unlock_irqrestore(host->host_lock, cpu_flags);
 }
 
+static void aac_internal_transfer(struct scsi_cmnd *scsicmd, void *data, unsigned int offset, unsigned int len)
+{
+	void *buf;
+	unsigned int transfer_len;
+	struct scatterlist *sg = scsicmd->request_buffer;
+
+	if (scsicmd->use_sg) {
+		buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+		transfer_len = min(sg->length, len + offset);
+	} else {
+		buf = scsicmd->request_buffer;
+		transfer_len = min(scsicmd->request_bufflen, len + offset);
+	}
+
+	memcpy(buf + offset, data, transfer_len - offset);
+
+	if (scsicmd->use_sg) 
+		kunmap_atomic(buf - sg->offset, KM_IRQ0);
+
+}
+
 static void get_container_name_callback(void *context, struct fib * fibptr)
 {
 	struct aac_get_name_resp * get_name_reply;
@@ -363,18 +384,22 @@
 	/* Failure is irrelevant, using default value instead */
 	if ((le32_to_cpu(get_name_reply->status) == CT_OK)
 	 && (get_name_reply->data[0] != '\0')) {
-		int    count;
-		char * dp;
-		char * sp = get_name_reply->data;
+		char *sp = get_name_reply->data;
 		sp[sizeof(((struct aac_get_name_resp *)NULL)->data)-1] = '\0';
 		while (*sp == ' ')
 			++sp;
-		count = sizeof(((struct inquiry_data *)NULL)->inqd_pid);
-		dp = ((struct inquiry_data *)scsicmd->request_buffer)->inqd_pid;
-		if (*sp) do {
-			*dp++ = (*sp) ? *sp++ : ' ';
-		} while (--count > 0);
+		if (*sp) {
+			char d[sizeof(((struct inquiry_data *)NULL)->inqd_pid)];
+			int count = sizeof(d);
+			char *dp = d;
+			do {
+				*dp++ = (*sp) ? *sp++ : ' ';
+			} while (--count > 0);
+			aac_internal_transfer(scsicmd, d, 
+			  offsetof(struct inquiry_data, inqd_pid), sizeof(d));
+		}
 	}
+
 	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 
 	fib_complete(fibptr);
@@ -1340,44 +1365,44 @@
 	switch (scsicmd->cmnd[0]) {
 	case INQUIRY:
 	{
-		struct inquiry_data *inq_data_ptr;
+		struct inquiry_data inq_data;
 
 		dprintk((KERN_DEBUG "INQUIRY command, ID: %d.\n", scsicmd->device->id));
-		inq_data_ptr = (struct inquiry_data *)scsicmd->request_buffer;
-		memset(inq_data_ptr, 0, sizeof (struct inquiry_data));
+		memset(&inq_data, 0, sizeof (struct inquiry_data));
 
-		inq_data_ptr->inqd_ver = 2;	/* claim compliance to SCSI-2 */
-		inq_data_ptr->inqd_dtq = 0x80;	/* set RMB bit to one indicating that the medium is removable */
-		inq_data_ptr->inqd_rdf = 2;	/* A response data format value of two indicates that the data shall be in the format specified in SCSI-2 */
-		inq_data_ptr->inqd_len = 31;
+		inq_data.inqd_ver = 2;	/* claim compliance to SCSI-2 */
+		inq_data.inqd_dtq = 0x80;	/* set RMB bit to one indicating that the medium is removable */
+		inq_data.inqd_rdf = 2;	/* A response data format value of two indicates that the data shall be in the format specified in SCSI-2 */
+		inq_data.inqd_len = 31;
 		/*Format for "pad2" is  RelAdr | WBus32 | WBus16 |  Sync  | Linked |Reserved| CmdQue | SftRe */
-		inq_data_ptr->inqd_pad2= 0x32 ;	 /*WBus16|Sync|CmdQue */
+		inq_data.inqd_pad2= 0x32 ;	 /*WBus16|Sync|CmdQue */
 		/*
 		 *	Set the Vendor, Product, and Revision Level
 		 *	see: <vendor>.c i.e. aac.c
 		 */
 		if (scsicmd->device->id == host->this_id) {
-			setinqstr(cardtype, (void *) (inq_data_ptr->inqd_vid), (sizeof(container_types)/sizeof(char *)));
-			inq_data_ptr->inqd_pdt = INQD_PDT_PROC;	/* Processor device */
+			setinqstr(cardtype, (void *) (inq_data.inqd_vid), (sizeof(container_types)/sizeof(char *)));
+			inq_data.inqd_pdt = INQD_PDT_PROC;	/* Processor device */
 			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 			scsicmd->scsi_done(scsicmd);
 			return 0;
 		}
-		setinqstr(cardtype, (void *) (inq_data_ptr->inqd_vid), fsa_dev_ptr[cid].type);
-		inq_data_ptr->inqd_pdt = INQD_PDT_DA;	/* Direct/random access device */
+		setinqstr(cardtype, (void *) (inq_data.inqd_vid), fsa_dev_ptr[cid].type);
+		inq_data.inqd_pdt = INQD_PDT_DA;	/* Direct/random access device */
+		aac_internal_transfer(scsicmd, &inq_data, 0, sizeof(inq_data));
 		return aac_get_container_name(scsicmd, cid);
 	}
 	case READ_CAPACITY:
 	{
 		u32 capacity;
-		char *cp;
+		char cp[8];
 
 		dprintk((KERN_DEBUG "READ CAPACITY command.\n"));
 		if (fsa_dev_ptr[cid].size <= 0x100000000LL)
 			capacity = fsa_dev_ptr[cid].size - 1;
 		else
 			capacity = (u32)-1;
-		cp = scsicmd->request_buffer;
+
 		cp[0] = (capacity >> 24) & 0xff;
 		cp[1] = (capacity >> 16) & 0xff;
 		cp[2] = (capacity >> 8) & 0xff;
@@ -1386,6 +1411,7 @@
 		cp[5] = 0;
 		cp[6] = 2;
 		cp[7] = 0;
+		aac_internal_transfer(scsicmd, cp, 0, sizeof(cp));
 
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		scsicmd->scsi_done(scsicmd);
@@ -1395,15 +1421,15 @@
 
 	case MODE_SENSE:
 	{
-		char *mode_buf;
+		char mode_buf[4];
 
 		dprintk((KERN_DEBUG "MODE SENSE command.\n"));
-		mode_buf = scsicmd->request_buffer;
 		mode_buf[0] = 3;	/* Mode data length */
 		mode_buf[1] = 0;	/* Medium type - default */
 		mode_buf[2] = 0;	/* Device-specific param, bit 8: 0/1 = write enabled/protected */
 		mode_buf[3] = 0;	/* Block descriptor length */
 
+		aac_internal_transfer(scsicmd, mode_buf, 0, sizeof(mode_buf));
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		scsicmd->scsi_done(scsicmd);
 
@@ -1411,10 +1437,9 @@
 	}
 	case MODE_SENSE_10:
 	{
-		char *mode_buf;
+		char mode_buf[8];
 
 		dprintk((KERN_DEBUG "MODE SENSE 10 byte command.\n"));
-		mode_buf = scsicmd->request_buffer;
 		mode_buf[0] = 0;	/* Mode data length (MSB) */
 		mode_buf[1] = 6;	/* Mode data length (LSB) */
 		mode_buf[2] = 0;	/* Medium type - default */
@@ -1423,6 +1448,7 @@
 		mode_buf[5] = 0;	/* reserved */
 		mode_buf[6] = 0;	/* Block descriptor length (MSB) */
 		mode_buf[7] = 0;	/* Block descriptor length (LSB) */
+		aac_internal_transfer(scsicmd, mode_buf, 0, sizeof(mode_buf));
 
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		scsicmd->scsi_done(scsicmd);

-- 
Mark Haverkamp <markh@osdl.org>

