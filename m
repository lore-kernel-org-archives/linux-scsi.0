From: Andrew Schulman <andrex@alumni.utexas.net>
Subject: Re: dc395x: CD writer causes endless "sg_to_virt failed" loop
Date: Sun, 28 Mar 2004 23:03:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200403282303.02146.andrex@alumni.utexas.net>
References: <20040327161034.GA9963@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc12.comcast.net ([216.148.227.85]:55465 "EHLO
	rwcrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S262596AbUC2EDF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Mar 2004 23:03:05 -0500
In-Reply-To: <20040327161034.GA9963@twibble.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lenehan <lenehan@twibble.org>
Cc: linux-scsi@vger.kernel.org, dc395x@twibble.org

> > I have a Tekram DC395UW card, running in Debian with kernel 2.6.3 and the
> > dc395x driver from the kernel source.  Attached to the card are a Seagate
>
> [...]
>
> > by, for example, trying to mount or burn a CD-- my console and syslog
> > begin to fill up with "dc395x: sg_to_virt failed!" messages-- several
>
> Yeah, this has been reported a few months back for the original
> driver in 2.4. I *think* I found and fixed what would have caused
> this problem in the latest version included in 2.6 but since no one
> has ever seen this issue in 2.6 it's been difficult to be certain.
>
[...]
>
> First thing to try would be to upgrade to 2.6.5-rc1 (or newer) and
> see if that works any better.
> 
> If it still has issues then you should edit drivers/scsi/dc395x.c and
> uncomment the first "#define DEBUG_MASK" line, rebuild the dc395x
> module and then reload the module. You should then gets lots of
> debugging output in one of your log file which you can then gzip or
> bzip2 and then send directly to me.

Tried it with 2.6.5-rc2.  Now 'modprobe dc395x' hangs (though without all of 
the 'sg_to_virt failed' messages) as the drive keeps spinning.  'reboot' also 
eventually hangs, and again I need to hit the case reset button to get back 
to normal.  syslog shows "Unable to handle kernel NULL pointer dereference"-- 
see excerpt below.  I'll try the debugging and send you a log soon.

Mar 28 22:40:10 helium kernel: dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC 
TRM-S1040 v2.05, 2004/03/08
Mar 28 22:40:11 helium kernel: dc395x: Used settings: AdapterID=07, Speed=0
(20.0MHz), dev_mode=0x77
Mar 28 22:40:11 helium kernel: dc395x:                AdaptMode=0x0f, Tags=4
(16), DelayReset=1s
Mar 28 22:40:11 helium kernel: dc395x: (Wide) Connectors: int50  Termination: 
Auto Low High 
Mar 28 22:40:11 helium kernel: dc395x: Performing initial SCSI bus reset
Mar 28 22:40:11 helium kernel: scsi2 : Tekram DC395(U/UW/F), DC315(U) - ASIC 
TRM-S1040 v2.05, 2004/03/08
Mar 28 22:40:12 helium kernel: dc395x: Target 02:  Sync: 100ns Offset 15 (10.0 
MB/s)
Mar 28 22:40:12 helium kernel:   Vendor: Seagate   Model: STT20000N         
Rev: 7A61
Mar 28 22:40:12 helium kernel:   Type:   Sequential-Access                  
ANSI SCSI revision: 02
Mar 28 22:40:12 helium scsi.agent[1795]: tape 
at /devices/pci0000:00/0000:00:1e.0/0000:02:04.0/host2/2:0:2:0
Mar 28 22:40:12 helium kernel: st: Version 20040226, fixed bufsize 32768, s/g 
segs 256
Mar 28 22:40:12 helium kernel: Unable to handle kernel NULL pointer 
dereference at virtual address 0000002e
Mar 28 22:40:12 helium kernel:  printing eip:
Mar 28 22:40:12 helium kernel: f8a961d7
Mar 28 22:40:12 helium kernel: *pde = 00000000
Mar 28 22:40:12 helium kernel: Oops: 0002 [#1]
Mar 28 22:40:12 helium kernel: PREEMPT SMP 
Mar 28 22:40:12 helium kernel: CPU:    0
Mar 28 22:40:12 helium kernel: EIP:    0060:[__crc_pm_idle+1598296/5541136]    
Not tainted
Mar 28 22:40:12 helium kernel: EFLAGS: 00010282   (2.6.5-rc2) 
Mar 28 22:40:12 helium kernel: EIP is at do_create_class_files+0x9a/0x152 [st]
Mar 28 22:40:12 helium kernel: eax: f73cd654   ebx: ffffffea   ecx: 00000000   
edx: f7fff2f0
Mar 28 22:40:12 helium kernel: esi: 00000000   edi: f73cd600   ebp: 00000000   
esp: f6811eb4
Mar 28 22:40:12 helium kernel: ds: 007b   es: 007b   ss: 0068
Mar 28 22:40:12 helium kernel: Process modprobe (pid: 1806, 
threadinfo=f6810000 task=f7c34300)
Mar 28 22:40:12 helium kernel: Stack: f7208b80 00900000 f76a0584 f8a96835 
f7493884 00000000 00000001 00000004 
Mar 28 22:40:12 helium kernel:        00000000 f73cd654 f8a9590c f73cd600 
00000000 00000000 00000000 c1b88480 
Mar 28 22:40:12 helium kernel:        c0189c97 f73cd654 00000000 c0189bb4 
f8a99e40 00000000 f73cd600 00000000 
Mar 28 22:40:12 helium kernel: Call Trace:
Mar 28 22:40:12 helium kernel:  [__crc_pm_idle+1596045/5541136] 
st_probe+0x506/0x883 [st]
Mar 28 22:40:12 helium kernel:  [create_dir+150/189] create_dir+0x96/0xbd
Mar 28 22:40:12 helium kernel:  [init_dir+0/31] init_dir+0x0/0x1f
Mar 28 22:40:12 helium kernel:  [bus_match+63/106] bus_match+0x3f/0x6a
Mar 28 22:40:12 helium kernel:  [driver_attach+86/128] driver_attach+0x56/0x80
Mar 28 22:40:12 helium kernel:  [bus_add_driver+140/159] 
bus_add_driver+0x8c/0x9f
Mar 28 22:40:12 helium kernel:  [__crc_pm_idle+549403/5541136] 
init_st+0x9a/0xe4 [st]
Mar 28 22:40:12 helium kernel:  [sys_init_module+304/603] 
sys_init_module+0x130/0x25b
Mar 28 22:40:12 helium kernel:  [syscall_call+7/11] syscall_call+0x7/0xb
Mar 28 22:40:12 helium kernel: 
Mar 28 22:40:12 helium kernel: Code: 89 43 44 89 1c 24 c7 44 24 04 a8 9f a9 f8 
e8 58 70 75 c7 89 
Mar 28 22:40:14 helium kernel:  <6>dc395x: Target 06:  Sync: 100ns Offset 15 
(10.0 MB/s)
Mar 28 22:40:14 helium kernel:   Vendor: HP        Model: CD-Writer+ 9200   
Rev: 1.0e
Mar 28 22:40:14 helium kernel:   Type:   CD-ROM                             
ANSI SCSI revision: 04
Mar 28 22:40:14 helium scsi.agent[1808]: how to add device type= 
at /devices/pci0000:00/0000:00:1e.0/0000:02:04.0/host2/2:0:6:0 ??
