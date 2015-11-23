From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Mon, 23 Nov 2015 13:04:25 -0800
Message-ID: <56537F59.4080708@sandisk.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-3-git-send-email-hch@lst.de>
 <20151113182513.GB21808@obsidianresearch.com> <564640C4.3000603@sandisk.com>
 <20151113220636.GA32133@obsidianresearch.com> <20151114071344.GE27738@lst.de>
 <20151123203712.GB5640@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0062.outbound.protection.outlook.com ([207.46.100.62]:36016
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752566AbbKWVE3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Nov 2015 16:04:29 -0500
In-Reply-To: <20151123203712.GB5640@obsidianresearch.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-rdma@vger.kernel.org, sagig@dev.mellanox.co.il, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 11/23/2015 12:37 PM, Jason Gunthorpe wrote:
> On Sat, Nov 14, 2015 at 08:13:44AM +0100, Christoph Hellwig wrote:
>> On Fri, Nov 13, 2015 at 03:06:36PM -0700, Jason Gunthorpe wrote:
>>> Looking at that thread and then at the patch a bit more..
>>>
>>> +void ib_process_cq_direct(struct ib_cq *cq)
>>> [..]
>>> +	__ib_process_cq(cq, INT_MAX);
>>>
>>> INT_MAX is not enough, it needs to loop.
>>> This is missing a ib_req_notify also.
>>
>> No.  Direct cases _never_ calls ib_req_notify.  Its for the case where
>> the SRP case polls the send CQ only from the same context it sends for
>> without any interrupt notification at al.
>
> Hurm, okay, that is not at all what I was thinking this was for..
>
> So the only use of this function is to drain a send cq, in a state
> where it is guarenteed no new entries can be added, and only if the cq
> is not already event driven. I'd stick those notes in the comment..
>
> Hum. I wonder if this is even a reasonable way to run a ULP. It is
> important that rx completions are not used to drive reaping of
> resources that are still committed to the send queue. ie do not
> trigger send buffer reuse based on a rx completion.
>
> So, if a ULP uses this API, how does it handle the sendq becoming
> full? As above, a ULP cannot use recvs to infer available sendq
> space. It must directly reap the sendq. So a correct ULP would have to
> spin calling ib_process_direct_cq until it makes enough progress to
> add more things to the sendq. I don't obviously see that in SRP - so
> I'm guessing it has buggered up sendq flow control?
>
> NFS had similar problems lately too, I wrote a long explanation to
> Chuck on this subject.
>
> That said, the demand poll almost seems like a reasonable way for a
> ULP to run the sendq, do the polls on send occasionally or when more
> space is needed to better amortize the reaping overhead at the cost of
> send latency. But API wise it needs to be able to switch over to a
> sleep if enough progress hasn't been made.
>
> So.. maybe also add to the comment that ib_process_cq_direct is
> deprecated and should not be used in new code until SRP gets sorted?

Hello Jason,

Considerable time ago the send queue in the SRP initiator driver was 
modified from signaled to non-signaled to reduce the number of 
interrupts triggered by the SRP initiator driver. The SRP initiator 
driver polls the send queue every time before a SCSI command is sent to 
the target. I think this is a pattern that is also useful for other 
ULP's so I'm not convinced that ib_process_cq_direct() should be 
deprecated :-)

Bart.
