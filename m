From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] qla2xxx: Fix dpc_thread race on the module unload
Date: Tue, 29 Jul 2008 09:40:57 -0500
Message-ID: <1217342457.6103.4.camel@localhost.localdomain>
References: <488E02DE.5080100@vlnb.net>
	 <20080728180745.GE12762@plap4-2.qlogic.org>  <488EE3A9.8030207@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43084 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755271AbYG2Ol0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2008 10:41:26 -0400
In-Reply-To: <488EE3A9.8030207@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

On Tue, 2008-07-29 at 13:32 +0400, Vladislav Bolkhovitin wrote:
> Nope, taking only one that hunk from this patch isn't sufficient.
> Around 
> dpc_thread there is pretty simple and classical race. You can't do
> 
> if (x != NULL)
>         y = *x;
> 
> without any protection, if x can be set to NULL by another thread. It 
> can happen exactly between "if" and "*x" and hence lead to a crash,
> correct?

No.

Today we go to reasonable lengths to avoid additional locking.
Spinlocks are nasty in most boxes because of the potential for
introducing hot points and cacheline bouncing.

The first question you ask is how hot is the variable ... as in how
constantly changing is it?  This one is set at start of day and cleared
when the thread is killed in shutdown.  Basically there's a single not
NULL -> NULL transition.  Once NULL, it never goes back to not NULL.

The point is that in this particular circumstance, the lock is overkill.
You can either use other indicators to show that the driver is being
removed (and the thread is dying) or you can simply use some type of
refcounting to ensure the thread isn't killed until it's no longer
needed.

Even if it were a constantly changing variable, and therefore a more
ideal candidate for locking, we might still look into atomics and bitops
before adding a lock.

James


