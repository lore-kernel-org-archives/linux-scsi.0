From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large
 IO sg-chaining
Date: Wed, 25 Jul 2007 11:26:44 +0300
Message-ID: <46A70944.6030005@panasas.com>
References: <20070724181635G.fujita.tomonori@lab.ntt.co.jp>	 <46A5CDFE.3020801@panasas.com>	 <20070724201247A.fujita.tomonori@lab.ntt.co.jp>	 <20070724110138P.tomof@acm.org>  <46A60633.2020904@panasas.com> <1185293406.3488.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:29092 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752771AbXGYI1F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2007 04:27:05 -0400
In-Reply-To: <1185293406.3488.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: FUJITA Tomonori <tomof@acm.org>, fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Tue, 2007-07-24 at 17:01 +0300, Benny Halevy wrote:
>> FUJITA Tomonori wrote:
>>> I should have said that, was the approach to use separate buffer for
>>> sglists instead of putting the sglists and the parameters in one
>>> buffer completely rejected?
>> I think that James should be asked this question.
>> My understanding was that he preferred allocating the sgtable
>> header along with the scatterlist array.
> 
> All I really cared about was insulating the drivers from future changes
> in this area.  It strikes me that for chained sglist implementations,
> this can all become a block layer responsibility, since more than SCSI
> will want to make use of it.

agreed.

> 
> Just remember, though that whatever is picked has to work in both memory
> constrained embedded systems as well as high end clusters.  It seems to
> me (but this isn't a mandate) that a single tunable sg element chunk
> size will accomplish this the best (as in get rid of the entire SCSI
> sglist sizing machinery) .

maybe :)
I'm not as familiar as you are with all the different uses of linux.
IMO, having a tunable is worse for the administrator and I'd prefer
an automatic mechanism that will dynamically adapt the allocation
size(s) to the actual use, very much like the one you have today.

> 
> However, I'm perfectly happy to go with whatever the empirical evidence
> says is best .. and hopefully, now we don't have to pick this once and
> for all time ... we can alter it if whatever is chosen proves to be
> suboptimal.

I agree.  This isn't a catholic marriage :)
We'll run some performance experiments comparing the sgtable chaining
implementation vs. a scsi_data_buff implementation pointing
at a possibly chained sglist and let's see if we can measure
any difference.  We'll send results as soon as we have them.

> 
>> There are pro's and con's either way.  In my opinion separating
>> the headers is better for mapping buffers that have a power of 2
>> #pages (which seems to be the typical case) since when you're
>> losing one entry in the sgtable for the header you'd waste a lot
>> more when you just cross the bucket boundary. E.g. for 64 pages
>> you need to allocate from the "64 to 127" bucket rather than the
>> "33 to 64" bucket).  Separated, one sgtable header structure
>> can just be embedded in struct scsi_cmnd for uni-directional transfers
>> (wasting some space when transferring no data, but saving space and
>> cycles in the common case vs. allocating it from a separate memory pool)
>> and the one for bidi read buffers can be allocated separately just for
>> bidi commands.
> 
> This is all opinion ... could someone actually run some performance
> tests?
> 
> James
> 
> 

