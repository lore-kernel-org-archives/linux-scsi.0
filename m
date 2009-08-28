From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH 1/3][RESUBMIT] scsi_dh_rdac: changes to collect the
	debug information during rdac_activate
Date: Fri, 28 Aug 2009 17:58:28 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474C66194@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF474C65F3D@cosmail01.lsi.com>
 <1251482228.20333.9.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og104.obsmtp.com ([64.18.2.161]:46273 "EHLO
	exprod7og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbZH1X6g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2009 19:58:36 -0400
In-Reply-To: <1251482228.20333.9.camel@chandra-ubuntu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'device mapper development' <dm-devel@redhat.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

Hi Chandra,
  Thanks for your comments. Yes, I thought about using get_lun to get the array name also. But that needed some more changes. Reason is when get_lun is called we might not have controller structure allocated. So, I need to use a temporary variable to get the array name and copy it back when controller structure is allocated. Please look at the attached patch.. This is still a draft. Feel free to comment..
I changed the get_lun function name to get_lun_info as we are getting all the lun related information. 

--- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-08-28 18:31:13.000000000 -0500
+++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-08-28 18:33:47.000000000 -0500
@@ -112,6 +112,7 @@ struct c9_inquiry {
 
 #define SUBSYS_ID_LEN	16
 #define SLOT_ID_LEN	2
+#define ARRAY_LABEL_LEN	31
 
 struct c4_inquiry {
 	u8	peripheral_info;
@@ -135,6 +136,8 @@ struct rdac_controller {
 		struct rdac_pg_legacy legacy;
 		struct rdac_pg_expanded expanded;
 	} mode_select;
+	u8	index;
+	u8	array_name[ARRAY_LABEL_LEN];
 };
 struct c8_inquiry {
 	u8	peripheral_info;
@@ -303,7 +306,8 @@ static void release_controller(struct kr
 	kfree(ctlr);
 }
 
-static struct rdac_controller *get_controller(u8 *subsys_id, u8 *slot_id)
+static struct rdac_controller *get_controller(u8 *subsys_id, u8 *slot_id,
+						char *array_name)
 {
 	struct rdac_controller *ctlr, *tmp;
 
@@ -324,6 +328,14 @@ static struct rdac_controller *get_contr
 	/* initialize fields of controller */
 	memcpy(ctlr->subsys_id, subsys_id, SUBSYS_ID_LEN);
 	memcpy(ctlr->slot_id, slot_id, SLOT_ID_LEN);
+	memcpy(ctlr->array_name, array_name, ARRAY_LABEL_LEN);
+
+	/* update the controller index */
+	if (slot_id[1] == 0x31)
+		ctlr->index = 0;
+	else
+		ctlr->index = 1;
+
 	kref_init(&ctlr->kref);
 	ctlr->use_ms10 = -1;
 	list_add(&ctlr->node, &ctlr_list);
@@ -363,9 +375,10 @@ done:
 	return err;
 }
 
-static int get_lun(struct scsi_device *sdev, struct rdac_dh_data *h)
+static int get_lun_info(struct scsi_device *sdev, struct rdac_dh_data *h,
+			char *array_name)
 {
-	int err;
+	int err, i;
 	struct c8_inquiry *inqp;
 
 	err = submit_inquiry(sdev, 0xC8, sizeof(struct c8_inquiry), h);
@@ -377,6 +390,11 @@ static int get_lun(struct scsi_device *s
 		    inqp->page_id[2] != 'i' || inqp->page_id[3] != 'd')
 			return SCSI_DH_NOSYS;
 		h->lun = inqp->lun[7]; /* Uses only the last byte */
+
+		for(i=0; i<ARRAY_LABEL_LEN-1; ++i)
+			*(array_name+i) = inqp->array_user_label[(2*i)+1];
+
+		h->ctlr->array_name[ARRAY_LABEL_LEN-1] = '\0';
 	}
 	return err;
 }
@@ -410,7 +428,7 @@ static int check_ownership(struct scsi_d
 }
 
 static int initialize_controller(struct scsi_device *sdev,
-				 struct rdac_dh_data *h)
+				 struct rdac_dh_data *h, char *array_name)
 {
 	int err;
 	struct c4_inquiry *inqp;
@@ -418,7 +436,8 @@ static int initialize_controller(struct 
 	err = submit_inquiry(sdev, 0xC4, sizeof(struct c4_inquiry), h);
 	if (err == SCSI_DH_OK) {
 		inqp = &h->inq.c4;
-		h->ctlr = get_controller(inqp->subsys_id, inqp->slot_id);
+		h->ctlr = get_controller(inqp->subsys_id, inqp->slot_id,
+					array_name);
 		if (!h->ctlr)
 			err = SCSI_DH_RES_TEMP_UNAVAIL;
 	}
@@ -525,17 +544,6 @@ static int rdac_activate(struct scsi_dev
 	if (err != SCSI_DH_OK)
 		goto done;
 
-	if (!h->ctlr) {
-		err = initialize_controller(sdev, h);
-		if (err != SCSI_DH_OK)
-			goto done;
-	}
-
-	if (h->ctlr->use_ms10 == -1) {
-		err = set_mode_select(sdev, h);
-		if (err != SCSI_DH_OK)
-			goto done;
-	}
 	if (h->lun_state == RDAC_LUN_UNOWNED)
 		err = send_mode_select(sdev, h);
 done:
@@ -656,6 +664,7 @@ static int rdac_bus_attach(struct scsi_d
 	struct rdac_dh_data *h;
 	unsigned long flags;
 	int err;
+	char array_name[ARRAY_LABEL_LEN];
 
 	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
 			       + sizeof(*h) , GFP_KERNEL);
@@ -670,7 +679,11 @@ static int rdac_bus_attach(struct scsi_d
 	h->lun = UNINITIALIZED_LUN;
 	h->state = RDAC_STATE_ACTIVE;
 
-	err = get_lun(sdev, h);
+	err = get_lun_info(sdev, h, array_name);
+	if (err != SCSI_DH_OK)
+		goto failed;
+
+	err = initialize_controller(sdev, h, array_name);
 	if (err != SCSI_DH_OK)
 		goto failed;
 
@@ -678,6 +691,10 @@ static int rdac_bus_attach(struct scsi_d
 	if (err != SCSI_DH_OK)
 		goto failed;
 
+	err = set_mode_select(sdev, h);
+	if (err != SCSI_DH_OK)
+		goto failed;
+
 	if (!try_module_get(THIS_MODULE))
 		goto failed;
 

 

Thanks
Babu Moger 

> -----Original Message-----
> From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
> Sent: Friday, August 28, 2009 12:57 PM
> To: Moger, Babu
> Cc: 'linux-scsi@vger.kernel.org'; 'device mapper development'; Chauhan,
> Vijay; Stankey, Robert; Dachepalli, Sudhir
> Subject: Re: [PATCH 1/3][RESUBMIT] scsi_dh_rdac: changes to collect the
> debug information during rdac_activate
> 
> Hi Babu,
> 
> Sorry about this comment after few iterations. I just realized it.
> 
> We already do a C8 inquiry (get_lun()), why can't we just piggy back on
> that to fill the array name also. You can change the name of the
> function to be get_lun_and_array_name() or some such.
> 
> chandra
> On Fri, 2009-08-28 at 08:22 -0600, Moger, Babu wrote:
> > Adding the code to read the debug information during activate. This
> patch collects the information about storage and controllers during
> rdac_activate.
> >
> > Signed-off-by: Babu Moger <babu.moger@lsi.com>
> > Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
> > Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>
> >
> > ---
> > --- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig
> 	2009-08-27 18:17:23.000000000 -0500
> > +++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-
> 08-27 18:27:23.000000000 -0500
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
> > @@ -324,6 +327,13 @@ static struct rdac_controller *get_contr
> >  	/* initialize fields of controller */
> >  	memcpy(ctlr->subsys_id, subsys_id, SUBSYS_ID_LEN);
> >  	memcpy(ctlr->slot_id, slot_id, SLOT_ID_LEN);
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
> > @@ -381,6 +391,26 @@ static int get_lun(struct scsi_device *s
> >  	return err;
> >  }
> >
> > +static int get_array_name(struct scsi_device *sdev, struct
> rdac_dh_data *h)
> > +{
> > +	int err, i;
> > +	struct c8_inquiry *inqp;
> > +
> > +	err = submit_inquiry(sdev, 0xC8, sizeof(struct c8_inquiry), h);
> > +	if (err == SCSI_DH_OK) {
> > +		inqp = &h->inq.c8;
> > +		if (inqp->page_code != 0xc8)
> > +			return SCSI_DH_NOSYS;
> > +
> > +		for(i=0; i<ARRAY_LABEL_LEN-1; ++i)
> > +			h->ctlr->array_name[i] = inqp-
> >array_user_label[(2*i)+1];
> > +
> > +		h->ctlr->array_name[ARRAY_LABEL_LEN-1] = '\0';
> > +	}
> > +
> > +	return err;
> > +}
> > +
> >  static int check_ownership(struct scsi_device *sdev, struct
> rdac_dh_data *h)
> >  {
> >  	int err;
> > @@ -529,6 +559,10 @@ static int rdac_activate(struct scsi_dev
> >  		err = initialize_controller(sdev, h);
> >  		if (err != SCSI_DH_OK)
> >  			goto done;
> > +
> > +		err = get_array_name(sdev, h);
> > +		if (err != SCSI_DH_OK)
> > +			goto done;
> >  	}
> >
> >  	if (h->ctlr->use_ms10 == -1) {
> >
> >

