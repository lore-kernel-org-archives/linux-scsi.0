From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: BTRFS doesn't handle USB device disconnect
Date: Wed, 11 Dec 2013 15:20:05 -0800
Message-ID: <20131211232005.GA2620@xanatos>
References: <20131211011755.GA3574@xanatos>
 <Pine.LNX.4.44L0.1312111058340.1531-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53525 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab3LKXUE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Dec 2013 18:20:04 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1312111058340.1531-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org, linux-usb@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, linux-scsi@vger.kernel.org

On Wed, Dec 11, 2013 at 11:03:09AM -0500, Alan Stern wrote:
> On Tue, 10 Dec 2013, Sarah Sharp wrote:
> > On 3.13-rc1, the btrfs partion from the disconnected USB device
> > continues to be listed as mounted.  Yanking the cable produces some
> > additional oops messages.  It also produced a couple hard-hangs.
> > Unfortunately, I didn't capture the dmesg during the hard-hangs, so I
> > can't tell for sure which driver is to blame (uas, btrfs, or xhci).
> 
> Does this happen with usb-storage instead of uas?
> 
> What about with ehci-hcd instead of xhci-hcd?
> 
> And just to be exotic, what about with dummy-hcd and the uas or
> g_mass_storage gadget driver?

I can't reproduce the hard-hangs (with xhci and uas), but I did manage
to reproduce a bug in uas where the disconnect function hangs, and hangs
the khubd thread as well.  This happens even with the btrfs partition
wiped from the drive, so it's not a btrfs issue.  I'll send a separate
bug report to Hans.

Sarah Sharp
