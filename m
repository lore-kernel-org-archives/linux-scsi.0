From: Jens Axboe <axboe@suse.de>
Subject: Re: Fw: PROBLEM: Linux V. 2.6.3 panics with "Buffers at physical address >16Mb used for aha1542" at boot time
Date: Mon, 23 Feb 2004 17:48:11 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040223164811.GK32010@suse.de>
References: <20040218171212.0eb6618a.akpm@osdl.org> <1077243517.2164.61.camel@mulgrave> <1077265837.1297.9.camel@felicia> <20040220083808.GA11822@suse.de> <1077300620.1937.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:27881 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261956AbUBWQsg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 11:48:36 -0500
Content-Disposition: inline
In-Reply-To: <1077300620.1937.11.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Dr. Ernst Molitor" <molitor@uni-bonn.de>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Feb 20 2004, James Bottomley wrote:
> On Fri, 2004-02-20 at 00:38, Jens Axboe wrote:
> > Hmm... James, sr_do_ioctl() used to do bouncing for private commands,
> > any reason it doesn't do that anymore?
> 
> OK, I've looked through the file history, I can't find anywhere that it
> used to do this.
> 
> However, the true solution is to see if we can get scsi_wait_req to go
> through the sg_io code path...that way the block layer will bounce for
> us and we can kill the use_sg == 0 code path in all the drivers.

The SCSI code is still pretty fucked up wrt clean use of struct
request... REQ_SPECIAL should just mean that ->special is assigned (and
holds a struct scsi_request), not be a request type on its own. That
fact alone makes it impossible to cleanly do REQ_BLOCK_PC conversions.
Add to that, that gendisk are inside the drivers and it's even worse.

Something half-assed like this should work as an immediate fix...

===== drivers/scsi/scsi_lib.c 1.118 vs edited =====
--- 1.118/drivers/scsi/scsi_lib.c	Mon Feb  2 17:14:22 2004
+++ edited/drivers/scsi/scsi_lib.c	Mon Feb 23 17:44:09 2004
@@ -954,7 +960,8 @@
 			cmd = scsi_get_command(sreq->sr_device, GFP_ATOMIC);
 			if (unlikely(!cmd))
 				goto defer;
-			scsi_init_cmd_from_req(cmd, sreq);
+			if (!blk_pc_request(req))
+				scsi_init_cmd_from_req(cmd, sreq);
 		} else
 			cmd = req->special;
 	} else if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
===== drivers/scsi/sr.c 1.98 vs edited =====
--- 1.98/drivers/scsi/sr.c	Mon Feb  9 21:59:10 2004
+++ edited/drivers/scsi/sr.c	Mon Feb 23 15:03:57 2004
@@ -557,20 +559,22 @@
 
 	sdev->sector_size = 2048;	/* A guess, just in case */
 
-	/* FIXME: need to handle a get_capabilities failure properly ?? */
-	get_capabilities(cd);
-	sr_vendor_init(cd);
-
 	snprintf(disk->devfs_name, sizeof(disk->devfs_name),
 			"%s/cd", sdev->devfs_name);
 	disk->driverfs_dev = &sdev->sdev_gendev;
-	register_cdrom(&cd->cdi);
 	set_capacity(disk, cd->capacity);
 	disk->private_data = &cd->driver;
 	disk->queue = sdev->request_queue;
 
 	dev_set_drvdata(dev, cd);
 	add_disk(disk);
+
+	/* FIXME: need to handle a get_capabilities failure properly ?? */
+	get_capabilities(cd);
+	sr_vendor_init(cd);
+
+	if (register_cdrom(&cd->cdi))
+		goto fail_put;
 
 	printk(KERN_DEBUG
 	    "Attached scsi CD-ROM %s at scsi%d, channel %d, id %d, lun %d\n",
===== drivers/scsi/sr_ioctl.c 1.31 vs edited =====
--- 1.31/drivers/scsi/sr_ioctl.c	Mon Aug 25 15:37:40 2003
+++ edited/drivers/scsi/sr_ioctl.c	Mon Feb 23 17:44:44 2004
@@ -90,14 +90,35 @@
         }
 	SRpnt->sr_data_direction = cgc->data_direction;
 
+	/* map cgc to a REQ_BLOCK_PC command. in the future cgc will
+	 * disappear, the uniform layer can place REQ_BLOCK_PC commands
+	 * directly on ide-cd/sr target queues
+	 */
+	req = SRpnt->sr_request;
+
+	req->cmd_len = COMMAND_SIZE(cgc->cmd[0]);
+	memcpy(req->cmd, cgc->cmd, req->cmd_len);
+	req->data = cgc->buffer;
+	req->data_len = cgc->buflen;
+	req->timeout = cgc->timeout;
+	req->sense = SRpnt->sr_sense_buffer;
+	req->sense_len = 0;
+	if (cgc->quiet)
+		req->flags |= REQ_QUIET;
+	if (cgc->data_direction == CGC_DATA_WRITE)
+		req->flags |= REQ_RW;
+	req->flags |= REQ_BLOCK_PC;
+	req->rq_disk = cd->disk;
+
       retry:
 	if (!scsi_block_when_processing_errors(SDev)) {
 		err = -ENODEV;
 		goto out_free;
 	}
 
-	scsi_wait_req(SRpnt, cgc->cmd, cgc->buffer, cgc->buflen,
-		      cgc->timeout, IOCTL_RETRIES);
+	/* we have no real use of the passed in data pointers... */
+	scsi_wait_req(SRpnt, req->cmd, req->data, req->data_len,
+		      req->timeout, IOCTL_RETRIES);
 
 	req = SRpnt->sr_request;
 	if (SRpnt->sr_buffer && req->buffer && SRpnt->sr_buffer != req->buffer) {


-- 
Jens Axboe

