From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bug 6009] tcpdump causes kernel panic
Date: Sat, 4 Feb 2006 21:04:31 -0800
Message-ID: <20060204210431.5a6af0d1.akpm@osdl.org>
References: <200602050242.k152giEp014748@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:37322 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030269AbWBEFFE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Feb 2006 00:05:04 -0500
In-Reply-To: <200602050242.k152giEp014748@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, Adam Radford <linuxraid@amcc.com>

bugme-daemon@bugzilla.kernel.org wrote:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=6009
> 
> 
> 
> 
> 
> ------- Additional Comments From djekels@breakwater.com  2006-02-04 18:42 -------
> James,
> 
> Initially, the kernel panic when we run our multicast C++ application for 
> about 20 minutes before the panic  occured. What I accidentally descovered was 
> that if I run tcpdump the panic occures much faster, about 2 minutes from 
> start to the panic. 
> I upgraded the firmware on the 3ware SATA array controller and the device 
> driver, 3w-xxx.ko, per instruction of 3ware developers. 
> Even with this new firmware I get same results. 
> 

No, there's no kernel panic here.

What we have is two things:

a) A kernel _warning_, telling us that we're doing illegal things from
   softirq context in the scsi stack.

   This is a known bug.  It's possible that the _probability_ of this
   happening is increased when there's a lot of network traffic happening,
   because that causes more softirq activity.

b) The 3ware driver is shitting itself:

messages.4:Jan  6 12:15:41 chilsp010 kernel: 3w-9xxx: scsi0: AEN: INFO (0x04:0x0053): Battery capacity test is overdue:.
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi0 : 3ware 9000 Storage Controller
messages.4:Jan  6 12:15:41 chilsp010 kernel: 3w-9xxx: scsi0: Found a 3ware 9000 Storage Controller at 0xfeaffc00, IRQ: 217.
messages.4:Jan  6 12:15:41 chilsp010 kernel: 3w-9xxx: scsi0: Firmware FE9X 2.06.00.009, BIOS BE9X 2.03.01.051, Ports: 8.
messages.4:Jan  6 12:15:41 chilsp010 kernel:   Vendor: AMCC      Model: 9500S-8    DISK   Rev: 2.06
messages.4:Jan  6 12:15:41 chilsp010 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 03
messages.4:Jan  6 12:15:41 chilsp010 kernel: SCSI device sda: 390602752 512-byte hdwr sectors (199989 MB)
messages.4:Jan  6 12:15:41 chilsp010 kernel: SCSI device sda: drive cache: write back, no read (daft)
messages.4:Jan  6 12:15:41 chilsp010 kernel:  sda: sda1 sda2
messages.4:Jan  6 12:15:41 chilsp010 kernel: Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi: On host 0 channel 0 id 0 only 511 (max_scsi_report_luns) of 493425154 luns reported, try increasing max_scsi_report_luns.
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi: host 0 channel 0 id 0 lun 0xb0b800008ed88ec0 has a LUN larger than currently supported.
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi: host 0 channel 0 id 0 lun 0xfbbe007cbf0006b9 has a LUN larger than currently supported.
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi: host 0 channel 0 id 0 lun 0x0002f3a4ea210600 has a LUN larger than currently supported.
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi: host 0 channel 0 id 0 lun 0x00bebe073804750b has a LUN larger than currently supported.
messages.4:Jan  6 12:15:41 chilsp010 kernel: scsi: host 0 channel 0 id 0 lun 0x83c61081fefe0775 has a LUN larger than currently supported.

I don't know why b) is happening.

Can you please confirm that the occurrence of b) is increased if there's a
tcpdump happening?  I don't believe that's the case, because b) happened at
boot.

In other words, we have two coompletely unrelated bugs.   Do you agree?
