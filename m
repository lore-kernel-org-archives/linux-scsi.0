From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 10/11] scsi: fix bad use of udelay in atp870u.c
Date: Fri, 09 Jan 2009 15:21:47 -0600
Message-ID: <1231536107.3235.50.camel@localhost.localdomain>
References: <200901092028.n09KSAeI024551@imap1.linux-foundation.org>
	 <20090109205835.GB5069@deprecation.cyrius.com>
	 <20090109130308.bfde281e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52741 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753169AbZAIVVv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2009 16:21:51 -0500
In-Reply-To: <20090109130308.bfde281e.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Michlmayr <tbm@cyrius.com>, linux-scsi@vger.kernel.org

On Fri, 2009-01-09 at 13:03 -0800, Andrew Morton wrote:
> On Fri, 9 Jan 2009 21:58:35 +0100
> Martin Michlmayr <tbm@cyrius.com> wrote:
> 
> > * akpm@linux-foundation.org <akpm@linux-foundation.org> [2009-01-09 12:28]:
> > > The ACARD driver calls udelay() with a value > 2000, which leads to
> > > to the following compilation error on ARM:
> > >   ERROR: "__bad_udelay" [drivers/scsi/atp870u.ko] undefined!
> > >   make[1]: *** [__modpost] Error 1
> > > Fix this by using a combination of mdelay and udelay.
> > 
> > James already said that this patch is wrong,
> 
> Well, it's not "wrong" - it has no runtime effect - it just fixes the build.

It's wrong to silence a warning or build break while keeping the effect
it was complaining about it's hiding a bug.  Now if the warning is
wrong, we can take it out of the ARM build ... but I've got to say it
looks right: the udelay in this driver will lock a UP system solid for
2ms.

James


