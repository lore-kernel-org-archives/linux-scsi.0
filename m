From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Subject: Re: [PATCH]: fixing gcc 4.4 compiler warning: suggest parentheses
	around operand of ???!???
Date: Fri, 1 May 2009 02:09:13 +0300
Message-ID: <20090430230913.GA5833@mydomain.tld>
References: <20090430060430.GA6040@localhost> <1241127084.3320.14.camel@mulgrave.int.hansenpartnership.com> <20090430215906.GA5214@mydomain.tld> <1241129324.3320.21.camel@mulgrave.int.hansenpartnership.com> <20090430222642.GP8633@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [212.98.175.89] ([212.98.175.89]:50177 "EHLO mydomain.tld"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754773AbZD3XKS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2009 19:10:18 -0400
Content-Disposition: inline
In-Reply-To: <20090430222642.GP8633@ZenIV.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Kai Makisara <Kai.Makisara@kolumbus.fi>, James Bottomley <James.Bottomley@HansenPartnership.com>

On (30/04/09 23:26), Al Viro wrote:
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

st.h:#define PF_TESTED   2
st.h:#define USE_PF      1

st.c:2963
if (cmdstatp->sense_hdr.sense_key == ILLEGAL_REQUEST && !(STp->use_pf & PF_TESTED))

'&& !(STp->use_pf & PF_TESTED)' means: STp->use_pf == 0 or STp->use_pf != ... 0010 (PF_TESTED).

if == 0
STp->use_pf = !0 | 2    -> 3

if > PF_TESTED
STp->use_pf = 0 | PF_TESTED     -> PF_TESTED

I need to think about
> I think the most likely thing to be done here is set the PF_TESTED flag.

Sergey.

