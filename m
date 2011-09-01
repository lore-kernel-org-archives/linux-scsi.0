From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [SCSI]: Allow expander T-T attachments
Date: Thu, 1 Sep 2011 10:25:28 -0700 (PDT)
Message-ID: <1314897928.35918.YahooMailNeo@web31813.mail.mud.yahoo.com>
References: <20110730002509.28735.82590.stgit@localhost6.localdomain6> <FC1F9E38C0703341A1A750524E2525A901853EC8@XYUS-EX22.xyus.xyratex.com> <1314812608.95574.YahooMailNeo@web31804.mail.mud.yahoo.com> <FC1F9E38C0703341A1A750524E2525A901853EFC@XYUS-EX22.xyus.xyratex.com>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm7.bullet.mail.ac4.yahoo.com ([98.139.52.204]:37155 "HELO
	nm7.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755872Ab1IARZa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Sep 2011 13:25:30 -0400
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A901853EFC@XYUS-EX22.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Darrick J Wong <djwong@us.ibm.com>, James Bottomley <jbottomley@parallels.com>

It was tested on a bunch of self-configuring, T2T supporting expanders,=
 connected as a binary tree with a SAS controller at the root of the tr=
ee, forming more than 2 levels of branching.



----- Original Message -----
> From: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
> To: Luben Tuikov <ltuikov@yahoo.com>; linux-scsi@vger.kernel.org
> Cc: Darrick J Wong <djwong@us.ibm.com>; James Bottomley <jbottomley@p=
arallels.com>
> Sent: Wednesday, August 31, 2011 10:51 AM
> Subject: RE: [PATCH] [SCSI]: Allow expander T-T attachments
>=20
> We will need James to chime in why your patch did not go in. My assum=
ption is=20
> the lack of response to his question left it in limbo.
>=20
> The likely modification to your patch would be to remove all the unus=
ed added=20
> flags rather than staking out the territory.
>=20
> What kind of testing was involved in your patch? I have not merged yo=
urs in here=20
> to try it out on our enclosures. Either way, I want to see some movem=
ent; James=20
> any directions?
>=20
> Sincerely -- Mark Salyzyn
>=20
> -----Original Message-----
> From: Luben Tuikov [mailto:ltuikov@yahoo.com]=20
> Sent: Wednesday, August 31, 2011 1:43 PM
> To: Mark Salyzyn; linux-scsi@vger.kernel.org
> Cc: Darrick J Wong; James Bottomley
> Subject: Re: [PATCH] [SCSI]: Allow expander T-T attachments
>=20
> ----- Original Message -----
>=20
>>  From: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
>>  To: linux-scsi@vger.kernel.org
>>  Cc: Luben Tuikov <ltuikov@yahoo.com>; Darrick J Wong=20
> <djwong@us.ibm.com>; James Bottomley <jbottomley@parallels.com>
>>  Sent: Wednesday, August 31, 2011 6:44 AM
>>  Subject: Re: [PATCH] [SCSI]: Allow expander T-T attachments
>>=20
>>  Since Luben's patch on July 28th 2011 went nowhere, as there was an
>>  unanswered question regarding the future-proofing that Luben added =
in.
>=20
> Are you saying that the patch I posted,
> http://marc.info/?t=3D131182720200001&r=3D1&w=3D2, didn't go in
> because I didn't entertain Bottomley's unrelated question therein?
> Or are you saying that it did go in based on TECHNICAL CONTENT? I.e. =
it
> was buggy, or wrong, etc?
>=20
>>  I decided to submit a simplified focussed patch we have been using =
for the
>=20
> By "simplified, focused" you mean one which doesn't define 2 out=20
> of 3 flags of=20
> REPORT GENERAL SMP response?
>=20
>>  past year testing with the Xyratex enclosures (5U84, 2U24, chained =
with
>>  *many* peered expanders with Table to Table routing) that should
>>  hopefully expedite things and will be on hot standby to refactor as
>>  requested (including tossing this baby and refactoring Luben's patc=
h
>>  should he be too busy, no hair off my back)
>=20
> Now onto technical matter:
> 1) I'd call the flag "t2t_supp" to a) fit in with the rest of the=20
> spirit of the
> code as other fields are also called "_supp", and to b) actually=20
> convey
> =A0the meaning of "table-to-table supported. Your naming of this flag
> "table_to_table" implicitly means "table to table=20
> supported".
> 2) Please also add the debug output as my patch did. People will
> be wondering what went wrong if their domain didn't work, and the
> debug print in my original patch would tell them that.
> 3) You don't check that the parent also supports T2T. That's a bug.
> 4) Your patch logically does this: P=3DT && C!=3DS && (C is T2T ||=20
> C!=3DT),
> which after expansion is equivalent to:
> (P=3D=3DT) && ((C!=3DS && C!=3DT2T) || C=3D=3DD) =3D=3D> fail
> where the outmost parens are an if (). Albeit from not being entirely=
 correct,
> it also obfuscates what is being sought after. I chose to use the neg=
ation for
> successful check to make it more clear:
> (P=3D=3DT) && (C=3D=3DS || (C=3D=3DT && P=3D=3DT2T && C=3D=3DT2T)) =3D=
=3D>=20
> success,
> Translates to
> "If parent phy is T, and If child phy is S OR (child is T and child a=
nd=20
> parent
> both support table to table) then we're okay, else report an error."
> Which is: T<-S is okay, and T<-T is okay if both parent and child sup=
port=20
> it.
>=20
> Alternatively, Bottomley could just add my patch upstream.
>=20
>>  Please note, as I am *stuck* on Outlook as per company policy, the
>>  following inline content will likely not patch clean even emailed a=
s
>>  'Plain Text', the enclosed attached file should do the job. I have=20
>>  Cc'd
>>  all the folks that originated the files in libsas, as there was no
>>  listed MAINTAINERs.
>>=20
>>  NB: this patch (and Luben's independent patch) results in an ABI br=
eak
>>  as the structures change 'shape' and thus result in a different set=
=20
> of
>>  libsas export signatures. I have an internal patch I use that prese=
rves
>>  the structure shapes and thus the ABI; but would be considered
>>  inappropriate for the pristine trees. Said alternate patch would wo=
rk
>>  fine for a Distribution tree where ABI concerns are an issue.
>>=20
>>  Checkpatch.pl reports clean.
>>=20
>>  Sincerely -- Mark Salyzyn
>>=20
>>  Cc: Luben Tuikov <tuikov@yahoo.com>
>>  Cc: Darrick J Wong <djwong@us.ibm.com>
>>  Cc: James Bottomley <jbottomley@parallels.com>
>>=20
>>  Signed-off-by: Mark Salyzyn <msalyzyn@us.xyratex.com>
>>=20
>>  drivers/scsi/libsas/sas_expander.c |=A0 =A0 6 +++++-
>>  include/scsi/libsas.h=A0 =A0 =A0 =A0 =A0 =A0 =A0 |=A0 =A0 1 +
>>  include/scsi/sas.h=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0 |=A0 =A0 6 +++=
+--
>>  3 files changed, 10 insertions(+), 3 deletions(-)
>>=20
>>  diff -ru scsi-misc-2.6/drivers/scsi/libsas/sas_expander.c
>>  scsi-misc-2.6.new/drivers/scsi/libsas/sas_expander.c
>>  --- scsi-misc-2.6/drivers/scsi/libsas/sas_expander.c=A0=A0=A0 2011-=
08-31
>>  08:32:21.000000000 -0400
>>  +++ scsi-misc-2.6.new/drivers/scsi/libsas/sas_expander.c
>>  2011-08-31 09:07:31.000000000 -0400
>>  @@ -331,6 +331,7 @@
>>  =A0=A0=A0 dev->ex_dev.num_phys =3D min(rg->num_phys, (u8)MAX_EXPAND=
ER_PHYS);
>>  =A0=A0=A0 dev->ex_dev.conf_route_table =3D rg->conf_route_table;
>>  =A0=A0=A0 dev->ex_dev.configuring =3D rg->configuring;
>>  +=A0=A0=A0 dev->ex_dev.table_to_table =3D rg->table_to_table;
>>  =A0=A0=A0 memcpy(dev->ex_dev.enclosure_logical_id,
>>  rg->enclosure_logical_id, 8);
>>  }
>>=20
>>  @@ -1239,7 +1240,10 @@
>>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 res =3D -ENODEV;
>>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 }
>>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 } else if (parent_phy->routing_attr =3D=
=3D
>>  TABLE_ROUTING &&
>>  -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0 child_phy->routing_=
attr !=3D
>>  SUBTRACTIVE_ROUTING) {
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0 child_phy->routing_=
attr !=3D
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 SUBTRACTIVE_ROUT=
ING &&
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0 (child_ex->table_to=
_table =3D=3D 0 ||
>>  +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 child_phy->routing=
_attr !=3D
>>  TABLE_ROUTING)) {
>>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 sas_print_parent_topology_b=
ug(child,
>>  parent_phy, child_phy);
>>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 res =3D -ENODEV;
>>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 }
>>  diff -ru scsi-misc-2.6/include/scsi/libsas.h
>>  scsi-misc-2.6.new/include/scsi/libsas.h
>>  --- scsi-misc-2.6/include/scsi/libsas.h=A0=A0=A0 2011-08-31 08:32:2=
2.000000000
>>  -0400
>>  +++ scsi-misc-2.6.new/include/scsi/libsas.h=A0=A0=A0 2011-08-31
>>  09:07:31.000000000 -0400
>>  @@ -144,6 +144,7 @@
>>  =A0=A0=A0 u8=A0 =A0=A0 num_phys;
>>  =A0=A0=A0 u8=A0 =A0=A0 configuring:1;
>>  =A0=A0=A0 u8=A0 =A0=A0 conf_route_table:1;
>>  +=A0=A0=A0 u8=A0 =A0=A0 table_to_table:1;
>>  =A0=A0=A0 u8=A0 =A0=A0 enclosure_logical_id[8];
>>=20
>>  =A0=A0=A0 struct ex_phy *ex_phy;
>>  diff -ru scsi-misc-2.6/include/scsi/sas.h
>>  scsi-misc-2.6.new/include/scsi/sas.h
>>  --- scsi-misc-2.6/include/scsi/sas.h=A0=A0=A0 2011-08-31 08:32:22.0=
00000000
>>  -0400
>>  +++ scsi-misc-2.6.new/include/scsi/sas.h=A0=A0=A0 2011-08-31
>>  09:07:31.000000000 -0400
>>  @@ -341,7 +341,8 @@
>>=20
>>  =A0=A0=A0 u8=A0 =A0 =A0 conf_route_table:1;
>>  =A0=A0=A0 u8=A0 =A0 =A0 configuring:1;
>>  -=A0=A0=A0 u8=A0 =A0 =A0 _r_b:6;
>>  +=A0=A0=A0 u8=A0 =A0 =A0 _r_b:5;
>>  +=A0=A0=A0 u8=A0 =A0 =A0 table_to_table:1;
>>=20
>>  =A0=A0=A0 u8=A0 =A0 =A0 _r_c;
>>=20
>>  @@ -528,7 +529,8 @@
>>  =A0=A0=A0 u8=A0 =A0 =A0 _r_a;
>>  =A0=A0=A0 u8=A0 =A0 =A0 num_phys;
>>=20
>>  -=A0=A0=A0 u8=A0 =A0 =A0 _r_b:6;
>>  +=A0=A0=A0 u8=A0 =A0 =A0 table_to_table:1;
>>  +=A0=A0=A0 u8=A0 =A0 =A0 _r_b:5;
>>  =A0=A0=A0 u8=A0 =A0 =A0 configuring:1;
>>  =A0=A0=A0 u8=A0 =A0 =A0 conf_route_table:1;
>>=20
> _____________________________________________________________________=
_
> This email may contain privileged or confidential information, which =
should only=20
> be used for the purpose for which it was sent by Xyratex. No further =
rights or=20
> licenses are granted to use such information. If you are not the inte=
nded=20
> recipient of this message, please notify the sender by return and del=
ete it. You=20
> may not use, copy, disclose or rely on the information contained in i=
t.
>=20
> Internet email is susceptible to data corruption, interception and un=
authorised=20
> amendment for which Xyratex does not accept liability. While we have =
taken=20
> reasonable precautions to ensure that this email is free of viruses, =
Xyratex=20
> does not accept liability for the presence of any computer viruses in=
 this=20
> email, nor for any losses caused as a result of viruses.
>=20
> Xyratex Technology Limited (03134912), Registered in England & Wales,=
=20
> Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
>=20
> The Xyratex group of companies also includes, Xyratex Ltd, registered=
 in=20
> Bermuda, Xyratex International Inc, registered in California, Xyratex=
 (Malaysia)=20
> Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd regi=
stered in=20
> The People's Republic of China and Xyratex Japan Limited registered i=
n=20
> Japan.
> _____________________________________________________________________=
_
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
