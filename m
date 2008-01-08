From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sym8xx_2: kill compilation warning
Date: Tue, 08 Jan 2008 09:35:53 -0600
Message-ID: <1199806553.3534.11.camel@localhost.localdomain>
References: <20080107225619.59621db7.krzysztof.h1@poczta.fm>
	 <1199745575.3126.50.camel@localhost.localdomain>
	 <20080108074034.604f84ee.krzysztof.h1@poczta.fm>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38166 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754975AbYAHPf7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 10:35:59 -0500
In-Reply-To: <20080108074034.604f84ee.krzysztof.h1@poczta.fm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: linux-scsi@vger.kernel.org, matthew@wil.cx


On Tue, 2008-01-08 at 07:40 +0100, Krzysztof Helt wrote:
> On Mon, 07 Jan 2008 16:39:35 -0600
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > 
> > On Mon, 2008-01-07 at 22:56 +0100, Krzysztof Helt wrote:
> > > From: Krzysztof Helt <krzysztof.h1@wp.pl>
> > > 
> > > This patch fixes call to wait_for_completion_timeout()
> > > with NULL argument.
> > 
> > That doesn't seem to be at all what your patch is doing.  I can't see
> > any case in the old code where wait_for_completion_timeout() could be
> > called with a NULL that you fix.  What it seems you are doing is
> > altering the code to eliminate the finished_reset variable.
> > 
> 
> I am sorry for the mess. I put the wrong description of the patch.
> Here is the correct one:
> ---
> 
> The purpose of the patch is to kill the compilation warning with gcc-4.1.1 on sparc64:
> 
> sym_glue.c: In function sym_eh_handler:
> sym_glue.c:612: warning: io_reset may be used uninitialized in this function
> 
> This patch also eliminates the finished_reset variable.

OK, ordinarily we don't change kernel code for what is clearly a
compiler bug (as in other versions of gcc 4.1 don't produce this warning
because they see the tie between the two variables).

However, now that I actually look at this code, it has two clear bugs in
it:

     1. the if (!sym_data->io_reset).  That variable is only ever filled
        by a stack based completion.  If we find it non empty it means
        this code has been entered twice and we have a severe problem,
        so that should just become a BUG_ON(!sym_data->io_reset)
     2. sym_data->io_reset should be set to NULL before the routine is
        exited otherwise the PCI recovery code could end up completing
        what will be a bogus pointer into the stack.

The vaule of sym_data->io_reset looks like it should remain current
across the lock, so there's no need to save it in a variable (the
sym2_io_resume() routine also shouldn't be setting it to NULL, and the
complete_all should be complete---just because we can only have a single
thread waiting for the completion otherwise all hell would break loose).

So, fix these issues (and quietly change the code not to produce the
compile warning on sparc64) and it can go in.

James


