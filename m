Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A1D1C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0863061372
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhJTVna (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:43:30 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:39915 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhJTVn3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:43:29 -0400
Received: by mail-pf1-f179.google.com with SMTP id d9so4091070pfl.6
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:41:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WBoQbwfgbWGOUHt2C6WF8qHbFDkaocHjhNPf0ztXEPk=;
        b=y5tapmAQhn70NbDA7JqqXnvyVYsnx4ZZOvFy7PqWuY2jsWXjKzBswMSkp4x91CHaYL
         3qeTfBf48BaYJvmFL7avIr1S9tZmdH3ZoVp6dN9DZUE0tF0NpIy5xuHX1fPcRdtvPlwQ
         9S3Zku6gTr3zzxBglwJJXWjqSLfJWwzxHJ3jINIbZ82odFli/UQPf4TCsFkmqhL6eWFf
         W1sh8NEis6W7He9UHA5LRtNMhdCqK5Fy+bPUDPpKxjTq2SAvsh1MBHekQwe8mDor9PEk
         QNg/5gNUWtEBkgUhMcnQtmduylgbm39cxu0seSo+/aS5KG8BOYnqgq/wABaclXQmdjAZ
         fIbg==
X-Gm-Message-State: AOAM533gk2mQ6itC6O1cyFc1eiRm1E6bX2roAoc7azKKPbrU6UpdJWn2
        V/+lWA/ZN0NQ8sWaYUc4XJA=
X-Google-Smtp-Source: ABdhPJwYYyaGbsTTvknbAQIati08s8U/1O3A1ePAnuXkub8oOwgaOMiOMkLADPvoGz2t8Ixa4H/MnQ==
X-Received: by 2002:a05:6a00:214d:b0:44d:35e9:4ce2 with SMTP id o13-20020a056a00214d00b0044d35e94ce2mr1280680pfk.13.1634766074587;
        Wed, 20 Oct 2021 14:41:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:200d:62ea:db33:9047])
        by smtp.gmail.com with ESMTPSA id 21sm6707694pjg.57.2021.10.20.14.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:41:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v2 07/10] scsi: ufs: Add debugfs attributes for triggering the UFS EH
Date:   Wed, 20 Oct 2021 14:40:21 -0700
Message-Id: <20211020214024.2007615-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211020214024.2007615-1-bvanassche@acm.org>
References: <20211020214024.2007615-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it easier to test the impact of the UFS error handler on software
that submits SCSI commands to the UFS driver.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-debugfs.c | 65 ++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-debugfs.c b/drivers/scsi/ufs/ufs-debugfs.c
index 1d4e5aa4b762..4a0bbcf1757a 100644
--- a/drivers/scsi/ufs/ufs-debugfs.c
+++ b/drivers/scsi/ufs/ufs-debugfs.c
@@ -138,8 +138,73 @@ static void ufs_debugfs_restart_ee(struct work_struct *work)
 	ufs_debugfs_put_user_access(hba);
 }
 
+static int ufs_saved_err_show(struct seq_file *s, void *data)
+{
+	struct ufs_debugfs_attr *attr = s->private;
+	struct ufs_hba *hba = hba_from_file(s->file);
+	const int *p;
+
+	if (strcmp(attr->name, "saved_err") == 0) {
+		p = &hba->saved_err;
+	} else if (strcmp(attr->name, "saved_uic_err") == 0) {
+		p = &hba->saved_uic_err;
+	} else {
+		return -ENOENT;
+	}
+
+	seq_printf(s, "%d\n", *p);
+	return 0;
+}
+
+static ssize_t ufs_saved_err_write(struct file *file, const char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ufs_debugfs_attr *attr = file->f_inode->i_private;
+	struct ufs_hba *hba = hba_from_file(file);
+	char val_str[16] = { };
+	int val, ret;
+
+	if (count > sizeof(val_str))
+		return -EINVAL;
+	if (copy_from_user(val_str, buf, count))
+		return -EFAULT;
+	ret = kstrtoint(val_str, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	spin_lock_irq(hba->host->host_lock);
+	if (strcmp(attr->name, "saved_err") == 0) {
+		hba->saved_err = val;
+	} else if (strcmp(attr->name, "saved_uic_err") == 0) {
+		hba->saved_uic_err = val;
+	} else {
+		ret = -ENOENT;
+	}
+	if (ret == 0)
+		ufshcd_schedule_eh_work(hba);
+	spin_unlock_irq(hba->host->host_lock);
+
+	return ret < 0 ? ret : count;
+}
+
+static int ufs_saved_err_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ufs_saved_err_show, inode->i_private);
+}
+
+static const struct file_operations ufs_saved_err_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ufs_saved_err_open,
+	.read		= seq_read,
+	.write		= ufs_saved_err_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static const struct ufs_debugfs_attr ufs_attrs[] = {
 	{ "stats", 0400, &ufs_debugfs_stats_fops },
+	{ "saved_err", 0600, &ufs_saved_err_fops },
+	{ "saved_uic_err", 0600, &ufs_saved_err_fops },
 	{ }
 };
 
