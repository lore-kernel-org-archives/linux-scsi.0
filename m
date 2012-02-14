From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: Yet another hot unplug NULL pointer dereference (was Re: status
 of oops in sd_revalidate_disk?)
Date: Tue, 14 Feb 2012 20:34:53 +0900
Message-ID: <4F3A46DD.8030305@ce.jp.nec.com>
References: <4EE8E419.8010000@pre-sense.de> <CA+v9cxZFUC45WD0=+8mvH2Tq_xvX3PgaW4ttzPep0jqvqab_6w@mail.gmail.com> <20111225215804.03ef9402@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:57727 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab2BNLfm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2012 06:35:42 -0500
In-Reply-To: <20111225215804.03ef9402@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, jbottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Huajun Li <huajun.li.lee@gmail.com>, Axel Theilmann <theilmann@pre-sense.de>, linux-kernel@vger.kernel.org

On 12/26/11 05:58, Stefan Richter wrote:
> First I tested a FireWire drive and got the first log which is included
> below, instantly in two attempts.  Then I made two attempts with a USB
> CD-ROM which did not oops immediately at device removal but when I then
> hit the eject button in the still open grip.  This consistently produced
> the second log at the end of this post.
> 
> First test with 1394 CD-ROM:
> -----------------------------------------------------------------
>   - attach CD-ROM drive
> -----------------------------------------------------------------
> scsi4 : SBP-2 IEEE-1394
> firewire_sbp2 fw1.0: logged in to LUN 0000 (0 retries)
> scsi 4:0:0:0: CD-ROM		TEAC	 CD-W28E	  1.1A PQ: 0 ANSI: 0 CCS
> sr1: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
> sr 4:0:0:0: Attached scsi CD-ROM sr1
> -----------------------------------------------------------------
>   - start grip
>   - detach CD-ROM drive
> -----------------------------------------------------------------
> sr 4:0:0:0: Attached scsi generic sg2 type 5
> scsi 4:0:0:0: killing request
> BUG: unable to handle kernel NULL pointer dereference at 000003f0
> IP: [<c11bc19f>] scsi_prep_state_check+0x6/0x68
> *pde = 00000000 
> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> Modules linked in: firewire_sbp2 firewire_ohci firewire_core netconsole snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss nfs lockd sunrpc i2c_i801 applesmc sr_mod rtc sg input_polldev cdrom snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_pcm snd_timer snd sky2 snd_page_alloc
> 
> Pid: 2832, comm: grip Not tainted 3.2.0-rc7 #1 Apple Computer, Inc. Macmini1,1/Mac-F4208EC8
> EIP: 0060:[<c11bc19f>] EFLAGS: 00010046 CPU: 0
> EIP is at scsi_prep_state_check+0x6/0x68
> EAX: 00000000 EBX: f33f3f18 ECX: 00000000 EDX: f33f3f18
> ESI: f4815a68 EDI: 00000000 EBP: f160bc14 ESP: f160bc10
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process grip (pid: 2832, ti=f160a000 task=f5d48760 task.ti=f160a000)
> Stack:
>  f33f3f18 f160bc2c c11bc8b1 f160bc3c f33f3f18 f4815a68 f33f3f18 f160bc3c
>  c11bc9a5 f33f3f18 f4815a68 f160bc50 c10efad5 00000000 f33f3f18 f4815a68
>  f160bc78 c11bd09f f4815db0 f33f3f18 00000001 f33f3f18 f4815a68 f4815a68
> 
> Call Trace:
>  [<c11bc8b1>] scsi_setup_blk_pc_cmnd+0x12/0xe7
>  [<c11bc9a5>] scsi_prep_fn+0x1f/0x2e
>  [<c10efad5>] blk_peek_request+0x98/0x168
>  [<c11bd09f>] scsi_request_fn+0x23/0x3b5
>  [<c10ed9d6>] __blk_run_queue+0x14/0x16
>  [<c10f25d5>] blk_execute_rq_nowait+0x7d/0x98
>  [<c10f2697>] blk_execute_rq+0xa7/0xe8
>  [<c10f2530>] ? blk_rq_map_user+0x1b7/0x1b7
>  [<c10f8c81>] ? changed_ioprio+0x70/0x70
>  [<c10ed700>] ? elv_set_request+0x12/0x20
>  [<c10eeebd>] ? get_request+0x21e/0x2bb
>  [<c11bcad2>] scsi_execute+0xc4/0x10a
>  [<c11bcb6c>] scsi_execute_req+0x54/0x81
>  [<c11bcbea>] scsi_test_unit_ready+0x51/0xb2
>  [<f828248b>] sr_drive_status+0x33/0xd5 [sr_mod]
>  [<f81f7860>] cdrom_ioctl+0x6a9/0xb31 [cdrom]
>  [<c1279f36>] ? mutex_lock_nested+0x26c/0x2b0
>  [<c10231e5>] ? get_parent_ip+0xb/0x31
>  [<c1023287>] ? sub_preempt_count+0x7c/0x89
>  [<c1279f5f>] ? mutex_lock_nested+0x295/0x2b0
>  [<f82815f1>] ? sr_block_ioctl+0x2e/0x9a [sr_mod]
>  [<f8281612>] sr_block_ioctl+0x4f/0x9a [sr_mod]
>  [<f82815c3>] ? sr_block_check_events+0x13/0x13 [sr_mod]
>  [<c10f39ee>] __blkdev_driver_ioctl+0x22/0x2e
>  [<c10f42f5>] blkdev_ioctl+0x66d/0x68c
>  [<c104bf7e>] ? __lock_acquire+0x62e/0x14bb
>  [<c10b1861>] block_ioctl+0x32/0x3a
>  [<c10b1861>] ? block_ioctl+0x32/0x3a
>  [<c10b182f>] ? bd_set_size+0x67/0x67
>  [<c109bfd5>] do_vfs_ioctl+0x481/0x4b7
>  [<c1090993>] ? fget_light+0x4c/0xd0
>  [<c109c039>] sys_ioctl+0x2e/0x49
>  [<c127bb50>] sysenter_do_call+0x12/0x36

While scsi_device is propery refcounted object,
q->queuedata is set to NULL by scsi_remove_device() asynchronously.
So every reader of scsi_device's q->queuedata should always check it.

Though I don't have a machine to actually test it,
the following patch should remove such places.

Index: linux-3.3/drivers/scsi/scsi_lib.c
===================================================================
--- linux-3.3.orig/drivers/scsi/scsi_lib.c	2012-02-01 06:31:54.000000000 +0900
+++ linux-3.3/drivers/scsi/scsi_lib.c	2012-02-14 19:12:57.641216402 +0900
@@ -1214,10 +1214,8 @@ int scsi_prep_state_check(struct scsi_de
 }
 EXPORT_SYMBOL(scsi_prep_state_check);
 
-int scsi_prep_return(struct request_queue *q, struct request *req, int ret)
+int scsi_prep_return(struct request_queue *q, struct scsi_device *sdev, struct request *req, int ret)
 {
-	struct scsi_device *sdev = q->queuedata;
-
 	switch (ret) {
 	case BLKPREP_KILL:
 		req->errors = DID_NO_CONNECT << 16;
@@ -1251,9 +1249,11 @@ int scsi_prep_fn(struct request_queue *q
 	struct scsi_device *sdev = q->queuedata;
 	int ret = BLKPREP_KILL;
 
+	if (!sdev)
+		return ret;
 	if (req->cmd_type == REQ_TYPE_BLOCK_PC)
 		ret = scsi_setup_blk_pc_cmnd(sdev, req);
-	return scsi_prep_return(q, req, ret);
+	return scsi_prep_return(q, sdev, req, ret);
 }
 EXPORT_SYMBOL(scsi_prep_fn);
 
Index: linux-3.3/drivers/scsi/sd.c
===================================================================
--- linux-3.3.orig/drivers/scsi/sd.c	2012-02-13 13:02:14.000000000 +0900
+++ linux-3.3/drivers/scsi/sd.c	2012-02-14 19:15:18.224212107 +0900
@@ -653,6 +653,9 @@ static int sd_prep_fn(struct request_que
 	int ret, host_dif;
 	unsigned char protect;
 
+	if (!sdp)
+		return BLKPREP_KILL;
+
 	/*
 	 * Discard request come in as REQ_TYPE_FS but we turn them into
 	 * block PC requests to make life easier.
@@ -905,7 +908,7 @@ static int sd_prep_fn(struct request_que
 	 */
 	ret = BLKPREP_OK;
  out:
-	return scsi_prep_return(q, rq, ret);
+	return scsi_prep_return(q, sdp, rq, ret);
 }
 
 /**
Index: linux-3.3/drivers/scsi/sr.c
===================================================================
--- linux-3.3.orig/drivers/scsi/sr.c	2012-02-01 06:31:54.000000000 +0900
+++ linux-3.3/drivers/scsi/sr.c	2012-02-14 19:15:59.001211143 +0900
@@ -372,6 +372,9 @@ static int sr_prep_fn(struct request_que
 	struct scsi_device *sdp = q->queuedata;
 	int ret;
 
+	if (!sdp)
+		return BLKPREP_KILL;
+
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
 		goto out;
@@ -503,7 +506,7 @@ static int sr_prep_fn(struct request_que
 	 */
 	ret = BLKPREP_OK;
  out:
-	return scsi_prep_return(q, rq, ret);
+	return scsi_prep_return(q, sdp, rq, ret);
 }
 
 static int sr_block_open(struct block_device *bdev, fmode_t mode)
Index: linux-3.3/include/scsi/scsi_driver.h
===================================================================
--- linux-3.3.orig/include/scsi/scsi_driver.h	2012-02-01 06:31:54.000000000 +0900
+++ linux-3.3/include/scsi/scsi_driver.h	2012-02-14 19:16:47.478209843 +0900
@@ -31,7 +31,7 @@ extern int scsi_register_interface(struc
 int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req);
 int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req);
 int scsi_prep_state_check(struct scsi_device *sdev, struct request *req);
-int scsi_prep_return(struct request_queue *q, struct request *req, int ret);
+int scsi_prep_return(struct request_queue *q, struct scsi_device *sdev, struct request *req, int ret);
 int scsi_prep_fn(struct request_queue *, struct request *);
 
 #endif /* _SCSI_SCSI_DRIVER_H */
