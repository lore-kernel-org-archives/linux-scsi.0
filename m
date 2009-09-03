From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 1/3][RESUBMIT] scsi_dh_rdac: changes to collect the
	rdac debug information during the initialization
Date: Thu, 03 Sep 2009 10:13:16 -0700
Message-ID: <1251997996.22527.3.camel@chandra-ubuntu>
References: <E463DF2B2E584B4A82673F53D62C2EF474CCCE67@cosmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:59075 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbZICRNS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2009 13:13:18 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e38.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n83H9Vle026874
	for <linux-scsi@vger.kernel.org>; Thu, 3 Sep 2009 11:09:31 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n83HDFFg063882
	for <linux-scsi@vger.kernel.org>; Thu, 3 Sep 2009 11:13:18 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n83HDAvM005052
	for <linux-scsi@vger.kernel.org>; Thu, 3 Sep 2009 11:13:12 -0600
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474CCCE67@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'device mapper development' <dm-devel@redhat.com>, "'sekharan@linux.vnet.ibm.com'" <sekharan@linux.vnet.ibm.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

Babu,

There is a small issue with this patch.

array_name is a local variable in rdac_attach() and is initialized
there, but the array_name used in initialize_controller() which is
called from rdac_activate is never initialized.

I see that it is fixed in the 2/3. But this patch is incorrect.

One thing you can do is to swap 1/3 and 2/3. Then you will not have this
issue.

regards,

chandra
On Wed, 2009-09-02 at 17:12 -0600, Moger, Babu wrote:
> Adding the code to read the debug information during initialization. This patch collects the information about storage and controllers during rdac_activate.
> 
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
> Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
> Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>
> 
> ---
> 
> --- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-09-02 09:49:23.000000000 -0500
> +++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-09-02 10:04:40.000000000 -0500
> @@ -112,6 +112,7 @@ struct c9_inquiry {
> 
>  #define SUBSYS_ID_LEN	16
>  #define SLOT_ID_LEN	2
> +#define ARRAY_LABEL_LEN	31
> 
>  struct c4_inquiry {
>  	u8	peripheral_info;
> @@ -135,6 +136,8 @@ struct rdac_controller {
>  		struct rdac_pg_legacy legacy;
>  		struct rdac_pg_expanded expanded;
>  	} mode_select;
> +	u8	index;
> +	u8	array_name[ARRAY_LABEL_LEN];
>  };
>  struct c8_inquiry {
>  	u8	peripheral_info;
> @@ -303,7 +306,8 @@ static void release_controller(struct kr
>  	kfree(ctlr);
>  }
> 
> -static struct rdac_controller *get_controller(u8 *subsys_id, u8 *slot_id)
> +static struct rdac_controller *get_controller(u8 *subsys_id, u8 *slot_id,
> +						char *array_name)
>  {
>  	struct rdac_controller *ctlr, *tmp;
> 
> @@ -324,6 +328,14 @@ static struct rdac_controller *get_contr
>  	/* initialize fields of controller */
>  	memcpy(ctlr->subsys_id, subsys_id, SUBSYS_ID_LEN);
>  	memcpy(ctlr->slot_id, slot_id, SLOT_ID_LEN);
> +	memcpy(ctlr->array_name, array_name, ARRAY_LABEL_LEN);
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
> @@ -363,9 +375,10 @@ done:
>  	return err;
>  }
> 
> -static int get_lun(struct scsi_device *sdev, struct rdac_dh_data *h)
> +static int get_lun_info(struct scsi_device *sdev, struct rdac_dh_data *h,
> +			char *array_name)
>  {
> -	int err;
> +	int err, i;
>  	struct c8_inquiry *inqp;
> 
>  	err = submit_inquiry(sdev, 0xC8, sizeof(struct c8_inquiry), h);
> @@ -377,6 +390,11 @@ static int get_lun(struct scsi_device *s
>  		    inqp->page_id[2] != 'i' || inqp->page_id[3] != 'd')
>  			return SCSI_DH_NOSYS;
>  		h->lun = inqp->lun[7]; /* Uses only the last byte */
> +
> +		for(i=0; i<ARRAY_LABEL_LEN-1; ++i)
> +			*(array_name+i) = inqp->array_user_label[(2*i)+1];
> +
> +		*(array_name+ARRAY_LABEL_LEN-1) = '\0';
>  	}
>  	return err;
>  }
> @@ -410,7 +428,7 @@ static int check_ownership(struct scsi_d
>  }
> 
>  static int initialize_controller(struct scsi_device *sdev,
> -				 struct rdac_dh_data *h)
> +				 struct rdac_dh_data *h, char *array_name)
>  {
>  	int err;
>  	struct c4_inquiry *inqp;
> @@ -418,7 +436,8 @@ static int initialize_controller(struct 
>  	err = submit_inquiry(sdev, 0xC4, sizeof(struct c4_inquiry), h);
>  	if (err == SCSI_DH_OK) {
>  		inqp = &h->inq.c4;
> -		h->ctlr = get_controller(inqp->subsys_id, inqp->slot_id);
> +		h->ctlr = get_controller(inqp->subsys_id, inqp->slot_id,
> +					array_name);
>  		if (!h->ctlr)
>  			err = SCSI_DH_RES_TEMP_UNAVAIL;
>  	}
> @@ -520,13 +539,14 @@ static int rdac_activate(struct scsi_dev
>  {
>  	struct rdac_dh_data *h = get_rdac_data(sdev);
>  	int err = SCSI_DH_OK;
> +	char array_name[ARRAY_LABEL_LEN];
> 
>  	err = check_ownership(sdev, h);
>  	if (err != SCSI_DH_OK)
>  		goto done;
> 
>  	if (!h->ctlr) {
> -		err = initialize_controller(sdev, h);
> +		err = initialize_controller(sdev, h, array_name);
>  		if (err != SCSI_DH_OK)
>  			goto done;
>  	}
> @@ -656,6 +676,7 @@ static int rdac_bus_attach(struct scsi_d
>  	struct rdac_dh_data *h;
>  	unsigned long flags;
>  	int err;
> +	char array_name[ARRAY_LABEL_LEN];
> 
>  	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
>  			       + sizeof(*h) , GFP_KERNEL);
> @@ -670,7 +691,7 @@ static int rdac_bus_attach(struct scsi_d
>  	h->lun = UNINITIALIZED_LUN;
>  	h->state = RDAC_STATE_ACTIVE;
> 
> -	err = get_lun(sdev, h);
> +	err = get_lun_info(sdev, h, array_name);
>  	if (err != SCSI_DH_OK)
>  		goto failed;
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

