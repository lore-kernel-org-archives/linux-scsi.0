From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 2.6.30-rc8 Oops whilst booting
Date: Mon, 08 Jun 2009 12:06:36 -0500
Message-ID: <1244480796.4079.301.camel@mulgrave.site>
References: <200906061959.55592.chris2553@googlemail.com>
	 <200906062215.30571.chris2553@googlemail.com>
	 <1244381140.30664.12.camel@ht.satnam>
	 <c6b1100b0906071138g2c46fb34vc1a2beb9438f1f1e@mail.gmail.com>
	 <1244413881.18742.31.camel@ht.satnam>
	 <2f9e3044bafcae848f74a1492b0ea471.squirrel@neil.brown.name>
	 <c6b1100b0906080108y191bb157n67ec681ade2a0d13@mail.gmail.com>
	 <c6b1100b0906080358y4033c402ra236eff3f972d169@mail.gmail.com>
	 <1244460875.12644.2.camel@ht.satnam>
	 <c6b1100b0906080553o2aa77a40pe0077b1b10a7d88a@mail.gmail.com>
	 <alpine.LFD.2.01.0906080916130.6847@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52104 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754860AbZFHRGh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 13:06:37 -0400
In-Reply-To: <alpine.LFD.2.01.0906080916130.6847@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Clayton <chris2553@googlemail.com>, Jaswinder Singh Rajput <jaswinder@kernel.org>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>

On Mon, 2009-06-08 at 09:21 -0700, Linus Torvalds wrote:
> 
> On Mon, 8 Jun 2009, Chris Clayton wrote:
> > 
> > OK. I reversed that change and built and installed the kernel. It has
> > withstood 100 reboots without a panic. Additionally, I pulled the
> > latest changes (that will be rc8-git5, I think) from kernel.org,
> > reversed the change to that kernel and built and installed it. That
> > too withstood 100 reboots without a panic.
> > 
> > Let me know if there's anything else I can do to help fix this.
> 
> That's already pretty convincing.
> 
> James, Arjan? The original oops message is here (a jpg screen capture, 
> unable to open initial console):
> 
> 	http://lkml.org/lkml/2009/6/6/142
> 
> and it's this bug entry:
> 
> 	Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13474
> 	Subject         : Oops whilst booting
> 	Submitter       : Chris Clayton <chris2553@googlemail.com>
> 	Date            : 2009-06-06 18:59 (2 days old)
> 	References      : http://marc.info/?l=linux-kernel&m=124431487924254&w=4
> 
> and now bisected down to 
> 
> >> commit d5a877e8dd409d8c702986d06485c374b705d340
> >> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> >> Date:   Sun May 24 13:03:43 2009 -0700
> >>
> >>     async: make sure independent async domains can't accidentally entangle
> 
> please advice. Otherwise I'll have to revert.

I think it's a bug in the async code.  It's providing cookies too high
because it doesn't stop after it finds a running entry.

Can we try this as the fix?

James

---

diff --git a/kernel/async.c b/kernel/async.c
index 5054030..e4909ee 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -97,7 +97,7 @@ static async_cookie_t  __lowest_in_progress(struct list_head *running)
 	if (!list_empty(running)) {
 		entry = list_first_entry(running,
 			struct async_entry, list);
-		ret = entry->cookie;
+		return entry->cookie;
 	}
 
 	if (!list_empty(&async_pending)) {


