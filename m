From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH]: fixing gcc 4.4 compiler warning: suggest parentheses
 around operand of ???!???
Date: Fri, 1 May 2009 08:09:24 +0300 (EEST)
Message-ID: <alpine.LNX.2.00.0905010759370.3660@kai.makisara.local>
References: <20090430060430.GA6040@localhost> <1241127084.3320.14.camel@mulgrave.int.hansenpartnership.com> <20090430215906.GA5214@mydomain.tld> <1241129324.3320.21.camel@mulgrave.int.hansenpartnership.com> <20090430222642.GP8633@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:57350 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZEAFRW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2009 01:17:22 -0400
In-Reply-To: <20090430222642.GP8633@ZenIV.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Sergey Senozhatsky <sergey.senozhatsky@mail.by>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

On Thu, 30 Apr 2009, Al Viro wrote:

> On Thu, Apr 30, 2009 at 10:08:44PM +0000, James Bottomley wrote:
> 
> > Well, I know why (!STp->use_pf) is wrong: it would set USE_PF in an
> > incredibly obscure fashon.  The flag PF_TESTED seems to imply that it's
> > a don't check this again type deal, and the if clause is looking for it
> > not being set, hence I think the most likely thing to be done here is
> > set the PF_TESTED flag.
> 
> Not _set_ USE_PF; what's happening there is
> 	^= USE_PF | PF_TESTED; 	/* we know that PF_TESTED was not set */
> 
Yes, this is the correct interpretation. This "bug" has been on my list of 
things to fix since David Binderman reported it to me earlier. The fix has 
waited because the current code is correct but difficult to read. The fix 
I have been planning is

        STp->use_pf = (STp->use_pf ^ USE_PF) | PF_TESTED;

This is a little more explicit in showing that we want to flip the bit 
masked by USE_PF and tell that we have tried both alternatives.

I can make a patch later today or tomorrow.

Thanks,
Kai

