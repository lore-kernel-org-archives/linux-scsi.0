From: Hannes Reinecke <hare@suse.de>
Subject: Re: complete boot failure in 4.5-rc1 caused by nvme: make SG_IO
 support optional
Date: Mon, 8 Feb 2016 08:26:25 +0100
Message-ID: <56B84321.3010308@suse.de>
References: <1454783624.2809.6.camel@HansenPartnership.com>
 <20160207092241.GA15331@lst.de>
 <1454861040.2329.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56367 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbcBHH01 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Feb 2016 02:26:27 -0500
In-Reply-To: <1454861040.2329.4.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>
Cc: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On 02/07/2016 05:04 PM, James Bottomley wrote:
> On Sun, 2016-02-07 at 10:22 +0100, Christoph Hellwig wrote:
>> Keith said it should be on by default, and I promised him to change
>> it once we run into problems, which I guess this counts as.
>>
>> But just curious:  what distro are you using?  Upstream systemd
>> explicitly rejected using scsi_id for NVMe here:
>>
>> 	https://github.com/systemd/systemd/issues/1453
>>
>> and all my test systems don't do this either.
>=20
> This was SUSE (in my case, openSUSE Leap).  I just checked the source
> package; they patch the by-id rules back in for NVME:
>=20
> # PATCH-FIX-SUSE 1101-rules-persistent-device-names-for-NVMe-devices.=
patch (bsc#944132)
> Patch1101:      1101-rules-persistent-device-names-for-NVMe-devices.p=
atch
>=20
> The bugzilla is giving access denied for bug id 944132, so it's likel=
y
> some proprietary vendor problem.  The patch has no preamble, so it's
> hard to tell what they were thinking.
>=20
They didn't think at all. That abovementioned bug just states 'by-id
symlinks for NVMe drives are missing'.
And they fixed it by add the respective rules (using sg_inq) to udev.

There's no mentioning of any NVMe specific sysfs attributes whatsoever.

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
