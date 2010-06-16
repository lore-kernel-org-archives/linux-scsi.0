From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 13/15] qla4xxx: Added bsg support
Date: Wed, 16 Jun 2010 06:16:14 -0500
Message-ID: <4C18B27E.3000205@cs.wisc.edu>
References: <20100611074900.GA27827@sles11sp1b1.qlogic.org>	 <4C12D398.8020200@cs.wisc.edu> <1276382259.10508.25.camel@mulgrave.site> <4C153B3F.2030608@cs.wisc.edu> <5E4F49720D0BAD499EE1F01232234BA871286CE741@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44145 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111Ab0FPLN4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2010 07:13:56 -0400
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA871286CE741@AVEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: "james.bottomley@suse.de" <james.bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>

On 06/15/2010 09:43 PM, Vikas Chaudhary wrote:
>> -----Original Message-----
>> From: Mike Christie [mailto:michaelc@cs.wisc.edu]
>> Sent: Sunday, June 13, 2010 1:11 PM
>> To: James Bottomley
>> Cc: Vikas Chaudhary; linux-scsi@vger.kernel.org; Ravi Anand
>> Subject: Re: [PATCH 13/15] qla4xxx: Added bsg support
>>
>> On 06/12/2010 05:37 PM, James Bottomley wrote:
>>> On Fri, 2010-06-11 at 19:23 -0500, Mike Christie wrote:
>>>> On 06/11/2010 02:49 AM, Vikas Chaudhary wrote:
>>>>> Added BSG support to enable application support to configure
>>>>> ISP40XX/ISP82XX adapter.
>>>>>
>>>>> This patch is on top of: http://marc.info/?l=linux-
>> scsi&m=126999297630764&w=2
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
>
> These operations are tied to per pci function in qla4xxx driver.


ServerEgnines supports multiple ips per pci function, so you need 
something that works for everyone like I was talking about in that other 
mail you guys sent about how to export the ipv4 and ipv6 addr.
