From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 1/2] SCSI tape: Store page order before driver buffer
 allocation
Date: Mon, 20 Dec 2010 18:43:39 +0200 (EET)
Message-ID: <alpine.LNX.2.00.1012201841230.8815@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs15.mail.saunalahti.fi ([195.197.172.101]:35423 "EHLO
	vs15.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab0LTQnr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2010 11:43:47 -0500
Received: from saunalahti-vams (localhost [127.0.0.1])
	by vs15.mail.saunalahti.fi (Postfix) with SMTP id 9E6AF10304D
	for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2010 18:43:45 +0200 (EET)
Received: from gw01.mail.saunalahti.fi (gw01.mail.saunalahti.fi [195.197.172.115])
	by vs15.mail.saunalahti.fi (Postfix) with ESMTP id 91C4610304D
	for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2010 18:43:45 +0200 (EET)
Received: from kai.makisara.local (a91-152-41-146.elisa-laajakaista.fi [91.152.41.146])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by gw01.mail.saunalahti.fi (Postfix) with ESMTP id B34E61515F6
	for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2010 18:43:44 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The order of the pages allocated for the driver buffer must be stored before
allocation because it is used in freeing already allocated pages if 
allocation fails.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
Reported-by: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
---
 linux-2.6.37-rc6-git4-1/drivers/scsi/st.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.37-rc6-git4/drivers/scsi/st.c	2010-12-16 03:24:48.000000000 +0200
+++ linux-2.6.37-rc6-git4-1/drivers/scsi/st.c	2010-12-19 09:42:08.255998445 +0200
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static const char *verstr = "20100829";
+static const char *verstr = "20101219";
 
 #include <linux/module.h>
 
@@ -3732,6 +3732,7 @@ static int enlarge_buffer(struct st_buff
 		     order < ST_MAX_ORDER && b_size < new_size;
 		     order++, b_size *= 2)
 			;  /* empty */
+		STbuffer->reserved_page_order = order;
 	}
 	if (max_segs * (PAGE_SIZE << order) < new_size) {
 		if (order == ST_MAX_ORDER)
@@ -3758,7 +3759,6 @@ static int enlarge_buffer(struct st_buff
 		segs++;
 	}
 	STbuffer->b_data = page_address(STbuffer->reserved_pages[0]);
-	STbuffer->reserved_page_order = order;
 
 	return 1;
 }
