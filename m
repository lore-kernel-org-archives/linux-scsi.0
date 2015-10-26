From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 03/21] hpsa: abandon rescans on memory alloaction
 failures.
Date: Mon, 26 Oct 2015 15:24:27 +0100
Message-ID: <562E379B.5040400@redhat.com>
References: <20151024193306.17127.7819.stgit@brunhilda>
 <20151024195244.17127.26347.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbbJZOYa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Oct 2015 10:24:30 -0400
In-Reply-To: <20151024195244.17127.26347.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 24.10.2015 21:52, Don Brace wrote:
> Abandon and reschedule rescan process only if device inquiries
> fail due to mem alloc failures, which are likely to occur for
> all devices.
>
> Otherwise, skip device if inquiry fails for other reasons,
> and continue rescanning process for other devices.
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |   24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 5dfb6cf..e1ee06d 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -3357,10 +3357,13 @@ static int hpsa_update_device_info(struct ctlr_info *h,
>  
>  	unsigned char *inq_buff;
>  	unsigned char *obdr_sig;
> +	int rc = 0;
>  
>  	inq_buff = kzalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
> -	if (!inq_buff)
> +	if (!inq_buff) {
> +		rc = -ENOMEM;
>  		goto bail_out;
> +	}
>  
>  	/* Do an inquiry to the device to see what it is. */
>  	if (hpsa_scsi_do_inquiry(h, scsi3addr, 0, inq_buff,
> @@ -3368,6 +3371,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
>  		/* Inquiry failed (msg printed already) */
>  		dev_err(&h->pdev->dev,
>  			"hpsa_update_device_info: inquiry failed\n");
> +		rc = 1;
>  		goto bail_out;
>  	}
>  
> @@ -3417,7 +3421,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
>  
>  bail_out:
>  	kfree(inq_buff);
> -	return 1;
> +	return rc;
>  }
>  
>  static void hpsa_update_device_supports_aborts(struct ctlr_info *h,
> @@ -3787,6 +3791,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
>  	n_ext_target_devs = 0;
>  	for (i = 0; i < nphysicals + nlogicals + 1; i++) {
>  		u8 *lunaddrbytes, is_OBDR = 0;
> +		int rc = 0;
>  
>  		/* Figure out where the LUN ID info is coming from */
>  		lunaddrbytes = figure_lunaddrbytes(h, raid_ctlr_position,
> @@ -3799,11 +3804,20 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
>  				continue;
>  
>  		/* Get device type, vendor, model, device id */
> -		if (hpsa_update_device_info(h, lunaddrbytes, tmpdevice,
> -							&is_OBDR)) {
> +		rc = hpsa_update_device_info(h, lunaddrbytes, tmpdevice,
> +							&is_OBDR);
> +		if (rc == -ENOMEM) {
> +			dev_warn(&h->pdev->dev,
> +				"Out of memory, rescan stopped.\n");

What about 'rescan deferred" instead of "rescan stopped?
 

>  			h->drv_req_rescan = 1;
> -			continue; /* skip it if we can't talk to it. */
> +			goto out;
>  		}
> +		if (rc) {
> +			dev_warn(&h->pdev->dev,
> +				"Inquiry failed, skipping device.\n");
> +			continue;
> +		}
> +
>  		figure_bus_target_lun(h, lunaddrbytes, tmpdevice);
>  		hpsa_update_device_supports_aborts(h, tmpdevice, lunaddrbytes);
>  		this_device = currentsd[ncurrent];
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

