From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [LSF/MM TOPIC] multiqueue and interrupt assignment
Date: Thu, 3 Mar 2016 15:59:27 +0800
Message-ID: <CACVXFVN=wo3xxJ0i1WR02i2udm9DL5HgQ-=GaPw+PbenK_uT=g@mail.gmail.com>
References: <56B0D9CF.1080001@suse.de>
	<56B0F41B.8010706@sandisk.com>
	<56B1F951.5010001@dev.mellanox.co.il>
	<56B1FCFC.2010104@suse.de>
	<56B20173.10006@dev.mellanox.co.il>
	<56B216B7.309@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:36552 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbcCCH72 convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Thu, 3 Mar 2016 02:59:28 -0500
In-Reply-To: <56B216B7.309@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, Bart Van Assche <bart.vanassche@sandisk.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

On Wed, Feb 3, 2016 at 11:03 PM, Hannes Reinecke <hare@suse.de> wrote:
> On 02/03/2016 02:32 PM, Sagi Grimberg wrote:
>>
>>> Indeed, something like this.
>>> Quite some issues would be solved if we could push a hctx mapping
>>> into blk-mq, instead of having it assign its own made-up one.
>>
>> For that you can provide your own .map_queue in blk_mq_ops I think
>> (no one does that at the moment). This requires every driver to
>> implement it's own routine (probably with a similar logic) though...
>
> And at the same time direct interrupt assigment from the driver is
> frowned upon ... feels a bit stupid, having to setup a cpu-to-queue
> assigment (which typically is identical to the cpu-to-msix
> assignment), then pass this information to blk-mq, which then passed
> it to user-space, which then uses the information to setup a
> cpu-to-msix assignment.
> There is room for improvement there ...
>
> Are there any plans addressing this in blk-mq?

Last year, I sent a patchset to address the issue[1], but
it wasn't good enough for merge, and I am happy to discuss
the issue further.

[1] http://marc.info/?t=3D144349691100002&r=3D1&w=3D2

> What does NVMe and virtio do?

virtio just takes the default irq affinity setting,  which means
the irq for one vq is only handled by the 1st CPU when it is
set to route to a group of CPU.

=46or NVMe, I remembered that the irq affinity setting is still
fixed after setting up the queue, and it should be better to
adjust it after hw/sw queue mapping is changed.

Thanks,
Ming

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Teamlead Storage & Networking
> hare@suse.de                                   +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=C3=BCrnberg)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-block=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Ming Lei
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
