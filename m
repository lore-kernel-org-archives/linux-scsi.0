From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [build fix] Re: [GIT PATCH] SCSI part 1
Date: Wed, 16 Jul 2008 07:28:48 -0600
Message-ID: <20080716132848.GB25255@parisc-linux.org>
References: <1216138543.3312.60.camel@localhost.localdomain> <20080716101634.GA8494@elte.hu> <20080716103337.GA22931@elte.hu> <20080716131543.GA3673@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44352 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbYGPN3K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jul 2008 09:29:10 -0400
Content-Disposition: inline
In-Reply-To: <20080716131543.GA3673@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, Jul 16, 2008 at 03:15:43PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > scsi_cmnd.h depends on symbols defined in blkdev.h. The fix is to 
> > > include blkdev.h as well.
> > 
> > that wont work - a better replacement fix is the one below. The 
> > problem is that scsi.h is included even on !CONFIG_BLOCK and then the 
> > BLK_MAX_CDB symbol is meaningless.
> 
> -v3 .. the new methods need to be under #ifdef CONFIG_BLOCK as well. 
> Note my patch is just a quick RFC, this can probably be done cleaner.

Maybe we should just #ifdef CONFIG_BLOCK the inclusion of scsi/*.h in
fs/compat_ioctl.h?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
