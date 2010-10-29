From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: Subject: [RFC 0/3] Add fc_rport attributes to further populate
 HBAAPIv2 HBAPortAttributes for discovered ports.
Date: Fri, 29 Oct 2010 15:35:41 -0400
Message-ID: <alpine.LFD.2.00.1010291532220.3526@localhost.localdomain>
References: <alpine.LFD.2.00.1010281212441.2885@localhost.localdomain> <20101029104515.GA15522@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:2701 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab0J2Tfq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2010 15:35:46 -0400
In-Reply-To: <20101029104515.GA15522@schmichrtp.mainz.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



On Fri, 29 Oct 2010, Christof Schmitt wrote:

> On Thu, Oct 28, 2010 at 12:14:18PM -0400, Chad Dupuis wrote:
>> Hi All,
>>
>> This small patch set adds 7 new attributes to the fc_rport struct so that application libraries who export HBAAPI v2 discovered port attributes can populate the HBA_PORTATTRIBUTES structure more fully.  The new fc_rport attributes,
>> which would be exported via the /sys/class/fc_remote_port/rport-x:y-z directory, are:
>>
>> - supported_fc4s
>> - supported_speed
>> - port_type
>> - speed
>> - active_fc4s
>> - symbolic_name
>> - fabric_name
>>
>> These attributes would be fixed-attributes which would mean that they would be set before the call to fc_remote_port_rolechg() but then once the role of the port has been established they would not change.
>>
>> There are two patches in this RFC:
>>
>> Patch #1 - scsi_transport_fc: Add HBAAPI v2 attributes to fc_rport structure.
>>
>> This patch adds the definitions for the new fc_rport attributes, sets up the show functions and assigns default nominal values to the attributes.
>>
>> Patch #2 - qla2xxx: Add name and management server queries to fill in new fc_rport attributes.
>>
>> This patch adds the necessary name and management server calls to the SAN fabric services to obtain the information needed to fill in the new fc_rport attributes.  The patch also assigns the attributes before calling
>> fc_remote_port_rolechg().
>
> It looks like this mechanism only queries data from the FC nameserver.
> It would be useful to have the same data available for all FC drivers.
> The FC BSG interface already allows sending CT requests to the FC
> nameserver. Could this be implemented by creating the request in
> common code and issue the requests through the FC BSG interface? If

We considered using bsg as the means for getting the information to and
from user space but deciced that exporting the information through
/sys/class/fc_remote_ports was easier and probably more appropriate as
other attributes relating to rports are currently exported there.

> the data is used by the HBAAPI, the userspace HBAAPI could create the
> FC requests and issue them through the /dev/bsg/... device files.

I think this would be a little too low level for a user level library.
Normally for user space I would assume we want to hide the mechanism
(which is very hardare dependent) that is used to get the information 
and rather just expose the information itself.

>
> --
> Christof
>
>
