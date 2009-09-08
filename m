From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 2/3][RESUBMIT] scsi_dh_rdac: changes to
	collect the rdac debug information during the initialization
Date: Tue, 08 Sep 2009 08:35:57 -0700
Message-ID: <1252424157.13253.2.camel@chandra-ubuntu>
References: <E463DF2B2E584B4A82673F53D62C2EF474CCD1BB@cosmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474CCD1BB@cosmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "Stankey, Robert" <Robert.Stankey@lsi.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'sekharan@linux.vnet.ibm.com'" <sekharan@linux.vnet.ibm.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, 'device mapper development' <dm-devel@redhat.com>, "Chauhan,
	Vijay" <Vijay.Chauhan@lsi.com>
List-Id: linux-scsi@vger.kernel.org

Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>
On Thu, 2009-09-03 at 21:42 -0600, Moger, Babu wrote:
> Adding the code to read the debug information during initialization. This patch collects the information about storage and controllers during rdac_activate.
> 
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
> Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
> Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>
> 
> ---
> --- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-09-03 14:14:35.000000000 -0500
> +++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-09-03 14:22:29.000000000 -0500
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
> @@ -645,6 +664,7 @@ static int rdac_bus_attach(struct scsi_d
>  	struct rdac_dh_data *h;
>  	unsigned long flags;
>  	int err;
> +	char array_name[ARRAY_LABEL_LEN];
>  
>  	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
>  			       + sizeof(*h) , GFP_KERNEL);
> @@ -659,11 +679,11 @@ static int rdac_bus_attach(struct scsi_d
>  	h->lun = UNINITIALIZED_LUN;
>  	h->state = RDAC_STATE_ACTIVE;
>  
> -	err = get_lun(sdev, h);
> +	err = get_lun_info(sdev, h, array_name);
>  	if (err != SCSI_DH_OK)
>  		goto failed;
>  
> -	err = initialize_controller(sdev, h);
> +	err = initialize_controller(sdev, h, array_name);
>  	if (err != SCSI_DH_OK)
>  		goto failed;
>  
> 
> 
