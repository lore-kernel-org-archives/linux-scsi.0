From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: block/bsg.c
Date: Wed, 18 Jul 2007 07:26:49 +0900
Message-ID: <20070718072644F.tomof@acm.org>
References: <20070717190705T.fujita.tomonori@lab.ntt.co.jp>
	<20070717101928.GK5195@kernel.dk>
	<200707172252.25729.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:43003 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757369AbXGQW2W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2007 18:28:22 -0400
In-Reply-To: <200707172252.25729.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bzolnier@gmail.com
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.orgfujita.tomonori@lab.ntt.co.jp

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 22:52:25 +0200

> /*
>  * TODO
>  *      - Should this get merged, block/scsi_ioctl.c will be migrated into
>  *        this file. To keep maintenance down, it's easier to have them
>  *        seperated right now.
>  *
>  */
> 
> This TODO should be fixed/removed.

Yeah, this should be removed now. I'll do.


> Firstly bsg got merged. ;)  Moreover bsg depends on SCSI and scsi_ioctl doesn't.
> Even if SCSI dependency is fixed bsg requires block driver to have struct
> class devices which is not a case for scsi_ioctl.
> 
> ...
> 
> static struct bsg_device *__bsg_get_device(int minor)
> {
>         struct hlist_head *list = &bsg_device_list[bsg_list_idx(minor)];
> 
> bsg_device_list[] access should be done under bsg_mutex lock.
> 
> May not be a problem currently because of lock_kernel but worth fixing anyway.
> 
>         struct bsg_device *bd = NULL;
>         struct hlist_node *entry;
> 
>         mutex_lock(&bsg_mutex);
> 

They were fixed. Please check the latest code:

git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git bsg

We wait for Linus to pull from it.


> static int
> bsg_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
>           unsigned long arg)
> {
> ...
>         case SCSI_IOCTL_SEND_COMMAND: {
> 
> Do we really want to add support for this *deprecated* ioctl to
> the *new* and shiny bsg driver?
> 
>                 void __user *uarg = (void __user *) arg;
>                 return scsi_cmd_ioctl(file, bd->queue, NULL, cmd, uarg);
>         }

We might remove it.


> int bsg_register_queue(struct request_queue *q, const char *name)
> {
> ...
>         memset(bcd, 0, sizeof(*bcd));
> ...
>         dev = MKDEV(BSG_MAJOR, bcd->minor);
>         class_dev = class_device_create(bsg_class, NULL, dev, bcd->dev, "%s", name);
> 
> bcd->dev is always 0 (NULL).
> 
> Is it OK to pass NULL struct device *dev argument to class_device_create()?

It's ok, I guess.


> It should be fixed by either removing bcd->dev or by setting it to something
> other than zero.
> 
> ...
> 
> MODULE_AUTHOR("Jens Axboe");
> MODULE_DESCRIPTION("Block layer SGSI generic (sg) driver");
> 
> SGSI? :)

It was fixed in the latest code.


Thanks,
