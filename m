From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
Date: Wed, 15 Dec 2010 14:33:30 -0500
Message-ID: <1292441610.4688.457.camel@mulgrave.site>
References: <4CBD95C0.6060302@kernel.org>  <4CBD95DC.8000001@kernel.org>
	 <1292194113.2989.9.camel@mulgrave.site>  <4D073E9A.3000608@kernel.org>
	 <1292335754.3058.2.camel@mulgrave.site>  <4D077CD9.6050907@kernel.org>
	 <1292336798.3058.5.camel@mulgrave.site>  <4D078052.3040800@kernel.org>
	 <1292382245.19511.56.camel@mulgrave.site>  <4D08E2FF.5090605@kernel.org>
	 <1292428486.4688.180.camel@mulgrave.site>  <4D08E624.3020808@kernel.org>
	 <1292433773.4688.278.camel@mulgrave.site>  <4D09116C.6010508@kernel.org>
	 <1292440246.4688.416.camel@mulgrave.site>  <4D0914B5.20208@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D0914B5.20208@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-12-15 at 20:19 +0100, Tejun Heo wrote:
> Hello,
> 
> On 12/15/2010 08:10 PM, James Bottomley wrote:
> >> Yes, it would do, but we were already too far with the existing
> >> implementation and I don't agree we need more when replacing it with
> >> usual workqueue usage would remove the issue.  So, when we actually
> >> need them, let's consider that or any other way to do it, please.
> >> A core API with only a few users which can be easily replaced isn't
> >> really worth keeping around.  Wouldn't you agree?
> > 
> > Not really ... since the fix is small and obvious.
> 
> IMHO, it's a bit too subtle to be a good API.  The callee is called
> under different (locking) context depending on the callsite and I've
> been already bitten enough times from implicit THIS_MODULEs.  Both
> properties increase possbility of introducing problems which can be
> quite difficult to detect and reproduce.

Both have subtleties ... see below.

> > Plus now it can't be moved into SCSI because I need the unremovable
> > call chain.
> 
> Yes, with the proposed change, it cannot be moved to SCSI.
> 
> > Show me how you propose to fix it differently first, since we both agree
> > the initial attempt doesn't work, and we can take the discussion from
> > there.
> 
> Given that the structures containing the work items are dynamically
> allocated, I would introduce a scsi_wq, unconditionally schedule
> release works on them and flush them before unloading.  Please note
> that workqueues no longer require dedicated threads, so it's quite
> cheap.

A single flush won't quite work.  The target is a parent of the device,
both of which release methods have execute_in_process_context()
requirements.  What can happen here is that the last put of the device
will release the target (from the function).  If both are moved to
workqueues, a single flush could cause the execution of the device work,
which then queues up target work (and makes it still pending).  A double
flush will solve this (because I think our nesting level doesn't go
beyond 2) but it's a bit ugly ...

execute_in_process_context() doesn't have this problem because the first
call automatically executes the second inline (because it now has
context).

James
