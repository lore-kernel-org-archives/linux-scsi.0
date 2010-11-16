From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] fix device_handler_match in SCSI device handler
Date: Tue, 16 Nov 2010 21:10:44 +0800
Message-ID: <AANLkTikUZsQbpne6Ott+QFNrM-HGt2=z-7c8u+j9BRPE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56012 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab0KPNKq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2010 08:10:46 -0500
Received: by wyb28 with SMTP id 28so681381wyb.19
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2010 05:10:45 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The scanning of scsi_dh_list for handler could stop when the first
handler is found, since the second, if exist, could not be better.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/device_handler/scsi_dh.c	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/scsi/device_handler/scsi_dh.c	2010-11-16 20:52:24.000000000 +0800
@@ -116,8 +116,10 @@ device_handler_match(struct scsi_device_

 		spin_lock(&list_lock);
 		list_for_each_entry(tmp_dh, &scsi_dh_list, list) {
-			if (scsi_dh_handler_lookup(tmp_dh, sdev))
+			if (scsi_dh_handler_lookup(tmp_dh, sdev)) {
 				found_dh = tmp_dh;
+				break;
+			}
 		}
 		spin_unlock(&list_lock);
 	}
