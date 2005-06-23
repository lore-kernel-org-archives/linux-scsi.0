From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] - mptfusion - adding back the spin locks in eh handle
	rs
Date: Thu, 23 Jun 2005 14:12:27 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C02D506D4@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:21189 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S263081AbVFWUMg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2005 16:12:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: linux scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

On Thursday, June 23, 2005 1:04 PM, Luben Tuikov wrote:
> On 06/23/05 14:20, Moore, Eric Dean wrote:
> > The eh handlers are called with host_lock acquired, and=20
> interrupts disabled.
> > However fusion waits for completion of task managment=20
> request.  With these spin locks=20
> > removed, the driver is going to hang within the sleep=20
> calls.   Someone recently posted=20
> > a patch to remove them(don=B4t know who),  and can be found=20
> in James Bottomely scsi-misc branch. =20
>=20
> That was Jeff, and I thought those patches made it in already.
> They are needed and are a good thing.
>=20
> 	Luben
>=20


Ok, explain that to me why having our driver hang is a good thing.
The task managment requests to our firmware stack are done in interrupt
mode,
thus we have sleep and have interrupts enabled in the eh threads waitin=
g on
the commands to complete.
Christoph H. requested this change about 6 months ago, asking that we r=
emove
our watchdog timers in the eh threads, in favor of this design.

Eric Moore
LSI Logic Corporation

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
