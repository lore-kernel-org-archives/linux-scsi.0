From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] aacraid: don't assign cpu_to_le32(int) to u8
Date: Thu, 8 Nov 2007 17:27:47 +0000
Message-ID: <20071108172747.GA4054@infradead.org>
References: <jefxzqqeha.fsf@sykes.suse.de> <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com> <20071107173307.GB25560@infradead.org> <AE4F746F2AECFC4DA4AADD66A1DFEF01F95F54@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53331 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759437AbXKHR1z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Nov 2007 12:27:55 -0500
Content-Disposition: inline
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01F95F54@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andreas Schwab <schwab@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Wed, Nov 07, 2007 at 01:51:44PM -0500, Salyzyn, Mark wrote:
> Christoph Hellwig [mailto:hch@infradead.org] sez:
> > Did anyone run the driver through sparse to see if we have 
> > more issues like this?
> 
> There are some warnings from sparse, none like this one. I will deal
> with the warnings ...

Actually there are a lot of endianess warnings, fortunately most of them
harmless.  The patch below fixes all of them up (including the ones in
the patch I replied to), except for aac_init_adapter which is really odd
and I don't know what to do.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/aacraid/aachba.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aacraid/aachba.c	2007-11-08 17:09:50.000000000 +0100
+++ linux-2.6/drivers/scsi/aacraid/aachba.c	2007-11-08 17:14:43.000000000 +0100
@@ -981,7 +981,7 @@
 	aac_fib_init(fib);
 	readcmd = (struct aac_read *) fib_data(fib);
 	readcmd->command = cpu_to_le32(VM_CtBlockRead);
-	readcmd->cid = cpu_to_le16(scmd_id(cmd));
+	readcmd->cid = cpu_to_le32(scmd_id(cmd));
 	readcmd->block = cpu_to_le32((u32)(lba&0xffffffff));
 	readcmd->count = cpu_to_le32(count * 512);
 
@@ -1072,7 +1072,7 @@
 	aac_fib_init(fib);
 	writecmd = (struct aac_write *) fib_data(fib);
 	writecmd->command = cpu_to_le32(VM_CtBlockWrite);
-	writecmd->cid = cpu_to_le16(scmd_id(cmd));
+	writecmd->cid = cpu_to_le32(scmd_id(cmd));
 	writecmd->block = cpu_to_le32((u32)(lba&0xffffffff));
 	writecmd->count = cpu_to_le32(count * 512);
 	writecmd->sg.count = cpu_to_le32(1);
@@ -1306,8 +1306,8 @@
 			  dev->supplement_adapter_info.VpdInfo.Tsid);
 		}
 		if (!aac_check_reset ||
-		  (dev->supplement_adapter_info.SupportedOptions2 &
-		  le32_to_cpu(AAC_OPTION_IGNORE_RESET))) {
+		    (dev->supplement_adapter_info.SupportedOptions2 &
+		     cpu_to_le32(AAC_OPTION_IGNORE_RESET))) {
 			printk(KERN_INFO "%s%d: Reset Adapter Ignored\n",
 			  dev->name, dev->id);
 		}
Index: linux-2.6/drivers/scsi/aacraid/commsup.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aacraid/commsup.c	2007-11-08 17:09:50.000000000 +0100
+++ linux-2.6/drivers/scsi/aacraid/commsup.c	2007-11-08 17:14:43.000000000 +0100
@@ -796,13 +796,13 @@
 	 */
 	switch (le32_to_cpu(aifcmd->command)) {
 	case AifCmdDriverNotify:
-		switch (le32_to_cpu(((u32 *)aifcmd->data)[0])) {
+		switch (le32_to_cpu(((__le32 *)aifcmd->data)[0])) {
 		/*
 		 *	Morph or Expand complete
 		 */
 		case AifDenMorphComplete:
 		case AifDenVolumeExtendComplete:
-			container = le32_to_cpu(((u32 *)aifcmd->data)[1]);
+			container = le32_to_cpu(((__le32 *)aifcmd->data)[1]);
 			if (container >= dev->maximum_num_containers)
 				break;
 
@@ -835,25 +835,25 @@
 			if (container >= dev->maximum_num_containers)
 				break;
 			if ((dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(u32 *)aifcmd->data)) &&
+			    le32_to_cpu(*(__le32 *)aifcmd->data)) &&
 			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		} else for (container = 0;
 		    container < dev->maximum_num_containers; ++container) {
 			if ((dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(u32 *)aifcmd->data)) &&
+			    le32_to_cpu(*(__le32 *)aifcmd->data)) &&
 			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		}
 		break;
 
 	case AifCmdEventNotify:
-		switch (le32_to_cpu(((u32 *)aifcmd->data)[0])) {
+		switch (le32_to_cpu(((__le32 *)aifcmd->data)[0])) {
 		/*
 		 *	Add an Array.
 		 */
 		case AifEnAddContainer:
-			container = le32_to_cpu(((u32 *)aifcmd->data)[1]);
+			container = le32_to_cpu(((__le32 *)aifcmd->data)[1]);
 			if (container >= dev->maximum_num_containers)
 				break;
 			dev->fsa_dev[container].config_needed = ADD;
@@ -866,7 +866,7 @@
 		 *	Delete an Array.
 		 */
 		case AifEnDeleteContainer:
-			container = le32_to_cpu(((u32 *)aifcmd->data)[1]);
+			container = le32_to_cpu(((__le32 *)aifcmd->data)[1]);
 			if (container >= dev->maximum_num_containers)
 				break;
 			dev->fsa_dev[container].config_needed = DELETE;
@@ -880,7 +880,7 @@
 		 * waiting on something else, setup to wait on a Config Change.
 		 */
 		case AifEnContainerChange:
-			container = le32_to_cpu(((u32 *)aifcmd->data)[1]);
+			container = le32_to_cpu(((__le32 *)aifcmd->data)[1]);
 			if (container >= dev->maximum_num_containers)
 				break;
 			if (dev->fsa_dev[container].config_waiting_on &&
@@ -905,13 +905,13 @@
 			if (container >= dev->maximum_num_containers)
 				break;
 			if ((dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(u32 *)aifcmd->data)) &&
+			    le32_to_cpu(*(__le32 *)aifcmd->data)) &&
 			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		} else for (container = 0;
 		    container < dev->maximum_num_containers; ++container) {
 			if ((dev->fsa_dev[container].config_waiting_on ==
-			    le32_to_cpu(*(u32 *)aifcmd->data)) &&
+			    le32_to_cpu(*(__le32 *)aifcmd->data)) &&
 			 time_before(jiffies, dev->fsa_dev[container].config_waiting_stamp + AIF_SNIFF_TIMEOUT))
 				dev->fsa_dev[container].config_waiting_on = 0;
 		}
@@ -926,9 +926,9 @@
 		 * wait for a container change.
 		 */
 
-		if ((((u32 *)aifcmd->data)[1] == cpu_to_le32(AifJobCtrZero))
-		 && ((((u32 *)aifcmd->data)[6] == ((u32 *)aifcmd->data)[5])
-		  || (((u32 *)aifcmd->data)[4] == cpu_to_le32(AifJobStsSuccess)))) {
+		if (((__le32 *)aifcmd->data)[1] == cpu_to_le32(AifJobCtrZero) &&
+		    (((__le32 *)aifcmd->data)[6] == ((__le32 *)aifcmd->data)[5] ||
+		     ((__le32 *)aifcmd->data)[4] == cpu_to_le32(AifJobStsSuccess))) {
 			for (container = 0;
 			    container < dev->maximum_num_containers;
 			    ++container) {
@@ -943,9 +943,9 @@
 					jiffies;
 			}
 		}
-		if ((((u32 *)aifcmd->data)[1] == cpu_to_le32(AifJobCtrZero))
-		 && (((u32 *)aifcmd->data)[6] == 0)
-		 && (((u32 *)aifcmd->data)[4] == cpu_to_le32(AifJobStsRunning))) {
+		if (((__le32 *)aifcmd->data)[1] == cpu_to_le32(AifJobCtrZero) &&
+		    ((__le32 *)aifcmd->data)[6] == 0 &&
+		    ((__le32 *)aifcmd->data)[4] == cpu_to_le32(AifJobStsRunning)) {
 			for (container = 0;
 			    container < dev->maximum_num_containers;
 			    ++container) {
@@ -1339,10 +1339,10 @@
 			aif = (struct aac_aifcmd *)hw_fib->data;
 			aif->command = cpu_to_le32(AifCmdEventNotify);
 		 	aif->seqnum = cpu_to_le32(0xFFFFFFFF);
-		 	aif->data[0] = cpu_to_le32(AifEnExpEvent);
-			aif->data[1] = cpu_to_le32(AifExeFirmwarePanic);
-		 	aif->data[2] = cpu_to_le32(AifHighPriority);
-			aif->data[3] = cpu_to_le32(BlinkLED);
+		 	aif->data[0] = AifEnExpEvent;
+			aif->data[1] = AifExeFirmwarePanic;
+		 	aif->data[2] = AifHighPriority;
+			aif->data[3] = BlinkLED;
 
 			/*
 			 * Put the FIB onto the
@@ -1373,8 +1373,8 @@
 	printk(KERN_ERR "%s: Host adapter BLINK LED 0x%x\n", aac->name, BlinkLED);
 
 	if (!aac_check_reset ||
-		(aac->supplement_adapter_info.SupportedOptions2 &
-			le32_to_cpu(AAC_OPTION_IGNORE_RESET)))
+	    (aac->supplement_adapter_info.SupportedOptions2 &
+	     cpu_to_le32(AAC_OPTION_IGNORE_RESET)))
 		goto out;
 	host = aac->scsi_host_ptr;
 	if (aac->thread->pid != current->pid)
@@ -1655,11 +1655,11 @@
 				struct fib *fibptr;
 
 				if ((fibptr = aac_fib_alloc(dev))) {
-					u32 * info;
+					__le32 *info;
 
 					aac_fib_init(fibptr);
 
-					info = (u32 *) fib_data(fibptr);
+					info = (__le32 *) fib_data(fibptr);
 					if (now.tv_usec > 500000)
 						++now.tv_sec;
 
Index: linux-2.6/drivers/scsi/aacraid/dpcsup.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aacraid/dpcsup.c	2007-11-08 17:09:50.000000000 +0100
+++ linux-2.6/drivers/scsi/aacraid/dpcsup.c	2007-11-08 17:14:43.000000000 +0100
@@ -229,11 +229,9 @@
  *	all QE there are and wake up all the waiters before exiting.
  */
 
-unsigned int aac_intr_normal(struct aac_dev * dev, u32 Index)
+unsigned int aac_intr_normal(struct aac_dev * dev, u32 index)
 {
-	u32 index = le32_to_cpu(Index);
-
-	dprintk((KERN_INFO "aac_intr_normal(%p,%x)\n", dev, Index));
+	dprintk((KERN_INFO "aac_intr_normal(%p,%x)\n", dev, index));
 	if ((index & 0x00000002L)) {
 		struct hw_fib * hw_fib;
 		struct fib * fib;
@@ -301,7 +299,7 @@
 
 		if (hwfib->header.Command == cpu_to_le16(NuFileSystem))
 		{
-			u32 *pstatus = (u32 *)hwfib->data;
+			__le32 *pstatus = (__le32 *)hwfib->data;
 			if (*pstatus & cpu_to_le32(0xffff0000))
 				*pstatus = cpu_to_le32(ST_OK);
 		}
Index: linux-2.6/drivers/scsi/aacraid/linit.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aacraid/linit.c	2007-11-08 17:09:50.000000000 +0100
+++ linux-2.6/drivers/scsi/aacraid/linit.c	2007-11-08 17:14:43.000000000 +0100
@@ -584,8 +584,8 @@
 	 * support a register, instead of a commanded, reset.
 	 */
 	if ((aac->supplement_adapter_info.SupportedOptions2 &
-	  le32_to_cpu(AAC_OPTION_MU_RESET|AAC_OPTION_IGNORE_RESET)) ==
-	  le32_to_cpu(AAC_OPTION_MU_RESET))
+	     cpu_to_le32(AAC_OPTION_MU_RESET|AAC_OPTION_IGNORE_RESET)) ==
+	     cpu_to_le32(AAC_OPTION_MU_RESET))
 		aac_reset_adapter(aac, 2); /* Bypass wait for command quiesce */
 	return SUCCESS; /* Cause an immediate retry of the command with a ten second delay after successful tur */
 }
Index: linux-2.6/drivers/scsi/aacraid/rx.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aacraid/rx.c	2007-11-08 17:09:50.000000000 +0100
+++ linux-2.6/drivers/scsi/aacraid/rx.c	2007-11-08 17:14:43.000000000 +0100
@@ -465,7 +465,7 @@
 	u32 var;
 
 	if (!(dev->supplement_adapter_info.SupportedOptions2 &
-	  le32_to_cpu(AAC_OPTION_MU_RESET)) || (bled >= 0) || (bled == -2)) {
+	    cpu_to_le32(AAC_OPTION_MU_RESET)) || (bled >= 0) || (bled == -2)) {
 		if (bled)
 			printk(KERN_ERR "%s%d: adapter kernel panic'd %x.\n",
 				dev->name, dev->id, bled);
