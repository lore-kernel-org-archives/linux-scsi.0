From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux Virtual SCSI HBAs and Virtual disks
Date: Wed, 17 Jan 2007 09:36:47 +0100
Message-ID: <45ADE01F.3020708@s5r6.in-berlin.de>
References: <45ACA765.3030701@aboo.org> <45AD80F3.6020100@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:40789 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbXAQIgs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2007 03:36:48 -0500
In-Reply-To: <45AD80F3.6020100@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Aboo Valappil <aboo@aboo.org>, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> The table would be for different versions as it looks
> like you may need a new one for bleeding edge kernels.
>=20
> I didn't get far trying to build the kernel module
> against lk 2.6.20-rc5:
>=20
> # make
> make -C /lib/modules/2.6.20-rc5/build M=3D/home/upgrades/apps/vscsihb=
a1/vscsihba1/kernel modules
> make[1]: Entering directory `/usr/src/linux-2.6.19'
>   CC [M]  /home/upgrades/apps/vscsihba1/vscsihba1/kernel/hba.o
> /home/upgrades/apps/vscsihba1/vscsihba1/kernel/hba.c:26: warning: =91=
kmem_cache_t=92 is deprecated
>   CC [M]  /home/upgrades/apps/vscsihba1/vscsihba1/kernel/device.o
> /home/upgrades/apps/vscsihba1/vscsihba1/kernel/device.c:263:51: error=
: macro "INIT_WORK" passed 3 arguments, but takes just 2
[...]

Aboo,

the workqueue API changes after 2.6.19 are for example explained here:
http://lwn.net/Articles/213149/
There are a lot of workqueue API conversion patches in 2.6.20-rc1 which
can be taken as example. The first step when converting to the new API
is to determine whether the work has to be delayed sometimes or can
always be queued as immediate work. In the latter case, a slimmed-down
variant of delayed work is used.

The conversion away from kmem_cache_t is trivial. There are also some
patches in 2.6.20-rc1 or later to use as example.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D=3D ---=3D =3D---=3D
http://arcgraph.de/sr/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
