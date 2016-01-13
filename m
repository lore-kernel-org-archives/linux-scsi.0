From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM ATTEND][LSF/MM TOPIC] Multipath redesign
Date: Wed, 13 Jan 2016 12:46:12 +0100
Message-ID: <56963904.7050801@suse.de>
References: <56961493.5010901@suse.de> <56962BDB.4080509@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933890AbcAMLqQ (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 06:46:16 -0500
In-Reply-To: <56962BDB.4080509@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

On 01/13/2016 11:50 AM, Sagi Grimberg wrote:
>
>> Hi all,
>>
>> I'd like to attend LSF/MM and would like to present my ideas for a
>> multipath redesign.
>>
>> The overall idea is to break up the centralized multipath handling i=
n
>> device-mapper (and multipath-tools) and delegate to the appropriate
>> sub-systems.
>
> I agree that would be very useful. Great topic. I'd like to attend
> this talk as well.
>
>>
>> Individually the plan is:
>> a) use the 'wwid' sysfs attribute to detect multipath devices;
>>     this removes the need of the current 'path_id' functionality
>>     in multipath-tools
>
> CC'ing Linux-nvme,
>
> I've recently looked at multipathing support for nvme (and nvme over
> fabrics) as well. For nvme the wwid equivalent is the nsid (namespace
> identifier). I'm wandering if we can have better abstraction for
> user-space so it won't need to change its behavior for scsi/nvme.
> The same applies for the the timeout attribute for example which
> assumes scsi device sysfs structure.
>
My idea for this is to lookup the sysfs attribute directly from=20
multipath-tools. As such we would need to have some transport=20
information in multipath so that we know where to find it.
And with that we should easily able to accomodate NVMe, provided the=20
nsid is displayed somewhere in sysfs.

>> b) leverage topology information from scsi_dh_alua (which we will
>>     have once my ALUA handler update is in) to detect the multipath
>>     topology. This removes the need of a 'prio' infrastructure
>>     in multipath-tools
>
> This would require further attention for nvme.
>
Indeed. But then I'm not sure how multipath topology would be=20
represented in NVMe; we would need some way of transmitting the=20
topology information.
Easiest would be to leverage VPD device information; so we only need=20
the equivalent of REPORT TARGET PORT GROUPS to implement an=20
ALUA-like scenario.

>> c) implement block or scsi events whenever a remote port becomes
>>     unavailable. This removes the need of the 'path_checker'
>>     functionality in multipath-tools.
>
> I'd prefer if we'd have it in the block layer so we can have it for a=
ll
> block drivers. Also, this assumes that port events are independent of
> I/O. This assumption is incorrect in SRP for example which detects po=
rt
> failures only by I/O errors (which makes path sensing a must).
>
That's what I though initially, too.
But then we're facing a layering issue:
The path events are generated at the _transport_ level.
So for SCSI we have to do a redirection
transport layer->scsi layer->scsi ULD->block device
requiring us to implement for sets of callback functions.
Which I found rather pointless (and time consuming), so I opted for=20
scsi events (like we have for UNIT ATTENTION) instead.

However, even now we're having two sets of events (block events and=20
scsi events) with a certain overlap, so this really could do with a=20
cleanup.

>> d) leverage these events to handle path-up/path-down events
>>     in-kernel
>> e) move the I/O redirection logic out of device-mapper proper
>>     and use blk-mq to redirect I/O. This is still a bit of
>>     hand-waving, and definitely would need discussion to figure
>>     out if and how it can be achieved.
>>     This is basically the same topic Mike Snitzer proposed, but
>>     coming from a different angle.
>
> Another (adjacent) topic is multipath performance with blk-mq.
>
> As I said, I've been looking at nvme multipathing support and
> initial measurements show huge contention on the multipath lock
> which really defeats the entire point of blk-mq...
>
> I have yet to report this as my work is still in progress. I'm not su=
re
> if it's a topic on it's own but I'd love to talk about that as well..=
=2E
>
Oh, most definitely. There are some areas in blk-mq which need to be=20
covered / implemented before we can even think of that (dynamic=20
queue reconfiguration and disabled queue handling being the most=20
prominent).

_And_ we have the problem of queue mapping (one queue per ITL nexus?
one queue per hardware queue per ITL nexus?) which might quickly=20
lead to a queue number explosion if we've not careful.

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
