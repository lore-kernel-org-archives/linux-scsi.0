From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] sd_zbc: Force use of READ16/WRITE16
Date: Mon, 14 Nov 2016 13:17:02 -0700
Message-ID: <e85daf9e-30d5-f069-26ce-57f9c21ed29d@kernel.dk>
References: <1478843606-15647-1-git-send-email-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1478843606-15647-1-git-send-email-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>
List-Id: linux-scsi@vger.kernel.org

On 11/10/2016 10:53 PM, Damien Le Moal wrote:
> Normally, sd_read_capacity sets sdp->use_16_for_rw to 1 based on the
> disk capacity so that READ16/WRITE16 are used for large drives.
> However, for a zoned disk with RC_BASIS set to 0, the capacity reported
> through READ_CAPACITY may be very small, leading to use_16_for_rw not being
> set and READ10/WRITE10 commands being used, even after the actual zoned disk
> capacity is corrected in sd_zbc_read_zones. This causes LBA offset overflow for
> accesses beyond 2TB.
>
> As the ZBC standard makes it mandatory for ZBC drives to support
> the READ16/WRITE16 commands anyway, make sure that use_16_for_rw is set.

Added to the 4.10 branch, thanks.

-- 
Jens Axboe

