From: Martin Michlmayr <tbm@cyrius.com>
Subject: [PATCH 12/12] [SCSI] mem_start is a physical address already
Date: Mon, 20 Mar 2006 04:41:27 +0000
Message-ID: <20060320044127.GL20416@deprecation.cyrius.com>
References: <20060320043802.GA20389@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:64527 "EHLO
	sorrow.cyrius.com") by vger.kernel.org with ESMTP id S1751488AbWCTEln
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Mar 2006 23:41:43 -0500
Content-Disposition: inline
In-Reply-To: <20060320043802.GA20389@deprecation.cyrius.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-scsi@vger.kernel.org

mem_start is a physical address already so there's no need to call
CPHYSADDR().  This brings the file in sync with the linux-mips tree.

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
Acked-by: Maciej W. Rozycki <macro@linux-mips.org>


--- linux-2.6/drivers/scsi/dec_esp.c	2006-03-05 19:35:05.000000000 +0000
+++ mips.git/drivers/scsi/dec_esp.c	2006-03-05 18:51:16.000000000 +0000
@@ -230,7 +230,7 @@
 			mem_start = get_tc_base_addr(slot);
 
 			/* Store base addr into esp struct */
-			esp->slot = CPHYSADDR(mem_start);
+			esp->slot = mem_start;
 
 			esp->dregs = 0;
 			esp->eregs = (void *)CKSEG1ADDR(mem_start +

-- 
Martin Michlmayr
http://www.cyrius.com/
