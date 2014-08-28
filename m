From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 18/22] scsi_error: format abort error message
Date: Thu, 28 Aug 2014 19:33:32 +0200
Message-ID: <1409247216-76074-19-git-send-email-hare@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbaH1Rdn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:43 -0400
In-Reply-To: <1409247216-76074-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>

Suggested-by: Robert Elliot <elliot@hp.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 16 ++++++++++++----
 include/scsi/scsi_dbg.h   |  1 +
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 6c99624..07887b1 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -155,10 +155,18 @@ scmd_eh_abort_handler(struct work_struct *work)
 				return;
 			}
 		} else {
-			SCSI_LOG_ERROR_RECOVERY(3,
-				scmd_printk(KERN_INFO, scmd,
-					    "scmd %p abort failed, rtn %d\n",
-					    scmd, rtn));
+			const char *rtn_str = scsi_disposition_string(rtn);
+			if (rtn_str) {
+				SCSI_LOG_ERROR_RECOVERY(3,
+					scmd_printk(KERN_INFO, scmd,
+						    "scmd %p abort failed,"
+						    " %s\n", scmd, rtn_str));
+			} else {
+				SCSI_LOG_ERROR_RECOVERY(3,
+					scmd_printk(KERN_INFO, scmd,
+						    "scmd %p abort failed,"
+						    " 0x%x\n", scmd, rtn));
+			}
 		}
 	}
 
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index fa04587..d60e7d8 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -25,5 +25,6 @@ extern const char *scsi_print_status(unsigned char);
 extern const char *scsi_sense_key_string(unsigned char);
 extern const char *scsi_extd_sense_format(unsigned char, unsigned char,
 					  const char **);
+extern const char *scsi_disposition_string(unsigned int);
 
 #endif /* _SCSI_SCSI_DBG_H */
-- 
1.8.5.2

