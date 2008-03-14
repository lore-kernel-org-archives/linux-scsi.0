From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [14/20] Don't disable direct_io for unchecked_isa_dma
	in st.c
Date: Fri, 14 Mar 2008 10:24:12 -0400
Message-ID: <20080314142412.GA30325@infradead.org>
References: <20080307653.720459648@firstfloor.org> <20080307175414.08C981B41AE@basil.firstfloor.org> <20080314135135.GT17940@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39678 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbYCNOYV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Mar 2008 10:24:21 -0400
Content-Disposition: inline
In-Reply-To: <20080314135135.GT17940@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Fri, Mar 14, 2008 at 02:51:35PM +0100, Jens Axboe wrote:
> Are you sure? Seems to me that st builds its own list with
> get_user_pages() for direct io, where will that get bounced? The block
> layer will only bounce things that are mapped directly, so if st used
> blk_rq_map_kern() and inserted that request in the queue, we could
> proceed with killing that check in st.

Which shouldn't be all too difficult and would be the right thing to
do.  We really need someone to sit down and convert st/osst/sg to use
the proper block layer helpers.

