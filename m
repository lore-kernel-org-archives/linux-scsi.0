From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [LSF/MM TOPIC] Improving Asynchronous SCSI Disk Probing
Date: Mon, 22 Jan 2018 06:06:01 +0000
Message-ID: <730B5E23-4387-4C88-A0FE-BA58955825D5@cavium.com>
References: <1516231473.2820.81.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0068.outbound.protection.outlook.com ([104.47.36.68]:56130
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750926AbeAVGGD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Jan 2018 01:06:03 -0500
In-Reply-To: <1516231473.2820.81.camel@wdc.com>
Content-Language: en-US
Content-ID: <9AF025EA9FFECD4A91221908403D44AA@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>

Hi Bart,=20

> On Jan 17, 2018, at 3:24 PM, Bart Van Assche <bart.vanassche@wdc.com> wro=
te:
>=20
> When the SCSI scanning code discovers a SCSI device it calls the driver c=
ore
> function device_add() to associate a SCSI ULD with the device. The driver
> core invokes the probing function for the matching SCSI ULP, e.g. sd_prob=
e().
> In order to minimize the time needed to scan SCSI targets that have a lar=
ge
> number of LUNs, the SCSI disk driver scans LUNs asynchronously by startin=
g
> the actual probing work asynchronously from inside sd_probe()
>=20
> An unfortunate aspect of how SCSI disk probing works today is that there =
is
> unnecessary serialization between probing and removal activity. For a
> possible approach of how to increase SCSI disk probing concurrency, see a=
lso
> [PATCH] sd: Increase SCSI disk probing concurrency, linux-scsi mailing li=
st,
> December 2017 (https://www.spinics.net/lists/linux-scsi/msg115657.html).
>=20
> A second unfortunate aspect of SCSI disk probing is that certain race
> conditions in the block layer are hit if removal starts before asynchrono=
us
> probing has finished. This is because the driver core is unaware that the
> SCSI disk code works asynchronously.
>=20
> Additionally, the SCSI disk asynchronous probing approach is incompatible
> with the power management code. The power management code calls
> wait_for_device_probe() in the driver core to wait for device probing
> activity to finish. wait_for_device_probe() however is unaware of the
> asynchronous probing in the SCSI sd driver and hence doesn't wait for the
> SCSI sd probing activity to finish.
>=20
> My proposal is to hold a session to discus potential solutions for
> increasing SCSI disk probing concurrency in a way that is compatible with
> the driver core and the power management subsystem.

We have run into issue with asyc probing and would be interested in the dis=
cussion.

Thanks,
- Himanshu
