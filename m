From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented
 and there's not way to prevent the kernel from using the 2nd cdb byte for
 the LUN
Date: Wed, 20 Aug 2014 15:15:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1408201507280.1959-100000@iolanthe.rowland.org>
References: <20140819175625.GB4617@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:36261 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752461AbaHTTPK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Aug 2014 15:15:10 -0400
In-Reply-To: <20140819175625.GB4617@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Tiziano Bacocco <tiziano.bacocco@gmail.com>, Douglas Gilbert <dgilbert@interlog.com>, bugzilla-daemon@bugzilla.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Tue, 19 Aug 2014, Christoph Hellwig wrote:

> On Thu, Aug 07, 2014 at 11:58:37AM -0400, Alan Stern wrote:
> > > On Wed, Aug 06, 2014 at 04:02:22PM -0400, Alan Stern wrote:
> > > > > I doubt either of them forces users to hack up flags for these cases.
> > > > 
> > > > Why was this change needed in the first place?  There's no explanation 
> > > > in the patch itself.
> > > 
> > > Which chance?  The one to not support SG_FLAG_LUN_INHIBIT?
> > 
> > No, the patch that started this Bugzilla entry.  Tiziano says it is 
> > needed in order to send vendor-specific commands that use the LUN bits 
> > in CDB[1].
> 
> Yes, I'd really like to know the exact scenario.  What kind of command
> is this and who sends it?

I don't know what the command is, but Tiziano is sending it via the
SCSI-generic (sg) interface.

In the meantime, I have made a little progress with Windows.  It turns
out there are two reasons my earlier test didn't work:

	I didn't bother to set up a valid serial number for the test
	device, and Windows wants to see the serial number.

	Windows wants at least one of the logical units to be
	removable.

After those issues were fixed, the host did recognize both logical 
units.  I tested with two devices, one reporting an ANSI SCSI level of 
0 and the other 2.  In both cases, Windows 7 does _not_ stick the LUN 
value into the high bits of CDB[1].

This suggests that we shouldn't be doing that either, for USB
mass-storage devices.  But I'm reluctant to change it because of the
possibility of regressions, not to mention the fact that it would
violate the SCSI spec.

Suggestions?

Alan Stern

