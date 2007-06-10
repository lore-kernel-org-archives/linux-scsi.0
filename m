From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Error in SCSI module for Adaptec 29320A
Date: Sat, 09 Jun 2007 19:25:59 -0500
Message-ID: <1181435159.4195.13.camel@mulgrave.il.steeleye.com>
References: <466A0AB0.8060308@activesec.biz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:45472 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758218AbXFJA0B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jun 2007 20:26:01 -0400
In-Reply-To: <466A0AB0.8060308@activesec.biz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Federico Petronio <fpetronio@activesec.biz>
Cc: linux-scsi@vger.kernel.org

On Fri, 2007-06-08 at 23:04 -0300, Federico Petronio wrote:
> I write to you since you appear as the maintainer for the SCSI subsystem
> of the 2.6.x kernel. This is a report for a, possible, bug or hardware
> error. I would be grateful if you can help me figure out if it's a bug
> or a hardware error.

Actually, no-one really maintains this driver, although Hannes has been
doing a sterling job under trying circumstances.  The main problem being
that no-one seems to have access to the documentation about the device.

> EXT3-fs: mounted filesystem with ordered data mode.
> scsi0: Transmission error detected

This is basically a hardware error.  It can be caused by many things:
marginal cables, reflections in the transmission lines, marginal
transcievers etc.  It's only seen when Information Units are in effect.
You can alter this by 

echo 0 > /sys/class/spi_transport/target<location of device>/iu

But it will force the device from U320 to U160.  If you still get parity
errors at U160, I'd start to look at cabling problems

> LQISTAT1[0x8]:(LQICRCI_NLQ) LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE)
> SCSISIGI[0xa0]:(P_MESGOUT) PERRDIAG[0x24]:(CRCERR|PREVPHASE)
> >>>>>>>>>>>>>>>>>>
> Dump Card State Begins
> <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x31 Mode 0x11
> Card was paused
> INTSTAT[0x8]:(SCSIINT) SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0]
> INTCTL[0x80]:(SWTMINTMASK) SEQINTSTAT[0x0] SAVED_MODE[0x11]
> DFFSTAT[0x24]:(CURRFIFO_0|FIFO1FREE)
> SCSISIGI[0xb6]:(P_MESGOUT|REQI|BSYI|ATNI)
> SCSIPHASE[0x4]:(MSG_OUT_PHASE) SCSIBUS[0xf7]
> LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE)
> SCSISEQ0[0x0] SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI)
> SEQCTL0[0x0] SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0]
> QFREEZE_COUNT[0x1] KERNEL_QFREEZE_COUNT[0x1] MK_MESSAGE_SCB[0xff00]
> MK_MESSAGE_SCSIID[0xff] SSTAT0[0x2]:(SPIORDY)
> SSTAT1[0x11]:(REQINIT|PHASEMIS)
> SSTAT2[0x20]:(NONPACKREQ) SSTAT3[0x0] PERRDIAG[0x0]
> SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO)
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0xc0]:(LQIPHASE_OUTPKT|PACKETIZED)
> LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0xe1]:(LQOSTOP0|LQOPKT)
> 
> SCB Count = 32 CMDS_PENDING = 1 LASTSCB 0xb CURRSCB 0xb NEXTSCB 0xff00
> qinstart = 1271 qinfifonext = 1271
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>  11 FIFO_USE[0x1] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x7]
> Total 1
> Kernel Free SCB list: 16 27 29 15 25 17 23 3 10 9 8 13 24 14 2 30 5 1 20
> 19 26 7 18 0 6 28 31 21 4 22 12
> Sequencer Complete DMA-inprog list:
> Sequencer Complete list:
> Sequencer DMA-Up and Complete list:
> Sequencer On QFreeze and Complete list:
> 
> 
> scsi0: FIFO0 Active, LONGJMP == 0x24c, SCB 0xb
> SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS)
> SEQINTSRC[0x0] DFCNTRL[0x8]:(HDMAEN)
> DFSTATUS[0xc8]:(HDONE|PKT_PRELOAD_AVAIL|PRELOAD_AVAIL)
> SG_CACHE_SHADOW[0x30] SG_STATE[0x3]:(SEGS_AVAIL|LOADING_NEEDED)
> DFFSXFRCTL[0x0] SOFFCNT[0x0]
> MDFFSTAT[0x46]:(DATAINFIFO|DLZERO|SHCNTNEGATIVE)
> SHADDR = 0x03f32c200, SHCNT = 0xfffe00 HADDR = 0x03f32c000, HCNT = 0x0
> CCSGCTL[0x10]:(SG_CACHE_AVAIL)
> 
> scsi0: FIFO1 Free, LONGJMP == 0x8063, SCB 0x3
> SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS)
> SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
> SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0]
> SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x0]
> LQIN: 0x5 0x0 0x0 0xb 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x72 0x0
> 0x0 0x0 0x2 0x0
> scsi0: LQISTATE = 0x2b, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc]:(ENOVERRUN|ENIOERR)
> CCSCBCTL[0x4]:(CCSCBDIR)
> scsi0: REG0 == 0x3, SINDEX = 0x130, DINDEX = 0x102
> scsi0: SCBPTR == 0x3, SCB_NEXT == 0xffc0, SCB_NEXT2 == 0xfff1
> CDB 0 14 0 80 10 c
> STACK: 0x1f 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<<
> Dump Card State Ends
> >>>>>>>>>>>>>>>>>>
> LQICRC_NLQ
> LQIRETRY for LQIPHASE_OUTPKT
> scsi0: Returning to Idle Loop
> scsi0: device overrun (status a) on 0:0:0

This looks like the standard death spiral the driver goes into.  It
should be recoverable (until the next transmission error) by resetting
the device, but somehow that never seems to happen correctly.

So, to answer your initial question: it's both a hardware error and a
driver error (because the driver should have been able to recover).

James


