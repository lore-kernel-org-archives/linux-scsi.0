Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E792CC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 10:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D3D861183
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 10:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhELKmB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 06:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbhELKmA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 06:42:00 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DB4C061574;
        Wed, 12 May 2021 03:40:52 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id l4so34256480ejc.10;
        Wed, 12 May 2021 03:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=v8a2G39uoN8k2ZjjclyG5gmaQ67RO7AkbAxDSQWLR7Y=;
        b=r1+mbVdfuMrTWIAbT2nox2AOMZ6MTTqQ/SwplT4Fb253cIHrf0qv7K3fXz8THFHkeF
         XvNYjUk5k0cxowAjI7cqMeYGui61kk4ZYX1ALwOzrxgM5L0guIzHlJbMObAHLHQrhNWt
         TEj9eqkQanlqRGTu63yWGjPDY2a0RU4xXHrdvUiq8OahG0zFnYTvJ3287PMw6C/eoQ6k
         GQ2eLntQEOUaDWgRKkRydNCNbYn7yvjgqOYkgrGe82uNMFNRoxui0afazl39XYYQB9iv
         +ip45FL1XKDSIXiAfpl9jKPQ2ziKe+GmrmyjFkiPXZjCQrY6xk7kubz4YbiiccaQblhh
         sZOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=v8a2G39uoN8k2ZjjclyG5gmaQ67RO7AkbAxDSQWLR7Y=;
        b=qmjJ/77uL8jDfL5xEe0pfFEbrBXS0LxmA1KpEdsIUyVzsYBxfN5CzDIbSL0TC0N9ie
         /Uptt3irWlUFGY/eR+//ngYme2W7Fh9NaLnLEsHmLSVvoL2rK1O78L4df6wU4PQQcJol
         wiahaRwEYtfchCu2ghHHhhaF/6DJjAMxvxd5bnMl9z15z5IWTNKc/ccOU71B6Os0hGqD
         GkO1yxbqV/xpbRJXJ48uNgJUv+HJfLISakgTv4NEZjExaDQxVAkDiU5fSP4M02KGrx/8
         M6GWWNwC/hSvCDMmOVVuBfHHoDci7VwsihXMaHq6TnihIKgOrJJVSqdgOJ+xOT7S+CTp
         p93w==
X-Gm-Message-State: AOAM531RY5gMVk3gGKGef1OUZDwMat+J6WxHHAoBb5fSL7/qOwDaXnPa
        8tPGfkxpbp42hANYLY3PuWz8FBd+ANI=
X-Google-Smtp-Source: ABdhPJyLAVcJY0YRnu9w/h7H9YE4Up0ORRyL8AaztscA6+A83z99Keaa3gkHNvoXYkUJR8szMl74ng==
X-Received: by 2002:a17:906:7842:: with SMTP id p2mr36176611ejm.487.1620816051170;
        Wed, 12 May 2021 03:40:51 -0700 (PDT)
Received: from localhost (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id n11sm14742649ejg.43.2021.05.12.03.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 03:40:50 -0700 (PDT)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>
Subject: [PATCH v2] scsi: target: tcmu: Add new feature KEEP_BUF
Date:   Wed, 12 May 2021 12:40:41 +0200
Message-Id: <20210512104041.15895-1-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When running command pipelining for WRITE direction commands,
(e.g. tape device write) userspace sends cmd completion to cmd
ring before processing write data. In that case userspace has to
copy data before sending completion, because cmd completion also
implicitly releases the data buffer in data area.

The new feature KEEP_BUF allows userspace to optionally keep the
buffer after completion by setting new bit TCMU_UFLAG_KEEP_BUF in
tcmu_cmd_entry_hdr->uflags. In that case buffer has to be released
explicitly by writing the cmd_id to new action item free_kept_buf.

All kept buffers are released during reset_ring and if userspace
closes uio device (tcmu_release).

Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
---

v2: During tcmu_dev_kref_release not only kill timed out commands,
    but also completed commands waiting for explicit buffer free
    (change in tcmu_check_and_free_pending_cmd).
    The change is necessary due to tcmu_release not being called
    during tcmu device removal if userspace holds uio dev open.

 drivers/target/target_core_user.c     | 148 +++++++++++++++++++++++++++++++---
 include/uapi/linux/target_core_user.h |   2 +
 2 files changed, 139 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 198d25ae482a..bb3b997849e5 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -191,6 +191,7 @@ struct tcmu_cmd {
 	unsigned long deadline;
 
 #define TCMU_CMD_BIT_EXPIRED 0
+#define TCMU_CMD_BIT_KEEP_BUF 1
 	unsigned long flags;
 };
 
@@ -1313,11 +1314,13 @@ tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
 	mutex_unlock(&udev->cmdr_lock);
 }
 
-static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *entry)
+static bool tcmu_handle_completion(struct tcmu_cmd *cmd,
+				   struct tcmu_cmd_entry *entry, bool keep_buf)
 {
 	struct se_cmd *se_cmd = cmd->se_cmd;
 	struct tcmu_dev *udev = cmd->tcmu_dev;
 	bool read_len_valid = false;
+	bool ret = true;
 	uint32_t read_len;
 
 	/*
@@ -1328,6 +1331,13 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 		WARN_ON_ONCE(se_cmd);
 		goto out;
 	}
+	if (test_bit(TCMU_CMD_BIT_KEEP_BUF, &cmd->flags)) {
+		pr_err("cmd_id %u already completed with KEEP_BUF, ring is broken\n",
+		       entry->hdr.cmd_id);
+		set_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
+		ret = false;
+		goto out;
+	}
 
 	list_del_init(&cmd->queue_entry);
 
@@ -1377,8 +1387,22 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 		target_complete_cmd(cmd->se_cmd, entry->rsp.scsi_status);
 
 out:
-	tcmu_cmd_free_data(cmd, cmd->dbi_cnt);
-	tcmu_free_cmd(cmd);
+	if (!keep_buf) {
+		tcmu_cmd_free_data(cmd, cmd->dbi_cnt);
+		tcmu_free_cmd(cmd);
+	} else {
+		/*
+		 * Keep this command after completion, since userspace still
+		 * needs the data buffer. Mark it with TCMU_CMD_BIT_KEEP_BUF
+		 * and reset potential TCMU_CMD_BIT_EXPIRED, so we don't accept
+		 * a second completion later.
+		 * Userspace can free the buffer later by writing the cmd_id
+		 * to new action attribute free_kept_buf.
+		 */
+		clear_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
+		set_bit(TCMU_CMD_BIT_KEEP_BUF, &cmd->flags);
+	}
+	return ret;
 }
 
 static int tcmu_run_tmr_queue(struct tcmu_dev *udev)
@@ -1430,6 +1454,7 @@ static bool tcmu_handle_completions(struct tcmu_dev *udev)
 	while (udev->cmdr_last_cleaned != READ_ONCE(mb->cmd_tail)) {
 
 		struct tcmu_cmd_entry *entry = udev->cmdr + udev->cmdr_last_cleaned;
+		bool keep_buf;
 
 		/*
 		 * Flush max. up to end of cmd ring since current entry might
@@ -1451,7 +1476,11 @@ static bool tcmu_handle_completions(struct tcmu_dev *udev)
 		}
 		WARN_ON(tcmu_hdr_get_op(entry->hdr.len_op) != TCMU_OP_CMD);
 
-		cmd = xa_erase(&udev->commands, entry->hdr.cmd_id);
+		keep_buf = !!(entry->hdr.uflags & TCMU_UFLAG_KEEP_BUF);
+		if (keep_buf)
+			cmd = xa_load(&udev->commands, entry->hdr.cmd_id);
+		else
+			cmd = xa_erase(&udev->commands, entry->hdr.cmd_id);
 		if (!cmd) {
 			pr_err("cmd_id %u not found, ring is broken\n",
 			       entry->hdr.cmd_id);
@@ -1459,7 +1488,8 @@ static bool tcmu_handle_completions(struct tcmu_dev *udev)
 			return false;
 		}
 
-		tcmu_handle_completion(cmd, entry);
+		if (!tcmu_handle_completion(cmd, entry, keep_buf))
+			break;
 
 		UPDATE_HEAD(udev->cmdr_last_cleaned,
 			    tcmu_hdr_get_len(entry->hdr.len_op),
@@ -1617,7 +1647,8 @@ static void tcmu_dev_call_rcu(struct rcu_head *p)
 
 static int tcmu_check_and_free_pending_cmd(struct tcmu_cmd *cmd)
 {
-	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
+	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags) ||
+	    test_bit(TCMU_CMD_BIT_KEEP_BUF, &cmd->flags)) {
 		kmem_cache_free(tcmu_cmd_cache, cmd);
 		return 0;
 	}
@@ -1901,6 +1932,38 @@ static int tcmu_open(struct uio_info *info, struct inode *inode)
 static int tcmu_release(struct uio_info *info, struct inode *inode)
 {
 	struct tcmu_dev *udev = container_of(info, struct tcmu_dev, uio_info);
+	struct tcmu_cmd *cmd;
+	unsigned long i;
+	bool freed = false;
+
+	mutex_lock(&udev->cmdr_lock);
+
+	xa_for_each(&udev->commands, i, cmd) {
+		/* Cmds with KEEP_BUF set are no longer on the ring, but
+		 * userspace still holds the data buffer. If userspace closes
+		 * we implicitly free these cmds and buffers, since after new
+		 * open the (new ?) userspace cannot find the cmd in the ring
+		 * and thus never will release the buffer by writing cmd_id to
+		 * free_kept_buf action attribute.
+		 */
+		if (!test_bit(TCMU_CMD_BIT_KEEP_BUF, &cmd->flags))
+			continue;
+		pr_debug("removing KEEP_BUF cmd %u on dev %s from ring\n",
+			 cmd->cmd_id, udev->name);
+		freed = true;
+
+		xa_erase(&udev->commands, i);
+		tcmu_cmd_free_data(cmd, cmd->dbi_cnt);
+		tcmu_free_cmd(cmd);
+	}
+	/*
+	 * We only freed data space, not ring space. Therefore we dont call
+	 * run_tmr_queue, but call run_qfull_queue if tmr_list is empty.
+	 */
+	if (freed && list_empty(&udev->tmr_queue))
+		run_qfull_queue(udev, false);
+
+	mutex_unlock(&udev->cmdr_lock);
 
 	clear_bit(TCMU_DEV_BIT_OPEN, &udev->flags);
 
@@ -2145,7 +2208,8 @@ static int tcmu_configure_device(struct se_device *dev)
 	mb->version = TCMU_MAILBOX_VERSION;
 	mb->flags = TCMU_MAILBOX_FLAG_CAP_OOOC |
 		    TCMU_MAILBOX_FLAG_CAP_READ_LEN |
-		    TCMU_MAILBOX_FLAG_CAP_TMR;
+		    TCMU_MAILBOX_FLAG_CAP_TMR |
+		    TCMU_MAILBOX_FLAG_CAP_KEEP_BUF;
 	mb->cmdr_off = CMDR_OFF;
 	mb->cmdr_size = udev->cmdr_size;
 
@@ -2277,12 +2341,16 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 	mutex_lock(&udev->cmdr_lock);
 
 	xa_for_each(&udev->commands, i, cmd) {
-		pr_debug("removing cmd %u on dev %s from ring (is expired %d)\n",
-			  cmd->cmd_id, udev->name,
-			  test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags));
+		pr_debug("removing cmd %u on dev %s from ring %s\n",
+			 cmd->cmd_id, udev->name,
+			 test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags) ?
+			 "(is expired)" :
+			 (test_bit(TCMU_CMD_BIT_KEEP_BUF, &cmd->flags) ?
+			 "(is keep buffer)" : ""));
 
 		xa_erase(&udev->commands, i);
-		if (!test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
+		if (!test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags) &&
+		    !test_bit(TCMU_CMD_BIT_KEEP_BUF, &cmd->flags)) {
 			WARN_ON(!cmd->se_cmd);
 			list_del_init(&cmd->queue_entry);
 			cmd->se_cmd->priv = NULL;
@@ -2931,6 +2999,63 @@ static ssize_t tcmu_reset_ring_store(struct config_item *item, const char *page,
 }
 CONFIGFS_ATTR_WO(tcmu_, reset_ring);
 
+static ssize_t tcmu_free_kept_buf_store(struct config_item *item, const char *page,
+				     size_t count)
+{
+	struct se_device *se_dev = container_of(to_config_group(item),
+						struct se_device,
+						dev_action_group);
+	struct tcmu_dev *udev = TCMU_DEV(se_dev);
+	struct tcmu_cmd *cmd;
+	u16 cmd_id;
+	int ret;
+
+	if (!target_dev_configured(&udev->se_dev)) {
+		pr_err("Device is not configured.\n");
+		return -EINVAL;
+	}
+
+	ret = kstrtou16(page, 0, &cmd_id);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&udev->cmdr_lock);
+
+	{
+		XA_STATE(xas, &udev->commands, cmd_id);
+
+		cmd = xas_load(&xas);
+		if (!cmd) {
+			pr_err("free_kept_buf: cmd_id %d not found\n", cmd_id);
+			count = -EINVAL;
+			goto out_unlock;
+		}
+		if (!test_bit(TCMU_CMD_BIT_KEEP_BUF, &cmd->flags)) {
+			pr_err("free_kept_buf: cmd_id %d was not completed with KEEP_BUF\n",
+			       cmd_id);
+			count = -EINVAL;
+			goto out_unlock;
+		}
+		xas_lock(&xas);
+		xas_store(&xas, NULL);
+		xas_unlock(&xas);
+	}
+
+	tcmu_cmd_free_data(cmd, cmd->dbi_cnt);
+	tcmu_free_cmd(cmd);
+	/*
+	 * We only freed data space, not ring space. Therefore we dont call
+	 * run_tmr_queue, but call run_qfull_queue if tmr_list is empty.
+	 */
+	if (list_empty(&udev->tmr_queue))
+		run_qfull_queue(udev, false);
+
+out_unlock:
+	mutex_unlock(&udev->cmdr_lock);
+	return count;
+}
+CONFIGFS_ATTR_WO(tcmu_, free_kept_buf);
+
 static struct configfs_attribute *tcmu_attrib_attrs[] = {
 	&tcmu_attr_cmd_time_out,
 	&tcmu_attr_qfull_time_out,
@@ -2949,6 +3074,7 @@ static struct configfs_attribute **tcmu_attrs;
 static struct configfs_attribute *tcmu_action_attrs[] = {
 	&tcmu_attr_block_dev,
 	&tcmu_attr_reset_ring,
+	&tcmu_attr_free_kept_buf,
 	NULL,
 };
 
diff --git a/include/uapi/linux/target_core_user.h b/include/uapi/linux/target_core_user.h
index 95b1597f16ae..27ace512babd 100644
--- a/include/uapi/linux/target_core_user.h
+++ b/include/uapi/linux/target_core_user.h
@@ -46,6 +46,7 @@
 #define TCMU_MAILBOX_FLAG_CAP_OOOC (1 << 0) /* Out-of-order completions */
 #define TCMU_MAILBOX_FLAG_CAP_READ_LEN (1 << 1) /* Read data length */
 #define TCMU_MAILBOX_FLAG_CAP_TMR (1 << 2) /* TMR notifications */
+#define TCMU_MAILBOX_FLAG_CAP_KEEP_BUF (1<<3) /* Keep buf after cmd completion */
 
 struct tcmu_mailbox {
 	__u16 version;
@@ -75,6 +76,7 @@ struct tcmu_cmd_entry_hdr {
 	__u8 kflags;
 #define TCMU_UFLAG_UNKNOWN_OP 0x1
 #define TCMU_UFLAG_READ_LEN   0x2
+#define TCMU_UFLAG_KEEP_BUF   0x4
 	__u8 uflags;
 
 } __packed;
-- 
2.12.3

