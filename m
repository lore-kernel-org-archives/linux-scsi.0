From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH]: fixing gcc 4.4 compiler warning: suggest parentheses
	around operand of ???!???
Date: Thu, 30 Apr 2009 23:26:42 +0100
Message-ID: <20090430222642.GP8633@ZenIV.linux.org.uk>
References: <20090430060430.GA6040@localhost> <1241127084.3320.14.camel@mulgrave.int.hansenpartnership.com> <20090430215906.GA5214@mydomain.tld> <1241129324.3320.21.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:40984 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbZD3W0p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2009 18:26:45 -0400
Content-Disposition: inline
In-Reply-To: <1241129324.3320.21.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Kai Makisara <Kai.Makisara@kolumbus.fi>

On Thu, Apr 30, 2009 at 10:08:44PM +0000, James Bottomley wrote:

> Well, I know why (!STp->use_pf) is wrong: it would set USE_PF in an
> incredibly obscure fashon.  The flag PF_TESTED seems to imply that it's
> a don't check this again type deal, and the if clause is looking for it
> not being set, hence I think the most likely thing to be done here is
> set the PF_TESTED flag.

Not _set_ USE_PF; what's happening there is
	^= USE_PF | PF_TESTED; 	/* we know that PF_TESTED was not set */
