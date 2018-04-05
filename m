From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] Fix DID_OK handling in __scsi_error_from_host_byte()
Date: Thu, 5 Apr 2018 08:43:18 +0200
Message-ID: <20180405084318.380ab452@pentland.suse.de>
References: <20180404175355.15982-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180404175355.15982-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Wed,  4 Apr 2018 10:53:55 -0700
"Bart Van Assche" <bart.vanassche@wdc.com> wrote:

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
> Fixes: e39a97353e53 ("scsi: core: return BLK_STS_OK for DID_OK in
> __scsi_error_from_host_byte()") Reported-by: Damien Le Moal
> <damien.lemoal@wdc.com> Signed-off-by: Bart Van Assche
> <bart.vanassche@wdc.com> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: Damien Le Moal <damien.lemoal@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: stable@vger.kernel.org
> ---
> 
> Changes compared to v1:
> - Modified __scsi_error_from_host_byte() such that it again returns
>   BLK_STS_OK for CONDITION MET and other result codes that represent
>   success.
> 
>  drivers/scsi/scsi_lib.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 74a39db57d49..1496b34af409 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -736,7 +736,13 @@ static blk_status_t
> __scsi_error_from_host_byte(struct scsi_cmnd *cmd, {
>  	switch (host_byte(result)) {
>  	case DID_OK:
> -		return BLK_STS_OK;
> +		/*
> +		 * Also check the other bytes than the status byte
> in result
> +		 * to handle the case when a SCSI LLD sets result to
> +		 * DRIVER_SENSE << 24 without setting
> SAM_STAT_CHECK_CONDITION.
> +		 */
> +		return scsi_status_is_good(result) && (result &
> ~0xff) == 0 ?
> +			BLK_STS_OK : BLK_STS_IOERR;
>  	case DID_TRANSPORT_FAILFAST:
>  		return BLK_STS_TRANSPORT;
>  	case DID_TARGET_FAILURE:

And a further nit-pick: the function is called
__scsi_error_from_host_byte(), so it's only logical that it would only
check the host_byte().
What's wrong is the _usage_ here; after calling
__scsi_error_from_host_byte() we need to check if the _other_ bits of
the results are non-zero to end up with a valid result.

Hence I would advocate to either rename this function
(__scsi_error_from_result() ?) or evaluate the remaining bits outside
this function.

But I would advocate for the former; otherwise the same issue will crop
up again in the future.

Cheers,

Hannes
