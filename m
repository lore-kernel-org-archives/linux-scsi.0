From: "Lev A. Melnikovsky" <leva@hotmail.com>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Mon, 5 Jun 2006 12:26:06 +0400 (MSD)
Message-ID: <Pine.LNX.4.64.0606051150440.4038@nev.ubzr>
References: <Pine.LNX.4.64.0606042013200.14649@nev.ubzr>
 <Pine.LNX.4.60.0606041850090.13574@poirot.grange> <Pine.LNX.4.64.0606042201460.14649@nev.ubzr>
 <Pine.LNX.4.60.0606042022540.24306@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [212.45.14.9] ([212.45.14.9]:27632 "EHLO ari.home")
	by vger.kernel.org with ESMTP id S1750751AbWFEI0J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2006 04:26:09 -0400
In-Reply-To: <Pine.LNX.4.60.0606042022540.24306@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jamie Lenehan <lenehan@twibble.org>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Hi!

I'm (also) having problems with my dc395x and HP C6270A scanner. The log 
contains multiple "Unexpected reselection" messages, so I assume this has 
something to do with the earlier report. Sorry, if my assumption is wrong.

I'm using [x]sane[d] (FC5 official rpm) to control the scanner. The 
problem is ~50% reproducible. Sometimes the scanning is successful, but 
sometimes it hangs for several minutes and reports and I/O Error 
(earlier sane versions segfaulted here, but the modern one does not).

I have tried the patch from 
http://marc.theaimsgroup.com/?l=linux-scsi&m=114400790021967&w=2
but it did not really change anything observable. The log (scsi_mod 
scsi_logging_level=15) follows:

--------------------------------------------------------------------

00:25:46: SCSI subsystem initialized
00:25:46: dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08
00:25:46: ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LNKD] -> GSI 5 (level, low) -> IRQ 5
00:25:46: Error handler scsi_eh_0 sleeping
00:25:46: dc395x: Used settings: AdapterID=07, Speed=0(20.0MHz), dev_mode=0x45
00:25:46: dc395x:                AdaptMode=0x0f, Tags=4(16), DelayReset=1s
00:25:46: dc395x: Connectors: ext50  Termination: Auto Low High 
00:25:46: dc395x: Performing initial SCSI bus reset
00:25:46: scsi0 : Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08
00:25:46: scsi_add_timer: scmd: c9988cc0, time: 1375, (d09692d0)
00:25:47: scsi_delete_timer: scmd: c9988cc0, rtn: 1
00:25:47: scsi_add_timer: scmd: c9988cc0, time: 1375, (d09692d0)
00:25:47: scsi_delete_timer: scmd: c9988cc0, rtn: 1
00:25:47: scsi_add_timer: scmd: c9988cc0, time: 1375, (d09692d0)
00:25:47: scsi_delete_timer: scmd: c9988cc0, rtn: 1
00:25:47:   Vendor: HP        Model: C6270A            Rev: 3828
00:25:47:   Type:   Processor                          ANSI SCSI revision: 02
00:25:47: scsi_add_timer: scmd: c9988cc0, time: 1375, (d09692d0)
00:25:47:  0:0:2:0: Attached scsi generic sg0 type 3
00:25:47: scsi_delete_timer: scmd: c9988cc0, rtn: 1
00:25:47: scsi_add_timer: scmd: c9988cc0, time: 1375, (d09692d0)
00:25:48: scsi_delete_timer: scmd: c9988cc0, rtn: 1
00:25:48: scsi_add_timer: scmd: c9988cc0, time: 1375, (d09692d0)
00:25:48: scsi_delete_timer: scmd: c9988cc0, rtn: 1
00:25:48: scsi_add_timer: scmd: c9988cc0, time: 1375, (d09692d0)
00:25:48: scsi_delete_timer: scmd: c9988cc0, rtn: 1
00:25:48: scsi_add_timer: scmd: c9988cc0, time: 1375, (d09692d0)
00:25:48: scsi_delete_timer: scmd: c9988cc0, rtn: 1
...
00:31:11: scsi_add_timer: scmd: c9988cc0, time: 30000, (d09692d0)
00:31:11: scsi_delete_timer: scmd: c99881c0, rtn: 1
00:31:11: scsi_add_timer: scmd: c99881c0, time: 30000, (d09692d0)
00:31:11: scsi_delete_timer: scmd: c9988cc0, rtn: 1
00:31:11: scsi_add_timer: scmd: c9988cc0, time: 30000, (d09692d0)
00:31:12: scsi_delete_timer: scmd: c99881c0, rtn: 1
00:31:12: scsi_add_timer: scmd: c99881c0, time: 30000, (d09692d0)
00:31:12: scsi_delete_timer: scmd: c9988cc0, rtn: 1
00:31:12: dc395x: disconnect: Unexpected reselection <02-0>
00:31:12: scsi_add_timer: scmd: c9988cc0, time: 30000, (d09692d0)
00:33:12: Waking error handler thread
00:33:12: Error handler scsi_eh_0 waking up
00:33:12:  0:0:2:0: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 2
00:33:12: Total of 2 commands on 1 devices require eh work
00:33:12: scsi_eh_0: aborting cmd:0xc99881c0
00:33:12: dc395x: eh_abort: (pid#4496) target=<02-0> cmd=c99881c0
00:33:12: scsi_eh_0: aborting cmd failed:0xc99881c0
00:33:12: scsi_eh_0: aborting cmd:0xc9988cc0
00:33:12: dc395x: eh_abort: (pid#4497) target=<02-0> cmd=c9988cc0
00:33:22: scsi_send_eh_cmnd: scmd: c9988cc0, timeleft: 0
00:33:22: dc395x: eh_abort: (pid#4497) target=<02-0> cmd=c9988cc0
00:33:22: scsi_eh_tur: scmd c9988cc0 rtn 2003
00:33:22: scsi_eh_0: Sending BDR sdev: 0xcf141c00
00:33:22: scsi_eh_0: BDR failed sdev:0xcf141c00
00:33:22: scsi_eh_0: Sending BRST chan: 0
00:33:22: scsi_try_bus_reset: Snd Bus RST
00:33:22: dc395x: eh_bus_reset: (pid#4496) target=<02-0> cmd=c99881c0
00:33:22: dc395x: doing_srb_done: pids G:4496(02-0) 
00:33:32: scsi_eh_done scmd: c99881c0 result: 8000002
00:33:32: scsi_send_eh_cmnd: scmd: c99881c0, timeleft: 2492
00:33:32: scsi_send_eh_cmnd: scsi_eh_completed_normally 2001
00:33:32: scsi_eh_tur: scmd c99881c0 rtn 2001
00:33:32: scsi_eh_done scmd: c99881c0 result: 0
00:33:32: scsi_send_eh_cmnd: scmd: c99881c0, timeleft: 2500
00:33:32: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
00:33:32: scsi_eh_tur: scmd c99881c0 rtn 2002
00:33:32: scsi_eh_done scmd: c9988cc0 result: 0
00:33:32: scsi_send_eh_cmnd: scmd: c9988cc0, timeleft: 2500
00:33:32: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
00:33:32: scsi_eh_tur: scmd c9988cc0 rtn 2002
00:33:32: scsi_eh_0: flush finish cmd: c99881c0
00:33:32: scsi_eh_0: flush finish cmd: c9988cc0
00:33:32: scsi_restart_operations: waking up host to restart
00:33:32: Error handler scsi_eh_0 sleeping
00:33:32: scsi_add_timer: scmd: c9988cc0, time: 30000, (d09692d0)
00:33:32: scsi_delete_timer: scmd: c9988cc0, rtn: 1
00:33:32: scsi_add_timer: scmd: c9988cc0, time: 30000, (d09692d0)
00:33:32: scsi_delete_timer: scmd: c9988cc0, rtn: 1
00:33:32: scsi_add_timer: scmd: c9988cc0, time: 30000, (d09692d0)
00:33:32: scsi_delete_timer: scmd: c9988cc0, rtn: 1
00:33:32: scsi_add_timer: scmd: c9988cc0, time: 30000, (d09692d0)
00:33:32: scsi_delete_timer: scmd: c9988cc0, rtn: 1
00:33:32: scsi_add_timer: scmd: c9988cc0, time: 30000, (d09692d0)
00:33:32: scsi_delete_timer: scmd: c9988cc0, rtn: 1
00:33:32: scsi_add_timer: scmd: c9988cc0, time: 30000, (d09692d0)
00:33:32: scsi_delete_timer: scmd: c9988cc0, rtn: 1
00:33:32: scsi_add_timer: scmd: c9988cc0, time: 30000, (d09692d0)
00:33:32: scsi_delete_timer: scmd: c9988cc0, rtn: 1
00:33:32: scsi_add_timer: scmd: c9988cc0, time: 30000, (d09692d0)
...

--------------------------------------------------------------------

This scanner is the only device on the bus. My understanding is that I 
don't need to manually terminate anything, please correct me if I'm wrong. 
I can not guarantee that this is not a hardware problem, but, as far as I 
remember, it did not show (this often) under 2.4 kernel (with the same 
hardware setup).

My configuration follows:

Linux 2.6.16.19 #9 Sun Jun 4 22:30:07 MSD 2006 i686 i686 i386 GNU/Linux

$ cat /proc/cpuinfo

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 11
model name      : Intel(R) Celeron(TM) CPU                1300MHz
stepping        : 1
cpu MHz         : 1303.107
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat pse36 mmx fxsr sse
bogomips        : 2608.88

$ free
              total       used       free     shared    buffers     cached
Mem:        256164     242876      13288          0      13456     176828
-/+ buffers/cache:      52592     203572
Swap:       530136          0     530136

$lspci -v
00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (rev 03)
         Subsystem: ASUSTeK Computer Inc. Unknown device 8024
         Flags: bus master, medium devsel, latency 64
         Memory at e4000000 (32-bit, prefetchable) [size=64M]
         Capabilities: [a0] AGP version 1.0

00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge (rev 03) (prog-if 00 [Normal decode])
         Flags: bus master, 66MHz, medium devsel, latency 64
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
         Memory behind bridge: d4000000-d5efffff
         Prefetchable memory behind bridge: d7700000-e3ffffff
  ...
00:09.0 SCSI storage controller: Tekram Technology Co.,Ltd. TRM-S1040 (rev 01)
         Subsystem: Tekram Technology Co.,Ltd. TRM-S1040
         Flags: medium devsel, IRQ 5
         I/O ports at d000 [size=256]
         Memory at d3800000 (32-bit, non-prefetchable) [size=4K]
         [virtual] Expansion ROM at 20080000 [disabled] [size=64K]
         Capabilities: [dc] Power Management version 1

This is Asus P3B-F motherboard.

I will appreciate any help.
Thanks
-L.
