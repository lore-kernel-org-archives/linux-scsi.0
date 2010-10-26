From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 4/4 ver2] libosd: write/read_sg_kern API
Date: Tue, 26 Oct 2010 12:07:07 +0200
Message-ID: <4CC6A84B.4090009@panasas.com>
References: <4CBD8CAB.2030207@panasas.com> <1287490962-24013-1-git-send-email-bharrosh@panasas.com> <4CBDA79E.8080006@panasas.com> <4CC1CA91.1080003@vlnb.net> <4CC40292.3090500@panasas.com> <4CC5D17A.4070406@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:55253 "HELO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751561Ab0JZKHL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2010 06:07:11 -0400
In-Reply-To: <4CC5D17A.4070406@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Bottomley <James.Bottomley@suse.de>, John Chandy <john.chandy@uconn.edu>, open-osd <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 10/25/2010 08:50 PM, Vladislav Bolkhovitin wrote:
> Boaz Harrosh, on 10/24/2010 01:55 PM wrote:
>> On 10/22/2010 07:32 PM, Vladislav Bolkhovitin wrote:
>>> Boaz Harrosh, on 10/19/2010 06:13 PM wrote:
>>>> This is a trivial addition to the SG API that can receive kernel
>>>> pointers. It is only used by the out-of-tree test module. So
>>>> it's immediate need is questionable. For maintenance ease it might
>>>> just get in, as it's very small.
>>>
>>> This patch doesn't handle queue's restrictions (DMA, etc.).
>>>
>>
>> Please for give me. I know that the name is misleading. The
>> Scatter-List here is the osd scatter-list. Which describes
>> extents on the object, not of the memory. The proper name would
>> be extents API. The reason we named it SG is because this is the
>> way the OSD standard names it. We keep very close with the STD
>> naming convention, so it ended up this way.
> 
> OK, but the queue's restrictions aren't handled by it anyway.
> 
> Vlad

Yes they are!

add_pc_page does the limits. blk_make_request() receives a bio-chain
and does bouncing.

But all this does not matter, because osd is a char-device not
block. Meaning osd objects can be written at char alignment
(offset and length). The way we work with multi segmented "out"
and "in" buffers, anything not char aligned like iscsi or fb will
not work very good any way. (Not very good I mean, everything
will bounce)

The libosd at the API level and internally works with bio-chains
the block-request is only made much later. blk_make_request(bio-chain)
should make everything work. If not it should be fixed.

Boaz
