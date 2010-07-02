From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] scsi: add sd_unprep_fn to free discard page
Date: Fri, 2 Jul 2010 12:48:01 +0200
Message-ID: <20100702104801.GA26318@lst.de>
References: <1277981359-10717-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1277981359-10717-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1277981359-10717-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: axboe@kernel.dk, snitzer@redhat.com, hch@lst.de, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> sd_unprep() uses rq->buffer to free discard page allocated in
> sd_prepare_discard().

Eeek.  Accessing it using the bio in both haves seems a lot cleaner than
abusing this.  Especially as we don't really need a mapped page anyway
at least for WRITE SAME implementation.

> -	return scsi_setup_blk_pc_cmnd(sdp, rq);
> +	ret = scsi_setup_blk_pc_cmnd(sdp, rq);
> +	rq->buffer = page_address(page);
> +	return ret;

In addition I don't think this is quite correct.  You still need to undo
the payload addition manually if scsi_setup_blk_pc_cmnd fails, as we
haven't marked the request as REQ_DONTPREP at that point - it's only
done by scsi_prep_return for the BLKPREP_OK case.
