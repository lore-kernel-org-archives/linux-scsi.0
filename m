From: "Jayamohan Kalickal" <jayamohank@serverengines.com>
Subject: Re: [PATCH 02/11] qla4xxx: added IPv6 support.
Date: Wed, 07 Apr 2010 10:26:45 -0700
Message-ID: <20100407172645.0434d49b@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail96.messagelabs.com ([216.82.254.19]:50361 "EHLO
	mail96.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758115Ab0DGR0s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Apr 2010 13:26:48 -0400
In-Reply-To: 4BBBFF62.9090900@cs.wisc.edu
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, "ravi.anand" <ravi.anand@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, open-iscsi <open-iscsi@googlegroups.com>, Karen Xie <kxie@chelsio.com>

Mike,

   Yes, IPV6 works for be2iscsi. One of our guys had set it up and we were able to do login etc.

You mentioned that be2iscsi handling is incorrect, can you let me know the details

-Jay

  _____  
From: Mike Christie [mailto:michaelc@cs.wisc.edu]
To: ravi.anand [mailto:ravi.anand@qlogic.com]
Cc: James Bottomley [mailto:james.bottomley@suse.de], Linux-SCSI Mailing List [mailto:linux-scsi@vger.kernel.org], Vikas Chaudhary [mailto:vikas.chaudhary@qlogic.com], open-iscsi [mailto:open-iscsi@googlegroups.com], Karen Xie [mailto:kxie@chelsio.com], Jayamohan Kalickal [mailto:jayamohank@serverengines.com]
Sent: Tue, 06 Apr 2010 20:43:30 -0700
Subject: Re: [PATCH 02/11] qla4xxx: added IPv6 support.

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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

___________________________________________________________________________________
This message, together with any attachment(s), contains confidential and proprietary information of
ServerEngines Corporation and is intended only for the designated recipient(s) named above. Any unauthorized
review, printing, retention, copying, disclosure or distribution is strictly prohibited.  If you are not the
intended recipient of this message, please immediately advise the sender by reply email message and
delete all copies of this message and any attachment(s). Thank you.

