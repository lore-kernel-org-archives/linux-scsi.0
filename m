From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] sd: close hole in > 2T device rejection when
 !CONFIG_LBDAF
Date: Mon, 27 Feb 2017 16:13:43 +0000
Message-ID: <1488211985.2656.1.camel@sandisk.com>
References: <1488208949-3811-1-git-send-email-steve@digidescorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1488208949-3811-1-git-send-email-steve@digidescorp.com>
Content-Language: en-US
Content-ID: <1CFD8157B51C814AB287333C6AB2713A@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "steve.magnani@digidescorp.com" <steve.magnani@digidescorp.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "steve@digidescorp.com" <steve@digidescorp.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-02-27 at 09:22 -0600, Steven J. Magnani wrote:
> @@ -2122,7 +2122,10 @@ static int read_capacity_16(struct scsi_
>  		return -ENODEV;
>  	}
> =20
> -	if ((sizeof(sdkp->capacity) =3D=3D 4) && (lba >=3D 0xffffffffULL)) {
> +	/* Make sure logical_to_sectors() won't overflow */
> +	lba_in_sectors =3D lba << (ilog2(sector_size) - 9);
> +	if ((sizeof(sdkp->capacity) =3D=3D 4) &&
> +	    ((lba >=3D 0xffffffffULL) || (lba_in_sectors >=3D 0xffffffffULL))) =
{
>  		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
>  			"kernel compiled with support for large block "
>  			"devices.\n");
> @@ -2162,6 +2165,7 @@ static int read_capacity_10(struct scsi_
>  	int the_result;
>  	int retries =3D 3, reset_retries =3D READ_CAPACITY_RETRIES_ON_RESET;
>  	sector_t lba;
> +	unsigned long long lba_in_sectors;
>  	unsigned sector_size;
> =20
>  	do {
> @@ -2208,7 +2212,10 @@ static int read_capacity_10(struct scsi_
>  		return sector_size;
>  	}
> =20
> -	if ((sizeof(sdkp->capacity) =3D=3D 4) && (lba =3D=3D 0xffffffff)) {
> +	/* Make sure logical_to_sectors() won't overflow */
> +	lba_in_sectors =3D ((unsigned long long) lba) << (ilog2(sector_size) - =
9);
> +	if ((sizeof(sdkp->capacity) =3D=3D 4) &&
> +	    (lba_in_sectors >=3D 0xffffffffULL)) {
>  		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
>  			"kernel compiled with support for large block "
>  			"devices.\n");

Why are the two checks slightly different? Could the same code be used for
both checks? BTW, using the macro below would make the above checks less
verbose and easier to read:

/*
=A0* Test whether the result of a shift-left operation would be larger than
=A0* what fits in a variable with the type of @a.
=A0*/
#define shift_left_overflows(a, b)					\
	({								\
		typeof(a) _minus_one =3D -1LL;				\
		typeof(a) _plus_one =3D 1;				\
		bool _a_is_signed =3D _minus_one < 0;			\
		int _shift =3D sizeof(a) * 8 - ((b) + _a_is_signed);	\
		_shift < 0 || ((a) & ~((_plus_one << _shift) - 1)) !=3D 0;\
	})

Bart.=
