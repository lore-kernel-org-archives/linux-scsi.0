From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 03/11] scsi: sd_zbc: Fix
	sd_zbc_check_zones() error checks
Date: Tue, 16 Oct 2018 00:51:47 -0400
Message-ID: <yq1zhvetrx8.fsf@oracle.com>
References: <20181012100850.23316-1-damien.lemoal@wdc.com>
	<20181012100850.23316-4-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181012100850.23316-4-damien.lemoal@wdc.com> (Damien Le Moal's
	message of "Fri, 12 Oct 2018 19:08:42 +0900")
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


Damien,

> The unsigned 32 bits overflow check for the zone size value is already
> done within sd_zbc_check_zones() with the test:
>
> } else if (logical_to_sectors(sdkp->device, zone_blocks) > UINT_MAX) {
>
> so there is no need to check again for an out of range value in
> sd_zbc_read_zones(). Simplify the code and fix sd_zbc_check_zones()
> error return to -EFBIG instead of -ENODEV if the zone size is too large.
> Change the return type of sd_zbc_check_zones() to an int for the error
> code and return the zone size (zone_blocks) through a u32 pointer to
> avoid overflowing the signed 32 return value.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
