From: Olaf Hering <olh@suse.de>
Subject: Re: [PATCH] fix sym2 negotiation
Date: Wed, 25 Aug 2004 11:25:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040825092541.GA15466@suse.de>
References: <1093113450.1732.334.camel@mulgrave> <20040824132936.GA25263@suse.de> <20040824203914.GA25755@us.ibm.com> <20040824205126.GA10105@suse.de> <20040825065747.GA2275@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:46000 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S264903AbUHYJZn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 05:25:43 -0400
Content-Disposition: inline
In-Reply-To: <20040825065747.GA2275@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, willy@debian.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Anton Blanchard <anton@samba.org>

 On Tue, Aug 24, Mike Anderson wrote:

> Olaf Hering [olh@suse.de] wrote:
> >  On Tue, Aug 24, Mike Anderson wrote:
> >=20
> > > I would guess this cdrom is behind a ACARD. We have had issues in
> > > the past with negotiation / interaction between the ACARD and the=
 sym.=20
> >=20
> > Oh, that would be possible. I will look through our patches and fin=
d the
> > one that adds an insane delay. Maybe it helps.
> >=20
>=20
> Yes increasing scsi_inq_timeout to 27 seconds makes the messages go a=
way
> on my system. Prior to increasing the timeout I bk pulled scsi-misc-2=
=2E6
> and received the same ABORT recovery sequence you did.

This patch fixed it. I'm sure this was already discussed on to dead, we
hit this bug initally one year ago with 2.4.21.


=2E...

garloff@suse.de

Workaround

This broken chip seems to be so popular on PPC64 that the arch maintain=
ers
want a PPC64 specific default. Oh well ...

diff -uNrp linux-2.6.5.inq_timeout/drivers/scsi/scsi_scan.c linux-2.6.5=
=2Einq_timeout.ppc64/drivers/scsi/scsi_scan.c
--- linux-2.6.5.inq_timeout/drivers/scsi/scsi_scan.c    2004-04-21 14:3=
2:04.000000000 +0200
+++ linux-2.6.5.inq_timeout.ppc64/drivers/scsi/scsi_scan.c      2004-04=
-21 14:44:05.000000000 +0200
@@ -94,7 +94,17 @@ MODULE_PARM_DESC(max_report_luns,
                 "REPORT LUNS maximum number of LUNS received (should b=
e"
                 " between 1 and 16384)");
=20
+/* Some AChip ARC765 based DVD-ROM's take 15 or more seconds
+ * to reset.  A scan will fail if made right after a reset.
+ * It's completely broken device behaviour: SCSI specification
+ * says devices need to be able to respond to INQUIRY always
+ * (after a selection timeout ... of 250ms).
+ */
+#ifdef __powerpc64__
+static unsigned int scsi_inq_timeout =3D SCSI_TIMEOUT/HZ+25;
+#else
 static unsigned int scsi_inq_timeout =3D SCSI_TIMEOUT/HZ+3;
+#endif
=20
 module_param_named(inq_timeout, scsi_inq_timeout, int, S_IRUGO|S_IWUSR=
);
 MODULE_PARM_DESC(inq_timeout,=20



--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
