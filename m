From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 3/3][RESUBMIT] scsi_dh_rdac: changes for rdac debug
 logging
Date: Sat, 05 Sep 2009 10:19:47 -0500
Message-ID: <1252163987.3882.103.camel@mulgrave.site>
References: <E463DF2B2E584B4A82673F53D62C2EF474CCD1BC@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54478 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbZIEPT6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Sep 2009 11:19:58 -0400
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474CCD1BC@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'device mapper development' <dm-devel@redhat.com>, "'sekharan@linux.vnet.ibm.com'" <sekharan@linux.vnet.ibm.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

On Thu, 2009-09-03 at 21:42 -0600, Moger, Babu wrote:
> Patch to add debugging stuff for rdac device handler. 
> - Added a bit mask "module parameter" rdac_logging with 2 bits for each type of logging.
> - currently defined only two types of logging(failover and sense logging). Can be enhanced later if required.
> - By default only failover logging is enabled which is equivalent of current logging.
> 
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
> Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
> Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>
> 
> ---
> --- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-09-03 14:52:46.000000000 -0500
> +++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-09-03 14:53:06.000000000 -0500
> @@ -201,6 +201,31 @@ static const char *lun_state[] =
>  static LIST_HEAD(ctlr_list);
>  static DEFINE_SPINLOCK(list_lock);
>  
> +/* 
> + * module parameter to enable rdac debug logging.
> + * 2 bits for each type of logging, only two types defined for now 
> + * Can be enhanced if required at later point
> + */
> +static int rdac_logging = 1;
> +module_param(rdac_logging, int, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(rdac_logging, "A bit mask of rdac logging levels, "
> +		"Default is 1 - failover logging enabled, "
> +		"set it to 0xF to enable all the logs");
> +
> +#define RDAC_LOG_FAILOVER	0
> +#define RDAC_LOG_SENSE		2
> +
> +#define RDAC_LOG_BITS		2
> +
> +#define RDAC_LOG_LEVEL(SHIFT)  \
> +        ((rdac_logging >> (SHIFT)) & ((1 << (RDAC_LOG_BITS)) - 1))
> +
> +#define RDAC_LOG(SHIFT, sdev, f, arg...) \
> +do { \
> +	if (unlikely(RDAC_LOG_LEVEL(SHIFT))) \
> +		sdev_printk(KERN_INFO, sdev, RDAC_NAME ": " f "\n", ## arg); \
> +} while (0);
> +
>  static inline struct rdac_dh_data *get_rdac_data(struct scsi_device *sdev)
>  {
>  	struct scsi_dh_data *scsi_dh_data = sdev->scsi_dh_data;
> @@ -469,6 +494,7 @@ static int mode_select_handle_sense(stru
>  {
>  	struct scsi_sense_hdr sense_hdr;
>  	int err = SCSI_DH_IO, ret;
> +	struct rdac_dh_data *h = get_rdac_data(sdev);
>  
>  	ret = scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE, &sense_hdr);
>  	if (!ret)
> @@ -497,11 +523,14 @@ static int mode_select_handle_sense(stru
>  			err = SCSI_DH_RETRY;
>  		break;
>  	default:
> -		sdev_printk(KERN_INFO, sdev,
> -			    "MODE_SELECT failed with sense %02x/%02x/%02x.\n",
> -			    sense_hdr.sense_key, sense_hdr.asc, sense_hdr.ascq);
> +		break;
>  	}
>  
> +	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
> +		"MODE_SELECT returned with sense %02x/%02x/%02x",
> +		(char *) h->ctlr->array_name, h->ctlr->index,
> +		sense_hdr.sense_key, sense_hdr.asc, sense_hdr.ascq);
> +
>  done:
>  	return err;
>  }
> @@ -518,7 +547,9 @@ retry:
>  	if (!rq)
>  		goto done;
>  
> -	sdev_printk(KERN_INFO, sdev, "%s MODE_SELECT command.\n",
> +	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
> +		"%s MODE_SELECT command",
> +		(char *) h->ctlr->array_name, h->ctlr->index,
>  		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
>  
>  	err = blk_execute_rq(q, NULL, rq, 1);
> @@ -528,8 +559,12 @@ retry:
>  		if (err == SCSI_DH_RETRY && retry_cnt--)
>  			goto retry;
>  	}
> -	if (err == SCSI_DH_OK)
> +	if (err == SCSI_DH_OK) {
>  		h->state = RDAC_STATE_ACTIVE;
> +		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
> +				"MODE_SELECT completed",
> +				(char *) h->ctlr->array_name, h->ctlr->index);
> +	}
>  
>  done:
>  	return err;
> @@ -567,6 +602,12 @@ static int rdac_check_sense(struct scsi_
>  				struct scsi_sense_hdr *sense_hdr)
>  {
>  	struct rdac_dh_data *h = get_rdac_data(sdev);
> +		
> +	RDAC_LOG(RDAC_LOG_SENSE, sdev, "array %s, ctlr %d, "
> +			"I/O returned with sense %02x/%02x/%02x",
> +			(char *) h->ctlr->array_name, h->ctlr->index,
> +			sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
> +
>  	switch (sense_hdr->sense_key) {
>  	case NOT_READY:
>  		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)

Could you run these through checkpatch.pl before sending them next time?

ERROR: trailing whitespace
#30: FILE: drivers/scsi/device_handler/scsi_dh_rdac.c:204:
+/* $

ERROR: trailing whitespace
#32: FILE: drivers/scsi/device_handler/scsi_dh_rdac.c:206:
+ * 2 bits for each type of logging, only two types defined for now $

ERROR: code indent should use tabs where possible
#47: FILE: drivers/scsi/device_handler/scsi_dh_rdac.c:221:
+        ((rdac_logging >> (SHIFT)) & ((1 << (RDAC_LOG_BITS)) - 1))$

ERROR: trailing whitespace
#113: FILE: drivers/scsi/device_handler/scsi_dh_rdac.c:605:
+^I^I$

total: 4 errors, 0 warnings, 90 lines checked

I fixed it all up this time around.

James


