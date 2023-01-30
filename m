Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1CEDC54EAA
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 20:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjA3Uyq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 15:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbjA3Uyn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 15:54:43 -0500
Received: from msg-4.mailo.com (msg-4.mailo.com [213.182.54.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13FB47094;
        Mon, 30 Jan 2023 12:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailo.com; s=mailo;
        t=1675112039; bh=bfFcOrFbHGSJZOWyBtjJIaGYLkbNQlO/HXEzfdCL/Z8=;
        h=X-EA-Auth:Date:From:To:Cc:Subject:Message-ID:MIME-Version:
         Content-Type;
        b=NPE+T1eMlbAH+D0Jo9yKQXLorxTS033etNTja+viPr4XJKvLancAuQNB25fKYtXlN
         LoembH9yE48g+fixD+TJJNI3A5BB+vMuGEvJhLmR4o0IDfItCe/s1oY+b6R+eCP2wX
         8GfClIxYBCNO7q+AvVdFPT2+zDaGdFQh+I7ZjrYQ=
Received: by b-3.in.mailobj.net [192.168.90.13] with ESMTP
        via ip-206.mailobj.net [213.182.55.206]
        Mon, 30 Jan 2023 21:53:54 +0100 (CET)
X-EA-Auth: 2KrLQiI3TtiSULUBE7lRV/apfvNhZ1NXjTW6KXqza+vYvgiL2sY3VY5lm0Dm88hooY8qgPAL1l/zXkh2EvEmTJCiEIWmAnKx
Date:   Tue, 31 Jan 2023 02:23:48 +0530
From:   Deepak R Varma <drv@mailo.com>
To:     HighPoint Linux Team <linux@highpoint-tech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Saurabh Singh Sengar <ssengar@microsoft.com>,
        Praveen Kumar <kumarpraveen@linux.microsoft.com>,
        Deepak R Varma <drv@mailo.com>
Subject: [PATCH] scsi: hptiop: Use sysfs_emit in show function callback
Message-ID: <Y9guXK+b/5DM+Y8f@ubun2204.myguest.virtualbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

According to Documentation/filesystems/sysfs.rst, show() callback
function should only use sysfs_emit() or sysfs_emit_at() instead
of sprint() family functions when formatting the device attribute
values to be returned to user space.
Issue identified using the device_attr_show.cocci Coccinelle script.

Signed-off-by: Deepak R Varma <drv@mailo.com>
---
 drivers/scsi/hptiop.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 7e8903718245..a92998dd77a6 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1111,7 +1111,7 @@ static int hptiop_adjust_disk_queue_depth(struct scsi_device *sdev,
 static ssize_t hptiop_show_version(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", driver_ver);
+	return sysfs_emit(buf, "%s\n", driver_ver);
 }
 
 static ssize_t hptiop_show_fw_version(struct device *dev,
@@ -1120,11 +1120,11 @@ static ssize_t hptiop_show_fw_version(struct device *dev,
 	struct Scsi_Host *host = class_to_shost(dev);
 	struct hptiop_hba *hba = (struct hptiop_hba *)host->hostdata;
 
-	return snprintf(buf, PAGE_SIZE, "%d.%d.%d.%d\n",
-				hba->firmware_version >> 24,
-				(hba->firmware_version >> 16) & 0xff,
-				(hba->firmware_version >> 8) & 0xff,
-				hba->firmware_version & 0xff);
+	return sysfs_emit(buf, "%d.%d.%d.%d\n",
+			  hba->firmware_version >> 24,
+			  (hba->firmware_version >> 16) & 0xff,
+			  (hba->firmware_version >> 8) & 0xff,
+			  hba->firmware_version & 0xff);
 }
 
 static struct device_attribute hptiop_attr_version = {
-- 
2.34.1



