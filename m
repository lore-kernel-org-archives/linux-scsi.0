From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] virtio-scsi: Add FC transport class
Date: Fri, 2 Feb 2018 17:00:42 +0100
Message-ID: <fca08474-ee20-9de7-ba53-e86b1937877a@suse.de>
References: <1513246316-56019-1-git-send-email-hare@suse.de>
 <1513246316-56019-3-git-send-email-hare@suse.de>
 <55641493-64bf-d997-9883-62fbf59a0404@linux.vnet.ibm.com>
 <062f16c7-ee30-aeb6-e531-f5aed285a52c@suse.de>
 <ab5328bd-207c-261f-f141-504f8cd0106a@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50802 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751567AbeBBQAp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Feb 2018 11:00:45 -0500
In-Reply-To: <ab5328bd-207c-261f-f141-504f8cd0106a@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 01/26/2018 05:54 PM, Steffen Maier wrote:
> On 12/18/2017 09:31 AM, Hannes Reinecke wrote:
>> On 12/15/2017 07:08 PM, Steffen Maier wrote:
>>> On 12/14/2017 11:11 AM, Hannes Reinecke wrote:
>>>> When a device announces an 'FC' protocol we should be pulling
>>>> in the FC transport class to have the rports etc setup correctly.
>>>
>>> It took some time for me to understand what this does.
>>> It seems to mirror the topology of rports and sdevs that exist under the
>>> fc_host on the kvm host side to the virtio-scsi-fc side in the guest.
>>>
>>> I like the idea. This is also what I've been suggesting users to do if
>>> they back virtio-scsi with zfcp on the kvm host side. Primarily to not
>>> stall all virtio-scsi I/O on all paths if the guest ever gets into
>>> scsi_eh. But also to make it look like an HBA pass through so one can
>>> more easily migrate to this once we have FCP pass through.
> 
> On second thought, I like the idea for virtio-scsi.
> 
> For the future virtio-(v)fc case, see below.
> 
>>>> @@ -755,19 +823,34 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
>>>
>>>> +    if (vscsi->protocol == SCSI_PROTOCOL_FCP) {
>>>> +        struct fc_rport *rport =
>>>> +            starget_to_rport(scsi_target(sc->device));
>>>> +        if (rport && rport->dd_data ) {
>>>> +            tgt = rport->dd_data;
>>>> +            target_id = tgt->target_id;
>>>> +        } else
>>>> +            return FAST_IO_FAIL;
>>>> +    } else {
>>>> +        tgt = scsi_target(sc->device)->hostdata;
>>>> +        if (!tgt || tgt->removed)
>>>> +            return FAST_IO_FAIL;
>>>> +    }
>>>
>>> dito
>>>
>>>> @@ -857,27 +970,67 @@ static void virtscsi_rescan_work(struct
>>>> work_struct *work)
>>>>
>>>>        wait_for_completion(&comp);
>>>
>>> Waiting in work item .vs. having the response (IRQ) path trigger
>>> subsequent processing async ?
>>> Or do we need the call chain(s) getting here to be in our own process
>>> context via the workqueue anyway?
>>>
>> Can't see I can parse this sentence, but I'll be looking at the code
>> trying to come up with a clever explanation :-)
> 
> Sorry, meanwhile I have a hard time understanding my own words, too.
> 
> I think I wondered if the effort of a work item is really necessary,
> especially considering that it does block on the completion and thus
> could delay other queued work items (even though Concurrency Managed
> Workqueues can often hide this delay).
> 
> Couldn't we just return asynchronously after having sent the request.
> And then later on, simply have the response (IRQ) path trigger whatever
> processing is necessary (after the work item variant woke up from the
> wait_for_completion) in some asynchronuous fashion? Of course, this
> could also be a work item which just does necessary remaining processing
> after we got a response.
> Just a wild guess, without knowing the environmental requirements.
> 
The main point here was that we get off the irq-completion handler; if
we were to trigger this directly we would be running in an interrupt
context, which then will make things like spin_lock, mutex et al tricky.
Plus it's not really time critical; during rescanning all I/O should be
blocked, so we shouldn't have anything else going on.

>>>> +    if (transport == SCSI_PROTOCOL_FCP) {
>>>> +        struct fc_rport_identifiers rport_ids;
>>>> +        struct fc_rport *rport;
>>>> +
>>>> +        rport_ids.node_name = wwn_to_u64(cmd->resp.rescan.node_wwn);
>>>> +        rport_ids.port_name = wwn_to_u64(cmd->resp.rescan.port_wwn);
>>>> +        rport_ids.port_id = (target_id >> 8);
>>>
>>> Why do you shift target_id by one byte to the right?
>>>
>> Because with the original setup virtio_scsi guest would pass in the
>> target_id, and the host would be selecting the device based on that
>> information.
>> With virtio-vfc we pass in the wwpn, but still require the target ID to
>> be compliant with things like event notification etc.
> 
> Don't we need the true N_Port-ID, then? That's what an fc_rport.port_id
> usually contains. It's also a simple way to lookup resources on a SAN
> switch for problem determination. Or did I misunderstand the
> content/semantics of the variable target_id, assuming it's a SCSI target
> ID, i.e. the 3rd part of a HCTL 4-tuple?
> 
Yes, that was the idea.
I've now modified the code so that we can pick up the port id for both,
target and host port. That should satisfy the needs here.

>> So I've shifted the target id onto the port ID (which is 24 bit anyway).
>> I could've used a bitfield here, but then I wasn't quite sure about the
>> endianness of which.
> 
>>>> +        rport = fc_remote_port_add(sh, 0, &rport_ids);
>>>> +        if (rport) {
>>>> +            tgt->rport = rport;
>>>> +            rport->dd_data = tgt;
>>>> +            fc_remote_port_rolechg(rport, FC_RPORT_ROLE_FCP_TARGET);
>>>
>>> Is the rolechg to get some event? Otherwise we could have
>>> rport_ids.roles = FC_RPORT_ROLE_FCP_TARGET before fc_remote_port_add().
>>>
>> That's how the 'normal' transport classes do it; but I'll check if this
>> can be rolled into the call to fc_remote_port_add().
> 
> My idea was just based on how zfcp does it. Do you think I need to check
> if zfcp should do it via rolechg (even though zfcp never changes an
> rport role since it can only open targets)?
> 
Yeah, modified that with the next version.

>>>> @@ -932,14 +1089,31 @@ static void virtscsi_scan_host(struct
>>>> virtio_scsi *vscsi)
>>>>    static void virtscsi_scan_start(struct Scsi_Host *sh)
>>>>    {
> 
>>>> +    if (vscsi->protocol == SCSI_PROTOCOL_FCP) {
>>>> +        fc_host_node_name(sh) = vscsi->wwnn;
>>>> +        fc_host_port_name(sh) = vscsi->wwpn;
>>>> +        fc_host_port_id(sh) = 0x00ff00;
>>>> +        fc_host_port_type(sh) = FC_PORTTYPE_NPIV;
>>>
>>> Why is this hardcoded?
>>>
>>> At least with zfcp, we can have kvm host *v*HBAs without NPIV.
>>>
>> For the simple fact that I don't have fields to transfer this
>> information; plus it's not _actually_ used anywhere.
> 
> It might not be used in this code, but it is exported to user space via
> sysfs. If I understood things correctly, you newly introduce virtio-scsi
> commands in patch 1 and are free to add more fields to struct
> virtio_scsi_rescan_resp (maybe within some max size limit)?
> To me, this raises the question which properties of the host's FC
> (driver core) objects should be mirrored to the guest. Ideally all (and
> that's a lot).
> This in turn makes me wonder if mirroring is really desirable (e.g.
> considering the effort) or if only the guest should have its own FC
> object hierarchy which does _not_ exist on the KVM host in case an
> fc_host is passed through with virtio-(v)fc.
> 
The original idea here was to pass in NPIV hosts only; otherwise it
might be simpler to use device passthrough and have the full device
assigned to the guest.

>> Unless you have a strict need why this information is required?
> 
> In general, I would wish that virtio-(v)fc has no hard requirement for
> creating real vports on the KVM host. From a zfcp perspective, it would
> be nice if already existing fc_hosts of any type (vport or not) could be
> configured for virtio-vfc pass through. A selection key could e.g. be
> fc_host.port_name which is the (NPIV) WWPN of the initiator.
> 
> Rationale:
> 
> A 1st level hypervisor manages physical devices.
> A 1st level hypervisor can pass through devices to a 1st level guest.
> 
> On x86, the 1st level hypervisor is KVM.
> It can pass through PCI devices (physical or virtual functions).
> It can create vports (defining the NPIV WWPN) to pass through with
> virtio-vfc.
> From your presentation [1] I derived and as quite surprised that there
> does not seem to be a thing that combines a VF and vport (actually no
> VFs for HBAs at all), because then x86 would already have everything
> needed: Just PCI pass through a vport-VF and be done.
> If I understood your slides correctly "mediated device passthrough"
> would be a software "workaround" because the hardware does not provide
> vport-VFs.
> 
Yeah, sort of.

> (The following assumes an FCP channel / zfcp perspective.)
> On s390, the 1st level hypervisor is PR/SM providing LPARs.
> The PR/SM ecosystem defines virtual function equivalents [2, slide 15].
> They can either use NPIV (kind of a vport) or not (FCP channel hardware
> virtualization was there before NPIV). Admittedly, the latter case is
> probably of no(t so much) importance for a virtio-vfc use case {it would
> be more like virtio-fc, i.e. without the 'v' as in NPIV}.
> For the NPIV case, we have something like a vport and VF combined into a
> device, that we can sense on the system bus CCW (would be PCI on x86).
> The PR/SM ecosystem also defines the virtual NPIV WWPN for such initiator.
> An LPAR only sees an equivalent of virtual functions; it does not get
> access to a PF equivalent.
> Hence, zfcp can hardly reasonably implement the vport creation interface
> of scsi_transport_fc; it only fakes the fc_host.port_type but otherwise
> all zfcp fc_hosts are "real", i.e. non-vport.
> KVM as a 2nd level hypervisor sees the VF equivalents of the LPAR it
> runs in. Hence, KVM can only take whatever devices are there, HBA LLDDs
> in that KVM cannot create vports themselves.
> (BTW, in case of z/VM as 2nd level hypervisor, it supports live guest
> migration with zfcp devices passed through the 1st and the 2nd level
> hypervisor.)
> 
> IOW, it would be nice if virtio-vfc could support nested KVM as 2nd
> level hypervisor just seeing already existing VFs or vports, which are
> in turn managed, defined and passed through by some 1st level hypervisor.
> 
As mentioned, there is nothing in the code which requires NPIV. It works
happily with any FC HBA (or emulated devices, or whatever).

>From the guest side I just have exposed the port_id, wwpn, and wwnn, as
this was the only fields I found a use-case for (like keeping lsscsi -t
happy). If you have a need to for additional information we sure can add
them.

> 
> A few more thoughts on your presentation [1]:
> 
> "Devices on the vport will not be visible on the host"
> I could not agree more to the design point that devices (or at least
> their descendant object subtree) passed through to a guest should not
> appear on the host!
> With virtio-blk or virtio-scsi, we have SCSI devices and thus disks
> visible in the host, which needlessly scans partitions, or even worse
> automatically scans for LVM and maybe even activates PVs/VGs/LVs. It's
> hard for a KVM host admin to suppress this (and not break the devices
> the host needs itself).
> If we mirror the host's scsi_transport_fc tree including fc_rports and
> thus SCSI devices etc., we would have the same problems?
> Even more so, dev_loss_tmo and fast_io_fail_tmo would run independently
> on the host and in the guest on the same mirrored scsi_transport_fc
> object tree. I can envision user confusion having configured timeouts on
> the "wrong" side (host vs. guest). Also we would still need a mechanism
> to mirror fc_rport (un)block from host to guest for proper transport
> recovery. In zfcp we try to recover on transport rather than scsi_eh
> whenever possible because it is so much smoother.
> 
As similar thing can be achieved event today, by setting the
'no_uld_attach' parameter when scanning the scsi device
(that's what some RAID HBAs do).
However, there currently is no way of modifying it from user-space, and
certainly not to change the behaviour for existing devices.
It should be relatively simple to set this flag whenever the host is
exposed to a VM; we would still see the scsi devices, but the 'sd'
driver won't be attached so nothing will scan the device on the host.

> "Towards virtio-fc?"
> Using the FCP_CMND_IU (instead of just a plain SCB as with virtio-scsi)
> sounds promising to me as starting point.
> A listener from the audience asked if you would also do ELS/CT in the
> guest and you replied that this would not be good. Why is that?
> Based on above starting point, doing ELS/CT (and basic aborts and maybe
> a few other functions such as open/close ports or metadata transfer
> commands) in the guest is exactly what I would have expected. An HBA
> LLDD on the KVM host would implement such API and for all fc_hosts,
> passed through this way, it would *not* establish any scsi_transport_fc
> tree on the host. Instead the one virtio-vfc implementation in the guest
> would do this indendently of which HBA LLDD provides the passed through
> fc_host in the KVM host.
> ELS/CT pass through is maybe even for free via FC_BSG for those LLDDs
> that already implement it.
> Rport open/close is just the analogon of slave_alloc()/slave_destroy().
> 
I'm not convinced that moving to full virtio-fc is something we want or
even can do.
Neither qla2xxx nor lpfc allow for direct FC frame access; so one would
need to reformat the FC frames into something the driver understands,
just so that the hardware can transform it back into FC frames.
Another thing is xid management; some drivers have to do their own xid
management, based on hardware capabilities etc.
So the FC frames would need to re-write the xids, making it hard if not
impossible to match things up when the response comes in.

And, more importantly, what's the gain here?
Which feature do we miss?

> A new tricky part would be how to "unbind" an fc_host on the KVM host to
> be able to pass it through. (At least on x86) we have a vport and thus
> would not have a system bus (PCI) device we could unbind and then bind
> to the virtio-vfc equivalent of VFIO for pass through. A virtio-vfc API
> with sysfs interface for HBA LLDDs on the host could provide something
> similar on an fc_host level.
> Even better would be if an HBA LLDD would already know at probe time
> which of its fc_hosts are planned for pass through so it would not even
> start establishing the whole FC transport object tree with port
> discovery and the implied SCSI target scan. A late unbind would, at
> least with zfcp, cause the object tree to linger with fc_rports
> transitioning to "not present" state eventually (because zfcp uses the
> default FC_TGTID_BIND_BY_WWPN and the fc_host lives long until module
> unload or system shutdown, so fc_remote_port_delete() does not really
> delete rports from sysfs) and SCSI devices transitioning to
> "transport-offline" eventually.
> 
Hehe. That's one unresolved problem; the FC vendors have a hard time
already figuring out how to bind to the various modes (FC inintiator, FC
target, NVMe initiator, NVMe target, and all the combinations thereof).

Not sure if we can solve it generically.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
