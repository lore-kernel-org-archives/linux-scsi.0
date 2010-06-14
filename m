From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 13/15] qla4xxx: Added bsg support
Date: Mon, 14 Jun 2010 15:48:43 -0500
Message-ID: <4C1695AB.4020002@cs.wisc.edu>
References: <4C12D398.8020200@cs.wisc.edu>	<1276382259.10508.25.camel@mulgrave.site>	<4C153B3F.2030608@cs.wisc.edu> <20100614095426E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36412 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab0FNUqc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jun 2010 16:46:32 -0400
In-Reply-To: <20100614095426E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@suse.de, vikas.chaudhary@qlogic.com, linux-scsi@vger.kernel.org, ravi.anand@qlogic.com

On 06/13/2010 07:55 PM, FUJITA Tomonori wrote:
> On Sun, 13 Jun 2010 15:10:39 -0500
> Mike Christie<michaelc@cs.wisc.edu>  wrote:
>
>> On 06/12/2010 05:37 PM, James Bottomley wrote:
>>> On Fri, 2010-06-11 at 19:23 -0500, Mike Christie wrote:
>>>> On 06/11/2010 02:49 AM, Vikas Chaudhary wrote:
>>>>> Added BSG support to enable application support to configure
>>>>> ISP40XX/ISP82XX adapter.
>>>>>
>>>>> This patch is on top of: http://marc.info/?l=linux-scsi&m=126999297630764&w=2
>>>>>
>>>>
>>>> Did James say that using vendor specific commands was ok? I did not see
>>>> anything on the list.
>>>
>>> In principle, the point about vendor specific host commands has already
>>> been conceded ... lpfc and qla2xxx already use them.
>>>
>>> I think the real rule is that for host specific BSG commands, it's only
>>> for stuff that's specific to the host ... so not stuff which should be
>>> done generically.
>>>
>>> There are no hard and fast rules for applying the test above.  In
>>> theory, the management interfaces exposed by FC_BSG_HST_VENDOR could be
>>> used to send commands ... but it tends to get tolerated as long as the
>>> drivers support the standardised rport commands.
>>>
>>> If I look at what the qla4xxx interface would do
>>>
>>>        1. it only supports vendor specific commands ... this is a bit of a
>>>           red flag since it's proposing to do nothing in a vendor neutral
>>>           way.  This one, I punt back to you: what should an iscsi device
>>>           implementing BSG support of the standard commands
>>
>> I am not 100% sure what we need yet, because qlogic has been pushing the
>> vendor specific route and I cannot see exactly what it needs with some
>> of its commands.
>>
>> Based on other drivers and from looking at the qlogic tools and their
>> qlogic.com driver which seems to convert some management operations to
>> flash commands, I have the list below:
>>
>> - Operation to set net settings like ip/dhcp, gateway, dns, subnet,
>> vlan, tcp/ip settings, speed/auto-negotiate, etc.
>>
>> Besides supporting a IPv4 and IPv6 address, some cards can support lots
>> of IPs and/or vlans per same physical port, so this operation cannot be
>> tied to just the host.
>>
>> - Operation to get port state.
>>
>> - Operation to set iscsi initiator port settings like initiator
>> name/alias/isid, iscsi IO settings like FirstBurstLength or Digests,
>> auth settings like chap or radius, etc.
>>
>> This should not be tied to the physical port either since we can have
>> multiple initiator ports per physical port.
>>
>> - Operation to set iscsi settings for specific sessions like iSCSI IO
>> settings and auth settings mentioned above (some drivers want global
>> defaults settable at the host/initiator-port level then be able to
>> specify specific values for each session).
>
> /sys/class/iscsi_* might work better for the above?

Yes and no. It works well when we just have to set 1 value, but if we 
have to set multiple ones then we need to batch them up because it can 
be disruptive to all sessions. When we set a setting in qla4xxx and 
be2iscsi, then I think the card is basically not accessible while the 
value is being set. So if we did use sysfs then we would need some other 
files like maybe one to indicate that we are done setting params and the 
card can write them to the flash now.

>
>
>> - Operation to discover targets and export targets that were found and:
>> 	- Operation to control if we want to log into specific targets that
>> were found.
>>
>> - Operation to notify userpsace of network link state changes.
>>
>> - Operation to notify userpsace of iscsi session/connection state changes.
>
> bsg supports only the request/response interface. The event
> notification from kernel space isn't fit for bsg.

Ah yeah, I just included it for completeness because in their previous 
patchset they were using the scsi netlink code to add vendor specific 
events for them.

>
> Sounds like all the features are useful to any iSCSI HBAs?


Yeah, the iscsi ones are useful to any iscsi HBA that does 
session/connection management in the card. The net ones are useful to 
cards that do net management in the card.
