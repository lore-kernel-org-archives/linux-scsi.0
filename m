From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Proposals to change the way all drivers work with SCSI commands
Date: Fri, 11 May 2007 23:58:30 +0200
Message-ID: <4644E706.5030102@s5r6.in-berlin.de>
References: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>	 <4644DE1F.8050107@s5r6.in-berlin.de> <59ad55d30705111430o3142dd6m37c05475a1b3c6dd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:39780 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831AbXEKV6o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2007 17:58:44 -0400
In-Reply-To: <59ad55d30705111430o3142dd6m37c05475a1b3c6dd@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Kristian H=F8gsberg wrote:
> On 5/11/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> James Bottomley wrote:
>> > It strikes me that in all of this, we could also consider doing th=
e DMA
>> > mapping inside the mid layer (instead of in every driver).
=2E..
>> The old SBP-2 driver needs the virtual addresses of S/G elements if
>> compiled with a certain config option.  This option is meant for use
>> with FireWire controllers which do not implement OHCI-1394, or to ru=
n
>> the IEEE 1394 stack in a more secure mode.
=2E..
> Well, if we want to make a more secure mode for fw-sbp2.c where it,
> like the old driver, manually copies the payload data from the genera=
l
> async receive buffer to the destination, we'll still need the virtual
> address.

Yes, that's right. /If/ we are going to implement such a mode, then (a)
the virtual addresses have to be passed down to ->queuecommand, and (b)
DMA mapping would be unnecessary and wasteful.

(For the list:  By "secure" we mean that we wouldn't allow the FireWire
controller to act as a bus bridge, and would be able to do boundary
checks on local bus addresses which, in the SBP-2 protocol, are
generally coming from the _target_.  Without such a mode, the lower 4G
of the initiator's memory are at the mercy of the target's firmware.)

> How does the usb storage driver handle this?
>=20
> Kristian

--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D=3D -=3D-=3D -=3D-=3D=3D
http://arcgraph.de/sr/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
