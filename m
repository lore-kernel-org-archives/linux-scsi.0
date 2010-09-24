From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] block: set the bounce_pfn to the actual DMA
 limit rather than to max memory
Date: Fri, 24 Sep 2010 20:28:53 +0200
Message-ID: <4C9CEDE5.902@fusionio.com>
References: <c9516154fabc03112353.1285107750@malahal>
	<4C9CAE68.4060706@fusionio.com> <20100924170532.GA29071@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100924170532.GA29071@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Malahal Naineni <malahal@us.ibm.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2010-09-24 19:05, Malahal Naineni wrote:
> Jens Axboe [jaxboe@fusionio.com] wrote:
>> On 2010-09-22 00:22, Malahal Naineni wrote:
>>> The bounce_pfn of the request queue in 64 bit systems is set to the
>>> current max_low_pfn. Adding more memory later makes this incorrect.
>>
>> Clearly correct.
>>
>>> Memory allocated beyond this boot time max_low_pfn appear to require
>>> bounce buffers (bounce buffers are actually not allocated but used in
>>> calculating segments that may result in "over max segments limit"
>>> errors).
>>
>> But I can't quite convince myself that the change is fully correct. You
>> don't really explain in your own words what the patch does, just what it
>> fixes.
> 
> OK, the problem is we get "over max segments limit" errors from
> blk_rq_check_limits() after adding memory. The actual bug is in
> blk_phys_contig_segment() where it doesn't check for possibility of
> bounce buffers. This results in merging more requests in
> ll_merge_requests_fn(). Later, blk_recalc_rq_segments() call from
> blk_rq_check_limits() actually uses the possibility of bounce buffers,
> so the calculated number of segments exceed q's max_segments resulting
> in the above error.
> 
> Fix for the actual problem is posted here:
> http://permalink.gmane.org/gmane.linux.kernel.device-mapper.devel/12426
> 
> So clearly the bug should manifest only when 'bounce buffers' are
> involved!  Applying the above patch indeed_fixed_ the problem, but I
> know there shouldn't be any need for bounce buffers on our system, and
> further investigation revealed that DMA limit is not set correctly.
> 
> This patch also _fixed_ our problem. So we are fine with either patch,
> but this patch is preferred as it enables more request merges. Also,
> both patches maybe needed for some configurations.

Plus it doesn't needlessly bounce, that's the real problem you want to
fix. I have applied this thread patch to for-2.6.37/core, thanks.

-- 
Jens Axboe
