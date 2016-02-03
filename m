From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC] multiqueue and interrupt assignment
Date: Wed, 3 Feb 2016 14:13:32 +0100
Message-ID: <56B1FCFC.2010104@suse.de>
References: <56B0D9CF.1080001@suse.de> <56B0F41B.8010706@sandisk.com>
 <56B1F951.5010001@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbcBCNNe (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Wed, 3 Feb 2016 08:13:34 -0500
In-Reply-To: <56B1F951.5010001@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Bart Van Assche <bart.vanassche@sandisk.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

On 02/03/2016 01:57 PM, Sagi Grimberg wrote:
> Hi Bart and Hannes,
>=20
>> This topic indeed needs further attention. I also encountered this
>> challenge while adding scsi-mq support to the SRP initiator
>> driver. What
>> I learned while working on the SRP driver is the following:
>> - Although I agree that requests and interrupts should be
>> processed on
>>    the same processor (same physical chip) if the request has been
>>    submitted from the CPU closest to the HBA, I'm not convinced that
>>    processing request completions and interrupts on the same CPU cor=
e
>>    yields the best performance. I would appreciate it if there would
>>    remain some freedom in how to assign interrupts to CPU cores.
>=20
> This is true not only for this reason. Some block storage transports
> (e.g. srp/iser) share the HBA with the networking stack and possibly
> with user-space workloads in the case of RDMA. This is why I don't se=
e
> how would MSIX assignments can be done anywhere other than user-space=
=2E
>=20
Oh, I don't doubt that we should allow to have the MSIX assignments
from user-space.
But ATM block-mq assigned a fixed CPU <-> hardware queue mapping,
and all we can do is to fixup things afterwards.
Irrespective on whether it's 'best' for any given hardware.

> However what I think we can do is have blk-mq ask the drivers
> information about the MSIX mappings. This concept was introduced in
> 2011 by Ben Hutchings with the CPU affinity reverse-mapping API [1].
>=20
> Perhaps we'd want to have drivers provide blk-mq a struct cpu_rmap wh=
en
> assigning the hctx mappings, or possibly per I/O if we want to be
> agnostic to MSIX topology changes. I think this approach would solve
> Hannes is experiencing.
>=20
> Thoughts?
>=20
Indeed, something like this.
Quite some issues would be solved if we could push a hctx mapping
into blk-mq, instead of having it assign its own made-up one.

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
