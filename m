From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 6/8] target_core_spc: Include target device descriptor
 in VPD page 83
Date: Wed, 05 Mar 2014 11:41:33 -0800
Message-ID: <53177DED.8050307@redhat.com>
References: <1387268330-121064-1-git-send-email-hare@suse.de>	 <1387268330-121064-7-git-send-email-hare@suse.de>	 <1387309849.20247.306.camel@haakon3.risingtidesystems.com> <1387310505.20247.309.camel@haakon3.risingtidesystems.com> <52B168F5.9060300@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbaCETll (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Mar 2014 14:41:41 -0500
In-Reply-To: <52B168F5.9060300@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On 12/18/2013 01:20 AM, Hannes Reinecke wrote:
> On 12/17/2013 09:01 PM, Nicholas A. Bellinger wrote:
>> On Tue, 2013-12-17 at 11:50 -0800, Nicholas A. Bellinger wrote:
>>> On Tue, 2013-12-17 at 09:18 +0100, Hannes Reinecke wrote:
>>>> We should be including a descriptor referring to the target device
>>>> to allow identification of different TCM instances.
>>>>
>>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>>> ---
>>>>   drivers/target/target_core_spc.c | 43 +++++++++++++++++++++++++++++++++++++++-
>>>>   1 file changed, 42 insertions(+), 1 deletion(-)
>>>>
>>>
>>> One issue with this patch.  The local buffer in spc_emulate_inquiry is
>>> currently hardcoded to SE_INQUIRY_BUF=512, so two large scsi name
>>> designators could overflow here..
>>>
>>> So for the largest case with EVPD=0x83, this would be:
>>>
>>> 4 bytes for header +
>>> 20 bytes for NAA IEEE Registered Extended Assigned designator +
>>> 56 bytes for T10 Vendor Identifier +
>>> 8 bytes for Relative target port +
>>> 8 bytes for Target port group +
>>> 8 bytes for Logical unit group +
>>> 256 bytes for SCSI name (target port) +
>>> 256 bytes for SCSI name (target device) == 616 bytes.
>>>
>>> So for good measure, bumping up SE_INQUIRY_BUF to 1024.
>>>
>>
>> Mmmm, looking at this again, is reporting back two SCSI names in
>> EVPD=0x83 with different associations (one for target port, and one for
>> target device) really necessary..?
>>
>> Doesn't the existing target port association report back the same
>> information..?
>>
> No.
> 'Target port' is the identification for the port handling the
> request, which is contained within a target device.
>
> The reason why we need this is that we want to identify the scope of
> the Target port group number.
>
> Target port group numbers are relative to the encompassing target
> device, so when we're having _several_ target devices they might
> well provide us with identical target port group numbers.
>
> For explicit ALUA each target port group within a target device can
> be thought of a 'scheduling domain', ie if I sent STPG to one of the
> devices in that domain there is a _high_ likelihood that _every_
> device within that scheduling domain will be affected.
> So I can be slightly smarter here and just send one STPG and then
> wait for the resulting states on all affected devices.
>
> If I don't have this information I am required to send STPG to each
> and every device, thereby flooding the target controller with STPGs
> for the same target port group.
>
> So yes, we should be furnishing both.
> In addition it's the only sane way of identifying the array :-)

Hi, fbfe858 only bumps INQUIRY_BUF to 768 although the comment says 
1024, is this expected and ok?

Regards -- Andy

