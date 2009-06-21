From: Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] fusion: mptsas, fix lock imbalance
Date: Sun, 21 Jun 2009 23:59:01 +0200
Message-ID: <1245621541-27008-1-git-send-email-jirislaby@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.wellnetcz.com ([212.24.148.102]:57947 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbZFUV7G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Jun 2009 17:59:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, support@lsi.com, linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>

Fix two typos in mptsas_not_responding_devices. It was mutex_lock instead
of unlock.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/message/fusion/mptsas.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 20e0b44..55ff252 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -3518,7 +3518,7 @@ retry_page:
 		} else
 			mptsas_volume_delete(ioc, sas_info->fw.id);
 	}
-	mutex_lock(&ioc->sas_device_info_mutex);
+	mutex_unlock(&ioc->sas_device_info_mutex);
 
 	/* expanders */
 	mutex_lock(&ioc->sas_topology_mutex);
@@ -3549,7 +3549,7 @@ retry_page:
 			goto redo_expander_scan;
 		}
 	}
-	mutex_lock(&ioc->sas_topology_mutex);
+	mutex_unlock(&ioc->sas_topology_mutex);
 }
 
 /**
-- 
1.6.3.2

