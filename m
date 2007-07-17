From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 22:52:25 +0200
Message-ID: <200707172252.25729.bzolnier@gmail.com>
References: <20070717065940.GZ5195@kernel.dk> <20070717190705T.fujita.tomonori@lab.ntt.co.jp> <20070717101928.GK5195@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:41656 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758089AbXGQUfQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 16:35:16 -0400
Received: by ug-out-1314.google.com with SMTP id j3so205399ugf
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jul 2007 13:35:15 -0700 (PDT)
In-Reply-To: <20070717101928.GK5195@kernel.dk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org


Hi,

Some more bsg findings...


block/Kconfig:

endif # BLOCK

Shouldn't BLK_DEV_BSG depend on BLOCK?

config BLK_DEV_BSG
        bool "Block layer SG support"
        depends on (SCSI=y) && EXPERIMENTAL
        default y
        ---help---
        Saying Y here will enable generic SG (SCSI generic) v4
        support for any block device.


block/bsg.c:

...

/*
 * TODO
 *      - Should this get merged, block/scsi_ioctl.c will be migrated into
 *        this file. To keep maintenance down, it's easier to have them
 *        seperated right now.
 *
 */

This TODO should be fixed/removed.

Firstly bsg got merged. ;)  Moreover bsg depends on SCSI and scsi_ioctl doesn't.
Even if SCSI dependency is fixed bsg requires block driver to have struct
class devices which is not a case for scsi_ioctl.

...

static struct bsg_device *__bsg_get_device(int minor)
{
        struct hlist_head *list = &bsg_device_list[bsg_list_idx(minor)];

bsg_device_list[] access should be done under bsg_mutex lock.

May not be a problem currently because of lock_kernel but worth fixing anyway.

        struct bsg_device *bd = NULL;
        struct hlist_node *entry;

        mutex_lock(&bsg_mutex);

...

static int
bsg_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
          unsigned long arg)
{
...
        case SCSI_IOCTL_SEND_COMMAND: {

Do we really want to add support for this *deprecated* ioctl to
the *new* and shiny bsg driver?

                void __user *uarg = (void __user *) arg;
                return scsi_cmd_ioctl(file, bd->queue, NULL, cmd, uarg);
        }

...

int bsg_register_queue(struct request_queue *q, const char *name)
{
...
        memset(bcd, 0, sizeof(*bcd));
...
        dev = MKDEV(BSG_MAJOR, bcd->minor);
        class_dev = class_device_create(bsg_class, NULL, dev, bcd->dev, "%s", name);

bcd->dev is always 0 (NULL).

Is it OK to pass NULL struct device *dev argument to class_device_create()?

It should be fixed by either removing bcd->dev or by setting it to something
other than zero.

...

MODULE_AUTHOR("Jens Axboe");
MODULE_DESCRIPTION("Block layer SGSI generic (sg) driver");

SGSI? :)

MODULE_LICENSE("GPL");


Now back to the first bsg commit 3d6392cfbd7dc11f23058e3493683afab4ac13a3:

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index f429be8..a21f585 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -1258,19 +1258,25 @@ static void idefloppy_create_rw_cmd (idefloppy_floppy_t *floppy, idefloppy_pc_t
 	set_bit(PC_DMA_RECOMMENDED, &pc->flags);
 }
 
-static int
+static void
 idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy, idefloppy_pc_t *pc, struct request *rq)
 {
-	/*
-	 * just support eject for now, it would not be hard to make the
-	 * REQ_BLOCK_PC support fully-featured
-	 */
-	if (rq->cmd[0] != IDEFLOPPY_START_STOP_CMD)
-		return 1;
-
 	idefloppy_init_pc(pc);
+	pc->callback = &idefloppy_rw_callback;
 	memcpy(pc->c, rq->cmd, sizeof(pc->c));
-	return 0;
+	pc->rq = rq;
+	pc->b_count = rq->data_len;
+	if (rq->data_len && rq_data_dir(rq) == WRITE)
+		set_bit(PC_WRITING, &pc->flags);
+	pc->buffer = rq->data;
+	if (rq->bio)
+		set_bit(PC_DMA_RECOMMENDED, &pc->flags);

Great to see SG_IO support being added to ide-floppy but this change has
nothing to do with the addition of bsg driver so WTF they have been mixed
within the same commit?

I also can't recall seeing this patch on linux-ide mailing list...

+	/*
+	 * possibly problematic, doesn't look like ide-floppy correctly
+	 * handled scattered requests if dma fails...
+	 */

Could you give some details on this?

+	pc->request_transfer = pc->buffer_size = rq->data_len;
 }
 
 /*
@@ -1317,10 +1323,7 @@ static ide_startstop_t idefloppy_do_request (ide_drive_t *drive, struct request
 		pc = (idefloppy_pc_t *) rq->buffer;
 	} else if (blk_pc_request(rq)) {
 		pc = idefloppy_next_pc_storage(drive);
-		if (idefloppy_blockpc_cmd(floppy, pc, rq)) {
-			idefloppy_do_end_request(drive, 0, 0);
-			return ide_stopped;
-		}
+		idefloppy_blockpc_cmd(floppy, pc, rq);
 	} else {
 		blk_dump_rq_flags(rq,
 			"ide-floppy: unsupported command in queue");
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index c948a5c..9ae60a7 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c

ide.c changes also have nothing to do with addition of bsg driver.

@@ -1049,9 +1049,13 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
 	unsigned long flags;
 	ide_driver_t *drv;
 	void __user *p = (void __user *)arg;
-	int err = 0, (*setfunc)(ide_drive_t *, int);
+	int err, (*setfunc)(ide_drive_t *, int);
 	u8 *val;
 
+	err = scsi_cmd_ioctl(file, bdev->bd_disk, cmd, p);
+	if (err != -ENOTTY)
+		return err;
+

Probably the goal was to add SG_IO IOCTL support for ide-floppy but instead
it adds support for *all* scsi_ioctl.c IOCTLs to *all* IDE device drivers.

ide-{disk,scsi,tape} don't support REQ_TYPE_BLOCK_PC requests et all
(so attempts to use SG_IO, CDROM_SEND_PACKET and SCSI_IOCTL_SEND_COMMAND
will result in requests being failed and error messages in the kernel logs).
Without REQ_TYPE_BLOCK_PC support there is no sense in supporting any other
scsi_ioctl.c IOCTLs (while at it: SG_{GET,SET}_RESERVED seems to have no
real effect in the current tree).

ide-cd already supports all scsi_ioctl.c IOCTLs through cdrom_ioctl() call.

This leaves us with ide-floppy where the above scsi_cmd_ioctl() call should
belong (we may also want to filter out deprecated SCSI_IOCTL_SEND_COMMAND
and legacy CDROM_SEND_PACKET IOCTLs).

Please fix it.

 	switch (cmd) {
 	case HDIO_GET_32BIT:	    val = &drive->io_32bit;	 goto read_val;
 	case HDIO_GET_KEEPSETTINGS: val = &drive->keep_settings; goto read_val;
@@ -1171,10 +1175,6 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
 			return 0;
 		}
 
-		case CDROMEJECT:
-		case CDROMCLOSETRAY:
-			return scsi_cmd_ioctl(file, bdev->bd_disk, cmd, p);
-

This chunk is OK, handling of these IOCTLs should go to ide-floppy
(ide-cd already handles them fine).

Thanks,
Bart
