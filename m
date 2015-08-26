From: Hannes Reinecke <hare@suse.de>
Subject: Re: IO failures with SMR drives at latest kernel versions
Date: Wed, 26 Aug 2015 08:40:05 +0200
Message-ID: <55DD5F45.7010905@suse.de>
References: <CAOMFOmVFqOvr7AZQ0hie3LB3ReUcNV3rav5Dk_uf2aHoq-LK4A@mail.gmail.com>	<CAOMFOmXSrG82TFmHFTiCQoG3hkwJ69+U5Z=fXfbbgdf=xjTaJQ@mail.gmail.com>	<55DAB673.10903@suse.de> <CAOMFOmUHzLad4wLMJdAxj+CPKM_GCY3dTZUqpD2icoEJKdJ8uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719AbbHZGkH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2015 02:40:07 -0400
In-Reply-To: <CAOMFOmUHzLad4wLMJdAxj+CPKM_GCY3dTZUqpD2icoEJKdJ8uw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, hch@lst.de, Tejun Heo <tj@kernel.org>

On 08/26/2015 06:53 AM, Anatol Pomozov wrote:
> Hi
>=20
> On Sun, Aug 23, 2015 at 11:15 PM, Hannes Reinecke <hare@suse.de> wrot=
e:
>>> I looked at this commit and it actually adds SMR support to SCSI
>>> layer. Reverting ATA_DEV_ZAC means going back to zones-unaware
>>> algorithms. It is suboptimal but still much better than IO failures
>>> and "BTRFS: lost page write due to I/O error on /dev/sdc" errors I =
see
>>> at my computer.
>>>
>>> If this SMR support is considered as non-stable, can we at least ge=
t a
>>> kernel boot (or config) option that disables ZAC?
>>>
>> Again: Has anybody actually _tested_ that reverting this patch fixes
>> this issue?
>=20
> Yes I tested it.
>=20
> This error happens only under heavy load with a lot of read/writes
> (like btrfs rebalance).
>=20
> With current Linux-4.1.6 'btrfs balance' fails after ~10 minutes afte=
r
> start. I reverted ZAC related changes and then ran rebalancing. The
> operation finished successfully after 3 hours of running.
>=20
Can you be a bit more specific about the 'ZAC related changes'?
There have been several patches, and we really would need to know
which one was the offending one.
Can you try to bisect things here?

Thanks.

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
