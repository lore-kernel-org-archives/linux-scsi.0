From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] async: make sure independent async domains can't
	accidentally entangle.
Date: Sun, 24 May 2009 13:50:43 -0500
Message-ID: <1243191043.2889.20.camel@localhost.localdomain>
References: <1243175371.2889.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55206 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752949AbZEXSum (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 May 2009 14:50:42 -0400
In-Reply-To: <1243175371.2889.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Sun, 2009-05-24 at 09:29 -0500, James Bottomley wrote:
> The problem occurs when async_synchronize_full_domain() is called when
> the async_pending list is not empty.  This will cause lowest_running()
> to return the cookie of the first entry on the async_pending list, which
> might be nothing at all to do with the domain being asked for and thus
> cause the domain synchronization to wait for an unrelated domain.   This
> can cause a deadlock if domain synchronization is used from one domain
> to wait for another.
> 
> Fix by running over the async_pending list to see if any pending items
> actually belong to our domain (and return their cookies if they do).
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

OK, so that version locked up under testing ... this version doesn't ---
I think the phrase "MUST be called with the lock held!" was supposed to
be some sort of clue ...

James

---

diff --git a/kernel/async.c b/kernel/async.c
index 968ef94..13ed571 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -92,19 +92,21 @@ extern int initcall_debug;
 static async_cookie_t  __lowest_in_progress(struct list_head *running)
 {
 	struct async_entry *entry;
+	async_cookie_t ret = next_cookie; /* begin with "infinity" value */
+
 	if (!list_empty(running)) {
 		entry = list_first_entry(running,
 			struct async_entry, list);
-		return entry->cookie;
+		ret = entry->cookie;
 	} else if (!list_empty(&async_pending)) {
-		entry = list_first_entry(&async_pending,
-			struct async_entry, list);
-		return entry->cookie;
-	} else {
-		/* nothing in progress... next_cookie is "infinity" */
-		return next_cookie;
+		list_for_each_entry(entry, &async_pending, list)
+			if (entry->running == running) {
+				ret = entry->cookie;
+				break;
+			}
 	}
 
+	return ret;
 }
 
 static async_cookie_t  lowest_in_progress(struct list_head *running)


