From: Douglas Gilbert <dougg@torque.net>
Subject: Re: ide-scsi error handling
Date: Tue, 20 May 2003 21:24:49 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ECA1081.805@torque.net>
References: <20030518230706.GA19202@linnie.riede.org> <3EC8D5A3.8020600@torque.net> <20030519234254.GG19202@linnie.riede.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050101080607040309050008"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:43268 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263711AbTETLLE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2003 07:11:04 -0400
In-Reply-To: <20030519234254.GG19202@linnie.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: wrlk@riede.org
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050101080607040309050008
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Willem Riede wrote:
> On 2003.05.19 09:01, Douglas Gilbert wrote:
> 
>>Debug: sleeping function called from illegal context at include/linux/rwsem.h:43
>>Call Trace:
>> [<c011f92c>] __might_sleep+0x5c/0x5e
>> [<c011b2d8>] do_page_fault+0x78/0x4a8
>> [<e0823c4b>] idescsi_transfer_pc+0xfb/0x130 [ide_scsi]
> 
> 
> A page fault while in idescsi_transfer_pc?!
> What memory would be accessed that is allowed to be paged out?
> 
> By the way, I have never seen that problem. When ide-scsi fails for me, it
> is in the same way Randy reports. While my change improves mean-time-to-hang
> significantly on my machine, it obviously doesn't for Randy. Back to the
> drawing board :-(

Willem,
When I tried today, my test went for a while then
failed with a timeout and an abort lockup (which
you reported as fixed but I don't have that fix):
   hdb: irq timeout: status=0xd0 { Busy }
   ide-scsi: abort called for 330982
   hdb: ATAPI reset complete
  <<machine lockup, alt-sysrq inactive>>

Attached is a patch to idescsi_queue(). Won't fix the
problems we are seeing now. Changes:
   - returns 0 on error (not 1 which means "busy")
   - yield DID_NO_CONNECT for channel, id or lun
     invalid (this should fix the "responding to
     multiple lun" problem often seen in lk 2.4
   - memset the whole of pc and rq to zero

Doug Gilbert



--------------050101080607040309050008
Content-Type: text/plain;
 name="ide-scsi2569bk13wr_d1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ide-scsi2569bk13wr_d1.diff"

--- linux/drivers/scsi/ide-scsi.c	2003-05-19 12:30:34.000000000 +1000
+++ linux/drivers/scsi/ide-scsi.c2569bk13wr_d1	2003-05-20 20:30:46.000000000 +1000
@@ -795,11 +795,20 @@
 
 static int idescsi_queue (Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
 {
+	struct scsi_device * sdev = cmd->device;
 	idescsi_scsi_t *scsi = scsihost_to_idescsi(cmd->device->host);
 	ide_drive_t *drive = scsi->drive;
 	struct request *rq = NULL;
 	idescsi_pc_t *pc = NULL;
 
+	if ((sdev->channel > 0) ||
+	    (sdev->id >= sdev->host->max_id) ||
+	    (sdev->lun >= sdev->host->max_lun)) {
+		printk(KERN_INFO "ide-scsi: channel:id:lun %d:%d:%d not "
+		       "present\n", sdev->channel, sdev->id, sdev->lun);
+		cmd->result = DID_NO_CONNECT << 16;
+		goto abort1;
+	}
 	if (!drive) {
 		printk (KERN_ERR "ide-scsi: drive id %d not present\n", cmd->device->id);
 		goto abort;
@@ -811,9 +820,8 @@
 		printk (KERN_ERR "ide-scsi: %s: out of memory\n", drive->name);
 		goto abort;
 	}
-
-	memset (pc->c, 0, 12);
-	pc->flags = 0;
+	memset(pc, 0, sizeof(idescsi_pc_t));
+	memset(rq, 0, sizeof(struct request));
 	pc->rq = rq;
 	memcpy (pc->c, cmd->cmnd, cmd->cmd_len);
 	if (cmd->use_sg) {
@@ -846,16 +854,17 @@
 	rq->special = (char *) pc;
 	rq->bio = idescsi_dma_bio (drive, pc);
 	rq->flags = REQ_SPECIAL;
-	spin_unlock_irq(cmd->device->host->host_lock);
+	spin_unlock_irq(sdev->host->host_lock);
 	(void) ide_do_drive_cmd (drive, rq, ide_end);
-	spin_lock_irq(cmd->device->host->host_lock);
+	spin_lock_irq(sdev->host->host_lock);
 	return 0;
 abort:
+	cmd->result = DID_ERROR << 16;
+abort1:
 	if (pc) kfree (pc);
 	if (rq) kfree (rq);
-	cmd->result = DID_ERROR << 16;
 	done(cmd);
-	return 1;
+	return 0;
 }
 
 static int idescsi_scsi_eh_abort (Scsi_Cmnd *cmd)

--------------050101080607040309050008--

