From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] virtio-scsi: Add FC transport class
Date: Fri, 2 Feb 2018 18:39:30 +0100
Message-ID: <5160d4bf-72f8-8ec7-72e7-3669a1933ca5@linux.vnet.ibm.com>
References: <1513246316-56019-1-git-send-email-hare@suse.de>
 <1513246316-56019-3-git-send-email-hare@suse.de>
 <55641493-64bf-d997-9883-62fbf59a0404@linux.vnet.ibm.com>
 <062f16c7-ee30-aeb6-e531-f5aed285a52c@suse.de>
 <ab5328bd-207c-261f-f141-504f8cd0106a@linux.vnet.ibm.com>
 <fca08474-ee20-9de7-ba53-e86b1937877a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41290 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753551AbeBBRjk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2018 12:39:40 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w12HdV3m040660
        for <linux-scsi@vger.kernel.org>; Fri, 2 Feb 2018 12:39:39 -0500
Received: from e06smtp11.uk.ibm.com (e06smtp11.uk.ibm.com [195.75.94.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2fvuectyhm-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 02 Feb 2018 12:39:38 -0500
Received: from localhost
        by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Fri, 2 Feb 2018 17:39:33 -0000
In-Reply-To: <fca08474-ee20-9de7-ba53-e86b1937877a@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


On 02/02/2018 05:00 PM, Hannes Reinecke wrote:
> On 01/26/2018 05:54 PM, Steffen Maier wrote:
>> On 12/18/2017 09:31 AM, Hannes Reinecke wrote:
>>> On 12/15/2017 07:08 PM, Steffen Maier wrote:
>>>> On 12/14/2017 11:11 AM, Hannes Reinecke wrote:

>> To me, this raises the question which properties of the host's FC
>> (driver core) objects should be mirrored to the guest. Ideally all (and
>> that's a lot).
>> This in turn makes me wonder if mirroring is really desirable (e.g.
>> considering the effort) or if only the guest should have its own FC
>> object hierarchy which does _not_ exist on the KVM host in case an
>> fc_host is passed through with virtio-(v)fc.

>> A few more thoughts on your presentation [1]:
>>
>> "Devices on the vport will not be visible on the host"
>> I could not agree more to the design point that devices (or at least
>> their descendant object subtree) passed through to a guest should not
>> appear on the host!
>> With virtio-blk or virtio-scsi, we have SCSI devices and thus disks
>> visible in the host, which needlessly scans partitions, or even worse
>> automatically scans for LVM and maybe even activates PVs/VGs/LVs. It's
>> hard for a KVM host admin to suppress this (and not break the devices
>> the host needs itself).
>> If we mirror the host's scsi_transport_fc tree including fc_rports and
>> thus SCSI devices etc., we would have the same problems?
>> Even more so, dev_loss_tmo and fast_io_fail_tmo would run independently
>> on the host and in the guest on the same mirrored scsi_transport_fc
>> object tree. I can envision user confusion having configured timeouts on
>> the "wrong" side (host vs. guest). Also we would still need a mechanism
>> to mirror fc_rport (un)block from host to guest for proper transport
>> recovery. In zfcp we try to recover on transport rather than scsi_eh
>> whenever possible because it is so much smoother.
>>
> As similar thing can be achieved event today, by setting the
> 'no_uld_attach' parameter when scanning the scsi device
> (that's what some RAID HBAs do).
> However, there currently is no way of modifying it from user-space, and
> certainly not to change the behaviour for existing devices.
> It should be relatively simple to set this flag whenever the host is
> exposed to a VM; we would still see the scsi devices, but the 'sd'
> driver won't be attached so nothing will scan the device on the host.

Ah, nice, didn't know that. It would solve the undesired I/O problem in 
the host.
But it would not solve the so far somewhat unsynchronized state 
transitions of fc_rports on the host and their mirrors in the guest?

I would be very interested in how you intend to do transport recovery.

>> "Towards virtio-fc?"
>> Using the FCP_CMND_IU (instead of just a plain SCB as with virtio-scsi)
>> sounds promising to me as starting point.
>> A listener from the audience asked if you would also do ELS/CT in the
>> guest and you replied that this would not be good. Why is that?
>> Based on above starting point, doing ELS/CT (and basic aborts and maybe
>> a few other functions such as open/close ports or metadata transfer
>> commands) in the guest is exactly what I would have expected. An HBA
>> LLDD on the KVM host would implement such API and for all fc_hosts,
>> passed through this way, it would *not* establish any scsi_transport_fc
>> tree on the host. Instead the one virtio-vfc implementation in the guest
>> would do this indendently of which HBA LLDD provides the passed through
>> fc_host in the KVM host.
>> ELS/CT pass through is maybe even for free via FC_BSG for those LLDDs
>> that already implement it.
>> Rport open/close is just the analogon of slave_alloc()/slave_destroy().
>>
> I'm not convinced that moving to full virtio-fc is something we want or
> even can do.
> Neither qla2xxx nor lpfc allow for direct FC frame access; so one would
> need to reformat the FC frames into something the driver understands,
> just so that the hardware can transform it back into FC frames.

I thought of a more high level para-virtualized FCP HBA interface, than 
FC frames (which did exist in kernel v2.4 under drivers/fc4/ but no 
longer as it seems). Just like large parts of today's FCP LLDDs handle 
scatter gather lists and framing is done by the hardware.

> Another thing is xid management; some drivers have to do their own xid
> management, based on hardware capabilities etc.
> So the FC frames would need to re-write the xids, making it hard if not
> impossible to match things up when the response comes in.

For such things, where the hardware exposes more details (than, say, 
zfcp sees) I thought the LLDD on the KVM host would handle such details 
internally and only expose the higher level interface to virtio-fc.

Maybe something roughly like the basic transport protocol part of 
ibmvfc/ibmvscsi (not the other end in the firmware and not the cross 
partition DMA part), if I understood its overall design correctly by 
quickly looking at the code.
I somewhat had the impression that zfcp isn't too far from the overall 
operations style. As seem qla2xxx or lpfc to me, they just see and need 
to handle some more low-level FC details.
Conceptually replace CRQ/RDMA or QDIO with virtio.
(And for ibmvscsi also: SRP => FCP because it uses a different SCSI 
transport.)

> And, more importantly, what's the gain here?
> Which feature do we miss?

Pros: Full transport_fc tree in guest (only) and reliable fc_rport state 
transitions done in the guest, where I would expect them as user for a 
passed through fc_host. No effort needed for transport tree mirroring 
and trying to get (mirrored) rport state transitions right.

Cons: Of course such virtio-fc protocol/API would be a bit more than 
just FCP_CMND_IU and FCP_RSP_IU. It's also: abort, open/close port, 
open/close LUN, ELS, CT, get HBA metadata, and a mechanism for 
unsolicited notifications from the HBA LLDD on the KVM host side mainly 
for link up/down. And any host LLDD interested in supporting it would 
need some modifications to implement such API.

Admittedly, with your currently limited transport tree property 
mirroring it is likely less effort to get a first working virtio-vfc. 
However, I would not call it fc_host pass through. To me it currently 
more looks like a bit of a "faked" (no offense) transport tree in the 
guest and the rest is close to today's virtio-scsi?
I'm just trying to understand where this would be going, in order to get 
a conceptual impression or classification in my brain.

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
