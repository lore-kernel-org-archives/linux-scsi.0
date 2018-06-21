From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [PATCH 0/5]stop normal completion path entering a timeout req
Date: Thu, 21 Jun 2018 09:43:26 +0800
Message-ID: <e87f5946-bb21-942e-2dcc-b24cee1ad23c@oracle.com>
References: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com>
 <20180620181601.GA24145@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620181601.GA24145@localhost.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com, josef@toxicpanda.com, ulf.hansson@linaro.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Keith

Thanks for your kindly response.

On 06/21/2018 02:16 AM, Keith Busch wrote:
> On Wed, Jun 20, 2018 at 09:22:39PM +0800, Jianchao Wang wrote:
>> Dear all
>>
>> scsi timeout and error handler are based on an assumption that normal
>> completion mustn't do anything on an timeout request. After 12f5b931
>> (blk-mq: Remove generation seqeunce), we lost this. __blk_mq_complete
>> request could ensure a request won't be completed twice, but it can
>> still complete a timeout request.
>> scsi (even other drivers) have been working on this assumption for many
>> years, it is dangerous to discard it suddenly. This patch set is to regain this.
> 
> I certainly don't want to harm any drivers. Could you possibly explain
> what about removing silent execptions from the completion handler and
> letting drivers control the destiny of requests they own is "dangerous"?

Letting LLDD control the destiny of requests they own is great idea !
But some of the LLDD (such as scsi) depends on an assumption (or setup)
normal completion mustn't do anything on an timeout request and this is provided
by block layer before 12f5b931 (blk-mq: Remove generation seqeunce) for many years.
timer and IO completion will both attempt to 'grab' the request, we have to make
sure that only one of them succeeds.

We could also refer to the following segment of the Documentation/scsi/scsi_eh.txt
" Note that this does not mean lower layers are quiescent.  If a LLDD
completed a scmd with error status, the LLDD and lower layers are
assumed to forget about the scmd at that point.  However, if a scmd
has timed out, unless hostt->eh_timed_out() made lower layers forget
about the scmd, which currently no LLDD does, the command is still
active as long as lower layers are concerned and completion could
occur at any time.  Of course, all such completions are ignored as the
timer has already expired.
"

So we have to preserve the ability of block layer that it could prevent
IO completion path from entering a timeout request.

With scsi-debug module, I tried to simulate a scenario where timeout and IO
completion path could occur concurrently, the system ran into crash easily.

> 
> A initial look at your proposal looks pretty harmful to me. A driver may
> return BLK_EH_RESET_TIMER, then call blk_mq_complete_req from another
> thread, and your patch will simply lose that request and escalate error
> recovery. That seems exactly what you shouldn't want to happen.
> 
Yes, this is indeed a hole.
The escalated error recovery should could handle this.
And it will be a better scenario than the one caused by trace between io completion
and timeout path.

Thanks
Jianchao
