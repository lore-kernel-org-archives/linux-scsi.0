From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patchset 0/4] osd: Stop usage of blk_rq_append_bio
Date: Tue, 12 May 2009 13:25:40 +0200
Message-ID: <20090512112539.GH4140@kernel.dk>
References: <4A0307F4.50205@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:60377 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbZELLZj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2009 07:25:39 -0400
Content-Disposition: inline
In-Reply-To: <4A0307F4.50205@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On Thu, May 07 2009, Boaz Harrosh wrote:
> 
> Osd library needs to submit pre-allocated bios, form several sources.
> osdblk exofs and pNFS-layout driver all have prepared bios for IO submission.
> On top of that the osd library needs to append additional segments to the
> IO memory, for get/set attributes and more.
> 
> All these are done today by use of a temporary hack - blk_rq_append_bio.
> This is bad on few accounts.
> 1. blk_rq_append_bio was not meant to be exported and is very specific to its users.
> 2. blk_rq_append_bio does not support chained bios.
> 3. blk_rq_append_bio does not bounce the bio and therefore current osd implementation
>    has a bug.
> 
> The proposed solution adds two new fixtures to the block layer, and a corresponding
> fixing patch to osd. These are:
> 
> [PATCH 1/4] allow blk_rq_map_kern to append to requests
> [PATCH 2/4] libosd: Use new blk_rq_map_kern
> 
>   This is originally a James patch and it's used, to let blk_rq_map_kern append it's buffer
>   to existing bio, and there for is able to be called multiple times in a loop, to append
>   multiple segments. This API can also be useful for scsi/block targets that have segment
>   information in some other memory structure (like scatterlist) and wants to set it into
>   a request. Until such time that they have a proper support for mapping scatterlists directly.
>   (Since above called on long lists might not be good for performance)
> 
>   Here in osd it makes tons of sense, and should be considered for inclusion.
>   (The patches are based on linus-tip but should patch on block tree)
> 
> [RFC 3/4] New blk_make_request(), takes bio, returns a request
> [RFC 4/4] libosd: Use of new blk_make_request
>   
>   Here I propose a new block API, that will support proper delegation of a bio
>   to a full request. Please read inside the patch descriptions for details.
>   After this patch both osd and block layer will have the proper support for osdblk
>   driver as well as future needs.
>   These patches also eliminate the last use of blk_rq_append_bio which can be now un-exported.
> 
>   These two patches conflic with Tejun's branch and are based on linus-tip. Upon positive review
>   I will serialize them with Tejun and submit them properly. But first they must be agreed upon.
>   Jens, I specially need your opinion on this?

Looks sane to me. Can you resubmit against 'for-2.6.31' of the block git
repo?

-- 
Jens Axboe

