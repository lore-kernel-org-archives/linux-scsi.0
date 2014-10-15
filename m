From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: Concurrent SG_SCSI_RESET ioctls
Date: Wed, 15 Oct 2014 14:34:50 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958D02A3A@G9W0745.americas.hpqcorp.net>
References: <94D0CD8314A33A4D9D801C0FE68B402958CE9B54@G4W3202.americas.hpqcorp.net>
 <20141011161110.GA16812@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958CEB20A@G4W3202.americas.hpqcorp.net>
 <20141014111354.GA3022@infradead.org> <543D5272.5080102@interlog.com>
 <20141015132537.GA10652@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:49436 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaJOOfo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Oct 2014 10:35:44 -0400
In-Reply-To: <20141015132537.GA10652@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Douglas Gilbert <dgilbert@interlog.com>
Cc: "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Don Brace (PMC)" <Don.Brace@pmcs.com>, "Scales, Webb" <webb.scales@hp.com>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, 15 October, 2014 8:26 AM
...
> On Tue, Oct 14, 2014 at 12:42:26PM -0400, Douglas Gilbert wrote:
> > I don't mind if you change it. However I plan to release
> > sg3_utils-1.40 in the next 2 or 3 weeks, so that would
> > be the earliest a revised sg_reset would be available for
> > distros. Improving error reports is something I always
> > like to do (so ENODEV for the "in progress" case seems a
> > bit strident).
> 
> If sg_utils needs any changes for a different ENODEV we shouldn't
> bother - breaking backwards compatibility is a bad idea.

None of the values will cause the current version of sg_reset to
retry the request.  Maybe -EBUSY should be returned, and interpreted
that way by future versions of sg_reset?

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Monday, 13 October, 2014 5:24 AM
...
> Both the existing code and my new code still serialize
> eh_*_reset_handler callers using the crude tmf_in_progress flag. Using
> a proper lock for it would seem preferable to me, as would be bouncing
> the work for SG_SCSI_RESET to the EH thread.

Eliminating serialization would be better, though.  Devices should
be independent, so bus device resets (that are not escalated)
should also be independent.


