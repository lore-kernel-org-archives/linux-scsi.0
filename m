From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Tue, 22 Dec 2015 10:59:22 +0100
Message-ID: <20151222105922.0896ded7@harpe.intellique.com>
References: <20151218170644.24167419@harpe.intellique.com>
	<20151221134649.293a1a1e@harpe.intellique.com>
	<F89B43DA-FE51-4FEF-97BB-C79A401050D7@kolumbus.fi>
	<20151221185759.38dd21d6@harpe.intellique.com>
	<3F0204AE-89BD-45C7-883F-D6EC3A1D34E2@kolumbus.fi>
	<DDB9C85B850785449757F9914A034FCB444FC76D@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:34293 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164AbbLVJ7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2015 04:59:23 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB444FC76D@G4W3219.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>
Cc: "Kai =?UTF-8?B?TcOka2lzYXJh?= (Kolumbus)" <kai.makisara@kolumbus.fi>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Le Tue, 22 Dec 2015 05:51:30 +0000
"Seymour, Shane M" <shane.seymour@hpe.com> =C3=A9crivait:

> If you need help with anything please let me know I'd be more than
> happy to contribute (with testing and a review if you want). I have a
> system with an older LTO-3 tape drive that I can use any time (it
> doesn=E2=80=99t support partitioning so if nothing else I can make su=
re
> partitioning attempts fail gracefully). I may be able to beg, borrow,
> or steal access to an LTO 5 or 6 drive though to help out in testing.

ATM I have an HP LTO-5 and IBM LTO-6 drives (there are real differences
in behaviour between these at times). I need to check what media I have
available for tests though.

> Kai, for the source of the HPE EverStore software should be available
> here:
>=20
> http://h20564.www2.hpe.com/hpsc/swd/public/readIndex?sp4ts.oid=3D5111=
617

The IBM driver should be here:
http://www-933.ibm.com/support/fixcentral/swg/quickorder?parent=3Dibm~S=
T~Tapedevicedriversandsoftware&product=3Dibm/Storage_Tape/Tape+device+d=
rivers&release=3D1.0&platform=3DLinux&function=3Dall&source=3Dfc

When you have selected RH as a platform, the source rpm is also
available to download.

>=20
> This seems to be the relevant code from the driver though (the same
> download has the ibm tape driver as well). You'll need to look at the
> following:
>=20
> ltotape.c - ltotape_readposition to determine the current partition
> ltotape.c - ltotape_locate - to move to a position on tape (includes
> setting the partition and has a special flag for changing partitions
> between the two it supports if required) ltotape.c - ltotape_format -
> for creating and destroying partitions ltotape.c -
> ltotape_remaining_capacity - will get you the remaining and maximum
> capacity for the partitions
>=20
> When you look at those functions you'll see TC_FORMAT_TYPE referenced
> this is the enum referred it is in src/libltfs/tape_ops.h:
>=20
> typedef enum {
>         TC_FORMAT_DEFAULT   =3D 0x00,   /* Make 1 partition medium */
>         TC_FORMAT_PARTITION =3D 0x01,   /* Make 2 partition medium */
>         TC_FORMAT_DEST_PART =3D 0x02,   /* Destroy all data and make =
2
> partition medium */ TC_FORMAT_MAX       =3D 0x03
> } TC_FORMAT_TYPE;    /* Space command operations */
=20
> The driver at that download looks like it only supports two
> partitions though and if you go looking around the code (grep for
> partition) some LTO drives (probably older ones) look like they may
> be partition aware but may not actually support partitions, see this
> comment:
>=20
> ltotape_platform.c:      * For an LTO drive, need to determine
> whether it is partition-capable or only partition-aware:

The IBM code however looks like it supports any number of partitions
(though LTO-6/7 support only 4,so MAX_SUPPORTED_PARTITIONS is set to 4)=
:

	if(copy_from_user((void*)usr_part, (void*)arg,
		sizeof(struct tape_partition))) {
		printk("lin_tape_create_partition: cannot copy from user\n");
		rc =3D -EFAULT;
		goto EXIT_LABEL;
	} /* if */

	if(usr_part->number_of_partitions > MAX_SUPPORTED_PARTITIONS) {
		DbgPrint(("lin_tape: too many partitions %d\n",
			usr_part->number_of_partitions));
		rc =3D -EINVAL;
		goto EXIT_LABEL;
	} /* if */


Interestingly it seems to support both wrap partitioning and
longitudinal partitioning (on 3592 drives).

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
