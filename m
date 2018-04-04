From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] Revert "scsi: core: return BLK_STS_OK for DID_OK in
 __scsi_error_from_host_byte()"
Date: Wed, 4 Apr 2018 13:03:55 -0400
Message-ID: <7cda8ed9-0c8d-8c25-0d8e-ba889acddacc@interlog.com>
References: <20180404163028.9826-1-bart.vanassche@wdc.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180404163028.9826-1-bart.vanassche@wdc.com>
Content-Language: en-CA
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Damien Le Moal <damien.lemoal@wdc.com>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-04-04 12:30 PM, Bart Van Assche wrote:
> The description of commit e39a97353e53 is wrong: it mentions that
> commit 2a842acab109 introduced a bug in __scsi_error_from_host_byte()
> although that commit did not change the behavior of that function.
> Additionally, that commit introduced a severe bug: it causes commands
> that fail with hostbyte=DID_OK and driverbyte=DRIVER_SENSE to be
> completed with BLK_STS_OK. Although that commit claims to fix a bug
> it does not mention which bug it fixes. Hence revert that commit.

That patch arose from the thread started by me titled:
    [PATCH v2] Make SCSI Status CONDITION MET equivalent to GOOD
on 26 February this year. Hannes Reinecke made the case for
reducing the helper scsi_io_completion_nz_result() to a single
returned value (an idea that was applied and later reverted).
He wrote:

 > Hmm. Can't we return blk_stat from this function, and adjusting the
 > 'result' value after it with an if-clause like
 >
 > if (blk_stat == BLK_STS_OK)
 >	result = 0;
 >
 > That would cleanup up the function and avoid having (essentially) two
 > return values.
 >
 > The only problem here is that __scsi_error_from_hostbyte() will return
 > BLK_STS_IOERR if result == 0; doubt that is intended.
 > And I guess it'll affect this issue, too.
 >
 > Mind sending a separate patch for that?

Actually Hannes had already sent a patch for that before I had time to
react (on the same day). That is the patch you now plan to revert.


In Hannes' defence (and I reviewed it) it is counter intuitive that for
callers to work properly, this function supplied with DID_OK in the
result argument should return BLK_STS_IOERR.

Please find out why that is so and craft a comment so nobody else falls
down this particular rabbit hole. Plus add 'case DID_OK:' before the
'default:' to emphasis the point.

Doug Gilbert

> Fixes: e39a97353e53 ("scsi: core: return BLK_STS_OK for DID_OK in __scsi_error_from_host_byte()")
> Reported-by: Damien Le Moal <damien.lemoal@wdc.com>
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: Damien Le Moal <damien.lemoal@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: stable@vger.kernel.org
> ---
>   drivers/scsi/scsi_lib.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 74a39db57d49..71f5b010684c 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -735,8 +735,6 @@ static blk_status_t __scsi_error_from_host_byte(struct scsi_cmnd *cmd,
>   		int result)
>   {
>   	switch (host_byte(result)) {
> -	case DID_OK:
> -		return BLK_STS_OK;
>   	case DID_TRANSPORT_FAILFAST:
>   		return BLK_STS_TRANSPORT;
>   	case DID_TARGET_FAILURE:
> 
