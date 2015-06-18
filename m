From: Don Brace <Don.Brace@pmcs.com>
Subject: RE: [patch] hpsa: fix an sprintf() overflow in the reset handler
Date: Thu, 18 Jun 2015 13:35:45 +0000
Message-ID: <07F70BBF6832E34FA1C923241E8833AB486B305D@BBYEXM01.pmc-sierra.internal>
References: <20150604144756.GA8897@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20150604144756.GA8897@mwanda>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "iss_storagedev@hp.com" <iss_storagedev@hp.com>, dl Team ESD Storage Dev Support <storagedev@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Thursday, June 04, 2015 9:48 AM
> To: Don Brace
> Cc: James E.J. Bottomley; iss_storagedev@hp.com; dl Team ESD Storage Dev
> Support; linux-scsi@vger.kernel.org; kernel-janitors@vger.kernel.org
> Subject: [patch] hpsa: fix an sprintf() overflow in the reset handler
> 
> The string "cmd %d RESET FAILED, new lockup detected" is not quite
> large enough so the sprintf() will overflow.  I have increased the size
> of the buffer and also changed the sprintf calls to snprintf.
> 
> Fixes: 73153fe533bc ('hpsa: use block layer tag for command allocation')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 1dafeb4..cab4e98 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -5104,7 +5104,7 @@ static int hpsa_eh_device_reset_handler(struct
> scsi_cmnd *scsicmd)
>  	int rc;
>  	struct ctlr_info *h;
>  	struct hpsa_scsi_dev_t *dev;
> -	char msg[40];
> +	char msg[48];
> 
>  	/* find the controller to which the command to be aborted was sent */
>  	h = sdev_to_hba(scsicmd->device);
> @@ -5122,16 +5122,18 @@ static int hpsa_eh_device_reset_handler(struct
> scsi_cmnd *scsicmd)
> 
>  	/* if controller locked up, we can guarantee command won't complete
> */
>  	if (lockup_detected(h)) {
> -		sprintf(msg, "cmd %d RESET FAILED, lockup detected",
> -				hpsa_get_cmd_index(scsicmd));
> +		snprintf(msg, sizeof(msg),
> +			 "cmd %d RESET FAILED, lockup detected",
> +			 hpsa_get_cmd_index(scsicmd));
>  		hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
>  		return FAILED;
>  	}
> 
>  	/* this reset request might be the result of a lockup; check */
>  	if (detect_controller_lockup(h)) {
> -		sprintf(msg, "cmd %d RESET FAILED, new lockup detected",
> -				hpsa_get_cmd_index(scsicmd));
> +		snprintf(msg, sizeof(msg),
> +			 "cmd %d RESET FAILED, new lockup detected",
> +			 hpsa_get_cmd_index(scsicmd));
>  		hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
>  		return FAILED;
>  	}
> @@ -5145,7 +5147,8 @@ static int hpsa_eh_device_reset_handler(struct
> scsi_cmnd *scsicmd)
>  	/* send a reset to the SCSI LUN which the command was sent to */
>  	rc = hpsa_do_reset(h, dev, dev->scsi3addr, HPSA_RESET_TYPE_LUN,
>  			   DEFAULT_REPLY_QUEUE);
> -	sprintf(msg, "reset %s", rc == 0 ? "completed successfully" : "failed");
> +	snprintf(msg, sizeof(msg), "reset %s",
> +		 rc == 0 ? "completed successfully" : "failed");
>  	hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
>  	return rc == 0 ? SUCCESS : FAILED;
>  }

Signed-off-by: Don Brace <don.brace@pmcs.com>
