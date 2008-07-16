From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [build fix] Re: [GIT PATCH] SCSI part 1
Date: Wed, 16 Jul 2008 10:11:57 -0500
Message-ID: <1216221117.3358.19.camel@localhost.localdomain>
References: <1216138543.3312.60.camel@localhost.localdomain>
	 <20080716101634.GA8494@elte.hu> <20080716103337.GA22931@elte.hu>
	 <20080716131543.GA3673@elte.hu>
	 <1216216320.3230.1.camel@localhost.localdomain>
	 <20080716141805.GB22631@elte.hu>
	 <1216218498.3358.3.camel@localhost.localdomain>
	 <20080716144501.GA4369@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49758 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595AbYGPPMF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2008 11:12:05 -0400
In-Reply-To: <20080716144501.GA4369@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, 2008-07-16 at 16:45 +0200, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Wed, 2008-07-16 at 16:18 +0200, Ingo Molnar wrote:
> > > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > 
> > > > On Wed, 2008-07-16 at 15:15 +0200, Ingo Molnar wrote:
> > > > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > > > 
> > > > > > > scsi_cmnd.h depends on symbols defined in blkdev.h. The fix is to 
> > > > > > > include blkdev.h as well.
> > > > > > 
> > > > > > that wont work - a better replacement fix is the one below. The 
> > > > > > problem is that scsi.h is included even on !CONFIG_BLOCK and then the 
> > > > > > BLK_MAX_CDB symbol is meaningless.
> > > > > 
> > > > > -v3 .. the new methods need to be under #ifdef CONFIG_BLOCK as well. 
> > > > > Note my patch is just a quick RFC, this can probably be done 
> > > > > cleaner.
> > > > 
> > > > Erm, Ingo, if you'd just follow linux-next instead of your own tree, 
> > > > you'd see there's already a fix for this.
> > > 
> > > Erm, no. In the merge window i follow upstream -git, not "my tree", and 
> > > i searched lkml for the build failure signature and it had nothing 
> > > there. Then i looked at the commit and it said that it was created just 
> > > 1 day before the merge window started:
> > > 
> > >  commit feac6a07c4a3578bffd6769bb4927e8a7e1f3ffe
> > >  Author:     Martin Petermann <martin@linux.vnet.ibm.com>
> > >  AuthorDate: Wed Jul 2 10:56:35 2008 +0200
> > >  Commit:     James Bottomley <James.Bottomley@HansenPartnership.com>
> > >  CommitDate: Sat Jul 12 08:22:34 2008 -0500
> > >                  ^^^^^^
> > > 
> > > So i didnt even think of it having hit linux-next so i didnt look into 
> > > the linux-next archives. lkml should have been Cc:-ed in this case, 
> > 
> > It was, that would be this email:
> > 
> > http://marc.info/?l=linux-kernel&m=121555252007662
> 
> right - i missed it because i limited my search based on the Jul 12 
> CommitDate. Why is the CommitDate in your commit _after_ the creation of 
> a fix to it? I have found the patch in linux-next as well now, but under 
> a different sha1 that was generated on July 7th.

Because my tree got rebased; some of the patches needed to be moved to
immediate fixes.

James


