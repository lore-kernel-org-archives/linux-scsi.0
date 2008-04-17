From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 4/4] block: add large command support
Date: Thu, 17 Apr 2008 21:07:32 +0900
Message-ID: <20080417210730T.tomof@acm.org>
References: <4805C209.6040606@panasas.com>
	<20080417123218V.tomof@acm.org>
	<20080417070704.GO12774@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:53613 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbYDQMIQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Apr 2008 08:08:16 -0400
In-Reply-To: <20080417070704.GO12774@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, bzolnier@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com

On Thu, 17 Apr 2008 09:07:05 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Apr 17 2008, FUJITA Tomonori wrote:
> > On Wed, 16 Apr 2008 12:08:25 +0300
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> > > On Wed, Apr 16 2008 at 11:33 +0300, Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > On Wed, Apr 16 2008, FUJITA Tomonori wrote:
> > > >> On Wed, 16 Apr 2008 00:50:54 +0200
> > > >> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > > >>
> > > >>> Hi,
> > > >>>
> > > >>> On Monday 14 April 2008, Jens Axboe wrote:
> > > >>>> On Mon, Apr 14 2008, FUJITA Tomonori wrote:
> > > >>>>> This patch changes rq->cmd from the static array to a pointer to
> > > >>>>> support large commands.
> > > >>>>>
> > > >>>>> We rarely handle large commands. So for optimization, a struct request
> > > >>>>> still has a static array for a command. rq_init sets rq->cmd pointer
> > > >>>>> to the static array.
> > > >>>>>
> > > >>>>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > >>>>> Cc: Jens Axboe <jens.axboe@oracle.com>
> > > >>>>> ---
> > > >>>>>  block/blk-core.c       |    1 +
> > > >>>>>  drivers/ide/ide-io.c   |    1 +
> > > >>>>>  include/linux/blkdev.h |   12 ++++++++++--
> > > >>>>>  3 files changed, 12 insertions(+), 2 deletions(-)
> > > >>>>>
> > > >>>>> diff --git a/block/blk-core.c b/block/blk-core.c
> > > >>>>> index 6669238..6f0968f 100644
> > > >>>>> --- a/block/blk-core.c
> > > >>>>> +++ b/block/blk-core.c
> > > >>>>> @@ -132,6 +132,7 @@ void rq_init(struct request_queue *q, struct request *rq)
> > > >>>>>  	rq->errors = 0;
> > > >>>>>  	rq->ref_count = 1;
> > > >>>>>  	rq->cmd_len = 0;
> > > >>>>> +	rq->cmd = rq->__cmd;
> > > >>>>>  	memset(rq->cmd, 0, BLK_MAX_CDB);
> > > >>>>>  	rq->data_len = 0;
> > > >>>>>  	rq->extra_len = 0;
> > > >>>>> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> > > >>>>> index 7153796..bac5ea1 100644
> > > >>>>> --- a/drivers/ide/ide-io.c
> > > >>>>> +++ b/drivers/ide/ide-io.c
> > > >>>>> @@ -1595,6 +1595,7 @@ void ide_init_drive_cmd (struct request *rq)
> > > >>>>>  {
> > > >>>>>  	memset(rq, 0, sizeof(*rq));
> > > >>>>>  	rq->ref_count = 1;
> > > >>>>> +	rq->cmd = rq->__cmd;
> > > >>>>>  }
> > > >>> Tomo, some more changes are needed:
> > > >>>
> > > >>> Please think about all _static_/dynamic allocations of 'struct request'
> > > >>> used together with REQ_TYPE_SPECIAL etc., i.e.
> > > >> I think that using struct request allocated statically is wrong from
> > > >> the perspective of the block layer design, that is, you always need to
> > > >> use blk_get_request. I think that except ide, everyone does.
> > > >>
> > > >> I try to convert ide to use blk_get_request properly if you want.
> > > > 
> > > > That would be best, but the on-stack allocation has the benefit that
> > > > it'll always work. So until we can completely get rid of that, lets just
> > > > make it a hard rule that ANY rq allocation MUST call rq_init(). It's a
> > > > lot saner than doing a memset() anyway.
> > > > 
> > > 
> > > Just a patch that I had for ages since the bad old request bidi times,
> > > perhaps is also good today. (rebased to for-2.6.26 branch)
> > > ---
> > > From: Boaz Harrosh <bharrosh@panasas.com>
> > > Date: Wed, 16 Apr 2008 12:05:33 +0300
> > > Subject: [PATCH] Initialize all members of struct request in rq_init
> > > 
> > > Before, every member added/removed from struct request would entitle a change
> > > to rq_init, for initialization. Now all members are default to zero and only
> > > the none zero members are specifically initialized.
> > > 
> > > Users that need requests on the stack or pre-allocated, must call rq_init()
> > > before use.
> > > 
> > > Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> > > ---
> > >  block/blk-core.c |   22 ++--------------------
> > >  1 files changed, 2 insertions(+), 20 deletions(-)
> > > 
> > > diff --git a/block/blk-core.c b/block/blk-core.c
> > > index 6f0968f..3f4c563 100644
> > > --- a/block/blk-core.c
> > > +++ b/block/blk-core.c
> > > @@ -113,36 +113,18 @@ EXPORT_SYMBOL(blk_get_backing_dev_info);
> > >   */
> > >  void rq_init(struct request_queue *q, struct request *rq)
> > >  {
> > > +	memset(rq, 0, sizeof(*rq));
> > 
> > Hmm, rq_init comment says:
> > 
> > /*
> >  * We can't just memset() the structure, since the allocation path
> >  * already stored some information in the request.
> >  */
> > 
> > I think that we can't initialize rq->cmd_flags here.
> 
> That is correct, the patch wont work as-is. The principle of clearing
> every member except block internal is sound and should be applied,
> though.

1) calls rq_init() and initializes rq->cmd_flags manually.
2) adds a new helper function to just memset() against rq.
3) modifies the block layer so that rq_init() can memset() against rq.
4) uses blk_get_request

I think that the second option would be the best for now but I don't
have a good name for such function.

The third or fourth option looks preferable for me in the long term
(probably, for 2.6.27).

Here's a patch to initialize rq->cmd by hand. I think that it's ok for
now.

drivers/scsi_errro.c doesn't need this hack now (since it doesn't use
struct request) but pending Boaz's extended cdbs patch needs this hack
since it removes scmd->cmnd array and uses rq->cmd.

===
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: initialize the cmd pointer in struct request

struct request that is not allocated via blk_get_request needs to
set up the cmd pointer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/block/nbd.c        |    3 +++
 drivers/block/paride/pd.c  |    1 +
 drivers/ide/ide-tape.c     |    1 +
 drivers/ide/ide-taskfile.c |    3 +--
 drivers/ide/ide.c          |    2 ++
 drivers/scsi/scsi_error.c  |    1 +
 6 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 60cc543..ebc653d 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -534,6 +534,9 @@ static int nbd_ioctl(struct inode *inode, struct file *file,
 	dprintk(DBG_IOCTL, "%s: nbd_ioctl cmd=%s(0x%x) arg=%lu\n",
 			lo->disk->disk_name, ioctl_cmd_to_ascii(cmd), cmd, arg);
 
+	memset(&sreq, 0, sizeof(sreq));
+	sreq.cmd = sreq.__cmd;
+
 	switch (cmd) {
 	case NBD_DISCONNECT:
 	        printk(KERN_INFO "%s: NBD_DISCONNECT\n", lo->disk->disk_name);
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index df819f8..e82a669 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -717,6 +717,7 @@ static int pd_special_command(struct pd_unit *disk,
 	int err = 0;
 
 	memset(&rq, 0, sizeof(rq));
+	rq.cmd = rq.__cmd;
 	rq.errors = 0;
 	rq.rq_disk = disk->gd;
 	rq.ref_count = 1;
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 0598ecf..d9c0267 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -946,6 +946,7 @@ static void idetape_create_request_sense_cmd(idetape_pc_t *pc)
 static void idetape_init_rq(struct request *rq, u8 cmd)
 {
 	memset(rq, 0, sizeof(*rq));
+	rq->cmd = rq->__cmd;
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd[0] = cmd;
 }
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 4c86a8d..1c30a57 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -529,8 +529,7 @@ int ide_raw_taskfile(ide_drive_t *drive, ide_task_t *task, u8 *buf, u16 nsect)
 {
 	struct request rq;
 
-	memset(&rq, 0, sizeof(rq));
-	rq.ref_count = 1;
+	ide_init_drive_cmd(&rq);
 	rq.cmd_type = REQ_TYPE_ATA_TASKFILE;
 	rq.buffer = buf;
 
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index fc69fe2..96aaec2 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -881,6 +881,7 @@ static int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 		ide_acpi_get_timing(hwif);
 
 	memset(&rq, 0, sizeof(rq));
+	rq.cmd = rq.__cmd;
 	memset(&rqpm, 0, sizeof(rqpm));
 	memset(&args, 0, sizeof(args));
 	rq.cmd_type = REQ_TYPE_PM_SUSPEND;
@@ -919,6 +920,7 @@ static int generic_ide_resume(struct device *dev)
 	ide_acpi_exec_tfs(drive);
 
 	memset(&rq, 0, sizeof(rq));
+	rq.cmd = rq.__cmd;
 	memset(&rqpm, 0, sizeof(rqpm));
 	memset(&args, 0, sizeof(args));
 	rq.cmd_type = REQ_TYPE_PM_RESUME;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 045a086..020b678 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1690,6 +1690,7 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	unsigned long flags;
 	int rtn;
 
+	req.cmd = req.__cmd;
 	scmd->request = &req;
 	memset(&scmd->eh_timeout, 0, sizeof(scmd->eh_timeout));
 
-- 
1.5.4.2

