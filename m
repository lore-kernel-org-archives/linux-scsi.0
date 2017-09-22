From: Hannes Reinecke <hare@suse.de>
Subject: Re: ibmvfc oddities
Date: Fri, 22 Sep 2017 07:59:27 +0200
Message-ID: <ca659cce-b6f2-4283-94b9-a523f1b80dad@suse.de>
References: <a0969601-e06a-7b90-36f0-357c54bfbfe7@suse.de>
 <4b11b1f6-cc46-5f40-2810-02f8ae9792cb@linux.vnet.ibm.com>
 <41162a79-9bf8-97c2-7282-e8cde619cd27@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41821 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751637AbdIVF73 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Sep 2017 01:59:29 -0400
In-Reply-To: <41162a79-9bf8-97c2-7282-e8cde619cd27@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyrel Datwyler <turtle.in.the.kernel@gmail.com>, Brian King <brking@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 09/21/2017 08:29 PM, Tyrel Datwyler wrote:
> On 09/21/2017 08:13 AM, Brian King wrote:
>> On 09/21/2017 05:02 AM, Hannes Reinecke wrote:
>>> Hi Brian,
>>>
>>> I was looking at the ibmvfc code (trying to hook up libfc), and have
>>> found this definition:
>>>
>>> struct ibmvfc_fcp_rsp_info {
>>> 	__be16 reserved;
>>> 	u8 rsp_code;
>>> 	u8 reserved2[4];
>>> }__attribute__((packed, aligned (2)));
>>>
>>> in comparison, libfc has this:
>>>
>>> struct fcp_resp_rsp_info {
>>>     __u8      _fr_resvd[3];       /* reserved */
>>>     __u8      rsp_code;           /* Response Info Code */
>>>     __u8      _fr_resvd2[4];      /* reserved */
>>> };
>>>
>>> So both look _nearly_ identical, except the missing byte at the start.
>>> It might be inserted due to some compile alignment magic, but I'd rather
>>> not rely on this.
>>> Could you clarify if the two structures really are different, or if this
>>> is a simple oversight?
>>
>> Looks like a bug to me. We should probably just have ibmvfc use the
>> libfc definition.
> 
> Yes, after looking at the FC spec we most definitely have it defined wrong, and I'm pretty
> certain that we aren't getting saved by any compiler magic.
> 
>>
>> Tyrel - can you do this conversion and run a bit of regression testing?
>> Looking at the possible values of rsp_code, the most likely place where
>> this might cause us some issues is in TMF handling. I'm a little
>> worried this could result in a potential double completion in error
>> handling in some rare cases.... Tyrel - are you aware of any issues
>> like that, which this might explain?
> 
> I certainly can. I recollect something like a double completion issue, but its been so
> long I can't remember if we were seeing it in the vfc driver or the vscsi driver. Anyhow,
> I do feel like from what I recall it seems like rsp_code is always zero in reported error
> messages.
> 
Sure it would, given that the ibmvfc driver would always use the
reserved bytes as rsp_code :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
