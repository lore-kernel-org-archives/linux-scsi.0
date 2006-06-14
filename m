From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [REPOST][PATCH 1/6] mpt fusion - fibre channel target discovery prematurely terminates
Date: Wed, 14 Jun 2006 16:27:52 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70199735@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:36838 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964881AbWFNW14 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jun 2006 18:27:56 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wednesday, June 14, 2006 1:00 PM, Mike Reed wrote: 
> 
> James Bottomley wrote:
> > 
> > I was still thinking of something that made mpt_config() 
> never return
> > -EAGAIN.  How does the following work out?  It's my first pass at
> > sorting out the frame and active logic in mptbase:
> 
> 
> pCfg->wait_done needs to be initialized to zero before sleeping.
> 

agreed

> It takes seven to ten seconds for the ioc->active value to become
> non-zero and the wake up to occur.
> 
> It appears that the order of execution during "lsiutil 99" testing
> has changed.  Once the driver marks the fibre targets missing, they
> never return.  Hmmm....  Until this is resolved, this patch cannot
> be applied.  I'll see if I can sort out how the execution order
> has changed.

not clear what you mean by "they never return"

> 
> Another comment, for every i/o, this patch introduces overhead.
> spinlock and checking a list which is empty 99.99[...]% of the time.
> I'll have to perform an iop measurement to see if there is a
> measurable impact on system performance.
> 

What overhead?  We don't read config pages on every I/O.  James
patch only effects the reading of config pages when there is
a host reset.

One concern on this patch.  A possible deadlock situation could
occur if we run out of message frames.  Meaning there is another way
that  mpt_get_msg_frame() could return NULL, and that is becuase
the ioc->FreeQ list is empty.  This patch only addresses the case
when there is a host reset.   Utimatley we need to address both
cases when NULL is returned.  Id rather try to come  up with a
solution where the fix is isolated inside of mpt_get_msg_frame().

Eric Moore
