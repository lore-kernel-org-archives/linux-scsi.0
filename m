From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] Re: /proc/scsi/map
Date: Sun, 16 Jun 2002 10:05:49 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <aeigls$orm$2@main.gmane.org>
References: <UTC200206152154.g5FLsCI23053.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: garloff@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, sancho@dauskardt.de, linux-usb-devel@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net

Andries.Brouwer@cwi.nl wrote:
>     Both usb-storage and iee1394-sbp2 know the GUID. It only needs to be 
>     communicated..
> 
> The usb-storage GUID is just one random item of information.
> One might wish for much more.
> 
> And: this information is already somewhere:

For example, on the 2.5 kernels one might also wish for the physical
path to the USB device in question ... what usb_make_path() returns.
(Simple enough to backport this to 2.4, which some folk have wanted.)

It's a string like "usb-06:0f.1-3.2" indicating first that it's
USB, then that it's the bus with name/serial "06:0f.1" (which in
this case is a PCI function), then that it's connected to port 3 on
the root hub, and port 2 on the hub connected there.  That's a
stable name:  it won't change unless/until you re-cable things.

Right now all of the 2.5 USB network adapters with ethool support
return those strings in the bus_info field, FWIW -- someone else
on this thread mentioned the need to asssign network interface names
based on physical location, and for USB (and likely PCI) that can
be done already.

- Dave


