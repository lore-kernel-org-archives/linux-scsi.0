From: "Medve Emilian-EMMEDVE1" <Emilian.Medve@freescale.com>
Subject: CONFIG_BLK_DEV_BSG=n
Date: Fri, 14 Sep 2007 12:50:29 -0700
Message-ID: <598D5675D34BE349929AF5EDE9B03E27015558EA@az33exm24.fsl.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from de01egw01.freescale.net ([192.88.165.102]:35426 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbXINTuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Sep 2007 15:50:40 -0400
Received: from de01smr02.am.mot.com (de01smr02.freescale.net [10.208.0.151])
	by de01egw01.freescale.net (8.12.11/de01egw01) with ESMTP id l8EJoUVU017783
	for <linux-scsi@vger.kernel.org>; Fri, 14 Sep 2007 12:50:31 -0700 (MST)
Received: from az33exm24.fsl.freescale.net (az33exm24.am.freescale.net [10.64.32.14])
	by de01smr02.am.mot.com (8.13.1/8.13.0) with ESMTP id l8EJoUcQ024160
	for <linux-scsi@vger.kernel.org>; Fri, 14 Sep 2007 14:50:30 -0500 (CDT)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@steeleye.com, James.Bottomley@HansenPartnership.com, paulus@samba.org, Gala Kumar-B11780 <kumar.gala@freescale.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org

Hello,


I'm trying to get powerpc to build without block device support
(CONFIG_BLOCK=n). I'm getting the following errors:

  CC      arch/powerpc/kernel/setup_32.o
In file included from include/linux/blkdev.h:17,
                 from include/linux/ide.h:13,
                 from arch/powerpc/kernel/setup_32.c:13:
include/linux/bsg.h:67: warning: 'struct request_queue' declared inside
parameter list
include/linux/bsg.h:67: warning: its scope is only this definition or
declaration, which is probably not what you want
include/linux/bsg.h:71: warning: 'struct request_queue' declared inside
parameter list
In file included from arch/powerpc/kernel/setup_32.c:13:
include/linux/ide.h:857: error: field 'wrq' has incomplete type

  CC      arch/powerpc/kernel/ppc_ksyms.o
In file included from include/linux/blkdev.h:17,
                 from include/linux/ide.h:13,
                 from arch/powerpc/kernel/ppc_ksyms.c:15:
include/linux/bsg.h:67: warning: 'struct request_queue' declared inside
parameter list
include/linux/bsg.h:67: warning: its scope is only this definition or
declaration, which is probably not what you want
include/linux/bsg.h:71: warning: 'struct request_queue' declared inside
parameter list
In file included from arch/powerpc/kernel/ppc_ksyms.c:15:
include/linux/ide.h:857: error: field 'wrq' has incomplete type

I fixed the errors with a small patch in the powerpc code only and I'm
comfortable with that. The matter I wanted your input on is the warnings
from bsg.h coming from this are of the file:

	...
#ifdef __KERNEL__

#if defined(CONFIG_BLK_DEV_BSG)
struct bsg_class_device {
        struct class_device *class_dev;
        struct device *dev;
        int minor;
        struct request_queue *queue;
};

extern int bsg_register_queue(struct request_queue *, struct device *,
const char *);
extern void bsg_unregister_queue(struct request_queue *);
#else
static inline int bsg_register_queue(struct request_queue * rq, struct
device *dev, const char *name
)
{
        return 0;
}
static inline void bsg_unregister_queue(struct request_queue *rq)
{
}
#endif

#endif /* __KERNEL__ */
	...

I noticed that the '#else' branch was last updated by James (a4ee0df8)
in order to address some other warnings in scsi_sysfs.c, for example, in
the next piece of code:

	...
        error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL);

        if (error)
                sdev_printk(KERN_INFO, sdev,
                            "Failed to register bsg queue, errno=%d\n",
error);

        /* we're treating error on bsg register as non-fatal, so pretend
         * nothing went wrong */
        error = 0;
	...

The quick fix to those warnings is to add a declaration of struct
request_queue in bsg.h something looking like this:

	...
#ifdef __KERNEL__

struct request_queue; <- This is the addition

#if defined(CONFIG_BLK_DEV_BSG)
struct bsg_class_device {
        struct class_device *class_dev;
	...

However, I was wondering if there isn't a cleaner way of doing it. For
example, from the comments in scsi_sysfs.c it looks like it would be
possible not to call bsg_register_queue() at all when
CONFIG_BLK_DEV_BSG=n and get rid of the '#else' branch in bsg.h as I
don't think bsg_register_queue() and bsg_unregister_queue() should be
called when CONFIG_BLK_DEV_BSG=n.

Which solution would you be more comfortable with?


Thanks,
Emil.


This e-mail, and any associated attachments have been classified as:
--------------------------------------------------------------------
[ ] Public
[x] Freescale Semiconductor Internal Use Only
[ ] Freescale Semiconductor Confidential Proprietary
