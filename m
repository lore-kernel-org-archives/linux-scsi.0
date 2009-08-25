From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 1/3] scsi_dh_rdac: Adding more debug options for scsi
	rdac handler
Date: Tue, 25 Aug 2009 16:50:19 -0700
Message-ID: <1251244219.2166.26.camel@chandra-ubuntu>
References: <E463DF2B2E584B4A82673F53D62C2EF474BFD90E@cosmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:38533 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473AbZHYXuQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Aug 2009 19:50:16 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e39.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7PNjDHD020119
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2009 17:45:13 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7PNoIwF168312
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2009 17:50:18 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7PNoHTk010275
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2009 17:50:18 -0600
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474BFD90E@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, device-mapper development <dm-devel@redhat.com>


On Mon, 2009-08-24 at 18:11 -0600, Moger, Babu wrote:
> Adding the code to read the debug information during activate. This p=
atch collects
>  the information about storage and controllers during rdac_activate.
> =20
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
>=20
> ---
> --- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	=
2009-08-24 11:54:41.000000000 -0500
> +++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-=
08-24 12:08:33.000000000 -0500
> @@ -112,6 +112,7 @@ struct c9_inquiry {
> =20
>  #define SUBSYS_ID_LEN	16
>  #define SLOT_ID_LEN	2
> +#define ARRAY_LABEL_LEN	31
> =20
>  struct c4_inquiry {
>  	u8	peripheral_info;
> @@ -135,6 +136,8 @@ struct rdac_controller {
>  		struct rdac_pg_legacy legacy;
>  		struct rdac_pg_expanded expanded;
>  	} mode_select;
> +	u8			index;
> +	u8			array_name[ARRAY_LABEL_LEN];
cosmetic... align with the above code (peripheral_info)

>  };
>  struct c8_inquiry {
>  	u8	peripheral_info;
> @@ -324,6 +327,13 @@ static struct rdac_controller *get_contr
>  	/* initialize fields of controller */
>  	memcpy(ctlr->subsys_id, subsys_id, SUBSYS_ID_LEN);
>  	memcpy(ctlr->slot_id, slot_id, SLOT_ID_LEN);
> +
> +	/* update the controller index */
> +	if (slot_id[1] =3D=3D 0x31)
> +		ctlr->index =3D 0;
> +	else
> +		ctlr->index =3D 1;
> +
>  	kref_init(&ctlr->kref);
>  	ctlr->use_ms10 =3D -1;
>  	list_add(&ctlr->node, &ctlr_list);
> @@ -381,6 +391,26 @@ static int get_lun(struct scsi_device *s
>  	return err;
>  }
> =20
> +static int get_array_name(struct scsi_device *sdev, struct rdac_dh_d=
ata *h)
> +{
> +	int err, i;
> +	struct c8_inquiry *inqp;
> +
> +	err =3D submit_inquiry(sdev, 0xC8, sizeof(struct c8_inquiry), h);
> +	if (err =3D=3D SCSI_DH_OK) {
> +		inqp =3D &h->inq.c8;
> +		if (inqp->page_code !=3D 0xc8)
> +			return SCSI_DH_NOSYS;
> +
> +		for(i=3D0; i<30; ++i)

Use the macro name above instead of literal "30"

> +			h->ctlr->array_name[i] =3D inqp->array_user_label[(2*i)+1];
> +
> +		h->ctlr->array_name[30] =3D '\0';

Use the macro name above instead of literal "30"

> +	}
> +		=09
> +	return err;
> +}
> +
>  static int check_ownership(struct scsi_device *sdev, struct rdac_dh_=
data *h)
>  {
>  	int err;
> @@ -529,6 +559,10 @@ static int rdac_activate(struct scsi_dev
>  		err =3D initialize_controller(sdev, h);
>  		if (err !=3D SCSI_DH_OK)
>  			goto done;
> +
> +		err =3D get_array_name(sdev, h);
> +		if (err !=3D SCSI_DH_OK)
> +			goto done;
>  	}
> =20
>  	if (h->ctlr->use_ms10 =3D=3D -1) {
>=20
>=20
> &#0;NrybX=C7=A7v^)=DE=BA{.n+{"{ay=1D=CA=87=DA=99,j=07fhz=1Ew=0Cj:+vwj=
m=07zZ+=DD=A2j"!

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
