From: Gilbert Wu <Gilbert_Wu@adaptec.com>
Subject: Re: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source device
Date: Fri, 31 Aug 2007 14:20:59 -0700
Message-ID: <1188595259.5812.10.camel@linux.site>
References: <1188583419.6353.9.camel@linux.site>
	 <46D85DA4.1070008@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:49755 "HELO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761147AbXHaVHo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Aug 2007 17:07:44 -0400
In-Reply-To: <46D85DA4.1070008@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Fri, 2007-08-31 at 14:27 -0400, Jeff Garzik wrote:
> Gilbert Wu wrote:
> > Subject:  [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source d=
evice
> > driver to fix smartctl utility problem.
> >=20
> > Contribution:
> >    Gilbert Wu <gilbert_wu@adaptec.com>
> >=20
> > Change Log:
> >=20
> >=20
> > 1. Fixed the problem that "smartctl -a /dev/some_sata_disk -d ata"
> >    does not work on aic94xx device drive with SATA devices.
> >    The smartctl utility send down ATA smart command to aic94xx
> >    driver and fail to get the result which is stored on ATA output
> >    register.=20
> >    In normal case, Aic94xx=E2=80=99s firmware does not return the v=
alue of
> >    ATA output register to device driver due to performance reason.
> >    To solve this issue then the driver need to turn on internal
> >    flag (CSMI_TASK) for particular ATA command to enable firmware
> >    to return the value of ATA output register.
> >=20
> >=20
> >=20
> >=20
> > Patch: apply to aic94xx-sas-2.6.git development tree
> >=20
> > Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>
>=20
> NAK
>=20
> 1) re-invents ATA command constants (a third time!).
>=20
> Fix: use the constants in include/linux/ata.h
>=20
>=20
> 2) ignores the large number of ATA commands that also need register o=
utput.
>=20
> Fix: invert the test.  the only time when we do NOT want the ATA=20
> register output is upon successful completion of "hot path" READ/WRIT=
E=20
> commands.  For ALL other cases, we need the D2H FIS and/or SDB FIS da=
ta=20
> reflecting register state.
>=20
>=20
> 3) Patches are normally imported by automated tools, and your email b=
ody=20
> is copied directly into the permanent kernel changelog, archived for =
all=20
> eternity.  As such, you should format your patch description in a=20
> similar fashion to other patches.
>=20
> Fixes:
> a) Subject line way too long and redundant.  Use:
>=20
> 	[PATCH] aic94xx: fix smartctl utility problem
>=20
> Execute 'git log' in the kernel repository for more examples.  The em=
ail=20
> subject is always copied into the kernel changelog as the FIRST LINE =
of=20
> the change.  This is a one-line summary of your patch.
>=20
> b) Do not write "Subject: [...]" in email body.  Make this the subjec=
t=20
> of your email, per guidelines at http://linux.yyz.us/patch-format.htm=
l=20
> and Documentation/SubmittingPatches
>=20
> c) Remove the redundant line
> 	Contribution:
> 	   Gilbert Wu <gilbert_wu@adaptec.com>
> (this is redundant to your email address in the email, and the=20
> Signed-off-by line)
>=20
> d) Remove the redundant line
> 	Change Log:
> (we already know its a changelog)
>=20
> e) Move temporal and meta-comments after the "---" separator, so that=
=20
> this text is not copied into the permanent kernel changelog.  See=20
> Documentation/SubmittingPatches for more info.
>=20
> Regards,
>=20
> 	Jeff
>=20

Hi Jeff,

 Thanks for your comments. I go through each item and rewrite the patch=
=2E

Thanks!
Gilbert
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
