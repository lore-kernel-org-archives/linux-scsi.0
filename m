From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 1/3][RESUBMIT] scsi_dh_rdac: changes to collect the
	debug information during rdac_activate
Date: Fri, 28 Aug 2009 10:57:08 -0700
Message-ID: <1251482228.20333.9.camel@chandra-ubuntu>
References: <E463DF2B2E584B4A82673F53D62C2EF474C65F3D@cosmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:44583 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbZH1R5I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2009 13:57:08 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7SHt5lq003966
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2009 11:55:05 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7SHv6OM056260
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2009 11:57:06 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7SHv5bR015538
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2009 11:57:06 -0600
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474C65F3D@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'device mapper development' <dm-devel@redhat.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

Hi Babu,

Sorry about this comment after few iterations. I just realized it.

We already do a C8 inquiry (get_lun()), why can't we just piggy back on
that to fill the array name also. You can change the name of the
function to be get_lun_and_array_name() or some such.

chandra
On Fri, 2009-08-28 at 08:22 -0600, Moger, Babu wrote:
> Adding the code to read the debug information during activate. This patch collects the information about storage and controllers during rdac_activate.
> 
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
> Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
> Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>
> 
> ---
> --- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-08-27 18:17:23.000000000 -0500
> +++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-08-27 18:27:23.000000000 -0500
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
> @@ -324,6 +327,13 @@ static struct rdac_controller *get_contr
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
> @@ -381,6 +391,26 @@ static int get_lun(struct scsi_device *s
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
> +		for(i=0; i<ARRAY_LABEL_LEN-1; ++i)
> +			h->ctlr->array_name[i] = inqp->array_user_label[(2*i)+1];
> +
> +		h->ctlr->array_name[ARRAY_LABEL_LEN-1] = '\0';
> +	}
> +			
> +	return err;
> +}
> +
>  static int check_ownership(struct scsi_device *sdev, struct rdac_dh_data *h)
>  {
>  	int err;
> @@ -529,6 +559,10 @@ static int rdac_activate(struct scsi_dev
>  		err = initialize_controller(sdev, h);
>  		if (err != SCSI_DH_OK)
>  			goto done;
> +
> +		err = get_array_name(sdev, h);
> +		if (err != SCSI_DH_OK)
> +			goto done;
>  	}
>  
>  	if (h->ctlr->use_ms10 == -1) {
> 
> 

