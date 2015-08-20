From: Ales Novak <alnovak@suse.cz>
Subject: [PATCH] fix: lpfc_send_rscn_event sends bigger buffer size
Date: Thu, 20 Aug 2015 13:35:45 +0200
Message-ID: <1440070545-15037-1-git-send-email-alnovak@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ales Novak <alnovak@suse.cz>
List-Id: linux-scsi@vger.kernel.org

lpfc_send_rscn_event() allocates data for sizeof(struct
lpfc_rscn_event_header) + payload_len, but claims that the data has size
of sizeof(struct lpfc_els_event_header) + payload_len. That leads to
buffer overruns.

Signed-off-by: Ales Novak <alnovak@suse.cz>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 36bf58b..136928e 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5444,7 +5444,7 @@ lpfc_send_rscn_event(struct lpfc_vport *vport,
 
 	fc_host_post_vendor_event(shost,
 		fc_get_event_number(),
-		sizeof(struct lpfc_els_event_header) + payload_len,
+		sizeof(struct lpfc_rscn_event_header) + payload_len,
 		(char *)rscn_event_data,
 		LPFC_NL_VENDOR_ID);
 
-- 
2.4.1.168.g1ea28e1
