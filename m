From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [patch 08/30] drivers/scsi/megaraid.c: Replacing yield() with a better alternative
Date: Mon, 7 May 2007 13:40:32 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229A8631C@NAMAIL2.ad.lsil.com>
References: <200704260735.l3Q7ZDV9024229@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35852 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966299AbXEGTlB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 15:41:01 -0400
Content-class: urn:content-classes:message
In-Reply-To: <200704260735.l3Q7ZDV9024229@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, amol@verismonetworks.com

Ack.

Thanks.

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of
akpm@linux-foundation.org
Sent: Thursday, April 26, 2007 12:35 AM
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org; akpm@linux-foundation.org;
amol@verismonetworks.com
Subject: [patch 08/30] drivers/scsi/megaraid.c: Replacing yield() with a
better alternative

From: Amol Lad <amol@verismonetworks.com>

For this driver cond_resched() seems to be a better alternative

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN
drivers/scsi/megaraid.c~drivers-scsi-megaraidc-replacing-yield-with-a
drivers/scsi/megaraid.c
---
a/drivers/scsi/megaraid.c~drivers-scsi-megaraidc-replacing-yield-with-a
+++ a/drivers/scsi/megaraid.c
@@ -1754,7 +1754,8 @@ __mega_busywait_mbox (adapter_t *adapter
 	for (counter = 0; counter < 10000; counter++) {
 		if (!mbox->m_in.busy)
 			return 0;
-		udelay(100); yield();
+		udelay(100);
+		cond_resched();
 	}
 	return -1;		/* give up after 1 second */
 }
_
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
