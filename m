From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: RE: [PATCH v7] st implement tape statistics
Date: Wed, 6 May 2015 15:05:49 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3BFA9A0E@G9W0766.americas.hpqcorp.net>
References: <DDB9C85B850785449757F9914A034FCB3BFA45A3@G9W0766.americas.hpqcorp.net>
 <20150505174241.GA6033@infradead.org>
 <DDB9C85B850785449757F9914A034FCB3BFA96F7@G9W0766.americas.hpqcorp.net>
 <20150506043047.GA2077@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t5008.houston.hp.com ([15.240.92.66]:54592 "EHLO
	g9t5008.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbbEFPGf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2015 11:06:35 -0400
In-Reply-To: <20150506043047.GA2077@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Laurence Oberman (loberman@redhat.com)" <loberman@redhat.com>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>

I don't see this as something that is easily done. It would require new entries in the statistics (and including increasing the arrays to include an other count and adding a byte count which has to be a u64). It would seem that if you were taking this approach you would really need to almost rewrite the tape driver to achieve close integration. If someone wants to rewrite the driver I'd be happy to help on the statistics side.

I don't feel that I have the experience to complete such a project by myself and there are huge risks associated with significant changes to the block layer in doing this. In the st driver the changes are isolated and we have a driver that only allows a single outstanding read or write or ioctl to a tape drive so it doesn't need the same level of complexity that the block layer provides.

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Wednesday, May 06, 2015 2:31 PM
To: Seymour, Shane M
Cc: Christoph Hellwig; linux-scsi@vger.kernel.org; Laurence Oberman (loberman@redhat.com); Kai.Makisara@kolumbus.fi; James E.J. Bottomley (JBottomley@parallels.com); Elliott, Robert (Server Storage)
Subject: Re: [PATCH v7] st implement tape statistics

On Wed, May 06, 2015 at 01:11:26AM +0000, Seymour, Shane M wrote:
> "The tape driver does not have access to the block device i/o statistics because the tapes are not block devices but character devices. They use the Linux block subsystem enough to do i/o but this does not include access to the statistics counters.
> 
> ... One alternative is, of course, to tie the st driver more into the Linux block device system. I have looked into this several times but have never seen how to do this in a simple enough way."

I know the architecture pretty well, but the question is if we can export some of that functionality so that it works for character devices nodes that driver a request_queue.  Note that it was formualted as a questions as thast change seems obvious but might not be feasible for one reason or another.  If you looked at it and consider it not doable or at least not worthwhile for good reasons document those in the patch description.
