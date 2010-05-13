From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [RFC PATCH 0/3] FC subsystem update
Date: Wed, 12 May 2010 17:55:47 -0700
Message-ID: <4BEB4E13.8010802@cisco.com>
References: <20100512202003.27512.34851.stgit@localhost.localdomain>	 <4BEB44A0.8070208@cisco.com> <1273711270.3543.89.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:15003 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab0EMAzs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2010 20:55:48 -0400
In-Reply-To: <1273711270.3543.89.camel@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.smart@emulex.com" <james.smart@emulex.com>, "hare@suse.de" <hare@suse.de>, "christof.schmitt@de.ibm.com" <christof.schmitt@de.ibm.com>, "james.bottomley@suse.de" <james.bottomley@suse.de>

Robert Love wrote:
> On Wed, 2010-05-12 at 17:15 -0700, Joe Eykholt wrote:
>> Robert Love wrote:
>>> This series represents the continuation of the RFC archived here:
>>> http://marc.info/?l=linux-scsi&m=126463466126962&w=2. The sysfs organization has
>>> taken shape and object allocations make more sense than the previous RFC. The
>>> patches have undergone my own developer testing, which has mostly focused on
>>> NPIV port creation and deletion and some I/O.
>>>
>>> This series creates a Fibre Channel subsystem that has an improved sysfs device
>>> tree (the port's view of the fabric) and begins to abstract itself from SCSI.
>>>
>>> This RFC is to solicit any feedback before I continue to refine these patches.
>>> I've created two diagrams to help people understand the change. The first shows
>>> the current sysfs device layout and the second shows the allocation scheme for
>>> libfc and fcoe's primary data structures.
>>>
>>> http://open-fcoe.org/rwlove/fc_sysfs.jpg
>>> http://open-fcoe.org/rwlove/libfc_alloc.jpg
>>>
>>> These patches apply to scsi-misc + the recently submitted fcoe patches, which
>>> is the same as the fcoe-next tree on open-fcoe.org.
>>>
>>> Overview of N_Port creation/login (for fcoe.ko):
>>>
>>> 1) First, fc.ko is installed and then scsi_transport_fcp.ko is installed.
>>>    scsi_transport_fcp.ko registers itself (SCSI initiator) as a FC4 with
>>>    fc.ko.
>>>
>>> 2) When a fcoe port is "created" from
>>>    'echo ethX > /sys/module/fcoe/parameters/create' a fcport is allocated and
>>>    added to sysfs. All of the port's physical properties are added as
>>>    attributes.
>>>
>>> <PCI root>/fcport_0
>>>
>>> 3) At this point libfc/libfcoe/fcoe needs an lport and an fcoe_port. The lport
>>>    and fcoe_ports are private data of a fcvport so a fcvport is allocated,
>>>    but not added to sysfs.
>>>
>>> 4) libfcoe.ko discovers FCFs and allocates/adds them as fcfabrics to sysfs
>>>    as they are discovered.
>>>
>>>    [ I think that we may want to revisit the idea of having a fcfport between
>>>      the fcport and fcfabric. Right now I'm creating a fcfabric for each FCF
>>>      that is discovered at the FIP phase, but that doesn't make much sense
>>>      since multiple FCFs on the same fabric can be discovered. Adding a fcfport
>>>      for each FCF discovered might be more correct. ]
>>>
>>> <PCI root>/fcport_0/fcfabric_0
>>>
>>> 5) libfc.ko will FLOGI into the fabric and upon the FLOGI ACC the fcvport
>>>    will be added to sysfs.
>>>
>>> <PCI root>/fcport_0/fcfabric_0/fcvport_0
>>>
>>> 5.1) The FC layer will call fc4_init_add in the fc4_template. If SCSI
>>>      is the FC4, fcp_init_add (scsi_transport_fcp) will be called. This
>>>      routine calls scsi_host_alloc/scsi_add_host. There is also a callback
>>>      down to the LLD so that it can setup any SCSI-FCP private data.
>>>
>>>      [ I'm not sure how non-FCoE HBAs will do this. I imagine they will just
>>>        create all three sysfs devices (fcport, fcfabric and fcvport) on the
>>>        FLOGI ACC since they do not rely on a discovery protocol. ]
>>>
>>> <PCI root>/fcport_0/fcfabric_0/fcvport_0/fcpinit_X/hostX
>>>
>>> 6) libfc will start discovery and as remote ports are discovered libfc will
>>>    notify FC to create and add fcrports to sysfs.
>>>
>>> <PCI root>/fcport_0/fcfabric_0/fcvport_0/fcpinit_X/hostX
>>> 					/fcrport_0
>>>
>>> 6.1) When the fcrports are created the FC layer will call fc4_targ_add in
>>>      the fc4_template. If SCSI is the FC4, fcp_targ_add (scsi_transport_fcp)
>>>      will be called. This routine will allocate a fcptarg device, add it to
>>>      sysfs and notify SCSI to scan it.
>>>
>>> <PCI root>/fcport_0/fcfabric_0/fcvport_0/fcpinit_X/hostX
>>> 					/fcrport_0/fcptargX:0-0
>>>
>>>
>>> The current series shortcomings are:
>>>
>>> 1) The FC4 interface needs work to become more FC4 agnostic.
>>>    (end of include/fc/fc.h)
>>>
>>> 2) Point-to-Point mode needs to be addressed
>>>
>>> 3) BSG needs to be tested and STGT should become another FC4 that is
>>>    registered with FC. Since libfc/fcoe doesn't plug into STGT yet this
>>>    will be a challenge.
>>>
>>> 4) user space updates - For the fcoe-utils package, libhbalinux (user
>>>    space HBA API library) needs to be updated to read the new layout before
>>>    heavy testing of the new layout can be done.
>>>
>>> 5) Miscellaneous problems like error handling, fcfabric deletion cleaning
>>>    up vports, using attribute containers / scsi transport style for
>>>    SCSI-FCP devices, warnings, etc...
>>>
>>> 6) FCoE attributes...
>>>
>>> Other thoughts:
>>>
>>> I would love to collaborate with someone who maintains a HBA that supports
>>> native FC since I'm not aware of the specific needs of traditional HBAs.
>>>
>>> I would hope that this new layout could be added to the kernel (when
>>> ready) and the existing FC Transport deprecated as I'm not sure how to get
>>> all HBA maintainers to switch their drivers at the same time. I think that
>>> only adding FCoE attributes to this layout would be an incentive to get LLDs
>>> to migrate.
>>>
>>> I've tried to keep this covermail brief, so there are plenty of details
>>> left out. Please ask if you have a question.
>>>
>>> Thanks, //Rob
>> <snip>
>>
>> Hi Rob,
>>
> Hi Joe, thanks for taking a look.
> 
>> I'm running the patches and they work OK (very lightly used).
>>
>> I'd prefer we kept the naming in /sys/class shorter and keep underscores
>> after "fc" like we currently have in fc_remote_port.  Maybe you could
>> continue to use the existing names where they apply, after getting the
>> other transport code converted.
>>
>> Here are my suggested name changes:
>>
>> 	fcvport becomes fc_vport
>> 	fcvport/fcvport_0 becomes fc_vport/0
>> 	fcpinit_4 becomes fcp_init4
>> 	fcptarg-X:0-1 becomes fcp_targ/1
>> 	fcrport:xxx-0 becomes fc_rport/0 (or fc_remote_ports/xxx eventually)
>> 	fcfabric/fcfabric_0 becomes fc_fabric/0
>> 	fcport/fcport_0 becomes fc_port/0
>>
> Sure, that sounds reasonable. I think I've got too much fc_fc* stuff in
> general- device names, function names, etc...
> 
>> When we have local FCP target ports (as opposed to remote ones) how will we
>> represent that?  You could include that in the diagram.
>>
> This is something that I've got to figure out so that I don't lose any
> existing functionality. I need a way to test whatever scheme is agreed
> upon and since stgt isn't integrated with libfc/fcoe I'll either need to
> integrate it or use one of the out-of-tree target infrastructures to
> create local target ports.

You wouldn't have to implement it, I just wanted to know what the
names would be.  Depending on the target module, they each
have their own management, and if/when they get into the kernel,
we can add something to this scheme.  scsi_tgt, being all
in user land, doesn't even show up in /sys.

>> When we see remote initiators, how do we show them?  Maybe we just don't
>> create anything under fcport_N in that case.
>>
> The FC layer could create an fc_rport and notify the registered FC4. I
> haven't really thought out if the SCSI-FCP layer would do anything
> though.
> 
> Another related question is if a discovered target is represented by the
> same device/structure when the host is an initiator or target. The same
> question applies to discovered initiators.
> 
>> I may have more comments later after I look through the code
>> a bit further.  I'm modifying fcc to handle the new trees.
>>
> Very cool. Let me know when you have it done as I'd love to use it for
> testing.
> 
>> Minor issues:  I noticed that fnic no longer compiles and checkpatch
>> spots some issues, but I'm sure those will be fixed later.
> 
> Yeah, sorry about fnic. :)

No biggie.  It makes sense to convert one LLD first and then then other.

> I tried to clean up a lot of the checkpatch warnings, many were the
> result of code moved from scsi_transport_fc, so I tried to clean up all
> of the issues that I introduced and some of the existing ones. I'll
> clean up all that stuff once this code matures.

Oh, right.  I remember that now.  Maybe checkpatch should be
smart enough to realize the code had just moved ... not easy, though.

	Regards,
	Joe
