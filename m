From: Juergen Gross <jgross@suse.com>
Subject: Re: [Xen-devel] [PATCH] xen/scsifront: don't advance ring request
 pointer in case of error
Date: Tue, 29 Nov 2016 12:33:44 +0100
Message-ID: <7ab5f25c-0611-e67a-3d31-a9c46e5e9aaa@suse.com>
References: <20161125202650.GK6266@mwanda>
 <20161129105013.7419-1-jgross@suse.com> <583D712F0200007800123283@suse.com>
 <cbf7fc2e-09e4-f2ef-3fa3-5371be08270d@suse.com>
 <de9639d9-620a-beac-7a58-14939c2baa0f@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <de9639d9-620a-beac-7a58-14939c2baa0f@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Vrabel <david.vrabel@citrix.com>, Jan Beulich <JBeulich@suse.com>
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, lambert.quentin@gmail.com, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com, dan.carpenter@oracle.com
List-Id: linux-scsi@vger.kernel.org

On 29/11/16 12:28, David Vrabel wrote:
> On 29/11/16 11:19, Juergen Gross wrote:
>> On 29/11/16 12:14, Jan Beulich wrote:
>>>>>> On 29.11.16 at 11:50, <JGross@suse.com> wrote:
>>>> --- a/drivers/scsi/xen-scsifront.c
>>>> +++ b/drivers/scsi/xen-scsifront.c
>>>> @@ -184,8 +184,6 @@ static struct vscsiif_request *scsifront_pre_req(struct vscsifrnt_info *info)
>>>>  
>>>>  	ring_req = RING_GET_REQUEST(&(info->ring), ring->req_prod_pvt);
>>>>  
>>>> -	ring->req_prod_pvt++;
>>>
>>> Please note the "_pvt" suffix, which stands for "private": This field is
>>> not visible to the backend. Only ring->sring fields are shared, and
>>> the updating of the shared field happens in RING_PUSH_REQUESTS()
>>> and RING_PUSH_REQUESTS_AND_CHECK_NOTIFY().
>>
>> Sure, but RING_PUSH_REQUESTS() will copy req_prod_pvt to req_prod. In
>> the case corrected this would advance req_prod by two after the error
>> case before, even if only one request would have made it to the ring.
>>
>> As an alternative I could have decremented req_prod_pvt in case of an
>> error, but I like my current solution better.
> 
> FWIW, I found the commit message a bit misleading and also came to the
> same conclusion as Jan initially.
> 
> Perhaps,
> 
> "When adding a new request to the ring, an error may cause the
> (partially constructed) request to be discarded and used for the next.
> Thus ring->req_prod_pvt should not be advanced until we know the request
> will be successfully added to the ring."

This is indeed much better, thanks.

In case there are no other objections I'll fix this up when
committing.


Juergen
