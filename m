From: Brian King <brking@us.ibm.com>
Subject: Re: drivers/block/scsi_ioctl problem
Date: Wed, 15 Dec 2004 16:44:14 -0600
Message-ID: <41C0BE3E.3060003@us.ibm.com>
References: <41BF7C18.9090303@us.ibm.com> <20041215071852.GM3157@suse.de> <41C08CD5.10309@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050808050800090901060407"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:43660 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S262521AbULOWoQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Dec 2004 17:44:16 -0500
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.195.10])
	by e31.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id iBFMiFjd531046
	for <linux-scsi@vger.kernel.org>; Wed, 15 Dec 2004 17:44:15 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay01.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iBFMiFB4229974
	for <linux-scsi@vger.kernel.org>; Wed, 15 Dec 2004 15:44:15 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id iBFMiE3T016109
	for <linux-scsi@vger.kernel.org>; Wed, 15 Dec 2004 15:44:15 -0700
In-Reply-To: <41C08CD5.10309@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050808050800090901060407
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Brian King wrote:
>> It was added to be able to find out which opcode was rejected and thus
>> caused an application malfunction. It dumps the specific opcode only
>> once, is that such a huge problem?
> 
> 
> Ok. I didn't realize that it was only dumped once. That's not as bad. I 
> guess it might be better if it were only dumped if the op actually failed.

How about something like this...

--------------050808050800090901060407
Content-Type: text/plain;
 name="blk_scsi_ioctl_unknown_cmd.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="blk_scsi_ioctl_unknown_cmd.patch"


Currently if an SG_IO ioctl is issued to a block device with an
unknown opcode, an error is logged. This error is logged regardless
the device successfully processes the command or not. This results in
an error getting logged for each unknown opcode ever issued. This patch
changes this policy and only prints the unknown opcode if the command
fails.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.10-rc3-bk8-bjking1/drivers/block/scsi_ioctl.c |   19 +++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff -puN drivers/block/scsi_ioctl.c~blk_scsi_ioctl_unknown_cmd drivers/block/scsi_ioctl.c
--- linux-2.6.10-rc3-bk8/drivers/block/scsi_ioctl.c~blk_scsi_ioctl_unknown_cmd	2004-12-15 14:19:34.000000000 -0600
+++ linux-2.6.10-rc3-bk8-bjking1/drivers/block/scsi_ioctl.c	2004-12-15 14:55:04.000000000 -0600
@@ -111,7 +111,7 @@ static int sg_emulated_host(request_queu
 #define safe_for_read(cmd)	[cmd] = CMD_READ_SAFE
 #define safe_for_write(cmd)	[cmd] = CMD_WRITE_SAFE
 
-static int verify_command(struct file *file, unsigned char *cmd)
+static int __verify_command(struct file *file, unsigned char *cmd, int logging)
 {
 	static unsigned char cmd_type[256] = {
 
@@ -199,7 +199,7 @@ static int verify_command(struct file *f
 			return 0;
 	}
 
-	if (!(type & CMD_WARNED)) {
+	if (logging && !(type & CMD_WARNED)) {
 		cmd_type[cmd[0]] = CMD_WARNED;
 		printk(KERN_WARNING "scsi: unknown opcode 0x%02x\n", cmd[0]);
 	}
@@ -212,6 +212,16 @@ static int verify_command(struct file *f
 	return -EPERM;
 }
 
+static int verify_command(struct file *file, unsigned char *cmd)
+{
+	return __verify_command(file, cmd, 0);
+}
+
+static void log_unknown_opcode(struct file *file, unsigned char *cmd)
+{
+	__verify_command(file, cmd, 1);
+}
+
 static int sg_io(struct file *file, request_queue_t *q,
 		struct gendisk *bd_disk, struct sg_io_hdr *hdr)
 {
@@ -307,8 +317,10 @@ static int sg_io(struct file *file, requ
 	hdr->host_status = host_byte(rq->errors);
 	hdr->driver_status = driver_byte(rq->errors);
 	hdr->info = 0;
-	if (hdr->masked_status || hdr->host_status || hdr->driver_status)
+	if (hdr->masked_status || hdr->host_status || hdr->driver_status) {
 		hdr->info |= SG_INFO_CHECK;
+		log_unknown_opcode(file, cmd);
+	}
 	hdr->resid = rq->data_len;
 	hdr->duration = ((jiffies - start_time) * 1000) / HZ;
 	hdr->sb_len_wr = 0;
@@ -415,6 +427,7 @@ static int sg_scsi_ioctl(struct file *fi
 	blk_execute_rq(q, bd_disk, rq);
 	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
+		log_unknown_opcode(file, rq->cmd);
 		if (rq->sense_len && rq->sense) {
 			bytes = (OMAX_SB_LEN > rq->sense_len) ?
 				rq->sense_len : OMAX_SB_LEN;
_

--------------050808050800090901060407--
