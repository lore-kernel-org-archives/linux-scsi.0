From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] [14/20] Don't disable direct_io for unchecked_isa_dma in st.c
Date: Fri, 14 Mar 2008 14:51:35 +0100
Message-ID: <20080314135135.GT17940@kernel.dk>
References: <20080307653.720459648@firstfloor.org> <20080307175414.08C981B41AE@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:18860 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbYCNNvi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Mar 2008 09:51:38 -0400
Content-Disposition: inline
In-Reply-To: <20080307175414.08C981B41AE@basil.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Fri, Mar 07 2008, Andi Kleen wrote:
> 
> Block layer bounces anyways.

Are you sure? Seems to me that st builds its own list with
get_user_pages() for direct io, where will that get bounced? The block
layer will only bounce things that are mapped directly, so if st used
blk_rq_map_kern() and inserted that request in the queue, we could
proceed with killing that check in st.

-- 
Jens Axboe

