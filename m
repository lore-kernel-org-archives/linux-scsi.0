From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Fw: [BUG] USB Storage OOPS and a D state process in 2.6.10
Date: Mon, 10 Jan 2005 12:14:30 -0800
Message-ID: <20050110201430.GB11967@us.ibm.com>
References: <200501102114.37744.harisri@internode.on.net> <Pine.LNX.4.44L0.0501101212160.1334-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0501101212160.1334-100000@ida.rowland.org>
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Srihari Vijayaraghavan <harisri@internode.on.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Alan Stern [stern@rowland.harvard.edu] wrote:
> Jan 10 20:49:08 desktop kernel: scsi113 : SCSI emulation for USB Mass Storage devices
> Jan 10 20:49:08 desktop kernel: usb-storage: device found at 113
> Jan 10 20:49:08 desktop kernel: usb-storage: waiting for device to settle before scanning
> Jan 10 20:49:12 desktop kernel: In bus_reset, srb: 0000010037d71640
> Jan 10 20:49:12 desktop kernel:   device: 0000010038e3d000
> Jan 10 20:49:12 desktop kernel:   host: 000001002b500c00
> Jan 10 20:49:12 desktop kernel:   hostdata: 000001002b549c00
> 
> This is the first indication of something funny.  I can't think how a bus
> reset would get initiated by the kernel -- that only happens after a
> timeout.  Maybe it came from a user program?

Well it can get initiated in the scsi error handler. This can be verified
by setting the logging_level (sysctl -w dev.scsi.logging_level=0x4).

You probably do not need to do this as I assume what is happening is that
with all the plug and unplug that is being initiated that a IO is in
flight when the scsi_remove_host functions is called. It looks like we
still have to decide on the removal cleanup. Currently scsi_host_cancel
being called from scsi_remove_host appears to not do anything as
scsi_forget_host removes the devices from the list it iterates over. Also
as previously mentioned by you there are races with scsi_mid canceling IOs
that might be completing.  Both of these issue where mentioned in an old
thread (link provided below), but not completely resolved.

http://marc.theaimsgroup.com/?t=109630920600005&r=1&w=2

What is needed is for the LLDD to ensure all IO sent through the LLDD's
queuecommand functions gets a scsi_done call (even a fail call). The scsi
mid applies choke points to stop IO being set to the LLDDs queuecommand,
but there can be races during a host removal (you previously mentioned
this). This would also imply that scsi mid should not be making the call
to scsi_host_cancel (which appears to not do anything anyway).


-andmike
--
Michael Anderson
andmike@us.ibm.com



-------------------------------------------------------
The SF.Net email is sponsored by: Beat the post-holiday blues
Get a FREE limited edition SourceForge.net t-shirt from ThinkGeek.
It's fun and FREE -- well, almost....http://www.thinkgeek.com/sfshirt
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
