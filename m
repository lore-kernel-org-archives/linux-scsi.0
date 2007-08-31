From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source device
Date: Fri, 31 Aug 2007 14:27:48 -0400
Message-ID: <46D85DA4.1070008@garzik.org>
References: <1188583419.6353.9.camel@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:40820 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966031AbXHaS1u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Aug 2007 14:27:50 -0400
In-Reply-To: <1188583419.6353.9.camel@linux.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gilbert Wu <Gilbert_Wu@adaptec.com>
Cc: linux-scsi@vger.kernel.org

Gilbert Wu wrote:
> Subject:  [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source dev=
ice
> driver to fix smartctl utility problem.
>=20
> Contribution:
>    Gilbert Wu <gilbert_wu@adaptec.com>
>=20
> Change Log:
>=20
>=20
> 1. Fixed the problem that "smartctl -a /dev/some_sata_disk -d ata"
>    does not work on aic94xx device drive with SATA devices.
>    The smartctl utility send down ATA smart command to aic94xx
>    driver and fail to get the result which is stored on ATA output
>    register.=20
>    In normal case, Aic94xx=E2=80=99s firmware does not return the val=
ue of
>    ATA output register to device driver due to performance reason.
>    To solve this issue then the driver need to turn on internal
>    flag (CSMI_TASK) for particular ATA command to enable firmware
>    to return the value of ATA output register.
>=20
>=20
>=20
>=20
> Patch: apply to aic94xx-sas-2.6.git development tree
>=20
> Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>

NAK

1) re-invents ATA command constants (a third time!).

=46ix: use the constants in include/linux/ata.h


2) ignores the large number of ATA commands that also need register out=
put.

=46ix: invert the test.  the only time when we do NOT want the ATA=20
register output is upon successful completion of "hot path" READ/WRITE=20
commands.  For ALL other cases, we need the D2H FIS and/or SDB FIS data=
=20
reflecting register state.


3) Patches are normally imported by automated tools, and your email bod=
y=20
is copied directly into the permanent kernel changelog, archived for al=
l=20
eternity.  As such, you should format your patch description in a=20
similar fashion to other patches.

=46ixes:
a) Subject line way too long and redundant.  Use:

	[PATCH] aic94xx: fix smartctl utility problem

Execute 'git log' in the kernel repository for more examples.  The emai=
l=20
subject is always copied into the kernel changelog as the FIRST LINE of=
=20
the change.  This is a one-line summary of your patch.

b) Do not write "Subject: [...]" in email body.  Make this the subject=20
of your email, per guidelines at http://linux.yyz.us/patch-format.html=20
and Documentation/SubmittingPatches

c) Remove the redundant line
	Contribution:
	   Gilbert Wu <gilbert_wu@adaptec.com>
(this is redundant to your email address in the email, and the=20
Signed-off-by line)

d) Remove the redundant line
	Change Log:
(we already know its a changelog)

e) Move temporal and meta-comments after the "---" separator, so that=20
this text is not copied into the permanent kernel changelog.  See=20
Documentation/SubmittingPatches for more info.

Regards,

	Jeff


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
