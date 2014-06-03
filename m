From: Daniel Walter <dwalter@google.com>
Subject: [PATCH v2 09/11] [drivers/scsi] replace strict_strto calls
Date: Tue, 3 Jun 2014 16:35:10 +0100
Message-ID: <20140603153510.GA21900@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:62756 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345AbaFCPfP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2014 11:35:15 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so6264642wib.0
        for <linux-scsi@vger.kernel.org>; Tue, 03 Jun 2014 08:35:13 -0700 (PDT)
Received: from google.com ([2620:0:1040:202:2e44:fdff:fe1c:7ea6])
        by mx.google.com with ESMTPSA id di10sm44796488wjb.1.2014.06.03.08.35.12
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Tue, 03 Jun 2014 08:35:12 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Daniel Walter <dwalter@google.com>
Subject: [PATCH v2 09/11] [drivers/scsi] replace strict_strto calls

Replace obsolete strict_strto with more appropriate kstrto calls

Signed-off-by: Daniel Walter <dwalter@google.com>
---
Resubmit to the mailing list (was submitted to MAINTAINER entry anil_ravindranath@pmc-sierra.com
but it seems this email no longer exists).

---
 drivers/scsi/pmcraid.c    | 4 ++--
 drivers/scsi/scsi_sysfs.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index be8ce54..3762488 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4213,9 +4213,9 @@ static ssize_t pmcraid_store_log_level(
 {
 	struct Scsi_Host *shost;
 	struct pmcraid_instance *pinstance;
-	unsigned long val;
+	u8 val;
 
-	if (strict_strtoul(buf, 10, &val))
+	if (kstrtou8(buf, 10, &val))
 		return -EINVAL;
 	/* log-level should be from 0 to 2 */
 	if (val > 2)
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 074e8cc..80f715d 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -885,9 +885,9 @@ sdev_store_queue_ramp_up_period(struct device *dev,
 				const char *buf, size_t count)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	unsigned long period;
+	unsigned int period;
 
-	if (strict_strtoul(buf, 10, &period))
+	if (kstrtouint(buf, 10, &period))
 		return -EINVAL;
 
 	sdev->queue_ramp_up_period = msecs_to_jiffies(period);
-- 
1.9.3

