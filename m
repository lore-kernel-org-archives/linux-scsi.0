From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 26 Mar 2010 15:10:32 -0400
Message-ID: <4BAD06A8.1040100@interlog.com>
References: <4BA9D74F.9040507@gmail.com> <4BA7797F.8060605@gmail.com> <20100324155917.GA4382@xanatos> <59ca64281003241107x40c5d83co29d1ee03d8d3a0d1@mail.gmail.com> <20100326184021.GA4350@xanatos>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:49450 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab0CZTKl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Mar 2010 15:10:41 -0400
In-Reply-To: <20100326184021.GA4350@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Jonas Schwertfeger <jschwertfeger@gmail.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org

Sarah Sharp wrote:
> On Wed, Mar 24, 2010 at 07:07:58PM +0100, Jonas Schwertfeger wrote:
>> On Wed, Mar 24, 2010 at 4:59 PM, Sarah Sharp
>> <sarah.a.sharp@linux.intel.com> wrote:
>>> Despite the fact that this device probably won't work for 2.6.31 or
>>> 2.6.32, the xHCI driver shouldn't be hanging the system.  The reset
>>> device API probably shouldn't be back ported to those kernels, but I can
>>> allow the USB core to disable the device's port instead.
>> In 2.6.31 the drive would show up as /dev/sdb and be mountable. The
>> system froze when I mounted it and then tried to partition it. In
>> 2.6.32 however the drive does not even show up in /dev/. Thus, I
>> cannot reproduce a system hang here.
> 
> Hmm, ok, I would rather figure out why 2.6.31 is hanging, since 2.6.32
> does not.  Can you compile the latest 2.6.31 stable tree and use
> netconsole to capture the crash with CONFIG_USB_XHCI_HCD_DEBUGGING and
> CONFIG_USB_STORAGE_DEBUG turned on?  (I assume you know how to use
> netconsole, but if you don't, I've posted how I setup netconsole at
> http://sarah.thesharps.us/2010-03-26-09-41)
> 
>> I configured USB storage debugging and attached another log file. If
>> there is not enough information in it let me know I will proceed with
>> Alan's suggestion of using usbmon.
> 
> I think the amount of information is fine, but I'm not sure why the
> device would respond with a stall to this particular command, so I'm
> CC'ing the USB storage list and SCSI list.  Does anyone know what the
> third command is?  The USB storage driver reports it as an "unknown
> command".  I can see from scsi.h that 0x85 is the code for ATA_16, but
> I'm not sure what that command actually does.

ATA commands are being tunnelled through SCSI commands
as defined in section 12.2 of this draft:
http://www.t10.org/cgi-bin/ac.pl?t=f&f=sat2r09.pdf
[The access control page will accept most anything in its
fields.]

In the case of the SCSI ATA PASS-THROUGH 16 (i.e. ATA_16)
command (opcode 85(hex) in the first byte) the tunnelled
ATA command code is the second last byte (e.g. "ec" on
the command that seemed to crash).

Doug Gilbert
