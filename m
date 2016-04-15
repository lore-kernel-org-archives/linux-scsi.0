From: Hannes Reinecke <hare@suse.de>
Subject: Re: [patch v2] scsi_dh_alua: uninitialized variable in alua_rtpg()
Date: Fri, 15 Apr 2016 07:59:30 +0200
Message-ID: <57108342.2070106@suse.de>
References: <20160414182034.GA32469@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbcDOF7c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 01:59:32 -0400
In-Reply-To: <20160414182034.GA32469@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Johannes Thumshirn <jthumshirn@suse.de>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On 04/14/2016 08:20 PM, Dan Carpenter wrote:
> It's possible to use "err" without initializing it.  If it happens to=
 be
> a 2 which is SCSI_DH_RETRY then that could cause a bug.  Bart Van Ass=
che
> pointed out that we should probably re-initialize it for every iterat=
ion
> through the retry loop.
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: The first version just initialized it at the start of the functio=
n.
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scs=
i/device_handler/scsi_dh_alua.c
> index 8eaed05..a655cf2 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -532,6 +532,7 @@ static int alua_rtpg(struct scsi_device *sdev, st=
ruct alua_port_group *pg)
>  		return SCSI_DH_DEV_TEMP_BUSY;
> =20
>   retry:
> +	err =3D 0;
>  	retval =3D submit_rtpg(sdev, buff, bufflen, &sense_hdr, pg->flags);
> =20
>  	if (retval) {
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
