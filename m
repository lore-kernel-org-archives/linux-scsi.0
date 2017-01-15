From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Revert "scsi: mpt3sas: Fix secure erase premature
 termination"
Date: Sun, 15 Jan 2017 11:13:19 -0800
Message-ID: <1484507599.2405.16.camel@HansenPartnership.com>
References: <1484319727.2527.8.camel@HansenPartnership.com>
         <20170115091925.GA26656@gmail.com>
         <1484496665.2405.2.camel@HansenPartnership.com>
         <CA+55aFweyFstUaKGdg6A9p65URrzZAJNBCF8ou0MfKb4EPL=Rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43544 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751206AbdAOTNY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 15 Jan 2017 14:13:24 -0500
In-Reply-To: <CA+55aFweyFstUaKGdg6A9p65URrzZAJNBCF8ou0MfKb4EPL=Rw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>

On Sun, 2017-01-15 at 10:54 -0800, Linus Torvalds wrote:
> On Sun, Jan 15, 2017 at 8:11 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > 
> > We're not reverting a fix that would cause regressions for others.
> 
> Oh HELL YES we are.
> 
> The rule is that we never break old stuff. Some new fix that fixes
> something that never used to work, but breaks something else, gets
> reverted very aggressively.
> 
> So if a new bugfix or workaround causes problems for existing users,
> it gets reverted. The fact that it fixed something else is COMPLETELY
> IRRELEVANT.
> 
> We do not do the "one step forward, two steps back" dance. If you
> can't fix a bug without breaking old systems, the "fix" gets
> reverted.
> 
> Apparently there is already a possible real fix in flight, so I won't
> actually do the revert, but I very much want to object to your
> statement.
> 
> Reverts happen.

Can we compromise on "try not to revert a fix ...".  The problem with
bugs in regression fixes is that we now have two constituencies: the
people who get the regression back if we revert the fix and the people
who are bitten by the bug in the original regression fix.  In this
particular case, I think we should always try to fix the fix because
reversion also violates "never break old stuff".  There are corner
cases, of course, like if the latter constituency is much bigger and
the fix is hard to fix, then we might revert and try again.

James

