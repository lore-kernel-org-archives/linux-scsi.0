From: Oliver.Neukum@lrz.uni-muenchen.de
Subject: Re: [linux-usb-devel] Re: bug 2400
Date: Wed, 7 Apr 2004 11:19:58 +0200 (MET DST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.SOL.4.58.0404071116580.2609@sun3.lrz-muenchen.de>
References: <Pine.LNX.4.44L0.0404032026590.30873-100000@netrider.rowland.org>
 <4071EA82.3020901@pacbell.net> <1081214360.1756.330.camel@mulgrave>
 <200404060852.34169.oliver@neukum.org> <1081260215.1804.17.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay2.lrz-muenchen.de ([129.187.254.102]:19861 "EHLO
	mailrelay2.lrz-muenchen.de") by vger.kernel.org with ESMTP
	id S261942AbUDGJUX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Apr 2004 05:20:23 -0400
In-Reply-To: <1081260215.1804.17.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Oliver Neukum <oliver@neukum.org>, David Brownell <david-b@pacbell.net>, Alan Stern <stern@rowland.harvard.edu>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 6 Apr 2004, James Bottomley wrote:

> On Tue, 2004-04-06 at 01:52, Oliver Neukum wrote:
> > Pure refcounting can never protect you against races with freeing objects.
> > The counters themselves must be protected. Try as you might you need
> > locks for that and rules on how this locks are to be used.
>
> Which part of
>
> On Mon, 2004-04-05 at 20:19, James Bottomley wrote:
> > Now, if the subsystem is going to garbage collect its own object as a
> > result of the other object disconnect, then it is responsible for
> > synchronising that with reference gets on its own object.  However, that
> > is easily achievable via *intra* subsystem synchronisation.
>
> didn't you understand?
>
> However, how a subsystem resolves this intra subsystem synchronisation
> is up to it ... and it doesn't have to do it with locks.  So there are
> no exposed locks for this and no rules therefore, for how to use them.

How you do this notification is irrelevant. You must address the basic
race of increasing the refcount from 0 to 1. After that all is fine.
At some point you have to handle a pointer to an object whose refcount
is unknown to you.

	Regards
		Oliver

