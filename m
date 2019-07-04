From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] scsi_host: add support for request batching
Date: Thu, 4 Jul 2019 15:19:08 +0200
Message-ID: <afea12a1-47b3-0ebe-a3c2-6adc615bbddf@redhat.com>
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <20190530112811.3066-2-pbonzini@redhat.com>
 <760164a0-589d-d9fa-fb63-79b5e0899c00@suse.de>
 <aaa344bf-af29-0485-4e83-5442331a2c9c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <aaa344bf-af29-0485-4e83-5442331a2c9c@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 19/06/19 12:31, Paolo Bonzini wrote:
>> I'm a bit unsure if 'bd->last' is always set; it's quite obvious that
>> it's present if set, but what about requests with 'bd->last == false' ?
>> Is there a guarantee that they will _always_ be followed with a request
>> with bd->last == true?
>> And if so, is there a guarantee that this request is part of the same batch?
> It's complicated.  A request with bd->last == false _will_ always be
> followed by a request with bd->last == true in the same batch.  However,
> due to e.g. errors it may be possible that the last request is not sent.
>  In that case, the block layer sends commit_rqs, as documented in the
> comment above, to flush the requests that have been sent already.
> 
> So, a driver that obeys bd->last (or SCMD_LAST) but does not implement
> commit_rqs is bound to have bugs, which is why this patch was not split
> further.
> 
> Makes sense?

Hannes, can you provide your Reviewed-by?

Thanks,

Paolo
