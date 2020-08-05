Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B5BEC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 09:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DE3D22CF7
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 09:46:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="B1yB7RI4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgHEJqs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 05:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727808AbgHEJph (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 05:45:37 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB5BC0617A2
        for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2020 02:45:27 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d22so4053226pfn.5
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2020 02:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gRhgCN7oJwispLAOBWNZIvR9k9He6AcoHnospPRglyo=;
        b=B1yB7RI4hpz8UXSJTNF1naCRYZ21hN2Q/+WPSQGscWfZui9wC7/eELi2n+eTD09pTL
         Uk4LiatAC97zMmGiTsoUGi168DdvGPSIdtcAdXX1f1+7iD3iqKaFwE1rpKXNwkv2LC3K
         GTUNLNcW5EaPbFRj5iLhEptcEZdLQQlbR3Pj8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gRhgCN7oJwispLAOBWNZIvR9k9He6AcoHnospPRglyo=;
        b=P+JB3Wqcg7sLY7heNVjMVHZJt74Pi0YlyUqk8Z9OobUtUI3hYbfiAe5BhVKWhA5a0F
         oaikrCsW9MpXkMnrqixOTPhmuD5ni2letg1jjuTf0/5YJZVNx6pbnSmdoSAb5CqcIcPP
         x1XgOj8iequ8gC21pMvPgnxmYZSR9K1tgHp7v2jiznoaZQEKhLbDJ/ioVf8e8DdjrDX9
         MFZ9zk6YinG4eNNtP2Si017m7XoktNz/amLLpBOfH6wvR5gmkMjvniQdhCuMgruTBsvm
         LEWVzCnhgUBBnuUJnVNJboD/PCccNK3ZwnZYGCwsK92FJeNPwSx5jM4tB5JX15BR7gF8
         aKsA==
X-Gm-Message-State: AOAM532c+zwRd6qz/YF5Dqqa2ZCIHEYjTuPaJ7ucKKqE7rd3L1smcoMn
        VgynCzPiKl2NRzrzXmccxxHr10EeSiTu/oslTv+PC8lvk3+XmO1wzxyUcTzUdDB97yFTQsxVYzT
        SRRIrFoYOqD6KykofbxNKf7nSyCRpl4p70oa9kiLbVWuBmh7SeCqwyY2Sx+CL2/01NcZcQ20VD4
        uclqKaUQ==
X-Google-Smtp-Source: ABdhPJxLOGEmGlQWi0grAn0sJc0i1qICzdsSHDHsSmH3S3aykKZPGZUJ4WUR7C/E76cYVIowmrFsxQ==
X-Received: by 2002:aa7:9e5d:: with SMTP id z29mr2571367pfq.122.1596620726664;
        Wed, 05 Aug 2020 02:45:26 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id e9sm2632346pfh.151.2020.08.05.02.45.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2020 02:45:25 -0700 (PDT)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     hare@suse.de, jsmart2021@gmail.com, emilne@redhat.com,
        mkumar@redhat.com, Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH 5/5] scsi_transport_fc: Added a new sysfs attribute noretries_abort
Date:   Wed,  5 Aug 2020 08:21:02 +0530
Message-Id: <1596595862-11075-6-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596595862-11075-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1596595862-11075-1-git-send-email-muneendra.kumar@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Added a new sysfs attribute noretries_abort under fc_transport/target*/

This interface will set SCMD_NORETRIES_ABORT bit in scmd->state for all
the pending io's on the scsi device associated with target port.

Below is the interface provided to abort the io
echo 1 >> /sys/class/fc_transport/targetX\:Y\:Z/noretries_abort

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
---
 drivers/scsi/scsi_transport_fc.c | 49 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 2732fa6..f7b00ae 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -305,7 +305,7 @@ struct device_attribute device_attr_##_prefix##_##_name = 	\
  * Attribute counts pre object type...
  * Increase these values if you add attributes
  */
-#define FC_STARGET_NUM_ATTRS 	3
+#define FC_STARGET_NUM_ATTRS	4
 #define FC_RPORT_NUM_ATTRS	10
 #define FC_VPORT_NUM_ATTRS	9
 #define FC_HOST_NUM_ATTRS	29
@@ -994,6 +994,44 @@ static FC_DEVICE_ATTR(rport, fast_io_fail_tmo, S_IRUGO | S_IWUSR,
 /*
  * FC SCSI Target Attribute Management
  */
+static void scsi_target_set_noretries_abort(struct scsi_target *starget)
+{
+	struct scsi_device *sdev, *tmp;
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_for_each_entry_safe(sdev, tmp, &starget->devices, same_target_siblings) {
+		if (sdev->sdev_state == SDEV_DEL)
+			continue;
+		if (scsi_device_get(sdev))
+			continue;
+
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		scsi_set_noretries_abort_io_device(sdev);
+		spin_lock_irqsave(shost->host_lock, flags);
+		scsi_device_put(sdev);
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
+/*
+ * Sets  no retries on abort in scmd->state for all
+ * outstanding io of all the scsi_devs
+ * write 1 to set the bit for all outstanding io's
+ */
+static ssize_t fc_target_set_noretries_abort(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct scsi_target *starget = transport_class_to_starget(dev);
+
+	scsi_target_set_noretries_abort(starget);
+	return count;
+}
+
+static FC_DEVICE_ATTR(starget, noretries_abort, 0200,
+		NULL, fc_target_set_noretries_abort);
 
 /*
  * Note: in the target show function we recognize when the remote
@@ -1036,6 +1074,13 @@ static FC_DEVICE_ATTR(starget, field, S_IRUGO,			\
 	if (i->f->show_starget_##field)					\
 		count++
 
+#define SETUP_PRIVATE_STARGET_ATTRIBUTE_RW(field)			\
+do {									\
+	i->private_starget_attrs[count] = device_attr_starget_##field; \
+	i->starget_attrs[count] = &i->private_starget_attrs[count];	\
+	count++;							\
+} while (0)
+
 #define SETUP_STARGET_ATTRIBUTE_RW(field)				\
 	i->private_starget_attrs[count] = device_attr_starget_##field; \
 	if (!i->f->set_starget_##field) {				\
@@ -2197,7 +2242,7 @@ struct scsi_transport_template *
 	SETUP_STARGET_ATTRIBUTE_RD(node_name);
 	SETUP_STARGET_ATTRIBUTE_RD(port_name);
 	SETUP_STARGET_ATTRIBUTE_RD(port_id);
-
+	SETUP_PRIVATE_STARGET_ATTRIBUTE_RW(noretries_abort);
 	BUG_ON(count > FC_STARGET_NUM_ATTRS);
 
 	i->starget_attrs[count] = NULL;
-- 
1.8.3.1

