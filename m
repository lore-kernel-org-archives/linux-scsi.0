Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 692C6C433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 19:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4689A619F8
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 19:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238112AbhCXT70 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 15:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238077AbhCXT64 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 15:58:56 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF4EC061763;
        Wed, 24 Mar 2021 12:58:55 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u21so16943701ejo.13;
        Wed, 24 Mar 2021 12:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f0HN6f20JYEnsxdYiG0sLMKPBzzq2rScWT3Gg1X4PTQ=;
        b=lKopZskU+8/OpXTy0vcJBXR521kSgefekJwZaXgG3EhLq+IQKqASti/iM8jwIhSyKb
         j9mIeMb/fIRf8/EW5YHS+YT6+SOJgWqDtQg4UNY8syHrtsluI3oqFaL4DQmR6T9nKQAw
         aUuCGChaOsFxXTJ4B8KOzfYGt+KC3cwgZym7b2nkNL8XJgx8bqx2xvuIicOSJKi7Zvvs
         hbs4yPhoEA/ctIM9W7BeP4hHY4RSTQpgxO0N4T+DphMrJLX+eKCZmUkRjHo9f33DyrXL
         T8EJGbM4S+R3VYOV8JRLh2smCM96INART9i6eWXRu8ABNqH7F1NXi5HhYuswPCxJPWYN
         p2xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=f0HN6f20JYEnsxdYiG0sLMKPBzzq2rScWT3Gg1X4PTQ=;
        b=uNRgOPwHFnbviD8q7PRSwP570UUdvP4N8X4ImIDJDNMQHj6F8ES4h/jkju7lELZYXg
         K5r+N9kTF06t700XM1EvFZoVK4E9hoHDSIlVq63Lm+4m4HeEQ95B5vqs12HWIdFUFR1G
         3OqMQUZmi+XmnM7dhlONtMWot4fjVU/4zjQQJWrvum10OgtAfutvE1L4V4imxFwo8s3G
         dhHrv+FsCw8aCl5km0Xl2T0Y5tDrS6tYywbAgnnQGkNm1cEUHoiElmDTDRQWHRkWVXep
         FOR8hauIHpWIhnigIr2FW5dt8ozz1VrHjC6+5Sth1nnVLJ+a/P38qwHzqvBPmjGxtxUj
         doRA==
X-Gm-Message-State: AOAM5322kb+kOOzO/q+bvS0MJVjsi4xaa+Bs2Ng0dULZk2Ro/MRe/scA
        iOqnuh7psyxloBivLjFCE5PceDOUdaw=
X-Google-Smtp-Source: ABdhPJzz0fW3JLa/XbCDSYSAhBmQo+D1jnfU4GupIYdc29xPwb4oZ5xUIR16aqmYJ1Zdr9FNsL0eow==
X-Received: by 2002:a17:906:938f:: with SMTP id l15mr5500818ejx.15.1616615934380;
        Wed, 24 Mar 2021 12:58:54 -0700 (PDT)
Received: from localhost (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id u24sm1383546ejr.34.2021.03.24.12.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 12:58:54 -0700 (PDT)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 6/6] scsi: target: tcmu: Make data_pages_per_blk changeable via configFS
Date:   Wed, 24 Mar 2021 20:57:58 +0100
Message-Id: <20210324195758.2021-7-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210324195758.2021-1-bostroesser@gmail.com>
References: <20210324195758.2021-1-bostroesser@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch makes data_pages_per_blk changeable in the same way as
it already is implemented for max_data_area_mb. This means, one
can change it typing
  echo "data_pages_per_blk=N" >control
It is printed when doing
  cat info

Also a new readonly attribute data_pages_per_blk delivers the
value if read.

Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
---
 drivers/target/target_core_user.c | 55 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 3de66db06438..eec2fd573e2b 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2331,7 +2331,8 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 
 enum {
 	Opt_dev_config, Opt_dev_size, Opt_hw_block_size, Opt_hw_max_sectors,
-	Opt_nl_reply_supported, Opt_max_data_area_mb, Opt_err,
+	Opt_nl_reply_supported, Opt_max_data_area_mb, Opt_data_pages_per_blk,
+	Opt_err,
 };
 
 static match_table_t tokens = {
@@ -2341,6 +2342,7 @@ static match_table_t tokens = {
 	{Opt_hw_max_sectors, "hw_max_sectors=%d"},
 	{Opt_nl_reply_supported, "nl_reply_supported=%d"},
 	{Opt_max_data_area_mb, "max_data_area_mb=%d"},
+	{Opt_data_pages_per_blk, "data_pages_per_blk=%d"},
 	{Opt_err, NULL}
 };
 
@@ -2405,6 +2407,39 @@ static int tcmu_set_max_blocks_param(struct tcmu_dev *udev, substring_t *arg)
 	return ret;
 }
 
+static int tcmu_set_data_pages_per_blk(struct tcmu_dev *udev, substring_t *arg)
+{
+	int val, ret;
+
+	ret = match_int(arg, &val);
+	if (ret < 0) {
+		pr_err("match_int() failed for data_pages_per_blk=. Error %d.\n",
+		       ret);
+		return ret;
+	}
+
+	if (val > TCMU_MBS_TO_PAGES(udev->data_area_mb)) {
+		pr_err("Invalid data_pages_per_blk %d: greater than max_data_area_mb %d -> %zd pages).\n",
+		       val, udev->data_area_mb,
+		       TCMU_MBS_TO_PAGES(udev->data_area_mb));
+		return -EINVAL;
+	}
+
+	mutex_lock(&udev->cmdr_lock);
+	if (udev->data_bitmap) {
+		pr_err("Cannot set data_pages_per_blk after it has been enabled.\n");
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	udev->data_pages_per_blk = val;
+	udev->max_blocks = TCMU_MBS_TO_PAGES(udev->data_area_mb) / val;
+
+unlock:
+	mutex_unlock(&udev->cmdr_lock);
+	return ret;
+}
+
 static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 		const char *page, ssize_t count)
 {
@@ -2456,6 +2491,9 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 		case Opt_max_data_area_mb:
 			ret = tcmu_set_max_blocks_param(udev, &args[0]);
 			break;
+		case Opt_data_pages_per_blk:
+			ret = tcmu_set_data_pages_per_blk(udev, &args[0]);
+			break;
 		default:
 			break;
 		}
@@ -2476,7 +2514,8 @@ static ssize_t tcmu_show_configfs_dev_params(struct se_device *dev, char *b)
 	bl = sprintf(b + bl, "Config: %s ",
 		     udev->dev_config[0] ? udev->dev_config : "NULL");
 	bl += sprintf(b + bl, "Size: %llu ", udev->dev_size);
-	bl += sprintf(b + bl, "MaxDataAreaMB: %u\n", udev->data_area_mb);
+	bl += sprintf(b + bl, "MaxDataAreaMB: %u ", udev->data_area_mb);
+	bl += sprintf(b + bl, "DataPagesPerBlk: %u\n", udev->data_pages_per_blk);
 
 	return bl;
 }
@@ -2574,6 +2613,17 @@ static ssize_t tcmu_max_data_area_mb_show(struct config_item *item, char *page)
 }
 CONFIGFS_ATTR_RO(tcmu_, max_data_area_mb);
 
+static ssize_t tcmu_data_pages_per_blk_show(struct config_item *item,
+					    char *page)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+						struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+
+	return snprintf(page, PAGE_SIZE, "%u\n", udev->data_pages_per_blk);
+}
+CONFIGFS_ATTR_RO(tcmu_, data_pages_per_blk);
+
 static ssize_t tcmu_dev_config_show(struct config_item *item, char *page)
 {
 	struct se_dev_attrib *da = container_of(to_config_group(item),
@@ -2885,6 +2935,7 @@ static struct configfs_attribute *tcmu_attrib_attrs[] = {
 	&tcmu_attr_cmd_time_out,
 	&tcmu_attr_qfull_time_out,
 	&tcmu_attr_max_data_area_mb,
+	&tcmu_attr_data_pages_per_blk,
 	&tcmu_attr_dev_config,
 	&tcmu_attr_dev_size,
 	&tcmu_attr_emulate_write_cache,
-- 
2.12.3

