From: Duncan Gibb <duncangibb@uk.dmgworldmedia.com>
Subject: Re: aic79xx U320 + e1000 Intel hangs on Idual Xeon 7505
Date: 09 Apr 2003 16:47:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1049903264.16881.48.camel@astrognat>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-OvuouTJmRxqBnTGhi2eY"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [217.169.3.187] ([217.169.3.187]:33159 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S263522AbTDIPgb (for <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2003 11:36:31 -0400
List-Id: linux-scsi@vger.kernel.org
To: Rohit Gupta <rohit@davsys.com>
Cc: linux-scsi@vger.kernel.org


--=-OvuouTJmRxqBnTGhi2eY
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

A few days ago, you wrote:

RG> I am having system hangs when I place the U320 SCSI card and
RG> the Intel gigabit Server card (copper) on the same bus,
RG> specifically the 100 Mhz bus on the Intel 7505 chipset.

I have a similar setup to you in a machine I built last weekend.  It's
based on a SuperMicro X5DA8 board, which has all the bits you mention on
the motherboard.

The system seems stable, but I am experiencing frequent SCSI bus and
apparent subsystem lockups.

Channel A has only the swap disk attached.

Channel B is:

CD-RW(term enabled)----m/b----|----PCMCIAreader----Scanner----terminator

M/B term is disabled (Adaptec SCSIselect seems to do this in a way the
m/b jumpers don't).  | is a backplate where the bus goes from IDC50-int
to 50MD-ext.  All devices worked fine on an older PCI aic7xxx-based card
but this board does not have enough PCI slots to test in situ.

Scanning at 300dpi in greyscale works fine; colour gets part way and
kills the scsi.  Writing a CD kills the scsi.  SCSI death looks like the
attached portion of /var/log/messages.  Death appears to afflict only
one channel.  "dd if=/dev/sda of=/dev/null" still works at any rate.

I am currently using an unadulterated kernel 2.4.21-pre5-ac3, pending
getting something more recent to build (with ac97).  ide-scsi is also
loaded.

If you've found any way around this apparent problem, or anyone has and
ideas, please let me know.

Cheers


Duncan


--=-OvuouTJmRxqBnTGhi2eY
Content-Disposition: attachment; filename=var_log_messages__edited
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=var_log_messages__edited; charset=UTF-8

Apr  9 14:22:06 localhost kernel: scsi1:0:2:0: Attempting to abort cmd f782=
de00
Apr  9 14:22:06 localhost kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins=
 <<<<<<<<<<<<<<<<<
Apr  9 14:22:06 localhost kernel: scsi1: Dumping Card State at program addr=
ess 0x1a4 Mode 0x33
Apr  9 14:22:06 localhost kernel: Card was paused
Apr  9 14:22:06 localhost kernel: HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0=
x0] SAVED_MODE[0x11]
Apr  9 14:22:06 localhost kernel: DFFSTAT[0x31] SCSISIGI[0x4] SCSIPHASE[0x0=
] SCSIBUS[0x0]
Apr  9 14:22:06 localhost kernel: LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x1=
2] SEQCTL0[0x10]
Apr  9 14:22:06 localhost kernel: SEQINTCTL[0x0] SEQ_FLAGS[0x40] SEQ_FLAGS2=
[0x0] SSTAT0[0x0]
Apr  9 14:22:06 localhost kernel: SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRD=
IAG[0x0]
Apr  9 14:22:06 localhost kernel: SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0]=
 LQISTAT2[0x0]
Apr  9 14:22:06 localhost kernel: LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]
Apr  9 14:22:06 localhost kernel:
Apr  9 14:22:06 localhost kernel: SCB Count =3D 4 CMDS_PENDING =3D 1 LASTSC=
B 0x2 CURRSCB 0x2 NEXTSCB 0x0
Apr  9 14:22:06 localhost kernel: qinstart =3D 10969 qinfifonext =3D 10970
Apr  9 14:22:06 localhost kernel: QINFIFO: 0x3
Apr  9 14:22:06 localhost kernel: WAITING_TID_QUEUES:
Apr  9 14:22:06 localhost kernel: Pending list:
Apr  9 14:22:06 localhost kernel:   3 SCB_CONTROL[0x48] SCB_SCSIID[0x27] SC=
B_TAG[0x3]
Apr  9 14:22:06 localhost kernel:   2 SCB_CONTROL[0x0] SCB_SCSIID[0x37] SCB=
_TAG[0x2]
Apr  9 14:22:06 localhost kernel: Total 2
Apr  9 14:22:06 localhost kernel: Kernel Free SCB list: 1 0
Apr  9 14:22:06 localhost kernel: Sequencer Complete DMA-inprog list:
Apr  9 14:22:06 localhost kernel: Sequencer Complete list:
Apr  9 14:22:06 localhost kernel: Sequencer DMA-Up and Complete list:
Apr  9 14:22:06 localhost kernel:
Apr  9 14:22:06 localhost kernel: scsi1: FIFO0 Free, LONGJMP =3D=3D 0x80ff,=
 SCB 0x0, LJSCB 0xff00
Apr  9 14:22:06 localhost kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0=
] DFSTATUS[0x89]
Apr  9 14:22:06 localhost kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXF=
RCTL[0x0]
Apr  9 14:22:06 localhost kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR =3D 0x0=
0, SHCNT =3D 0x0
Apr  9 14:22:06 localhost kernel: HADDR =3D 0x00, HCNT =3D 0x0 CCSGCTL[0x10=
]
Apr  9 14:22:06 localhost kernel: scsi1: FIFO1 Free, LONGJMP =3D=3D 0x81e8,=
 SCB 0x3, LJSCB 0x2
Apr  9 14:22:06 localhost kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0=
] DFSTATUS[0x89]
Apr  9 14:22:06 localhost kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXF=
RCTL[0x0]
Apr  9 14:22:06 localhost kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR =3D 0x0=
0, SHCNT =3D 0x0
Apr  9 14:22:06 localhost kernel: HADDR =3D 0x00, HCNT =3D 0x0 CCSGCTL[0x10=
]
Apr  9 14:22:06 localhost kernel: LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0=
 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Apr  9 14:22:06 localhost kernel: scsi1: LQISTATE =3D 0x0, LQOSTATE =3D 0x0=
, OPTIONMODE =3D 0x42
Apr  9 14:22:06 localhost kernel: scsi1: OS_SPACE_CNT =3D 0x20 MAXCMDCNT =
=3D 0x0
Apr  9 14:22:06 localhost kernel: SIMODE0[0xc]
Apr  9 14:22:06 localhost kernel: CCSCBCTL[0x0]
Apr  9 14:22:06 localhost kernel: scsi1: REG0 =3D=3D 0x3, SINDEX =3D 0x133,=
 DINDEX =3D 0x108
Apr  9 14:22:06 localhost kernel: scsi1: SCBPTR =3D=3D 0x2, SCB_NEXT =3D=3D=
 0xff00, SCB_NEXT2 =3D=3D 0xfffd
Apr  9 14:22:06 localhost kernel: CDB 3 0 0 0 20 0
Apr  9 14:22:06 localhost kernel: STACK: 0xdd 0x0 0x0 0x0 0x0 0x0 0x0 0x2e
Apr  9 14:22:06 localhost kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>=
>>>>>>>>>>>>>>>>
Apr  9 14:22:06 localhost kernel: DevQ(0:2:0): 0 waiting
Apr  9 14:22:06 localhost kernel: DevQ(0:3:0): 0 waiting
Apr  9 14:22:06 localhost kernel: DevQ(0:6:0): 0 waiting
Apr  9 14:22:06 localhost kernel: scsi1:0:2:0: Cmd aborted from QINFIFO
Apr  9 14:22:16 localhost kernel: scsi1:0:2:0: Attempting to abort cmd f782=
de00
Apr  9 14:22:16 localhost kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins=
 <<<<<<<<<<<<<<<<<
Apr  9 14:22:16 localhost kernel: scsi1: Dumping Card State at program addr=
ess 0x1a4 Mode 0x33
Apr  9 14:22:16 localhost kernel: Card was paused
Apr  9 14:22:16 localhost kernel: HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0=
x0] SAVED_MODE[0x11]
Apr  9 14:22:16 localhost kernel: DFFSTAT[0x31] SCSISIGI[0x4] SCSIPHASE[0x0=
] SCSIBUS[0x0]
Apr  9 14:22:16 localhost kernel: LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x1=
2] SEQCTL0[0x10]
Apr  9 14:22:16 localhost kernel: SEQINTCTL[0x0] SEQ_FLAGS[0x40] SEQ_FLAGS2=
[0x0] SSTAT0[0x0]
Apr  9 14:22:16 localhost kernel: SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRD=
IAG[0x0]
Apr  9 14:22:16 localhost kernel: SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0]=
 LQISTAT2[0x0]
Apr  9 14:22:16 localhost kernel: LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]
Apr  9 14:22:16 localhost kernel:
Apr  9 14:22:16 localhost kernel: SCB Count =3D 4 CMDS_PENDING =3D 1 LASTSC=
B 0x2 CURRSCB 0x2 NEXTSCB 0x0
Apr  9 14:22:16 localhost kernel: qinstart =3D 10969 qinfifonext =3D 10970
Apr  9 14:22:16 localhost kernel: QINFIFO: 0x3
Apr  9 14:22:16 localhost kernel: WAITING_TID_QUEUES:
Apr  9 14:22:16 localhost kernel: Pending list:
Apr  9 14:22:16 localhost kernel:   3 SCB_CONTROL[0x48] SCB_SCSIID[0x27] SC=
B_TAG[0x3]
Apr  9 14:22:16 localhost kernel:   2 SCB_CONTROL[0x0] SCB_SCSIID[0x37] SCB=
_TAG[0x2]
Apr  9 14:22:16 localhost kernel: Total 2
Apr  9 14:22:16 localhost kernel: Kernel Free SCB list: 1 0
Apr  9 14:22:16 localhost kernel: Sequencer Complete DMA-inprog list:
Apr  9 14:22:16 localhost kernel: Sequencer Complete list:
Apr  9 14:22:16 localhost kernel: Sequencer DMA-Up and Complete list:
Apr  9 14:22:16 localhost kernel:
Apr  9 14:22:16 localhost kernel: scsi1: FIFO0 Free, LONGJMP =3D=3D 0x80ff,=
 SCB 0x0, LJSCB 0xff00
Apr  9 14:22:16 localhost kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0=
] DFSTATUS[0x89]
Apr  9 14:22:16 localhost kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXF=
RCTL[0x0]
Apr  9 14:22:16 localhost kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR =3D 0x0=
0, SHCNT =3D 0x0
Apr  9 14:22:16 localhost kernel: HADDR =3D 0x00, HCNT =3D 0x0 CCSGCTL[0x10=
]
Apr  9 14:22:16 localhost kernel: scsi1: FIFO1 Free, LONGJMP =3D=3D 0x81e8,=
 SCB 0x3, LJSCB 0x2
Apr  9 14:22:16 localhost kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0=
] DFSTATUS[0x89]
Apr  9 14:22:16 localhost kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXF=
RCTL[0x0]
Apr  9 14:22:16 localhost kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR =3D 0x0=
0, SHCNT =3D 0x0
Apr  9 14:22:16 localhost kernel: HADDR =3D 0x00, HCNT =3D 0x0 CCSGCTL[0x10=
]
Apr  9 14:22:16 localhost kernel: LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0=
 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Apr  9 14:22:16 localhost kernel: scsi1: LQISTATE =3D 0x0, LQOSTATE =3D 0x0=
, OPTIONMODE =3D 0x42
Apr  9 14:22:16 localhost kernel: scsi1: OS_SPACE_CNT =3D 0x20 MAXCMDCNT =
=3D 0x0
Apr  9 14:22:16 localhost kernel: SIMODE0[0xc]
Apr  9 14:22:16 localhost kernel: CCSCBCTL[0x0]
Apr  9 14:22:16 localhost kernel: scsi1: REG0 =3D=3D 0x3, SINDEX =3D 0x133,=
 DINDEX =3D 0x108
Apr  9 14:22:16 localhost kernel: scsi1: SCBPTR =3D=3D 0x2, SCB_NEXT =3D=3D=
 0xff00, SCB_NEXT2 =3D=3D 0xfffd
Apr  9 14:22:16 localhost kernel: CDB 3 0 0 0 20 0
Apr  9 14:22:16 localhost kernel: STACK: 0xdd 0x0 0x0 0x0 0x0 0x0 0x0 0x2e
Apr  9 14:22:16 localhost kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>=
>>>>>>>>>>>>>>>>
Apr  9 14:22:16 localhost kernel: DevQ(0:2:0): 0 waiting
Apr  9 14:22:16 localhost kernel: DevQ(0:3:0): 0 waiting
Apr  9 14:22:16 localhost kernel: DevQ(0:6:0): 0 waiting
Apr  9 14:22:16 localhost kernel: scsi1:0:2:0: Cmd aborted from QINFIFO
Apr  9 14:22:16 localhost kernel: scsi1:0:3:0: Attempting to abort cmd f782=
da00
Apr  9 14:22:16 localhost kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins=
 <<<<<<<<<<<<<<<<<
Apr  9 14:22:16 localhost kernel: scsi1: Dumping Card State at program addr=
ess 0x1a4 Mode 0x33
Apr  9 14:22:16 localhost kernel: Card was paused
Apr  9 14:22:16 localhost kernel: HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0=
x0] SAVED_MODE[0x11]
Apr  9 14:22:16 localhost kernel: DFFSTAT[0x31] SCSISIGI[0x4] SCSIPHASE[0x0=
] SCSIBUS[0x0]
Apr  9 14:22:16 localhost kernel: LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x1=
2] SEQCTL0[0x10]
Apr  9 14:22:16 localhost kernel: SEQINTCTL[0x0] SEQ_FLAGS[0x40] SEQ_FLAGS2=
[0x0] SSTAT0[0x0]
Apr  9 14:22:16 localhost kernel: SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRD=
IAG[0x0]
Apr  9 14:22:16 localhost kernel: SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0]=
 LQISTAT2[0x0]
Apr  9 14:22:16 localhost kernel: LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]
Apr  9 14:22:16 localhost kernel:
Apr  9 14:22:16 localhost kernel: SCB Count =3D 4 CMDS_PENDING =3D 1 LASTSC=
B 0x2 CURRSCB 0x2 NEXTSCB 0x0
Apr  9 14:22:16 localhost kernel: qinstart =3D 10969 qinfifonext =3D 10969
Apr  9 14:22:16 localhost kernel: QINFIFO:
Apr  9 14:22:16 localhost kernel: WAITING_TID_QUEUES:
Apr  9 14:22:16 localhost kernel: Pending list:
Apr  9 14:22:16 localhost kernel:   2 SCB_CONTROL[0x0] SCB_SCSIID[0x37] SCB=
_TAG[0x2]
Apr  9 14:22:16 localhost kernel: Total 1
Apr  9 14:22:16 localhost kernel: Kernel Free SCB list: 3 1 0
Apr  9 14:22:16 localhost kernel: Sequencer Complete DMA-inprog list:
Apr  9 14:22:16 localhost kernel: Sequencer Complete list:
Apr  9 14:22:16 localhost kernel: Sequencer DMA-Up and Complete list:
Apr  9 14:22:16 localhost kernel:
Apr  9 14:22:16 localhost kernel: scsi1: FIFO0 Free, LONGJMP =3D=3D 0x80ff,=
 SCB 0x0, LJSCB 0xff00
Apr  9 14:22:16 localhost kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0=
] DFSTATUS[0x89]
Apr  9 14:22:16 localhost kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXF=
RCTL[0x0]
Apr  9 14:22:16 localhost kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR =3D 0x0=
0, SHCNT =3D 0x0
Apr  9 14:22:16 localhost kernel: HADDR =3D 0x00, HCNT =3D 0x0 CCSGCTL[0x10=
]
Apr  9 14:22:16 localhost kernel: scsi1: FIFO1 Free, LONGJMP =3D=3D 0x81e8,=
 SCB 0x3, LJSCB 0x2
Apr  9 14:22:16 localhost kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0=
] DFSTATUS[0x89]
Apr  9 14:22:16 localhost kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXF=
RCTL[0x0]
Apr  9 14:22:16 localhost kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR =3D 0x0=
0, SHCNT =3D 0x0
Apr  9 14:22:16 localhost kernel: HADDR =3D 0x00, HCNT =3D 0x0 CCSGCTL[0x10=
]
Apr  9 14:22:16 localhost kernel: LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0=
 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Apr  9 14:22:16 localhost kernel: scsi1: LQISTATE =3D 0x0, LQOSTATE =3D 0x0=
, OPTIONMODE =3D 0x42
Apr  9 14:22:16 localhost kernel: scsi1: OS_SPACE_CNT =3D 0x20 MAXCMDCNT =
=3D 0x0
Apr  9 14:22:16 localhost kernel: SIMODE0[0xc]
Apr  9 14:22:16 localhost kernel: CCSCBCTL[0x0]
Apr  9 14:22:16 localhost kernel: scsi1: REG0 =3D=3D 0x3, SINDEX =3D 0x133,=
 DINDEX =3D 0x108
Apr  9 14:22:16 localhost kernel: scsi1: SCBPTR =3D=3D 0x2, SCB_NEXT =3D=3D=
 0xff00, SCB_NEXT2 =3D=3D 0xfffd
Apr  9 14:22:16 localhost kernel: CDB 3 0 0 0 20 0
Apr  9 14:22:16 localhost kernel: STACK: 0xdd 0x0 0x0 0x0 0x0 0x0 0x0 0x2e
Apr  9 14:22:16 localhost kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>=
>>>>>>>>>>>>>>>>
Apr  9 14:22:16 localhost kernel: DevQ(0:2:0): 0 waiting
Apr  9 14:22:16 localhost kernel: DevQ(0:3:0): 0 waiting
Apr  9 14:22:16 localhost kernel: DevQ(0:6:0): 0 waiting
Apr  9 14:22:16 localhost kernel: scsi1:0:3:0: Unable to deliver message
Apr  9 14:22:16 localhost kernel: Recovery code sleeping
Apr  9 14:22:21 localhost kernel: Recovery code awake
Apr  9 14:22:21 localhost kernel: Timer Expired
Apr  9 14:22:21 localhost kernel: scsi1: Device reset returning 0x2003
Apr  9 14:22:21 localhost kernel: Recovery code sleeping
Apr  9 14:22:26 localhost kernel: Recovery code awake
Apr  9 14:22:26 localhost kernel: Timer Expired
Apr  9 14:22:26 localhost kernel: scsi1: Device reset returning 0x2003
Apr  9 14:22:26 localhost kernel: Recovery SCB completes
Apr  9 14:22:26 localhost kernel: Recovery SCB completes

--=-OvuouTJmRxqBnTGhi2eY--

