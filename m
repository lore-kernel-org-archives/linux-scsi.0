From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Kernel 3.10.3 "reset SuperSpeed USB device number 2 using
 xhci_hcd"
Date: Sun, 28 Jul 2013 15:28:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1307281505410.18237-100000@netrider.rowland.org>
References: <51F44125.2040803@ntlworld.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:33555 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753529Ab3G1T2y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jul 2013 15:28:54 -0400
In-Reply-To: <51F44125.2040803@ntlworld.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stuart Foster <smf.linux@ntlworld.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ed Tomlinson <edt@aei.ca>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, stable@vger.kernel.org

On Sat, 27 Jul 2013, Stuart Foster wrote:

> On 07/27/13 20:34, Alan Stern wrote:
> > On Sat, 27 Jul 2013, Stuart Foster wrote:
> >
> >> On 07/27/13 15:58, Alan Stern wrote:
> >>> On Sat, 27 Jul 2013, Stuart Foster wrote:
> >>>
> >>>> Hi,
> >>>>
> >>>> I have started having problems with an external USB 3 diskdrive, the
> >>>> problems started when I moved from the 3.10.2 kernel to 3.10.3.
> >>>> The machine is a ASUS M5A97 PRO, BIOS 1604.
> >>>
> >>> On Sat, 27 Jul 2013, Ed Tomlinson wrote:
> >>>
> >>>> Hi
> >>>>
> >>>> Same problem here with 3.10.3.  Dmesg filtered with 'hci'.
> >>>
> >>> Each of you, please post a usbmon trace showing what happens when the
> >>> drive is plugged in.
> >>>
> >>> Alan Stern
> >>>
> >>>
> >> Hi Alan
> >>
> >> Herewith the log you requested.
> >
> > The trace shows that something is sending an invalid INQUIRY command
> > (one with a 512-byte transfer length) to the drive.  Normally such
> > things are done by user programs, but in this case it looks more like
> > the command came from somewhere in the kernel.  I have no idea where.
> >
> > Did you change anything besides the kernel when going from 3.10.2 to
> > 3.10.3?
> >
> > If you boot now into a 3.10.2 kernel, does the drive work?
> >
> > What happens if you plug the drive into a USB-2 port?  (I expect it
> > will make no difference at all.)
> >
> > Alan Stern
> >
> >
> Hi Alan,
> 
> The config between 3.10.2 and 3.10.3 did not change.
> 
> The drive works correctly on 3.10.2 (I usually keep the previous kernel 
> available just in case).
> 
> On 3.10.3 the drive fails in a similar manner when plugged into a USB-2 
> port.
> 
> For interest I have tried the USB-3 drive in the USB-2 ports on an IBM 
> thinkpad R51 laptop that is also running 3.10.3 and that fails also.
> 
> Conversely I have tried a USB-2 drive on both the IBM and my ASUS 
> machine and that works fine on 3.10.3 in all available USB ports.

Thank you.  I was able to duplicate the problem on my own machine and 
track down the bug.

It was introduced by commit 98dcc2946adb (SCSI: sd: Update WRITE SAME
heuristics).  This commit adds a call to scsi_get_vpd_page() in
sd_read_write_same() without first checking sd_try_extended_inquiry().  
As noted in the latter routine, VPD inquiries will crash some devices.

Martin, this bug needs to be fixed in 3.11.  As far as the stable
kernels are concerned, the best thing for now may simply be to revert
it.

Alan Stern

