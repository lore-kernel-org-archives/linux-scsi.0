From: "Amit D. Chaudhary" <amit_c@comcast.net>
Subject: Segmentation fault for target mode on qlogic ISP (feral) drivers
 when enabling lun
Date: Tue, 27 Apr 2004 15:49:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <408EE35C.9090803@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc13.comcast.net ([204.127.198.39]:49826 "EHLO
	rwcrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S264385AbUD0Wte (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 18:49:34 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hi,

Sending it to the list, incase someone has worked on this.

I got the latest qlogic ISP drivers, loaded it up with target mode 
support on linux-2.4.20 with QLA 2340.

The call to enable lun fails. See log and stack trace from oops below. 
Any ideas?

Thanks
Amit


[root@lumpkins1 linux]# modprobe isp_mod
[root@lumpkins1 linux]# modprobe scsi_target scsi_tdebug=1
[root@lumpkins1 linux]# cat /proc/scsi/scsi /proc/scsi/isp/0
Attached devices: none
Driver for a Qlogic ISP 2312 Host Adapter
  DEVID 20000 role 2
  Interrupt Stats:
   total=0x000000000000d6c8 bogus=0x0000000000000000
   MboxC=0x000000000000d6c8 async=0x0000000000000000
   CRslt=0x0000000000000000 CPost=0x0000000000000000
   RspnsCHiWater=0x0000 FastPostC_Hiwater=0x0000
  Request In 0 Request Out 0 Result 0 Nactv 0 HiWater 0 QAVAIL 1023 WtQHi 1

blocked 0 draining 0 qfdelay 0
Loop ID: 0 AL_PA 0x0 Port ID 0x0 FW State 4 Loop State 0
Port WWN 0x210000e08b13226d Node WWN 0x200000e08b13226d

[root@lumpkins1 linux]# ./scsi_target_ctl enable isp0 0 0 1
ctl: Doing ioctl: channel 0 target 0 lun 1
Segmentation fault
[root@lumpkins1 linux]#


Apr 26 12:25:50 lumpkins1 kernel: scsi_target_thread starting
Apr 26 12:26:02 lumpkins1 kernel: SCSI subsystem driver Revision: 1.00
Apr 26 12:26:02 lumpkins1 kernel: ISP SCSI and Fibre Channel Host 
Adapter Driver
Apr 26 12:26:02 lumpkins1 kernel:       Linux Platform Version 2.1
Apr 26 12:26:02 lumpkins1 kernel:       Common Core Code Version 2.7
Apr 26 12:26:02 lumpkins1 kernel:       Built on Apr 26 2004, 11:35:40
Apr 26 12:26:02 lumpkins1 kernel: isp0: Board Type 2312, Chip Revision 
0x2, loaded F/W Revision 3.1.20
Apr 26 12:26:02 lumpkins1 kernel: isp0: NVRAM Port WWN 0x210000e08b13226d
Apr 26 12:26:02 lumpkins1 kernel: scsi0 : Driver for a Qlogic ISP 2312 
Host Adapter
Apr 26 12:26:02 lumpkins1 kernel: blk: queue f198bc18, I/O limit 4095Mb 
(mask 0xffffffff)
Apr 26 12:26:17 lumpkins1 kernel: isp0: assuming loop is dead
Apr 26 12:36:37 lumpkins1 kernel: scsi_target_thread exiting
Apr 26 12:36:52 lumpkins1 kernel: scsi : 0 hosts left.
Apr 26 12:38:52 lumpkins1 kernel: ISP SCSI and Fibre Channel Host 
Adapter Driver
Apr 26 12:38:52 lumpkins1 kernel:       Linux Platform Version 2.1
Apr 26 12:38:52 lumpkins1 kernel:       Common Core Code Version 2.7
Apr 26 12:38:52 lumpkins1 kernel:       Built on Apr 26 2004, 12:35:08
Apr 26 12:38:52 lumpkins1 kernel: isp0: Board Type 2312, Chip Revision 
0x2, loaded F/W Revision 3.2.15
Apr 26 12:38:52 lumpkins1 kernel: isp0: NVRAM Port WWN 0x210000e08b13226d
Apr 26 12:38:52 lumpkins1 kernel: scsi_target: registering isp0
Apr 26 12:38:52 lumpkins1 kernel: scsi0 : Driver for a Qlogic ISP 2312 
Host Adapter
Apr 26 12:40:22 lumpkins1 kernel: isp0: assuming loop is dead
Apr 26 12:40:55 lumpkins1 kernel: scsi_target_ioctl: cmd
Apr 26 12:40:55 lumpkins1 kernel: scsi_target_ioctl: sizeof sc 28
Apr 26 12:40:55 lumpkins1 kernel: scsi_target_ioctl: enable isp0, chan 
0, target 0, lun 1
Apr 26 12:40:56 lumpkins1 kernel: isp0: Board Type 2312, Chip Revision 
0x2, loaded F/W Revision 3.2.15
Apr 26 12:40:58 lumpkins1 kernel: Unable to handle kernel NULL pointer 
dereference at virtual address 00000000
Apr 26 12:40:58 lumpkins1 kernel:  printing eip:
Apr 26 12:40:58 lumpkins1 kernel: f9c4f9c6
Apr 26 12:40:58 lumpkins1 kernel: *pde = 00000000
Apr 26 12:40:58 lumpkins1 kernel: Oops: 0002
Apr 26 12:40:58 lumpkins1 kernel: CPU:    0
Apr 26 12:40:58 lumpkins1 kernel: EIP:    0010:[<f9c4f9c6>]    Tainted: P
Apr 26 12:40:58 lumpkins1 kernel: EFLAGS: 00210297
Apr 26 12:40:58 lumpkins1 kernel: eax: 00000001   ebx: e505be80   ecx: 
00000000   edx: 00000000
Apr 26 12:40:58 lumpkins1 kernel: esi: f9c51b40   edi: 00000001   ebp: 
e505be80   esp: e505be00
Apr 26 12:40:58 lumpkins1 kernel: ds: 0018   es: 0018   ss: 0018
Apr 26 12:40:58 lumpkins1 kernel: Process scsi_target_ctl (pid: 2387, 
stackpage=e505b000)
Apr 26 12:40:58 lumpkins1 kernel: Stack: 0000000a ffffffff 00000000 
e505be80 f9c51b40 00000001 e505be80 f9cd55d0
Apr 26 12:40:58 lumpkins1 kernel:        f1d6807c 00000001 00000000 
00000000 00000000 f9c50a11 e505be60 e505be80
Apr 26 12:40:58 lumpkins1 kernel:        f9c51b40 00000001 e505be80 
f9c502ed 00000001 e505be80 00000090 00000000
Apr 26 12:40:58 lumpkins1 kernel: Call Trace:    [<f9c51b40>] 
[<f9cd55d0>] [<f9c50a11>] [<f9c51b40>] [<f9c502ed>]
Apr 26 12:40:58 lumpkins1 kernel:   [<c012f900>] [<f9c50b59>] 
[<f9c4f174>] [<c014e5fd>] [<c014e82d>] [<c010770f>]
Apr 26 12:40:58 lumpkins1 kernel:
Apr 26 12:40:58 lump


--------------------
stack trace

Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00210297
eax: 00000001   ebx: e505be80   ecx: 00000000   edx: 00000000
esi: f9c51b40   edi: 00000001   ebp: e505be80   esp: e505be00
ds: 0018   es: 0018   ss: 0018
Process scsi_target_ctl (pid: 2387, stackpage=e505b000)
Stack: 0000000a ffffffff 00000000 e505be80 f9c51b40 00000001 e505be80 
f9cd55d0
        f1d6807c 00000001 00000000 00000000 00000000 f9c50a11 e505be60 
e505be80
        f9c51b40 00000001 e505be80 f9c502ed 00000001 e505be80 00000090 
00000000
Call Trace:    [<f9c51b40>] [<f9cd55d0>] [<f9c50a11>] [<f9c51b40>] 
[<f9c502ed>]
   [<c012f900>] [<f9c50b59>] [<f9c4f174>] [<c014e5fd>] [<c014e82d>] 
[<c010770f>]
Warning (Oops_read): Code line not seen, dumping what data is available


 >>EIP; f9c4f9c6 <[scsi_target]scsi_target_handler+136/730>   <=====
 >>ebx; e505be80 <_end+24ca7abc/3844bc9c>
 >>esi; f9c51b40 <[scsi_target].data.end+19/63539>
 >>ebp; e505be80 <_end+24ca7abc/3844bc9c>
 >>esp; e505be00 <_end+24ca7a3c/3844bc9c>

Trace; f9c51b40 <[scsi_target].data.end+19/63539>
Trace; f9cd55d0 <[isp_mod]isp_taction+70/130>
Trace; f9c50a11 <[scsi_target].rodata.end+5e/102d>
Trace; f9c51b40 <[scsi_target].data.end+19/63539>
Trace; f9c502ed <[scsi_target]scsi_target_endis+10d/210>
Trace; c012f900 <filemap_nopage+b0/220>
Trace; f9c50b59 <[scsi_target].rodata.end+1a6/102d>
Trace; f9c4f174 <[scsi_target]scsi_target_ioctl+f4/120>
Trace; c014e5fd <file_ioctl+6d/190>
Trace; c014e82d <sys_ioctl+10d/21f>
Trace; c010770f <system_call+33/38>

0x98a+0x136 = 0xac0 is in no man's land, that is middle of a compare 
instruction if (e) in scsi_target_handler() in linux/scsi_target.c


