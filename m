From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] make the SCSI mid-layer obey the device online flag
Date: 06 Jun 2003 11:19:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1054912742.1778.25.camel@mulgrave>
References: <1054742495.1674.18.camel@mulgrave>
	<20030604165146.GA1426@beaverton.ibm.com>
	<1054754103.2360.8.camel@mulgrave>  <20030606073603.A13259@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:15879 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261861AbTFFPGW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2003 11:06:22 -0400
In-Reply-To: <20030606073603.A13259@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On Fri, 2003-06-06 at 02:36, Christoph Hellwig wrote:
> We need a way to disable _all_ I/O to a device due to the way the driver
> model works.  The driver model ->remove always is a surprise removal,
> so the underlying PCI (or whatever) device for a scsi host can go away
> anytime.  Because of that we need to make damn sure no call to
> ->queuecommand will happen after scsi_remove_host is called.  Whether
> this is implemented with the same mechanisms as the current sdev->online
> is another question.

I'm not entirely convinced.  Sure, the device has gone away, but the
driver is still there.  If you rip out a real SCSI disc, all subsequent
commands will error with DID_NO_CONNECT, I don't see why this should be
so hard for other types of storage do follow.

The question is whether we should allow (and any LLD actually wants) the
ability to tell the mid-layer that it will accept no further commands at
all.

At the moment, I think we can handle both ejection scenarios adequately
without forbidding all commands to the LLD:

Surprise ejection:

driver starts returning DID_NO_CONNECT to commands
possibly hotplug notify of surprise ejection
device->online to be reset
command queue drains
command queue drops to zero, ->remove can be called and everything
cleaned up from user level (including remove-single-device)

Nice ejection:

hotplug notify of ejection request
eject script cleans up, unmounts, possibly resets online
command queue drains
command queue drops to zero, ->remove can be called and everything
cleaned up from user level (including remove-single-device)
ejection may now proceed

For the remove_host scenario, it would be convenient just to do
nice/surprise ejections on all the devices (from user level) and then do
the clean up when the hosts device count falls to zero.  That may imply
some type of host->offline flag which disallows the addition of new scsi
devices to the host.

James


