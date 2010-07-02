From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: address leak in the error path of discard page allocation
Date: Fri, 2 Jul 2010 12:48:24 +0200
Message-ID: <20100702104824.GB26318@lst.de>
References: <1277981359-10717-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1277981359-10717-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20100701130328.GB19605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100701130328.GB19605@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, axboe@kernel.dk, hch@lst.de, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 01, 2010 at 09:03:28AM -0400, Mike Snitzer wrote:
> On Thu, Jul 01 2010 at  6:49am -0400,
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > This fixes discard page leak by using q->unprep_rq_fn facility.
> > 
> > q->unprep_rq_fn is called when all the data buffer (req->bio and
> > scsi_data_buffer) in the request is freed.
> > 
> > sd_unprep() uses rq->buffer to free discard page allocated in
> > sd_prepare_discard().
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Thanks for sorting this out Tomo, all 3 patches work great!
> 
> BTW, there is one remaining (rare) leak in the allocation path.
> 
> The following patch serves to fix it but I'm not sure if there is a more
> elegant way to address this.
> 
> An alternative would be to check if the page is already allocated
> (before allocating the page in scsi_setup_discard_cmnd)?

Ah, should have read your mail first, sorry..
