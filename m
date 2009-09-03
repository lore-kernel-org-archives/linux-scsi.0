From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH 1/3][RESUBMIT] scsi_dh_rdac: changes to collect the	rdac
 debug information during the initialization
Date: Thu, 3 Sep 2009 12:27:20 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474CCD082@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF474CCCE67@cosmail01.lsi.com>
 <1251997996.22527.3.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og123.obsmtp.com ([64.18.2.24]:47897 "EHLO
	exprod7og123.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbZICS11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2009 14:27:27 -0400
In-Reply-To: <1251997996.22527.3.camel@chandra-ubuntu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'device mapper development' <dm-devel@redhat.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

Hi Chandra, 
	Yes, I can swap the patches. Then I won't have this problem. Reason I did that was to make the patches independent while compiling. 
Thanks
Babu Moger 

> -----Original Message-----
> From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
> Sent: Thursday, September 03, 2009 12:13 PM
> To: Moger, Babu
> Cc: 'linux-scsi@vger.kernel.org'; 'device mapper development';
> 'sekharan@linux.vnet.ibm.com'; Chauhan, Vijay; Stankey, Robert;
> Dachepalli, Sudhir
> Subject: Re: [PATCH 1/3][RESUBMIT] scsi_dh_rdac: changes to collect the
> rdac debug information during the initialization
> 
> Babu,
> 
> There is a small issue with this patch.
> 
> array_name is a local variable in rdac_attach() and is initialized
> there, but the array_name used in initialize_controller() which is
> called from rdac_activate is never initialized.
> 
> I see that it is fixed in the 2/3. But this patch is incorrect.
> 
> One thing you can do is to swap 1/3 and 2/3. Then you will not have
> this
> issue.
> 
> regards,
> 
> chandra
> On Wed, 2009-09-02 at 17:12 -0600, Moger, Babu wrote:
> > Adding the code to read the debug information during initialization.
> This patch collects the information about storage and controllers
> during rdac_activate.
> >
> > Signed-off-by: Babu Moger <babu.moger@lsi.com>
> > Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
> > Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>
> >
> > ---
> >
> > --- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig
> 	2009-09-02 09:49:23.000000000 -0500
> > +++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-
> 09-02 10:04:40.000000000 -0500
> > @@ -112,6 +112,7 @@ struct c9_inquiry {
> >
> >  #define SUBSYS_ID_LEN	16
> >  #define SLOT_ID_LEN	2
> > +#define ARRAY_LABEL_LEN	31
> >
> >  struct c4_inquiry {
> >  	u8	peripheral_info;
> > @@ -135,6 +136,8 @@ struct rdac_controller {
> >  		struct rdac_pg_legacy legacy;
> >  		struct rdac_pg_expanded expanded;
> >  	} mode_select;
> > +	u8	index;
> > +	u8	array_name[ARRAY_LABEL_LEN];
> >  };
> >  struct c8_inquiry {
> >  	u8	peripheral_info;
> > @@ -303,7 +306,8 @@ static void release_controller(struct kr
> >  	kfree(ctlr);
> >  }
> >
> > -static struct rdac_controller *get_controller(u8 *subsys_id, u8
> *slot_id)
> > +static struct rdac_controller *get_controller(u8 *subsys_id, u8
> *slot_id,
> > +						char *array_name)
> >  {
> >  	struct rdac_controller *ctlr, *tmp;
> >
> > @@ -324,6 +328,14 @@ static struct rdac_controller *get_contr
> >  	/* initialize fields of controller */
> >  	memcpy(ctlr->subsys_id, subsys_id, SUBSYS_ID_LEN);
> >  	memcpy(ctlr->slot_id, slot_id, SLOT_ID_LEN);
> > +	memcpy(ctlr->array_name, array_name, ARRAY_LABEL_LEN);
> > +
> > +	/* update the controller index */
> > +	if (slot_id[1] == 0x31)
> > +		ctlr->index = 0;
> > +	else
> > +		ctlr->index = 1;
> > +
> >  	kref_init(&ctlr->kref);
> >  	ctlr->use_ms10 = -1;
> >  	list_add(&ctlr->node, &ctlr_list);
> > @@ -363,9 +375,10 @@ done:
> >  	return err;
> >  }
> >
> > -static int get_lun(struct scsi_device *sdev, struct rdac_dh_data *h)
> > +static int get_lun_info(struct scsi_device *sdev, struct
> rdac_dh_data *h,
> > +			char *array_name)
> >  {
> > -	int err;
> > +	int err, i;
> >  	struct c8_inquiry *inqp;
> >
> >  	err = submit_inquiry(sdev, 0xC8, sizeof(struct c8_inquiry), h);
> > @@ -377,6 +390,11 @@ static int get_lun(struct scsi_device *s
> >  		    inqp->page_id[2] != 'i' || inqp->page_id[3] != 'd')
> >  			return SCSI_DH_NOSYS;
> >  		h->lun = inqp->lun[7]; /* Uses only the last byte */
> > +
> > +		for(i=0; i<ARRAY_LABEL_LEN-1; ++i)
> > +			*(array_name+i) = inqp->array_user_label[(2*i)+1];
> > +
> > +		*(array_name+ARRAY_LABEL_LEN-1) = '\0';
> >  	}
> >  	return err;
> >  }
> > @@ -410,7 +428,7 @@ static int check_ownership(struct scsi_d
> >  }
> >
> >  static int initialize_controller(struct scsi_device *sdev,
> > -				 struct rdac_dh_data *h)
> > +				 struct rdac_dh_data *h, char *array_name)
> >  {
> >  	int err;
> >  	struct c4_inquiry *inqp;
> > @@ -418,7 +436,8 @@ static int initialize_controller(struct
> >  	err = submit_inquiry(sdev, 0xC4, sizeof(struct c4_inquiry), h);
> >  	if (err == SCSI_DH_OK) {
> >  		inqp = &h->inq.c4;
> > -		h->ctlr = get_controller(inqp->subsys_id, inqp->slot_id);
> > +		h->ctlr = get_controller(inqp->subsys_id, inqp->slot_id,
> > +					array_name);
> >  		if (!h->ctlr)
> >  			err = SCSI_DH_RES_TEMP_UNAVAIL;
> >  	}
> > @@ -520,13 +539,14 @@ static int rdac_activate(struct scsi_dev
> >  {
> >  	struct rdac_dh_data *h = get_rdac_data(sdev);
> >  	int err = SCSI_DH_OK;
> > +	char array_name[ARRAY_LABEL_LEN];
> >
> >  	err = check_ownership(sdev, h);
> >  	if (err != SCSI_DH_OK)
> >  		goto done;
> >
> >  	if (!h->ctlr) {
> > -		err = initialize_controller(sdev, h);
> > +		err = initialize_controller(sdev, h, array_name);
> >  		if (err != SCSI_DH_OK)
> >  			goto done;
> >  	}
> > @@ -656,6 +676,7 @@ static int rdac_bus_attach(struct scsi_d
> >  	struct rdac_dh_data *h;
> >  	unsigned long flags;
> >  	int err;
> > +	char array_name[ARRAY_LABEL_LEN];
> >
> >  	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
> >  			       + sizeof(*h) , GFP_KERNEL);
> > @@ -670,7 +691,7 @@ static int rdac_bus_attach(struct scsi_d
> >  	h->lun = UNINITIALIZED_LUN;
> >  	h->state = RDAC_STATE_ACTIVE;
> >
> > -	err = get_lun(sdev, h);
> > +	err = get_lun_info(sdev, h, array_name);
> >  	if (err != SCSI_DH_OK)
> >  		goto failed;
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

