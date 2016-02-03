From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC] multiqueue and interrupt assignment
Date: Wed, 3 Feb 2016 16:03:19 +0100
Message-ID: <56B216B7.309@suse.de>
References: <56B0D9CF.1080001@suse.de> <56B0F41B.8010706@sandisk.com>
 <56B1F951.5010001@dev.mellanox.co.il> <56B1FCFC.2010104@suse.de>
 <56B20173.10006@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932499AbcBCPDV (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Wed, 3 Feb 2016 10:03:21 -0500
In-Reply-To: <56B20173.10006@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Bart Van Assche <bart.vanassche@sandisk.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

On 02/03/2016 02:32 PM, Sagi Grimberg wrote:
>=20
>> Indeed, something like this.
>> Quite some issues would be solved if we could push a hctx mapping
>> into blk-mq, instead of having it assign its own made-up one.
>=20
> For that you can provide your own .map_queue in blk_mq_ops I think
> (no one does that at the moment). This requires every driver to
> implement it's own routine (probably with a similar logic) though...

And at the same time direct interrupt assigment from the driver is
frowned upon ... feels a bit stupid, having to setup a cpu-to-queue
assigment (which typically is identical to the cpu-to-msix
assignment), then pass this information to blk-mq, which then passed
it to user-space, which then uses the information to setup a
cpu-to-msix assignment.
There is room for improvement there ...

Are there any plans addressing this in blk-mq?
What does NVMe and virtio do?

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
