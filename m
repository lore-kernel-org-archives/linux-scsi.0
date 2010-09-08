From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 42/41] dm: convey that all flushes are processed as empty
Date: Wed, 8 Sep 2010 02:00:01 +0200
Message-ID: <20100908000001.GA21552@lst.de>
References: <1283509796-1510-1-git-send-email-tj@kernel.org> <1283509796-1510-24-git-send-email-tj@kernel.org> <4C84CD18.6060906@redhat.com> <20100907211724.GA22525@redhat.com> <20100907221543.GB22525@redhat.com> <20100907234918.GA23921@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100907234918.GA23921@redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, jack@suse.cz, mst@redhat.com, linux-ide@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, hch@lst.de, k-ueda@ct.jp.nec.com, vst@vlnb.net, linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, linux-raid@vger.kernel.org, mpatocka@redhat.com, swhiteho@redhat.com, chris.mason@oracle.com, tytso@mit.edu, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, rwheeler@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 07, 2010 at 07:49:18PM -0400, Mike Snitzer wrote:
>  		if (!(bio->bi_rw & REQ_FLUSH) || !bio->bi_size) {
> +			/* done with normal IO or empty flush */
>  			trace_block_bio_complete(md->queue, bio);
>  			bio_endio(bio, io_error);
>  		} else {

To clarify this further I'd reorder the checks:

		if ((bio->bi_rw & REQ_FLUSH) && bio->bi_size) {
			/*
			 * Preflush done, ...
			 */
		} else {
		}

> @@ -1302,20 +1302,17 @@ static void __split_and_process_bio(struct mapped_device *md, struct bio *bio)
>  	ci.sector = bio->bi_sector;
>  	ci.idx = bio->bi_idx;
>  
> +	start_io_acct(ci.io);
>  	if (!is_flush) {

no need for the is_flush anymore now that it's only used once.  Again,
I think avoiding negatives without a reason in if statement usually
makes the code a bit more clear.

