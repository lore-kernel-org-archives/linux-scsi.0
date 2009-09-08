From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 3/3][RESUBMIT] scsi_dh_rdac: changes for rdac debug
	logging
Date: Tue, 08 Sep 2009 08:36:34 -0700
Message-ID: <1252424194.13253.4.camel@chandra-ubuntu>
References: <E463DF2B2E584B4A82673F53D62C2EF474CCD1BC@cosmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:57649 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZIHPgi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2009 11:36:38 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e37.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n88FZin2020223
	for <linux-scsi@vger.kernel.org>; Tue, 8 Sep 2009 09:35:44 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n88FaQV5075806
	for <linux-scsi@vger.kernel.org>; Tue, 8 Sep 2009 09:36:26 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n88FaPeM026871
	for <linux-scsi@vger.kernel.org>; Tue, 8 Sep 2009 09:36:25 -0600
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474CCD1BC@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'device mapper development' <dm-devel@redhat.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>"Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>

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
> 
> 

