From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Fwd: Re: [linux-usb-devel] USB Storage oops in 2.5.69-bk8
Date: Fri, 16 May 2003 09:22:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030516162250.GB1654@beaverton.ibm.com>
References: <20030516155621.GB11432@iucha.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:56294 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S264475AbTEPQHb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 12:07:31 -0400
Content-Disposition: inline
In-Reply-To: <20030516155621.GB11432@iucha.net>
List-Id: linux-scsi@vger.kernel.org
To: Florin Iucha <florin@iucha.net>
Cc: linux-scsi@vger.kernel.org

This might be a case that the scsi_error handler never reclaimed or
canceled the command (i.e., this is a lost command) and probably should
not update the fields.

Could you get me a little more data on what the error handler actions
where by doing the following:
	1.) Ensure SCSI logging is enabled in your config.
	CONFIG_SCSI_LOGGING=y.

	2.) Prior to the mount of the Compact Flash card.
	echo "scsi log error 4" > /proc/scsi/scsi

	If this is getting set dmesg should give a line that scsi
	logging level set to ...

	3.) Mount the Compact Flash card and send me the output when it
	fails.

Thanks,

Florin Iucha [florin@iucha.net] wrote:
> ----- Forwarded message from Alan Stern <stern@rowland.harvard.edu> -----
> 
> > Subject: Re: [linux-usb-devel] USB Storage oops in 2.5.69-bk8
> > From: Alan Stern <stern@rowland.harvard.edu>
> > To: Florin Iucha <florin@iucha.net>
> > Cc: USB development list <linux-usb-devel@lists.sourceforge.net>
> > Date: Fri, 16 May 2003 11:49:00 -0400 (EDT)
> > 
> > On Thu, 15 May 2003, Florin Iucha wrote:
> > 
> > > Hello,
> > > 
> > > I get the following oops in 2.5.69-bk8 when I try to mount a Compact
> > > Flash card in a SanDisk adapter:
> > > 
> > > usb 2-1: USB disconnect, address 2
> > > hub 2-0:0: debounce: port 1: delay 100ms stable 4 status 0x301
> > > hub 2-0:0: new USB device on port 1, assigned address 3
> > > input: USB HID v1.00 Mouse [Microsoft Microsoft IntelliMouse? Explorer] on usb-00:02.3-1
> > > usb 2-1: USB disconnect, address 3
> > > drivers/usb/input/hid-core.c: can't resubmit intr, 00:02.3-1/input0, status -19
> > > hub 2-0:0: debounce: port 1: delay 100ms stable 4 status 0x301
> > > hub 2-0:0: new USB device on port 1, assigned address 4
> > > input: USB HID v1.00 Mouse [Microsoft Microsoft IntelliMouse? Explorer] on usb-00:02.3-1
> > > SCSI device sda: 31232 512-byte hdwr sectors (16 MB)
> > > sda: Write Protect is off
> > > sda: Mode Sense: 02 00 00 00
> > > drivers/usb/core/message.c: usb_control/bulk_msg: timeout
> > > drivers/usb/core/message.c: usb_control/bulk_msg: timeout
> > > drivers/usb/core/hub.c: USB device not accepting new address (error=-22)
> > > scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 0 lun 0
> > > usb 5-2: USB disconnect, address 2
> > > Unable to handle kernel paging request at virtual address 544150a8
> > >  printing eip:
> > > c02abc39
> > > *pde = 00000000
> > > Oops: 0000 [#1]
> > > CPU:    0
> > > EIP:    0060:[<c02abc39>]    Not tainted
> > > EFLAGS: 00010286
> > > EIP is at scsi_eh_finish_cmd+0x19/0x60
> > > eax: ef19d000   ebx: eef28080   ecx: eef22140   edx: 54415056
> > > esi: eef21fa8   edi: eef21fb0   ebp: eef21fa8   esp: eef21f60
> > > ds: 007b   es: 007b   ss: 0068
> > > Process scsi_eh_1 (pid: 118, threadinfo=eef20000 task=eef23340)
> > > Stack: eef28080 eef28080 eef21fb0 c02ac418 eef28080 eef21fa8 00000000 00000000 
> > >        00000000 ef62f428 eef20000 00000282 eef21fa8 c02ac8d6 eef21fb0 eef21fa8 
> > >        eef21fa8 eef21fb0 eef21fa8 eef21fa8 eef28098 eef28098 ef62f400 eef21fd4 
> > > Call Trace:
> > >  [<c02ac418>] scsi_eh_offline_sdevs+0x68/0x80
> > >  [<c02ac8d6>] scsi_unjam_host+0xc6/0xd0
> > >  [<c02ac9b1>] scsi_error_handler+0xd1/0x120
> > >  [<c02ac8e0>] scsi_error_handler+0x0/0x120
> > >  [<c0108abd>] kernel_thread_helper+0x5/0x18
> > > 
> > > Code: 0f b7 42 52 48 66 89 42 52 c7 43 24 00 00 00 00 66 c7 43 08 
> > > 
> > > I cannot tell if it is a regression since I just got the CF and the
> > > adapter.
> > 
> > This is a problem in the SCSI error handler.  You should post your 
> > question to <linux-scsi@vger.kernel.org>.  Maybe also cc: to Mike Anderson 
> > <andmike@us.ibm.com>.
> > 
> > Alan Stern
> 
> ----- End forwarded message -----
> 
> florin
> 
> -- 
> 
> "NT is to UNIX what a doughnut is to a particle accelerator."


-andmike
--
Michael Anderson
andmike@us.ibm.com

