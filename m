From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] aacraid changes for 2.4.24 kernel to ride through SCSI
	hang ?
Date: Mon, 16 Feb 2004 07:47:56 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076946475.1358.3.camel@markh1.pdx.osdl.net>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F25528E@otce2k03.adaptec.com>
	 <20040213203632.A19671@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:25246 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S265757AbUBPPsC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Feb 2004 10:48:02 -0500
In-Reply-To: <20040213203632.A19671@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

On Fri, 2004-02-13 at 12:36, Christoph Hellwig wrote:
> On Fri, Feb 13, 2004 at 01:56:40PM -0500, Salyzyn, Mark wrote:
> > This patch allows the system to ride through an Adapter that is
> > temporarily reticent to commands.
> > 
> > The cause of this reticence is usually a combination of a Fast Host
> > Processors loading up the adapter full with commands and a less than
> > perfect SCSI cable or drive triggering an Adapter Cache Flush operation.
> > Some Adapters with large cache configuration have been clocked as being
> > unresponsive for more than 90 seconds.
> > 
> > When the SCSI subsystem times out and asks for the Adapter to be reset,
> > we wait a minute longer for the Adapter to complete all outstanding
> > commands before giving up and returning to the SCSI layers recovery
> > code. Without this delay, the first test unit ready issued to the device
> > times out and the device is taken offline; usually resulting in a panic
> > of the filesystem driver.
> 
> Patch looks okay, what about a 2.6 version as we usually require that
> for 2.4 updates these days?

Here is a reset patch for 2.6.  It is against James' scsi-misc-2.6 bk
tree.  Adapted from Adaptec's reset patch.

Mark.

===== drivers/scsi/aacraid/aacraid.h 1.12 vs edited =====
--- 1.12/drivers/scsi/aacraid/aacraid.h	Wed Jan 28 03:37:58 2004
+++ edited/drivers/scsi/aacraid/aacraid.h	Fri Feb 13 14:17:36 2004
@@ -512,6 +512,7 @@
 	void (*adapter_enable_int)(struct aac_dev *dev, u32 event);
 	void (*adapter_disable_int)(struct aac_dev *dev, u32 event);
 	int  (*adapter_sync_cmd)(struct aac_dev *dev, u32 command, u32 p1, u32 *status);
+	int  (*adapter_check_health)(struct aac_dev *dev);
 };
 
 /*
@@ -942,6 +943,8 @@
 #define aac_adapter_disable_int(dev, event) \
 	dev->a_ops.adapter_disable_int(dev, event)
 
+#define aac_adapter_check_health(dev) \
+	(dev)->a_ops.adapter_check_health(dev)
 
 
 #define FIB_CONTEXT_FLAG_TIMED_OUT		(0x00000001)
===== drivers/scsi/aacraid/linit.c 1.25 vs edited =====
--- 1.25/drivers/scsi/aacraid/linit.c	Tue Feb  3 06:46:46 2004
+++ edited/drivers/scsi/aacraid/linit.c	Fri Feb 13 13:57:38 2004
@@ -49,6 +49,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
+#include <scsi/scsi_eh.h>
 
 #include "aacraid.h"
 
@@ -339,6 +340,51 @@
 	return FAILED;
 }
 
+/*
+ *	aac_eh_reset	- Reset command handling
+ *	@scsi_cmd:	SCSI command block causing the reset
+ *
+ */
+static int aac_eh_reset(struct scsi_cmnd* cmd)
+{
+	struct scsi_device * dev = cmd->device;
+	struct Scsi_Host * host = dev->host;
+	struct scsi_cmnd * command;
+	int count;
+	unsigned long flags;
+
+	printk(KERN_ERR "%s: Host adapter reset request. SCSI hang ?\n", 
+					AAC_DRIVERNAME);
+
+
+	if (aac_adapter_check_health((struct aac_dev *)host->hostdata)) {
+		printk(KERN_ERR "%s: Host adapter appears dead\n", 
+				AAC_DRIVERNAME);
+		return -ENODEV;
+	}
+	/*
+	 * Wait for all commands to complete to this specific
+	 * target (block maximum 60 seconds).
+	 */
+	for (count = 60; count; --count) {
+		__shost_for_each_device(dev, host) {
+			spin_lock_irqsave(&dev->list_lock, flags);
+			list_for_each_entry(command, &dev->cmd_list, list) {
+				if (command->serial_number) {
+					spin_unlock_irqrestore(&dev->list_lock, flags);
+					return SUCCESS;
+				}
+			}
+			spin_unlock_irqrestore(&dev->list_lock, flags);
+		}
+		spin_unlock_irq(host->host_lock);
+		scsi_sleep(HZ);
+		spin_lock_irq(host->host_lock);
+	}
+	printk(KERN_ERR "%s: SCSI bus appears hung\n", AAC_DRIVERNAME);
+	return -ETIMEDOUT;
+}
+
 /**
  *	aac_cfg_open		-	open a configuration file
  *	@inode: inode being opened
@@ -397,6 +443,7 @@
 	.bios_param     		= aac_biosparm,	
 	.slave_configure		= aac_slave_configure,
 	.eh_abort_handler		= aac_eh_abort,
+	.eh_host_reset_handler		= aac_eh_reset,
 	.can_queue      		= AAC_NUM_IO_FIB,	
 	.this_id        		= 16,
 	.sg_tablesize   		= 16,
===== drivers/scsi/aacraid/rkt.c 1.1 vs edited =====
--- 1.1/drivers/scsi/aacraid/rkt.c	Tue Feb  3 07:18:33 2004
+++ edited/drivers/scsi/aacraid/rkt.c	Fri Feb 13 14:06:03 2004
@@ -325,6 +325,38 @@
 }
 
 /**
+ *	aac_rkt_check_health
+ *	@dev: device to check if healthy
+ *
+ *	Will attempt to determine if the specified adapter is alive and
+ *	capable of handling requests, returning 0 if alive.
+ */
+static int aac_rkt_check_health(struct aac_dev *dev)
+{
+	long status = rkt_readl(dev, IndexRegs.Mailbox[7]);
+
+	/*
+	 *	Check to see if the board failed any self tests.
+	 */
+	if (status & SELF_TEST_FAILED)
+		return -1;
+	/*
+	 *	Check to see if the board panic'd while booting.
+	 */
+	if (status & KERNEL_PANIC)
+		return -2;
+	/*
+	 *	Wait for the adapter to be up and running. Wait up to 3 minutes
+	 */
+	if (!(status & KERNEL_UP_AND_RUNNING))
+		return -3;
+	/*
+	 *	Everything is OK
+	 */
+	return 0;
+} /* aac_rkt_check_health */
+
+/**
  *	aac_rkt_init	-	initialize an i960 based AAC card
  *	@dev: device to configure
  *	@devnum: adapter number
===== drivers/scsi/aacraid/rx.c 1.6 vs edited =====
--- 1.6/drivers/scsi/aacraid/rx.c	Tue Feb  3 06:23:03 2004
+++ edited/drivers/scsi/aacraid/rx.c	Fri Feb 13 14:04:31 2004
@@ -325,6 +325,38 @@
 }
 
 /**
+ *	aac_rx_check_health
+ *	@dev: device to check if healthy
+ *
+ *	Will attempt to determine if the specified adapter is alive and
+ *	capable of handling requests, returning 0 if alive.
+ */
+static int aac_rx_check_health(struct aac_dev *dev)
+{
+	long status = rx_readl(dev, IndexRegs.Mailbox[7]);
+
+	/*
+	 *	Check to see if the board failed any self tests.
+	 */
+	if (status & SELF_TEST_FAILED)
+		return -1;
+	/*
+	 *	Check to see if the board panic'd while booting.
+	 */
+	if (status & KERNEL_PANIC)
+		return -2;
+	/*
+	 *	Wait for the adapter to be up and running. Wait up to 3 minutes
+	 */
+	if (!(status & KERNEL_UP_AND_RUNNING))
+		return -3;
+	/*
+	 *	Everything is OK
+	 */
+	return 0;
+} /* aac_rx_check_health */
+
+/**
  *	aac_rx_init	-	initialize an i960 based AAC card
  *	@dev: device to configure
  *	@devnum: adapter number
===== drivers/scsi/aacraid/sa.c 1.6 vs edited =====
--- 1.6/drivers/scsi/aacraid/sa.c	Wed Nov 19 10:39:11 2003
+++ edited/drivers/scsi/aacraid/sa.c	Fri Feb 13 14:03:46 2004
@@ -300,6 +300,38 @@
 }
 
 /**
+ *	aac_sa_check_health
+ *	@dev: device to check if healthy
+ *
+ *	Will attempt to determine if the specified adapter is alive and
+ *	capable of handling requests, returning 0 if alive.
+ */
+static int aac_sa_check_health(struct aac_dev *dev)
+{
+	long status = sa_readl(dev, Mailbox7);
+
+	/*
+	 *	Check to see if the board failed any self tests.
+	 */
+	if (status & SELF_TEST_FAILED)
+		return -1;
+	/*
+	 *	Check to see if the board panic'd while booting.
+	 */
+	if (status & KERNEL_PANIC)
+		return -2;
+	/*
+	 *	Wait for the adapter to be up and running. Wait up to 3 minutes
+	 */
+	if (!(status & KERNEL_UP_AND_RUNNING))
+		return -3;
+	/*
+	 *	Everything is OK
+	 */
+	return 0;
+} /* aac_sa_check_health */
+
+/**
  *	aac_sa_init	-	initialize an ARM based AAC card
  *	@dev: device to configure
  *	@devnum: adapter number


-- 
Mark Haverkamp <markh@osdl.org>

