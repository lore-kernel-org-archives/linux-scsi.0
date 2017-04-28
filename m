From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 3/3] scsi_dh_alua: do not call BUG_ON when updating port
 group
Date: Fri, 28 Apr 2017 19:58:08 +0000
Message-ID: <1493409488.2767.17.camel@sandisk.com>
References: <20170428130626.32162-1-mwilck@suse.com>
         <20170428130626.32162-4-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:1633 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161974AbdD1T6N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2017 15:58:13 -0400
In-Reply-To: <20170428130626.32162-4-mwilck@suse.com>
Content-Language: en-US
Content-ID: <0B1E51FFEE1FCB4EB489D4991645B463@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "mwilck@suse.com" <mwilck@suse.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2017-04-28 at 15:06 +0200, Martin Wilck wrote:
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/de=
vice_handler/scsi_dh_alua.c
> index 501855bde633..274fb49d0801 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -652,9 +652,13 @@ static int alua_rtpg(struct scsi_device *sdev, struc=
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
> +						if (h->sdev)
> +							h->sdev->access_state =3D
> +								desc[0];
>  					}
>  					rcu_read_unlock();
>  				}

Hello Hannes and Martin,

What will happen if h->sdev is cleared after it has been tested and before
it is dereferenced? Additionally, even if h->sdev would be cached, can the
following sequence of events happen?
*=A0alua_rtpg() tests h->sdev.
* alua_bus_detach() clears h->sdev.
* h->sdev is freed.
* alua_rtpg() dereferences h->sdev.

Thanks,

Bart.=
