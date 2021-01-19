Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C0BDC18E17
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBCE620706
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389816AbhASRDT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 12:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730595AbhASQjq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2021 11:39:46 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CCAC061574;
        Tue, 19 Jan 2021 08:39:02 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id rv9so10624787ejb.13;
        Tue, 19 Jan 2021 08:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ksmspH25ZE9JAlOy0UzAxXX6kDfsAEZCpKdtY20OyMw=;
        b=o1dCZFcyJqwovn485um1zkf+SXnql6nXsQ6U/YUeNfldQEO5BhrQHV8KYb3SAWCHbk
         mh3wXNbIC7O7q6V/4JZiu1MUSWGPicM839InSoxmGmU7FOqH+/XCGZfsDX/KoW+Vm0Hn
         gPDu1yQ5OneKQIHMFWSQvx8f3feKssSrpzT8eanubGe8DaYWWVnBgcZ62sCrHQZ9s4Jw
         bltCCQjd2gdAPuWHF2ycpOJhdzGF2HfJP1236FmPknAUGY+PIiZfQ1NYrRJtbTvYaw6v
         4PX34UE8Ojv7ylvfj/QY79wvgPaoi/usm5Ym9OOdy2YShS1E58+ha1KDMa1ElSwSopo0
         3ayQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ksmspH25ZE9JAlOy0UzAxXX6kDfsAEZCpKdtY20OyMw=;
        b=KWpYlcai8vzFeaveVlwQopmupSOoUVP98JcfSxNQoIdy5+8RCJNkvlp7KDzwmsjPOE
         OULEOn9Om2YYmPQMofT0nqlOsp7/2cY2dDzNJnwpSJB+GW5HzDbCJ9M7ocH1ZJBYs+it
         djnj3d8aqOW/vdj3EfXsn18pMrArlRzLwrO45xHeYXJba3+/DW9+ra7eNrnzAGjKaQop
         vVUxjh2M7WSGsgQsl0nneaKXgkDVXarOe+96skukBLt0+IiXCzFv9RrZe/CRwy6628uj
         SA5/qWJTi4eKJz2rmhpfScCt6dTSQ5kev0LoJWqOB38msbcoKc7lzFud+FVqGH/MQA1E
         uBcQ==
X-Gm-Message-State: AOAM531JWvGn3CecVISZafdIWmYMR1UkGnPn+cFCAjembZQ0IeumMtvw
        53LUg8JN9kwA/woomNIdxck=
X-Google-Smtp-Source: ABdhPJzMVhFvdrQeOW+QLHmntsHSp8+d6AaMZ/hiJTEWt/QaJ/f3W2MVv/WxpgOpzK7T85/XDwu/+g==
X-Received: by 2002:a17:906:4b48:: with SMTP id j8mr3516470ejv.112.1611074340773;
        Tue, 19 Jan 2021 08:39:00 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.gmail.com with ESMTPSA id k22sm9589993eji.101.2021.01.19.08.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 08:39:00 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 1/6] scsi: ufs: Add "wb_on" sysfs node to control WB on/off
Date:   Tue, 19 Jan 2021 17:38:42 +0100
Message-Id: <20210119163847.20165-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210119163847.20165-1-huobean@gmail.com>
References: <20210119163847.20165-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Currently UFS WriteBooster driver uses clock scaling up/down to set
WB on/off, for the platform which doesn't support UFSHCD_CAP_CLK_SCALING,
WB will be always on. Provide a sysfs attribute to enable/disable WB
during runtime. Write 1/0 to "wb_on" sysfs node to enable/disable UFS WB.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs-sysfs.c | 46 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c    |  3 +--
 drivers/scsi/ufs/ufshcd.h    |  2 ++
 3 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index c092f249d6f9..76db8593ca09 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -209,6 +209,50 @@ static ssize_t auto_hibern8_store(struct device *dev,
 	return ret ? ret : count;
 }
 
+static ssize_t wb_on_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%d\n", hba->wb_enabled);
+}
+
+static ssize_t wb_on_store(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	unsigned int wb_enable;
+	ssize_t res;
+
+	if (!ufshcd_is_wb_allowed(hba) || ufshcd_is_clkscaling_supported(hba)) {
+		/*
+		 * If the platform supports UFSHCD_CAP_CLK_SCALING, turn WB
+		 * on/off will be done while clock scaling up/down.
+		 */
+		dev_warn(dev, "To control WB through wb_on is not allowed!\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (kstrtouint(buf, 0, &wb_enable))
+		return -EINVAL;
+
+	if (wb_enable != 0 && wb_enable != 1)
+		return -EINVAL;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		res = -EBUSY;
+		goto out;
+	}
+
+	pm_runtime_get_sync(hba->dev);
+	res = ufshcd_wb_ctrl(hba, wb_enable);
+	pm_runtime_put_sync(hba->dev);
+out:
+	up(&hba->host_sem);
+	return res < 0 ? res : count;
+}
+
 static DEVICE_ATTR_RW(rpm_lvl);
 static DEVICE_ATTR_RO(rpm_target_dev_state);
 static DEVICE_ATTR_RO(rpm_target_link_state);
@@ -216,6 +260,7 @@ static DEVICE_ATTR_RW(spm_lvl);
 static DEVICE_ATTR_RO(spm_target_dev_state);
 static DEVICE_ATTR_RO(spm_target_link_state);
 static DEVICE_ATTR_RW(auto_hibern8);
+static DEVICE_ATTR_RW(wb_on);
 
 static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_rpm_lvl.attr,
@@ -225,6 +270,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_spm_target_dev_state.attr,
 	&dev_attr_spm_target_link_state.attr,
 	&dev_attr_auto_hibern8.attr,
+	&dev_attr_wb_on.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9b387d6a2a25..501c617cecb9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -249,7 +249,6 @@ static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
 static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba);
 static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba);
-static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
 static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set);
 static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
 static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
@@ -5413,7 +5412,7 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 				__func__, err);
 }
 
-static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
+int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
 {
 	int ret;
 	u8 index;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 5bbe4715d4e9..ac0f03f69e42 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1089,6 +1089,8 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     u8 *desc_buff, int *buff_len,
 			     enum query_opcode desc_op);
 
+int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
+
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
 {
-- 
2.17.1

