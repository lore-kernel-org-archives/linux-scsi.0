From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.30-rc8 Oops whilst booting
Date: Mon, 8 Jun 2009 10:42:14 -0700 (PDT)
Message-ID: <alpine.LFD.2.01.0906081039520.6847@localhost.localdomain>
References: <200906061959.55592.chris2553@googlemail.com>  <200906062215.30571.chris2553@googlemail.com>  <1244381140.30664.12.camel@ht.satnam>  <c6b1100b0906071138g2c46fb34vc1a2beb9438f1f1e@mail.gmail.com>  <1244413881.18742.31.camel@ht.satnam>
 <2f9e3044bafcae848f74a1492b0ea471.squirrel@neil.brown.name>  <c6b1100b0906080108y191bb157n67ec681ade2a0d13@mail.gmail.com>  <c6b1100b0906080358y4033c402ra236eff3f972d169@mail.gmail.com>  <1244460875.12644.2.camel@ht.satnam>
 <c6b1100b0906080553o2aa77a40pe0077b1b10a7d88a@mail.gmail.com>  <alpine.LFD.2.01.0906080916130.6847@localhost.localdomain> <1244480796.4079.301.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904AbZFHRnY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 13:43:24 -0400
In-Reply-To: <1244480796.4079.301.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Chris Clayton <chris2553@googlemail.com>, Jaswinder Singh Rajput <jaswinder@kernel.org>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>



On Mon, 8 Jun 2009, James Bottomley wrote:
> 
> I think it's a bug in the async code.  It's providing cookies too high
> because it doesn't stop after it finds a running entry.
> 
> Can we try this as the fix?

Ok, this looks likely.

That said, why doesn't that function look like this?

		Linus
---
 kernel/async.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index 5054030..27235f5 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -92,23 +92,18 @@ extern int initcall_debug;
 static async_cookie_t  __lowest_in_progress(struct list_head *running)
 {
 	struct async_entry *entry;
-	async_cookie_t ret = next_cookie; /* begin with "infinity" value */
 
 	if (!list_empty(running)) {
 		entry = list_first_entry(running,
 			struct async_entry, list);
-		ret = entry->cookie;
+		return entry->cookie;
 	}
 
-	if (!list_empty(&async_pending)) {
-		list_for_each_entry(entry, &async_pending, list)
-			if (entry->running == running) {
-				ret = entry->cookie;
-				break;
-			}
-	}
+	list_for_each_entry(entry, &async_pending, list)
+		if (entry->running == running)
+			return entry->cookie;
 
-	return ret;
+	return next_cookie;	/* "infinity" value */
 }
 
 static async_cookie_t  lowest_in_progress(struct list_head *running)
