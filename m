From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCHv2] scsi: Fix failed request error code
Date: Wed, 4 Apr 2018 11:44:38 -0400
Message-ID: <f4e05a27-7f17-6dea-f1e5-748441f9d16b@interlog.com>
References: <20180404072734.21718-1-hare@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180404072734.21718-1-hare@suse.de>
Content-Language: en-CA
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Hannes Reinecke <hare@suse.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-04-04 03:27 AM, Hannes Reinecke wrote:
> With the introduction of commit e39a97353e53 ("scsi: core: return
> BLK_STS_OK for DID_OK in __scsi_error_from_host_byte()"), a command that
> failed with hostbyte=DID_OK and driverbyte=DRIVER_SENSE but lacking
> additional sense information will have a return code set to BLK_STS_OK.
> This results in the request issuer to see successful request execution
> despite the failure. An example of such case is an unaligned write on a
> host managed ZAC disk connected to a SAS HBA with a malfunctioning SAT.
> The unaligned write command gets aborted but has no additional sense
> information.
> 
> sd 10:0:0:0: [sde] tag#3905 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> sd 10:0:0:0: [sde] tag#3905 Sense Key : Aborted Command [current]
> sd 10:0:0:0: [sde] tag#3905 Add. Sense: No additional sense information
> sd 10:0:0:0: [sde] tag#3905 CDB: Write(16) 8a 00 00 00 00 00 02 0c 00 01 00 00 00 01 00 00
> print_req_error: I/O error, dev sde, sector 274726920
> 
> In scsi_io_completion(), sense key handling to not change the request
> error code and success being reported to the issuer.
> 
> Fix this by making sure that the error code always indicates an error
> if scsi_io_completion() decide that the action to be taken for a failed
> command is to not retry it and terminate it immediately (ACTION_FAIL) .
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Fixes: e39a97353e53 ("scsi: core: return BLK_STS_OK for DID_OK in __scsi_error_from_host_byte()")
> Cc: <stable@vger.kernel.org>
> ---
>   drivers/scsi/scsi_lib.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 393f9db8f41b..9389c41e2829 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -905,6 +905,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>   		goto requeue;
>   
>   	error = __scsi_error_from_host_byte(cmd, result);
> +	/*
> +	 * If the hostbyte was DID_OK, but the sense code is valid
> +	 * we always should set BLK_STS_IOERR.
> +	 */
> +	if (error == BLK_STS_OK && sense_valid)

&& !sense_deferred

Doug Gilbert

> +		error = BLK_STS_IOERR;
>   
>   	if (host_byte(result) == DID_RESET) {
>   		/* Third party bus reset or reset for error recovery
> 
