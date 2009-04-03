From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 15/15] libfc: Remove unused FC_DBG macro
Date: Fri, 03 Apr 2009 14:59:21 -0700
Message-ID: <20090403215920.10856.16142.stgit@fritz>
References: <20090403215758.10856.6946.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:61285 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763289AbZDCV7X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Apr 2009 17:59:23 -0400
In-Reply-To: <20090403215758.10856.6946.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

This patch also removes the final two uses of this macro.
The last two uses are in inline functions and are unnecessary.
If statements are needed to show invalid op codes those
statements can be outside of the inline functions as the
inline's return value is checked.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 include/scsi/fc_encode.h |    2 --
 include/scsi/libfc.h     |   12 ------------
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
index 6300f55..a0ff61c 100644
--- a/include/scsi/fc_encode.h
+++ b/include/scsi/fc_encode.h
@@ -107,7 +107,6 @@ static inline int fc_ct_fill(struct fc_lport *lport, struct fc_frame *fp,
 		break;
 
 	default:
-		FC_DBG("Invalid op code %x \n", op);
 		return -EINVAL;
 	}
 	*r_ctl = FC_RCTL_DD_UNSOL_CTL;
@@ -298,7 +297,6 @@ static inline int fc_els_fill(struct fc_lport *lport, struct fc_rport *rport,
 		break;
 
 	default:
-		FC_DBG("Invalid op code %x \n", op);
 		return -EINVAL;
 	}
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 3afa005..bceb00b 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -34,18 +34,6 @@
 
 #include <scsi/fc_frame.h>
 
-#define LIBFC_DEBUG
-
-#ifdef LIBFC_DEBUG
-/* Log messages */
-#define FC_DBG(fmt, args...)						\
-	do {								\
-		printk(KERN_INFO "%s " fmt, __func__, ##args);		\
-	} while (0)
-#else
-#define FC_DBG(fmt, args...)
-#endif
-
 #define FC_LIBFC_LOGGING 0x01 /* General logging, not categorized */
 #define FC_LPORT_LOGGING 0x02 /* lport layer logging */
 #define FC_DISC_LOGGING  0x04 /* discovery layer logging */

