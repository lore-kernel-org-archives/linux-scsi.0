From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Open-FCoE on linux-scsi
Date: Tue, 15 Jan 2008 17:18:58 -0500
Message-ID: <478D3152.4080508@emulex.com>
References: <200801031035.m03AZYcJ012171@mbox.iij4u.or.jp><10A7D0016239E24092DEF05CCC582E4302BB789B@fmsmsx411.amr.corp.intel.com><477E1C69.9010203@s5r6.in-berlin.de> <20080104205938U.fujita.tomonori@lab.ntt.co.jp> <08FE5CC30C9A3F41BF819A502CF7BF6E029FF0B8@fmsmsx411.amr.corp.intel.com> <477EC411.9040703@s5r6.in-berlin.de> <477ECAD4.8010809@s5r6.in-berlin.de> <10A7D0016239E24092DEF05CCC582E4302CFB7F7@fmsmsx411.amr.corp.intel.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:53377 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764AbYAOWTd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jan 2008 17:19:33 -0500
In-Reply-To: <10A7D0016239E24092DEF05CCC582E4302CFB7F7@fmsmsx411.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Love, Robert W" <robert.w.love@intel.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, "Dev, Vasu" <vasu.dev@intel.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tomof@acm.org, "Zou, Yi" <yi.zou@intel.com>, "Leech, Christopher" <christopher.leech@intel.com>, linux-scsi@vger.kernel.org, James Smart <James.Smart@Emulex.Com>

Love, Robert W wrote:
>> The interconnect layer could be split further:
>> SCSI command set layer -- SCSI core -- SCSI transport layer (FCP) --
>> Fibre Channel core -- Fibre Channel card drivers, FCoE drivers.
> 
> This is how I see the comparison. ('/' indicates 'or')
> 
> You suggest						Open-FCoE
> SCSI-ml						SCSI-ml
> scsi_transport_fc.h				scsi_tranport_fc.h
> scsi_transport_fc.c (FC core) / HBA		openfc / HBA
> fcoe / HBA						fcoe / HBA
> 
>>From what I can see the layering is roughly the same with the main
> difference being that we should be using more of (and putting more into)
> scsi_transport_fc.h. Also we should make the FCP implementation (openfc)
> fit in a bit nicer as scsi_transport_fc.c. We're going to look into
> making better use of scsi_transport_fc.h as a first step.

I don't know what the distinction is between scsi_transport_fc.h vs
scsi_transport_fc.c is. They're all one and the same - the fc transport.
One contains the data structures and api between LLD and transport,
the other (the .c) contains the code to implement the api, transport objects
and sysfs handlers.

 From my point of view, the fc transport is an assist library for the FC LLDDs.
Currently, it interacts with the midlayer only around some scan and block/unblock
functions. Excepting a small helper function used by the LLDD, it does not get
involved in the i/o path.

So my view of the layering for a normal FC driver is:
    SCSI-ml
    LLDD <-> FC transport
    <bus code (e.g. pci)>

Right now, the "assists" provided in the FC transport are:
- Presentation of transport objects into the sysfs tree, and thus sysfs
   attribute handling around those objects. This effectively is the FC
   management interface.
- Remote Port Object mgmt - interaction with the midlayer. Specifically:
   - Manages the SCSI target id bindings for the remote port
   - Knows when the rport is present or not.
     On new connectivity:
       Kicks off scsi scans, restarts blocked i/o.
     On connectivity loss:
       Insulates midlayer from temporary disconnects by block of
         the target/luns, and manages the timer for the allowed period of
         disconnect.
       Assists in knowing when/how to terminate pending i/o after a
         connectivity loss (fast fail, or wait).
   - Provides consistent error codes for i/o path and error handlers via
     helpers that are used by LLDD.

Note that the above does not contain the FC login state machine, etc.
We have discussed this in the past. Given the 4 FC LLDDs we had, there was
a wide difference on who did what where. LSI did all login and FC ELS
handling in their firmware. Qlogic did the initiation of the login in the
driver, but the ELS handling in the firmware. Emulex did the ELS handling
in the driver. IBM/zfcp runs a hybrid of login/ELS handling over it's pseudo
hba interface. Knowing how much time we spend constantly debugging login/ELS
handling and the fact that we have to interject adapter resource allocation
steps into the statemachine, I didn't want to go to a common library until
there was a very clear and similar LLDD.  Well, you can't get much clearer
than a full software-based login/ELS state machine that FCOE needs. It makes
sense to at least try to library-ize the login/ELS handling if possible.

Here's what I have in mind for FCOE layering. Keep in mind, that one of the
goals here is to support a lot of different implementations which may range
from s/w layers on a simple Ethernet packet pusher, to more and more levels
of offload on an FCOE adapter. The goal is to create the s/w layers such that
different LLDD's can pick and choose the layer(s) (or level) they want to
integrate into. At a minimum, they should/must integrate with the base mgmt
objects.

For FC transport, we'd have the following "layers" or api "sections" :
    Layer 0: rport and vport objects   (current functionality)
    Layer 1: Port login and ELS handling
    Layer 2: Fabric login, PT2PT login, CT handling, and discovery/RSCN
    Layer 3: FCP I/O Assist
    Layer 4: FC2 - Exchange and Sequence handling
    Layer 5: FCOE encap/decap
    Layer 6: FCOE FLOGI handler

Layer 1 would work with an api to the LLDD based on a send/receive ELS interface
   coupled with a login/logout to address interface. The code within layer 1
   would make calls to layer 0 to instantiate the different objects. If layer 1
   needs to track additional rport data, it should specify dd_data on the
   rport_add call. (Note: all of the LLDDs today have their own node structure
   that is independent from the rport struct. I wish we could kill this, but for
   now, Layer 1 could do the same (but don't name it so similarly like openfc did)).
   You could also specify login types, so that it knows to do FC4-specific login
   steps such as PRLI's for FCP.

Layer 2 work work with an api to the LLDD based on a send/receive ELS/CT coupled
   with a fabric or pt2pt login/logout interface. It manages discovery and would
   use layer 1 for all endpoint-to-endpoint logins. It too would use layer 0 to
   instantiate sysfs objects. It could also be augmented with a simple link
   up/down statemachine that auto invokes the fabric/pt2pt login.

Layer 3 would work with an api to the LLDD based on a exchange w/ send/receive
   sequence interface.  You could extend this with a set of routines that glue
   directly into the queuecommand and error handler interfaces, which then
   utilizes the FCP helpers.

Layer 4 would work with a send/receive frame interface with the LLDD, and support
   send/receive ELS/CT/sequence, etc. It essentially supports operation of all
   of the above on a simple FC mac. It too would likely need to work with a link
   state machine.

Layer 5 is a set of assist routines that convert a FC frame to an FCOE ethernet
   packet and vice versa. It probably has an option to calculate the checksum or
   not (if not, it's expected a adapter would do it). It may need to contain a
   global FCOE F_Port object that is used as part of the translation.

Layer 6 would work with a send/receive ethernet packet interface and would
   perform the FCOE FLOGI and determine the FCOE F_Port MAC address. It would
   then tie into layer 2 to continue fabric logins, CT traffic, and discovery.

Thus, we could support adapters such as :
- A FC adapter such as Emulex, which would want to use layers 0, 1, and perhaps 2.
- A FC adapter, that sends/receives FC frames - uses layers 0 thru 4.
- A FCOE adapter, that sends/receives ethernet packets, but also provides FCP
     I/O offload.
- A FCOE adapter, that simply sends/receives ethernet frames.

Layers 1, 2, 3, and 4 map to things in your openfc implementation layer.
Layers 5 and 6 map to things in your fcoe layer.
Note that they are not direct copies, but your layers carved up into libraries.
My belief is you would still have an FCOE LLDD that essentially contains the
logic to glue the different layers together.

Thus, the resulting layering looks like:

    SCSI-ml
             +- fc layer 0
             +- fc layer 1
    FC LLDD -+- fc layer 3
             +- fc layer 4
             +- fc layer 5
             +- fc layer 6
    net_device
    NIC_LLDD
    <i/o bus>

I hope this made sense..... There's lots of partial thoughts. They key here is
to create a library of reusable subsets that could be used by different hardware
implementations. We could punt, and have the FC LLDD just contain your openfc
and openfcoe chunks. I don't like this as you will create a bunch of sysfs
parameters for your own port objects, etc which are effectively FCOE-driver
specific. Even if we ignored my dislike, we would minimally need to put the
basic FCOE mgmt interface in place. We could start by extending the fc_port
object to reflect a type of FCOE, and to add support for optional FCOE MAC
addresses for the port and the FCOE F_Port. We'd then need to look at what
else (outside of login state, etc) that we'd want to manage for FCOE. This would
mirror what we did for FC in general.



Also, a couple of comments from my perspective on netlink vs sysfs vs ioctl
from a management perspective. Sysfs works well for singular attributes with
simple set/get primitives. They do not work if a set of attributes much be
changed together or in any multi-step operation. Such things, especially when
requests from user space to kernel, work better in an ioctl (e.g. soon to all
be under sgio). However, ioctls suck for driver-to-user space requests and
event postings. Netlink is a much better fit for these operations, with the
caveate that payloads can't be DMA based.


>> But this would only really make sense if anybody would implement
>> additional FC-4 drivers besides FCP, e.g. RFC 2625, which would also
> sit
>> on top of Fibre Channel core.
>> --
>> Stefan Richter
>> -=====-==--- ---= --=-=
>> http://arcgraph.de/sr/

True - it should become rather evident that FC should be its own
i/o bus, with the hba LLDD providing bindings to each of the FC4 stacks.
This would have worked really well for FCOE, with it creating a fc_port
object, which could then layer a scsi_host on top of it, etc.
Right now there's too much assumption that SCSI is the main owner of the
port.  The NPIV vport stuff is a good illustration of this concept (why is
the vport a subobject of the scsi_host ?).

As it stands today, we have implemented these other FC-4's but they end
up being add-on's similar to the fc-transport.

-- james s
