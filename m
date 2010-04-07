From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 02/11] qla4xxx: added IPv6 support.
Date: Tue, 06 Apr 2010 22:43:30 -0500
Message-ID: <4BBBFF62.9090900@cs.wisc.edu>
References: <20100130062822.GC10274@linux-qf4p> <4B671A34.9080300@cs.wisc.edu> <7312FDA8-2587-4DA7-9762-978EA46A8B9C@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37504 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472Ab0DGDjz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2010 23:39:55 -0400
In-Reply-To: <7312FDA8-2587-4DA7-9762-978EA46A8B9C@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ravi.anand" <ravi.anand@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, open-iscsi <open-iscsi@googlegroups.com>, Karen Xie <kxie@chelsio.com>, Jayamohan Kalickal <jayamohank@serverengines.com>

On 04/06/2010 05:21 AM, ravi.anand wrote:
>
> On Feb 1, 2010, at 10:15 AM, Mike Christie wrote:
>
>> On 01/30/2010 12:28 AM, Ravi Anand wrote:
>>>
>>
>>> + DEBUG2(dev_info(&ha->pdev->dev, "%s: DDB[%d] osIdx = %d "
>>> + "State %04x ConnErr %08x "
>>> + NIPQUAD_FMT ":%04d \"%s\"\n",
>>
>>
>> Do you go down this path for ipv6 (looked like it did and did in other
>> places)? NIPQUAD_FMT will not work, and we are trying to not use it
>> NIPQUAD_FMT/NIPQUAD. See %pI4 use in qla4xxx_conn_get_param. There is
>> also a %pI6 for ipv6.
>>
>> Also you need to update qla4xxx_conn_get_param and
>> qla4xxx_host_get_param ip handling.
>>>
>>
>
> While trying to address the IPV6 part for conn_get_param() and
> host_get_param(), we ran into
> the dilemma how to populate IPV4 and IPV6 address at the same time.
> Currently on our adapter IPV4 and IPV6 can be enabled at the same time
> and can be active.
>
> So we wanted to find out if for following param mask :
>
> ISCSI_HOST_PARAM_IPADDRESS
>
> should we just fill the buffer for IPV4 and IPV6 address or should
> we need define new param mask sepeartely for IPV6 ?
>
> Basically we will like to follow up with another patch to address this part
> on to of the patches which we have just pushed.
>

Right now iscsi_tcp supports ipv4 and ipv6 for that param. I think 
people have been saying it might be easier to break it up into a ipv4 
and ipv6 param.

Karen, it seems like you are only supporting ipv4 right now. Any thoughts?

Jay, it seems be2iscsi handling is incorrect. Is your driver supporting 
ipv6 right now?
