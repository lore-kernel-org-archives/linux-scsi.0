From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
Date: Tue, 14 Dec 2010 08:26:38 -0600
Message-ID: <1292336798.3058.5.camel@mulgrave.site>
References: <4CBD95C0.6060302@kernel.org>  <4CBD95DC.8000001@kernel.org>
	 <1292194113.2989.9.camel@mulgrave.site>  <4D073E9A.3000608@kernel.org>
	 <1292335754.3058.2.camel@mulgrave.site>  <4D077CD9.6050907@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D077CD9.6050907@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2010-12-14 at 15:19 +0100, Tejun Heo wrote:
> Hello, James.
> 
> On 12/14/2010 03:09 PM, James Bottomley wrote:
> > That's the point ... it's purely for operations which require user
> > context which may not have it.  There's no synchronisation by design
> > (it's a simple API).
> 
> Well, the problem is that you do require proper synchornization
> anyway; otherwise, there is no way to make sure that the work is
> finished before the SCSI module is about to be unloaded.  Currently,
> the code uses flush_scheduled_work() for this, which is going away
> because the latency can grow arbitrarily large and the behavior is
> dependent on completely unrelated work items.  So, either we need to
> add a separate flush interface for ew's, flush the work item inside
> ew's or schedule them to a dedicated workqueue.

Depends what you're doing about the flush problem.  The synchronisation
is inherent in the use (we're holding a reference to the module within
the executed code).  The flush is to try to speed things up so the user
doesn't get annoyed during rmmod.  We don't need a sync, just an
accelerator.

> >> So, unless there's a compelling reason, let's remove it.
> > 
> > The open coding of if (in_atomic()) { do workqueue stuff } else
> > { execute function } is rather bug prone (most people tend to do
> > in_interrupt()).  It's better to encapsulate it in an API.
> 
> Compelling reason for it to exist.  Why not just use work when you
> need execution context and the caller might or might not have one?

Because it's completely lame to have user context and not use it.

> > It was in SCSI ... I got told to make it generic.
> 
> Heh, yeah, that would feel quite silly.  Sorry about that.  :-)
> 
> But, really, let's just remove it.  At this point, we either need to
> fortify the interface or remove it and given the current usage, I
> think we're better off with the latter.

I really don't think the open coding is a good idea.  It's complex and
error prone; exactly the type of thing that should be in an API.

>   If any pressing need arises,
> we can always add a proper API with all the necessary bells and
> whistles later.

James
