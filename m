From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V2 0/2] initial submit of Microsemi smartpqi driver
Date: Fri, 10 Jun 2016 11:56:45 +0200
Message-ID: <575A8EDD.5040803@suse.de>
References: <146549801043.16211.9235237852162154026.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35632 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932224AbcFJJ4y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2016 05:56:54 -0400
In-Reply-To: <146549801043.16211.9235237852162154026.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 06/09/2016 08:50 PM, Don Brace wrote:
> These patches are based on Linus's tree
>=20
> - add smartpqi to kernel.org
> - remove PCI IDs from aacraid driver
>   - Depends on adoption of smartpqi driver
>=20
> Changes since initial upload
>  - Forgot to give correct ownership to the author.
> Changes since V1
>  - Corrected make ARCH=3Di386 kbuild test robot issue.
>=20
> ---
>=20
> Don Brace (1):
>       aacraid: remove wildcard for series 9 controllers
>=20
> Kevin Barnett (1):
>       smartpqi: initial commit of Microsemi smartpqi driver
>=20
>=20
>  drivers/scsi/smartpqi/Kconfig                  |   50=20
>  drivers/scsi/smartpqi/Makefile                 |    3=20
>  drivers/scsi/smartpqi/smartpqi.h               | 1135 ++++
>  drivers/scsi/smartpqi/smartpqi_init.c          | 6817 ++++++++++++++=
++++++++++
>  drivers/scsi/smartpqi/smartpqi_sas_transport.c |  350 +
>  drivers/scsi/smartpqi/smartpqi_sis.c           |  394 +
>  drivers/scsi/smartpqi/smartpqi_sis.h           |   32=20
>  7 files changed, 8781 insertions(+)
>  create mode 100644 drivers/scsi/smartpqi/Kconfig
>  create mode 100644 drivers/scsi/smartpqi/Makefile
>  create mode 100644 drivers/scsi/smartpqi/smartpqi.h
>  create mode 100644 drivers/scsi/smartpqi/smartpqi_init.c
>  create mode 100644 drivers/scsi/smartpqi/smartpqi_sas_transport.c
>  create mode 100644 drivers/scsi/smartpqi/smartpqi_sis.c
>  create mode 100644 drivers/scsi/smartpqi/smartpqi_sis.h
>=20
Some general comments:
- Wouldn't it be better to split off CISS specific definitions from
smartpqi.h into a separate header file? I guess this even could be
shared with hpsa, right?
- In the same vein: Maybe it's worth considering splitting off the PQI
specific ones into a separate header file, too, and just keeping the
smartpqi.h file for the driver specific definitions.
- The device rescan / device mapping functionality is positively
horrible. I still think it was a mistake having that in hpsa, but I'd b=
e
loath to see this one repeated in smartpqi. Why can't you use the LUN
numbers directly? It's _quite_ easy to have the RAID and passthrough
devices on a separate SCSI bus, so that shouldn't be an issue.
- The 'devices' sysfs attribute is a sysfs abuse. As per definition eac=
h
sysfs attribute should be a single entry. If you want/need to have a
listing consider adding a sysfs directory for the devices.
But then again, if you drop the device rescan/mapping functionality and
use the LUN numbers directly none of these would matter and the
'devices' attribute could be dropped, too.
- Statistics. Using atomics for each variable and enabling them by
default is not a good idea. I'd prefer to have it optional; have you
checked using debugfs for this?
- 'host_wellness' is cute. Do we get a Spa to go with it?
- pqi_alloc_io_request() has this weird 'while' loop. I was under the
impression that the block layer would guarantee tag uniqueness, so why
don't you use the request tag to identify the command from the request
pool (and split the number of tags per hardware queue)?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
