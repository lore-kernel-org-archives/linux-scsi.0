From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi/libata: Support variable-length cdb of ata
 pass-thru(32).
Date: Wed, 21 Jun 2017 18:52:31 +0000
Message-ID: <1498071149.2746.26.camel@wdc.com>
References: <1497697243-3724-1-git-send-email-dn3108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1497697243-3724-1-git-send-email-dn3108@gmail.com>
Content-Language: en-US
Content-ID: <BC04648527C99B408CFF3E670EF6B776@namprd04.prod.outlook.com>
Sender: linux-ide-owner@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "tj@kernel.org" <tj@kernel.org>, "dn3108@gmail.com" <dn3108@gmail.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2017-06-17 at 20:00 +0900, Minwoo Im wrote:=20
> -	if ((tf->protocol =3D ata_scsi_map_proto(cdb[1])) =3D=3D ATA_PROT_UNKNO=
WN) {
> +	/*
> +	 * if SCSI operation code in cdb[0] is ATA_12 or ATA_16,
> +	 * then cdb[1] will contain protocol of ATA PASS-THROUGH.
> +	 * otherwise, Its operation code shall be ATA_32(7Fh).
> +	 * in this case, cdb[10] will contain protocol of it.
> +	 * we call this command as a variable-length cdb.
> +	 */
> +	if (cdb[0] =3D=3D ATA_12 || cdb[0] =3D=3D ATA_16)
> +		tf->protocol =3D ata_scsi_map_proto(cdb[1]);
> +	else
> +		tf->protocol =3D ata_scsi_map_proto(cdb[10]);
> +
> +	if (tf->protocol =3D=3D ATA_PROT_UNKNOWN) {
>  		fp =3D 1;
>  		goto invalid_fld;
>  	}

Hello Minwoo,

Please consider introducing a variable (e.g. called "cdb_offset") in which =
the
value 9 is stored for 32-byte CDBs and 0 for 12-byte and 16-byte CDBs. That
will allow to rewrite the above code as follows:

	tf->protocol =3D ata_scsi_map_proto(cdb[1 + cdb_offset])

I think that will allow to remove most "if (cdb[0] =3D=3D ATA_12 || cdb[0] =
=3D=3D ATA_16)"
statements introduced by this patch.

> +		tf->auxiliary =3D (cdb[28] << 24) | (cdb[29] << 16)
> +			| (cdb[30] << 8) | cdb[31];

Please use get_unaligned_be32() instead of open-coding it.

> +	const u16 sa =3D (cdb[8] >> 8) | cdb[9];	/* service action */

Please use get_unaligned_be16() instead of open-coding it.

> @@ -4385,7 +4463,12 @@ int ata_scsi_add_hosts(struct ata_host *host, stru=
ct scsi_host_template *sht)
>  		shost->max_id =3D 16;
>  		shost->max_lun =3D 1;
>  		shost->max_channel =3D 1;
> -		shost->max_cmd_len =3D 16;
> +		/*
> +		 * SPC-3, SPC-4: Definition of CDB
> +		 * A CDB may have a fixed length of up to 16 bytes or
> +		 * variable length of between 12 and 260 bytes.
> +		 */
> +		shost->max_cmd_len =3D 260;

Does ATA pass-through really support 260-byte CDBs or is the maximum CDB le=
ngth
that is supported by ATA_32 perhaps 32 bytes?

Thanks,

Bart.=
