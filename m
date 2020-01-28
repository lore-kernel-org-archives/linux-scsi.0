Return-Path: <SRS0=0wOg=3R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F31FC32771
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64DA522527
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CIG7QHV9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgA1AXp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jan 2020 19:23:45 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33600 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgA1AXo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jan 2020 19:23:44 -0500
Received: by mail-wm1-f65.google.com with SMTP id m10so590896wmc.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2020 16:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Hvp5VjDvnqbZv6jI96DotywfNWxeovCkVGmlBUZyW6Q=;
        b=CIG7QHV9EpaZ1t38AhSVVL3qFMMn5+WQXdiybt74LCex9MTofHx1LQJfRvkysPLZ8e
         R03nOGLkrAtwJ96mguQB1M+REY1jK9GqZJlv1CkfUsp+j/WTjg7jU+fGaIb4lqL4ciKR
         5XS2+O53pDC7J8STw7URQHjmbTerrauB8wOdnBTXNNC6V8l+eynloEGMSJrHXCDSZJbh
         Ddu+S4QWWAmIqMfhmgKxJ0MfdFuPb8bZSVwPUVWl7wesIbqUQMyAd7IOM8wZp460pUNJ
         wmxHIvdFMMYcT6LOv89zko4mrHG5CZCKpK+Uq1+GIm7hJAt3NlWx9BRuPX7Ho8gKryh5
         AQzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Hvp5VjDvnqbZv6jI96DotywfNWxeovCkVGmlBUZyW6Q=;
        b=S8VvLHaskSQYcF0NXGTsvyJAgtLlL7ZZ8m4rYQ9HbIrImd6z9ltOGzNOqj/8EfkOTU
         37WpzqLsV0uk7SXIkPRaoSIAVUoqdfUL8fvve1y01gs6FTRyqLmsRbqYR7RGy35ZPmTL
         ORfhmYz5atmnyg+gRnnDQWZWfSQIpjuL3hnsFoKDXx7OYKTFzri0GHxPROerBuoted/j
         9lifTVtACPgUXV2sgNS4zMef2Lkyqn4eYdDVAfAN6dW+pTB0qgz1Tau0n56lcvy5Q3yR
         kLrlGEU8OX07XLGJBDHOxQmxFeftIfuFDhqN00qfKQjzilyUypfDHybBJAQZaPi5xnST
         ZHTw==
X-Gm-Message-State: APjAAAVZul/r3AQ4oJ3S+HWaJpYde21IzhUfq4IRnolubQ0wv8We9NNz
        0N9L1prShvTnM9kwdWOYYGcGk8GY
X-Google-Smtp-Source: APXvYqxbPsJ0150z6Aex0bXxI/2luVFbj0OI8bEPvaRYqIHlsUb0KVRsq9uJLKYoM8mnucvtoBfZqQ==
X-Received: by 2002:a05:600c:218a:: with SMTP id e10mr1260571wme.6.1580171021806;
        Mon, 27 Jan 2020 16:23:41 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z19sm583769wmi.43.2020.01.27.16.23.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 16:23:41 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 10/12] lpfc: Change lpfc_lun_queue_depth attribute to writable
Date:   Mon, 27 Jan 2020 16:23:10 -0800
Message-Id: <20200128002312.16346-11-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200128002312.16346-1-jsmart2021@gmail.com>
References: <20200128002312.16346-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change the lpfc_lun_queue_depth attribute to be writable. When written,
will change the driver's value and calls the new scsi service routine
shost_change_max_queue_depths() to set the maximum and queue depth of
the luns on the shost to the new value.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
This patch is dependent upon this series, which adds the new
scsi service routine shost_change_max_queue_depths():
https://www.spinics.net/lists/linux-scsi/msg137981.html
---
 drivers/scsi/lpfc/lpfc.h      |  3 +++
 drivers/scsi/lpfc/lpfc_attr.c | 59 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index cebbad1b3e55..d26ae94e6f1e 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -69,6 +69,9 @@ struct lpfc_sli2_slim;
 #define LPFC_TGTQ_RAMPUP_PCENT	5	/* Target queue rampup in percentage */
 #define LPFC_MIN_TGT_QDEPTH	10
 #define LPFC_MAX_TGT_QDEPTH	0xFFFF
+#define LPFC_MIN_LUN_QDEPTH	1
+#define LPFC_DEF_LUN_QDEPTH	30
+#define LPFC_MAX_LUN_QDEPTH	512
 
 #define  LPFC_MAX_BUCKET_COUNT 20	/* Maximum no. of buckets for stat data
 					   collection. */
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 48b6c98ec922..127484061f18 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3870,8 +3870,63 @@ LPFC_VPORT_ATTR_R(enable_da_id, 1, 0, 1,
 # lun_queue_depth:  This parameter is used to limit the number of outstanding
 # commands per FCP LUN. Value range is [1,512]. Default value is 30.
 */
-LPFC_VPORT_ATTR_R(lun_queue_depth, 30, 1, 512,
-		  "Max number of FCP commands we can queue to a specific LUN");
+static u16 lpfc_lun_queue_depth = LPFC_DEF_LUN_QDEPTH;
+module_param(lpfc_lun_queue_depth, ushort, 0644);
+MODULE_PARM_DESC(lpfc_lun_queue_depth,
+		 "Max number of FCP commands we can queue to a specific LUN");
+lpfc_vport_param_show(lun_queue_depth);
+lpfc_vport_param_init(lun_queue_depth, LPFC_DEF_LUN_QDEPTH, LPFC_MIN_LUN_QDEPTH,
+		      LPFC_MAX_LUN_QDEPTH);
+
+static ssize_t
+lpfc_lun_queue_depth_store(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+	u16 new_queue_depth;
+	int rc;
+
+	rc = kstrtou16(buf, 0, &new_queue_depth);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"4385 lpfc_lun_queue_depth: failed to convert "
+				"\"%s\" to u16 (%d)\n",
+				buf, rc);
+		return -EINVAL;
+	}
+
+	/* Check allowed range */
+	if (new_queue_depth < LPFC_MIN_LUN_QDEPTH ||
+	    new_queue_depth > LPFC_MAX_LUN_QDEPTH) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"4386 lpfc_lun_queue_depth: %d outside of "
+				"allowed range [%u, %u]\n",
+				new_queue_depth, LPFC_MIN_LUN_QDEPTH,
+				LPFC_MAX_LUN_QDEPTH);
+		return -EINVAL;
+	}
+
+	/* Check if previously set same value */
+	if (new_queue_depth == vport->cfg_lun_queue_depth)
+		goto buffer_done;
+
+	/* Store for future calls to slave_configure */
+	vport->cfg_lun_queue_depth = new_queue_depth;
+
+	/* Change all the current LUNs' queue depths */
+	rc = shost_change_max_queue_depths(shost, new_queue_depth);
+	if (rc)
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"4387 lpfc_lun_queue_depth: error setting lun "
+				"max queue depths (%d)\n",
+				rc);
+
+buffer_done:
+	return strlen(buf);
+}
+static DEVICE_ATTR_RW(lpfc_lun_queue_depth);
 
 /*
 # tgt_queue_depth:  This parameter is used to limit the number of outstanding
-- 
2.13.7

