From: Hannes Reinecke <hare@suse.de>
Subject: Re: IO failures with SMR drives at latest kernel versions
Date: Mon, 24 Aug 2015 08:15:15 +0200
Message-ID: <55DAB673.10903@suse.de>
References: <CAOMFOmVFqOvr7AZQ0hie3LB3ReUcNV3rav5Dk_uf2aHoq-LK4A@mail.gmail.com> <CAOMFOmXSrG82TFmHFTiCQoG3hkwJ69+U5Z=fXfbbgdf=xjTaJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbbHXGPR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Aug 2015 02:15:17 -0400
In-Reply-To: <CAOMFOmXSrG82TFmHFTiCQoG3hkwJ69+U5Z=fXfbbgdf=xjTaJQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anatol Pomozov <anatol.pomozov@gmail.com>, Linux SCSI List <linux-scsi@vger.kernel.org>
Cc: hch@lst.de, Tejun Heo <tj@kernel.org>

On 08/22/2015 07:23 PM, Anatol Pomozov wrote:
> Hi
>=20
> On Fri, Aug 21, 2015 at 10:37 PM, Anatol Pomozov
> <anatol.pomozov@gmail.com> wrote:
>> Discs are from different batches and I was a bit surprised to see
>> identical failures at the same time. I was ready send the drives to
>> RMA but then I discovered this thread
>> https://bbs.archlinux.org/viewtopic.php?id=3D199351 A lot of people
>> report the same problem as mine. It was found that the problem appea=
rs
>> only starting from 3.19, with kernel 3.18 or Windows these drives wo=
rk
>> fine. It is recommended to revert this change
>> 9162c6579bf90b3f5ddb7e3a6c6fa946c1b4cbeb "libata: Implement
>> ATA_DEV_ZAC" that seems fixes the issue.
>=20
> I looked at this commit and it actually adds SMR support to SCSI
> layer. Reverting ATA_DEV_ZAC means going back to zones-unaware
> algorithms. It is suboptimal but still much better than IO failures
> and "BTRFS: lost page write due to I/O error on /dev/sdc" errors I se=
e
> at my computer.
>=20
> If this SMR support is considered as non-stable, can we at least get =
a
> kernel boot (or config) option that disables ZAC?
>=20
Again: Has anybody actually _tested_ that reverting this patch fixes
this issue?
Or even a proper bisect?

Needless to say, my drives work without issues, so I can't really
reproduce this issue.

Which disks are these?

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
