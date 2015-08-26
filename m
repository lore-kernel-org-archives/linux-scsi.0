From: Hannes Reinecke <hare@suse.de>
Subject: Re: Persistent Reservation API
Date: Wed, 26 Aug 2015 14:45:59 +0200
Message-ID: <55DDB507.8000403@suse.de>
References: <1438672271-11309-1-git-send-email-hch@lst.de> <20150811113041.68d9f122@g21.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893AbbHZMqB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2015 08:46:01 -0400
In-Reply-To: <20150811113041.68d9f122@g21.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Disseldorp <ddiss@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On 08/11/2015 11:30 AM, David Disseldorp wrote:
> Hi Christoph,
>=20
> On Tue,  4 Aug 2015 09:11:05 +0200, Christoph Hellwig wrote:
>=20
>> This series adds support for a simplified persistent reservation API
>> to the block layer.  The intent is that both in-kernel and userspace
>> consumers can use the API instead of having to hand craft SCSI or NV=
Me
>> command through the various pass through interfaces.  It also adds
>> DM support as getting reservations through dm-multipath is a major
>> pain with the current scheme.
>>
>> NVMe support currently isn't included as I don't have a multihost
>> NVMe setup to test on, but if I can find a volunteer to test it I'm
>> happy to write the code for it.
>>
>> The ioctl API is documented in Documentation/block/pr.txt, but to
>> fully understand the concept you'll have to read up the SPC spec,
>> PRs are too complicated that trying to rephrase them into different
>> terminology is just going to create confusion.
>=20
> Do you have any thoughts on where SCSI-2 RESERVE/RELEASE should fit i=
nto
> this API, if at all? I.e. as a new enum pr_type members for
> pr_reserve()/pr_release(), as separate pr_ops hooks, etc?
> Similarly for PR_IN - IIUC, if LIO is to handle cluster wide PRs
> for Ceph rbd via the block layer, these will all need to be supported
> by block layer (and LIO backend) APIs.
>=20
Just don't. Ignore SCSI-2 RESERVE/RELEASE.

To my knowledge there are _no_ 'real' SCSI-2 systems in the market
anymore; those which you might come across are 'fake' devices,
trying to emulate SCSI-2 for backwards compability despite being in
fact SCSI-3 devices.

I would vote for just ignoring them. Simply not worth the pain.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
