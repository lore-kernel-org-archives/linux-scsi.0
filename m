From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/27] target: use bio_is_full()
Date: Tue, 5 Apr 2016 06:02:23 -0700
Message-ID: <20160405130223.GC32576@infradead.org>
References: <1459857443-20611-1-git-send-email-tom.leiming@gmail.com>
 <1459857443-20611-10-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459857443-20611-10-git-send-email-tom.leiming@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 05, 2016 at 07:56:54PM +0800, Ming Lei wrote:
> +++ b/drivers/target/target_core_pscsi.c
> @@ -951,7 +951,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>  			pr_debug("PSCSI: bio->bi_vcnt: %d nr_vecs: %d\n",
>  				bio->bi_vcnt, nr_vecs);
>  
> -			if (bio->bi_vcnt > nr_vecs) {
> +			if (bio_is_full(bio)) {
>  				pr_debug("PSCSI: Reached bio->bi_vcnt max:"
>  					" %d i: %d bio: %p, allocating another"
>  					" bio\n", bio->bi_vcnt, i, bio);

This check should be removed entirely - bio_add_pc_page takes care of
it.
