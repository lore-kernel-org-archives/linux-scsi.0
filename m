From: Duncan Gibb <duncangibb@uk.dmgworldmedia.com>
Subject: Re: AIC7902 lockups on Intel SMP (Re: HD somtimes hanging)
Date: 24 Jul 2003 18:02:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1059066139.7650.36.camel@carwash.duncangibb.com>
References: <20030724151233.E9280@laokoon.bug.net>
	<1059057411.6798.30.camel@carwash.duncangibb.com>
	<20030724174451.B14635@laokoon.bug.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [217.169.3.180] ([217.169.3.180]:11974 "EHLO
	carwash.duncangibb.com") by vger.kernel.org with ESMTP
	id S271715AbTGXQrO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jul 2003 12:47:14 -0400
In-Reply-To: <20030724174451.B14635@laokoon.bug.net>
List-Id: linux-scsi@vger.kernel.org
To: Thomas Beutin <tyrone@laokoon.IN-Berlin.DE>
Cc: linux-scsi@vger.kernel.org

On Thu, 2003-07-24 at 16:44, Thomas Beutin wrote:

DG> I built a 2.4.21-bk17 kernel in the hope that this would
DG> have been fixed

TB> what ist the Your version of the aic79xx driver in the
TB> 2.4.21-bk17 kernel?

It's 1.3.10, which I believe is the most recent.  I didn't want to go
blasting it with Justin's source files as they are only advertised as
working for 2.4.20.

TB> Maybe there is a new driver by Justin Gibbs, but i didn't
TB> found anything for the 2.4.21 kernel in
TB> http://people.freebsd.org/~gibbs/linux/SRC/


I also (eventually) managed to compile 2.6.0-test1-ac3 (that DVB code is
a bit of a mess, isn't it?).  That kernel has aic79xx 1.3.9, but I can
reproduce the problem in a slightly less severe form.

The scanner has gone haywire (magnification seems to be locked at
maximum), so I couldn't do a scan that would transfer enough data to
cause the lockup.

Also putting a CD in the drive no longer hangs the scsi subsytem.  But a
recoverable SCSI death still happens if you try even a simple thing like
"cdrecord dev=1,3,0 -atip"...


-- lockup under 2.6.0-test1-ac3 ------------------------------------

scsi1:0:3:0: Attempting to abort cmd f7c37b00: 0x1b 0x0 0x0 0x0 0x1 0x0
scsi1: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi1: Dumping Card State at program address 0x94 Mode 0x33
Card was paused
HS_MAILBOX[0x0] INTCTL[0x80]:(SWTMINTMASK) SEQINTSTAT[0x0]
SAVED_MODE[0x11] DFFSTAT[0x31]:(CURRFIFO_1|FIFO0FREE|FIFO1FREE)
SCSISIGI[0x48]:(P_DATAIN|SELI) SCSIPHASE[0x0] SCSIBUS[0x88]
LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE) SCSISEQ0[0x0]
SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI) SEQCTL0[0x10]:(FASTMODE)
SEQINTCTL[0x80]:(INTVEC1DSL)
SEQ_FLAGS[0xc0]:(NO_CDB_SENT|NOT_IDENTIFIED)
SEQ_FLAGS2[0x0] SSTAT0[0x0] SSTAT1[0x0] SSTAT2[0x0]
SSTAT3[0x0] PERRDIAG[0x8]:(AIPERR)
SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO)
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0]
LQOSTAT1[0x0] LQOSTAT2[0x0]
SCB Count = 4 CMDS_PENDING = 1 LASTSCB 0x3 CURRSCB 0x3 NEXTSCB 0x0
qinstart = 8971 qinfifonext = 8971
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
3 FIFO_USE[0x0] SCB_CONTROL[0x44]:(DISCONNECTED|DISCENB)
SCB_SCSIID[0x37]
Total 1
Kernel Free SCB list: 2 1 0
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:
scsi1: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS)
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL)
scsi1: FIFO1 Free, LONGJMP == 0x81ec, SCB 0x3
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS)
SEQINTSRC[0x0] DFCNTRL[0x4]:(DIRECTION)
DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL)
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0
scsi1: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x42
scsi1: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
SIMODE0[0xc]:(ENOVERRUN|ENIOERR)
CCSCBCTL[0x4]:(CCSCBDIR)
scsi1: REG0 == 0x3, SINDEX = 0x100, DINDEX = 0x1c0
scsi1: SCBPTR == 0x3, SCB_NEXT == 0xffc0, SCB_NEXT2 == 0xffc3
CDB 1b 0 0 0 1 0
STACK: 0x23 0x14 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
DevQ(0:2:0): 0 waiting
DevQ(0:3:0): 0 waiting
DevQ(0:6:0): 0 waiting
DevQ(0:6:1): 0 waiting
DevQ(0:6:2): 0 waiting
DevQ(0:6:3): 0 waiting
DevQ(0:6:4): 0 waiting
DevQ(0:6:5): 0 waiting
DevQ(0:6:6): 0 waiting
DevQ(0:6:7): 0 waiting
(scsi1:A:3:0): Device is disconnected, re-queuing SCB
Recovery code sleeping
(scsi1:A:3:0): Abort Message Sent
Kernel Free SCB list: 2 1 0
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:
scsi1: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS)
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL)
scsi1: FIFO1 Free, LONGJMP == 0x81ec, SCB 0x3
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS)
SEQINTSRC[0x0] DFCNTRL[0x4]:(DIRECTION)
DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL)
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0
scsi1: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x42
scsi1: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
SIMODE0[0xc]:(ENOVERRUN|ENIOERR)
CCSCBCTL[0x4]:(CCSCBDIR)
scsi1: REG0 == 0x3, SINDEX = 0x100, DINDEX = 0x1c0
scsi1: SCBPTR == 0x3, SCB_NEXT == 0xffc0, SCB_NEXT2 == 0xffc3
CDB 1b 0 0 0 1 0
STACK: 0x23 0x14 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
DevQ(0:2:0): 0 waiting
DevQ(0:3:0): 0 waiting
DevQ(0:6:0): 0 waiting
DevQ(0:6:1): 0 waiting
DevQ(0:6:2): 0 waiting
DevQ(0:6:3): 0 waiting
DevQ(0:6:4): 0 waiting
DevQ(0:6:5): 0 waiting
DevQ(0:6:6): 0 waiting
DevQ(0:6:7): 0 waiting
(scsi1:A:3:0): Device is disconnected, re-queuing SCB
Recovery code sleeping
(scsi1:A:3:0): Abort Message Sent

-- five-second pause

Recovery code awake
Timer Expired
Recovery code sleeping

-- five-second pause

Recovery code awake
Timer Expired
scsi1: Device reset returning 0x2003
Recovery SCB completes
Recovery SCB completes

-- ten-second pause

scsi: Device offlined - not ready after error recovery: host 1 channel 0
id 3 lun 0

-- user process unfreezes

-- lockup under 2.6.0-test1-ac3 ------------------------------------


According to dmesg, both the really-scsi and the ide-scsi CD drives
should work:

# dmesg | grep sr
sr0: scsi3-mmc drive: 59x/61x caddy
Attached scsi CD-ROM sr0 at scsi1, channel 0, id 3, lun 0
sr1: scsi3-mmc drive: 0x/0x caddy
Attached scsi CD-ROM sr1 at scsi2, channel 0, id 0, lun 0

# eject /dev/scd1

(the scsi-ide one) works perfectly, but

# eject /dev/scd0
eject: unable to find or open device for: `/dev/scd0'

(dmesg records "cdrom: open failed").


TB> Do You think the problem goes away by using a non SMP kernel?

To be honest, I have tried so many kernels I have forgotten which ones I
tested with SMP disabled.  I will have another go shortly (must get some
real work done).


Cheers


Duncan


