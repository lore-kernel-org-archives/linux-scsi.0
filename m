From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: RE: [PATCH v7] st implement tape statistics
Date: Wed, 6 May 2015 01:11:26 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3BFA96F7@G9W0766.americas.hpqcorp.net>
References: <DDB9C85B850785449757F9914A034FCB3BFA45A3@G9W0766.americas.hpqcorp.net>
 <20150505174241.GA6033@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t5008.houston.hp.com ([15.240.92.66]:47123 "EHLO
	g9t5008.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbbEFBNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2015 21:13:05 -0400
In-Reply-To: <20150505174241.GA6033@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Laurence Oberman (loberman@redhat.com)" <loberman@redhat.com>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>

Hi Christoph,

> The subject line should be
> 
> "st: implement tape statistics" to fit the general scheme.

No problem I can fix that easily.

> > On Thu, Apr 23, 2015 at 08:06:50AM +0000, Seymour, Shane M wrote:
> > Signed-off-by: Shane Seymour <shane.seymour@hp.com>
> > Tested-by: Shane Seymour <shane.seymour@hp.com>
>
> Tested-by is usually used for other testers, not the patch author.

I'll remove that.

> Where is the description of what these staistics do and what you need
> them for?  A patch with just a subject and a signoff is unlikely to get applied.

I'll add that.

> A lot of the code seems to be duplicates of what we do in block layer
> statistics, I wonder if there is any way to share that code?

The following two paragraphs are from Kai about that issue from an email a while ago:

"The tape driver does not have access to the block device i/o statistics because the tapes are not block devices but character devices. They use the Linux block subsystem enough to do i/o but this does not include access to the statistics counters.

... One alternative is, of course, to tie the st driver more into the Linux block device system. I have looked into this several times but have never seen how to do this in a simple enough way."

Some of the statistics I'm trying to implement aren't possible to determine just using the block layer statistics like keeping track of time spent doing other I/O such as tape movement since it's not a read or a write. The other thing is that disk stats measure I/O in sectors but tape drives are character devices. While most I/O to tape probably happens in a multiple of a sector size it doesn't have to and that means that some I/O would be over or under counted when rounded up or down to the sector size.

Thanks
Shane
