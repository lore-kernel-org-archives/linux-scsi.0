From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [linux-usb-devel] [2.6-test] Bug in usb-storage or scsi?
Date: Fri, 12 Sep 2003 13:56:28 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030912135628.B21598@beaverton.ibm.com>
References: <3F5E434D.6080801@unixsol.org> <Pine.LNX.4.44L0.0309101219190.905-100000@ida.rowland.org> <20030910170227.C3367@beaverton.ibm.com> <1063392194.3677.7.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:63995 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S261873AbTILU5F
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2003 16:57:05 -0400
Content-Disposition: inline
In-Reply-To: <1063392194.3677.7.camel@patehci2>; from p.lavarre@ieee.org on Fri, Sep 12, 2003 at 12:43:14PM -0600
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: stern@rowland.harvard.edu, mdharm-usb@one-eyed-alien.net, usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org

On Fri, Sep 12, 2003 at 12:43:14PM -0600, Pat LaVarre wrote:
> 
> > From: Patrick Mansfield <patmans@us.ibm.com>
> > ...
> > last April: ... changes since then
> > in how the MODE SENSE is handled (sd.c only?)
> 
> Anybody know more?

The mode sense 6 vs 10 that James mentioned, search the code for
use_10_for_ms, used in scsi_lib.c, set to 0 in scsi_scan.c and set to 1 by
drivers/usb/storage/scsiglue.c.

> > If you moved a device from one transport to
> > another, the commands sent to the device
> > should not change: for example, you move an
> > iSCSI attached device onto your local system
> > via SPI.
> 
> Eh?

More specifically, if you are using some LLDD or transport X as a bridge
to another transport Y, we might set flags - maybe what commands we can
send - relative to transport X, when they might be inappropriate for
transport Y.

Examples:

If USB (usb-storage) bridged to a remote device that is actually connected
via SPI, today we will try and send 10 byte MODE SENSE commands to the
device.

If iSCSI bridged to a remote USB device, we will only send 6 byte MODE
SENSE commands.

There are also devices that work with FCP or SPI, but those generally
don't have borken devices like the USB storage ones.

> I thought in linux we have competing cdb authors on purpose.  For
> example, how sr decides if a device is writable differs from how ide-cd
> decides if a device is writable.  I thought that the powers that be like
> linux that way.
> 
> No?

> Having multiple cdb authors necessarily means that the cdb's passed thru
> one kind of transport or another do differ any time the multiple
> versions of copy-edited authoring code differ.
> 
> In particular, people designing an unusual device to work with linux
> have to repeat their work: once for sr, again for ide-cd, and so on.
> 
> No?

I don't get your point - I was talking about the transport (LLDD), not the
actual scsi device or upper level drivers.

Code used for different upper level scsi devices should not be duplicated,
I don't know ide or cd enough to comment in that area, except that there
is common cd code (struct cdrom_device_ops).

sr could probably do some of the same things as sd to figure out if a
device is writable, but we are best maintaining current algorithms (don't
have sr send new mode sense commands) to avoid borken devices.

-- Patrick Mansfield
