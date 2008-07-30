From: Gal Rosen <galr@storwize.com>
Subject: Re: [PATCH] qla2xxx: Fix dpc_thread race on the module unload
Date: Wed, 30 Jul 2008 10:10:39 +0300
Message-ID: <1217401839.4133.119.camel@galr-linux>
References: <488E02DE.5080100@vlnb.net>
	 <1217267776.3503.112.camel@localhost.localdomain> <488E0C78.80205@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.storwize.com ([62.90.10.208]:31215 "EHLO swdc2.storwiz.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751609AbYG3HKq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2008 03:10:46 -0400
In-Reply-To: <488E0C78.80205@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net


From: James Bottomley <James.Bottomley@Ha...> - 2008-07-29 15:28

On Tue, 2008-07-29 at 19:13 +0400, Vladislav Bolkhovitin wrote:
> James Bottomley wrote:
> > On Tue, 2008-07-29 at 13:32 +0400, Vladislav Bolkhovitin wrote:
> >> Nope, taking only one that hunk from this patch isn't sufficient.
> >> Around 
> >> dpc_thread there is pretty simple and classical race. You can't do
> >>
> >> if (x != NULL)
> >> y = *x;
> >>
> >> without any protection, if x can be set to NULL by another thread.
It 
> >> can happen exactly between "if" and "*x" and hence lead to a crash,
> >> correct?
> > 
> > No.
> 
> What "No"? The above unlocked "if (x != NULL) y = *x;" is always safe 
> now? ;)

No ... no as in your analysis based on the example is not correct to
conclude protection is required. We have quite a number of examples of
this within the linux kernel (the SCSI error thread would be one).

But the wake up of the SCSI error thread is also called by holding a
spinlock (but not to protect the stopping of the thread).
The difference here is that the assignment of the thread to NULL is in
the thread function, when exiting from the while loop, and not before
calling kthread_stop() routine (like in the qla).
Maybe this would be the solution.  
