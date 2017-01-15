From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Revert "scsi: mpt3sas: Fix secure erase premature
 termination"
Date: Sun, 15 Jan 2017 11:49:36 -0800
Message-ID: <1484509776.2405.21.camel@HansenPartnership.com>
References: <1484319727.2527.8.camel@HansenPartnership.com>
         <20170115091925.GA26656@gmail.com>
         <1484496665.2405.2.camel@HansenPartnership.com>
         <CA+55aFweyFstUaKGdg6A9p65URrzZAJNBCF8ou0MfKb4EPL=Rw@mail.gmail.com>
         <1484507599.2405.16.camel@HansenPartnership.com>
         <CA+55aFyyBf9SLSNDRqMcFbmUBBkbamZYXGOgfXU8k5KYaFD2mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44182 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751223AbdAOTti (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 15 Jan 2017 14:49:38 -0500
In-Reply-To: <CA+55aFyyBf9SLSNDRqMcFbmUBBkbamZYXGOgfXU8k5KYaFD2mw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>

On Sun, 2017-01-15 at 11:41 -0800, Linus Torvalds wrote:
> On Sun, Jan 15, 2017 at 11:13 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > 
> > Can we compromise on "try not to revert a fix ...".
> 
> No.
> 
> It's about timing, and about how serious the regression is.
> 
> For example, if this happened in rc7, I would have reverted
> immediately. No questions asked.
> 
> In this case, the "fix" was was also much less important then the
> problem it caused. Some specialized pass-through command not working
> right, vs a machine not even booting? There's just no question
> what-so-ever.
> 
> So the "fix" you claim just wasn't nearly important enough. It was
> also pretty recent and clearly things had worked for _years_ without
> it.
> 
> In fact, I'm still somewhat inclined to revert it, just to have a
> working rc4 release later today. But I'm hoping maybe Ingo has time 
> to test things (although I suspect he's already asleep).

OK, so the patch to revert would actually be

commit 669f044170d8933c3d66d231b69ea97cb8447338
Author: Bart Van Assche <bart.vanassche@sandisk.com>
Date:   Tue Nov 22 16:17:13 2016 -0800

    scsi: srp_transport: Move queuecommand() wait code to SCSI core

Because that change in the wait code broke the "fix" in mpt3sas. 
 Before that was applied, it actually worked even though I think it's a
wrong fix.

James



