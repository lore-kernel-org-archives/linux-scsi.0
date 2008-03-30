From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 08/17] scsi: replace remaining __FUNCTION__ occurrences
Date: Sun, 30 Mar 2008 08:07:48 -0700
Message-ID: <20080330080748.5b40231d.akpm@linux-foundation.org>
References: <200803282148.m2SLmbog012237@imap1.linux-foundation.org>
	<1206743704.3662.61.camel@localhost.localdomain>
	<20080328154518.1a178afa.akpm@linux-foundation.org>
	<1206886107.4224.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752315AbYC3PHx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2008 11:07:53 -0400
In-Reply-To: <1206886107.4224.12.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, harvey.harrison@gmail.com

On Sun, 30 Mar 2008 09:08:27 -0500 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> 
> On Fri, 2008-03-28 at 15:45 -0700, Andrew Morton wrote:
> > On Fri, 28 Mar 2008 17:35:04 -0500
> > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > On Fri, 2008-03-28 at 14:48 -0700, akpm@linux-foundation.org wrote:
> > > > From: Harvey Harrison <harvey.harrison@gmail.com>
> > > > 
> > > > __FUNCTION__ is gcc-specific, use __func__
> > > 
> > > I thought we basically agreed
> > 
> > No.
> 
> OK, so what are your reasons?  I've only heard the unpersuasive:
> 
> > 1) Currently there is a mix of __FUNCTION__ and __func__ in the
> > kernel,
> > and __func__ is ansi C (C99...)
> > 
> > 2) It's shorter
> > 
> > 3) When people look around to add new code, they will only see the one
> > way the kernel does it.
> > 
> > None of which are very convincing, but there you go.
> 

That's four reasons.

> 
> > > there was no point to this since if it
> > > ever became an issue you can do 
> > > 
> > > #define __FUNCTION__ __func__
> > > 
> > > inside the include/compiler-xxx.h file
> > > 
> > 
> > It's better to get things right at the original code site, rather than
> > adding crufty back-compatibility macros.
> 
> What do you mean "get things right"?  __FUNCTION__ isn't even deprecated
> in gcc (the deprecation was __FUNCTION__ string concatenation) ...
> there's no sign it will ever be wrong.  It's also stylistically far more
> consonant with __FILE__ and __LINE__.

That's a bug.  __FILE__ and __LINE__ are preprocessor variables. 
__FUNCTION__ is not.

> > The patches are easy to prepare, easy to review and easy to merge.  There's
> > no reason to not do so.
> 
> Except for the code churn in the drivers and the merge problems it
> causes (The -mc tree already has this reverted in acpi to fix a merge
> issue).  The greater issue is setting the bar too low for for mechanical
> changes ... what's next?  C99 comments?  u32 -> uint32_t ... there are
> tons of possible sweeping changes that could be justified on the above
> grounds.

If merge problems are preventing scsi (and only scsi) from being able to
handle trivial cleanups then _that_ is what should be fixed, rather than
avoiding the cleanups.

