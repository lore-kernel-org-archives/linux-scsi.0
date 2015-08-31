From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 09/14] fix: lpfc_send_rscn_event sends bigger buffer size
Date: Mon, 31 Aug 2015 16:48:16 -0400
Message-ID: <55e4bd90.zlcxDDRSu3edLd6S%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:35104 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbbHaUsd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 16:48:33 -0400
Received: by qkcj187 with SMTP id j187so16804631qkc.2
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2015 13:48:32 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by smtp.gmail.com with ESMTPSA id b82sm9430307qhc.46.2015.08.31.13.48.31
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 31 Aug 2015 13:48:31 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


From: Ales Novak <alnovak@suse.cz>

lpfc_send_rscn_event() allocates data for sizeof(struct
lpfc_rscn_event_header) + payload_len, but claims that the data has size
of sizeof(struct lpfc_els_event_header) + payload_len. That leads to
buffer overruns.

Signed-off-by: Ales Novak <alnovak@suse.cz>
Signed-off-by: James Smart <james.smart@avagotech.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index c859aa3..f9c957d 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5401,7 +5401,7 @@ lpfc_send_rscn_event(struct lpfc_vport *vport,
 
 	fc_host_post_vendor_event(shost,
 		fc_get_event_number(),
-		sizeof(struct lpfc_els_event_header) + payload_len,
+		sizeof(struct lpfc_rscn_event_header) + payload_len,
 		(char *)rscn_event_data,
 		LPFC_NL_VENDOR_ID);
 
-- 
1.7.11.7

