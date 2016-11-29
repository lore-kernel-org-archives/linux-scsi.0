From: Juergen Gross <jgross@suse.com>
Subject: Re: [Xen-devel] [PATCH] xen/scsifront: don't advance ring request
 pointer in case of error
Date: Tue, 29 Nov 2016 12:19:33 +0100
Message-ID: <cbf7fc2e-09e4-f2ef-3fa3-5371be08270d@suse.com>
References: <20161125202650.GK6266@mwanda>
 <20161129105013.7419-1-jgross@suse.com> <583D712F0200007800123283@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60221 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754940AbcK2LTg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Nov 2016 06:19:36 -0500
In-Reply-To: <583D712F0200007800123283@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Beulich <JBeulich@suse.com>
Cc: lambert.quentin@gmail.com, jejb@linux.vnet.ibm.com, xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com, dan.carpenter@oracle.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 29/11/16 12:14, Jan Beulich wrote:
>>>> On 29.11.16 at 11:50, <JGross@suse.com> wrote:
>> --- a/drivers/scsi/xen-scsifront.c
>> +++ b/drivers/scsi/xen-scsifront.c
>> @@ -184,8 +184,6 @@ static struct vscsiif_request *scsifront_pre_req(struct vscsifrnt_info *info)
>>  
>>  	ring_req = RING_GET_REQUEST(&(info->ring), ring->req_prod_pvt);
>>  
>> -	ring->req_prod_pvt++;
> 
> Please note the "_pvt" suffix, which stands for "private": This field is
> not visible to the backend. Only ring->sring fields are shared, and
> the updating of the shared field happens in RING_PUSH_REQUESTS()
> and RING_PUSH_REQUESTS_AND_CHECK_NOTIFY().

Sure, but RING_PUSH_REQUESTS() will copy req_prod_pvt to req_prod. In
the case corrected this would advance req_prod by two after the error
case before, even if only one request would have made it to the ring.

As an alternative I could have decremented req_prod_pvt in case of an
error, but I like my current solution better.


Juergen
