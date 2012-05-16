From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: Re: [dm-devel] multipath_busy() stalls IO due to scsi_host_is_busy()
Date: Wed, 16 May 2012 17:54:45 +0200
Message-ID: <4FB3CDC5.9040608@itwm.fraunhofer.de>
References: <4FB39D78.9020300@itwm.fraunhofer.de> <1337177200.2985.71.camel@dabdike.int.hansenpartnership.com> <4FB3B9DE.1050903@itwm.fraunhofer.de> <4FB3C75F.3070903@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FB3C75F.3070903-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 05/16/2012 05:27 PM, Mike Christie wrote:
> On 05/16/2012 09:29 AM, Bernd Schubert wrote:
>> On 05/16/2012 04:06 PM, James Bottomley wrote:
>>> On Wed, 2012-05-16 at 14:28 +0200, Bernd Schubert wrote:
>>>> shost->can_queue ->   62 here
>>>> shost->host_busy ->   62 when one of the multipath groups does IO,
>>>> further
>>>> multipath groups then seem to get stalled.
>>>>
>>>> I'm not sure yet why multipath_busy() does not stall IO when there is a
>>>> passive path in the prio group.
>>>>
>>>> Any idea how to properly address this problem?
>>>
>>> shost->can_queue is supposed to represent the maximum number of possible
>>> outstanding commands per HBA (i.e. the HBA hardware limit).  Assuming
>>> the driver got it right, the only way of increasing this is to buy a
>>> better HBA.
>>
>> HBA is a mellanox IB adapter. I have not checked yet where the limit of
>
> What driver is this with? SRP or iSER or something else?


Its SRP. The command queue limit comes from SRP_RQ_SIZE. The value seems 
a bit low, IMHO. And its definitely lower than needed for optimal 
performance. However, given that I get good performance when 
multipath_busy() is a noop, I think this is the primary issue here. And 
it is always possible that a single LUN could use all command queues. 
Other LUNs still shouldn't be stalled completely.

So in summary we actually have two issues:

1) Unfair queuing/waiting of dm-mpath, which stalls an entire path and 
brings down overall performance.

2) Low SRP command queues. Is there a reason why 
SRP_RQ_SHIFT/SRP_RQ_SIZE and their depend values such as SRP_RQ_SIZE are 
so small?


Thanks,
Bernd


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
