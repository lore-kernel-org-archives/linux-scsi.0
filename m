From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 5/7] scsi: storvsc: Fix a bug in copy_from_bounce_buffer()
Date: Mon, 23 Mar 2015 14:06:39 -0700
Message-ID: <1427144801-11920-5-git-send-email-kys@microsoft.com>
References: <1427144760-11875-1-git-send-email-kys@microsoft.com>
 <1427144801-11920-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:54008
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbbCWTuA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Mar 2015 15:50:00 -0400
In-Reply-To: <1427144801-11920-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, stable@vger.kernel.org

We may exit this function without properly freeing up the maapings
we may have acquired. Fix the bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 5c13eec..88f5d79 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -754,21 +754,22 @@ static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
 			if (bounce_sgl[j].length == PAGE_SIZE) {
 				/* full..move to next entry */
 				sg_kunmap_atomic(bounce_addr);
+				bounce_addr = 0;
 				j++;
+			}
 
-				/* if we need to use another bounce buffer */
-				if (srclen || i != orig_sgl_count - 1)
-					bounce_addr = sg_kmap_atomic(bounce_sgl,j);
+			/* if we need to use another bounce buffer */
+			if (srclen && bounce_addr == 0)
+				bounce_addr = sg_kmap_atomic(bounce_sgl, j);
 
-			} else if (srclen == 0 && i == orig_sgl_count - 1) {
-				/* unmap the last bounce that is < PAGE_SIZE */
-				sg_kunmap_atomic(bounce_addr);
-			}
 		}
 
 		sg_kunmap_atomic(src_addr - orig_sgl[i].offset);
 	}
 
+	if (bounce_addr)
+		sg_kunmap_atomic(bounce_addr);
+
 	local_irq_restore(flags);
 
 	return total_copied;
-- 
1.7.4.1

