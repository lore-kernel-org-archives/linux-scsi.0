From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 03/11] scsi: sd_zbc: Fix
 sd_zbc_check_zones() error checks
Date: Wed, 17 Oct 2018 09:21:59 +0200
Message-ID: <20181017072159.GE23407@lst.de>
References: <20181012100850.23316-1-damien.lemoal@wdc.com>
	<20181012100850.23316-4-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181012100850.23316-4-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

> @@ -687,12 +688,8 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
>  	 * Check zone size: only devices with a constant zone size (except
>  	 * an eventual last runt zone) that is a power of 2 are supported.
>  	 */
> -	zone_blocks = sd_zbc_check_zones(sdkp);
> -	ret = -EFBIG;
> -	if (zone_blocks != (u32)zone_blocks)
> -		goto err;
> -	ret = zone_blocks;
> -	if (ret < 0)
> +	ret = sd_zbc_check_zones(sdkp, &zone_blocks);
> +	if (ret != 0)

This coud be simplified to

	if (ret)

or just keep the old

	if (ret < 0)

which would still work.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
