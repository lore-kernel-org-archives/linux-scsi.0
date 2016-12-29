From: Oliver Neukum <oneukum@suse.com>
Subject: Re: JMS56x not working reliably with uas driver
Date: Thu, 29 Dec 2016 09:28:04 +0100
Message-ID: <1483000084.4506.1.camel@suse.com>
References: <Pine.LNX.4.44L0.1612272109450.3821-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52314 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751167AbcL2Iec (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Dec 2016 03:34:32 -0500
In-Reply-To: <Pine.LNX.4.44L0.1612272109450.3821-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: George Cherian <gcherian@caviumnetworks.com>, hdegoede@redhat.com, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Tue, 2016-12-27 at 21:19 -0500, Alan Stern wrote:
> On Tue, 27 Dec 2016, George Cherian wrote:

> > True. I am afraid that there necessarily is a window for resetting a
> > disconnected device. But the check you proposed is better.
> > however, I'd like to encapsulate that together with a test for
> > logical disconnect. Uas is unlikely to be the only driver that has
> > this issue.
> 
> True enough.  We could have a usb_device_is_disconnected() inline
> helper for this purpose.  There's no need to try to distinguish 
> between physical and logical disconnects, as far as I can see.

There is no such need. There is a need for both checks though.

> However, as George points out, the "Transfer event" error has nothing 
> to do with disconnection.  It was triggered by the device's bogus 
> response to a REPORT OPCODES command, or something of the sort.  We 
> should be able to handle bogus responses without logging ERROR 
> messages, because such messages indicate a bug in a kernel driver.

Indeed. We have two independent issues. We should have two independent
fixes.

	Regards
		Oliver



