From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [scsi-mq] WARNING: CPU: 0 PID: 99 at block/elevator.c:193
 elevator_init()
Date: Sun, 22 Dec 2013 21:54:28 -0800
Message-ID: <1387778068.5567.104.camel@haakon3.risingtidesystems.com>
References: <20131223031624.GB23200@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131223031624.GB23200@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKP <fnstml-lkp@cn.fujitsu.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-12-23 at 11:16 +0800, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit 29ff818720ce09b044652b83e9c70ef474800d54
> Author:     Nicholas Bellinger <nab@linux-iscsi.org>
> AuthorDate: Thu May 23 22:11:38 2013 -0700
> Commit:     Nicholas Bellinger <nab@linux-iscsi.org>
> CommitDate: Sun Dec 22 13:00:48 2013 +0000
> 
>     scsi-debug: Enable scsi-mq operation
>     
>     v4 changes:
>       - Bump can_queue to 64 for performance testing
>       - Enable scsi-mq DIF support
>       - Add nop_fs_io module parameter for performance testing
>     
>     Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> +-----------------------------------------------------+----+
> |                                                     |    |
> +-----------------------------------------------------+----+
> | boot_successes                                      | 0  |
> | boot_failures                                       | 19 |
> | WARNING:CPU:PID:at_block/elevator.c:elevator_init() | 19 |
> +-----------------------------------------------------+----+
> 
> [    4.763205]   CPU 1 -> Queue 0
> [    4.764566] ------------[ cut here ]------------
> [    4.764566] ------------[ cut here ]------------
> [    4.765951] WARNING: CPU: 0 PID: 99 at block/elevator.c:193 elevator_init+0xf0/0xfb()
> 
> Attached are the full dmesg and kconfig.
> 

Mmm, so elevator_init() is now expecting q->sysfs_lock to be held after:

commit eb1c160b22655fd4ec44be732d6594fd1b1e44f4
Author: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Date:   Tue Oct 15 16:42:16 2013 -0600

    elevator: Fix a race in elevator switching and md device initialization

Adding the following scsi_mq_alloc_queue() patch to quiet this warning.

Thanks Fengguang!

--nab

diff --git a/drivers/scsi/scsi-mq.c b/drivers/scsi/scsi-mq.c
index dad720a..188509d 100644
--- a/drivers/scsi/scsi-mq.c
+++ b/drivers/scsi/scsi-mq.c
@@ -151,7 +151,7 @@ int scsi_mq_alloc_queue(struct Scsi_Host *sh, struct scsi_device *sdev)
        struct request_queue *q;
        struct request *rq;
        struct scsi_cmnd *sc;
-       int i, j, sgl_size;
+       int i, j, rc, sgl_size;
        bool prot = true;
 
        sdev->sdev_mq_reg.ops = &scsi_mq_ops;
@@ -181,8 +181,11 @@ int scsi_mq_alloc_queue(struct Scsi_Host *sh, struct scsi_device *sdev)
 
        q->sg_reserved_size = INT_MAX;
 
-       if (elevator_init(q, NULL)) {
-               dump_stack();
+       mutex_lock(&q->sysfs_lock);
+       rc = elevator_init(q, NULL);
+       mutex_unlock(&q->sysfs_lock);
+       if (rc) {
+               pr_err("elevator_init failed for scsi-mq: %d\n", rc);
                return -ENOMEM;
        }
        /*
