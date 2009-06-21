From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 13594] New: SMART responses for SATA disks on SAS get
 interpreted as errors
Date: Sun, 21 Jun 2009 13:47:51 -0500
Message-ID: <1245610071.4328.232.camel@mulgrave.site>
References: <bug-13594-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44576 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbZFUSrx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Jun 2009 14:47:53 -0400
In-Reply-To: <bug-13594-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Sun, 2009-06-21 at 17:26 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=3D13594
>=20
>            Summary: SMART responses for SATA disks on SAS get interpr=
eted
>                     as errors
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 2.6.30-rc6
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: sgunderson@bigfoot.com
>         Regression: No
>=20
>=20
> Hi,
>=20
> I just bought a LSI SAS3081E-R which I use against a Supermicro backp=
lane to
> drive ten Seagate SATA disks (7200.11, 750GB and 1.5GB). I'm using th=
e
> standard Linux Fusion MPT device driver (CONFIG_FUSION_SAS) under Lin=
ux
> 2.6.30-rc6. Everything seems to work pretty well, with one exception:=
 When I
> use SMART against the drives (say, smartctl -a /dev/sda) the kernel c=
omplains
> with:
>=20
>   [  811.091916] sd 0:0:0:0: [sda] Sense Key : Recovered Error [curre=
nt]
> [descriptor]
>   [  811.099807] Descriptor sense data with sense descriptors (in hex=
):
>   [  811.106175]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00=
 00
>   [  811.113262]         00 4f 00 c2 00 50
>   [  811.117379] sd 0:0:0:0: [sda] Add. Sense: ATA pass through infor=
mation
> available

This is a message the kernel prints out on all recovered error returns
(except those marked REQ_QUIET).  It's purely informational and doesn't
affect return processing of the command at all, so the kernel is
actually treating this as a successful completion not an error.

> I've tried upgrading to the newest firmware (1.28.02.00, 05-MAY-2009)=
, but
> all that changed is that the hex dump was added to the error message.
>=20
> Whenever this happens, it appears like all the disks =E2=80=9Chiccup=E2=
=80=9D and the kernel
> loses contact with the controller for a small while. If too many of t=
hese
> happen at once, eventually disks start falling off RAIDs, and the ent=
ire
> machine goes down. It looks to me as if these messages should simply =
not be
> treated as errors by the kernel -- smartctl explicitly asks for a res=
ponse even
> if the command doesn't fail (by setting CK_COND), so the response pro=
bably
> shouldn't be taken as an error.

So this sounds like the bug ... however, for the LSI card, this bug wil=
l
be in the SAT layer in the fusion firmware.  I can shut the kernel up b=
y
making the recovered error processing clause look for 01/00/1D as well
as REQ_QUIET, but it won't affect this problem.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
