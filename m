From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: transport_class: BUG if we can't release the attribute
	container
Date: Wed, 02 Apr 2008 09:36:46 -0500
Message-ID: <1207147006.3082.14.camel@localhost.localdomain>
References: <1206203957.4393.16.camel@localhost.localdomain>
	 <20080402063232.GD8158@kroah.com>
	 <1207145753.3082.7.camel@localhost.localdomain>
	 <47F3990E.1010002@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:32914 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757927AbYDBOgu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 10:36:50 -0400
In-Reply-To: <47F3990E.1010002@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2008-04-02 at 17:32 +0300, Boaz Harrosh wrote:
> James Bottomley wrote:
> <snip> 
> > Well, we can agree to differ on this.  The camp that wants no side
> > effects for BUG_ON() does so in case they want to define it to be a nop.
> > I've always argued that having special rules for this that differ from
> > functions is asking for trouble.  It's also easy to preserve the side
> > effects by making the compile out do this:
> > 
> > #define BUG_ON(x) (void)(x)
> > 
> > That lets the compiler process the side effects and discard the result.
> > This basically means the rules for BUG_ON() arguments are identical to
> > the rules for function arguments ... I think that's consonant with the
> > principle of least surprise.
> > 
> 
> The Kernel seems to agree with you:
> #define BUG_ON(condition) do { if (condition) ; } while(0)
> 
> what should we do with stuff like
> 	BUG_ON(check_foo_valid()); 
> which is time consuming and should not run on production machines

create a separate CONFIG_FOO_DEBUG flag ... BUG_ON is designed to
operate as assertion checks on all systems ... including production
ones.  In fact, I've never really agreed with the need to compile it out
in the first place.  Extra and time consuming debugging should be
controlled by a config (or runtime, which is nice because you can turn
it on if there's a problem) variable.

> should we directly use:
> #ifdef CONFIG_BUG
> or is there some other facility for that?

James


