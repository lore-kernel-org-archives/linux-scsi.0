From: Sean Bruno <sean.bruno@dsl-only.net>
Subject: Re: Adaptec 29320 [aic79xx] fails on power cycle of LUN
Date: Thu, 19 Oct 2006 09:18:31 -0700
Message-ID: <1161274711.3204.41.camel@home-desk>
References: <1161210246.3204.17.camel@home-desk>
	 <1161210748.3204.22.camel@home-desk>  <1161237121.15090.9.camel@max>
	 <1161260730.3204.36.camel@home-desk>  <45378767.4080106@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iron2.pdx.net ([69.64.224.71]:26330 "EHLO iron2.pdx.net")
	by vger.kernel.org with ESMTP id S1946191AbWJSQV2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Oct 2006 12:21:28 -0400
In-Reply-To: <45378767.4080106@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Thu, 2006-10-19 at 16:10 +0200, Hannes Reinecke wrote:
> Sean Bruno wrote:
> > On Thu, 2006-10-19 at 01:52 -0400, Mike Christie wrote:
> >> On Wed, 2006-10-18 at 15:32 -0700, Sean Bruno wrote:
> >>> On Wed, 2006-10-18 at 15:24 -0700, Sean Bruno wrote:
> >>>> I have had a tough time tracking this one down, however I can say for
> >>>> certain that the 29320 is really having trouble if a LUN is power
> >>>> cycled.
> >>>>
> >>>> I don't have access to a BUS analyzer right now, but here is my
> >>>> regression.
> >>>>
> >>>> 1.  Hook an external SCSI array/disk to a 29320.
> >>>> 2.  Power up SCSI array/disk
> >>>> 3.  Power up PC with 29320.
> >>>> 4.  When PC has booted, login and test device by creating a file
> >>>>     system, eg. mkfs /dev/sda (or whatever disk the array is called on
> >>>>     ur machine).
> >>>> 5.  Power cycle array/disk
> >>>> 6.  Retest device with another 'mkfs /dev/sda' ... panic/crash/lock-up
> >>>> ensues.
> >>>>
> >>>>
> >>>>
> >>>> This did not happen in 2.6.15.7 but did appear in 2.6.16 and higher.
> >>>>
> > 
> >> Does this only occur with sg or is that the only way you got a trace? In
> >> the original bug report you mentioned it occurring with mkfs, but the
> >> bug oops is from a sg request. Is tdg_2 run while the mkfs is running?
> > 
> > Snippets from 'dmesg' during step 6:
> > 
> > scsi0: Someone reset channel A
> > sd 0:0:4:0: Attempting to queue an ABORT message:CDB: 0x28 0x0 0x0 0x0
> > 0x0 0x80 0x0 0x0 0x80 0x0
> > Infinite interrupt loop, INTSTAT = 8scsi0: At time of recovery, card was
> > paused
> Ah. Hmm. Infinite SCSI interrupt.
> 
> Maybe someone forgot to clear the status ...
> 
> Can you try the attached patch?
> 
> Cheers,
> 
> Hannes

Better.  The patch allows me to cycle power on the array exactly once.
So the new regression is:

1.  Hook an external SCSI array/disk to a 29320.
2.  Power up SCSI array/disk
3.  Power up PC with 29320.
4.  When PC has booted, login and test device by creating a file
    system, eg. mkfs /dev/sda (or whatever disk the array is called on
    ur machine).
5.  Power cycle array/disk
6.  Retest device with another 'mkfs /dev/sda'  <-- works just fine!
7.  Power cycle array/disk
8.  No need to do anything, card dump in dmesg/messages appears and
device in not useable:

Oct 19 09:12:26 testsrv kernel: scsi0: Someone reset channel A
Oct 19 09:16:33 testsrv kernel: scsi0: Unexpected PKT busfree condition
Oct 19 09:16:33 testsrv kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Oct 19 09:16:33 testsrv kernel: scsi0: Dumping Card State at program address 0x20 Mode 0x33
Oct 19 09:16:33 testsrv kernel: Card was paused
Oct 19 09:16:33 testsrv kernel: INTSTAT[0x0] SELOID[0x4] SELID[0x40] HS_MAILBOX[0x0]
Oct 19 09:16:33 testsrv kernel: INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33]
Oct 19 09:16:33 testsrv kernel: SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1]
Oct 19 09:16:33 testsrv kernel: SCSISEQ0[0x0] SCSISEQ1[0x2] SEQCTL0[0x0] SEQINTCTL[0x0]
Oct 19 09:16:33 testsrv kernel: SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x0] QFREEZE_COUNT[0x7]
Oct 19 09:16:33 testsrv kernel: KERNEL_QFREEZE_COUNT[0x7] MK_MESSAGE_SCB[0x2] MK_MESSAGE_SCSIID[0x47]
Oct 19 09:16:33 testsrv kernel: SSTAT0[0x0] SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0]
Oct 19 09:16:33 testsrv kernel: PERRDIAG[0xc0] SIMODE1[0xa4] LQISTAT0[0x0] LQISTAT1[0x0]
Oct 19 09:16:33 testsrv kernel: LQISTAT2[0x0] LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]
Oct 19 09:16:33 testsrv kernel:
Oct 19 09:16:33 testsrv kernel: SCB Count = 4 CMDS_PENDING = 0 LASTSCB 0xffff CURRSCB 0x0 NEXTSCB 0x0
Oct 19 09:16:33 testsrv kernel: qinstart = 52908 qinfifonext = 52908
Oct 19 09:16:33 testsrv kernel: QINFIFO:
Oct 19 09:16:33 testsrv kernel: WAITING_TID_QUEUES:
Oct 19 09:16:33 testsrv kernel: Pending list:
Oct 19 09:16:33 testsrv kernel: Total 0
Oct 19 09:16:33 testsrv kernel: Kernel Free SCB list: 0 1 2 3
Oct 19 09:16:33 testsrv kernel: Sequencer Complete DMA-inprog list:
Oct 19 09:16:33 testsrv kernel: Sequencer Complete list:
Oct 19 09:16:33 testsrv kernel: Sequencer DMA-Up and Complete list:
Oct 19 09:16:33 testsrv kernel: Sequencer On QFreeze and Complete list:
Oct 19 09:16:33 testsrv kernel:
Oct 19 09:16:33 testsrv kernel:
Oct 19 09:16:33 testsrv kernel: scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
Oct 19 09:16:33 testsrv kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
Oct 19 09:16:33 testsrv kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
Oct 19 09:16:33 testsrv kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
Oct 19 09:16:33 testsrv kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
Oct 19 09:16:33 testsrv kernel:
Oct 19 09:16:33 testsrv kernel: scsi0: FIFO1 Free, LONGJMP == 0x81f1, SCB 0x0
Oct 19 09:16:33 testsrv kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89]
Oct 19 09:16:33 testsrv kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
Oct 19 09:16:33 testsrv kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
Oct 19 09:16:33 testsrv kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
Oct 19 09:16:33 testsrv kernel: LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Oct 19 09:16:33 testsrv kernel: scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
Oct 19 09:16:33 testsrv kernel: scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
Oct 19 09:16:33 testsrv kernel: scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
Oct 19 09:16:33 testsrv kernel: SIMODE0[0xc]
Oct 19 09:16:33 testsrv kernel: CCSCBCTL[0x0]
Oct 19 09:16:33 testsrv kernel: scsi0: REG0 == 0xffff, SINDEX = 0x1e0, DINDEX = 0xe1
Oct 19 09:16:33 testsrv kernel: scsi0: SCBPTR == 0x0, SCB_NEXT == 0xffc0, SCB_NEXT2 == 0xff57
Oct 19 09:16:33 testsrv kernel: CDB 2a 0 0 80 9 d0
Oct 19 09:16:33 testsrv kernel: STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Oct 19 09:16:33 testsrv kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>


Sean


