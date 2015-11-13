From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Fri, 13 Nov 2015 11:57:56 -0800
Message-ID: <564640C4.3000603@sandisk.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-3-git-send-email-hch@lst.de>
 <20151113182513.GB21808@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151113182513.GB21808-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 11/13/2015 10:25 AM, Jason Gunthorpe wrote:
> On Fri, Nov 13, 2015 at 02:46:43PM +0100, Christoph Hellwig wrote:
>> This adds an abstraction that allows ULP to simply pass a completion
>> object and completion callback with each submitted WR and let the RDMA
>> core handle the nitty gritty details of how to handle completion
>> interrupts and poll the CQ.
>
> This looks pretty nice, I'd really like to look it over carefully
> after SC|15..
>
> I know Bart and others have attempted to have switching between event
> and polling driven operation, but there were problems resolving the
> races. Would be nice to review that conversation.. Do you remember the
> details Bart?

Hello Jason,

I think this is the conversation you are referring to: "About a 
shortcoming of the verbs API" 
(http://thread.gmane.org/gmane.linux.drivers.rdma/5028). That 
conversation occurred five years ago, which means that you have an 
excellent memory :-)

I doesn't seem to me like Christoph wanted to support dynamic switching 
between the IB_POLL_DIRECT, IB_POLL_SOFTIRQ and IB_POLL_WORKQUEUE 
polling modes. I think this should have been mentioned in the patch 
description.

The implementation of this patch makes it clear that it is essential 
that all polling is serialized. The WC array that is used for polling is 
embedded in the CQ and is not protected against concurrent access. This 
means that it is essential that _ib_process_cq() calls are serialized. I 
need some more time to verify whether such serialization is always 
guaranteed by this patch.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
