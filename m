From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
Subject: RE: [PATCH] [SCSI]: libsas failure to revalidate domain for anything but the first expander child.
Date: Tue, 6 Sep 2011 07:56:05 -0700
Message-ID: <FC1F9E38C0703341A1A750524E2525A9018540CA@XYUS-EX22.xyus.xyratex.com>
References: <20110730002509.28735.82590.stgit@localhost6.localdomain6> <FC1F9E38C0703341A1A750524E2525A901853EC8@XYUS-EX22.xyus.xyratex.com> <FC1F9E38C0703341A1A750524E2525A901853F74@XYUS-EX22.xyus.xyratex.com> <1314897501.64142.YahooMailNeo@web31807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:44008 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754257Ab1IFPAd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Sep 2011 11:00:33 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1314897501.64142.YahooMailNeo@web31807.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>, linux-scsi@vger.kernel.org
Cc: Darrick J Wong <djwong@us.ibm.com>, James Bottomley <jbottomley@parallels.com>

So are you suggesting a larger/different fix, or do you see this minor =
change as an acceptable means of resolving the specific issue of the re=
validation not going beyond the first child expander? At least with thi=
s fix it will go to the first expander with a change. It was a code-bug=
 from fumble-fingers, missing a '*', not a request to revamp ;->

I know that by spec it should not stop at the first discovered change, =
ignoring changes in other children, but that is a much finer corner cas=
e requiring discovery events at a higher frequency than the revalidatio=
n period can handle. Not sure if I have the stomach to wait for a rewri=
te of libsas ... Besides I feel libsas 'mostly works' and for today jus=
t needs a few tweaks (evolution, not revolution).

Sincerely -- Mark Salyzyn

-----Original Message-----
=46rom: Luben Tuikov [mailto:ltuikov@yahoo.com]=20
Sent: Thursday, September 01, 2011 1:18 PM
To: Mark Salyzyn; linux-scsi@vger.kernel.org
Cc: Darrick J Wong; James Bottomley
Subject: Re: [PATCH] [SCSI]: libsas failure to revalidate domain for an=
ything but the first expander child.

----- Original Message -----

> In an enclosure model where there are chaining expanders to a large b=
ody
> of storage, it was discovered that libsas, responding to a broadcast
> event change, would only revalidate the domain of first child expande=
r
> in the list.
>=20
> The issue is that the pointer value to the discovered source device w=
as
> used to break out of the loop, rather than the content of the pointer=
=2E
>=20
> This still remains non-compliant as the revalidate domain code is
> supposed to loop through all child expanders, and not stop at the fir=
st
> one it finds that reports a change count. However, the design of this
> routine does not allow multiple device discoveries and that would be =
a
> more complicated set of patches reserved for another day. We are fixi=
ng
> the glaring bug rather than refactoring the code.

Obviously I've tested this both when I was at Adaptec and at Vitesse. I=
'd connect
7-8 expanders, run iogen with 1000 threads to say 30-40 disks, and then=
 unplug
the port between a level 1 and 2 expander and the I/O would quiesce, io=
gen would
report a subset of the disks missing, and then when the port was reesta=
blished,
I/O would restart. However I'm not sure that Bottomley tested this scen=
ario after
changing my code off-line before submitting it into the Linux kernel.

Now a few notes to mention: Your patch patches a function called
sas_find_bcast_dev(). My original code does NOT have such a function.
Revalidation is much more subtle and the code looks simpler in my origi=
nal
version. In my original code there is a lot more recursion, symmetry an=
d
code mirroring. Granted, while such code is shorter, and simpler, it is=
 harder
to figure out what it does, and I feel this is exactly why we see the c=
urrent
state of libsas to be so explicit, simplistic and introducing bugs. See=
 this:
http://marc.info/?l=3Dlinux-scsi&m=3D131480962006471&w=3D2 where I desc=
ribed
the state of libsas recently.

> Please note, as I am *stuck* on Outlook as per company policy, the
> following inline content will likely not patch clean even emailed as
> 'Plain Text', the enclosed attached file should do the job. I have=20
> Cc'd
> all the folks that originated the files in libsas, as there was no
> listed MAINTAINERs.
>=20
> Checkpatch.pl reports clean. Patch applies cleanly to a WIDE variety =
of
> kernels up to latest.
>=20
> Sincerely -- Mark Salyzyn
>=20
> Cc: Luben Tuikov <tuikov@yahoo.com>
> Cc: Darrick J Wong <djwong@us.ibm.com>
> Cc: James Bottomley <jbottomley@parallels.com>
>=20
> Signed-off-by: Mark Salyzyn <msalyzyn@us.xyratex.com>
>=20
> sas_expander.c |=A0 =A0 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff -ru scsi-misc-2.6/drivers/scsi/libsas/sas_expander.c
> scsi-misc-2.6.new/drivers/scsi/libsas/sas_expander.c
> --- scsi-misc-2.6/drivers/scsi/libsas/sas_expander.c=A0=A0=A0 2011-08=
-31
> 08:32:21.000000000 -0400
> +++ scsi-misc-2.6.new/drivers/scsi/libsas/sas_expander.c
> 2011-09-01 08:57:55.000000000 -0400
> @@ -1721,7 +1721,7 @@
> =A0=A0=A0 list_for_each_entry(ch, &ex->children, siblings) {
> =A0=A0=A0 =A0=A0=A0 if (ch->dev_type =3D=3D EDGE_DEV || ch->dev_type =
=3D=3D
> FANOUT_DEV) {
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 res =3D sas_find_bcast_dev(ch, src_dev)=
;
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (src_dev)
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (*src_dev)
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return res;
> =A0=A0=A0 =A0=A0=A0 }
> =A0=A0=A0 }
>
______________________________________________________________________
This email may contain privileged or confidential information, which sh=
ould only be used for the purpose for which it was sent by Xyratex. No =
further rights or licenses are granted to use such information. If you =
are not the intended recipient of this message, please notify the sende=
r by return and delete it. You may not use, copy, disclose or rely on t=
he information contained in it.
=20
Internet email is susceptible to data corruption, interception and unau=
thorised amendment for which Xyratex does not accept liability. While w=
e have taken reasonable precautions to ensure that this email is free o=
f viruses, Xyratex does not accept liability for the presence of any co=
mputer viruses in this email, nor for any losses caused as a result of =
viruses.
=20
Xyratex Technology Limited (03134912), Registered in England & Wales, R=
egistered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
=20
The Xyratex group of companies also includes, Xyratex Ltd, registered i=
n Bermuda, Xyratex International Inc, registered in California, Xyratex=
 (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) C=
o Ltd registered in The People's Republic of China and Xyratex Japan Li=
mited registered in Japan.
______________________________________________________________________
=20
=0D
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
