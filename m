From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH] [SCSI] scsi_error: really disable eh_deadline if no host_reset_handler is set
Date: Fri, 14 Mar 2014 13:09:01 -0400
Message-ID: <1394816941-7368-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809AbaCNRJD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Mar 2014 13:09:03 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2EH92g9022660
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 14 Mar 2014 13:09:02 -0400
Received: from emilne.csb ([10.18.25.104])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s2EH922s008146
	for <linux-scsi@vger.kernel.org>; Fri, 14 Mar 2014 13:09:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

Commit 0d860641db6d49655b91cd08c8db5af74f88bcb5
("disable eh_deadline if no host_reset_handler is set")
did not prevent eh_deadline from being set via sysfs if
shost->transportt was NULL.  That logic is incorrect.

The logic should prevent setting eh_deadline if:

  - A transport-specific eh_strategy_handler is provided
 
    or

  - The host driver has no eh_reset_handler

...because the eh_deadline value won't be used if a
different EH strategy is provided, and won't work properly
if the host can't be reset when the deadline expires.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_sysfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 8dab6dd..facafc1 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -300,9 +300,9 @@ store_shost_eh_deadline(struct device *dev, struct device_attribute *attr,
 	int ret = -EINVAL;
 	unsigned long deadline, flags;
 
-	if (shost->transportt &&
-	    (shost->transportt->eh_strategy_handler ||
-	     !shost->hostt->eh_host_reset_handler))
+	if ((shost->transportt &&
+	     shost->transportt->eh_strategy_handler) ||
+	     !shost->hostt->eh_host_reset_handler)
 		return ret;
 
 	if (!strncmp(buf, "off", strlen("off")))
-- 
1.7.11.7

