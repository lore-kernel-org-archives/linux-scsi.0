From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2] Fix DID_OK handling in __scsi_error_from_host_byte()
Date: Wed, 4 Apr 2018 14:35:33 -0400
Message-ID: <36251e0f-2dd0-539b-9a72-e3ba330133e2@interlog.com>
References: <20180404175355.15982-1-bart.vanassche@wdc.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180404175355.15982-1-bart.vanassche@wdc.com>
Content-Language: en-CA
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Damien Le Moal <damien.lemoal@wdc.com>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-04-04 01:53 PM, Bart Van Assche wrote:
> Commit e39a97353e53 modified __scsi_error_from_host_byte() such
> that that function translates DID_OK into BLK_STS_OK. However,
> the description of that commit is wrong: it mentions that commit
> 2a842acab109 introduced a bug in __scsi_error_from_host_byte()
> although that commit did not change the behavior of that function.
> Additionally, commit e39a97353e53 introduced a severe bug: it causes
> commands that fail with hostbyte=DID_OK and driverbyte=DRIVER_SENSE
> to be completed with BLK_STS_OK. Fix __scsi_error_from_host_byte()
> by only translating good status values into BLK_STS_OK.
> 
> Fixes: e39a97353e53 ("scsi: core: return BLK_STS_OK for DID_OK in __scsi_error_from_host_byte()")
> Reported-by: Damien Le Moal <damien.lemoal@wdc.com>
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>

Reviewed-by: Douglas Gilbert <dgilbert@interlog.com>

> Cc: Damien Le Moal <damien.lemoal@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: stable@vger.kernel.org
> ---

There is some urgency here as the faulty patch is in lk 4.16.0
release.

My patch was prepared independently of seeing this one. Both
do the job (mine has a redundant status_byte(result) in the
conditional). And the function name is now completely misleading
but due to the urgency, that can wait for another day.

> Changes compared to v1:
> - Modified __scsi_error_from_host_byte() such that it again returns
>    BLK_STS_OK for CONDITION MET and other result codes that represent
>    success.
> 
>   drivers/scsi/scsi_lib.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 74a39db57d49..1496b34af409 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -736,7 +736,13 @@ static blk_status_t __scsi_error_from_host_byte(struct scsi_cmnd *cmd,
>   {
>   	switch (host_byte(result)) {
>   	case DID_OK:
> -		return BLK_STS_OK;
> +		/*
> +		 * Also check the other bytes than the status byte in result
> +		 * to handle the case when a SCSI LLD sets result to
> +		 * DRIVER_SENSE << 24 without setting SAM_STAT_CHECK_CONDITION.
> +		 */
> +		return scsi_status_is_good(result) && (result & ~0xff) == 0 ?
> +			BLK_STS_OK : BLK_STS_IOERR;
>   	case DID_TRANSPORT_FAILFAST:
>   		return BLK_STS_TRANSPORT;
>   	case DID_TARGET_FAILURE:
> 
