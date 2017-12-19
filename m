From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH] lpfc: correct sg_seg_cnt attribute min vs default
Date: Tue, 19 Dec 2017 10:57:50 -0800
Message-ID: <20171219185750.24348-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:46611 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbdLSS57 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Dec 2017 13:57:59 -0500
Received: by mail-qk0-f196.google.com with SMTP id c85so9668870qkh.13
        for <linux-scsi@vger.kernel.org>; Tue, 19 Dec 2017 10:57:58 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, James Smart <james.smart@broadcom.com>

Prior patch mixed up what argument in the macro was what, so min
value was placed as the "default" argument, and the default value
was placed as the "min" argument. Thus, when the default was applied,
it looked like the default was smaller than the allowed min.

swap argument postions to correct.

Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 797bb42a6306..8938c867ed2c 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5174,7 +5174,7 @@ LPFC_ATTR(delay_discovery, 0, 0, 1,
  * this parameter will be limited to 128 if BlockGuard is enabled under SLI4
  * and will be limited to 512 if BlockGuard is enabled under SLI3.
  */
-LPFC_ATTR_R(sg_seg_cnt, LPFC_MIN_SG_SEG_CNT, LPFC_DEFAULT_SG_SEG_CNT,
+LPFC_ATTR_R(sg_seg_cnt, LPFC_DEFAULT_SG_SEG_CNT, LPFC_MIN_SG_SEG_CNT, 
 	    LPFC_MAX_SG_SEG_CNT, "Max Scatter Gather Segment Count");
 
 /*
-- 
2.13.1
