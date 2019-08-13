Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C5BC433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4F7B20663
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tGBzGzfy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfHMHZX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:25:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50028 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfHMHZX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 03:25:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vD3m7KhomNKY3ojUBv4CZDoJYm0aPjbAe9GckHbQ3po=; b=tGBzGzfyi6ofQ/RJ9JP/zLjpZa
        dQoqdTkpsnn/EG0053IxewUD+BMDJI+7t9JQ4P9wbOVrcp9WLsdx7dBDYB+x43ewmXSPoIlwkZr/m
        EHRysLaSNujmO5F/PnFIf3Jqcbru8rN6g+cyvcsKmlxDm5OfqvWiSktZrPJpErisOmnJwq5zA92Ep
        CWfCmjWsDrdcxYkrCK4nVA6x0SNZTneWTybpQU7FfcS6F2vymY7qelYYOByLXBcvD2IKGSk4rPkmu
        LARAfKYdvfDzYcCwY99CpcdwkW9KQOh+4BXmRXCUOh0pI6mo626qFkJzvd7BAXfqXY0FCxLpTWshO
        EpvAuezw==;
Received: from [2001:4bb8:180:1ec3:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxRBH-00064g-AB; Tue, 13 Aug 2019 07:25:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <sivanich@hpe.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/28] char: remove the SGI snsc driver
Date:   Tue, 13 Aug 2019 09:24:47 +0200
Message-Id: <20190813072514.23299-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813072514.23299-1-hch@lst.de>
References: <20190813072514.23299-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SGI SN2 support is about to be removed.  Remove this driver that
depends on the SN2 support.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/ia64/configs/generic_defconfig   |   1 -
 arch/ia64/configs/gensparse_defconfig |   1 -
 drivers/char/Kconfig                  |   8 -
 drivers/char/Makefile                 |   1 -
 drivers/char/snsc.c                   | 469 --------------------------
 drivers/char/snsc.h                   |  92 -----
 drivers/char/snsc_event.c             | 303 -----------------
 7 files changed, 875 deletions(-)
 delete mode 100644 drivers/char/snsc.c
 delete mode 100644 drivers/char/snsc.h
 delete mode 100644 drivers/char/snsc_event.c

diff --git a/arch/ia64/configs/generic_defconfig b/arch/ia64/configs/generic_defconfig
index 81f686dee53c..22b98ddc9913 100644
--- a/arch/ia64/configs/generic_defconfig
+++ b/arch/ia64/configs/generic_defconfig
@@ -90,7 +90,6 @@ CONFIG_IGB=y
 # CONFIG_SERIO_SERPORT is not set
 CONFIG_GAMEPORT=m
 CONFIG_SERIAL_NONSTANDARD=y
-CONFIG_SGI_SNSC=y
 CONFIG_SGI_TIOCX=y
 CONFIG_SGI_MBCS=m
 CONFIG_SERIAL_8250=y
diff --git a/arch/ia64/configs/gensparse_defconfig b/arch/ia64/configs/gensparse_defconfig
index 5b4fcdd51457..1d230c0a90bd 100644
--- a/arch/ia64/configs/gensparse_defconfig
+++ b/arch/ia64/configs/gensparse_defconfig
@@ -79,7 +79,6 @@ CONFIG_E1000=y
 # CONFIG_SERIO_SERPORT is not set
 CONFIG_GAMEPORT=m
 CONFIG_SERIAL_NONSTANDARD=y
-CONFIG_SGI_SNSC=y
 CONFIG_SGI_TIOCX=y
 CONFIG_SGI_MBCS=m
 CONFIG_SERIAL_8250=y
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 3e866885a405..c9fbbc6a3967 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -26,14 +26,6 @@ config DEVKMEM
 	  kind of kernel debugging operations.
 	  When in doubt, say "N".
 
-config SGI_SNSC
-	bool "SGI Altix system controller communication support"
-	depends on (IA64_SGI_SN2 || IA64_GENERIC)
-	help
-	  If you have an SGI Altix and you want to enable system
-	  controller communication from user space (you want this!),
-	  say Y.  Otherwise, say N.
-
 config SGI_TIOCX
        bool "SGI TIO CX driver support"
        depends on (IA64_SGI_SN2 || IA64_GENERIC)
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index fbea7dd12932..50835d420471 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -9,7 +9,6 @@ obj-y				+= misc.o
 obj-$(CONFIG_ATARI_DSP56K)	+= dsp56k.o
 obj-$(CONFIG_VIRTIO_CONSOLE)	+= virtio_console.o
 obj-$(CONFIG_RAW_DRIVER)	+= raw.o
-obj-$(CONFIG_SGI_SNSC)		+= snsc.o snsc_event.o
 obj-$(CONFIG_MSPEC)		+= mspec.o
 obj-$(CONFIG_UV_MMTIMER)	+= uv_mmtimer.o
 obj-$(CONFIG_IBM_BSR)		+= bsr.o
diff --git a/drivers/char/snsc.c b/drivers/char/snsc.c
deleted file mode 100644
index 5918ea7499bb..000000000000
--- a/drivers/char/snsc.c
+++ /dev/null
@@ -1,469 +0,0 @@
-/*
- * SN Platform system controller communication support
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2004, 2006 Silicon Graphics, Inc. All rights reserved.
- */
-
-/*
- * System controller communication driver
- *
- * This driver allows a user process to communicate with the system
- * controller (a.k.a. "IRouter") network in an SGI SN system.
- */
-
-#include <linux/interrupt.h>
-#include <linux/sched/signal.h>
-#include <linux/device.h>
-#include <linux/poll.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/mutex.h>
-#include <asm/sn/io.h>
-#include <asm/sn/sn_sal.h>
-#include <asm/sn/module.h>
-#include <asm/sn/geo.h>
-#include <asm/sn/nodepda.h>
-#include "snsc.h"
-
-#define SYSCTL_BASENAME	"snsc"
-
-#define SCDRV_BUFSZ	2048
-#define SCDRV_TIMEOUT	1000
-
-static DEFINE_MUTEX(scdrv_mutex);
-static irqreturn_t
-scdrv_interrupt(int irq, void *subch_data)
-{
-	struct subch_data_s *sd = subch_data;
-	unsigned long flags;
-	int status;
-
-	spin_lock_irqsave(&sd->sd_rlock, flags);
-	spin_lock(&sd->sd_wlock);
-	status = ia64_sn_irtr_intr(sd->sd_nasid, sd->sd_subch);
-
-	if (status > 0) {
-		if (status & SAL_IROUTER_INTR_RECV) {
-			wake_up(&sd->sd_rq);
-		}
-		if (status & SAL_IROUTER_INTR_XMIT) {
-			ia64_sn_irtr_intr_disable
-			    (sd->sd_nasid, sd->sd_subch,
-			     SAL_IROUTER_INTR_XMIT);
-			wake_up(&sd->sd_wq);
-		}
-	}
-	spin_unlock(&sd->sd_wlock);
-	spin_unlock_irqrestore(&sd->sd_rlock, flags);
-	return IRQ_HANDLED;
-}
-
-/*
- * scdrv_open
- *
- * Reserve a subchannel for system controller communication.
- */
-
-static int
-scdrv_open(struct inode *inode, struct file *file)
-{
-	struct sysctl_data_s *scd;
-	struct subch_data_s *sd;
-	int rv;
-
-	/* look up device info for this device file */
-	scd = container_of(inode->i_cdev, struct sysctl_data_s, scd_cdev);
-
-	/* allocate memory for subchannel data */
-	sd = kzalloc(sizeof (struct subch_data_s), GFP_KERNEL);
-	if (sd == NULL) {
-		printk("%s: couldn't allocate subchannel data\n",
-		       __func__);
-		return -ENOMEM;
-	}
-
-	/* initialize subch_data_s fields */
-	sd->sd_nasid = scd->scd_nasid;
-	sd->sd_subch = ia64_sn_irtr_open(scd->scd_nasid);
-
-	if (sd->sd_subch < 0) {
-		kfree(sd);
-		printk("%s: couldn't allocate subchannel\n", __func__);
-		return -EBUSY;
-	}
-
-	spin_lock_init(&sd->sd_rlock);
-	spin_lock_init(&sd->sd_wlock);
-	init_waitqueue_head(&sd->sd_rq);
-	init_waitqueue_head(&sd->sd_wq);
-	sema_init(&sd->sd_rbs, 1);
-	sema_init(&sd->sd_wbs, 1);
-
-	file->private_data = sd;
-
-	/* hook this subchannel up to the system controller interrupt */
-	mutex_lock(&scdrv_mutex);
-	rv = request_irq(SGI_UART_VECTOR, scdrv_interrupt,
-			 IRQF_SHARED, SYSCTL_BASENAME, sd);
-	if (rv) {
-		ia64_sn_irtr_close(sd->sd_nasid, sd->sd_subch);
-		kfree(sd);
-		printk("%s: irq request failed (%d)\n", __func__, rv);
-		mutex_unlock(&scdrv_mutex);
-		return -EBUSY;
-	}
-	mutex_unlock(&scdrv_mutex);
-	return 0;
-}
-
-/*
- * scdrv_release
- *
- * Release a previously-reserved subchannel.
- */
-
-static int
-scdrv_release(struct inode *inode, struct file *file)
-{
-	struct subch_data_s *sd = (struct subch_data_s *) file->private_data;
-	int rv;
-
-	/* free the interrupt */
-	free_irq(SGI_UART_VECTOR, sd);
-
-	/* ask SAL to close the subchannel */
-	rv = ia64_sn_irtr_close(sd->sd_nasid, sd->sd_subch);
-
-	kfree(sd);
-	return rv;
-}
-
-/*
- * scdrv_read
- *
- * Called to read bytes from the open IRouter pipe.
- *
- */
-
-static inline int
-read_status_check(struct subch_data_s *sd, int *len)
-{
-	return ia64_sn_irtr_recv(sd->sd_nasid, sd->sd_subch, sd->sd_rb, len);
-}
-
-static ssize_t
-scdrv_read(struct file *file, char __user *buf, size_t count, loff_t *f_pos)
-{
-	int status;
-	int len;
-	unsigned long flags;
-	struct subch_data_s *sd = (struct subch_data_s *) file->private_data;
-
-	/* try to get control of the read buffer */
-	if (down_trylock(&sd->sd_rbs)) {
-		/* somebody else has it now;
-		 * if we're non-blocking, then exit...
-		 */
-		if (file->f_flags & O_NONBLOCK) {
-			return -EAGAIN;
-		}
-		/* ...or if we want to block, then do so here */
-		if (down_interruptible(&sd->sd_rbs)) {
-			/* something went wrong with wait */
-			return -ERESTARTSYS;
-		}
-	}
-
-	/* anything to read? */
-	len = CHUNKSIZE;
-	spin_lock_irqsave(&sd->sd_rlock, flags);
-	status = read_status_check(sd, &len);
-
-	/* if not, and we're blocking I/O, loop */
-	while (status < 0) {
-		DECLARE_WAITQUEUE(wait, current);
-
-		if (file->f_flags & O_NONBLOCK) {
-			spin_unlock_irqrestore(&sd->sd_rlock, flags);
-			up(&sd->sd_rbs);
-			return -EAGAIN;
-		}
-
-		len = CHUNKSIZE;
-		set_current_state(TASK_INTERRUPTIBLE);
-		add_wait_queue(&sd->sd_rq, &wait);
-		spin_unlock_irqrestore(&sd->sd_rlock, flags);
-
-		schedule_timeout(msecs_to_jiffies(SCDRV_TIMEOUT));
-
-		remove_wait_queue(&sd->sd_rq, &wait);
-		if (signal_pending(current)) {
-			/* wait was interrupted */
-			up(&sd->sd_rbs);
-			return -ERESTARTSYS;
-		}
-
-		spin_lock_irqsave(&sd->sd_rlock, flags);
-		status = read_status_check(sd, &len);
-	}
-	spin_unlock_irqrestore(&sd->sd_rlock, flags);
-
-	if (len > 0) {
-		/* we read something in the last read_status_check(); copy
-		 * it out to user space
-		 */
-		if (count < len) {
-			pr_debug("%s: only accepting %d of %d bytes\n",
-				 __func__, (int) count, len);
-		}
-		len = min((int) count, len);
-		if (copy_to_user(buf, sd->sd_rb, len))
-			len = -EFAULT;
-	}
-
-	/* release the read buffer and wake anyone who might be
-	 * waiting for it
-	 */
-	up(&sd->sd_rbs);
-
-	/* return the number of characters read in */
-	return len;
-}
-
-/*
- * scdrv_write
- *
- * Writes a chunk of an IRouter packet (or other system controller data)
- * to the system controller.
- *
- */
-static inline int
-write_status_check(struct subch_data_s *sd, int count)
-{
-	return ia64_sn_irtr_send(sd->sd_nasid, sd->sd_subch, sd->sd_wb, count);
-}
-
-static ssize_t
-scdrv_write(struct file *file, const char __user *buf,
-	    size_t count, loff_t *f_pos)
-{
-	unsigned long flags;
-	int status;
-	struct subch_data_s *sd = (struct subch_data_s *) file->private_data;
-
-	/* try to get control of the write buffer */
-	if (down_trylock(&sd->sd_wbs)) {
-		/* somebody else has it now;
-		 * if we're non-blocking, then exit...
-		 */
-		if (file->f_flags & O_NONBLOCK) {
-			return -EAGAIN;
-		}
-		/* ...or if we want to block, then do so here */
-		if (down_interruptible(&sd->sd_wbs)) {
-			/* something went wrong with wait */
-			return -ERESTARTSYS;
-		}
-	}
-
-	count = min((int) count, CHUNKSIZE);
-	if (copy_from_user(sd->sd_wb, buf, count)) {
-		up(&sd->sd_wbs);
-		return -EFAULT;
-	}
-
-	/* try to send the buffer */
-	spin_lock_irqsave(&sd->sd_wlock, flags);
-	status = write_status_check(sd, count);
-
-	/* if we failed, and we want to block, then loop */
-	while (status <= 0) {
-		DECLARE_WAITQUEUE(wait, current);
-
-		if (file->f_flags & O_NONBLOCK) {
-			spin_unlock_irqrestore(&sd->sd_wlock, flags);
-			up(&sd->sd_wbs);
-			return -EAGAIN;
-		}
-
-		set_current_state(TASK_INTERRUPTIBLE);
-		add_wait_queue(&sd->sd_wq, &wait);
-		spin_unlock_irqrestore(&sd->sd_wlock, flags);
-
-		schedule_timeout(msecs_to_jiffies(SCDRV_TIMEOUT));
-
-		remove_wait_queue(&sd->sd_wq, &wait);
-		if (signal_pending(current)) {
-			/* wait was interrupted */
-			up(&sd->sd_wbs);
-			return -ERESTARTSYS;
-		}
-
-		spin_lock_irqsave(&sd->sd_wlock, flags);
-		status = write_status_check(sd, count);
-	}
-	spin_unlock_irqrestore(&sd->sd_wlock, flags);
-
-	/* release the write buffer and wake anyone who's waiting for it */
-	up(&sd->sd_wbs);
-
-	/* return the number of characters accepted (should be the complete
-	 * "chunk" as requested)
-	 */
-	if ((status >= 0) && (status < count)) {
-		pr_debug("Didn't accept the full chunk; %d of %d\n",
-			 status, (int) count);
-	}
-	return status;
-}
-
-static __poll_t
-scdrv_poll(struct file *file, struct poll_table_struct *wait)
-{
-	__poll_t mask = 0;
-	int status = 0;
-	struct subch_data_s *sd = (struct subch_data_s *) file->private_data;
-	unsigned long flags;
-
-	poll_wait(file, &sd->sd_rq, wait);
-	poll_wait(file, &sd->sd_wq, wait);
-
-	spin_lock_irqsave(&sd->sd_rlock, flags);
-	spin_lock(&sd->sd_wlock);
-	status = ia64_sn_irtr_intr(sd->sd_nasid, sd->sd_subch);
-	spin_unlock(&sd->sd_wlock);
-	spin_unlock_irqrestore(&sd->sd_rlock, flags);
-
-	if (status > 0) {
-		if (status & SAL_IROUTER_INTR_RECV) {
-			mask |= EPOLLIN | EPOLLRDNORM;
-		}
-		if (status & SAL_IROUTER_INTR_XMIT) {
-			mask |= EPOLLOUT | EPOLLWRNORM;
-		}
-	}
-
-	return mask;
-}
-
-static const struct file_operations scdrv_fops = {
-	.owner =	THIS_MODULE,
-	.read =		scdrv_read,
-	.write =	scdrv_write,
-	.poll =		scdrv_poll,
-	.open =		scdrv_open,
-	.release =	scdrv_release,
-	.llseek =	noop_llseek,
-};
-
-static struct class *snsc_class;
-
-/*
- * scdrv_init
- *
- * Called at boot time to initialize the system controller communication
- * facility.
- */
-int __init
-scdrv_init(void)
-{
-	geoid_t geoid;
-	cnodeid_t cnode;
-	char devname[32];
-	char *devnamep;
-	struct sysctl_data_s *scd;
-	void *salbuf;
-	dev_t first_dev, dev;
-	nasid_t event_nasid;
-
-	if (!ia64_platform_is("sn2"))
-		return -ENODEV;
-
-	event_nasid = ia64_sn_get_console_nasid();
-
-	snsc_class = class_create(THIS_MODULE, SYSCTL_BASENAME);
-	if (IS_ERR(snsc_class)) {
-		printk("%s: failed to allocate class\n", __func__);
-		return PTR_ERR(snsc_class);
-	}
-
-	if (alloc_chrdev_region(&first_dev, 0, num_cnodes,
-				SYSCTL_BASENAME) < 0) {
-		printk("%s: failed to register SN system controller device\n",
-		       __func__);
-		return -ENODEV;
-	}
-
-	for (cnode = 0; cnode < num_cnodes; cnode++) {
-			geoid = cnodeid_get_geoid(cnode);
-			devnamep = devname;
-			format_module_id(devnamep, geo_module(geoid),
-					 MODULE_FORMAT_BRIEF);
-			devnamep = devname + strlen(devname);
-			sprintf(devnamep, "^%d#%d", geo_slot(geoid),
-				geo_slab(geoid));
-
-			/* allocate sysctl device data */
-			scd = kzalloc(sizeof (struct sysctl_data_s),
-				      GFP_KERNEL);
-			if (!scd) {
-				printk("%s: failed to allocate device info"
-				       "for %s/%s\n", __func__,
-				       SYSCTL_BASENAME, devname);
-				continue;
-			}
-
-			/* initialize sysctl device data fields */
-			scd->scd_nasid = cnodeid_to_nasid(cnode);
-			if (!(salbuf = kmalloc(SCDRV_BUFSZ, GFP_KERNEL))) {
-				printk("%s: failed to allocate driver buffer"
-				       "(%s%s)\n", __func__,
-				       SYSCTL_BASENAME, devname);
-				kfree(scd);
-				continue;
-			}
-
-			if (ia64_sn_irtr_init(scd->scd_nasid, salbuf,
-					      SCDRV_BUFSZ) < 0) {
-				printk
-				    ("%s: failed to initialize SAL for"
-				     " system controller communication"
-				     " (%s/%s): outdated PROM?\n",
-				     __func__, SYSCTL_BASENAME, devname);
-				kfree(scd);
-				kfree(salbuf);
-				continue;
-			}
-
-			dev = first_dev + cnode;
-			cdev_init(&scd->scd_cdev, &scdrv_fops);
-			if (cdev_add(&scd->scd_cdev, dev, 1)) {
-				printk("%s: failed to register system"
-				       " controller device (%s%s)\n",
-				       __func__, SYSCTL_BASENAME, devname);
-				kfree(scd);
-				kfree(salbuf);
-				continue;
-			}
-
-			device_create(snsc_class, NULL, dev, NULL,
-				      "%s", devname);
-
-			ia64_sn_irtr_intr_enable(scd->scd_nasid,
-						 0 /*ignored */ ,
-						 SAL_IROUTER_INTR_RECV);
-
-                        /* on the console nasid, prepare to receive
-                         * system controller environmental events
-                         */
-                        if(scd->scd_nasid == event_nasid) {
-                                scdrv_event_init(scd);
-                        }
-	}
-	return 0;
-}
-device_initcall(scdrv_init);
diff --git a/drivers/char/snsc.h b/drivers/char/snsc.h
deleted file mode 100644
index e8c52c882b21..000000000000
--- a/drivers/char/snsc.h
+++ /dev/null
@@ -1,92 +0,0 @@
-/*
- * SN Platform system controller communication support
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2004-2006 Silicon Graphics, Inc. All rights reserved.
- */
-
-/*
- * This file contains macros and data types for communication with the
- * system controllers in SGI SN systems.
- */
-
-#ifndef _SN_SYSCTL_H_
-#define _SN_SYSCTL_H_
-
-#include <linux/types.h>
-#include <linux/spinlock.h>
-#include <linux/wait.h>
-#include <linux/fs.h>
-#include <linux/cdev.h>
-#include <linux/semaphore.h>
-#include <asm/sn/types.h>
-
-#define CHUNKSIZE 127
-
-/* This structure is used to track an open subchannel. */
-struct subch_data_s {
-	nasid_t sd_nasid;	/* node on which the subchannel was opened */
-	int sd_subch;		/* subchannel number */
-	spinlock_t sd_rlock;	/* monitor lock for rsv */
-	spinlock_t sd_wlock;	/* monitor lock for wsv */
-	wait_queue_head_t sd_rq;	/* wait queue for readers */
-	wait_queue_head_t sd_wq;	/* wait queue for writers */
-	struct semaphore sd_rbs;	/* semaphore for read buffer */
-	struct semaphore sd_wbs;	/* semaphore for write buffer */
-
-	char sd_rb[CHUNKSIZE];	/* read buffer */
-	char sd_wb[CHUNKSIZE];	/* write buffer */
-};
-
-struct sysctl_data_s {
-	struct cdev scd_cdev;	/* Character device info */
-	nasid_t scd_nasid;	/* Node on which subchannels are opened. */
-};
-
-
-/* argument types */
-#define IR_ARG_INT              0x00    /* 4-byte integer (big-endian)  */
-#define IR_ARG_ASCII            0x01    /* null-terminated ASCII string */
-#define IR_ARG_UNKNOWN          0x80    /* unknown data type.  The low
-                                         * 7 bits will contain the data
-                                         * length.                      */
-#define IR_ARG_UNKNOWN_LENGTH_MASK	0x7f
-
-
-/* system controller event codes */
-#define EV_CLASS_MASK		0xf000ul
-#define EV_SEVERITY_MASK	0x0f00ul
-#define EV_COMPONENT_MASK	0x00fful
-
-#define EV_CLASS_POWER		0x1000ul
-#define EV_CLASS_FAN		0x2000ul
-#define EV_CLASS_TEMP		0x3000ul
-#define EV_CLASS_ENV		0x4000ul
-#define EV_CLASS_TEST_FAULT	0x5000ul
-#define EV_CLASS_TEST_WARNING	0x6000ul
-#define EV_CLASS_PWRD_NOTIFY	0x8000ul
-
-/* ENV class codes */
-#define ENV_PWRDN_PEND		0x4101ul
-
-#define EV_SEVERITY_POWER_STABLE	0x0000ul
-#define EV_SEVERITY_POWER_LOW_WARNING	0x0100ul
-#define EV_SEVERITY_POWER_HIGH_WARNING	0x0200ul
-#define EV_SEVERITY_POWER_HIGH_FAULT	0x0300ul
-#define EV_SEVERITY_POWER_LOW_FAULT	0x0400ul
-
-#define EV_SEVERITY_FAN_STABLE		0x0000ul
-#define EV_SEVERITY_FAN_WARNING		0x0100ul
-#define EV_SEVERITY_FAN_FAULT		0x0200ul
-
-#define EV_SEVERITY_TEMP_STABLE		0x0000ul
-#define EV_SEVERITY_TEMP_ADVISORY	0x0100ul
-#define EV_SEVERITY_TEMP_CRITICAL	0x0200ul
-#define EV_SEVERITY_TEMP_FAULT		0x0300ul
-
-void scdrv_event_init(struct sysctl_data_s *);
-
-#endif /* _SN_SYSCTL_H_ */
diff --git a/drivers/char/snsc_event.c b/drivers/char/snsc_event.c
deleted file mode 100644
index e452673dff66..000000000000
--- a/drivers/char/snsc_event.c
+++ /dev/null
@@ -1,303 +0,0 @@
-/*
- * SN Platform system controller communication support
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2004-2006 Silicon Graphics, Inc. All rights reserved.
- */
-
-/*
- * System controller event handler
- *
- * These routines deal with environmental events arriving from the
- * system controllers.
- */
-
-#include <linux/interrupt.h>
-#include <linux/sched/signal.h>
-#include <linux/slab.h>
-#include <asm/byteorder.h>
-#include <asm/sn/sn_sal.h>
-#include <asm/unaligned.h>
-#include "snsc.h"
-
-static struct subch_data_s *event_sd;
-
-void scdrv_event(unsigned long);
-DECLARE_TASKLET(sn_sysctl_event, scdrv_event, 0);
-
-/*
- * scdrv_event_interrupt
- *
- * Pull incoming environmental events off the physical link to the
- * system controller and put them in a temporary holding area in SAL.
- * Schedule scdrv_event() to move them along to their ultimate
- * destination.
- */
-static irqreturn_t
-scdrv_event_interrupt(int irq, void *subch_data)
-{
-	struct subch_data_s *sd = subch_data;
-	unsigned long flags;
-	int status;
-
-	spin_lock_irqsave(&sd->sd_rlock, flags);
-	status = ia64_sn_irtr_intr(sd->sd_nasid, sd->sd_subch);
-
-	if ((status > 0) && (status & SAL_IROUTER_INTR_RECV)) {
-		tasklet_schedule(&sn_sysctl_event);
-	}
-	spin_unlock_irqrestore(&sd->sd_rlock, flags);
-	return IRQ_HANDLED;
-}
-
-
-/*
- * scdrv_parse_event
- *
- * Break an event (as read from SAL) into useful pieces so we can decide
- * what to do with it.
- */
-static int
-scdrv_parse_event(char *event, int *src, int *code, int *esp_code, char *desc)
-{
-	char *desc_end;
-
-	/* record event source address */
-	*src = get_unaligned_be32(event);
-	event += 4; 			/* move on to event code */
-
-	/* record the system controller's event code */
-	*code = get_unaligned_be32(event);
-	event += 4;			/* move on to event arguments */
-
-	/* how many arguments are in the packet? */
-	if (*event++ != 2) {
-		/* if not 2, give up */
-		return -1;
-	}
-
-	/* parse out the ESP code */
-	if (*event++ != IR_ARG_INT) {
-		/* not an integer argument, so give up */
-		return -1;
-	}
-	*esp_code = get_unaligned_be32(event);
-	event += 4;
-
-	/* parse out the event description */
-	if (*event++ != IR_ARG_ASCII) {
-		/* not an ASCII string, so give up */
-		return -1;
-	}
-	event[CHUNKSIZE-1] = '\0';	/* ensure this string ends! */
-	event += 2; 			/* skip leading CR/LF */
-	desc_end = desc + sprintf(desc, "%s", event);
-
-	/* strip trailing CR/LF (if any) */
-	for (desc_end--;
-	     (desc_end != desc) && ((*desc_end == 0xd) || (*desc_end == 0xa));
-	     desc_end--) {
-		*desc_end = '\0';
-	}
-
-	return 0;
-}
-
-
-/*
- * scdrv_event_severity
- *
- * Figure out how urgent a message we should write to the console/syslog
- * via printk.
- */
-static char *
-scdrv_event_severity(int code)
-{
-	int ev_class = (code & EV_CLASS_MASK);
-	int ev_severity = (code & EV_SEVERITY_MASK);
-	char *pk_severity = KERN_NOTICE;
-
-	switch (ev_class) {
-	case EV_CLASS_POWER:
-		switch (ev_severity) {
-		case EV_SEVERITY_POWER_LOW_WARNING:
-		case EV_SEVERITY_POWER_HIGH_WARNING:
-			pk_severity = KERN_WARNING;
-			break;
-		case EV_SEVERITY_POWER_HIGH_FAULT:
-		case EV_SEVERITY_POWER_LOW_FAULT:
-			pk_severity = KERN_ALERT;
-			break;
-		}
-		break;
-	case EV_CLASS_FAN:
-		switch (ev_severity) {
-		case EV_SEVERITY_FAN_WARNING:
-			pk_severity = KERN_WARNING;
-			break;
-		case EV_SEVERITY_FAN_FAULT:
-			pk_severity = KERN_CRIT;
-			break;
-		}
-		break;
-	case EV_CLASS_TEMP:
-		switch (ev_severity) {
-		case EV_SEVERITY_TEMP_ADVISORY:
-			pk_severity = KERN_WARNING;
-			break;
-		case EV_SEVERITY_TEMP_CRITICAL:
-			pk_severity = KERN_CRIT;
-			break;
-		case EV_SEVERITY_TEMP_FAULT:
-			pk_severity = KERN_ALERT;
-			break;
-		}
-		break;
-	case EV_CLASS_ENV:
-		pk_severity = KERN_ALERT;
-		break;
-	case EV_CLASS_TEST_FAULT:
-		pk_severity = KERN_ALERT;
-		break;
-	case EV_CLASS_TEST_WARNING:
-		pk_severity = KERN_WARNING;
-		break;
-	case EV_CLASS_PWRD_NOTIFY:
-		pk_severity = KERN_ALERT;
-		break;
-	}
-
-	return pk_severity;
-}
-
-
-/*
- * scdrv_dispatch_event
- *
- * Do the right thing with an incoming event.  That's often nothing
- * more than printing it to the system log.  For power-down notifications
- * we start a graceful shutdown.
- */
-static void
-scdrv_dispatch_event(char *event, int len)
-{
-	static int snsc_shutting_down = 0;
-	int code, esp_code, src, class;
-	char desc[CHUNKSIZE];
-	char *severity;
-
-	if (scdrv_parse_event(event, &src, &code, &esp_code, desc) < 0) {
-		/* ignore uninterpretible event */
-		return;
-	}
-
-	/* how urgent is the message? */
-	severity = scdrv_event_severity(code);
-
-	class = (code & EV_CLASS_MASK);
-
-	if (class == EV_CLASS_PWRD_NOTIFY || code == ENV_PWRDN_PEND) {
-		if (snsc_shutting_down)
-			return;
-
-		snsc_shutting_down = 1;
-
-		/* give a message for each type of event */
-		if (class == EV_CLASS_PWRD_NOTIFY)
-			printk(KERN_NOTICE "Power off indication received."
-			       " Sending SIGPWR to init...\n");
-		else if (code == ENV_PWRDN_PEND)
-			printk(KERN_CRIT "WARNING: Shutting down the system"
-			       " due to a critical environmental condition."
-			       " Sending SIGPWR to init...\n");
-
-		/* give a SIGPWR signal to init proc */
-		kill_cad_pid(SIGPWR, 0);
-	} else {
-		/* print to system log */
-		printk("%s|$(0x%x)%s\n", severity, esp_code, desc);
-	}
-}
-
-
-/*
- * scdrv_event
- *
- * Called as a tasklet when an event arrives from the L1.  Read the event
- * from where it's temporarily stored in SAL and call scdrv_dispatch_event()
- * to send it on its way.  Keep trying to read events until SAL indicates
- * that there are no more immediately available.
- */
-void
-scdrv_event(unsigned long dummy)
-{
-	int status;
-	int len;
-	unsigned long flags;
-	struct subch_data_s *sd = event_sd;
-
-	/* anything to read? */
-	len = CHUNKSIZE;
-	spin_lock_irqsave(&sd->sd_rlock, flags);
-	status = ia64_sn_irtr_recv(sd->sd_nasid, sd->sd_subch,
-				   sd->sd_rb, &len);
-
-	while (!(status < 0)) {
-		spin_unlock_irqrestore(&sd->sd_rlock, flags);
-		scdrv_dispatch_event(sd->sd_rb, len);
-		len = CHUNKSIZE;
-		spin_lock_irqsave(&sd->sd_rlock, flags);
-		status = ia64_sn_irtr_recv(sd->sd_nasid, sd->sd_subch,
-					   sd->sd_rb, &len);
-	}
-	spin_unlock_irqrestore(&sd->sd_rlock, flags);
-}
-
-
-/*
- * scdrv_event_init
- *
- * Sets up a system controller subchannel to begin receiving event
- * messages. This is sort of a specialized version of scdrv_open()
- * in drivers/char/sn_sysctl.c.
- */
-void
-scdrv_event_init(struct sysctl_data_s *scd)
-{
-	int rv;
-
-	event_sd = kzalloc(sizeof (struct subch_data_s), GFP_KERNEL);
-	if (event_sd == NULL) {
-		printk(KERN_WARNING "%s: couldn't allocate subchannel info"
-		       " for event monitoring\n", __func__);
-		return;
-	}
-
-	/* initialize subch_data_s fields */
-	event_sd->sd_nasid = scd->scd_nasid;
-	spin_lock_init(&event_sd->sd_rlock);
-
-	/* ask the system controllers to send events to this node */
-	event_sd->sd_subch = ia64_sn_sysctl_event_init(scd->scd_nasid);
-
-	if (event_sd->sd_subch < 0) {
-		kfree(event_sd);
-		printk(KERN_WARNING "%s: couldn't open event subchannel\n",
-		       __func__);
-		return;
-	}
-
-	/* hook event subchannel up to the system controller interrupt */
-	rv = request_irq(SGI_UART_VECTOR, scdrv_event_interrupt,
-			 IRQF_SHARED, "system controller events", event_sd);
-	if (rv) {
-		printk(KERN_WARNING "%s: irq request failed (%d)\n",
-		       __func__, rv);
-		ia64_sn_irtr_close(event_sd->sd_nasid, event_sd->sd_subch);
-		kfree(event_sd);
-		return;
-	}
-}
-- 
2.20.1

