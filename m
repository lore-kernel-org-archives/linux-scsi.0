From: Tyrel Datwyler <turtle.in.the.kernel@gmail.com>
Subject: Re: ibmvfc oddities
Date: Thu, 21 Sep 2017 11:29:55 -0700
Message-ID: <41162a79-9bf8-97c2-7282-e8cde619cd27@gmail.com>
References: <a0969601-e06a-7b90-36f0-357c54bfbfe7@suse.de>
 <4b11b1f6-cc46-5f40-2810-02f8ae9792cb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:56589 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751781AbdIUS36 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2017 14:29:58 -0400
Received: by mail-qk0-f176.google.com with SMTP id g128so1745608qke.13
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 11:29:58 -0700 (PDT)
In-Reply-To: <4b11b1f6-cc46-5f40-2810-02f8ae9792cb@linux.vnet.ibm.com>
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 09/21/2017 08:13 AM, Brian King wrote:
> On 09/21/2017 05:02 AM, Hannes Reinecke wrote:
>> Hi Brian,
>>
>> I was looking at the ibmvfc code (trying to hook up libfc), and have
>> found this definition:
>>
>> struct ibmvfc_fcp_rsp_info {
>> 	__be16 reserved;
>> 	u8 rsp_code;
>> 	u8 reserved2[4];
>> }__attribute__((packed, aligned (2)));
>>
>> in comparison, libfc has this:
>>
>> struct fcp_resp_rsp_info {
>>     __u8      _fr_resvd[3];       /* reserved */
>>     __u8      rsp_code;           /* Response Info Code */
>>     __u8      _fr_resvd2[4];      /* reserved */
>> };
>>
>> So both look _nearly_ identical, except the missing byte at the start.
>> It might be inserted due to some compile alignment magic, but I'd rather
>> not rely on this.
>> Could you clarify if the two structures really are different, or if this
>> is a simple oversight?
> 
> Looks like a bug to me. We should probably just have ibmvfc use the
> libfc definition.

Yes, after looking at the FC spec we most definitely have it defined wrong, and I'm pretty
certain that we aren't getting saved by any compiler magic.

> 
> Tyrel - can you do this conversion and run a bit of regression testing?
> Looking at the possible values of rsp_code, the most likely place where
> this might cause us some issues is in TMF handling. I'm a little
> worried this could result in a potential double completion in error
> handling in some rare cases.... Tyrel - are you aware of any issues
> like that, which this might explain?

I certainly can. I recollect something like a double completion issue, but its been so
long I can't remember if we were seeing it in the vfc driver or the vscsi driver. Anyhow,
I do feel like from what I recall it seems like rsp_code is always zero in reported error
messages.

-Tyrel

> 
> Thanks,
> 
> Brian
> 
