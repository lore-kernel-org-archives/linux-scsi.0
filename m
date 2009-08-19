From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH] scsi_dh: Adding more debug options for scsi rdac	handler
Date: Wed, 19 Aug 2009 15:45:08 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474B7AD1D@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF474B7A493@cosmail01.lsi.com>
 <1250647775.30799.36.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og123.obsmtp.com ([64.18.2.24]:35845 "EHLO
	exprod7og123.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbZHSVpe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Aug 2009 17:45:34 -0400
In-Reply-To: <1250647775.30799.36.camel@chandra-ubuntu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>
Cc: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

Hi Chandra,
   Thanks for your comments. I will start working on incorporating your=
 comments however I may need some clarifications. Please see my respons=
e inline..
- Babu

> -----Original Message-----
> From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
> Sent: Tuesday, August 18, 2009 9:10 PM
> To: Moger, Babu
> Cc: Linux SCSI Mailing list; device-mapper development; Chauhan, Vija=
y;
> Stankey, Robert; Dachepalli, Sudhir
> Subject: Re: [PATCH] scsi_dh: Adding more debug options for scsi rdac
> handler
>=20
> Hi Babu,
>=20
> Code looks good. But I have few comments...
>=20
> Generic:
>  - Is that all the debug stuff you want to add ?
>  - I would split this into few patches (since they
>      are can be independent and not related to
>      configurable logging, IMO)
>    1. Add the array_name and index and acquiring it.
>    2. Moving the initialization code to attach()
>    3. removal of SCSI_DH_OK in check_ownership() (more below).
>    4. Logging stuff.
>    (1) and (4) have dependency, but (2) and (3) are
>    totally independent of all this.

I am fine with this proposal. I will try to see if I can do it without =
creating merging issues.
      I think I can break it into three patches.=20
	a) removal of SCSI_DH_OK in check_ownership() (more below).
	b) moving the initialization code to attach()
      c) combining 1 and 4.=20
	What do you think?

>=20
> Specific comments inline...
>=20
> On Mon, 2009-08-17 at 11:46 -0600, Moger, Babu wrote:
> > From: Babu Moger <babu.moger@lsi.com>
> >
> > Hi All,
> > This patch adds more debugging options to scsi rdac device handler.
> This patch can considerably reduce the time taken to debug issues in
> big configurations also very helpful in addressing the support issues=
=2E
> > Here are the summary of changes.
> >  - Added a bit mask "module parameter" rdac_logging with 2 bits for
> each type of logging.
>=20
> Why 2 bits ? isn't 1 bit sufficient ?

Right now 1 bit is sufficient. We thought it may be necessary in future=
 in case we want to display only some messages(critical or info but not=
 all) in particular category. =20

>=20
> >  - currently defined only two types of logging(failover and sense
> logging). Can be enhanced later if required.
> >  - Only failover logging is enabled for now which is equivalent of
> current logging.
> by default.

Ok. I will correct it.

>=20
> >
> > Signed-off-by: Babu Moger <babu.moger@lsi.com>
> > Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
> > Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>
> >
> > ---
> > --- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.ori=
g
> 	2009-08-05 16:30:51.000000000 -0500
> > +++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	200=
9-
> 08-17 09:15:03.000000000 -0500
> > @@ -135,6 +135,8 @@ struct rdac_controller {
> >  		struct rdac_pg_legacy legacy;
> >  		struct rdac_pg_expanded expanded;
> >  	} mode_select;
> > +	u8			index;
> > +	u8			array_name[31];
>=20
> Can use a #define ?

If I understood your question correctly,  #define may not work well. Re=
ason is, if we have multiple arrays(which is very common) then we canno=
t differentiate the two arrays.. So we have to have index and array nam=
e separately for each array/controller..

>=20
> >  };
> >  struct c8_inquiry {
> >  	u8	peripheral_info;
> > @@ -198,6 +200,31 @@ static const char *lun_state[] =3D
> >  static LIST_HEAD(ctlr_list);
> >  static DEFINE_SPINLOCK(list_lock);
> >
> > +/*
> > + * module parameter to enable rdac debug logging.
> > + * 2 bits for each type of logging, only two types defined for now
> > + * Can be enhanced if required at later point
> > + */
> > +static int rdac_logging =3D 1;
> > +module_param(rdac_logging, int, S_IRUGO|S_IWUSR);
> > +MODULE_PARM_DESC(rdac_logging, "A bit mask of rdac logging levels,=
 "
> > +		"Default is 1 - failover logging enabled, "
> > +		"set it to 0xF to enable all the logs");
> > +
> > +#define RDAC_LOG_FAILOVER	0
> > +#define RDAC_LOG_SENSE		2
> > +
> > +#define RDAC_LOG_BITS		2
> > +
> > +#define RDAC_LOG_LEVEL(SHIFT)  \
> > +        ((rdac_logging >> (SHIFT)) & ((1 << (RDAC_LOG_BITS)) - 1))
> > +
> > +#define RDAC_DEBUG(SHIFT, sdev, f, arg...) \
>=20
> instead of RDAC_DEBUG, we can say RDAC_LOG ?!

Sure.. I will do that..

>=20
> > +do { \
> > +	if (unlikely(RDAC_LOG_LEVEL(SHIFT))) \
> > +		sdev_printk(KERN_INFO, sdev, RDAC_NAME ": " f "\n", ##
> arg); \
> > +} while (0);
> > +
> >  static inline struct rdac_dh_data *get_rdac_data(struct scsi_devic=
e
> *sdev)
> >  {
> >  	struct scsi_dh_data *scsi_dh_data =3D sdev->scsi_dh_data;
> > @@ -324,6 +351,13 @@ static struct rdac_controller *get_contr
> >  	/* initialize fields of controller */
> >  	memcpy(ctlr->subsys_id, subsys_id, SUBSYS_ID_LEN);
> >  	memcpy(ctlr->slot_id, slot_id, SLOT_ID_LEN);
> > +
> > +	/* update the controller index */
> > +	if (slot_id[1] =3D=3D 0x31)
> > +		ctlr->index =3D 0;
> > +	else
> > +		ctlr->index =3D 1;
> > +
> >  	kref_init(&ctlr->kref);
> >  	ctlr->use_ms10 =3D -1;
> >  	list_add(&ctlr->node, &ctlr_list);
> > @@ -381,6 +415,26 @@ static int get_lun(struct scsi_device *s
> >  	return err;
> >  }
> >
> > +static int get_array_name(struct scsi_device *sdev, struct
> rdac_dh_data *h)
> > +{
> > +	int err, i;
> > +	struct c8_inquiry *inqp;
> > +
> > +	err =3D submit_inquiry(sdev, 0xC8, sizeof(struct c8_inquiry), h);
> > +	if (err =3D=3D SCSI_DH_OK) {
> > +		inqp =3D &h->inq.c8;
> > +		if (inqp->page_code !=3D 0xc8)
> > +			return SCSI_DH_NOSYS;
> > +
> > +		for(i=3D0; i<30; ++i) {
> > +			h->ctlr->array_name[i] =3D inqp-
> >array_user_label[(2*i)+1];
> > +		}
>=20
> do not have to have { } for a single line loop.

Sure.. I will remove that..

>=20
> > +		h->ctlr->array_name[30] =3D '\0';
> > +	}
> > +
> > +	return err;
> > +}
> > +
> >  static int check_ownership(struct scsi_device *sdev, struct
> rdac_dh_data *h)
> >  {
> >  	int err;
> > @@ -450,13 +504,12 @@ static int mode_select_handle_sense(stru
> >  {
> >  	struct scsi_sense_hdr sense_hdr;
> >  	int err =3D SCSI_DH_IO, ret;
> > +	struct rdac_dh_data *h =3D get_rdac_data(sdev);
> >
> >  	ret =3D scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE,
> &sense_hdr);
> >  	if (!ret)
> >  		goto done;
> >
> > -	err =3D SCSI_DH_OK;
> > -
>=20
> This is a change in behavior.
>=20
> Why is this needed ?

Setting the flag by default to SCSI_DH_OK might wrongly report the comm=
and as success even though the command had failed. The switch statement=
 here only lists certain check conditions. If the target returns the ch=
eck conditions other than the listed here then this function will retur=
n SCSI_DH_OK which is not correct.

>=20
> >  	switch (sense_hdr.sense_key) {
> >  	case NO_SENSE:
> >  	case ABORTED_COMMAND:
> > @@ -478,12 +531,15 @@ static int mode_select_handle_sense(stru
> >  			err =3D SCSI_DH_RETRY;
> >  		break;
> >  	default:
> > -		sdev_printk(KERN_INFO, sdev,
> > -			    "MODE_SELECT failed with sense
> %02x/%02x/%02x.\n",
> > -			    sense_hdr.sense_key, sense_hdr.asc,
> sense_hdr.ascq);
> > +		break;
> >  	}
> >
> >  done:
> > +	RDAC_DEBUG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
> > +		"MODE_SELECT returned with sense %02x/%02x/%02x",
> > +		(char *) h->ctlr->array_name, h->ctlr->index,
> > +		sense_hdr.sense_key, sense_hdr.asc, sense_hdr.ascq);
> > +
>=20
> May need to be moved above "done:", as the control comes to done when
> scsi_normalize_sense() fails.

Sometimes we have seen target returning invalid sense. We need to catch=
 that as well. That is the reason we moved this after done.

>=20
> >
> >  	return err;
> >  }
> >
> > @@ -499,7 +555,9 @@ retry:
> >  	if (!rq)
> >  		goto done;
> >
> > -	sdev_printk(KERN_INFO, sdev, "%s MODE_SELECT command.\n",
> > +	RDAC_DEBUG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
> > +		"%s MODE_SELECT command",
> > +		(char *) h->ctlr->array_name, h->ctlr->index,
> >  		(retry_cnt =3D=3D RDAC_RETRY_COUNT) ? "queueing" : "retrying");
> >
> >  	err =3D blk_execute_rq(q, NULL, rq, 1);
> > @@ -509,8 +567,12 @@ retry:
> >  		if (err =3D=3D SCSI_DH_RETRY && retry_cnt--)
> >  			goto retry;
> >  	}
> > -	if (err =3D=3D SCSI_DH_OK)
> > +	if (err =3D=3D SCSI_DH_OK) {
> >  		h->state =3D RDAC_STATE_ACTIVE;
> > +		RDAC_DEBUG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
> > +				"MODE_SELECT completed",
> > +				(char *) h->ctlr->array_name, h->ctlr->index);
> > +	}
> Don;t you think we need to have failure also reported ?

=46ailure will be anyway reported by the function mode_select_handle_se=
nse. Did not want to print that again.

>=20
> >
> >  done:
> >  	return err;
> > @@ -525,12 +587,6 @@ static int rdac_activate(struct scsi_dev
> >  	if (err !=3D SCSI_DH_OK)
> >  		goto done;
> >
> > -	if (!h->ctlr) {
> > -		err =3D initialize_controller(sdev, h);
> > -		if (err !=3D SCSI_DH_OK)
> > -			goto done;
> > -	}
> > -
>=20
> You can also move the set_mode_select block below.

Sure.. I will do that..

>=20
> >  	if (h->ctlr->use_ms10 =3D=3D -1) {
> >  		err =3D set_mode_select(sdev, h);
> >  		if (err !=3D SCSI_DH_OK)
> > @@ -559,6 +615,12 @@ static int rdac_check_sense(struct scsi_
> >  				struct scsi_sense_hdr *sense_hdr)
> >  {
> >  	struct rdac_dh_data *h =3D get_rdac_data(sdev);
> > +
> > +	RDAC_DEBUG(RDAC_LOG_SENSE, sdev, "array %s, ctlr %d, "
> > +			"command returned with sense %02x/%02x/%02x",
> > +			(char *) h->ctlr->array_name, h->ctlr->index,
> > +			sense_hdr->sense_key, sense_hdr->asc, sense_hdr-
> >ascq);
> > +
>=20
> It is not a "command", right ? Code comes here for any I/O failure.
> cut-n-paste problem :)

I was in a confusion about what will be the right word here. Ok.. I wil=
l use "I/O"

>=20
>=20
> >  	switch (sense_hdr->sense_key) {
> >  	case NOT_READY:
> >  		if (sense_hdr->asc =3D=3D 0x04 && sense_hdr->ascq =3D=3D 0x01)
> > @@ -678,6 +740,16 @@ static int rdac_bus_attach(struct scsi_d
> >  	if (err !=3D SCSI_DH_OK)
> >  		goto failed;
> >
> > +	if (!h->ctlr) {
>=20
> I do not think we need this check here.

You are right.. We don=92t need this check here..

> > +		err =3D initialize_controller(sdev, h);
> > +		if (err !=3D SCSI_DH_OK)
> > +			goto failed;
> > +
> > +		err =3D get_array_name(sdev, h);
> > +		if (err !=3D SCSI_DH_OK)
> > +			goto failed;
> > +	}
> > +
> >  	if (!try_module_get(THIS_MODULE))
> >  		goto failed;
> >
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scs=
i"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
