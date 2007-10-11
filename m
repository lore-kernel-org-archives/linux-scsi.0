From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: drivers/fc4/fc.c in git-scsi-misc
Date: Thu, 11 Oct 2007 11:20:58 -0700
Message-ID: <20071011112058.d95fe040.akpm@linux-foundation.org>
References: <20071011025203.e95690ee.akpm@linux-foundation.org>
	<470E037C.4080204@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51525 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628AbXJKSX4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2007 14:23:56 -0400
In-Reply-To: <470E037C.4080204@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

On Thu, 11 Oct 2007 13:05:32 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:

> On Thu, Oct 11 2007 at 11:52 +0200, Andrew Morton <akpm@linux-foundation.org> wrote:
> > davem won't be happy
> > 
> > drivers/fc4/fc.c: In function `fcp_scsi_receive':
> > drivers/fc4/fc.c:397: error: structure has no member named `done'
> > drivers/fc4/fc.c:450: error: structure has no member named `done'
> > drivers/fc4/fc.c: In function `fcp_scsi_queuecommand':
> > drivers/fc4/fc.c:837: error: structure has no member named `done'
> > drivers/fc4/fc.c:838: error: structure has no member named `done'
> > drivers/fc4/fc.c:839: error: structure has no member named `done'
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> OK that was a nice lesson in Kconfig and Linux-Makefile for me :)
> 
> So I can see that drivers/fc4/Kconfig is only "source"d from 
> arch/sparc64/Kconfig. Hence no one experienced the breakage.
> 
> [
> If I add to, say, drivrs/Kconfig
> +source drivers/fc4/Kconfig
> Than everything compiles and I can see the breakage now
> ]

Well if fc4.c compiles OK on non-sparc64 then perhaps we should enable
compilation on non-sparc64.  It will increase maintainability and code
quality and stuff.

otoh people might end up shipping useless drivers in x86 distros.

> Do you have a cross-compiling environment to compile all these
> ARCHs, or you actually have these machines laying around for
> compilation. (It's the cross-compiling I'm interested in)

There are a number of precompiled (by me) cross-compilers at
http://userweb.kernel.org/~akpm/cross-compilers/

