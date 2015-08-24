From: Hannes Reinecke <hare@suse.de>
Subject: Re: IO failures with SMR drives at latest kernel versions
Date: Mon, 24 Aug 2015 08:11:06 +0200
Message-ID: <55DAB57A.70906@suse.de>
References: <CAOMFOmVFqOvr7AZQ0hie3LB3ReUcNV3rav5Dk_uf2aHoq-LK4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbbHXGLI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Aug 2015 02:11:08 -0400
In-Reply-To: <CAOMFOmVFqOvr7AZQ0hie3LB3ReUcNV3rav5Dk_uf2aHoq-LK4A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anatol Pomozov <anatol.pomozov@gmail.com>, Linux SCSI List <linux-scsi@vger.kernel.org>
Cc: hch@lst.de, Tejun Heo <tj@kernel.org>

On 08/22/2015 07:37 AM, Anatol Pomozov wrote:
> Hi
>=20
> I recently got 2 Seagate 8Tb drives. 'dd' over whole disc ran fine.
> Then I inserted into my RAID and started rebalancing. I've got
> following error almost immediately:
>=20
>=20
>=20
> ata5.00: failed command: WRITE FPDMA QUEUED
> ata5.00: cmd 61/00:e0:80:e7:75/1d:00:9f:00:00/40 tag 28 ncq 3801088 o=
ut
>                                        res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata5.00: status: { DRDY }
> ata5.00: failed command: WRITE FPDMA QUEUED
> ata5.00: cmd 61/80:e8:80:04:76/1d:00:9f:00:00/40 tag 29 ncq 3866624 o=
ut
>                                        res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata5.00: status: { DRDY }
> ata5: hard resetting link
> ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
> ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtere=
d out
> ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY)
> filtered out
> ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
> ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtere=
d out
> ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY)
> filtered out
> ata5.00: configured for UDMA/133
> ata5.00: device reported invalid CHS sector 0
> ata5.00: device reported invalid CHS sector 0
> ata5.00: device reported invalid CHS sector 0
> ata5.00: device reported invalid CHS sector 0
> ata5.00: device reported invalid CHS sector 0
> ata5.00: device reported invalid CHS sector 0
> ata5.00: device reported invalid CHS sector 0
> ata5.00: device reported invalid CHS sector 0
> ata5.00: device reported invalid CHS sector 0
> ata5.00: device reported invalid CHS sector 0
> ata5.00: device reported invalid CHS sector 0
>=20
>=20
>=20
> Discs are from different batches and I was a bit surprised to see
> identical failures at the same time. I was ready send the drives to
> RMA but then I discovered this thread
> https://bbs.archlinux.org/viewtopic.php?id=3D199351 A lot of people
> report the same problem as mine. It was found that the problem appear=
s
> only starting from 3.19, with kernel 3.18 or Windows these drives wor=
k
> fine. It is recommended to revert this change
> 9162c6579bf90b3f5ddb7e3a6c6fa946c1b4cbeb "libata: Implement
> ATA_DEV_ZAC" that seems fixes the issue.
>=20
Please clarify: Have you _checked_ that it fixes this issue?

The above patch just adds a new ATA device type, and the necessary
changes to have it detected correctly.
I find it extremely unlikely it being the culprit here.

> There is also the same issue reported at kernel.org
> https://bugzilla.kernel.org/show_bug.cgi?id=3D93581
>=20
>=20
> This issue is extremely annoying and makes negative SMR drives user
> experience. Had anybody look at this bug?
>=20
Did you attempt a bisect to find out the offending patch?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
