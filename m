From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 05/17] lpfc: Fix driver crash when module parameter
 lpfc_fcp_io_channel set to 16
Date: Wed, 16 Dec 2015 18:11:56 -0500
Message-ID: <5671efbc.dvhEy//FvbpoWxN6%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:33350 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbbLPXMP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2015 18:12:15 -0500
Received: by mail-pf0-f170.google.com with SMTP id n128so853190pfn.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2015 15:12:15 -0800 (PST)
Received: from myfc17 (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id w27sm7009140pfi.36.2015.12.16.15.12.13
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 16 Dec 2015 15:12:13 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix driver crash when module parameter lpfc_fcp_io_channel set to 16

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ab27d81..bd6aa8d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8833,9 +8833,12 @@ found:
 				 * already mapped to this phys_id.
 				 */
 				if (cpup->irq != LPFC_VECTOR_MAP_EMPTY) {
-					chann[saved_chann] =
-						cpup->channel_id;
-					saved_chann++;
+					if (saved_chann <=
+					    LPFC_FCP_IO_CHAN_MAX) {
+						chann[saved_chann] =
+							cpup->channel_id;
+						saved_chann++;
+					}
 					goto out;
 				}
 
-- 
1.7.11.7

