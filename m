From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/6] virtio-blk: implement init_flush_rq
Date: Sun, 7 Sep 2014 20:52:59 +0200
Message-ID: <20140907185259.GC23026@lst.de>
References: <1410079162-9872-1-git-send-email-ming.lei@canonical.com> <1410079162-9872-5-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1410079162-9872-5-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

A couple comments not directly related to this patch, it's just
a convenient vehicle for my rants :)

> @@ -556,6 +555,19 @@ static int virtblk_init_request(void *data, struct request *rq,
>  	struct virtio_blk *vblk = data;
>  	struct virtblk_req *vbr = blk_mq_rq_to_pdu(rq);
>  
> +	vbr->req = rq;

I really hate how we need these backpointers in most drivers.  Given
that struct request and the driver privata data are allocated together
we should be able to do this with simple pointer arithmetics.

> +	sg_init_table(vbr->sg, vblk->sg_elems);

Jens, what do you think about moving of the SG list handling to the
core block layer?  I'd really like to have the S/G list in struct request,
and if we do that we could also take the scsi-mq code that allows small
S/G lists preallocated in blk-mq and allocating larger ones at runtime
there, avoiding the need to duplicate that code and the whole mempool
magic it requires in drivers that want to make use of it.
