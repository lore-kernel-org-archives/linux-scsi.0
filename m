From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [TRIVIAL] Patch for linux 2.5.32
Date: Tue, 10 Sep 2002 13:01:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020910130143.A15963@eng2.beaverton.ibm.com>
References: <20020910092648.4A4AB2C2A2@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020910092648.4A4AB2C2A2@lists.samba.org>; from rusty@rustcorp.com.au on Tue, Sep 10, 2002 at 07:18:53PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Rusty Trivial Russell <rusty@rustcorp.com.au>, Josef <josef.moellers@fujitsu-siemens.com>
Cc: linux-scsi@vger.kernel.org

It is sane, but Josef -

Do devices that are adding BLIST_LARGELUN have a way to configure their
scsi level? Most disk arrays built in the last 3 years (or more) can
modify the scsi level they report. Changing the scsi level to 3 or high=
er
is preferable to adding a BLIST_LARGELUN.

Do devices that are adding BLIST_SPARSELUN or BLIST_FORCELUN have
SCSI REPORT LUNS support? If so SCSI REPORT LUN probing/scanning is
preferable and neither flag is needed; also, a SCSI REPORT LUN will
only be used if the scsi level is greater than 2.

-- Patrick Mansfield

On Tue, Sep 10, 2002 at 07:18:53PM +1000, Rusty Trivial Russell wrote:
> [ This patch had no attached comment: is it sane? --RR ]
> From:  Josef <josef.moellers@fujitsu-siemens.com>
>=20
>   --=20
>   Josef M=F6llers (Pinguinpfleger bei FSC)
>   	If failure had no penalty success would not be a prize
>   						-- T.  Pratchett--- linux-2.5.32/drivers/scsi/scsi_scan.c	Thu=
 Aug 29 10:37:55 2002
>=20
> --- trivial-2.5.34/drivers/scsi/scsi_scan.c.orig	2002-09-10 19:10:54.=
000000000 +1000
> +++ trivial-2.5.34/drivers/scsi/scsi_scan.c	2002-09-10 19:10:54.00000=
0000 +1000
> @@ -162,8 +162,8 @@
>  	{"TOSHIBA", "CDROM", NULL, BLIST_ISROM},
>  	{"TOSHIBA", "CD-ROM", NULL, BLIST_ISROM},
>  	{"MegaRAID", "LD", NULL, BLIST_FORCELUN},
> -	{"DGC", "RAID", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, storage on=
 LUN 0 */
> -	{"DGC", "DISK", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, no storage=
 on LUN 0 */
> +        {"DGC", "DISK", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLI=
ST_FORCELUN },
> +        {"DGC", "RAID ", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BL=
IST_FORCELUN },
>  	{"DELL", "PV660F", NULL, BLIST_SPARSELUN},
>  	{"DELL", "PV660F   PSEUDO", NULL, BLIST_SPARSELUN},
>  	{"DELL", "PSEUDO DEVICE .", NULL, BLIST_SPARSELUN},	/* Dell PV 530F=
 */
> @@ -183,6 +183,10 @@
>  	{"COMPAQ", "MSA1000", NULL, BLIST_FORCELUN},
>  	{"HP", "C1557A", NULL, BLIST_FORCELUN},
>  	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
> +        {"EUROLOGC", "FC2502", NULL, BLIST_SPARSELUN | BLIST_LARGELU=
N | BLIST_FORCELUN },
> +        {"FSC FC47", "DISK", NULL, BLIST_SPARSELUN | BLIST_LARGELUN =
| BLIST_FORCELUN },
> +        {"FSC FC47", "RAID ", NULL, BLIST_SPARSELUN | BLIST_LARGELUN=
 | BLIST_FORCELUN },
> +        {"MYLEX", "DACARMRB", NULL, BLIST_SPARSELUN | BLIST_LARGELUN=
 | BLIST_FORCELUN },
>  };
> =20
>  #define ALLOC_FAILURE_MSG	KERN_ERR "%s: Allocation failure during" \
> --=20
>   Don't blame me: the Monkey is driving
>   File: Josef =3D?iso-8859-1?Q?M=3DF6llers?=3D <josef.moellers@fujits=
u-siemens.com>: Patch for linux 2.5.32
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
