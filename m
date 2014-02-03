From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Mon, 03 Feb 2014 07:55:52 +0100
Message-ID: <52EF3D78.9060109@suse.de>
References: <1391157974-17512-1-git-send-email-hare@suse.de> <52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de> <60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi> <52EE2F2D.1010300@suse.de> <5132C611-A5B1-41A8-B348-824643930CB2@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbaBCGzz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Feb 2014 01:55:55 -0500
In-Reply-To: <5132C611-A5B1-41A8-B348-824643930CB2@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?windows-1252?Q?=22Kai_M=E4kisara_=28Kolumbus=29=22?= <kai.makisara@kolumbus.fi>
Cc: Jeremy Linton <jlinton@tributary.com>, James Bottomley <jbottomley@parallels.com>, Kay Sievers <kay@vrfy.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/02/2014 08:15 PM, "Kai M=E4kisara (Kolumbus)" wrote:
>=20
> On 2.2.2014, at 13.42, Hannes Reinecke <hare@suse.de> wrote:
>=20
> [part of explanation snipped from reply]
>=20
>> But we're now trying to deprecate the original (and unmaintained)
>> scsi_id program and replace it with the standard 'sg_inq' program.
>> Which is a standard program which just issues the respective SCSI
>> command; most of the post-processing will be done by udev rules.
>> And implementing the same workaround here is really a bit hackish.
>> Hence this proposal to allow 'sg_inq' (or any program from sg3_utils=
)
>> to be called without interrupting normal operations on a tape device=
=2E
>>
> OK. After your explanation I think adding the new MTIOCTOP operation =
is the
> least ugly solution :-)
>=20
Ok.

>>> If you absolutely have to do this, then do it. But new ioctls are d=
eprecated and
>>> also it is a bad habit to change the kernel to make things easier f=
or a single
>>> program.
>>>
>> Well, the actual problem here is that the 'st' driver is not designe=
d for
>> multi-initiator environments. The original design for the driver
assumed
>> that a single program had control over the 'st' driver, and there
is only
>> one instance talking to the hardware.
>> Which simply doesn't fit well with the modern, asynchronous, setup.
>>
> The basic problem is that a sequential access device does not fit wel=
l the
> asynchronous setup. I admit that some simplifications have been
made because of this.
>=20
>> And it's not just udev which suffers here; try to setup multipath on=
 a tape device ...
>>
>>>> I'll be drafting up a patch.
>>>>
>>> If you do, don=92t forget to update the documentation.
>>>
>> Okay. New patch attached.
>>
> I think you have not compiled the patched st.c:
>=20
> @@ -2263,6 +2265,8 @@ static int st_set_options(struct scsi_tape *STp=
, long options)
>  			STm->sysv =3D value;
>  		if ((options & MT_ST_SILI) !=3D 0)
>  			STp->sili =3D value;
> +		if (value && (options & MT_ST_NOREWIND) !=3D 0)
> +			Stp->rew_at_close =3D 0;
>                          ^^^
> Should be STp.
>=20
> However, looking at the code already suggests that this operation doe=
s not belong to MT_ST_*.
> These bits set/clear options that persist. The operations you need
is transient so that the
> effect disappears when the device is closed. I think it would be
better to define it as and
> ordinary MTIOCTOP operation code, e.g., in mtio.h:
>=20
> #define MTNOAUTOREWIND 36  /* suppress possible pending automatic rew=
ind */
>=20
> or something like that?
>
Ok, can do.

Let's draft up a new version.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
