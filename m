From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/2] scsi: add support for request batching
Date: Wed, 26 Jun 2019 16:50:52 +0200
Message-ID: <cbb24317-7682-a854-4460-e8828db1eb25@redhat.com>
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <746ad64a-4047-1597-a0d4-f14f3529cc19@redhat.com>
 <65e5ad25-a475-989a-ce3d-400a8c90cb61@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <65e5ad25-a475-989a-ce3d-400a8c90cb61@interlog.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 26/06/19 16:14, Douglas Gilbert wrote:
> 
> I have no objections, just a few questions.
> 
> To implement this is the scsi_debug driver, a per device queue would
> need to be added, correct?

Yes, queuecommand would then return before calling schedule_resp (for
all requests except the one with SCMD_LAST, see later).  schedule_resp
would then be called for all requests in a batch.

> Then a 'commit_rqs' call would be expected
> at some later point and it would drain that queue and submit each
> command. Or is the queue draining ongoing in the LLD and 'commit_rqs'
> means: don't return until that queue is empty?

commit_rqs means the former; it is asynchronous.

However, commit_rqs is only called if a request batch fails submission
in the middle of the batch, so the request batch must be sent to the
HBA.  If the whole request batch is sent successfully, then the LLD
takes care of sending the batch to the HBA when it sees SCMD_LAST in the
request.

So, in the scsi_debug case schedule_resp would be called for the whole
batch from commit_rqs *and* when queuecommand sees a command with the
SCMD_LAST flag set.  This is exactly to avoid having two calls to the
LLD in the case of no request batching.

> So does that mean in the normal (i.e. non request batching) case
> there are two calls to the LLD for each submitted command? Or is
> 'commit_rqs' optional, a sync-ing type command?

It's not syncing.  It's mandatory if the queuecommand function observes
SCMD_LAST, not needed at all if queuecommand ignores it.  So it's not
needed at all until your driver adds support for batched submission of
requests to the HBA.

(All this is documented by the patches in the comments for struct
scsi_host_template, if those are not clear please reply to patch 1 with
your doubts).

Paolo
