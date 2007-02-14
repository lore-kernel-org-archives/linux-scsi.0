From: Maarten De Wispelaere <maarten.de_wispelaere@erbaholding.be>
Subject: Dell PE2950 with adaptec 39320A scsi card : card dump while using
 Dell PV110T LTO2 tapedrive]
Date: Wed, 14 Feb 2007 17:19:05 +0100
Message-ID: <45D33679.4090506@erbaholding.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip-212-233-20-36.dsl-static.scarlet.be ([212.233.20.36]:48091
	"EHLO limace.habitat.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750750AbXBNRRu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Feb 2007 12:17:50 -0500
Received: from localhost (unknown [127.0.0.1])
	by limace.habitat.be (Postfix) with ESMTP id 2792C2CFF7A
	for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2007 17:19:10 +0100 (CET)
Received: from limace.habitat.be ([127.0.0.1])
 by localhost (limace [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 07270-05 for <linux-scsi@vger.kernel.org>;
 Wed, 14 Feb 2007 17:19:05 +0100 (CET)
Received: from [128.1.1.37] (lap003.clt.woladm.bel.erba [128.1.1.37])
	by limace.habitat.be (Postfix) with ESMTP id CACEE2CF3E8
	for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2007 17:19:05 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm having the following problem with my PE 2950 and PV110T LTO2 tapedrive :

At the end of my backup, I'm getting a Card Dump (see contents of 
/var/log/messages below).
My backupscript uses simple tar and mt command and runs fine on another 
machine with a DLT drive.

The scsi card is an adaptec 39320A - bought direct from Dell (came 
mounted with the server).

I'm running CentOS 4.4 on this machine, with the following kernel :
Linux cheetah.svr.woladm.bel.erba 2.6.9-42.0.8.ELsmp #1 SMP Tue Jan 30 
12:18:01 EST 2007 x86_64 x86_64 x86_64 GNU/Linux

Is there anyone on this list that has had these kind of problems before 
? As far as I know, I'm using the correct kernel-module for the card
aic79xx
Or should I use another one ?

What follows are the errors in /var/log/messages
and the output of lsmod

I hope someone on this recognizes the problem.

Thanks in advance,

regards,
Maarten

-- 
Maarten De Wispelaere
Hardware & Network Manager

SA ERBA Holding NV

St. Lambertusstraat 198
1200 Brussel

Tel. : +32 2 775 03 24
Fax  : +32 2 775 03 49



--------------------------------------
/var/log/messages :


Feb 14 00:02:55 cheetah kernel: scsi0:0:6:0: Attempting to abort cmd 
00000102cf454080: 0x1b 0x0 0x0 0x0 0x2 0x0
Feb 14 00:02:55 cheetah kernel: scsi0: At time of recovery, card was not 
paused
Feb 14 00:02:55 cheetah kernel: >>>>>>>>>>>>>>>>>> Dump Card State 
Begins <<<<<<<<<<<<<<<<<
Feb 14 00:02:55 cheetah kernel: scsi0: Dumping Card State at program 
address 0x27 Mode 0x11
Feb 14 00:02:55 cheetah kernel: Card was paused
Feb 14 00:02:55 cheetah kernel: HS_MAILBOX[0x0] INTCTL[0x80] 
SEQINTSTAT[0x0] SAVED_MODE[0x11]
Feb 14 00:02:55 cheetah kernel: DFFSTAT[0x33] SCSISIGI[0x0] 
SCSIPHASE[0x0] SCSIBUS[0x0]
Feb 14 00:02:55 cheetah kernel: LASTPHASE[0x1] SCSISEQ0[0x0] 
SCSISEQ1[0x12] SEQCTL0[0x0]
Feb 14 00:02:55 cheetah kernel: SEQINTCTL[0x0] SEQ_FLAGS[0xc0] 
SEQ_FLAGS2[0x0] SSTAT0[0x0]
Feb 14 00:02:55 cheetah kernel: SSTAT1[0x8] SSTAT2[0x0] SSTAT3[0x0] 
PERRDIAG[0xc0]
Feb 14 00:02:55 cheetah kernel: SIMODE1[0xa4] LQISTAT0[0x0] 
LQISTAT1[0x0] LQISTAT2[0x0]
Feb 14 00:02:55 cheetah kernel: LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]
Feb 14 00:02:55 cheetah kernel:
Feb 14 00:02:55 cheetah kernel: SCB Count = 4 CMDS_PENDING = 1 LASTSCB 
0xffff CURRSCB 0x3 NEXTSCB 0x0
Feb 14 00:02:55 cheetah kernel: qinstart = 23615 qinfifonext = 23615
Feb 14 00:02:55 cheetah kernel: QINFIFO:
Feb 14 00:02:55 cheetah kernel: WAITING_TID_QUEUES:
Feb 14 00:02:55 cheetah kernel: Pending list:
Feb 14 00:02:55 cheetah kernel:   3 FIFO_USE[0x0] SCB_CONTROL[0x44] 
SCB_SCSIID[0x67]
Feb 14 00:02:55 cheetah kernel: Total 1
Feb 14 00:02:55 cheetah kernel: Kernel Free SCB list: 2 1 0
Feb 14 00:02:55 cheetah kernel: Sequencer Complete DMA-inprog list:
Feb 14 00:02:55 cheetah kernel: Sequencer Complete list:
Feb 14 00:02:55 cheetah kernel: Sequencer DMA-Up and Complete list:
Feb 14 00:02:55 cheetah kernel:
Feb 14 00:02:55 cheetah kernel: scsi0: FIFO0 Free, LONGJMP == 0x80ff, 
SCB 0x0
Feb 14 00:02:55 cheetah kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] 
DFCNTRL[0x0] DFSTATUS[0x89]
Feb 14 00:02:55 cheetah kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] 
DFFSXFRCTL[0x0]
Feb 14 00:02:55 cheetah kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 
0x00, SHCNT = 0x0
Feb 14 00:02:55 cheetah kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
Feb 14 00:02:55 cheetah kernel: scsi0: FIFO1 Free, LONGJMP == 0x81d8, 
SCB 0x3
Feb 14 00:02:55 cheetah kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] 
DFCNTRL[0x4] DFSTATUS[0x89]
Feb 14 00:02:55 cheetah kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] 
DFFSXFRCTL[0x0]
Feb 14 00:02:55 cheetah kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 
0x00, SHCNT = 0x0
Feb 14 00:02:55 cheetah kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
Feb 14 00:02:55 cheetah kernel: LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Feb 14 00:02:55 cheetah kernel: scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, 
OPTIONMODE = 0x52
Feb 14 00:02:55 cheetah kernel: scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
Feb 14 00:02:55 cheetah kernel: SIMODE0[0xc]
Feb 14 00:02:55 cheetah kernel: CCSCBCTL[0x4]
Feb 14 00:02:55 cheetah kernel: scsi0: REG0 == 0x3, SINDEX = 0x1bc, 
DINDEX = 0x1be
Feb 14 00:02:55 cheetah kernel: scsi0: SCBPTR == 0x3, SCB_NEXT == 
0xff00, SCB_NEXT2 == 0xff4e
Feb 14 00:02:55 cheetah kernel: CDB 1b 0 0 0 2 0
Feb 14 00:02:55 cheetah kernel: STACK: 0x14 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Feb 14 00:02:55 cheetah kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
>>>>>>>>>>>>>>>>>>
Feb 14 00:02:55 cheetah kernel: DevQ(0:6:0): 0 waiting
Feb 14 00:02:55 cheetah kernel: (scsi0:A:6:0): Device is disconnected, 
re-queuing SCB
Feb 14 00:02:55 cheetah kernel: Recovery code sleeping
Feb 14 00:02:55 cheetah kernel: (scsi0:A:6:0): Abort Message Sent
Feb 14 00:02:55 cheetah kernel: (scsi0:A:6:0): SCB 3 - Abort Tag Completed.
Feb 14 00:02:55 cheetah kernel: Recovery SCB completes
Feb 14 00:02:55 cheetah kernel: found == 0x1
Feb 14 00:02:55 cheetah kernel: Recovery code awake
--------------------------------------
lsmod :

[root@cheetah ~]# lsmod
Module                  Size  Used by
nfs                   246641  0
sg                     42873  0
vmnet                  47368  8
parport_pc             29569  0
parport                44493  1 parport_pc
vmmon                 160020  22
mptctl                 34505  2
mptbase                66977  1 mptctl
dell_rbu                8553  0
nfsd                  278113  17
exportfs                8001  1 nfsd
lockd                  78449  3 nfs,nfsd
nfs_acl                 5313  2 nfs,nfsd
sunrpc                176441  13 nfs,nfsd,lockd,nfs_acl
autofs4                24393  0
ipmi_devintf           12241  2
ipmi_si                40545  1
ipmi_msghandler        33349  2 ipmi_devintf,ipmi_si
dm_mirror              32721  0
dm_mod                 68609  1 dm_mirror
button                  9313  0
battery                11465  0
ac                      6985  0
sr_mod                 20965  0
usb_storage            71561  0
joydev                 12097  0
md5                     5953  1
ipv6                  284193  29
uhci_hcd               35049  0
ehci_hcd               33989  0
hw_random               7393  0
bnx2                  147509  0
st                     42213  0
ext3                  138193  3
jbd                    69105  1 ext3
megaraid_sas           36217  6
aic79xx               178109  0
sd_mod                 19393  5
scsi_mod              141457  7 
sg,sr_mod,usb_storage,st,megaraid_sas,aic79xx,sd_mod



