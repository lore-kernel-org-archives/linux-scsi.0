From: Stephen Cameron <smcameron@yahoo.com>
Subject: Re: [PATCH 4/5] hpsa: Fix incorrect SCSI status reporting
Date: Wed, 16 Dec 2009 14:53:03 -0800 (PST)
Message-ID: <748125.31172.qm@web33007.mail.mud.yahoo.com>
References: <20091208213827.23493.88533.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web33007.mail.mud.yahoo.com ([209.191.69.122]:29048 "HELO
	web33007.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935375AbZLPW7o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 17:59:44 -0500
In-Reply-To: <20091208213827.23493.88533.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org



--- On Tue, 12/8/09, Stephen M. Cameron <scameron@beardog.cce.hp.com> w=
rote:

> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> Subject: [PATCH 4/5] hpsa: Fix incorrect SCSI status reporting
> To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
> Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scs=
i@vger.kernel.org, smcameron@yahoo.com
> Date: Tuesday, December 8, 2009, 3:38 PM
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>=20
> hpsa: Fix incorrect SCSI status reporting
>=20
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/scsi/hpsa.c |=A0 =A0 5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 0e696ee..380236a 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -930,7 +930,7 @@ static void
> complete_scsi_command(struct CommandList *cp,
> =20
>  =A0=A0=A0 cmd->result =3D (DID_OK << 16);
> =A0=A0=A0 =A0=A0=A0 /* host byte */
>  =A0=A0=A0 cmd->result |=3D (COMMAND_COMPLETE << 8);=A0=A0=A0 /* msg =
byte */
> -=A0=A0=A0 cmd->result |=3D (ei->ScsiStatus);
> +=A0=A0=A0 cmd->result |=3D (ei->ScsiStatus << 1);

I don't think this is correct.

I got fooled by some code in other drivers (3w-9xxx.c, gdth.c)
which use CHECK_CONDITION, and shift it left 1, but I failed to notice
that CHECK_CONDITION is defined to be 0x01, not 0x02.

Might be nice if there were some macros or helper functions
for setting the status bytes in scsi.h (there are some for=20
unpacking, but not for packing, but drivers mainly need to
pack these, not unpack them.)

Will send a patch tomorrow in any case.

-- steve



> =20
>  =A0=A0=A0 /* copy the sense data whether we need
> to or not. */
>  =A0=A0=A0 memcpy(cmd->sense_buffer,
> ei->SenseInfo,
> @@ -991,7 +991,6 @@ static void
> complete_scsi_command(struct CommandList *cp,
> =20
> =20
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> /* Must be some other type of check condition */
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> cmd->result |=3D (ei->ScsiStatus << 1);
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> dev_warn(&h->pdev->dev, "cp %p has check
> condition: "
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 "unknown type: "
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 "Sense: 0x%x, ASC:
> 0x%x, ASCQ: 0x%x, "
> @@ -1013,8 +1012,6 @@ static void
> complete_scsi_command(struct CommandList *cp,
>  =A0=A0=A0 =A0=A0=A0=A0=A0* Pass it
> up to the upper layers...
>  =A0=A0=A0 =A0=A0=A0=A0=A0*/
>  =A0=A0=A0 =A0=A0=A0 if
> (ei->ScsiStatus) {
> -
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> cmd->result |=3D (ei->ScsiStatus << 1);
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> dev_warn(&h->pdev->dev, "cp %p has status 0x%x "
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 "Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 "Returning result: 0x%x\n",
>=20
>=20


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
