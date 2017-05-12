From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 3/4] scsi_dh_alua: do not call BUG_ON when updating
 port group
Date: Fri, 12 May 2017 16:24:23 +0000
Message-ID: <1494606261.14477.3.camel@sandisk.com>
References: <20170512131508.3231-1-mwilck@suse.com>
         <20170512131508.3231-4-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:26004 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932922AbdELQY0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 May 2017 12:24:26 -0400
In-Reply-To: <20170512131508.3231-4-mwilck@suse.com>
Content-Language: en-US
Content-ID: <05EBE37EA09CCA4BB5CBFFC5975C28A7@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "mwilck@suse.com" <mwilck@suse.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2017-05-12 at 15:15 +0200, Martin Wilck wrote:
> alua_rtpg() can race with alua_bus_detach(). The assertion that
> alua_dh_data *h->sdev must be non-NULL is not guaranteed because
> alua_bus_detach sets this field to NULL before removing the entry
> from the port group's dh_list.
>=20
> This happens when a device is about to be removed, so don't BUG out
> but continue silently.
>=20
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/de=
vice_handler/scsi_dh_alua.c
> index 2b60f493f90e..a59783020c66 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -652,9 +652,15 @@ static int alua_rtpg(struct scsi_device *sdev, struc=
t alua_port_group *pg)
>  					rcu_read_lock();
>  					list_for_each_entry_rcu(h,
>  						&tmp_pg->dh_list, node) {
> -						/* h->sdev should always be valid */
> -						BUG_ON(!h->sdev);
> -						h->sdev->access_state =3D desc[0];
> +						/*
> +						 * We might be racing with
> +						 * alua_bus_detach here
> +						 */
> +						struct scsi_device *sdev =3D
> +							h->sdev;
> +						if (sdev)
> +							sdev->access_state =3D
> +								desc[0];
>  					}
>  					rcu_read_unlock();
>  				}
> @@ -694,11 +700,13 @@ static int alua_rtpg(struct scsi_device *sdev, stru=
ct alua_port_group *pg)
>  			pg->expiry =3D 0;
>  			rcu_read_lock();
>  			list_for_each_entry_rcu(h, &pg->dh_list, node) {
> -				BUG_ON(!h->sdev);
> -				h->sdev->access_state =3D
> +				struct scsi_device *sdev =3D h->sdev;
> +				if (!sdev)
> +					continue;
> +				sdev->access_state =3D
>  					(pg->state & SCSI_ACCESS_STATE_MASK);
>  				if (pg->pref)
> -					h->sdev->access_state |=3D
> +					sdev->access_state |=3D
>  						SCSI_ACCESS_STATE_PREFERRED;
>  			}
>  			rcu_read_unlock();

Hello Martin,

Allowing races like the one this patch tries to address to exist makes
the ALUA code harder to maintain than necessary. Have you considered to
make alua_bus_detach() wait until ALUA work has finished by using e.g.
cancel_work_sync() or rcu_synchronize()?

Bart.=
