From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
Date: Tue, 14 Dec 2010 15:19:05 +0100
Message-ID: <4D077CD9.6050907@kernel.org>
References: <4CBD95C0.6060302@kernel.org>  <4CBD95DC.8000001@kernel.org>	 <1292194113.2989.9.camel@mulgrave.site>  <4D073E9A.3000608@kernel.org> <1292335754.3058.2.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292335754.3058.2.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello, James.

On 12/14/2010 03:09 PM, James Bottomley wrote:
> That's the point ... it's purely for operations which require user
> context which may not have it.  There's no synchronisation by design
> (it's a simple API).

Well, the problem is that you do require proper synchornization
anyway; otherwise, there is no way to make sure that the work is
finished before the SCSI module is about to be unloaded.  Currently,
the code uses flush_scheduled_work() for this, which is going away
because the latency can grow arbitrarily large and the behavior is
dependent on completely unrelated work items.  So, either we need to
add a separate flush interface for ew's, flush the work item inside
ew's or schedule them to a dedicated workqueue.

>> So, unless there's a compelling reason, let's remove it.
> 
> The open coding of if (in_atomic()) { do workqueue stuff } else
> { execute function } is rather bug prone (most people tend to do
> in_interrupt()).  It's better to encapsulate it in an API.

Compelling reason for it to exist.  Why not just use work when you
need execution context and the caller might or might not have one?

> It was in SCSI ... I got told to make it generic.

Heh, yeah, that would feel quite silly.  Sorry about that.  :-)

But, really, let's just remove it.  At this point, we either need to
fortify the interface or remove it and given the current usage, I
think we're better off with the latter.  If any pressing need arises,
we can always add a proper API with all the necessary bells and
whistles later.

Thank you.

-- 
tejun
