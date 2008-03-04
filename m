From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 7/8] SCSI: add a field to scsi_device to count open file
 references
Date: Tue, 4 Mar 2008 12:00:39 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0803041151510.4039-100000@iolanthe.rowland.org>
References: <47CC99AF.10509@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:46270 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752184AbYCDRAj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 12:00:39 -0500
In-Reply-To: <47CC99AF.10509@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 4 Mar 2008, Stefan Richter wrote:

> >> On Mon, 2008-03-03 at 15:16 -0500, Alan Stern wrote:
> >>> This count
> >>> will be used by usb-storage to determine whether USB-PERSIST should be
> >>> forced on during a suspend.
> 
> Why should devices without openers be treated differently from devices 
> with openers?

It's not the openers themselves that matter; it's whether or not the 
device contains a mounted filesystem.  I'm using the openers as a proxy 
for that.  If you can suggest a better approach, I'd like to hear it.

Devices containing a mounted filesystem need special treatment to avoid
being disconnected when power is lost during a system suspend or
hibernation.  In principle this special treatment could be extended to
all USB devices, whether mounted or not.  However the USB spec says not
to do it.

Really it's a tradeoff.  If power goes out during a suspend and a
device with a mounted filesystem is disconnected as a result, there's a
very high risk of data loss.  Conversely, if the user replaces the
medium while the system is asleep and the kernel doesn't realize it,
then upon waking the data on the new medium will be corrupted.

After suffering from exactly this sort of data loss, Linus decreed that
the kernel should automatically avoid disconnecting devices with
mounted filesystems, even though it contradicts the spec.  So I need a
way to know whether anything is mounted on a device below a SCSI host.

Alan Stern

