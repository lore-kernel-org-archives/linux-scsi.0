From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: new runtime scsi warnings in 2.6.24-rc6+git
Date: Sat, 12 Jan 2008 14:16:15 -0600
Message-ID: <1200168975.3656.54.camel@localhost.localdomain>
References: <Pine.SOC.4.64.0801041231320.15055@math.ut.ee>
	 <200801122058.55750.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51114 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757769AbYALUQV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jan 2008 15:16:21 -0500
In-Reply-To: <200801122058.55750.rjw@sisk.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Meelis Roos <mroos@linux.ee>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>


On Sat, 2008-01-12 at 20:58 +0100, Rafael J. Wysocki wrote:
> On Friday, 4 of January 2008, Meelis Roos wrote:
> > Todays git gives the following warning during bootup on a Intel 845+PATA 
> > PC (using libata to drive PATA):
> > 
> > Driver 'sd' needs updating - please use bus_type methods
> > Driver 'sr' needs updating - please use bus_type methods
> 
> They are due to commit 751bf4d7865e4ced406be93b04c7436d866d3684, AFAICS, and
> they don't mean anything wrong.

Yes ... SCSI actually is actually using the bus_type methods.  The issue
is that we need to cascade the removes so we're using the driver remove
method for this.  The warning appears if you have both a bus_type remove
and a driver remove (and a host of other duplicate methods), I think
because if the bus_type method is set, the driver method won't be
called.

However, we've taken all this into account and our bus type remove calls
into the driver remove itself ... unfortunately there seems to be no way
to persuade the driver core we know what we're doing.

James


