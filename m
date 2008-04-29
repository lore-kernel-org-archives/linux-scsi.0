From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/6] add large command support to the block layer
Date: Tue, 29 Apr 2008 21:32:33 +0900
Message-ID: <20080429213325P.tomof@acm.org>
References: <1209140607-28654-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080429075424.GF12774@kernel.dk>
	<58cb370e0804290455m3892d5efi6ab293075f8277ca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:37367 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbYD2Meo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2008 08:34:44 -0400
In-Reply-To: <58cb370e0804290455m3892d5efi6ab293075f8277ca@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, bzolnier@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, bharrosh@panasas.com, James.Bottomley@hansenpartnership.com, agk@redhat.com, Geert.Uytterhoeven@sonycom.com

On Tue, 29 Apr 2008 13:55:13 +0200
"Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com> wrote:

> On Tue, Apr 29, 2008 at 9:54 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> >
> > On Sat, Apr 26 2008, FUJITA Tomonori wrote:
> >  > This is an updated patchset for large command support to the block
> >  > layer:
> >  >
> >  > http://marc.info/?l=linux-scsi&m=120817127118449&w=2
> >  >
> >  > We rarely handle large commands. So for optimization, a struct request
> >  > still has a static array for a command. rq_init sets rq->cmd pointer
> >  > to the static array. In short, rq_init() does
> >  >
> >  > rq->cmd = rq->__cmd;
> >  >
> >  > So we can access to rq->cmd and rq->cmd_len as before.
> >  >
> >  > This change requires everyone to initialize the request in a proper
> >  > way (that is, just doing a memset() will not work). Now we have
> >  > rq_init() that works for any path so this patchset can cleanly convert
> >  > users of requests on the stack or kmalloced requests to use it (the
> >  > previous patchset does it in a hacky way):
> >  >
> >  > http://marc.info/?l=linux-scsi&m=120911792725876&w=2
> >  >
> >  > This patchset is against Jens' for-linus branch.
> >  >
> >  > #1-#4 patches can be applied via Jens' tree now. #5 patch is for
> >  > IDE. It cleanly can be applied to both Bart's latest quilt tree and
> >  > Jens' tree though Bart's quilt tree has some pending IDE patches. #4
> >  > patch depends on #4. #6 patch depends on #1-#5.
> >  >
> >  > I guess that the easiest way to apply this patchset would be:
> >  >
> >  > 1. Pushing Bart's quilt tree to mainline.
> >  > 2. Rebasing Jens' tree to mainline.
> >  > 3. Pushing this patchset via Jens' tree.
> >  >
> >  > Jens and Bart, let me know if I can do something to make the process
> >  > easier.
> >  >
> >  > Bart, I will try to push the patchset to remove the requests on the
> >  > stack for 2.6.27:
> >  >
> >  > http://marc.info/?l=linux-ide&m=120882410712466&w=2
> >
> >  I've applied all patches to the for-linus branch, it should go up
> >  soonish. If anyone has problems with this, please holler SOON.
> 
> Fine with me (patches look good and survived quick testing).

Thanks,


> My only concern is that the final series from Tomo lacked
> 
> 	"block: replace sizeof(rq->cmd) with BLK_MAX_CDB"
> 
> and it is also not in for-linus branch (it has to be merged
> before "block: add large command support" patch or ide-cd
> will break).

Sorry, somehow I forgot to put it in the patchset. Yeah, probabaly
initializing only 4 (or 8) bytes in rq->cmd would not work for ide-cd.

Jens, please put this to the for-linus branch.

==
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: replace sizeof(rq->cmd) with BLK_MAX_CDB

This is a preparation for changing rq->cmd from the static array to a
pointer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c             |    2 +-
 drivers/ide/ide-cd.c         |    4 ++--
 drivers/ide/ide-cd_verbose.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 35ae1c0..abe5b9f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -174,7 +174,7 @@ void blk_dump_rq_flags(struct request *rq, char *msg)
 
 	if (blk_pc_request(rq)) {
 		printk(KERN_INFO "  cdb: ");
-		for (bit = 0; bit < sizeof(rq->cmd); bit++)
+		for (bit = 0; bit < BLK_MAX_CDB; bit++)
 			printk("%02x ", rq->cmd[bit]);
 		printk("\n");
 	}
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index fe9df38..68e7f19 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -782,7 +782,7 @@ static ide_startstop_t cdrom_start_seek_continuation(ide_drive_t *drive)
 
 	sector_div(frame, queue_hardsect_size(drive->queue) >> SECTOR_BITS);
 
-	memset(rq->cmd, 0, sizeof(rq->cmd));
+	memset(rq->cmd, 0, BLK_MAX_CDB);
 	rq->cmd[0] = GPCMD_SEEK;
 	put_unaligned(cpu_to_be32(frame), (unsigned int *) &rq->cmd[2]);
 
@@ -1694,7 +1694,7 @@ static int ide_cdrom_prep_fs(struct request_queue *q, struct request *rq)
 	long block = (long)rq->hard_sector / (hard_sect >> 9);
 	unsigned long blocks = rq->hard_nr_sectors / (hard_sect >> 9);
 
-	memset(rq->cmd, 0, sizeof(rq->cmd));
+	memset(rq->cmd, 0, BLK_MAX_CDB);
 
 	if (rq_data_dir(rq) == READ)
 		rq->cmd[0] = GPCMD_READ_10;
diff --git a/drivers/ide/ide-cd_verbose.c b/drivers/ide/ide-cd_verbose.c
index 6ed7ca0..6490a2d 100644
--- a/drivers/ide/ide-cd_verbose.c
+++ b/drivers/ide/ide-cd_verbose.c
@@ -326,7 +326,7 @@ void ide_cd_log_error(const char *name, struct request *failed_command,
 
 		printk(KERN_ERR "  The failed \"%s\" packet command "
 				"was: \n  \"", s);
-		for (i = 0; i < sizeof(failed_command->cmd); i++)
+		for (i = 0; i < BLK_MAX_CDB; i++)
 			printk(KERN_CONT "%02x ", failed_command->cmd[i]);
 		printk(KERN_CONT "\"\n");
 	}
-- 
1.5.4.2


