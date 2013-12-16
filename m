From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 32/32] target: Increase MAX_LUNS_PER_TPG to 16384
Date: Mon, 16 Dec 2013 10:20:12 +0100
Message-ID: <52AEC5CC.9050701@suse.de>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com> <1386979160-6928-33-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386979160-6928-33-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/14/2013 12:59 AM, Andy Grover wrote:
> Indicate support for hierarchical LUN addressing.
>=20
> Set address method field in each LUN reported by REPORT LUNS to 1, in
> accordance with SCSI SAM specs.
>=20
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_spc.c  |    8 ++++++--
>  include/target/target_core_base.h |    4 ++--
>  2 files changed, 8 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target=
_core_spc.c
> index 0b678fc..04690bf 100644
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c
> @@ -79,7 +79,7 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigne=
d char *buf)
>  	buf[2] =3D 0x05; /* SPC-3 */
> =20
>  	/*
> -	 * NORMACA and HISUP =3D 0, RESPONSE DATA FORMAT =3D 2
> +	 * NORMACA =3D 0, HISUP =3D 1, RESPONSE DATA FORMAT =3D 2
>  	 *
>  	 * SPC4 says:
>  	 *   A RESPONSE DATA FORMAT field set to 2h indicates that the
> @@ -88,7 +88,7 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigne=
d char *buf)
>  	 *   obsolete. Response data format values greater than 2h are
>  	 *   reserved.
>  	 */
> -	buf[3] =3D 2;
> +	buf[3] =3D 0x12;
> =20
>  	/*
>  	 * Enable SCCS and TPGS fields for Emulated ALUA
> @@ -1164,6 +1164,10 @@ sense_reason_t spc_emulate_report_luns(struct =
se_cmd *cmd)
>  			break;
> =20
>  		int_to_scsilun(deve->mapped_lun, (struct scsi_lun *)&buf[offset]);
> +
> +		/* Address method 1 for hier flat-space address. see SAM-5 */
> +		buf[offset] |=3D (1 << 6);
> +
>  		offset +=3D 8;
>  	}
>  	spin_unlock_irq(&sess->se_node_acl->device_list_lock);
> diff --git a/include/target/target_core_base.h b/include/target/targe=
t_core_base.h
> index 08ecfed..537cc67 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -14,8 +14,8 @@
>  #define TARGET_CORE_VERSION		TARGET_CORE_MOD_VERSION
> =20
>  /* Maximum Number of LUNs per Target Portal Group */
> -/* Don't raise above 511 or REPORT_LUNS needs to handle >1 page */
> -#define TRANSPORT_MAX_LUNS_PER_TPG		256
> +/* Don't raise above 16384 or a different format in report_luns is n=
eeded */
> +#define TRANSPORT_MAX_LUNS_PER_TPG		16384
>  /*
>   * By default we use 32-byte CDBs in TCM Core and subsystem plugin c=
ode.
>   *
>=20
NO WAY.

TCM is (currently) keeping the LUNs in a static array.
Which is sort-of-okay if the number of LUNs is somewhat reasonable,
as it was for 256.
But 16k is way beyond any sensible number and will increase the
memory footprint by a massive amount, irrespective whether someone
will actually _use_ such a large number of LUNs.

Before attempting that one would need to convert the LUN array into
something scalable, like a linked list or somesuch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
