From: Mark Lord <liml@rtr.ca>
Subject: [PATCH] fix page_alloc for larger I/O segments (improved)
Date: Thu, 13 Dec 2007 19:46:49 -0500
Message-ID: <4761D279.6050500@rtr.ca>
References: <20071213185326.GQ26334@parisc-linux.org>	<4761821F.3050602@rtr.ca>	<20071213192633.GD10104@kernel.dk>	<4761883A.7050908@rtr.ca>	<476188C4.9030802@rtr.ca>	<20071213193937.GG10104@kernel.dk>	<47618B0B.8020203@rtr.ca>	<20071213195350.GH10104@kernel.dk>	<20071213200219.GI10104@kernel.dk>	<476190BE.9010405@rtr.ca>	<20071213200958.GK10104@kernel.dk>	<20071213140207.111f94e2.akpm@linux-foundation.org>	<1197584106.3154.55.camel@localhost.localdomain>	<20071213142935.47ff19d9.akpm@linux-foundation.org>	<4761B32A.3070201@rtr.ca>	<4761BCB4.1060601@rtr.ca>	<4761C8E4.2010900@rtr.ca>	<4761CE88.9070406@rtr.ca> <20071213163726.3bb601fa.akpm@linux-foundation.org> <4761D160.7060603@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:4426 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764398AbXLNAqv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 19:46:51 -0500
In-Reply-To: <4761D160.7060603@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, lkml@rtr.ca, matthew@wil.cx, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mm@kvack.org, mel@csn.ul.ie


"Improved version", more similar to the 2.6.23 code:

Fix page allocator to give better chance of larger contiguous segments (again).

Signed-off-by: Mark Lord <mlord@pobox.com
---

--- old/mm/page_alloc.c	2007-12-13 19:25:15.000000000 -0500
+++ linux-2.6/mm/page_alloc.c	2007-12-13 19:43:07.000000000 -0500
@@ -760,7 +760,7 @@
 		struct page *page = __rmqueue(zone, order, migratetype);
 		if (unlikely(page == NULL))
 			break;
-		list_add(&page->lru, list);
+		list_add_tail(&page->lru, list);
 		set_page_private(page, migratetype);
 	}
 	spin_unlock(&zone->lock);
