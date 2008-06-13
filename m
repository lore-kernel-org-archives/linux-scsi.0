From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Fri, 13 Jun 2008 14:02:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0806131312340.2166-100000@iolanthe.rowland.org>
References: <8db1092f0806130957r22bf02a4pd5138f67f4ac56dd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:38838 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751954AbYFMSCu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jun 2008 14:02:50 -0400
In-Reply-To: <8db1092f0806130957r22bf02a4pd5138f67f4ac56dd@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 13 Jun 2008, Maciej Rutecki wrote:

> 2008/6/3 Alan Stern <stern@rowland.harvard.edu>:
> [...]
> >
> > What do you think of a patch like this?

...

> > (To refresh your memory: The problem is that a weird device responds to
> > MODE SENSE with Residue equal to the data length -- so none of the
> > returned data is valid -- and Okay status.)
> >
> > Alan Stern

> It does'n help. I still have "write protect is on" message. Also I see
> "usb-storage: queuecommand called" message.

That patch wasn't meant to help; it wasn't complete.  It was meant to 
stimulate conversation -- and clearly it failed.

Below is a complete patch.  It's very ugly and isn't likely to get
accepted, but maybe it will convince people to start talking about the
problem.  Maybe it will offend people's sensibilities so that they will
just _have_ to chime in, if only to complain about how bad the patch
is...

Alan Stern



Index: 2.6.26-rc5/include/linux/blkdev.h
===================================================================
--- 2.6.26-rc5.orig/include/linux/blkdev.h
+++ 2.6.26-rc5/include/linux/blkdev.h
@@ -221,6 +221,7 @@ struct request {
 
 	unsigned int data_len;
 	unsigned int extra_len;	/* length of alignment and padding */
+	unsigned int min_data_len;
 	unsigned int sense_len;
 	void *data;
 	void *sense;
Index: 2.6.26-rc5/include/scsi/scsi_device.h
===================================================================
--- 2.6.26-rc5.orig/include/scsi/scsi_device.h
+++ 2.6.26-rc5/include/scsi/scsi_device.h
@@ -324,9 +324,17 @@ extern int scsi_execute(struct scsi_devi
 			int data_direction, void *buffer, unsigned bufflen,
 			unsigned char *sense, int timeout, int retries,
 			int flag);
+extern int scsi_execute_min(struct scsi_device *sdev, const unsigned char *cmd,
+			int data_direction, void *buffer, unsigned bufflen,
+			unsigned char *sense, int timeout, int retries,
+			int flag, unsigned min_data);
 extern int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
 			    int data_direction, void *buffer, unsigned bufflen,
 			    struct scsi_sense_hdr *, int timeout, int retries);
+extern int scsi_execute_req_min(struct scsi_device *sdev, const unsigned char *cmd,
+			    int data_direction, void *buffer, unsigned bufflen,
+			    struct scsi_sense_hdr *, int timeout, int retries,
+			    unsigned min_data);
 extern int scsi_execute_async(struct scsi_device *sdev,
 			      const unsigned char *cmd, int cmd_len, int data_direction,
 			      void *buffer, unsigned bufflen, int use_sg,
Index: 2.6.26-rc5/drivers/scsi/scsi_lib.c
===================================================================
--- 2.6.26-rc5.orig/drivers/scsi/scsi_lib.c
+++ 2.6.26-rc5/drivers/scsi/scsi_lib.c
@@ -215,6 +215,44 @@ int scsi_execute(struct scsi_device *sde
 }
 EXPORT_SYMBOL(scsi_execute);
 
+int scsi_execute_min(struct scsi_device *sdev, const unsigned char *cmd,
+		 int data_direction, void *buffer, unsigned bufflen,
+		 unsigned char *sense, int timeout, int retries, int flags,
+		 unsigned min_data)
+{
+	struct request *req;
+	int write = (data_direction == DMA_TO_DEVICE);
+	int ret = DRIVER_ERROR << 24;
+
+	req = blk_get_request(sdev->request_queue, write, __GFP_WAIT);
+
+	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
+					buffer, bufflen, __GFP_WAIT))
+		goto out;
+
+	req->cmd_len = COMMAND_SIZE(cmd[0]);
+	memcpy(req->cmd, cmd, req->cmd_len);
+	req->sense = sense;
+	req->sense_len = 0;
+	req->retries = retries;
+	req->timeout = timeout;
+	req->cmd_type = REQ_TYPE_BLOCK_PC;
+	req->cmd_flags |= flags | REQ_QUIET | REQ_PREEMPT;
+	req->min_data_len = min_data;
+
+	/*
+	 * head injection *required* here otherwise quiesce won't work
+	 */
+	blk_execute_rq(req->q, NULL, req, 1);
+
+	ret = req->errors;
+ out:
+	blk_put_request(req);
+
+	return ret;
+}
+EXPORT_SYMBOL(scsi_execute_min);
+
 
 int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
 		     int data_direction, void *buffer, unsigned bufflen,
@@ -238,6 +276,29 @@ int scsi_execute_req(struct scsi_device 
 }
 EXPORT_SYMBOL(scsi_execute_req);
 
+int scsi_execute_req_min(struct scsi_device *sdev, const unsigned char *cmd,
+		     int data_direction, void *buffer, unsigned bufflen,
+		     struct scsi_sense_hdr *sshdr, int timeout, int retries,
+		     unsigned min_data)
+{
+	char *sense = NULL;
+	int result;
+
+	if (sshdr) {
+		sense = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
+		if (!sense)
+			return DRIVER_ERROR << 24;
+	}
+	result = scsi_execute_min(sdev, cmd, data_direction, buffer, bufflen,
+			      sense, timeout, retries, 0, min_data);
+	if (sshdr)
+		scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, sshdr);
+
+	kfree(sense);
+	return result;
+}
+EXPORT_SYMBOL(scsi_execute_req_min);
+
 struct scsi_io_context {
 	void *data;
 	void (*done)(void *data, char *sense, int result, int resid);
@@ -1125,6 +1186,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_d
 		ret = scsi_init_io(cmd, GFP_ATOMIC);
 		if (unlikely(ret))
 			return ret;
+		cmd->underflow = req->min_data_len;
 	} else {
 		BUG_ON(req->data_len);
 		BUG_ON(req->data);
@@ -1879,8 +1941,8 @@ scsi_mode_sense(struct scsi_device *sdev
 
 	memset(buffer, 0, len);
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
-				  sshdr, timeout, retries);
+	result = scsi_execute_req_min(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
+				  sshdr, timeout, retries, header_length);
 
 	/* This code looks awful: what it's doing is making sure an
 	 * ILLEGAL REQUEST sense return identifies the actual command

