From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
Date: Wed, 15 Dec 2010 17:00:36 +0100
Message-ID: <4D08E624.3020808@kernel.org>
References: <4CBD95C0.6060302@kernel.org>  <4CBD95DC.8000001@kernel.org>	 <1292194113.2989.9.camel@mulgrave.site>  <4D073E9A.3000608@kernel.org>	 <1292335754.3058.2.camel@mulgrave.site>  <4D077CD9.6050907@kernel.org>	 <1292336798.3058.5.camel@mulgrave.site>  <4D078052.3040800@kernel.org>	 <1292382245.19511.56.camel@mulgrave.site>  <4D08E2FF.5090605@kernel.org> <1292428486.4688.180.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292428486.4688.180.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

On 12/15/2010 04:54 PM, James Bottomley wrote:
> On Wed, 2010-12-15 at 16:47 +0100, Tejun Heo wrote:
>> One way or the other, the current code is racy.  The module can go
>> away while the work is still running.  We'll have to add sync
>> interface for ew's, which conceptually is fine but is unnecessary with
>> the current code base.  Let's do it when it actually is necessary.
> 
> OK, ignoring the bickering over API, this is what I don't get.
> 
> The executed function releases the parent reference as its last call.
> That will cause the freeing of the embedded work item and a cascade
> release of all the parents.  If there's no more references, that will
> result in a final put of the module semaphore and rmmod will then
> proceed.  What is racy about that?  All the work structures and
> references have been freed before the module gets removed.  Nothing
> blocks the execution thread in the function, so it exits long before the
> code path gets zeroed.

Because the final put and return aren't atomic against module
unloading.  The worker can get preempted inbetween and the module can
be unloaded beneath it.  When the worker is scheduled back, its text,
which was inside the module, is gone.

To make that working, it either has to do the final put from the code
outside of the module (in another module or built-in) or the module
unloading should guarantee that the work item has finished executing
before proceeding with unload, which can only be done by flushing it
from outside the work itself.

Thanks.

-- 
tejun
