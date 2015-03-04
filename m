From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, resend] IB/srp: Add 64-bit LUN support
Date: Wed, 04 Mar 2015 14:16:22 +0100
Message-ID: <1425474982.3069.21.camel@opteya.com>
References: <54F6D7ED.3080606@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54F6D7ED.3080606-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Nathan Fontenot <nfont-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Tyrel Datwyler <tyreld-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

Le mercredi 04 mars 2015 =C3=A0 11:01 +0100, Bart Van Assche a =C3=A9cr=
it :
> The SCSI standard defines 64-bit values for LUNs. Large arrays
> employing large or hierarchical LUN numbers become more and more
> common. So update the SRP initiator to use 64-bit LUN numbers.
> See also Hannes Reinecke, commit 9cb78c16f5da ("scsi: use 64-bit LUNs=
"),
> June 2014.
>=20

Thanks for the added description.

> The largest LUN number that has been tested is 0xd2003fff00000000.
>=20
> Checked the following structure sizes with gdb:
> * sizeof(struct srp_cmd) =3D 48
> * sizeof(struct srp_tsk_mgmt) =3D 48
> * sizeof(struct srp_aer_req) =3D 36
>=20
> The ibmvscsi changes have been compile tested only on a PPC system.
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Reviewed-by: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Cc: Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Cc: Nathan Fontenot <nfont-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Cc: Tyrel Datwyler <tyreld-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 12 ++++++------
>  drivers/scsi/ibmvscsi/ibmvscsi.c    |  6 +++---
>  include/scsi/srp.h                  |  7 ++++---
>  3 files changed, 13 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband=
/ulp/srp/ib_srp.c
> index a0e24a8..e427454 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -3146,7 +3146,7 @@ static ssize_t srp_create_target(struct device =
*dev,
>  	target_host->transportt  =3D ib_srp_transport_template;
>  	target_host->max_channel =3D 0;
>  	target_host->max_id      =3D 1;
> -	target_host->max_lun     =3D SRP_MAX_LUN;
> +	target_host->max_lun     =3D -1LL;

I guess you can remove SRP_MAX_LUN from
drivers/infiniband/ulp/srp/ib_srp.h too.

>  	target_host->max_cmd_len =3D sizeof ((struct srp_cmd *) (void *) 0L=
)->cdb;
> =20
>  	target =3D host_to_target(target_host);

> diff --git a/include/scsi/srp.h b/include/scsi/srp.h
> index 1ae84db..5be834d 100644
> --- a/include/scsi/srp.h
> +++ b/include/scsi/srp.h
> @@ -42,6 +42,7 @@
>   */
> =20
>  #include <linux/types.h>
> +#include <scsi/scsi.h>
> =20
>  enum {
>  	SRP_LOGIN_REQ	=3D 0x00,

@@ -54,7 +54,6 @@ enum {
        SRP_DLID_REDIRECT       =3D 2,
        SRP_STALE_CONN          =3D 3,
=20
-       SRP_MAX_LUN             =3D 512,
        SRP_DEF_SG_TABLESIZE    =3D 12,
=20
        SRP_DEFAULT_QUEUE_SIZE  =3D 1 << 6,


Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
