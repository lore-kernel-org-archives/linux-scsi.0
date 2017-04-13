From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 3/4] scsi: scsi_dh_alua: print changes to RTPG state of
 other PGs too
Date: Thu, 13 Apr 2017 21:35:54 +0000
Message-ID: <1492119352.24345.26.camel@sandisk.com>
References: <1491873481-23900-1-git-send-email-mauricfo@linux.vnet.ibm.com>
         <1491873481-23900-4-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:10012 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751404AbdDMVf5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Apr 2017 17:35:57 -0400
In-Reply-To: <1491873481-23900-4-git-send-email-mauricfo@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <858F6B141D79A44589C40DEB87B1F1BF@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2017-04-10 at 22:18 -0300, Mauricio Faria de Oliveira wrote:
> Currently, alua_rtpg() can change the 'state' and 'preferred'
> values for the current port group _and_ of other port groups
> present in the response buffer/descriptors.
>=20
> However, it reports such changes _only_ for the current port
> group (i.e., only for 'pg' but not for 'tmp_pg').
>=20
> This might cause uncertainty and confusion when going through
> the kernel logs for analyzing/debugging scsi_dh_alua behavior,
> which is not helpful during support and development scenarios.
>=20
> So, print such changes for other port groups than the current
> one.
>=20
> This requires finding a scsi_device to call sdev_printk() with
> for that other port group. Using 'tmp_pg->rtpg_sdev' is not an
> option because in that 'if' conditional the 'tmp_pg' is not in
> the ALUA_PG_RUNNING state, so that pointer may be NULL. So the
> for-loop over the tmp->pg device_handler structures is used to
> find a valid scsi_device that is associated to this port group.
>=20
> Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/de=
vice_handler/scsi_dh_alua.c
> index 0d3508f2e285..c2c9173fd883 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -688,6 +688,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct=
 alua_port_group *pg)
>  				if ((tmp_pg =3D=3D pg) ||
>  				    !(tmp_pg->flags & ALUA_PG_RUNNING)) {
>  					struct alua_dh_data *h;
> +					struct scsi_device *tmp_pg_sdev =3D NULL;
> =20
>  					tmp_pg->state =3D desc[0] & 0x0f;
>  					tmp_pg->pref =3D desc[0] >> 7;
> @@ -697,6 +698,17 @@ static int alua_rtpg(struct scsi_device *sdev, struc=
t alua_port_group *pg)
>  						/* h->sdev should always be valid */
>  						BUG_ON(!h->sdev);
>  						h->sdev->access_state =3D desc[0];
> +
> +						/*
> +						 * If tmp_pg is not the running pg, and its worker
> +						 * is not running, tmp_pg->rtpg_sdev might be NULL.
> +						 * Use another/one associated scsi_device to print
> +						 * its RTPG information.
> +						 */
> +						if ((tmp_pg !=3D pg) && !tmp_pg_sdev) {
> +							tmp_pg_sdev =3D h->sdev;
> +							alua_rtpg_print(tmp_pg_sdev, tmp_pg, NULL);
> +						}
>  					}
>  					rcu_read_unlock();
>  				}

Hello Mauricio,

Please consider moving the alua_rtpg_print() call out of the loop. That wil=
l
not only allow to eliminate the tmp_pg_sdev variable but will also reduce t=
he
nesting depth of the code. E.g. something like the following (untested) cod=
e:

					list_for_each_entry_rcu(h,
						&tmp_pg->dh_list, node) {
						[ ... ]
					}
+=A0					h =3D list_first_or_null_rcu(&tmp_pg->dh_list, typeof(*h), node);
+=A0					if (tmp_pg !=3D pg && h)
+=A0						alua_rtpg_print(h->sdev, tmp_pg, NULL);
=A0					rcu_read_unlock();

Thanks,

Bart.=
