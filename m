From: Kyle Davenport <kdavenpo@comcast.net>
Subject: oops and lockups with aic79xx 2.6.15+
Date: Mon, 08 May 2006 22:17:00 -0500
Message-ID: <446009AC.9030406@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc14.comcast.net ([204.127.192.84]:48574 "EHLO
	rwcrmhc14.comcast.net") by vger.kernel.org with ESMTP
	id S1751352AbWEIDRC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 May 2006 23:17:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I don't know enough about this problem to create a bugzilla report yet.

I didn't notice any problems with my Toshiba scsi DVD-ROM SD-M1401 until 
upgrading to 2.6.15.1 from 2.6.13.4.  (this system, a Tyan Thunder 
K7X-Pro (S2469UNG) dual 2400mp, has been stable since 2.4.18).    Now, 
most cd/dvd's I try cause a long listing of scsi errors in syslog.   It 
could be that the drive is going bad, but the system no longer 
gracefully recovers from scsi errors.   The other scsi drive, a YAMAHA  
CRW2100S cd-rw does not generate any read errors on all the cd's I have 
tried.   Both 2.6.15.1 and 2.6.16.12 are causing system lockups.   I 
have rebooted back into 2.6.13.4 and my system behaves normally, ie, CD 
read errors are simply reported to the shell, and processing continues.

In 2.6.15.1 I started to seeing these:
Apr 30 22:13:12 quickest automount[29812]: mount(generic): mounted 
/dev/dvdrom type iso9660 on /mnt/cdrom
Apr 30 22:13:58 quickest kernel: sr 1:0:2:0: Attempting to queue an 
ABORT message:CDB: 0x28 0x0 0x0 0x0 0x0 0x1e 0x0 0x0 0x1 0x0
Apr 30 22:13:58 quickest kernel: scsi1: At time of recovery, card was 
not paused
Apr 30 22:13:58 quickest kernel: >>>>>>>>>>>>>>>>>> Dump Card State 
Begins <<<<<<<<<<<<<<<<<
Apr 30 22:13:58 quickest kernel: scsi1: Dumping Card State at program 
address 0x94 Mode 0x11
Apr 30 22:13:58 quickest kernel: Card was paused
Apr 30 22:13:58 quickest kernel: HS_MAILBOX[0x0] 
INTCTL[0x80]:(SWTMINTMASK) SEQINTSTAT[0x0]
Apr 30 22:13:58 quickest kernel: SAVED_MODE[0x11] 
DFFSTAT[0x31]:(CURRFIFO_1|FIFO0FREE|FIFO1FREE)
Apr 30 22:13:58 quickest kernel: SCSISIGI[0x0]:(P_DATAOUT) 
SCSIPHASE[0x0] SCSIBUS[0x0]
Apr 30 22:13:58 quickest kernel: LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE) 
SCSISEQ0[0x0]
Apr 30 22:13:58 quickest kernel: SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI) 
SEQCTL0[0x10]:(FASTMODE)
Apr 30 22:13:58 quickest kernel: SEQINTCTL[0x80]:(INTVEC1DSL) 
SEQ_FLAGS[0xc0]:(NO_CDB_SENT|NOT_IDENTIFIED)
Apr 30 22:13:58 quickest kernel: SEQ_FLAGS2[0x0] SSTAT0[0x0] SSTAT1[0x0] 
SSTAT2[0x0]
Apr 30 22:13:58 quickest kernel: SSTAT3[0x0] 
PERRDIAG[0xc0]:(HIPERR|HIZERO) 
SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO)
Apr 30 22:13:58 quickest kernel: LQISTAT0[0x0] LQISTAT1[0x0] 
LQISTAT2[0x0] LQOSTAT0[0x0]
Apr 30 22:13:58 quickest kernel: LQOSTAT1[0x0] LQOSTAT2[0x0]
Apr 30 22:13:58 quickest kernel:
Apr 30 22:13:58 quickest kernel: SCB Count = 4 CMDS_PENDING = 1 LASTSCB 
0x2 CURRSCB 0x2 NEXTSCB 0x0
Apr 30 22:13:58 quickest kernel: qinstart = 30690 qinfifonext = 30690
Apr 30 22:13:58 quickest kernel: QINFIFO:
Apr 30 22:13:58 quickest kernel: WAITING_TID_QUEUES:
Apr 30 22:13:58 quickest kernel: Pending list:
Apr 30 22:13:58 quickest kernel:   3 FIFO_USE[0x0] 
SCB_CONTROL[0x44]:(DISCONNECTED|DISCENB)
Apr 30 22:13:58 quickest kernel: SCB_SCSIID[0x27]
Apr 30 22:13:58 quickest kernel: Total 1
Apr 30 22:13:58 quickest kernel: Kernel Free SCB list: 2 1 0
Apr 30 22:13:58 quickest kernel: Sequencer Complete DMA-inprog list:
Apr 30 22:13:58 quickest kernel: Sequencer Complete list:
Apr 30 22:13:58 quickest kernel: Sequencer DMA-Up and Complete list:
Apr 30 22:13:58 quickest kernel:
Apr 30 22:13:58 quickest kernel: scsi1: FIFO0 Free, LONGJMP == 0x80ff, 
SCB 0x0
Apr 30 22:13:58 quickest kernel: 
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 

Apr 30 22:13:58 quickest kernel: SEQINTSRC[0x0] DFCNTRL[0x0] 
DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
Apr 30 22:13:58 quickest kernel: SG_CACHE_SHADOW[0x2]:(LAST_SEG) 
SG_STATE[0x0] DFFSXFRCTL[0x0]
Apr 30 22:13:58 quickest kernel: SOFFCNT[0x0] 
MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0
Apr 30 22:13:58 quickest kernel: HADDR = 0x00, HCNT = 0x0 
CCSGCTL[0x10]:(SG_CACHE_AVAIL)
Apr 30 22:13:58 quickest kernel: scsi1: FIFO1 Free, LONGJMP == 0x81ec, 
SCB 0x2
Apr 30 22:13:59 quickest kernel: 
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 

Apr 30 22:13:59 quickest kernel: SEQINTSRC[0x0] DFCNTRL[0x0] 
DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
Apr 30 22:13:59 quickest kernel: SG_CACHE_SHADOW[0x2]:(LAST_SEG) 
SG_STATE[0x0] DFFSXFRCTL[0x0]
Apr 30 22:13:59 quickest kernel: SOFFCNT[0x0] 
MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0
Apr 30 22:13:59 quickest kernel: HADDR = 0x00, HCNT = 0x0 
CCSGCTL[0x10]:(SG_CACHE_AVAIL)
Apr 30 22:13:59 quickest kernel: LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
Apr 30 22:13:59 quickest kernel: scsi1: LQISTATE = 0x0, LQOSTATE = 0x0, 
OPTIONMODE = 0x42
Apr 30 22:13:59 quickest kernel: scsi1: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
Apr 30 22:13:59 quickest kernel:
Apr 30 22:13:59 quickest kernel: SIMODE0[0xc]:(ENOVERRUN|ENIOERR)
Apr 30 22:13:59 quickest kernel: CCSCBCTL[0x0]
Apr 30 22:13:59 quickest kernel: scsi1: REG0 == 0x3, SINDEX = 0x122, 
DINDEX = 0xe1
Apr 30 22:13:59 quickest kernel: scsi1: SCBPTR == 0x2, SCB_NEXT == 
0xff00, SCB_NEXT2 == 0xff44
Apr 30 22:13:59 quickest kernel: CDB 43 2 0 80 9 f8
Apr 30 22:13:59 quickest kernel: STACK: 0x29 0x15 0x0 0x0 0x0 0x0 0x0 0x0
Apr 30 22:13:59 quickest kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
 >>>>>>>>>>>>>>>>>>
Apr 30 22:13:59 quickest kernel: (scsi1:A:2:0): Device is disconnected, 
re-queuing SCB
Apr 30 22:13:59 quickest kernel: Recovery code sleeping
Apr 30 22:13:59 quickest kernel: (scsi1:A:2:0): Abort Message Sent
Apr 30 22:13:59 quickest kernel: (scsi1:A:2:0): SCB 3 - Abort Tag Completed.
Apr 30 22:13:59 quickest kernel: Recovery SCB completes
Apr 30 22:13:59 quickest kernel: found == 0x1
Apr 30 22:13:59 quickest kernel: Recovery code awake

Here is the oops from 2.6.16.12:
quickest kernel: Oops: 0000 [#1]
quickest kernel: PREEMPT SMP
quickest kernel: CPU:    0
quickest kernel: EIP is at ahd_linux_run_command+0x201/0x648
quickest kernel: eax: f45ac380   ebx: 00000001   ecx: 00000000   edx: 
f45ac380
quickest kernel: esi: f45ac3d0   edi: 00000000   ebp: f7c93e60   esp: 
e8fa5b28
quickest kernel: ds: 007b   es: 007b   ss: 0068
quickest kernel: Process xmms (pid: 17463, threadinfo=e8fa4000 
task=c9966560)
quickest kernel: Stack: <0>00000000 c1708e00 00000000 00200202 f747a000 
f45ac380 f7c9b368 00200002
quickest kernel:        c02a7fb7 f747a000 f7c9b368 f45ac380 00001055 
00200202 f7c9b800 f45ac380
quickest kernel:        00000000 c027d129 f45ac380 c027d324 00000001 
f7c37794 f7c9b000 f7ca004c
quickest kernel: Call Trace:
quickest kernel:  [<c02a7fb7>] ahd_linux_queue+0x7b/0x84
quickest kernel:  [<c027d129>] scsi_dispatch_cmd+0x135/0x1ea
quickest kernel:  [<c027d324>] scsi_done+0x0/0x1c
quickest kernel:  [<c0281deb>] scsi_request_fn+0x1ad/0x2c8
quickest kernel:  [<c02073df>] elv_insert+0x147/0x14a
quickest kernel:  [<c02074a9>] elv_add_request+0x31/0x46
quickest kernel:  [<c020a1da>] blk_execute_rq_nowait+0x36/0x44
quickest kernel:  [<c020a270>] blk_execute_rq+0x88/0xb0
quickest kernel:  [<c020a43c>] blk_end_sync_rq+0x0/0x22
quickest kernel:  [<c01555db>] bio_phys_segments+0x1b/0x20
quickest kernel:  [<c020b3b8>] blk_rq_bio_prep+0x2a/0x86
quickest kernel:  [<c02b31ec>] cdrom_read_cdda_bpc+0x15e/0x1bc
quickest kernel:  [<c02b326d>] cdrom_read_cdda+0x23/0x90
quickest kernel:  [<c02b4285>] mmc_ioctl+0x457/0x8c6
quickest kernel:  [<f962cb3c>] _nv000419rm+0x24/0x28 [nvidia]
quickest kernel:  [<f9525f21>] _nv002668rm+0x1d/0x2c [nvidia]
quickest kernel:  [<f9525f2a>] _nv002668rm+0x26/0x2c [nvidia]
quickest kernel:  [<c020d9f7>] scsi_cmd_ioctl+0x7f/0x3a0
quickest kernel:  [<f969bd57>] _nv005436rm+0x23/0x28 [nvidia]
quickest kernel:  [<f9525f21>] _nv002668rm+0x1d/0x2c [nvidia]
quickest kernel:  [<f9525f21>] _nv002668rm+0x1d/0x2c [nvidia]
quickest kernel:  [<f9525f2a>] _nv002668rm+0x26/0x2c [nvidia]
quickest kernel:  [<f969bd57>] _nv005436rm+0x23/0x28 [nvidia]
quickest kernel:  [<f969bd57>] _nv005436rm+0x23/0x28 [nvidia]
quickest kernel:  [<f9525f21>] _nv002668rm+0x1d/0x2c [nvidia]
quickest kernel:  [<f9525f2a>] _nv002668rm+0x26/0x2c [nvidia]
quickest kernel:  [<c02b3d26>] cdrom_ioctl+0xa4c/0xad2
quickest kernel:  [<f969b4ca>] _nv005201rm+0x8a/0x94 [nvidia]
quickest kernel:  [<f953d576>] rm_set_interrupts+0x12e/0x164 [nvidia]
quickest kernel:  [<c0218136>] fast_clear_page+0xa/0x5e
quickest kernel:  [<c01395cb>] buffered_rmqueue+0x14d/0x210
quickest kernel:  [<c02af2b7>] sr_block_ioctl+0x3f/0x5a
quickest kernel:  [<c020bf67>] blkdev_driver_ioctl+0x3f/0x58
quickest kernel:  [<c020c001>] blkdev_ioctl+0x81/0x1c2
quickest kernel:  [<c015778c>] block_ioctl+0x1a/0x1e
quickest kernel:  [<c0160141>] do_ioctl+0x55/0x68
quickest kernel:  [<c01602a4>] vfs_ioctl+0x58/0x190
quickest kernel:  [<c0160439>] sys_ioctl+0x5d/0x64
quickest kernel:  [<c01029ed>] syscall_call+0x7/0xb
quickest kernel: Code: b7 83 86 00 00 00 66 85 c0 0f 84 43 03 00 00 8b 
7b 70 0f b7 d8 8b 44 24 2c 83 78 3c 03 0f 84 22 03 00 00 85 db 0f 84 f7 
02 00 00 <83> 7f 0c 00 0f 84 ed 02 00 00 85 db 74 29 31 c9 89 da 8b 04 0f


Please advise,

Kyle Davenport - unix sys admin consultant - Dallas TX
_____________________________
One OS to fool them all
One browser to find them
One email client to bring them all
And through security holes, blind them...
				- Paul Johnson



