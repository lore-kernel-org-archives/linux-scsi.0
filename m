From: Oliver Neukum <oliver@neukum.org>
Subject: Re: SCSI dynamic power management
Date: Tue, 20 Nov 2007 16:36:30 +0100
Message-ID: <200711201636.30767.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0711191405160.3005-100000@iolanthe.rowland.org> <200711201607.06317.oliver@neukum.org> <1195572119.3131.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:47051 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494AbXKTPge (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Nov 2007 10:36:34 -0500
In-Reply-To: <1195572119.3131.21.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Matthew Wilcox <matthew@wil.cx>, Oliver Neukum <oliver@neukum.name>, SCSI development list <linux-scsi@vger.kernel.org>

Am Dienstag 20 November 2007 schrieb James Bottomley:
> 
> On Tue, 2007-11-20 at 16:07 +0100, Oliver Neukum wrote:
> > Am Dienstag 20 November 2007 schrieb James Bottomley:
> > > I don't understand why you want to do this.  Power management is a
> > > layered issue on SCSI, divided (as always) into host, device and
> > > transport.  The idle you're talking about is a pure device thing, so it
> > > can be managed by the ULD (and currently is).  When a unit is stopped,
> > 
> > The lower layers don't know how to correctly suspend a device. sd_suspend()
> > may know how to do it. It would also mean the LLD having to detect idleness.
> 
> You really mean you want to involve the transport as well, right?  So

Yes, we cannot avoid that. Some device drop their caches unless they are
flushed.

> ipso facto this is more than simple idleness management.  Thus, you
> really need to look into the full solution (host, transport and ULD).

Only detecting idleness without doing anything with that knowledge would
be pointless :-)
What is the right kind of sequence?

	Regards
		Oliver

