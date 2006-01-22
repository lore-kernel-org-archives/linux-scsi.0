From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: 2.6.15: Oops in aha152x with invalid parameter
Date: Sun, 22 Jan 2006 09:36:55 -0800
Message-ID: <20060122093655.65fa51b9.rdunlap@xenotime.net>
References: <vio0s1l8pauk4tj4slpc2cg31dees84lpu@4ax.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:49617 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S932276AbWAVRgr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jan 2006 12:36:47 -0500
Received: from zx64.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Sun, 22 Jan 2006 09:36:46 -0800
In-Reply-To: <vio0s1l8pauk4tj4slpc2cg31dees84lpu@4ax.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gcoady@gmail.com
Cc: scsi <linux-scsi@vger.kernel.org>


(redirecting to linux-scsi)

On Sun, 08 Jan 2006 12:09:41 +1100 Grant Coady wrote:

> Hi there,
> 
> Just trying an old ISA SCSI adapter, got this.  Dunno why 0x340 is not 
> valid IO addr, it is the thing's default setting.  More info, testing 
> as requested.  Box still running over ssh link but console locked up.
> 
> aha162x compiled as module, oops on "modprobe aha162x" with 
> /etc/modprobe containing:
> $ cat /etc/modprobe.conf
> alias eth0 e100
> alias eth1 tulip
> 
> #alias scsi_hostadapter aha152x
> options aha152x io=0x340 irq=11
> 
> alias char-major-89 i2c-dev
> - - -
> # lspci
> 00:00.0 Host bridge: Intel Corp. 440LX/EX - 82443LX/EX Host bridge (rev 03)
> 00:01.0 PCI bridge: Intel Corp. 440LX/EX - 82443LX/EX AGP bridge (rev 03)
> 00:07.0 ISA bridge: Intel Corp. 82371AB/EB/MB PIIX4 ISA (rev 01)
> 00:07.1 IDE interface: Intel Corp. 82371AB/EB/MB PIIX4 IDE (rev 01)
> 00:07.2 USB Controller: Intel Corp. 82371AB/EB/MB PIIX4 USB (rev 01)
> 00:07.3 Bridge: Intel Corp. 82371AB/EB/MB PIIX4 ACPI (rev 01)
> 00:08.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] (rev 08)
> 00:0a.0 Ethernet controller: Digital Equipment Corporation DECchip 21140 [FasterNet] (rev 22)
> 01:00.0 VGA compatible controller: ATI Technologies Inc 3D Rage IIC AGP (rev 7a)
> 
> /var/log/syslog:
> Jan  8 10:47:48 silly kernel: aha152x: `0x340' invalid for parameter `io'
> Jan  8 10:49:43 silly kernel: aha152x: `0x340' invalid for parameter `io'
> Jan  8 10:53:46 silly kernel: aha152x: resetting bus...
> Jan  8 10:53:48 silly kernel: (scsi0:6:0) command already sent
> Jan  8 10:53:48 silly kernel: Unable to handle kernel NULL pointer dereference at virtual address 00000038
> Jan  8 10:53:48 silly kernel:  printing eip:
> Jan  8 10:53:48 silly kernel: cabf86c7
> Jan  8 10:53:48 silly kernel: *pde = 00000000
> Jan  8 10:53:48 silly kernel: Oops: 0000 [#1]
> Jan  8 10:53:48 silly kernel: Modules linked in: aha152x nfsd exportfs tulip e100
> Jan  8 10:53:48 silly kernel: CPU:    0
> Jan  8 10:53:48 silly kernel: EIP:    0060:[<cabf86c7>]    Not tainted VLI
> Jan  8 10:53:48 silly kernel: EFLAGS: 00010296   (2.6.15a)
> Jan  8 10:53:48 silly kernel: EIP is at cmd_run+0x17/0x80 [aha152x]
> Jan  8 10:53:48 silly kernel: eax: cabf86b0   ebx: 0000000b   ecx: 00000000   edx: 00000006
> Jan  8 10:53:48 silly kernel: esi: c96f6000   edi: c96f6000   ebp: 000181b0   esp: c119fefc
> Jan  8 10:53:48 silly kernel: ds: 007b   es: 007b   ss: 0068
> Jan  8 10:53:48 silly kernel: Process events/0 (pid: 4, threadinfo=c119f000 task=c119ea30)
> Jan  8 10:53:48 silly kernel: Stack: c96f6000 0000000b c96f6000 00000340 000181b0 cabf98a5 c96f6000 cabfefe4
> Jan  8 10:53:48 silly kernel:        c119ff40 000016bb a0172a72 00000000 00000000 cabfefe4 cabf71f0 cabf7230
> Jan  8 10:53:48 silly kernel:        c96f6000 00000216 c012383d 00000000 c119ff68 00000000 c11816b8 c119f000
> Jan  8 10:53:48 silly kernel: Call Trace:
> Jan  8 10:53:48 silly kernel:  [<cabf98a5>] is_complete+0x225/0x270 [aha152x]
> Jan  8 10:53:48 silly kernel:  [<cabf71f0>] run+0x0/0x50 [aha152x]
> Jan  8 10:53:48 silly kernel:  [<cabf7230>] run+0x40/0x50 [aha152x]
> Jan  8 10:53:48 silly kernel:  [<c012383d>] worker_thread+0x1ad/0x250
> Jan  8 10:53:48 silly kernel:  [<c0111ba0>] default_wake_function+0x0/0x20
> Jan  8 10:53:48 silly kernel:  [<c0111ba0>] default_wake_function+0x0/0x20
> Jan  8 10:53:48 silly kernel:  [<c0123690>] worker_thread+0x0/0x250
> Jan  8 10:53:48 silly kernel:  [<c01277ba>] kthread+0xba/0xc0
> Jan  8 10:53:48 silly kernel:  [<c0127700>] kthread+0x0/0xc0
> Jan  8 10:53:48 silly kernel:  [<c0100c59>] kernel_thread_helper+0x5/0xc
> Jan  8 10:53:48 silly kernel: Code: 24 10 83 c4 14 c3 31 c9 89 8b 9c 03 00 00 eb ee 8d 74 26 
> 00 55 57 56 53 83 ec 04 8b 7c 24 18 8b 8f 88 02 00 00 8b 97 9c 03 00 00 <0f> b6 41 38 39 c2 
> 74 45 0f b6 41 38 89 d5 39 c2 7d 35 8b 87 b0
> Jan  8 10:53:53 silly kernel:  <3>(scsi0:6:0) cannot abort running or disconnected command
> -- 

Is this fixed, or at least the "invalid for parameter" part of it?
There was a snafu in some parameter magic that was fixed after 2.6.15.

Thanks,
---
~Randy
