From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH 2/4] scsi_debug: Added taking of sdebug_host_list_lock when changing capacity
Date: Thu,  4 Dec 2014 11:49:26 -0500
Message-ID: <1417711768-24167-3-git-send-email-emilne@redhat.com>
References: <1417711768-24167-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422AbaLDQtd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 11:49:33 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sB4GnVZH003354
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2014 11:49:32 -0500
Received: from emilne.csb ([10.18.25.104])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id sB4GnUgE011313
	for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2014 11:49:31 -0500
In-Reply-To: <1417711768-24167-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

All other traversals of the sdebug_host_list take the lock.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 397cc10..1a11466 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4439,6 +4439,7 @@ static ssize_t virtual_gb_store(struct device_driver *ddp, const char *buf,
 			struct sdebug_host_info *sdhp;
 			struct sdebug_dev_info *dp;
 
+			spin_lock(&sdebug_host_list_lock);
 			list_for_each_entry(sdhp, &sdebug_host_list,
 					    host_list) {
 				list_for_each_entry(dp, &sdhp->dev_info_list,
@@ -4447,6 +4448,7 @@ static ssize_t virtual_gb_store(struct device_driver *ddp, const char *buf,
 						dp->uas_bm);
 				}
 			}
+			spin_unlock(&sdebug_host_list_lock);
 		}
 		return count;
 	}
-- 
1.7.11.7

