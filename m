From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] virtio-scsi: Add FC transport class
Date: Mon, 5 Feb 2018 09:07:24 +0100
Message-ID: <4ff72b14-2baf-14d0-4f24-ff8158bfcfa3@suse.de>
References: <1513246316-56019-1-git-send-email-hare@suse.de>
 <1513246316-56019-3-git-send-email-hare@suse.de>
 <55641493-64bf-d997-9883-62fbf59a0404@linux.vnet.ibm.com>
 <062f16c7-ee30-aeb6-e531-f5aed285a52c@suse.de>
 <ab5328bd-207c-261f-f141-504f8cd0106a@linux.vnet.ibm.com>
 <fca08474-ee20-9de7-ba53-e86b1937877a@suse.de>
 <5160d4bf-72f8-8ec7-72e7-3669a1933ca5@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33477 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750943AbeBEIH1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Feb 2018 03:07:27 -0500
In-Reply-To: <5160d4bf-72f8-8ec7-72e7-3669a1933ca5@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 02/02/2018 06:39 PM, Steffen Maier wrote:
> 
> On 02/02/2018 05:00 PM, Hannes Reinecke wrote:
>> On 01/26/2018 05:54 PM, Steffen Maier wrote:
>>> On 12/18/2017 09:31 AM, Hannes Reinecke wrote:
>>>> On 12/15/2017 07:08 PM, Steffen Maier wrote:
>>>>> On 12/14/2017 11:11 AM, Hannes Reinecke wrote:
> 
>>> To me, this raises the question which properties of the host's FC
>>> (driver core) objects should be mirrored to the guest. Ideally all (and
>>> that's a lot).
>>> This in turn makes me wonder if mirroring is really desirable (e.g.
>>> considering the effort) or if only the guest should have its own FC
>>> object hierarchy which does _not_ exist on the KVM host in case an
>>> fc_host is passed through with virtio-(v)fc.
> 
>>> A few more thoughts on your presentation [1]:
>>>
>>> "Devices on the vport will not be visible on the host"
>>> I could not agree more to the design point that devices (or at least
>>> their descendant object subtree) passed through to a guest should not
>>> appear on the host!
>>> With virtio-blk or virtio-scsi, we have SCSI devices and thus disks
>>> visible in the host, which needlessly scans partitions, or even worse
>>> automatically scans for LVM and maybe even activates PVs/VGs/LVs. It's
>>> hard for a KVM host admin to suppress this (and not break the devices
>>> the host needs itself).
>>> If we mirror the host's scsi_transport_fc tree including fc_rports and
>>> thus SCSI devices etc., we would have the same problems?
>>> Even more so, dev_loss_tmo and fast_io_fail_tmo would run independently
>>> on the host and in the guest on the same mirrored scsi_transport_fc
>>> object tree. I can envision user confusion having configured timeouts on
>>> the "wrong" side (host vs. guest). Also we would still need a mechanism
>>> to mirror fc_rport (un)block from host to guest for proper transport
>>> recovery. In zfcp we try to recover on transport rather than scsi_eh
>>> whenever possible because it is so much smoother.
>>>
>> As similar thing can be achieved event today, by setting the
>> 'no_uld_attach' parameter when scanning the scsi device
>> (that's what some RAID HBAs do).
>> However, there currently is no way of modifying it from user-space, and
>> certainly not to change the behaviour for existing devices.
>> It should be relatively simple to set this flag whenever the host is
>> exposed to a VM; we would still see the scsi devices, but the 'sd'
>> driver won't be attached so nothing will scan the device on the host.
> 
> Ah, nice, didn't know that. It would solve the undesired I/O problem in
> the host.
> But it would not solve the so far somewhat unsynchronized state
> transitions of fc_rports on the host and their mirrors in the guest?
> 
> I would be very interested in how you intend to do transport recovery.
> 
So am I :-)

Current plan is to check fc-transport events; probably implementing a
listener which then will manage the interface to the guest.
Also I'm looking at implementing a new block device, which just gets a
WWPN as input and manages all associated scsi (sg) devices.
But that still needs some more work to be done.

>>> "Towards virtio-fc?"
[ .. ]
>> I'm not convinced that moving to full virtio-fc is something we want or
>> even can do.
>> Neither qla2xxx nor lpfc allow for direct FC frame access; so one would
>> need to reformat the FC frames into something the driver understands,
>> just so that the hardware can transform it back into FC frames.
> 
> I thought of a more high level para-virtualized FCP HBA interface, than
> FC frames (which did exist in kernel v2.4 under drivers/fc4/ but no
> longer as it seems). Just like large parts of today's FCP LLDDs handle
> scatter gather lists and framing is done by the hardware.
> 
But that would amount to yet another abstraction layer; not sure if it's
worth the trouble...

>> Another thing is xid management; some drivers have to do their own xid
>> management, based on hardware capabilities etc.
>> So the FC frames would need to re-write the xids, making it hard if not
>> impossible to match things up when the response comes in.
> 
> For such things, where the hardware exposes more details (than, say,
> zfcp sees) I thought the LLDD on the KVM host would handle such details
> internally and only expose the higher level interface to virtio-fc.
> 
Yes; but that's what I'm aiming for with my virtio-vfc thingie already :-)

> Maybe something roughly like the basic transport protocol part of
> ibmvfc/ibmvscsi (not the other end in the firmware and not the cross
> partition DMA part), if I understood its overall design correctly by
> quickly looking at the code.
> I somewhat had the impression that zfcp isn't too far from the overall
> operations style. As seem qla2xxx or lpfc to me, they just see and need
> to handle some more low-level FC details.
> Conceptually replace CRQ/RDMA or QDIO with virtio.
> (And for ibmvscsi also: SRP => FCP because it uses a different SCSI
> transport.)
> 
This is actually a different project; we're looking at extending libfc
to cover ibmvfc, too. But that's even further down the line.

>> And, more importantly, what's the gain here?
>> Which feature do we miss?
> 
> Pros: Full transport_fc tree in guest (only) and reliable fc_rport state
> transitions done in the guest, where I would expect them as user for a
> passed through fc_host. No effort needed for transport tree mirroring
> and trying to get (mirrored) rport state transitions right.
> 
> Cons: Of course such virtio-fc protocol/API would be a bit more than
> just FCP_CMND_IU and FCP_RSP_IU. It's also: abort, open/close port,
> open/close LUN, ELS, CT, get HBA metadata, and a mechanism for
> unsolicited notifications from the HBA LLDD on the KVM host side mainly
> for link up/down. And any host LLDD interested in supporting it would
> need some modifications to implement such API.
> 
> Admittedly, with your currently limited transport tree property
> mirroring it is likely less effort to get a first working virtio-vfc.
> However, I would not call it fc_host pass through. To me it currently
> more looks like a bit of a "faked" (no offense) transport tree in the
> guest and the rest is close to today's virtio-scsi?
> I'm just trying to understand where this would be going, in order to get
> a conceptual impression or classification in my brain.
> 
Oh, it certainly is not fc_host pass through; indeed it _is_ a faked
transport tree. vfc is just a better name; less degrading :-)

And the overall idea here was to provide a _minimal_ emulation for
virtio to simulate an FC host in the KVM guest.

Basically, let's see if we can make it to work without having to
reinvent yet another protocol, and layer it on top of the existing
virtio scsi transport.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
