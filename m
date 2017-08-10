From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 5/6] bsg: reduce unnecessary arguments for
        bsg_map_hdr()
Date: Thu, 10 Aug 2017 11:35:31 +0200
Message-ID: <20170810093531.GP24539@lst.de>
References: <cover.1502120928.git.bblock@linux.vnet.ibm.com> <6d4d39222a4b76f9b39ec52e0aca5b01a3fac9e1.1502120928.git.bblock@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6d4d39222a4b76f9b39ec52e0aca5b01a3fac9e1.1502120928.git.bblock@linux.vnet.ibm.com>
Sender: linux-block-owner@vger.kernel.org
To: Benjamin Block <bblock@linux.vnet.ibm.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, Steffen Maier <maier@linux.vnet.ibm.com>, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 09, 2017 at 04:11:19PM +0200, Benjamin Block wrote:
> Since struct bsg_command is now used in every calling case, we don't
> need separation of arguments anymore that are contained in the same
> bsg_command.
> 
> Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
> ---
>  block/bsg.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/block/bsg.c b/block/bsg.c
> index 8517361a9b3f..6ee2ffca808a 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -212,11 +212,12 @@ bsg_validate_sgv4_hdr(struct sg_io_v4 *hdr, int *op)
>   * map sg_io_v4 to a request.
>   */
>  static struct request *
> -bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
> -	    u8 *reply_buffer)
> +bsg_map_hdr(struct bsg_device *bd, struct bsg_command *bc,
> +	    fmode_t has_write_perm)

I wish we could just rename the argument to mode and pass on the
whole file->f_mode while you are cleaning up this code.  That should
be a separate patch, though.

Reviewed-by: Christoph Hellwig <hch@lst.de>
