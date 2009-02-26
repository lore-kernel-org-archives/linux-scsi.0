From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RFC: Transport identifier
Date: Thu, 26 Feb 2009 15:32:24 -0500
Message-ID: <yq1prh5ey7b.fsf@sermon.lab.mkp.net>
References: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net>
	<1235663301.19035.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:52782 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbZBZUcg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Feb 2009 15:32:36 -0500
In-Reply-To: <1235663301.19035.44.camel@localhost.localdomain> (James Bottomley's message of "Thu\, 26 Feb 2009 15\:48\:21 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> I'd really rather not put transport specific knowledge back into
James> the mid-layer ... the whole idea of the transport classes was to
James> take it out as much as possible.

I felt that implementing transport classes for everything else was a
huge overkill for a simple identifier.


James> The other thought is that a lot of devices nowadays are bridged
James> (all SCSI DVDs have SPI to ATA bridges; a lot of high end USB
James> storage or enclosures has USB to ATA bridges), so a single
James> transport identifier doesn't quite cover it.

Nope.  And it was not means to be concise.  It was meant to be a hint as
to what kind of technology was at play.

To a large extent a dubious_transport bit would suffice.  But I also
wanted to remedy the lsscsi problem while I was at it.  As Doug
mentioned the current heuristics are icky.


James> The final thought is that a lot of what you're looking for is
James> actually in the PROTOCOL field of a VPD inquiry, so it might be
James> possible to use that to obviate a lot of this.

You mean the protocol mode page?  Or the version descriptors in INQUIRY?

I don't have a single device that provides the version descriptors.
Sadly.

I'm fine with the mode page approach, although a quick test shows only
very recent drives fill it out.  I'll try it on all my spindles in the
lab and see what I discover.

Maybe we can reverse the logic a bit and key off of whether the protocol
mode page is provided.  And consider devices dubious if it's not?

The thing is we need to start sending RC16 to a lot of drives very soon
because of the 4KB thing.  And as we've seen RC16 breaks a lot of junk
devices.  So we need a good indicator other than the SCSI rev. because
that unfortunately doesn't cut it.

-- 
Martin K. Petersen	Oracle Linux Engineering
