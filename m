From: Christoph Hellwig <hch@infradead.org>
Subject: Re: compile warning fix for advansys (trivial)
Date: Sun, 28 Dec 2003 23:28:31 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031228232831.A23869@infradead.org>
References: <20031228200548.A22668@infradead.org> <Pine.LNX.4.44.0312290017120.554-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:16650 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262139AbTL1X2g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Dec 2003 18:28:36 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0312290017120.554-100000@poirot.grange>; from g.liakhovetski@gmx.de on Mon, Dec 29, 2003 at 12:26:39AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Mon, Dec 29, 2003 at 12:26:39AM +0100, Guennadi Liakhovetski wrote:
> > It's not that easy.  You need to move the request_region as early as
> > the check_region is currently and make sure you properly release the
> > I/O region again on an initialization failure later on.
> 
> Hm, my assumption was, that if the old version, doing
> 
> if (check_region())
> 	fail();
> 
> if (!request_region())
> 	fail();
> 
> was correct, it would mean, that if check_region succeeds, but due to the
> race, the following request_region() fails, the error-processing and
> bailing-out should work correct. So, we can just safely assume, that the
> check_region() does succeed, and let the actual request_region decide. So,
> I think, the patch would only be wrong if either the original driver
> behaviour was wrong in the race-case,

it was.  That's why we're changing it after all :)

