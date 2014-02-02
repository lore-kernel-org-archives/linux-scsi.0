From: =?windows-1252?Q?=22Kai_M=E4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Sun, 2 Feb 2014 21:15:52 +0200
Message-ID: <5132C611-A5B1-41A8-B348-824643930CB2@kolumbus.fi>
References: <1391157974-17512-1-git-send-email-hare@suse.de> <52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de> <60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi> <52EE2F2D.1010300@suse.de>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs17.mail.saunalahti.fi ([62.142.117.198]:54769 "EHLO
	vs17.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbaBBTQD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Feb 2014 14:16:03 -0500
In-Reply-To: <52EE2F2D.1010300@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jeremy Linton <jlinton@tributary.com>, James Bottomley <jbottomley@parallels.com>, Kay Sievers <kay@vrfy.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


On 2.2.2014, at 13.42, Hannes Reinecke <hare@suse.de> wrote:

[part of explanation snipped from reply]

> But we're now trying to deprecate the original (and unmaintained)
> scsi_id program and replace it with the standard 'sg_inq' program.
> Which is a standard program which just issues the respective SCSI com=
mand; most of the post-processing will be done by udev rules.
> And implementing the same workaround here is really a bit hackish.
> Hence this proposal to allow 'sg_inq' (or any program from sg3_utils)
> to be called without interrupting normal operations on a tape device.
>=20
OK. After your explanation I think adding the new MTIOCTOP operation is=
 the
least ugly solution :-)

>> If you absolutely have to do this, then do it. But new ioctls are de=
precated and
>> also it is a bad habit to change the kernel to make things easier fo=
r a single
>> program.
>>=20
> Well, the actual problem here is that the 'st' driver is not designed=
 for multi-initiator environments. The original design for the driver a=
ssumed that a single program had control over the 'st' driver, and ther=
e is only one instance talking to the hardware.
> Which simply doesn't fit well with the modern, asynchronous, setup.
>=20
The basic problem is that a sequential access device does not fit well =
the asynchronous setup. I admit that some simplifications have been mad=
e because of this.

> And it's not just udev which suffers here; try to setup multipath on =
a tape device ...
>=20
>>> I'll be drafting up a patch.
>>>=20
>> If you do, don=92t forget to update the documentation.
>>=20
> Okay. New patch attached.
>=20
I think you have not compiled the patched st.c:

@@ -2263,6 +2265,8 @@ static int st_set_options(struct scsi_tape *STp, =
long options)
 			STm->sysv =3D value;
 		if ((options & MT_ST_SILI) !=3D 0)
 			STp->sili =3D value;
+		if (value && (options & MT_ST_NOREWIND) !=3D 0)
+			Stp->rew_at_close =3D 0;
                         ^^^
Should be STp.

However, looking at the code already suggests that this operation does =
not belong to MT_ST_*. These bits set/clear options that persist. The o=
perations you need is transient so that the effect disappears when the =
device is closed. I think it would be better to define it as and ordina=
ry MTIOCTOP operation code, e.g., in mtio.h:

#define MTNOAUTOREWIND 36  /* suppress possible pending automatic rewin=
d */

or something like that?

Thanks,
Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
