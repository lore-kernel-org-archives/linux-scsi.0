From: Brian King <brking@linux.ibm.com>
Subject: Re: [PATCH] aacraid: Correct hba_send to include iu_type
Date: Wed, 25 Apr 2018 14:37:15 -0600
Message-ID: <e43c7c2c-5dc5-0b2a-5cc1-5d00588d1cf0@linux.ibm.com>
References: <20180425162420.612-1-david.carroll@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180425162420.612-1-david.carroll@microsemi.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Dave Carroll <david.carroll@microsemi.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Noah Misner <nmisner@us.ibm.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, aacraid@microsemi.com, Scott Benesh <scott.benesh@microsemi.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/25/2018 10:24 AM, Dave Carroll wrote:
> commit b60710ec7d7ab ("aacraid: enable sending of TMFs from aac_hba_send()")
> 
> allows aac_hba_send() to send scsi commands, and TMF requests, but the existing
> code only updates the iu_type for scsi commands. For TMF requests we are sending
> an unknown iu_type to firmware, which causes a fault.
> 
> Include iu_type prior to determining the validity of the command
> 
> Reported-by: Noah Misner <nmisner@us.ibm.com>
> Fixes: b60710ec7d7ab ("aacraid: enable sending of TMFs from aac_hba_send()")
> Fixes: 423400e64d377 ("aacraid: Include HBA direct interface")
> Tested-by: Noah Misner <nmisner@us.ibm.com>
> cc: stable@vger.kernel.org
> Signed-off-by: Dave Carroll <david.carroll@microsemi.com>
> Reviewed-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> ---
>  drivers/scsi/aacraid/commsup.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
> index 0156c96..d62ddd6 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -724,6 +724,8 @@ int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
>  	int wait;
>  	unsigned long flags = 0;
>  	unsigned long mflags = 0;
> +	struct aac_hba_cmd_req *hbacmd = (struct aac_hba_cmd_req *)
> +			fibptr->hw_fib_va;
> 
>  	fibptr->flags = (FIB_CONTEXT_FLAG | FIB_CONTEXT_FLAG_NATIVE_HBA);
>  	if (callback) {
> @@ -734,11 +736,9 @@ int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
>  		wait = 1;
> 
> 
> -	if (command == HBA_IU_TYPE_SCSI_CMD_REQ) {
> -		struct aac_hba_cmd_req *hbacmd =
> -			(struct aac_hba_cmd_req *)fibptr->hw_fib_va;
> +	hbacmd->iu_type = command;
> 
> -		hbacmd->iu_type = command;
> +	if (command == HBA_IU_TYPE_SCSI_CMD_REQ) {
>  		/* bit1 of request_id must be 0 */
>  		hbacmd->request_id =
>  			cpu_to_le32((((u32)(fibptr - dev->fibs)) << 2) + 1);
> 

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
