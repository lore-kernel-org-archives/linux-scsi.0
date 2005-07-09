From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sat, 9 Jul 2005 18:56:25 +0200 (CEST)
Message-ID: <200507091656.j69GuP5Y028863@einhorn.in-berlin.de>
References: <1120926901.5008.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:26812 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S261614AbVGIQ46 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Jul 2005 12:56:58 -0400
In-Reply-To: <1120926901.5008.12.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Cc: bcollins@debian.org, James.Bottomley@SteelEye.com, arjan@infradead.org, rbrito@ime.usp.br

On  9 Jul, James Bottomley wrote:
> On Sat, 2005-07-09 at 12:27 -0400, Ben Collins wrote:
>> THese changes break sbp2, and we'll need to revert them in the main =
stream
>> kernel until the patch is tested and fixed in our tree.
>=20
> They cannot be simply reverted.  The API has changed from the EH
> routines being called with the host lock held to being called lockles=
s.
> If you need the lock, you have to take it yourself, which is what the
> changes do from my reading of the code.

The locking change is probably not an issue. I will test it ASAP and
prepare a patch for the linux1394.org repo.

(James, thanks for your explanation and pointers to the history in your
other post.)

> What's the breakage?

There was one report from a -mm tester (Rog=E9rio Brito) who needed to
revert the TYPE_RBC changes to sbp2.[ch]. Else the initial inquiry woul=
d
fail. See the link to the archive in my initial post. Summary of that
report:

-- bad inquiry with TYPE_RBC patch --
ieee1394: sbp2: Logged into SBP-2 device
ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
  Vendor: ST316002  Model: 1A                Rev: 3.06
  Type:   Unknown                            ANSI SCSI revision: 04

-- good inquiry with old sbp2 sources --
ieee1394: sbp2: Logged into SBP-2 device
ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
  Vendor: ST316002  Model: 1A                Rev: 3.06
  Type:   Direct-Access                      ANSI SCSI revision: 06
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
 sda: [mac] sda1 sda2 sda3 sda4
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0

To make the matter a bit more complicated, Rog=E9rio's FireWire disk ha=
s
got another problem with the ieee1394 base driver. Rog=E9rio and I will
try to work these two (perhaps orthogonal) problems out.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D-=3D -=3D=3D=3D -=3D--=3D
http://arcgraph.de/sr/

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
