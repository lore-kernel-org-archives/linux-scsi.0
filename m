From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 3/3] Import fw-sbp2 driver.
Date: Fri, 15 Dec 2006 19:27:56 +0100
Message-ID: <4582E92C.7030004@s5r6.in-berlin.de>
References: <20061205052229.7213.38194.stgit@dinky.boston.redhat.com> <20061205052253.7213.41796.stgit@dinky.boston.redhat.com> <45750C9A.607@garzik.org> <4581B88C.9040104@redhat.com> <4581C4D1.8090803@s5r6.in-berlin.de> <4582BA68.1010303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751720AbWLOS17@vger.kernel.org>
In-Reply-To: <4582BA68.1010303@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

(added Cc: lsml)

Kristian H=F8gsberg wrote at lkml:
> I saw that the stack
[the FireWire stack]
> creates a struct device per LUN, which is kinda gross in my opinion.

If you mean regular "unit directories" here, not SCSI LUs, then one
device per unit makes sense. Different units of a node may implement
different protocols and may have different lifetimes.

If you mean the special representation of SBP-2 logical units by
multiple leaf entries in one and the same unit directory (Why the heck
did they allow two different representations?), then you are right that
the burden could certainly be shifted from the FireWire core to the
SBP-2 protocol driver, WRT ROM scanning and generic device representati=
on.

> It's easy enough to discover the LUNs from the rom, I just need to
> figure out how to tell the SCSI stack about multiple LUNs.

Since REPORT LUNS is not guaranteed to work with SBP-2 targets, we stic=
k
to scsi_add_device(). With some effort we could supply scsi_add_device(=
)
with common instances of Scsi_Host and target for units which reside on
the same target. Alas the scsi_add_device() API has a concept of target
which is quite unfit for most SCSI transports other than SPI. We have
got the following alternatives:
 - Implement a mapping of SAM targets to scsi_add_device targets in
   sbp2. Effectively, map from pointer or EUI-64 to uint. <linux/idr.h>
   has an infrastructure for such a mapping.
   (This is not the Linux way of doing things, but wicked people may be
   tempted to call it 'the Linux SCSI way so far'.)
 - Reform the scsi_add_device API to support SAM targets.
 - Leave stuff as is, concentrate on fixing the FireWire stack's issues
   first.
If you look closely, you see the order of list items reflecting my
personal preference. :-)

Of course, as mentioned before, a precondition to represent multiple LU=
s
beneath a single representation of a target is to convert sbp2 to
instantiante only one Scsi_Host for many or all SBP-2 units.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D- =3D=3D-- -=3D=3D=3D=3D
http://arcgraph.de/sr/
