From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: Subject: [RFC 0/3] Add fc_rport attributes to further populate
 HBAAPIv2 HBAPortAttributes for discovered ports.
Date: Tue, 2 Nov 2010 14:53:35 -0400
Message-ID: <alpine.LFD.2.00.1011021446210.5644@localhost.localdomain>
References: <alpine.LFD.2.00.1010281212441.2885@localhost.localdomain> <20101029104515.GA15522@schmichrtp.mainz.de.ibm.com> <alpine.LFD.2.00.1010291532220.3526@localhost.localdomain> <4CD02F77.5090607@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:28855 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab0KBSxm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2010 14:53:42 -0400
In-Reply-To: <4CD02F77.5090607@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



On Tue, 2 Nov 2010, James Smart wrote:

>
>
> On 10/29/2010 3:35 PM, Chad Dupuis wrote:
>> On Fri, 29 Oct 2010, Christof Schmitt wrote:
>>> On Thu, Oct 28, 2010 at 12:14:18PM -0400, Chad Dupuis wrote:
>>>> Hi All,
>>>>
>>>> This small patch set adds 7 new attributes to the fc_rport struct so that application libraries who export HBAAPI v2 discovered port attributes can populate the HBA_PORTATTRIBUTES structure more fully.  The new fc_rport attributes,
>>>> which would be exported via the /sys/class/fc_remote_port/rport-x:y-z directory, are:
>>>>
>>>> - supported_fc4s
>>>> - supported_speed
>>>> - port_type
>>>> - speed
>>>> - active_fc4s
>>>> - symbolic_name
>>>> - fabric_name
>>>>
>>>> These attributes would be fixed-attributes which would mean that they would be set before the call to fc_remote_port_rolechg() but then once the role of the port has been established they would not change.
>>>>
>>>> There are two patches in this RFC:
>>>>
>>>> Patch #1 - scsi_transport_fc: Add HBAAPI v2 attributes to fc_rport structure.
>>>>
>>>> This patch adds the definitions for the new fc_rport attributes, sets up the show functions and assigns default nominal values to the attributes.
>>>>
>>>> Patch #2 - qla2xxx: Add name and management server queries to fill in new fc_rport attributes.
>>>>
>>>> This patch adds the necessary name and management server calls to the SAN fabric services to obtain the information needed to fill in the new fc_rport attributes.  The patch also assigns the attributes before calling
>>>> fc_remote_port_rolechg().
>>>
>>> It looks like this mechanism only queries data from the FC nameserver.
>>> It would be useful to have the same data available for all FC drivers.
>
> I second this statement from Christof.  There is nothing in this that is
> driver-specific, so the queries should be placed in a common place (transport
> or in the hbaapi library).
>
> I'm also not a fan of the "must query for the data before calling
> fc_remote_port_rolechg()".  This stuff is informational, so I would prefer the
> queries be done after or independent of the rolechg() call.

This is reasonable.  We could make the calls directly in 
fc_remote_port_add() to fill in the attributes or any point thereafter.

>>> The FC BSG interface already allows sending CT requests to the FC
>>> nameserver. Could this be implemented by creating the request in
>>> common code and issue the requests through the FC BSG interface? If
>>
>> We considered using bsg as the means for getting the information to and
>> from user space but deciced that exporting the information through
>> /sys/class/fc_remote_ports was easier and probably more appropriate as
>> other attributes relating to rports are currently exported there.
>
> I'm 50/50 on this....  I do like to see all the info via sysfs files w/o the
> need for additional tools.   However, I don't like all the extra inodes we
> create for all the attributes (especially as rports should be many, and
> replicated per host path to the rport). And, I'm unsure where we really should
> start to draw the line for what's in sysfs vs what do you go to a tool to find
> out.

We'd like to see this in sysfs for consistency and for the fact that you 
don't need a special tool to view the information.

>
> Anyone else with an opinion ?
>
>
>>> the data is used by the HBAAPI, the userspace HBAAPI could create the
>>> FC requests and issue them through the /dev/bsg/... device files.
>>
>> I think this would be a little too low level for a user level library.
>> Normally for user space I would assume we want to hide the mechanism
>> (which is very hardare dependent) that is used to get the information
>> and rather just expose the information itself.
>>
>
> Actually, this is exactly the kind of detail that should be in a user-level
> library.  It's an FC-centric library, and making FC-centric queries makes
> sense.  The whole purpose of the library is to hide mechanism (is it from
> sysfs, from directory tires, from sgio, from bsg, from netlink, etc) from the
> consumer of the library.
>
> The only advantage for keeping it out of the library - is to display it under
> sysfs w/o the use of a tool.
>
> The 2 options in my mind are:
> a) the CT queries are issued by the fc_transport after fc_remote_port_add()
> and fc_remote_port_rolechg() calls - to populate the rport sysfs data.  (no
> need to involve the LLDD for anything other than the CT queries)

This is our preferred approach given the two options; to make the calls 
from the FC transport layer.

> or
> b) move the items and CT queries to the library. Ultimately, the library
> should be refreshing data in sync with the fc_remote_port_add/rolechg()calls,
> so we should post async events at those points, and have them handled by the
> library.  I don't remember if HBAAPI is actually geared for async event
> updates, as I thought the consumer had to periodically call in to refresh.
> This would need to be worked out.
>
>
> -- james s
>
>
>
