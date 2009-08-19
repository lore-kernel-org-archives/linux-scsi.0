From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH] scsi_dh: Adding more debug options for scsi rdac
	handler
Date: Tue, 18 Aug 2009 19:09:35 -0700
Message-ID: <1250647775.30799.36.camel@chandra-ubuntu>
References: <E463DF2B2E584B4A82673F53D62C2EF474B7A493@cosmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:48994 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZHSCFV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 22:05:21 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7J20k8L014268
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2009 20:00:47 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7J25Hlw153752
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2009 20:05:17 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7J25GLV029418
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2009 20:05:16 -0600
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474B7A493@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

Hi Babu,

Code looks good. But I have few comments...

Generic:
 - Is that all the debug stuff you want to add ?
 - I would split this into few patches (since they
     are can be independent and not related to
     configurable logging, IMO)
   1. Add the array_name and index and acquiring it.
   2. Moving the initialization code to attach()
   3. removal of SCSI_DH_OK in check_ownership() (more below).
   4. Logging stuff.
   (1) and (4) have dependency, but (2) and (3) are
   totally independent of all this.

Specific comments inline...

On Mon, 2009-08-17 at 11:46 -0600, Moger, Babu wrote:
> From: Babu Moger <babu.moger@lsi.com>
> 
> Hi All,
> This patch adds more debugging options to scsi rdac device handler. This patch can considerably reduce the time taken to debug issues in big configurations also very helpful in addressing the support issues.
> Here are the summary of changes. 
>  - Added a bit mask "module parameter" rdac_logging with 2 bits for each type of logging.

Why 2 bits ? isn't 1 bit sufficient ?

>  - currently defined only two types of logging(failover and sense logging). Can be enhanced later if required.
>  - Only failover logging is enabled for now which is equivalent of current logging.
by default.

> 
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
> Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
> Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>
> 
> ---
> --- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-08-05 16:30:51.000000000 -0500
> +++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-08-17 09:15:03.000000000 -0500
> @@ -135,6 +135,8 @@ struct rdac_controller {
>  		struct rdac_pg_legacy legacy;
>  		struct rdac_pg_expanded expanded;
>  	} mode_select;
> +	u8			index;
> +	u8			array_name[31];

Can use a #define ?

>  };
>  struct c8_inquiry {
>  	u8	peripheral_info;
> @@ -198,6 +200,31 @@ static const char *lun_state[] =
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
> +#define RDAC_DEBUG(SHIFT, sdev, f, arg...) \

instead of RDAC_DEBUG, we can say RDAC_LOG ?!

> +do { \
> +	if (unlikely(RDAC_LOG_LEVEL(SHIFT))) \
> +		sdev_printk(KERN_INFO, sdev, RDAC_NAME ": " f "\n", ## arg); \
> +} while (0);
> +
>  static inline struct rdac_dh_data *get_rdac_data(struct scsi_device *sdev)
>  {
>  	struct scsi_dh_data *scsi_dh_data = sdev->scsi_dh_data;
> @@ -324,6 +351,13 @@ static struct rdac_controller *get_contr
>  	/* initialize fields of controller */
>  	memcpy(ctlr->subsys_id, subsys_id, SUBSYS_ID_LEN);
>  	memcpy(ctlr->slot_id, slot_id, SLOT_ID_LEN);
> +
> +	/* update the controller index */
> +	if (slot_id[1] == 0x31)
> +		ctlr->index = 0;
> +	else
> +		ctlr->index = 1;
> +
>  	kref_init(&ctlr->kref);
>  	ctlr->use_ms10 = -1;
>  	list_add(&ctlr->node, &ctlr_list);
> @@ -381,6 +415,26 @@ static int get_lun(struct scsi_device *s
>  	return err;
>  }
> 
> +static int get_array_name(struct scsi_device *sdev, struct rdac_dh_data *h)
> +{
> +	int err, i;
> +	struct c8_inquiry *inqp;
> +
> +	err = submit_inquiry(sdev, 0xC8, sizeof(struct c8_inquiry), h);
> +	if (err == SCSI_DH_OK) {
> +		inqp = &h->inq.c8;
> +		if (inqp->page_code != 0xc8)
> +			return SCSI_DH_NOSYS;
> +
> +		for(i=0; i<30; ++i) {
> +			h->ctlr->array_name[i] = inqp->array_user_label[(2*i)+1];
> +		}

do not have to have { } for a single line loop.

> +		h->ctlr->array_name[30] = '\0';
> +	}
> +			
> +	return err;
> +}
> +
>  static int check_ownership(struct scsi_device *sdev, struct rdac_dh_data *h)
>  {
>  	int err;
> @@ -450,13 +504,12 @@ static int mode_select_handle_sense(stru
>  {
>  	struct scsi_sense_hdr sense_hdr;
>  	int err = SCSI_DH_IO, ret;
> +	struct rdac_dh_data *h = get_rdac_data(sdev);
> 
>  	ret = scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE, &sense_hdr);
>  	if (!ret)
>  		goto done;
> 
> -	err = SCSI_DH_OK;
> -

This is a change in behavior.

Why is this needed ?

>  	switch (sense_hdr.sense_key) {
>  	case NO_SENSE:
>  	case ABORTED_COMMAND:
> @@ -478,12 +531,15 @@ static int mode_select_handle_sense(stru
>  			err = SCSI_DH_RETRY;
>  		break;
>  	default:
> -		sdev_printk(KERN_INFO, sdev,
> -			    "MODE_SELECT failed with sense %02x/%02x/%02x.\n",
> -			    sense_hdr.sense_key, sense_hdr.asc, sense_hdr.ascq);
> +		break;
>  	}
> 
>  done:
> +	RDAC_DEBUG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
> +		"MODE_SELECT returned with sense %02x/%02x/%02x",
> +		(char *) h->ctlr->array_name, h->ctlr->index,
> +		sense_hdr.sense_key, sense_hdr.asc, sense_hdr.ascq);
> +

May need to be moved above "done:", as the control comes to done when
scsi_normalize_sense() fails.

> 		
>  	return err;
>  }
> 
> @@ -499,7 +555,9 @@ retry:
>  	if (!rq)
>  		goto done;
> 
> -	sdev_printk(KERN_INFO, sdev, "%s MODE_SELECT command.\n",
> +	RDAC_DEBUG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
> +		"%s MODE_SELECT command",
> +		(char *) h->ctlr->array_name, h->ctlr->index,
>  		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
> 
>  	err = blk_execute_rq(q, NULL, rq, 1);
> @@ -509,8 +567,12 @@ retry:
>  		if (err == SCSI_DH_RETRY && retry_cnt--)
>  			goto retry;
>  	}
> -	if (err == SCSI_DH_OK)
> +	if (err == SCSI_DH_OK) {
>  		h->state = RDAC_STATE_ACTIVE;
> +		RDAC_DEBUG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
> +				"MODE_SELECT completed",
> +				(char *) h->ctlr->array_name, h->ctlr->index);
> +	}
Don;t you think we need to have failure also reported ?

> 
>  done:
>  	return err;
> @@ -525,12 +587,6 @@ static int rdac_activate(struct scsi_dev
>  	if (err != SCSI_DH_OK)
>  		goto done;
> 
> -	if (!h->ctlr) {
> -		err = initialize_controller(sdev, h);
> -		if (err != SCSI_DH_OK)
> -			goto done;
> -	}
> -

You can also move the set_mode_select block below.

>  	if (h->ctlr->use_ms10 == -1) {
>  		err = set_mode_select(sdev, h);
>  		if (err != SCSI_DH_OK)
> @@ -559,6 +615,12 @@ static int rdac_check_sense(struct scsi_
>  				struct scsi_sense_hdr *sense_hdr)
>  {
>  	struct rdac_dh_data *h = get_rdac_data(sdev);
> +		
> +	RDAC_DEBUG(RDAC_LOG_SENSE, sdev, "array %s, ctlr %d, "
> +			"command returned with sense %02x/%02x/%02x",
> +			(char *) h->ctlr->array_name, h->ctlr->index,
> +			sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
> +

It is not a "command", right ? Code comes here for any I/O failure.
cut-n-paste problem :)


>  	switch (sense_hdr->sense_key) {
>  	case NOT_READY:
>  		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
> @@ -678,6 +740,16 @@ static int rdac_bus_attach(struct scsi_d
>  	if (err != SCSI_DH_OK)
>  		goto failed;
> 
> +	if (!h->ctlr) {

I do not think we need this check here.
> +		err = initialize_controller(sdev, h);
> +		if (err != SCSI_DH_OK)
> +			goto failed;
> +		
> +		err = get_array_name(sdev, h);
> +		if (err != SCSI_DH_OK)
> +			goto failed;
> +	}
> +
>  	if (!try_module_get(THIS_MODULE))
>  		goto failed;
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

