From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 09/16] target: Add DEF_TB_DEFAULT_ATTRIBS macro for virtual device attrs
Date: Fri, 28 Nov 2014 09:06:35 +0000
Message-ID: <1417165602-32359-10-git-send-email-nab@daterainc.com>
References: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:44477 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaK1Jho (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Nov 2014 04:37:44 -0500
Received: by mail-oi0-f53.google.com with SMTP id x69so4330238oia.26
        for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2014 01:37:44 -0800 (PST)
In-Reply-To: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Jerome Martin <tramjoe.merin@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This helper macro adds the default set of 30 device attributes for
virtual devices from existing target_core_configfs.c code, and moves
the definitions into a single macro to create the structs necessary
for backend drivers.

It allows them to populate their own external struct configfs_attribute
for se_subsystem_api->tb_cits.tb_dev_attrib_cit.ct_attrs.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 include/target/target_core_backend_configfs.h | 67 +++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/include/target/target_core_backend_configfs.h b/include/target/target_core_backend_configfs.h
index f91935b..3247d75 100644
--- a/include/target/target_core_backend_configfs.h
+++ b/include/target/target_core_backend_configfs.h
@@ -50,4 +50,71 @@ static struct target_backend_dev_attrib_attribute _backend##_dev_attrib_##_name
 	__CONFIGFS_EATTR_RO(_name,					\
 	_backend##_dev_show_attr_##_name);
 
+/*
+ * Default list of target backend device attributes as defined by
+ * struct se_dev_attrib
+ */
+
+#define DEF_TB_DEFAULT_ATTRIBS(_backend)				\
+	DEF_TB_DEV_ATTRIB(_backend, emulate_model_alias);		\
+	TB_DEV_ATTR(_backend, emulate_model_alias, S_IRUGO | S_IWUSR);	\
+	DEF_TB_DEV_ATTRIB(_backend, emulate_dpo);			\
+	TB_DEV_ATTR(_backend, emulate_dpo, S_IRUGO | S_IWUSR);		\
+	DEF_TB_DEV_ATTRIB(_backend, emulate_fua_write);			\
+	TB_DEV_ATTR(_backend, emulate_fua_write, S_IRUGO | S_IWUSR);	\
+	DEF_TB_DEV_ATTRIB(_backend, emulate_fua_read);			\
+	TB_DEV_ATTR(_backend, emulate_fua_read, S_IRUGO | S_IWUSR);	\
+	DEF_TB_DEV_ATTRIB(_backend, emulate_write_cache);		\
+	TB_DEV_ATTR(_backend, emulate_write_cache, S_IRUGO | S_IWUSR);	\
+	DEF_TB_DEV_ATTRIB(_backend, emulate_ua_intlck_ctrl);		\
+	TB_DEV_ATTR(_backend, emulate_ua_intlck_ctrl, S_IRUGO | S_IWUSR); \
+	DEF_TB_DEV_ATTRIB(_backend, emulate_tas);			\
+	TB_DEV_ATTR(_backend, emulate_tas, S_IRUGO | S_IWUSR);		\
+	DEF_TB_DEV_ATTRIB(_backend, emulate_tpu);			\
+	TB_DEV_ATTR(_backend, emulate_tpu, S_IRUGO | S_IWUSR);		\
+	DEF_TB_DEV_ATTRIB(_backend, emulate_tpws);			\
+	TB_DEV_ATTR(_backend, emulate_tpws, S_IRUGO | S_IWUSR);		\
+	DEF_TB_DEV_ATTRIB(_backend, emulate_caw);			\
+	TB_DEV_ATTR(_backend, emulate_caw, S_IRUGO | S_IWUSR);		\
+	DEF_TB_DEV_ATTRIB(_backend, emulate_3pc);			\
+	TB_DEV_ATTR(_backend, emulate_3pc, S_IRUGO | S_IWUSR);		\
+	DEF_TB_DEV_ATTRIB(_backend, pi_prot_type);			\
+	TB_DEV_ATTR(_backend, pi_prot_type, S_IRUGO | S_IWUSR);		\
+	DEF_TB_DEV_ATTRIB_RO(_backend, hw_pi_prot_type);		\
+	TB_DEV_ATTR_RO(_backend, hw_pi_prot_type);			\
+	DEF_TB_DEV_ATTRIB(_backend, pi_prot_format);			\
+	TB_DEV_ATTR(_backend, pi_prot_format, S_IRUGO | S_IWUSR);	\
+	DEF_TB_DEV_ATTRIB(_backend, enforce_pr_isids);			\
+	TB_DEV_ATTR(_backend, enforce_pr_isids, S_IRUGO | S_IWUSR);	\
+	DEF_TB_DEV_ATTRIB(_backend, is_nonrot);				\
+	TB_DEV_ATTR(_backend, is_nonrot, S_IRUGO | S_IWUSR);		\
+	DEF_TB_DEV_ATTRIB(_backend, emulate_rest_reord);		\
+	TB_DEV_ATTR(_backend, emulate_rest_reord, S_IRUGO | S_IWUSR);	\
+	DEF_TB_DEV_ATTRIB(_backend, force_pr_aptpl);			\
+	TB_DEV_ATTR(_backend, force_pr_aptpl, S_IRUGO | S_IWUSR);	\
+	DEF_TB_DEV_ATTRIB_RO(_backend, hw_block_size);			\
+	TB_DEV_ATTR_RO(_backend, hw_block_size);			\
+	DEF_TB_DEV_ATTRIB(_backend, block_size);			\
+	TB_DEV_ATTR(_backend, block_size, S_IRUGO | S_IWUSR);		\
+	DEF_TB_DEV_ATTRIB_RO(_backend, hw_max_sectors);			\
+	TB_DEV_ATTR_RO(_backend, hw_max_sectors);			\
+	DEF_TB_DEV_ATTRIB(_backend, fabric_max_sectors);		\
+	TB_DEV_ATTR(_backend, fabric_max_sectors, S_IRUGO | S_IWUSR);	\
+	DEF_TB_DEV_ATTRIB(_backend, optimal_sectors);			\
+	TB_DEV_ATTR(_backend, optimal_sectors, S_IRUGO | S_IWUSR);	\
+	DEF_TB_DEV_ATTRIB_RO(_backend, hw_queue_depth);			\
+	TB_DEV_ATTR_RO(_backend, hw_queue_depth);			\
+	DEF_TB_DEV_ATTRIB(_backend, queue_depth);			\
+	TB_DEV_ATTR(_backend, queue_depth, S_IRUGO | S_IWUSR);		\
+	DEF_TB_DEV_ATTRIB(_backend, max_unmap_lba_count);		\
+	TB_DEV_ATTR(_backend, max_unmap_lba_count, S_IRUGO | S_IWUSR);	\
+	DEF_TB_DEV_ATTRIB(_backend, max_unmap_block_desc_count);	\
+	TB_DEV_ATTR(_backend, max_unmap_block_desc_count, S_IRUGO | S_IWUSR); \
+	DEF_TB_DEV_ATTRIB(_backend, unmap_granularity);			\
+	TB_DEV_ATTR(_backend, unmap_granularity, S_IRUGO | S_IWUSR);	\
+	DEF_TB_DEV_ATTRIB(_backend, unmap_granularity_alignment);	\
+	TB_DEV_ATTR(_backend, unmap_granularity_alignment, S_IRUGO | S_IWUSR); \
+	DEF_TB_DEV_ATTRIB(_backend, max_write_same_len);		\
+	TB_DEV_ATTR(_backend, max_write_same_len, S_IRUGO | S_IWUSR);
+
 #endif /* TARGET_CORE_BACKEND_CONFIGFS_H */
-- 
1.9.1

