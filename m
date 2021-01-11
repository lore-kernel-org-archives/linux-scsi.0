Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D18BC43331
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 15:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D21822A83
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 15:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730649AbhAKPWR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 10:22:17 -0500
Received: from comms.puri.sm ([159.203.221.185]:56914 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732692AbhAKPWL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 10:22:11 -0500
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id D6E47DF76B;
        Mon, 11 Jan 2021 07:21:00 -0800 (PST)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PZI06H7Wq84z; Mon, 11 Jan 2021 07:21:00 -0800 (PST)
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        stern@rowland.harvard.edu, bvanassche@acm.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: [PATCH 2/3] scsi: add expect_media_change_suspend sysfs device setting
Date:   Mon, 11 Jan 2021 16:20:28 +0100
Message-Id: <20210111152029.28426-3-martin.kepplinger@puri.sm>
In-Reply-To: <20210111152029.28426-1-martin.kepplinger@puri.sm>
References: <20210111152029.28426-1-martin.kepplinger@puri.sm>
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a user-facing flag that sets expecting_media_change on runtime
resume. That works around devices that send MEDIA_CHANGED when it
actually is just resumed from suspend and the media can be expected
not to have changed.

Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
---
 drivers/scsi/scsi_sysfs.c  | 38 ++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  2 ++
 2 files changed, 40 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b6378c8ca783..a049290addff 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1189,6 +1189,43 @@ static DEVICE_ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,
 		   sdev_show_queue_ramp_up_period,
 		   sdev_store_queue_ramp_up_period);
 
+static ssize_t
+sdev_show_expect_media_change_suspend(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev;
+	sdev = to_scsi_device(dev);
+
+	if (sdev->expect_media_change_suspend)
+		return sprintf(buf, "1\n");
+	else
+		return sprintf(buf, "0\n");
+}
+
+static ssize_t
+sdev_store_expect_media_change_suspend(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
+{
+	struct scsi_device *sdev;
+	unsigned int flag;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	sdev = to_scsi_device(dev);
+	err = kstrtouint(buf, 10, &flag);
+	if (err)
+		return err;
+	sdev->expect_media_change_suspend = !!flag;
+
+	return count;
+}
+static DEVICE_ATTR(expect_media_change_suspend, S_IRUGO | S_IWUSR,
+		   sdev_show_expect_media_change_suspend,
+		   sdev_store_expect_media_change_suspend);
+
 static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
 					 struct attribute *attr, int i)
 {
@@ -1260,6 +1297,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_queue_type.attr,
 	&dev_attr_wwid.attr,
 	&dev_attr_blacklist.attr,
+	&dev_attr_expect_media_change_suspend.attr,
 #ifdef CONFIG_SCSI_DH
 	&dev_attr_dh_state.attr,
 	&dev_attr_access_state.attr,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index ca2c3eb5830f..fafb8e6ea4d0 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -171,6 +171,8 @@ struct scsi_device {
 	unsigned expecting_cc_ua:1; /* Expecting a CHECK_CONDITION/UNIT_ATTN
 				     * because we did a bus reset. */
 	unsigned expecting_media_change:1; /* Expecting "media changed" UA */
+	unsigned expect_media_change_suspend:1; /* User facing flag to enable
+						 * the above flag on runtime resume */
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
 	unsigned set_dbd_for_ms:1; /* Set "DBD" field in mode sense */
-- 
2.20.1

