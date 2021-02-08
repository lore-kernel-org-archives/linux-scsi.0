Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E20C433E9
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 19:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05EDB64E8C
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 19:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234671AbhBHTIp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 14:08:45 -0500
Received: from vps.thesusis.net ([34.202.238.73]:49326 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236035AbhBHTGl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Feb 2021 14:06:41 -0500
X-Greylist: delayed 650 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Feb 2021 14:06:37 EST
Received: from localhost (localhost [127.0.0.1])
        by vps.thesusis.net (Postfix) with ESMTP id 049F62BB8B;
        Mon,  8 Feb 2021 13:55:04 -0500 (EST)
Received: from vps.thesusis.net ([IPv6:::1])
        by localhost (vps.thesusis.net [IPv6:::1]) (amavisd-new, port 10024)
        with ESMTP id n4IrlePrxosk; Mon,  8 Feb 2021 13:55:03 -0500 (EST)
Received: from debian.iradimed.local (097-068-109-042.biz.spectrum.com [97.68.109.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: psusi)
        by vps.thesusis.net (Postfix) with ESMTPSA id 280952BB8D;
        Mon,  8 Feb 2021 13:55:03 -0500 (EST)
From:   Phillip Susi <phill@thesusis.net>
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH] LIO: Add emulate_removable attribute
Date:   Mon,  8 Feb 2021 13:54:09 -0500
Message-Id: <20210208185409.35907-2-phill@thesusis.net>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208185409.35907-1-phill@thesusis.net>
References: <20210208185409.35907-1-phill@thesusis.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add another attribute that can be tuned via sysfs to have the
emulated scsi disk report that it is removable.
---
 drivers/target/target_core_configfs.c | 4 ++++
 drivers/target/target_core_spc.c      | 2 ++
 include/target/target_core_base.h     | 1 +
 3 files changed, 7 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f04352285155..2cecc0c1cc26 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -546,6 +546,7 @@ DEF_CONFIGFS_ATTRIB_SHOW(unmap_granularity);
 DEF_CONFIGFS_ATTRIB_SHOW(unmap_granularity_alignment);
 DEF_CONFIGFS_ATTRIB_SHOW(unmap_zeroes_data);
 DEF_CONFIGFS_ATTRIB_SHOW(max_write_same_len);
+DEF_CONFIGFS_ATTRIB_SHOW(emulate_removable);
 
 #define DEF_CONFIGFS_ATTRIB_STORE_U32(_name)				\
 static ssize_t _name##_store(struct config_item *item, const char *page,\
@@ -589,6 +590,7 @@ DEF_CONFIGFS_ATTRIB_STORE_BOOL(emulate_3pc);
 DEF_CONFIGFS_ATTRIB_STORE_BOOL(emulate_pr);
 DEF_CONFIGFS_ATTRIB_STORE_BOOL(enforce_pr_isids);
 DEF_CONFIGFS_ATTRIB_STORE_BOOL(is_nonrot);
+DEF_CONFIGFS_ATTRIB_STORE_BOOL(emulate_removable);
 
 #define DEF_CONFIGFS_ATTRIB_STORE_STUB(_name)				\
 static ssize_t _name##_store(struct config_item *item, const char *page,\
@@ -1178,6 +1180,7 @@ CONFIGFS_ATTR(, emulate_tpws);
 CONFIGFS_ATTR(, emulate_caw);
 CONFIGFS_ATTR(, emulate_3pc);
 CONFIGFS_ATTR(, emulate_pr);
+CONFIGFS_ATTR(, emulate_removable);
 CONFIGFS_ATTR(, pi_prot_type);
 CONFIGFS_ATTR_RO(, hw_pi_prot_type);
 CONFIGFS_ATTR(, pi_prot_format);
@@ -1241,6 +1244,7 @@ struct configfs_attribute *sbc_attrib_attrs[] = {
 	&attr_max_write_same_len,
 	&attr_alua_support,
 	&attr_pgr_support,
+	&attr_emulate_removable,
 	NULL,
 };
 EXPORT_SYMBOL(sbc_attrib_attrs);
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index ca5579ebc81d..5af67a1e10f9 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -54,6 +54,8 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 	struct se_device *dev = cmd->se_dev;
 	struct se_session *sess = cmd->se_sess;
 
+	if (dev->dev_attrib.emulate_removable)
+		buf[1] = 0x80;
 	/* Set RMB (removable media) for tape devices */
 	if (dev->transport->get_device_type(dev) == TYPE_TAPE)
 		buf[1] = 0x80;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 63dd12124139..ae2396c1485a 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -692,6 +692,7 @@ struct se_dev_attrib {
 	bool		is_nonrot;
 	bool		emulate_rest_reord;
 	bool		unmap_zeroes_data;
+	bool		emulate_removable;
 	u32		hw_block_size;
 	u32		block_size;
 	u32		hw_max_sectors;
-- 
2.30.0

