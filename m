From: =?ISO-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>
Subject: Re: Making sym-2 do 160 MB/sec
Date: Sun, 2 Mar 2003 10:35:44 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030302101738.W187-100000@localhost.my.domain>
References: <20030219120639.3df58497.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030219120639.3df58497.akpm@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: linux-scsi@vger.kernel.org



On Wed, 19 Feb 2003, Andrew Morton wrote:

>
> I have a machine here in which both the controller (53c1010) and the =
disk
> (IBM IC35L036UCD210-0) can do FAST-80, but the sym2 driver only does =
=46AST-40.
>
> The below patch fixes it up, and has been fearsomely tested.
>
> Can anyone tell me whether it is right, and what is generally going o=
n in
> there?
>
>
> diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.c~sym-do-160 drivers/scsi=
/sym53c8xx_2/sym_hipd.c
> --- 25-power4/drivers/scsi/sym53c8xx_2/sym_hipd.c~sym-do-160	2003-02-=
19 01:04:59.000000000 -0800
> +++ 25-power4-akpm/drivers/scsi/sym53c8xx_2/sym_hipd.c	2003-02-19 01:=
05:13.000000000 -0800
> @@ -800,7 +800,8 @@ static int sym_prepare_setting(hcb_p np,
>  	 * Btw, 'period' is in tenths of nanoseconds.
>  	 */
>  	period =3D (4 * div_10M[0] + np->clock_khz - 1) / np->clock_khz;
> -	if	(period <=3D 250)		np->minsync =3D 10;
> +	if	(period =3D=3D 250)		np->minsync =3D 9;
> +	else if	(period <=3D 250)		np->minsync =3D 10;
>  	else if	(period <=3D 303)		np->minsync =3D 11;
>  	else if	(period <=3D 500)		np->minsync =3D 12;
>  	else				np->minsync =3D (period + 40 - 1) / 40;


These calculations apply to ST (Single Transition) transfer mode.
In DT (Dual Transition) mode you get twice the data transfer rate of ST
for the same transition pattern/timing.

=46or Ultra-160 chips, the driver gets the synchronous capabilities of =
the
C1010 controller in a far more simple way:

	/*
	 * If chip is a C1010, guess the sync limits in DT mode.
	 */
	if ((np->features & (FE_C10|FE_ULTRA3)) =3D=3D (FE_C10|FE_ULTRA3)) {
		if (np->clock_khz =3D=3D 160000) {
			np->minsync_dt =3D 9;
			np->maxsync_dt =3D 50;
			np->maxoffs_dt =3D nvram->type ? 62 : 31;
		}
	}

May-be, it is your hard disk which negotiates FAST-40. The driver will =
not
renegotiate for FAST-80 if such happens. You should check that IMO.

Regards,
  G=E9rard.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
