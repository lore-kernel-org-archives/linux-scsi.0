From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] aacraid: Fix out of bounds in aac_get_name_resp
Date: Fri, 4 Aug 2017 15:40:42 +0000
Message-ID: <1501861241.2757.7.camel@wdc.com>
References: <150184390108.30112.458253019139897272.stgit@rslab209.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:57564 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752490AbdHDPla (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 11:41:30 -0400
In-Reply-To: <150184390108.30112.458253019139897272.stgit@rslab209.pmc-sierra.bc.ca>
Content-Language: en-US
Content-ID: <143477F7CA1E8346BAF485794C477618@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "RaghavaAditya.Renukunta@microsemi.com" <RaghavaAditya.Renukunta@microsemi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>, "david.carroll@microsemi.com" <david.carroll@microsemi.com>, "gana.sridaran@microsemi.com" <gana.sridaran@microsemi.com>

On Fri, 2017-08-04 at 03:51 -0700, Raghava Aditya Renukunta wrote:
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.=
c
> index 707ee2f5954d..a875175d58d1 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -549,7 +549,9 @@ static void get_container_name_callback(void *context=
, struct fib * fibptr)
>  	if ((le32_to_cpu(get_name_reply->status) =3D=3D CT_OK)
>  	 && (get_name_reply->data[0] !=3D '\0')) {
>  		char *sp =3D get_name_reply->data;
> -		sp[sizeof(((struct aac_get_name_resp *)NULL)->data)] =3D '\0';
> +		int data_size =3D FIELD_SIZEOF(struct aac_get_name_resp, data);
> +
> +		sp[data_size - 1] =3D '\0';
>  		while (*sp =3D=3D ' ')
>  			++sp;
>  		if (*sp) {
> @@ -579,12 +581,15 @@ static void get_container_name_callback(void *conte=
xt, struct fib * fibptr)
>  static int aac_get_container_name(struct scsi_cmnd * scsicmd)
>  {
>  	int status;
> +	int data_size;
>  	struct aac_get_name *dinfo;
>  	struct fib * cmd_fibcontext;
>  	struct aac_dev * dev;
> =20
>  	dev =3D (struct aac_dev *)scsicmd->device->host->hostdata;
> =20
> +	data_size =3D FIELD_SIZEOF(struct aac_get_name_resp, data);
> +
>  	cmd_fibcontext =3D aac_fib_alloc_tag(dev, scsicmd);
> =20
>  	aac_fib_init(cmd_fibcontext);
> @@ -593,7 +598,7 @@ static int aac_get_container_name(struct scsi_cmnd * =
scsicmd)
>  	dinfo->command =3D cpu_to_le32(VM_ContainerConfig);
>  	dinfo->type =3D cpu_to_le32(CT_READ_NAME);
>  	dinfo->cid =3D cpu_to_le32(scmd_id(scsicmd));
> -	dinfo->count =3D cpu_to_le32(sizeof(((struct aac_get_name_resp *)NULL)-=
>data));
> +	dinfo->count =3D cpu_to_le32(data_size - 1);
> =20
>  	status =3D aac_fib_send(ContainerCommand,
>  		  cmd_fibcontext,
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacrai=
d.h
> index 69812994b81e..92fabf2b0c24 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -2275,7 +2275,7 @@ struct aac_get_name_resp {
>  	__le32		parm3;
>  	__le32		parm4;
>  	__le32		parm5;
> -	u8		data[16];
> +	u8		data[17];
>  };
> =20
>  #define CT_CID_TO_32BITS_UID 165

Hello Raghava,

This patch would have been more brief if FIELD_SIZEOF(struct aac_get_name_r=
esp, data)
would have been used directly instead of introducing the new local variable=
 'data_size'.
Anyway:

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
