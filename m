From: Hannes Reinecke <hare@suse.de>
Subject: Re: IO failures with SMR drives at latest kernel versions
Date: Thu, 27 Aug 2015 08:18:24 +0200
Message-ID: <55DEABB0.5070806@suse.de>
References: <CAOMFOmVFqOvr7AZQ0hie3LB3ReUcNV3rav5Dk_uf2aHoq-LK4A@mail.gmail.com>		<CAOMFOmXSrG82TFmHFTiCQoG3hkwJ69+U5Z=fXfbbgdf=xjTaJQ@mail.gmail.com>		<55DAB673.10903@suse.de>	 <CAOMFOmUHzLad4wLMJdAxj+CPKM_GCY3dTZUqpD2icoEJKdJ8uw@mail.gmail.com>	 <55DD5F45.7010905@suse.de> <1440629555.2196.92.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbbH0GS0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 02:18:26 -0400
In-Reply-To: <1440629555.2196.92.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, hch@lst.de, Tejun Heo <tj@kernel.org>

On 08/27/2015 12:52 AM, James Bottomley wrote:
> On Wed, 2015-08-26 at 08:40 +0200, Hannes Reinecke wrote:
>> On 08/26/2015 06:53 AM, Anatol Pomozov wrote:
>>> Hi
>>>
>>> On Sun, Aug 23, 2015 at 11:15 PM, Hannes Reinecke <hare@suse.de> wr=
ote:
>>>>> I looked at this commit and it actually adds SMR support to SCSI
>>>>> layer. Reverting ATA_DEV_ZAC means going back to zones-unaware
>>>>> algorithms. It is suboptimal but still much better than IO failur=
es
>>>>> and "BTRFS: lost page write due to I/O error on /dev/sdc" errors =
I see
>>>>> at my computer.
>>>>>
>>>>> If this SMR support is considered as non-stable, can we at least =
get a
>>>>> kernel boot (or config) option that disables ZAC?
>>>>>
>>>> Again: Has anybody actually _tested_ that reverting this patch fix=
es
>>>> this issue?
>>>
>>> Yes I tested it.
>>>
>>> This error happens only under heavy load with a lot of read/writes
>>> (like btrfs rebalance).
>>>
>>> With current Linux-4.1.6 'btrfs balance' fails after ~10 minutes af=
ter
>>> start. I reverted ZAC related changes and then ran rebalancing. The
>>> operation finished successfully after 3 hours of running.
>>>
>> Can you be a bit more specific about the 'ZAC related changes'?
>> There have been several patches, and we really would need to know
>> which one was the offending one.
>> Can you try to bisect things here?
>=20
> OK, let's stop shooting the messenger here.  There are multiple repor=
ts
> of this problem.  The pattern seems to be some type of error causes
> everything to die.
>=20
> There looks to be an obvious bug in
> 9162c6579bf90b3f5ddb7e3a6c6fa946c1b4cbeb in that there's no
> ATA_DEV_ZAC_UNSUP class which means that any attempt to disable the
> device pushes it up to ATA_DEV_NONE.  I'm not sure ... don't have tim=
e
> to follow the code ... but doesn't this interfere with the speed
> dropping routines which seems to disable then re-enable the device?
> Does adding ATA_DEV_ZAC_UNSUP fix this problem? patch (compile tested
> only) below.
>=20
> James
>=20
> ---
>=20
> diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-tran=
sport.c
> index d6c37bc..fa83320 100644
> --- a/drivers/ata/libata-transport.c
> +++ b/drivers/ata/libata-transport.c
> @@ -144,6 +144,7 @@ static struct {
>  	{ ATA_DEV_SEMB,			"semb" },
>  	{ ATA_DEV_SEMB_UNSUP,		"semb" },
>  	{ ATA_DEV_ZAC,			"zac" },
> +	{ ATA_DEV_ZAC_UNSUP,		"zac" },
>  	{ ATA_DEV_NONE,			"none" }
>  };
>  ata_bitfield_name_search(class, ata_class_names)
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 36ce37b..49c5b98 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -191,7 +191,8 @@ enum {
>  	ATA_DEV_SEMB		=3D 7,	/* SEMB */
>  	ATA_DEV_SEMB_UNSUP	=3D 8,	/* SEMB (unsupported) */
>  	ATA_DEV_ZAC		=3D 9,	/* ZAC device */
> -	ATA_DEV_NONE		=3D 10,	/* no device */
> +	ATA_DEV_ZAC_UNSUP	=3D 10,	/* ZAC (unsupported) */
> +	ATA_DEV_NONE		=3D 11,	/* no device */
> =20
>  	/* struct ata_link flags */
>  	ATA_LFLAG_NO_HRST	=3D (1 << 1), /* avoid hardreset */
> @@ -1517,7 +1518,8 @@ static inline unsigned int ata_class_enabled(un=
signed int class)
>  static inline unsigned int ata_class_disabled(unsigned int class)
>  {
>  	return class =3D=3D ATA_DEV_ATA_UNSUP || class =3D=3D ATA_DEV_ATAPI=
_UNSUP ||
> -		class =3D=3D ATA_DEV_PMP_UNSUP || class =3D=3D ATA_DEV_SEMB_UNSUP;
> +		class =3D=3D ATA_DEV_PMP_UNSUP || class =3D=3D ATA_DEV_SEMB_UNSUP =
||
> +		class =3D=3D ATA_DEV_ZAC_UNSUP;
>  }
> =20
>  static inline unsigned int ata_class_absent(unsigned int class)
>=20
>=20
Yes, you are correct. Even if this does not fix up this particular
issue it looks like a valid fix.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
