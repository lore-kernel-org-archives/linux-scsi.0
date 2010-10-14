From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] fix id computation in scsi_eh_target_reset()
Date: Thu, 14 Oct 2010 22:04:25 +0800
Message-ID: <AANLkTin-Tkj3Ab312usO2FWE57m3St2iG2oz881F-Zhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57959 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab0JNOE2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Oct 2010 10:04:28 -0400
Received: by wyb28 with SMTP id 28so2139658wyb.19
        for <linux-scsi@vger.kernel.org>; Thu, 14 Oct 2010 07:04:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

There seems that the id of the tgtr_scmd processed by
scsi_try_target_reset() does not match the id in case that
SUCCESS is returned by scsi_try_target_reset().

The mismatch is fixed, and the loop to find the next highest
is also simplified.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/scsi_error.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/scsi_error.c	2010-10-14 21:45:56.000000000 +0800
@@ -1173,14 +1173,19 @@ static int scsi_eh_target_reset(struct S
 			list_for_each_entry(scmd, work_q, eh_entry) {
 				if (scmd_id(scmd) > id &&
 				    (!tgtr_scmd ||
-				     scmd_id(tgtr_scmd) > scmd_id(scmd)))
+				     scmd_id(tgtr_scmd) > scmd_id(scmd))) {
 						tgtr_scmd = scmd;
+						if (1 + id == scmd_id(scmd))
+							break;
+				}
 			}
 		}
 		if (!tgtr_scmd)
 			/* no more commands, that's it */
 			break;

+		id = scmd_id(tgtr_scmd);
+
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending target reset "
 						  "to target %d\n",
 						  current->comm, id));
