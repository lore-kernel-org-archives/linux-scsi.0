From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH v3 08/18] scsi: hpsa: Eliminate duplicate barriers on weakly-ordered archs
Date: Fri, 16 Mar 2018 12:16:21 -0400
Message-ID: <1521216991-28706-9-git-send-email-okaya@codeaurora.org>
References: <1521216991-28706-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521216991-28706-1-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: netdev@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Code includes wmb() followed by writel(). writel() already has a
barrier on some architectures like arm64.

This ends up CPU observing two barriers back to back before executing
the register write.

Since code already has an explicit barrier call, changing writel() to
writel_relaxed().

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/scsi/hpsa.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 018f980..c7d7e6a 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -599,7 +599,7 @@ static unsigned long SA5_ioaccel_mode1_completed(struct ctlr_info *h, u8 q)
 		 * but with current driver design this is easiest.
 		 */
 		wmb();
-		writel((q << 24) | rq->current_entry, h->vaddr +
+		writel_relaxed((q << 24) | rq->current_entry, h->vaddr +
 				IOACCEL_MODE1_CONSUMER_INDEX);
 		atomic_dec(&h->commands_outstanding);
 	}
-- 
2.7.4
