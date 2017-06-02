From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 09/17] lpfc: Fix return value of board_mode store routine in case of online failure
Date: Thu,  1 Jun 2017 21:07:03 -0700
Message-ID: <20170602040711.21046-10-jsmart2021@gmail.com>
References: <20170602040711.21046-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33313 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751153AbdFBEHv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 00:07:51 -0400
Received: by mail-qk0-f196.google.com with SMTP id c206so8289421qkb.0
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jun 2017 21:07:51 -0700 (PDT)
In-Reply-To: <20170602040711.21046-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On hbacmd reset failure, observing wrong string "nline" in
kernel log.

On failure, non negative value (1) is returned from sysfs store
routine. It is interpreted as count by kernel and store routine
is called again with the remaining characters as input.

Fix: Return negative error code (-EIO) in case of failure.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index eb33473cbc62..8eee39de15f7 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1351,6 +1351,8 @@ lpfc_board_mode_store(struct device *dev, struct device_attribute *attr,
 			goto board_mode_out;
 		}
 		wait_for_completion(&online_compl);
+		if (status)
+			status = -EIO;
 	} else if (strncmp(buf, "offline", sizeof("offline") - 1) == 0)
 		status = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
 	else if (strncmp(buf, "warm", sizeof("warm") - 1) == 0)
-- 
2.11.0
