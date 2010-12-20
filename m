From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 2/2] SCSI tape: Increase success probability in driver buffer
 allocation
Date: Mon, 20 Dec 2010 18:44:45 +0200 (EET)
Message-ID: <alpine.LNX.2.00.1012201843560.8815@kai.makisara.local>
References: <alpine.LNX.2.00.1012201841230.8815@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs15.mail.saunalahti.fi ([195.197.172.101]:35471 "EHLO
	vs15.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab0LTQor (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2010 11:44:47 -0500
Received: from saunalahti-vams (localhost [127.0.0.1])
	by vs15.mail.saunalahti.fi (Postfix) with SMTP id B6B0F10304D
	for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2010 18:44:46 +0200 (EET)
Received: from gw03.mail.saunalahti.fi (gw03.mail.saunalahti.fi [195.197.172.111])
	by vs15.mail.saunalahti.fi (Postfix) with ESMTP id AA8FE10304D
	for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2010 18:44:46 +0200 (EET)
Received: from kai.makisara.local (a91-152-41-146.elisa-laajakaista.fi [91.152.41.146])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by gw03.mail.saunalahti.fi (Postfix) with ESMTP id A1A822168D0
	for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2010 18:44:45 +0200 (EET)
In-Reply-To: <alpine.LNX.2.00.1012201841230.8815@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Modify allocation to try the minimum possible page order allowed by the HBA
scatter/gather segment limit in allocation of the driver's internal
buffer. This increases the probability of successful allocation. The
allocation may still fail if this minimum order is > 0.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
Reported-by: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>
---
 linux-2.6.37-rc6-git4-2/drivers/scsi/st.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.37-rc6-git4-1/drivers/scsi/st.c	2010-12-19 09:42:08.255998445 +0200
+++ linux-2.6.37-rc6-git4-2/drivers/scsi/st.c	2010-12-19 09:44:36.483997640 +0200
@@ -3729,7 +3729,8 @@ static int enlarge_buffer(struct st_buff
 		b_size = PAGE_SIZE << order;
 	} else {
 		for (b_size = PAGE_SIZE, order = 0;
-		     order < ST_MAX_ORDER && b_size < new_size;
+		     order < ST_MAX_ORDER &&
+			     max_segs * (PAGE_SIZE << order) < new_size;
 		     order++, b_size *= 2)
 			;  /* empty */
 		STbuffer->reserved_page_order = order;
