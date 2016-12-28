From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: JMS56x not working reliably with uas driver
Date: Tue, 27 Dec 2016 21:19:35 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1612272109450.3821-100000@netrider.rowland.org>
References: <ab607030-bb4f-f6ac-755b-f38e7cd13be7@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:49759 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1750707AbcL1C06 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Dec 2016 21:26:58 -0500
In-Reply-To: <ab607030-bb4f-f6ac-755b-f38e7cd13be7@caviumnetworks.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: George Cherian <gcherian@caviumnetworks.com>
Cc: Oliver Neukum <oneukum@suse.com>, hdegoede@redhat.com, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Tue, 27 Dec 2016, George Cherian wrote:

> Hi Alan,
> 
> 
> On Tuesday 27 December 2016 08:50 PM, Alan Stern wrote:
> > On Tue, 27 Dec 2016, Oliver Neukum wrote:
> >
> >> On Thu, 2016-12-22 at 17:44 -0500, Alan Stern wrote:
> >>> I don't see how this patch fixes anything.  Unless I'm mistaken, it
> >>> just avoids the problem by preventing the system from issuing the
> >>> command that provokes the error, rather than really fixing the
> >>> underlying error.
> >> Please clarify. If a reset leads to a disconnect, isn't that
> >> exactly what we want?
> > I didn't express myself clearly enough.  Yes, if a reset leads to a
> > disconnect then avoiding the reset will avoid problems.
> >
> > But the _real_ error here is that xhci-hcd says "ERROR Transfer event
> > for disabled endpoint or incorrect stream ring" when the disconnect
> > occurs during reset.
> I think there is some misunderstanding of the issues.
> 
> "ERROR Transfer event for disabled endpoint or incorrect stream ring"
> This particular message is during the connect of the device and not
> during the disconnect.
> To avoid this message the unusual_uas.h patch was sent earlier.

Right -- the patch _avoids_ the message.  But it doesn't fix the actual 
error/bug that caused to message to be logged in the first place.

> During disconnect of the device I get   "scsi host4: uas_post_reset: alloc streams error -19 after reset" and 
> I dont get the same with the modified patch which Alan suggested, 
> instead I get a proper disconnect.

Good.


On Tue, 27 Dec 2016, Oliver Neukum wrote:

> On Tue, 2016-12-27 at 10:20 -0500, Alan Stern wrote:
> > On Tue, 27 Dec 2016, Oliver Neukum wrote:
> > 
> > > On Thu, 2016-12-22 at 17:44 -0500, Alan Stern wrote:
> > > > I don't see how this patch fixes anything.  Unless I'm mistaken, it
> > > > just avoids the problem by preventing the system from issuing the
> > > > command that provokes the error, rather than really fixing the
> > > > underlying error.
> > > 
> > > Please clarify. If a reset leads to a disconnect, isn't that
> > > exactly what we want?
> > 
> > I didn't express myself clearly enough.  Yes, if a reset leads to a 
> > disconnect then avoiding the reset will avoid problems.
> 
> Good. Then we need to clarify whether the device was physically
> disconnected when the logs were taken.

According to George, it was connected when the first error message 
occurred and physically disconnected when the second message occurred.

> > But the _real_ error here is that xhci-hcd says "ERROR Transfer event
> > for disabled endpoint or incorrect stream ring" when the disconnect 
> > occurs during reset.  That shouldn't happen, no matter what quirks the 
> > device has.  It indicates a bug either in uas or in xhci-hcd.
> 
> True. I am afraid that there necessarily is a window for resetting a
> disconnected device. But the check you proposed is better.
> however, I'd like to encapsulate that together with a test for
> logical disconnect. Uas is unlikely to be the only driver that has
> this issue.

True enough.  We could have a usb_device_is_disconnected() inline
helper for this purpose.  There's no need to try to distinguish 
between physical and logical disconnects, as far as I can see.

However, as George points out, the "Transfer event" error has nothing 
to do with disconnection.  It was triggered by the device's bogus 
response to a REPORT OPCODES command, or something of the sort.  We 
should be able to handle bogus responses without logging ERROR 
messages, because such messages indicate a bug in a kernel driver.

Alan Stern


