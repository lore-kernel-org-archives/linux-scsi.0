From: Fabien Salvi <fabien@cri74.org>
Subject: Fibre-Channel Access : interuptive access
Date: Mon, 25 Nov 2002 18:46:13 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DE261E5.3F61EBC4@cri74.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc00.cri.cur-archamps.fr (pc00.cri.cur-archamps.fr [10.10.10.11])
	by aravis.cur-archamps.fr (8.9.3/8.9.3) with ESMTP id SAA26861
	for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2002 18:46:13 +0100
Received: from cri74.org (localhost [127.0.0.1])
	by pc00.cri.cur-archamps.fr (8.9.3/8.9.3) with ESMTP id SAA25211
	for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2002 18:46:13 +0100
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>

Hello,

We have Fibre-Channel HBA (Qlogic 2200F) with a Sanbox2 switch connected
to a storage enclosure with a CMD 7240 Raid FC - SCSI controller.

We use qla2x00 (v6.01) driver.

When I reboot the FC switch, access is interrupted for 1 minute.
If I still have partition mounted on external enclosure while rebooting,
it brings failure on the server with a "semi-crash" of linux :

I can still access on it, but fsync is impossible, access to the data
after the reboot is not possible and reboot is blocked...
So, I must do a hard reset.

Well, this is something not really anormal you will say me, but what can
I do to reduce damages ?
Is there a way to prevent access to the partition while rebooting ?
When there is a timeout in NFS mounts, it is still possible to reboot
normally and to get back data when NFS is ok. Is there a solution like
this with FibreChannel SCSI ?

Here are the logs (I use Reiserfs filesystem) :

Nov 25 16:26:27 d4 kernel: scsi(0): LOOP DOWN detected
Nov 25 16:27:07 d4 kernel: SCSI disk error : host 0 channel 0 id 0 lun 7
return code = 10000
Nov 25 16:27:07 d4 kernel:  I/O error: dev 08:01, sector 50056
Nov 25 16:27:07 d4 kernel: journal-601, buffer write failed
Nov 25 16:27:07 d4 kernel: kernel BUG at prints.c:334!
Nov 25 16:27:07 d4 kernel: invalid operand: 0000
Nov 25 16:27:07 d4 kernel: CPU:    0
Nov 25 16:27:07 d4 kernel: EIP:    0010:[reiserfs_panic+41/96]    Not
tainted
Nov 25 16:27:07 d4 kernel: EFLAGS: 00010286
Nov 25 16:27:07 d4 kernel: eax: 00000024   ebx: c02764c0   ecx:
c7fb0000   edx: 00000000
Nov 25 16:27:07 d4 kernel: esi: c3470400   edi: 00000000   ebp:
c3470400   esp: c7fb1ee4
Nov 25 16:27:07 d4 kernel: ds: 0018   es: 0018   ss: 0018
Nov 25 16:27:07 d4 kernel: Process kupdated (pid: 7, stackpage=c7fb1000)
Nov 25 16:27:07 d4 kernel: Stack: c027495a c031f0c0 c02764c0 c7fb1f08
c888c798 00000003 c01a83cf
 c3470400 
Nov 25 16:27:07 d4 kernel:        c02764c0 00000011 00000012 00000010
00000000 c888c7cc c888c7c0
 00000004 
Nov 25 16:27:07 d4 kernel:        00000000 00000012 c7a032c0 c01abcfe
c3470400 c888c798 00000001
 c7fb1fa4 
Nov 25 16:27:07 d4 kernel: Call Trace:    [flush_commit_list+687/928]
[do_journal_end+1982/2704]
 [flush_old_commits+287/320] [reiserfs_write_super+21/32]
[sync_supers+191/240]
Nov 25 16:27:07 d4 kernel:   [sync_old_buffers+12/64] [kupdate+213/256]
[kernel_thread+40/64]
Nov 25 16:27:07 d4 kernel: 
Nov 25 16:27:07 d4 kernel: Code: 0f 0b 4e 01 60 49 27 c0 68 c0 f0 31 c0
85 f6 74 16 0f b7 46 
Nov 25 16:27:08 d4 kernel:  SCSI disk error : host 0 channel 0 id 0 lun
7 return code = 10000
Nov 25 16:27:08 d4 kernel:  I/O error: dev 08:01, sector 50064
Nov 25 16:27:09 d4 kernel: SCSI disk error : host 0 channel 0 id 0 lun 7
return code = 10000
Nov 25 16:27:09 d4 kernel:  I/O error: dev 08:01, sector 50072
Nov 25 16:27:30 d4 kernel: scsi(0): LOOP UP detected


Thanks a lot for your help !

--
Fabien
