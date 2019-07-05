From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] scsi_host: add support for request batching
Date: Fri, 5 Jul 2019 09:12:37 +0200
Message-ID: <c1d16dbf-713d-3528-78d7-a3f49c056f74@suse.de>
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <20190530112811.3066-2-pbonzini@redhat.com>
 <760164a0-589d-d9fa-fb63-79b5e0899c00@suse.de>
 <aaa344bf-af29-0485-4e83-5442331a2c9c@redhat.com>
 <afea12a1-47b3-0ebe-a3c2-6adc615bbddf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <afea12a1-47b3-0ebe-a3c2-6adc615bbddf@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 7/4/19 3:19 PM, Paolo Bonzini wrote:
> On 19/06/19 12:31, Paolo Bonzini wrote:
>>> I'm a bit unsure if 'bd->last' is always set; it's quite obvious that
>>> it's present if set, but what about requests with 'bd->last == false' ?
>>> Is there a guarantee that they will _always_ be followed with a request
>>> with bd->last == true?
>>> And if so, is there a guarantee that this request is part of the same batch?
>> It's complicated.  A request with bd->last == false _will_ always be
>> followed by a request with bd->last == true in the same batch.  However,
>> due to e.g. errors it may be possible that the last request is not sent.
>>  In that case, the block layer sends commit_rqs, as documented in the
>> comment above, to flush the requests that have been sent already.
>>
>> So, a driver that obeys bd->last (or SCMD_LAST) but does not implement
>> commit_rqs is bound to have bugs, which is why this patch was not split
>> further.
>>
>> Makes sense?
> 
> Hannes, can you provide your Reviewed-by?
> 
Well ... since you asked for it:

Where is the 'commit_rqs' callback actually used?
I seem to be going blind, but I can't find it; should be somewhere in
the first patch, no?
As per description:

 * The commit_rqs function is used to trigger a hardware
 * doorbell after some requests have been queued with
 * queuecommand, when an error is encountered before sending
 * the request with SCMD_LAST set.

So it should be somewhere in the error path, probably scsi_error or
something. But I don't seem to be able to find it ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
