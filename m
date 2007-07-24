From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large
	IO sg-chaining
Date: Tue, 24 Jul 2007 12:10:06 -0400
Message-ID: <1185293406.3488.5.camel@localhost.localdomain>
References: <20070724181635G.fujita.tomonori@lab.ntt.co.jp>
	 <46A5CDFE.3020801@panasas.com>
	 <20070724201247A.fujita.tomonori@lab.ntt.co.jp>
	 <20070724110138P.tomof@acm.org>  <46A60633.2020904@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:40008 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750858AbXGXQpk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 12:45:40 -0400
In-Reply-To: <46A60633.2020904@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>
Cc: FUJITA Tomonori <tomof@acm.org>, fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

On Tue, 2007-07-24 at 17:01 +0300, Benny Halevy wrote:
> FUJITA Tomonori wrote:
> > I should have said that, was the approach to use separate buffer for
> > sglists instead of putting the sglists and the parameters in one
> > buffer completely rejected?
> 
> I think that James should be asked this question.
> My understanding was that he preferred allocating the sgtable
> header along with the scatterlist array.

All I really cared about was insulating the drivers from future changes
in this area.  It strikes me that for chained sglist implementations,
this can all become a block layer responsibility, since more than SCSI
will want to make use of it.

Just remember, though that whatever is picked has to work in both memory
constrained embedded systems as well as high end clusters.  It seems to
me (but this isn't a mandate) that a single tunable sg element chunk
size will accomplish this the best (as in get rid of the entire SCSI
sglist sizing machinery) .

However, I'm perfectly happy to go with whatever the empirical evidence
says is best .. and hopefully, now we don't have to pick this once and
for all time ... we can alter it if whatever is chosen proves to be
suboptimal.

> There are pro's and con's either way.  In my opinion separating
> the headers is better for mapping buffers that have a power of 2
> #pages (which seems to be the typical case) since when you're
> losing one entry in the sgtable for the header you'd waste a lot
> more when you just cross the bucket boundary. E.g. for 64 pages
> you need to allocate from the "64 to 127" bucket rather than the
> "33 to 64" bucket).  Separated, one sgtable header structure
> can just be embedded in struct scsi_cmnd for uni-directional transfers
> (wasting some space when transferring no data, but saving space and
> cycles in the common case vs. allocating it from a separate memory pool)
> and the one for bidi read buffers can be allocated separately just for
> bidi commands.

This is all opinion ... could someone actually run some performance
tests?

James


