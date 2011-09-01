From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [SCSI]: libsas failure to revalidate domain for anything but the first expander child.
Date: Thu, 1 Sep 2011 10:18:21 -0700 (PDT)
Message-ID: <1314897501.64142.YahooMailNeo@web31807.mail.mud.yahoo.com>
References: <20110730002509.28735.82590.stgit@localhost6.localdomain6> <FC1F9E38C0703341A1A750524E2525A901853EC8@XYUS-EX22.xyus.xyratex.com> <FC1F9E38C0703341A1A750524E2525A901853F74@XYUS-EX22.xyus.xyratex.com>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm21-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.216]:35261 "HELO
	nm21-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755257Ab1IARZS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Sep 2011 13:25:18 -0400
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A901853F74@XYUS-EX22.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Darrick J Wong <djwong@us.ibm.com>, James Bottomley <jbottomley@parallels.com>

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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
