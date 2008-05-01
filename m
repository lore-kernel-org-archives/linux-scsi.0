From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH #repost] SCSI: megaraid, fix suspend/resume sections
Date: Thu, 1 May 2008 15:30:48 -0700
Message-ID: <20080501153048.2a8d356f.akpm@linux-foundation.org>
References: <1209657362-20300-1-git-send-email-jirislaby@gmail.com>
	<20080501142305.77433e50.akpm@linux-foundation.org>
	<481A3781.8080100@gmail.com>
	<1209679559.14864.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754460AbYEAWa7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 18:30:59 -0400
In-Reply-To: <1209679559.14864.33.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: jirislaby@gmail.com, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 01 May 2008 17:05:59 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Thu, 2008-05-01 at 23:34 +0200, Jiri Slaby wrote:
> > On 05/01/2008 11:23 PM, Andrew Morton wrote:
> > > On Thu,  1 May 2008 17:56:02 +0200
> > > Jiri Slaby <jirislaby@gmail.com> wrote:
> > > 
> > >> megaraid_sas suspend and resume are inappropriatelly placed in
> > >> __devinit section.
> > > 
> > > That's a box-killer, isn't it?
> > 
> > I think so -- the non-CONFIG_HOTPLUG ones.
> 
> CONFIG_HOTPLUG is only settable to 'n' if you're CONFIG_EMBEDDED which
> has a zero set intersection with the users of megaraid, so in practical
> terms, there's no actual box it could kill.

who suspends and resumes servers?

> this whole 
> 
> #if CONFIG_PM
> define suspend resume
> #else
> set suspend resume methods to null
> #endif
> 
> Is completely analagous to what we used to do with CONFIG_HOTPLUG before
> we had the __dev.* sectional annotations.  Since the expanding
> bureacracy is determined to keep the _dev.* sections 

ooh, that makes us sound really bad!  ("since the server-obsessed
embedded-hating bloatmonkeys..."?)

> in spite of the pain,

What pain?  Other people write the dang patches for you!  Their main
problem is getting them merged.

> could we not at least make the machinery do something vaguely
> useful and expand it to confine the pm routines to sections which can be
> discarded if CONFIG_PM is n?

a) it would need to be discarded at link-time, ideally.

b) worth investigating.  It might lead to lengthy chains of compilation
   warnings though.

