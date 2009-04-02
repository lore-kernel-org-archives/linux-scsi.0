From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Proposal to add sysfs attributes for FCoE in FC Transport layer
Date: Thu, 2 Apr 2009 13:42:48 -0400
Message-ID: <49D4F918.1090507@emulex.com>
References: <9F784EDD-BC14-4113-B7F2-1E5EBC17B65F@qlogic.com>	 <49D37349.3070202@emulex.com> <1238631208.15031.42.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60321 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765110AbZDBRmy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2009 13:42:54 -0400
In-Reply-To: <1238631208.15031.42.camel@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Carnuccio <joe.carnuccio@qlogic.com>, Marcus Barrow <marcus.barrow@qlogic.com>, David Wagner <david.wagner@qlogic.com>



Robert Love wrote:
> On Wed, 2009-04-01 at 09:59 -0400, James Smart wrote:
>> The largest issue I have is - what attributes are really fc/fcoe specific ?
>> DCBX and PFC are arguably NIC-related parameters and have no business being
>> under the fc transport.  Additionally, whatever we pick, we had better put
>> the same or like parameters with lib_fcoe-supporting adapters in the same
>> place.
>>
>> This is very muddy as some adapters will want present a fc/scsi function
>> only, hiding the nic completely; others may present a nic function and
>> an fcoe function, and physically share the nic; while others will have
>> only the nic and a bunch of software, or a nic with super-features for
>> fcoe.  What object belongs where for what attribute ?
>>
>> Another thing that should be brought up is the presentation model when
>> there are multiple FCF's that an FCOE adapter can talk to. I'm a fan of
>> having a new fc_host for every new *initiator* context on a fabric.
>> Meaning, there's a fc_host for each N_Port_Id on each fabric (which is
>> what we have been doing for NPIV and VSANs). Mean an FCOE port, which
>> sees multiple FCFs, or contacts the same FCF on different vlans (which
>> map to different VSANs) need to be separate fc_hosts.  Additionally, we
> 
> What do you think about having a fcoe_host defined in the FC transport
> that can exist for the FIP phase and then create fc_hosts for each
> N_Port_ID that is logged into the fabric(s)? 

I don't think it meshes very well. If we're going to create a new "top"
object, I'd rather it became a generic fc port (or bus/adapter, as I'd
want to move it above the 1st scsi_host).  This object could then have
"type" attributes, or even a std FC or FCOE subclass, then the fc_hosts
under it.

> We could also have a fcoe_fcf structure that would have a similar
> relationship with the fcoe_host that the rports have with the fc_host
> (at least from the device model perspective). I don't think the
> fcoe_host would be coupled with a scsi_host, or fc_host, since there is
> no intent to use it for I/O, it would be used to do FIP and then we
> switch to fc_hosts just before we log a port into a fabric.

Agreed in concept, thus my push for fc being a bus-like object.

We'll need to work this further. It means creating a small subtree
of objects - from the adapter; to an egress port/point (a single FC
port, or 1 per mac or mac/vlan ?); to fabric ingress point (aka FC
Fport, or FCF's); to a set of fabrics (VSAN hdrs or VLAN related);
to fc_vport (an N_Port_ID on a fabric); to scsi_host/fc_host (initiator
role on the fc_vport); (consider tgt mode attachment to a fc_vport);
to ...rest of current initiator-based rport/stgt/slun tree....

This part concerns me as the scope is a bit large.

> 
> libfcoe has two structures that are used for this purpose
> (include/scsi/libfcoe.h), but they're only used by modules that use
> libfcoe. Maybe they should be moved up to the transport layer, modified
> to fit into the the device model and then have the relevant info exposed
> in sysfs.

Agreed.  Although, we're going to touch on the same kind of issues
you had with rports - can you actively use the entity for internal
topology and state management, or is it only in the transport in order
for mgmt presentation and control.

-- james s
