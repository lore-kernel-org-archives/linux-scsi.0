From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Mon, 19 Sep 2005 21:39:32 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0509192040360.4404@kai.makisara.local>
References: <1126845599.9276.44.camel@max>  <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>
  <432C39BC.1030105@cs.wisc.edu>  <432C3C75.5090405@cs.wisc.edu>
 <1126974325.10413.5.camel@max>  <Pine.LNX.4.61.0509181456370.14776@kai.makisara.local>
  <432D81BD.9080803@cs.wisc.edu> <432D8515.9010809@cs.wisc.edu>
 <Pine.LNX.4.61.0509182031090.15507@kai.makisara.local> <1127061365.800.1.camel@max>
 <432D97F2.5040508@cs.wisc.edu> <Pine.LNX.4.61.0509182155350.15507@kai.makisara.local>
 <432D9D53.3070706@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep19-0.kolumbus.fi ([193.229.0.45]:54218 "EHLO
	fep19-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S932559AbVISSeI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2005 14:34:08 -0400
In-Reply-To: <432D9D53.3070706@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Sun, 18 Sep 2005, Mike Christie wrote:

> Kai Makisara wrote:
> > 
> > This solves the problem. All works properly and if I try some mt command
> > after filemark detection, the residual is correctly zero.
> 
> ok thanks for having patience with me and testing so much.
> 
Thanks for making the code. But we still have some problems left.

I have tested writing big blocks. The writing fails if the block 
size exceeds 512 kB. Below are the details I have found out so far.

The system uses sym53c8xx_2. It does not enable clustering by default but 
I changed this. The driver supports up to 96 s/g segments.

I have added some printks to see where the process hangs. The following is 
output related to the write command when the command
dd if=tdata of=/dev/nst0 bs=512k count=1
is used (this succeeds):

Sep 19 20:27:48 box kernel: st: about to send cmd 0x0a segs 1
Sep 19 20:27:48 box kernel: queuecommand: cmd[0]=0x0a
Sep 19 20:27:48 box kernel: sym_scatter: use_sg=8
Sep 19 20:27:48 box kernel: st: async ccmd sent.
Sep 19 20:27:48 box kernel: st: cmd=0x0a result=0x0 resid=0 sense[0]=0x00 
sense[2]=0x00

st sends the command using a buffer of one segment. The command is passed 
to the HBA driver and it sees 8 segments. Clustering seems to work 
properly (the maximum segment size is set to 65536 bytes by default). 

Here is what is seen when the block size is increased to 513 kB:
dd if=tdata of=/dev/nst0 bs=513k count=1

The dd process hangs in device wait. It turns out that 
scsi_execute_async() fails. This is an async write and the process later 
waits for the failed write to finish. The patch at the end of this message 
fixes this st bug (don't worry about the line shifts, I have some 
debugging printks in this driver).

The real problem is that scsi_execute_async() fails. The 513 kB request is 
129 pages. Could the reason be related to these defaults in include/linux?
#define MAX_PHYS_SEGMENTS 128
#define MAX_HW_SEGMENTS 128

-- 
Kai

-------------------------------8<------------------------------------------
--- linux-2.6.14-rc1-blk3/drivers/scsi/st.c.org	2005-09-16 20:37:19.000000000 +0300
+++ linux-2.6.14-rc1-blk3/drivers/scsi/st.c	2005-09-19 21:21:02.000000000 +0300
@@ -507,6 +510,7 @@
 
 	memcpy(SRpnt->cmd, cmd, sizeof(SRpnt->cmd));
 	STp->buffer->cmdstat.have_sense = 0;
+	STp->buffer->syscall_result = 0;
 
 	if (scsi_execute_async(STp->device, cmd, direction,
 			&((STp->buffer)->sg[0]), 0, (STp->buffer)->sg_segs,
@@ -1623,7 +1627,7 @@
 			retval = STbp->syscall_result;
 			goto out;
 		}
-		if (async_write) {
+		if (async_write && !STbp->syscall_result) {
 			STbp->writing = transfer;
 			STp->dirty = !(STbp->writing ==
 				       STbp->buffer_bytes);
@@ -1697,7 +1701,7 @@
 			} else {
 				count += do_count;
 				STps->drv_block = (-1);		/* Too cautious? */
-				retval = (-EIO);
+				retval = STbp->syscall_result;
 			}
 
 		}
