From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH] xen/scsifront: don't advance ring
 request pointer in case of error
Date: Tue, 29 Nov 2016 04:40:13 -0700
Message-ID: <583D772D02000078001232DD@prv-mh.provo.novell.com>
References: <20161125202650.GK6266@mwanda>
 <20161129105013.7419-1-jgross@suse.com>
 <583D712F0200007800123283@suse.com>
 <cbf7fc2e-09e4-f2ef-3fa3-5371be08270d@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prv-mh.provo.novell.com ([137.65.248.74]:58591 "EHLO
        prv-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752161AbcK2LkR (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:6:2>);
        Tue, 29 Nov 2016 06:40:17 -0500
In-Reply-To: <cbf7fc2e-09e4-f2ef-3fa3-5371be08270d@suse.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Juergen Gross <JGross@suse.com>
Cc: lambert.quentin@gmail.com, jejb@linux.vnet.ibm.com, xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com, dan.carpenter@oracle.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>>> On 29.11.16 at 12:19, <JGross@suse.com> wrote:
> On 29/11/16 12:14, Jan Beulich wrote:
>>>>> On 29.11.16 at 11:50, <JGross@suse.com> wrote:
>>> --- a/drivers/scsi/xen-scsifront.c
>>> +++ b/drivers/scsi/xen-scsifront.c
>>> @@ -184,8 +184,6 @@ static struct vscsiif_request *scsifront_pre_req(struct 
> vscsifrnt_info *info)
>>>  
>>>  	ring_req = RING_GET_REQUEST(&(info->ring), ring->req_prod_pvt);
>>>  
>>> -	ring->req_prod_pvt++;
>> 
>> Please note the "_pvt" suffix, which stands for "private": This field is
>> not visible to the backend. Only ring->sring fields are shared, and
>> the updating of the shared field happens in RING_PUSH_REQUESTS()
>> and RING_PUSH_REQUESTS_AND_CHECK_NOTIFY().
> 
> Sure, but RING_PUSH_REQUESTS() will copy req_prod_pvt to req_prod. In
> the case corrected this would advance req_prod by two after the error
> case before, even if only one request would have made it to the ring.

Okay, then I may have been mislead by the patch description: I
understood it to say that you want to avoid the backend seeing
requests which haven't been filled fully, but it looks like you're
instead saying that for these requests the filling will never be
completed (because of some unrelated(?) error). Iirc other
frontend drivers behave similarly to the unpatched scsifront, and
incrementing req_prod_pvt late has possible (perhaps just
theoretical) other issues, like parallel retrieval and filling of them
on mor than one CPU. Wouldn't it be better to obtain a request
structure only when everything else is ready (and hence no further
errors can occur)? After all you also need to deal with the acquired
ID upon errors, and seems odd to me to deal with the two parts of
cleanup in different places (and even in different ways).

Jan

