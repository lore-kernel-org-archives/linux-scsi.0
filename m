From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Subject: [PATCH] Remove printk, which triggers because of low scsi clock on SNI RMs
Date: Wed, 11 Jul 2007 19:08:31 +0200
Message-ID: <20070711170829.GA19910@alpha.franken.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elvis.franken.de ([193.175.24.41]:42698 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756262AbXGKSvG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jul 2007 14:51:06 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

remove printk, which triggers because of low scsi clock on SNI RMs

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index cb02656..b5ee4b3 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -267,8 +267,6 @@ NCR_700_offset_period_to_sxfer(struct NCR_700_Host_Parameters *hostdata,
 		offset = max_offset;
 	}
 	if(XFERP < min_xferp) {
-		printk(KERN_WARNING "53c700: XFERP %d is less than minium, setting to %d\n",
-		       XFERP,  min_xferp);
 		XFERP =  min_xferp;
 	}
 	return (offset & 0x0f) | (XFERP & 0x07)<<4;



-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
