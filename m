From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: BUG 2.6.24-rc4-mm1 -- Boot still hangs w/ async scsi scan
Date: Fri, 07 Dec 2007 14:38:59 -0500
Message-ID: <1197056339.5293.65.camel@localhost>
References: <1196872599.5346.8.camel@localhost>
	 <20071205132043.a80853d9.akpm@linux-foundation.org>
	 <1196964862.5293.34.camel@localhost>
	 <20071206103531.ea74d4bc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:1235 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbXLGTik (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2007 14:38:40 -0500
In-Reply-To: <20071206103531.ea74d4bc.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, Eric.Moore@lsi.com, Eric Whitney <eric.whitney@hp.com>

On Thu, 2007-12-06 at 10:35 -0800, Andrew Morton wrote:
> On Thu, 06 Dec 2007 13:14:22 -0500 Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> 
> > On Wed, 2007-12-05 at 13:20 -0800, Andrew Morton wrote:
> > > On Wed, 05 Dec 2007 11:36:39 -0500
> > > Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> > > 
> > > > As reported here:
> > > > 
> > > > 	http://marc.info/?l=linux-scsi&m=119645761124683&w=4
> > > > 
> > > > against 24-rc3-mm2, I'm still seeing the hang on my HP ia64 NUMA
> > > > platform under 24-rc4-mm1 with async scsi scan enabled.  I'm still
> > > > seeing the message  "mptspi: ioc#: mpt_config failed" when it hangs. 
> > > > 
> > > > I can boot by disabling async scan.  However, I've also noticed some
> > > > disks attached via one of the "mpt" adapters ["scsi8" in console long in
> > > > message linked above] going "off-line" during stress tests.  This was
> > > > under 24-rc3-mm2.  Haven't got that far yet with 24-rc4-mm1.
> > > > 
> > > 
> > > Is ther any way of tricking you into
> > > http://www.zip.com.au/~akpm/linux/patches/stuff/bisecting-mm-trees.txt?
> > > 
> > > Obvious culprits to start with would be git-scsi-misc and maybe
> > > scsi-early-detection-of-medium-not-present-updated.patch.  But there are
> > > only 20-odd scsi patches in there.
> > 
> > The reported hang occurs after pushing the git-scsi-misc patch.
> 
> OK, thanks.

More info on the hang.

I thought I'd enable the debug prints in just mpt_config() to see if I
could see why it "failed" when the hang occurs.  [Hacky patch below.].
However, when I enable the printk's the system boots fine with
git-scsi-misc applied, even with async scan enabled.  An extract of the
console log of the messages is included below, in case that provides a
clue to anyone who might care.

One other thing:  If I leave the system in the hung state long enough, I
start seeing stack dumps and messages about tasks blocked for more than
120 seconds [swapper and scsi_scan_[89]].  Section of the log included
below.

I'll keep investigating in the background...

Lee

-------------------------------

temp mpt debug patch

 drivers/message/fusion/mptbase.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: Linux/drivers/message/fusion/mptbase.c
===================================================================
--- Linux.orig/drivers/message/fusion/mptbase.c	2007-12-07 12:12:00.000000000 -0500
+++ Linux/drivers/message/fusion/mptbase.c	2007-12-07 12:16:29.000000000 -0500
@@ -5633,6 +5633,9 @@ SendEventAck(MPT_ADAPTER *ioc, EventNoti
  *	-EAGAIN if no msg frames currently available
  *	-EFAULT for non-successful reply or no reply (timeout)
  */
+// brute force enable dcprintk for just this function
+#undef dcprintk
+#define dcprintk(IOC, CMD) CMD
 int
 mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
 {
@@ -5746,6 +5749,8 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS
 
 	return rc;
 }
+#undef dcprintk
+#define dcprintk(IOC, CMD)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**

-----------------------------------------------
console log extract of messages from patch above:

Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.06
GSI 43 (level, low) -> CPU 2 (0x0800) vector 74
ACPI: PCI Interrupt 0000:38:01.0[A] -> GSI 43 (level, low) -> IRQ 74
mptbase: ioc0: Initiating bringup
ioc0: LSI53C1030 C0: Capabilities={Initiator,Target}
mptbase: ioc0: Sending Config request type 3, page 0 and action 0
mptbase: ioc0: Sending Config request type 3, page 0 and action 1
mptbase: ioc0: Sending Config request type 3, page 2 and action 0
mptbase: ioc0: Sending Config request type 3, page 2 and action 6
mptbase: ioc0: Sending Config request type 4, page 1 and action 0
mptbase: ioc0: Sending Config request type 4, page 0 and action 0
mptbase: ioc0: Sending Config request type 1, page 1 and action 0
mptbase: ioc0: Sending Config request type 1, page 1 and action 1
mptbase: ioc0: Sending Config request type 1, page 4 and action 0
mptbase: ioc0: Sending Config request type 1, page 4 and action 1
mptbase: ioc0: Sending Config request type 0, page 2 and action 0
mptbase: ioc0: Sending Config request type 0, page 2 and action 1
mptbase: ioc0: Sending Config request type 9, page 0 and action 0
mptbase: ioc0: Sending Config request type 9, page 0 and action 1
scsi8 : ioc0: LSI53C1030 C0, FwRev=01032341h, Ports=1, MaxQ=255, IRQ=74
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
GSI 44 (level, low) -> CPU 3 (0x0c00) vector 75
ACPI: PCI Interrupt 0000:38:01.1[B] -> GSI 44 (level, low) -> IRQ 75
mptbase: ioc1: Initiating bringup
ioc1: LSI53C1030 C0: Capabilities={Initiator,Target}
mptbase: ioc1: Sending Config request type 3, page 0 and action 0
scsi 8:0:0:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target8:0:0: Beginning Domain Validation
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 3, page 0 and action 1
mptbase: ioc1: Sending Config request type 3, page 2 and action 0
mptbase: ioc1: Sending Config request type 3, page 2 and action 6
mptbase: ioc1: Sending Config request type 4, page 1 and action 0
mptbase: ioc1: Sending Config request type 4, page 0 and action 0
mptbase: ioc1: Sending Config request type 1, page 1 and action 0
mptbase: ioc1: Sending Config request type 1, page 1 and action 1
mptbase: ioc1: Sending Config request type 1, page 4 and action 0
mptbase: ioc1: Sending Config request type 1, page 4 and action 1
mptbase: ioc1: Sending Config request type 0, page 2 and action 0
mptbase: ioc1: Sending Config request type 0, page 2 and action 1
mptbase: ioc1: Sending Config request type 9, page 0 and action 0
mptbase: ioc1: Sending Config request type 9, page 0 and action 1
scsi9 : ioc1: LSI53C1030 C0, FwRev=01032341h, Ports=1, MaxQ=255, IRQ=75
scsi 1:0:2:0: CD-ROM            HP       DVD-ROM 305      1.01 PQ: 0 ANSI: 2
 target1:0:2: Beginning Domain Validation
 target1:0:2: asynchronous
 target1:0:2: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 16)
 target1:0:2: Domain Validation skipping write tests
 target1:0:2: Ending Domain Validation
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mice: PS/2 mouse device common for all mice
EFI Variables Facility v0.08 2004-May-17
scsi 9:0:0:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:0: Beginning Domain Validation
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
 target9:0:0: Ending Domain Validation
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
 target9:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
scsi 9:0:1:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:1: Beginning Domain Validation
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
 target9:0:1: Ending Domain Validation
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
 target9:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
scsi 9:0:2:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:2: Beginning Domain Validation
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
 target9:0:2: Ending Domain Validation
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
 target9:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
scsi 9:0:3:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:3: Beginning Domain Validation
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
 target9:0:3: Ending Domain Validation
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
 target9:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
scsi 9:0:4:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:4: Beginning Domain Validation
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
 target9:0:4: Ending Domain Validation
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
 target9:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
scsi 9:0:5:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:5: Beginning Domain Validation
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
 target9:0:5: Ending Domain Validation
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
 target9:0:5: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
scsi 9:0:8:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target9:0:8: Beginning Domain Validation
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
 target9:0:8: Ending Domain Validation
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
 target9:0:8: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
mptbase: ioc1: Sending Config request type 4, page 0 and action 1
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
scsi 2:0:6:0: Direct-Access     HP 36.4G ST336753LC       HPC3 PQ: 0 ANSI: 3
 target2:0:6: tagged command queuing enabled, command queue depth 16.
 target2:0:6: Beginning Domain Validation
 target2:0:6: asynchronous
 target2:0:6: wide asynchronous
 target2:0:6: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 31)
 target2:0:6: Domain Validation skipping write tests
 target2:0:6: Ending Domain Validation
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
registered taskstats version 1
scsi: waiting for bus probes to complete ...
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc1: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
 target8:0:0: Ending Domain Validation
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
 target8:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
scsi 8:0:1:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target8:0:1: Beginning Domain Validation
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
scsi 0:0:6:0: Direct-Access     HP 36.4G ST336753LC       HPC3 PQ: 0 ANSI: 3
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
 target8:0:1: Ending Domain Validation
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
 target8:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
scsi 8:0:2:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target8:0:2: Beginning Domain Validation
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
 target8:0:2: Ending Domain Validation
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
 target8:0:2: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
scsi 8:0:3:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target8:0:3: Beginning Domain Validation
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
 target8:0:3: Ending Domain Validation
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
 target8:0:3: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
scsi 8:0:4:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target8:0:4: Beginning Domain Validation
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
 target8:0:4: Ending Domain Validation
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
 target8:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
scsi 8:0:5:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target8:0:5: Beginning Domain Validation
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
 target8:0:5: Ending Domain Validation
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
 target8:0:5: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
scsi 8:0:8:0: Direct-Access     COMPAQ   BF036863B9       HPB4 PQ: 0 ANSI: 3
 target8:0:8: Beginning Domain Validation
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
 target8:0:8: Ending Domain Validation
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
 target8:0:8: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, offset 127)
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
scsi 8:0:15:0: Processor         COMPAQ   PROLIANT 4L7E*DB 2.14 PQ: 0 ANSI: 2
 target8:0:15: Beginning Domain Validation
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
 target8:0:15: Ending Domain Validation
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
 target8:0:15: asynchronous
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
 target0:0:6: tagged command queuing enabled, command queue depth 16.
 target0:0:6: Beginning Domain Validation
 target0:0:6: asynchronous
 target0:0:6: wide asynchronous
 target0:0:6: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 31)
 target0:0:6: Domain Validation skipping write tests
 target0:0:6: Ending Domain Validation
sd 0:0:6:0: [sda] 71132960 512-byte hardware sectors (36420 MB)
sd 0:0:6:0: [sda] Write Protect is off
sd 0:0:6:0: [sda] Mode Sense: d3 00 10 08
sd 0:0:6:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 0:0:6:0: [sda] 71132960 512-byte hardware sectors (36420 MB)
sd 0:0:6:0: [sda] Write Protect is off
sd 0:0:6:0: [sda] Mode Sense: d3 00 10 08
sd 0:0:6:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7 sda8 sda9 sda10
sd 0:0:6:0: [sda] Attached SCSI disk
sd 2:0:6:0: [sdb] 71132960 512-byte hardware sectors (36420 MB)
sd 2:0:6:0: [sdb] Write Protect is off
sd 2:0:6:0: [sdb] Mode Sense: d3 00 10 08
sd 2:0:6:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 2:0:6:0: [sdb] 71132960 512-byte hardware sectors (36420 MB)
sd 2:0:6:0: [sdb] Write Protect is off
sd 2:0:6:0: [sdb] Mode Sense: d3 00 10 08
sd 2:0:6:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdb: sdb1 sdb2 sdb3 sdb4 sdb5 sdb6 sdb7 sdb8 sdb9 sdb10
sd 2:0:6:0: [sdb] Attached SCSI disk
sd 8:0:0:0: [sdc] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:0:0: [sdc] Write Protect is off
sd 8:0:0:0: [sdc] Mode Sense: e7 00 10 08
sd 8:0:0:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 8:0:0:0: [sdc] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:0:0: [sdc] Write Protect is off
sd 8:0:0:0: [sdc] Mode Sense: e7 00 10 08
sd 8:0:0:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdc: sdc1 sdc2 sdc3
sd 8:0:0:0: [sdc] Attached SCSI disk
sd 8:0:1:0: [sdd] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:1:0: [sdd] Write Protect is off
sd 8:0:1:0: [sdd] Mode Sense: e7 00 10 08
sd 8:0:1:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 8:0:1:0: [sdd] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:1:0: [sdd] Write Protect is off
sd 8:0:1:0: [sdd] Mode Sense: e7 00 10 08
sd 8:0:1:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdd: sdd1 sdd2 sdd3
sd 8:0:1:0: [sdd] Attached SCSI disk
sd 8:0:2:0: [sde] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:2:0: [sde] Write Protect is off
sd 8:0:2:0: [sde] Mode Sense: e7 00 10 08
sd 8:0:2:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 8:0:2:0: [sde] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:2:0: [sde] Write Protect is off
sd 8:0:2:0: [sde] Mode Sense: e7 00 10 08
sd 8:0:2:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sde:<4>GPT:disk_guids don't match.
GPT:partition_entry_array_crc32 values don't match: 0x413661e0 != 0x36c03570
GPT: Use GNU Parted to correct GPT errors.
 sde1 sde2 sde3
sd 8:0:2:0: [sde] Attached SCSI disk
sd 8:0:3:0: [sdf] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:3:0: [sdf] Write Protect is off
sd 8:0:3:0: [sdf] Mode Sense: e7 00 10 08
sd 8:0:3:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 8:0:3:0: [sdf] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:3:0: [sdf] Write Protect is off
sd 8:0:3:0: [sdf] Mode Sense: e7 00 10 08
sd 8:0:3:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdf: sdf1 sdf2 sdf3
sd 8:0:3:0: [sdf] Attached SCSI disk
sd 8:0:4:0: [sdg] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:4:0: [sdg] Write Protect is off
sd 8:0:4:0: [sdg] Mode Sense: e7 00 10 08
sd 8:0:4:0: [sdg] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 8:0:4:0: [sdg] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:4:0: [sdg] Write Protect is off
sd 8:0:4:0: [sdg] Mode Sense: e7 00 10 08
sd 8:0:4:0: [sdg] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdg: sdg1 sdg2 sdg3
sd 8:0:4:0: [sdg] Attached SCSI disk
sd 8:0:5:0: [sdh] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:5:0: [sdh] Write Protect is off
sd 8:0:5:0: [sdh] Mode Sense: e7 00 10 08
sd 8:0:5:0: [sdh] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 8:0:5:0: [sdh] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:5:0: [sdh] Write Protect is off
sd 8:0:5:0: [sdh] Mode Sense: e7 00 10 08
sd 8:0:5:0: [sdh] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdh: sdh1
sd 8:0:5:0: [sdh] Attached SCSI disk
sd 8:0:8:0: [sdi] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:8:0: [sdi] Write Protect is off
sd 8:0:8:0: [sdi] Mode Sense: e7 00 10 08
sd 8:0:8:0: [sdi] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 8:0:8:0: [sdi] 71132000 512-byte hardware sectors (36420 MB)
sd 8:0:8:0: [sdi] Write Protect is off
sd 8:0:8:0: [sdi] Mode Sense: e7 00 10 08
sd 8:0:8:0: [sdi] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdi:<6>sd 8:0:8:0: [sdi] Sense Key : 0x1 [current] 
sd 8:0:8:0: [sdi] ASC=0x5d ASCQ=0x32
 sdi1
sd 8:0:8:0: [sdi] Attached SCSI disk
sd 9:0:0:0: [sdj] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:0:0: [sdj] Write Protect is off
sd 9:0:0:0: [sdj] Mode Sense: e7 00 10 08
sd 9:0:0:0: [sdj] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 9:0:0:0: [sdj] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:0:0: [sdj] Write Protect is off
sd 9:0:0:0: [sdj] Mode Sense: e7 00 10 08
sd 9:0:0:0: [sdj] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdj: sdj1
sd 9:0:0:0: [sdj] Attached SCSI disk
sd 9:0:1:0: [sdk] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:1:0: [sdk] Write Protect is off
sd 9:0:1:0: [sdk] Mode Sense: e7 00 10 08
sd 9:0:1:0: [sdk] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 9:0:1:0: [sdk] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:1:0: [sdk] Write Protect is off
sd 9:0:1:0: [sdk] Mode Sense: e7 00 10 08
sd 9:0:1:0: [sdk] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdk: sdk1
sd 9:0:1:0: [sdk] Attached SCSI disk
sd 9:0:2:0: [sdl] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:2:0: [sdl] Write Protect is off
sd 9:0:2:0: [sdl] Mode Sense: e7 00 10 08
sd 9:0:2:0: [sdl] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 9:0:2:0: [sdl] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:2:0: [sdl] Write Protect is off
sd 9:0:2:0: [sdl] Mode Sense: e7 00 10 08
sd 9:0:2:0: [sdl] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdl: sdl1
sd 9:0:2:0: [sdl] Attached SCSI disk
sd 9:0:3:0: [sdm] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:3:0: [sdm] Write Protect is off
sd 9:0:3:0: [sdm] Mode Sense: e7 00 10 08
sd 9:0:3:0: [sdm] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 9:0:3:0: [sdm] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:3:0: [sdm] Write Protect is off
sd 9:0:3:0: [sdm] Mode Sense: e7 00 10 08
sd 9:0:3:0: [sdm] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdm: sdm1
sd 9:0:3:0: [sdm] Attached SCSI disk
sd 9:0:4:0: [sdn] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:4:0: [sdn] Write Protect is off
sd 9:0:4:0: [sdn] Mode Sense: e7 00 10 08
sd 9:0:4:0: [sdn] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 9:0:4:0: [sdn] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:4:0: [sdn] Write Protect is off
sd 9:0:4:0: [sdn] Mode Sense: e7 00 10 08
sd 9:0:4:0: [sdn] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdn: sdn1
sd 9:0:4:0: [sdn] Attached SCSI disk
sd 9:0:5:0: [sdo] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:5:0: [sdo] Write Protect is off
sd 9:0:5:0: [sdo] Mode Sense: e7 00 10 08
sd 9:0:5:0: [sdo] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 9:0:5:0: [sdo] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:5:0: [sdo] Write Protect is off
sd 9:0:5:0: [sdo] Mode Sense: e7 00 10 08
sd 9:0:5:0: [sdo] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdo: sdo1 sdo2 sdo3
sd 9:0:5:0: [sdo] Attached SCSI disk
sd 9:0:8:0: [sdp] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:8:0: [sdp] Write Protect is off
sd 9:0:8:0: [sdp] Mode Sense: e7 00 10 08
sd 9:0:8:0: [sdp] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 9:0:8:0: [sdp] 71132000 512-byte hardware sectors (36420 MB)
sd 9:0:8:0: [sdp] Write Protect is off
sd 9:0:8:0: [sdp] Mode Sense: e7 00 10 08
sd 9:0:8:0: [sdp] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdp: sdp1
sd 9:0:8:0: [sdp] Attached SCSI disk

-----------------------------------------------
task blocked log when I leave the system in the hung state for a couple of minutes:

INFO: task swapper:1 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
swapper       D a0000001006cc530     0     1      0

Call Trace:
 [<a0000001006caa70>] schedule+0xa30/0x1e80
                                sp=e00007018143fd80 bsp=e000070181438e58
 [<a0000001006cc530>] schedule_timeout+0x110/0x1a0
                                sp=e00007018143fda0 bsp=e000070181438e28
 [<a0000001006c9d40>] wait_for_common+0x1a0/0x300
                                sp=e00007018143fdd0 bsp=e000070181438dd0
 [<a0000001006ca020>] wait_for_completion+0x40/0x60
                                sp=e00007018143fe00 bsp=e000070181438db0
 [<a0000001004ceba0>] scsi_complete_async_scans+0x1c0/0x240
                                sp=e00007018143fe00 bsp=e000070181438d68
 [<a0000001008305b0>] kernel_init+0x330/0x820
                                sp=e00007018143fe00 bsp=e000070181438d08
 [<a000000100012ab0>] kernel_thread_helper+0x30/0x60
                                sp=e00007018143fe30 bsp=e000070181438ce0
 [<a0000001000089c0>] start_kernel_thread+0x20/0x40
                                sp=e00007018143fe30 bsp=e000070181438ce0
INFO: task scsi_scan_8:1231 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scsi_scan_8   D a0000001006cc530     0  1231      2

Call Trace:
 [<a0000001006caa70>] schedule+0xa30/0x1e80
                                sp=e000070182777cb0 bsp=e000070182771098
 [<a0000001006cc530>] schedule_timeout+0x110/0x1a0
                                sp=e000070182777cd0 bsp=e000070182771068
 [<a0000001006c9d40>] wait_for_common+0x1a0/0x300
                                sp=e000070182777d00 bsp=e000070182771018
 [<a0000001006ca020>] wait_for_completion+0x40/0x60
                                sp=e000070182777d30 bsp=e000070182770ff0
 [<a0000001002e6da0>] blk_execute_rq+0xe0/0x240
                                sp=e000070182777d30 bsp=e000070182770fb0
 [<a0000001004cc7c0>] scsi_execute+0x180/0x1e0
                                sp=e000070182777dc0 bsp=e000070182770f58
 [<a0000001004cc8f0>] scsi_execute_req+0xd0/0x160
                                sp=e000070182777dc0 bsp=e000070182770ef0
 [<a0000001004d1100>] __scsi_scan_target+0x4c0/0xc40
                                sp=e000070182777dd0 bsp=e000070182770e70
 [<a0000001004d1950>] scsi_scan_channel+0xd0/0x160
                                sp=e000070182777e30 bsp=e000070182770e18
 [<a0000001004d1ac0>] scsi_scan_host_selected+0xe0/0x240
                                sp=e000070182777e30 bsp=e000070182770dc0
 [<a0000001004d1dd0>] do_scsi_scan_host+0x1b0/0x1e0
                                sp=e000070182777e30 bsp=e000070182770d88
 [<a0000001004d1e30>] do_scan_async+0x30/0x300
                                sp=e000070182777e30 bsp=e000070182770d38
 [<a0000001000c7570>] kthread+0x110/0x180
                                sp=e000070182777e30 bsp=e000070182770d08
 [<a000000100012ab0>] kernel_thread_helper+0x30/0x60
                                sp=e000070182777e30 bsp=e000070182770ce0
 [<a0000001000089c0>] start_kernel_thread+0x20/0x40
                                sp=e000070182777e30 bsp=e000070182770ce0
INFO: task scsi_scan_9:1300 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
scsi_scan_9   D a0000001006cc530     0  1300      2

Call Trace:
 [<a0000001006caa70>] schedule+0xa30/0x1e80
                                sp=e000070182917db0 bsp=e000070182910e30
 [<a0000001006cc530>] schedule_timeout+0x110/0x1a0
                                sp=e000070182917dd0 bsp=e000070182910e00
 [<a0000001006c9d40>] wait_for_common+0x1a0/0x300
                                sp=e000070182917e00 bsp=e000070182910da8
 [<a0000001006ca020>] wait_for_completion+0x40/0x60
                                sp=e000070182917e30 bsp=e000070182910d88
 [<a0000001004d1ee0>] do_scan_async+0xe0/0x300
                                sp=e000070182917e30 bsp=e000070182910d38
 [<a0000001000c7570>] kthread+0x110/0x180
                                sp=e000070182917e30 bsp=e000070182910d08
 [<a000000100012ab0>] kernel_thread_helper+0x30/0x60
                                sp=e000070182917e30 bsp=e000070182910ce0
 [<a0000001000089c0>] start_kernel_thread+0x20/0x40
                                sp=e000070182917e30 bsp=e000070182910ce0

<repeats ad nauseum>


