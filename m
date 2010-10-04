From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: I/O topology fixes for big physical block size
Date: Mon, 04 Oct 2010 15:49:11 -0400
Message-ID: <yq1sk0l3fig.fsf@sermon.lab.mkp.net>
References: <4CA17B13.7080801@redhat.com> <20100928141545.GA21587@redhat.com>
	<20100928205741.GA22257@thunk.org>
	<yq162xpa7dj.fsf@sermon.lab.mkp.net> <4CA25FEA.6040505@redhat.com>
	<20100930163047.GA4098@thunk.org> <4CA4C3B6.9000104@redhat.com>
	<20100930173342.GB31945@redhat.com> <20101001142441.GF21129@thunk.org>
	<yq1y6ah4kuu.fsf@sermon.lab.mkp.net>
	<20101002023113.GJ21129@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:63595 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab0JDTvB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2010 15:51:01 -0400
In-Reply-To: <20101002023113.GJ21129@thunk.org> (Ted Ts'o's message of "Fri, 1
	Oct 2010 22:31:13 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Jens Axboe <jaxboe@fusionio.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

>>>>> "Ted" == Ted Ts'o <tytso@mit.edu> writes:

Ted,

Ted> OK, but what do we do when we start seeing devices with 8k or 16k
Ted> physical block sizes?  The VM doesn't deal well with block sizes >
Ted> page size.

I don't think we're going to see devices reporting logical blocks bigger
than 4KiB anytime soon.  Too much pain for everybody in the industry
(most other operating systems can't even deal with 4KiB logical blocks
yet).  Eventually we will have to do the required page cache surgery to
support filesystem block sizes bigger than the page size.  But I don't
think that's something we'll have to deal with in the immediate future.

In the meantime, however, the question is whether there is something we
can do in the allocators to mitigate effects of devices reporting
physical blocks bigger than PAGE_CACHE_SIZE.  Obviously this would be in
the I/O hint/alignment category and not something which would guarantee
that all writes would be aligned multiples of that physical block size.

-- 
Martin K. Petersen	Oracle Linux Engineering
