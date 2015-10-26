From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 01/21] hpsa: correct calls to dev_printk
Date: Mon, 26 Oct 2015 13:52:24 +0100
Message-ID: <562E2208.5060200@redhat.com>
References: <20151024193306.17127.7819.stgit@brunhilda>
 <20151024195232.17127.59627.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935AbbJZMw1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Oct 2015 08:52:27 -0400
In-Reply-To: <20151024195232.17127.59627.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 24.10.2015 21:52, Don Brace wrote:
> was seeing issues passing level into hpsa_show_dev_msg and then using
> the level as an arguement to dev_printk. For now, switch to dev_warn.
>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |   41 ++++++++++++++++++++++++-----------------
>  1 file changed, 24 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 40669f8..8454f22 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1137,11 +1137,15 @@ static int hpsa_find_target_lun(struct ctlr_info *h,
>  static inline void hpsa_show_dev_msg(const char *level, struct ctlr_info *h,
>  	struct hpsa_scsi_dev_t *dev, char *description)
>  {
> -	dev_printk(level, &h->pdev->dev,
> +	if (dev == NULL)
> +		return;
> +
> +	dev_warn(&h->pdev->dev,
>  			"scsi %d:%d:%d:%d: %s %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",
>  			h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
>  			description,
> -			scsi_device_type(dev->devtype),
> +			dev->devtype >= 0 ?
> +				scsi_device_type(dev->devtype) : "unknown",

Can devtype ever be negative? Found only this place in code
where it is set "this_device->devtype = (inq_buff[0] & 0x1f);"
And if it was negative the scsi_device_type will return "Unknown"
anyway. You probably could skip the test now and switch devtype
from int to unsigned in the future.

Cheers,
Tomas


>  			dev->vendor,
>  			dev->model,
>  			dev->raid_level > RAID_UNKNOWN ?
> @@ -1220,7 +1224,7 @@ lun_assigned:
>  	h->ndevices++;
>  	added[*nadded] = device;
>  	(*nadded)++;
> -	hpsa_show_dev_msg(KERN_INFO, h, device,
> +	hpsa_show_dev_msg(__stringify(KERN_INFO), h, device,
>  		device->expose_state & HPSA_SCSI_ADD ? "added" : "masked");
>  	device->offload_to_be_enabled = device->offload_enabled;
>  	device->offload_enabled = 0;
> @@ -1271,7 +1275,7 @@ static void hpsa_scsi_update_entry(struct ctlr_info *h, int hostno,
>  
>  	offload_enabled = h->dev[entry]->offload_enabled;
>  	h->dev[entry]->offload_enabled = h->dev[entry]->offload_to_be_enabled;
> -	hpsa_show_dev_msg(KERN_INFO, h, h->dev[entry], "updated");
> +	hpsa_show_dev_msg(__stringify(KERN_INFO), h, h->dev[entry], "updated");
>  	h->dev[entry]->offload_enabled = offload_enabled;
>  }
>  
> @@ -1298,7 +1302,7 @@ static void hpsa_scsi_replace_entry(struct ctlr_info *h, int hostno,
>  	h->dev[entry] = new_entry;
>  	added[*nadded] = new_entry;
>  	(*nadded)++;
> -	hpsa_show_dev_msg(KERN_INFO, h, new_entry, "replaced");
> +	hpsa_show_dev_msg(__stringify(KERN_INFO), h, new_entry, "replaced");
>  	new_entry->offload_to_be_enabled = new_entry->offload_enabled;
>  	new_entry->offload_enabled = 0;
>  }
> @@ -1320,7 +1324,7 @@ static void hpsa_scsi_remove_entry(struct ctlr_info *h, int hostno, int entry,
>  	for (i = entry; i < h->ndevices-1; i++)
>  		h->dev[i] = h->dev[i+1];
>  	h->ndevices--;
> -	hpsa_show_dev_msg(KERN_INFO, h, sd, "removed");
> +	hpsa_show_dev_msg(__stringify(KERN_INFO), h, sd, "removed");
>  }
>  
>  #define SCSI3ADDR_EQ(a, b) ( \
> @@ -1710,7 +1714,8 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
>  		 */
>  		if (sd[i]->volume_offline) {
>  			hpsa_show_volume_status(h, sd[i]);
> -			hpsa_show_dev_msg(KERN_INFO, h, sd[i], "offline");
> +			hpsa_show_dev_msg(__stringify(KERN_INFO), h, sd[i],
> +						"offline");
>  			continue;
>  		}
>  
> @@ -1774,7 +1779,8 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
>  				 * future cmds to this device will get selection
>  				 * timeout as if the device was gone.
>  				 */
> -				hpsa_show_dev_msg(KERN_WARNING, h, removed[i],
> +				hpsa_show_dev_msg(__stringify(KERN_WARNING),
> +					h, removed[i],
>  					"didn't find device for removal.");
>  			}
>  		}
> @@ -1789,7 +1795,7 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
>  		if (scsi_add_device(sh, added[i]->bus,
>  			added[i]->target, added[i]->lun) == 0)
>  			continue;
> -		hpsa_show_dev_msg(KERN_WARNING, h, added[i],
> +		hpsa_show_dev_msg(__stringify(KERN_WARNING), h, added[i],
>  					"addition failed, device not added.");
>  		/* now we have to remove it from h->dev,
>  		 * since it didn't get added to scsi mid layer
> @@ -5188,7 +5194,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
>  		snprintf(msg, sizeof(msg),
>  			 "cmd %d RESET FAILED, lockup detected",
>  			 hpsa_get_cmd_index(scsicmd));
> -		hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
> +		hpsa_show_dev_msg(__stringify(KERN_WARNING), h, dev, msg);
>  		return FAILED;
>  	}
>  
> @@ -5197,7 +5203,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
>  		snprintf(msg, sizeof(msg),
>  			 "cmd %d RESET FAILED, new lockup detected",
>  			 hpsa_get_cmd_index(scsicmd));
> -		hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
> +		hpsa_show_dev_msg(__stringify(KERN_WARNING), h, dev, msg);
>  		return FAILED;
>  	}
>  
> @@ -5205,14 +5211,14 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
>  	if (is_hba_lunid(dev->scsi3addr))
>  		return SUCCESS;
>  
> -	hpsa_show_dev_msg(KERN_WARNING, h, dev, "resetting");
> +	hpsa_show_dev_msg(__stringify(KERN_WARNING), h, dev, "resetting");
>  
>  	/* send a reset to the SCSI LUN which the command was sent to */
>  	rc = hpsa_do_reset(h, dev, dev->scsi3addr, HPSA_RESET_TYPE_LUN,
>  			   DEFAULT_REPLY_QUEUE);
>  	snprintf(msg, sizeof(msg), "reset %s",
>  		 rc == 0 ? "completed successfully" : "failed");
> -	hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
> +	hpsa_show_dev_msg(__stringify(KERN_WARNING), h, dev, msg);
>  	return rc == 0 ? SUCCESS : FAILED;
>  }
>  
> @@ -5548,14 +5554,14 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
>  
>  	/* If controller locked up, we can guarantee command won't complete */
>  	if (lockup_detected(h)) {
> -		hpsa_show_dev_msg(KERN_WARNING, h, dev,
> +		hpsa_show_dev_msg(__stringify(KERN_WARNING), h, dev,
>  					"ABORT FAILED, lockup detected");
>  		return FAILED;
>  	}
>  
>  	/* This is a good time to check if controller lockup has occurred */
>  	if (detect_controller_lockup(h)) {
> -		hpsa_show_dev_msg(KERN_WARNING, h, dev,
> +		hpsa_show_dev_msg(__stringify(KERN_WARNING), h, dev,
>  					"ABORT FAILED, new lockup detected");
>  		return FAILED;
>  	}
> @@ -5610,7 +5616,8 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
>  			as->cmd_len, as->cmnd[0], as->cmnd[1],
>  			as->serial_number);
>  	dev_warn(&h->pdev->dev, "%s BEING SENT\n", msg);
> -	hpsa_show_dev_msg(KERN_WARNING, h, dev, "Aborting command");
> +	hpsa_show_dev_msg(__stringify(KERN_WARNING), h, dev,
> +				"Aborting command");
>  
>  	/*
>  	 * Command is in flight, or possibly already completed
> @@ -5629,7 +5636,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
>  	wake_up_all(&h->abort_cmd_wait_queue);
>  	if (rc != 0) {
>  		dev_warn(&h->pdev->dev, "%s SENT, FAILED\n", msg);
> -		hpsa_show_dev_msg(KERN_WARNING, h, dev,
> +		hpsa_show_dev_msg(__stringify(KERN_WARNING), h, dev,
>  				"FAILED to abort command");
>  		cmd_free(h, abort);
>  		return FAILED;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

