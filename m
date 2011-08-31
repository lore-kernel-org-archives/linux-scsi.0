From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [SCSI]: Allow expander T-T attachments
Date: Wed, 31 Aug 2011 10:43:28 -0700 (PDT)
Message-ID: <1314812608.95574.YahooMailNeo@web31804.mail.mud.yahoo.com>
References: <20110730002509.28735.82590.stgit@localhost6.localdomain6> <FC1F9E38C0703341A1A750524E2525A901853EC8@XYUS-EX22.xyus.xyratex.com>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm25.bullet.mail.ac4.yahoo.com ([98.139.52.222]:21780 "HELO
	nm25.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756877Ab1HaRna convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Aug 2011 13:43:30 -0400
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A901853EC8@XYUS-EX22.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Darrick J Wong <djwong@us.ibm.com>, James Bottomley <jbottomley@parallels.com>

----- Original Message -----

> From: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
> To: linux-scsi@vger.kernel.org
> Cc: Luben Tuikov <ltuikov@yahoo.com>; Darrick J Wong <djwong@us.ibm.c=
om>; James Bottomley <jbottomley@parallels.com>
> Sent: Wednesday, August 31, 2011 6:44 AM
> Subject: Re: [PATCH] [SCSI]: Allow expander T-T attachments
>=20
> Since Luben's patch on July 28th 2011 went nowhere, as there was an
> unanswered question regarding the future-proofing that Luben added in=
=2E

Are you saying that the patch I posted,
http://marc.info/?t=3D131182720200001&r=3D1&w=3D2, didn't go in
because I didn't entertain Bottomley's unrelated question therein?
Or are you saying that it did go in based on TECHNICAL CONTENT? I.e. it
was buggy, or wrong, etc?

> I decided to submit a simplified focussed patch we have been using fo=
r the

By "simplified, focused" you mean one which doesn't define 2 out of 3 f=
lags of=20
REPORT GENERAL SMP response?

> past year testing with the Xyratex enclosures (5U84, 2U24, chained wi=
th
> *many* peered expanders with Table to Table routing) that should
> hopefully expedite things and will be on hot standby to refactor as
> requested (including tossing this baby and refactoring Luben's patch
> should he be too busy, no hair off my back)

Now onto technical matter:
1) I'd call the flag "t2t_supp" to a) fit in with the rest of the spiri=
t of the
code as other fields are also called "_supp", and to b) actually convey
=A0the meaning of "table-to-table supported. Your naming of this flag
"table_to_table" implicitly means "table to table supported".
2) Please also add the debug output as my patch did. People will
be wondering what went wrong if their domain didn't work, and the
debug print in my original patch would tell them that.
3) You don't check that the parent also supports T2T. That's a bug.
4) Your patch logically does this: P=3DT && C!=3DS && (C is T2T || C!=3D=
T),
which after expansion is equivalent to:
(P=3D=3DT) && ((C!=3DS && C!=3DT2T) || C=3D=3DD) =3D=3D> fail
where the outmost parens are an if (). Albeit from not being entirely c=
orrect,
it also obfuscates what is being sought after. I chose to use the negat=
ion for
successful check to make it more clear:
(P=3D=3DT) && (C=3D=3DS || (C=3D=3DT && P=3D=3DT2T && C=3D=3DT2T)) =3D=3D=
> success,
Translates to
"If parent phy is T, and If child phy is S OR (child is T and child and=
 parent
both support table to table) then we're okay, else report an error."
Which is: T<-S is okay, and T<-T is okay if both parent and child suppo=
rt it.

Alternatively, Bottomley could just add my patch upstream.

> Please note, as I am *stuck* on Outlook as per company policy, the
> following inline content will likely not patch clean even emailed as
> 'Plain Text', the enclosed attached file should do the job. I have=20
> Cc'd
> all the folks that originated the files in libsas, as there was no
> listed MAINTAINERs.
>=20
> NB: this patch (and Luben's independent patch) results in an ABI brea=
k
> as the structures change 'shape' and thus result in a different set o=
f
> libsas export signatures. I have an internal patch I use that preserv=
es
> the structure shapes and thus the ABI; but would be considered
> inappropriate for the pristine trees. Said alternate patch would work
> fine for a Distribution tree where ABI concerns are an issue.
>=20
> Checkpatch.pl reports clean.
>=20
> Sincerely -- Mark Salyzyn
>=20
> Cc: Luben Tuikov <tuikov@yahoo.com>
> Cc: Darrick J Wong <djwong@us.ibm.com>
> Cc: James Bottomley <jbottomley@parallels.com>
>=20
> Signed-off-by: Mark Salyzyn <msalyzyn@us.xyratex.com>
>=20
> drivers/scsi/libsas/sas_expander.c |=A0 =A0 6 +++++-
> include/scsi/libsas.h=A0 =A0 =A0 =A0 =A0 =A0 =A0 |=A0 =A0 1 +
> include/scsi/sas.h=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0  |=A0 =A0 6 ++++--
> 3 files changed, 10 insertions(+), 3 deletions(-)
>=20
> diff -ru scsi-misc-2.6/drivers/scsi/libsas/sas_expander.c
> scsi-misc-2.6.new/drivers/scsi/libsas/sas_expander.c
> --- scsi-misc-2.6/drivers/scsi/libsas/sas_expander.c=A0=A0=A0 2011-08=
-31
> 08:32:21.000000000 -0400
> +++ scsi-misc-2.6.new/drivers/scsi/libsas/sas_expander.c
> 2011-08-31 09:07:31.000000000 -0400
> @@ -331,6 +331,7 @@
> =A0=A0=A0 dev->ex_dev.num_phys =3D min(rg->num_phys, (u8)MAX_EXPANDER=
_PHYS);
> =A0=A0=A0 dev->ex_dev.conf_route_table =3D rg->conf_route_table;
> =A0=A0=A0 dev->ex_dev.configuring =3D rg->configuring;
> +=A0=A0=A0 dev->ex_dev.table_to_table =3D rg->table_to_table;
> =A0=A0=A0 memcpy(dev->ex_dev.enclosure_logical_id,
> rg->enclosure_logical_id, 8);
> }
>=20
> @@ -1239,7 +1240,10 @@
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 res =3D -ENODEV;
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 }
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 } else if (parent_phy->routing_attr =3D=
=3D
> TABLE_ROUTING &&
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0  child_phy->routing_attr=
 !=3D
> SUBTRACTIVE_ROUTING) {
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0  child_phy->routing_attr=
 !=3D
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 SUBTRACTIVE_ROUTIN=
G &&
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0  (child_ex->table_to_tab=
le =3D=3D 0 ||
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 child_phy->routing_a=
ttr !=3D
> TABLE_ROUTING)) {
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 sas_print_parent_topology_bug=
(child,
> parent_phy, child_phy);
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 res =3D -ENODEV;
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 }
> diff -ru scsi-misc-2.6/include/scsi/libsas.h
> scsi-misc-2.6.new/include/scsi/libsas.h
> --- scsi-misc-2.6/include/scsi/libsas.h=A0=A0=A0 2011-08-31 08:32:22.=
000000000
> -0400
> +++ scsi-misc-2.6.new/include/scsi/libsas.h=A0=A0=A0 2011-08-31
> 09:07:31.000000000 -0400
> @@ -144,6 +144,7 @@
> =A0=A0=A0 u8=A0 =A0  num_phys;
> =A0=A0=A0 u8=A0 =A0  configuring:1;
> =A0=A0=A0 u8=A0 =A0  conf_route_table:1;
> +=A0=A0=A0 u8=A0 =A0  table_to_table:1;
> =A0=A0=A0 u8=A0 =A0  enclosure_logical_id[8];
>=20
> =A0=A0=A0 struct ex_phy *ex_phy;
> diff -ru scsi-misc-2.6/include/scsi/sas.h
> scsi-misc-2.6.new/include/scsi/sas.h
> --- scsi-misc-2.6/include/scsi/sas.h=A0=A0=A0 2011-08-31 08:32:22.000=
000000
> -0400
> +++ scsi-misc-2.6.new/include/scsi/sas.h=A0=A0=A0 2011-08-31
> 09:07:31.000000000 -0400
> @@ -341,7 +341,8 @@
>=20
> =A0=A0=A0 u8=A0 =A0 =A0 conf_route_table:1;
> =A0=A0=A0 u8=A0 =A0 =A0 configuring:1;
> -=A0=A0=A0 u8=A0 =A0 =A0 _r_b:6;
> +=A0=A0=A0 u8=A0 =A0 =A0 _r_b:5;
> +=A0=A0=A0 u8=A0 =A0 =A0 table_to_table:1;
>=20
> =A0=A0=A0 u8=A0 =A0 =A0 _r_c;
>=20
> @@ -528,7 +529,8 @@
> =A0=A0=A0 u8=A0 =A0 =A0 _r_a;
> =A0=A0=A0 u8=A0 =A0 =A0 num_phys;
>=20
> -=A0=A0=A0 u8=A0 =A0 =A0 _r_b:6;
> +=A0=A0=A0 u8=A0 =A0 =A0 table_to_table:1;
> +=A0=A0=A0 u8=A0 =A0 =A0 _r_b:5;
> =A0=A0=A0 u8=A0 =A0 =A0 configuring:1;
> =A0=A0=A0 u8=A0 =A0 =A0 conf_route_table:1;
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
