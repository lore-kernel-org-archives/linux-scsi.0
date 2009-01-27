From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] bfa: Brocade BFA FC SCSI driver submission
Date: Tue, 27 Jan 2009 17:16:18 -0500
Message-ID: <20090127221618.GA26480@infradead.org>
References: <200901271854.n0RIs73a026759@swe37.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50576 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbZA0WQW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jan 2009 17:16:22 -0500
Content-Disposition: inline
In-Reply-To: <200901271854.n0RIs73a026759@swe37.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: James.Bottomley@HansenPartnership.com, kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

On Tue, Jan 27, 2009 at 10:54:07AM -0800, Jing Huang wrote:
> +/**
> + * Generic HAL callback element.
> + */
> +struct bfa_cb_qe_s {
> +	struct bfa_q_s         qe;
> +	bfa_cb_cbfn_t  cbfn;
> +	bfa_boolean_t   once;
> +	u32		rsvd;
> +	void           *cbarg;
> +};
> +
> +#define bfa_cb_queue(__bfa, __hcb_qe, __cbfn, __cbarg) do {		\
> +	(__hcb_qe)->cbfn  = (__cbfn);					\
> +	(__hcb_qe)->cbarg = (__cbarg);					\
> +	bfa_q_enq(&(__bfa)->comp_q, (__hcb_qe));			\
> +} while (0)

Please stop here, weird HALs and own list management routines are not
things we put into the tree.  (except for gregs junk subdirectory..)

Please rewrite this into a proper Linux driver.

