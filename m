From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
Date: Tue, 14 Dec 2010 15:33:54 +0100
Message-ID: <4D078052.3040800@kernel.org>
References: <4CBD95C0.6060302@kernel.org>  <4CBD95DC.8000001@kernel.org>	 <1292194113.2989.9.camel@mulgrave.site>  <4D073E9A.3000608@kernel.org>	 <1292335754.3058.2.camel@mulgrave.site>  <4D077CD9.6050907@kernel.org> <1292336798.3058.5.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292336798.3058.5.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

On 12/14/2010 03:26 PM, James Bottomley wrote:
> Depends what you're doing about the flush problem.  The synchronisation
> is inherent in the use (we're holding a reference to the module within
> the executed code).  The flush is to try to speed things up so the user
> doesn't get annoyed during rmmod.  We don't need a sync, just an
> accelerator.

Hmmm, I'm confused.  How does it drop the reference then?  Something
outside of the callback should wait for its completion and drop the
reference as otherwise nothing can guarantee that the modules doesn't
go away between the reference drop and the actual completion of the
callback.

>> Compelling reason for it to exist.  Why not just use work when you
>> need execution context and the caller might or might not have one?
> 
> Because it's completely lame to have user context and not use it.

It may be lame but I think it's better than having an optimization
interface which is incomplete and, more importantly, unnecessary.

>> But, really, let's just remove it.  At this point, we either need to
>> fortify the interface or remove it and given the current usage, I
>> think we're better off with the latter.
> 
> I really don't think the open coding is a good idea.  It's complex and
> error prone; exactly the type of thing that should be in an API.

Yeah, just schedule work like everyone else.

Thanks.

-- 
tejun
