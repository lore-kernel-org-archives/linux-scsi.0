Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52CA3CA9EBD
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0ACB205ED
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rdRySEny"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436640AbfJWV4z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:56:55 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:37047 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436632AbfJWV4z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:56:55 -0400
Received: by mail-wr1-f46.google.com with SMTP id e11so15003303wrv.4
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vzycFVKkt1uch3Lk5KiDKLY7sNNPndicknRuTPSNvKU=;
        b=rdRySEny0ac6AHyAt2MBqSWJszIvEllsdp1wHgKOGaitGbJfWZxd66VqAKL44grpgs
         qnhI5FFzCuxWIE3MX1kzprCBaDmdy5cthlXuvReV1J8hXlHuMP88HZNV+yJS1AjHwUxr
         YGfSihj0nG4X4CRZCStPTKI+Fok7nCptUZoLF85MVyXS1SIuiN9yd9viBcbt2ZIBza59
         9tPWQwHb8eDzVfXQsp6+hxQgyN3wRdpYoBshHnIwDjYwZw5trS/n9gkamQvyIrA3kSsW
         Bh2tSb+CjVZ77mwQwPHPFhfjHnwNUso1mmxpkouFclF3T43mFyxrVO5Qe5twSXbZotg2
         lQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vzycFVKkt1uch3Lk5KiDKLY7sNNPndicknRuTPSNvKU=;
        b=fyUts8+Er29iHnK4PIygvpjgz9V/fg8QNwbiWKZVLYPQ5At0NXp0geOR1Oj68GOLEt
         nyrvJKyI7gERcCkjkHZ/3lEO++8aMCRGYTpR7r4rmtCH/QnGqGVUrff8qxlTpDDmCQMC
         YJGdl/UUQKu32hcZukwi1Eht1ozO2ZLwLYnypAUsMz7M3upTwKgmxQLoRBTr+do9MyRK
         BpewmEr42y3GJj+R4nFJ65GpquAvqs/PtXKR6zXedi4hQ38FC2etBKyMQ83jZOa2tVdw
         6Gld3cFtTC8jLTbxtw3lkE11QjSVRyEHSbh0eVAm5ODTwXEqf0OZXkeLQhmTtQlKqLqN
         iYtA==
X-Gm-Message-State: APjAAAVALbvJoy8I3rAILcZxoXNjRfFhl7+EGhLmskFbN5743tPEVbG2
        iL8lKuph/wM34hwGfHMdNGpqw0h5
X-Google-Smtp-Source: APXvYqxIiu44oI40qv9+1rHexyYbgiTZUp2AeFb0gqH0WOpBLUEwpmJOGgNZzs+P93hEZ7v/AjZ6xQ==
X-Received: by 2002:adf:a497:: with SMTP id g23mr714519wrb.135.1571867807176;
        Wed, 23 Oct 2019 14:56:47 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:46 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 24/32] elx: efct: LIO backend interface routines
Date:   Wed, 23 Oct 2019 14:55:49 -0700
Message-Id: <20191023215557.12581-25-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191023215557.12581-1-jsmart2021@gmail.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
LIO backend template registration and template functions.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/efct/efct_lio.c | 2643 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_lio.h |  371 ++++++
 2 files changed, 3014 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_lio.c
 create mode 100644 drivers/scsi/elx/efct/efct_lio.h

diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
new file mode 100644
index 000000000000..c2661ab3e9c3
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -0,0 +1,2643 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efct_driver.h"
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_tcq.h>
+#include <target/target_core_base.h>
+#include <target/target_core_fabric.h>
+
+#include "efct_lio.h"
+
+#define	FABRIC_NAME		"efct"
+#define FABRIC_NAME_NPIV	"efct_npiv"
+
+#define	FABRIC_SNPRINTF_LEN	32
+#define	FABRIC_SNPRINTF(str, len, pre, wwn)	snprintf(str, len, \
+		"%s%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x", pre,  \
+	    (u8)((wwn >> 56) & 0xff), (u8)((wwn >> 48) & 0xff),    \
+	    (u8)((wwn >> 40) & 0xff), (u8)((wwn >> 32) & 0xff),    \
+	    (u8)((wwn >> 24) & 0xff), (u8)((wwn >> 16) & 0xff),    \
+	    (u8)((wwn >>  8) & 0xff), (u8)((wwn & 0xff)))
+
+#define	ARRAY2WWN(w, a)	(w = ((((u64)(a)[0]) << 56) | (((u64)(a)[1]) << 48) | \
+			    (((u64)(a)[2]) << 40) | (((u64)(a)[3]) << 32) | \
+			    (((u64)(a)[4]) << 24) | (((u64)(a)[5]) << 16) | \
+			    (((u64)(a)[6]) <<  8) | (((u64)(a)[7]))))
+
+struct efct_lio_sport {
+	u64 wwpn;
+	unsigned char wwpn_str[FABRIC_SNPRINTF_LEN];
+	struct se_wwn sport_wwn;
+	struct efct_lio_tpg *tpg;
+	struct efct_s *efct;
+	struct dentry *sessions;
+	atomic_t enable;
+};
+
+struct efct_lio_tpg_attrib {
+	int generate_node_acls;
+	int cache_dynamic_acls;
+	int demo_mode_write_protect;
+	int prod_mode_write_protect;
+	int demo_mode_login_only;
+	bool session_deletion_wait;
+};
+
+struct efct_lio_tpg {
+	struct se_portal_group tpg;
+	struct efct_lio_sport *sport;
+	struct efct_lio_vport *vport;
+	struct efct_lio_tpg_attrib tpg_attrib;
+	unsigned short tpgt;
+	atomic_t enabled;
+};
+
+struct efct_lio_nacl {
+	u64			nport_wwnn;
+	char			nport_name[FABRIC_SNPRINTF_LEN];
+	struct se_session	*session;
+	struct se_node_acl	se_node_acl;
+};
+
+/* Per-target data for virtual targets */
+struct efct_lio_vport_data_t {
+	struct list_head list_entry;
+	bool initiator_mode;
+	bool target_mode;
+	u64 phy_wwpn;
+	u64 phy_wwnn;
+	u64 vport_wwpn;
+	u64 vport_wwnn;
+	struct efct_lio_vport *lio_vport;
+};
+
+/* Per-target data for virtual targets */
+struct efct_lio_vport_list_t {
+	struct list_head list_entry;
+	struct efct_lio_vport *lio_vport;
+};
+
+/* local prototypes */
+static char *efct_lio_get_npiv_fabric_wwn(struct se_portal_group *);
+static char *efct_lio_get_fabric_wwn(struct se_portal_group *);
+static u16 efct_lio_get_tag(struct se_portal_group *);
+static u16 efct_lio_get_npiv_tag(struct se_portal_group *);
+static int efct_lio_check_demo_mode(struct se_portal_group *);
+static int efct_lio_check_demo_mode_cache(struct se_portal_group *);
+static int efct_lio_check_demo_write_protect(struct se_portal_group *);
+static int efct_lio_check_prod_write_protect(struct se_portal_group *);
+static int efct_lio_npiv_check_demo_write_protect(struct se_portal_group *);
+static int efct_lio_npiv_check_prod_write_protect(struct se_portal_group *);
+static u32 efct_lio_tpg_get_inst_index(struct se_portal_group *);
+static int efct_lio_check_stop_free(struct se_cmd *se_cmd);
+static void efct_lio_aborted_task(struct se_cmd *se_cmd);
+static void efct_lio_release_cmd(struct se_cmd *);
+static void efct_lio_close_session(struct se_session *);
+static u32 efct_lio_sess_get_index(struct se_session *);
+static int efct_lio_write_pending(struct se_cmd *);
+static void efct_lio_set_default_node_attrs(struct se_node_acl *);
+static int efct_lio_get_cmd_state(struct se_cmd *);
+static int efct_lio_queue_data_in(struct se_cmd *);
+static int efct_lio_queue_status(struct se_cmd *);
+static void efct_lio_queue_tm_rsp(struct se_cmd *);
+static struct se_wwn *efct_lio_make_sport(struct target_fabric_configfs *,
+					  struct config_group *, const char *);
+static void efct_lio_drop_sport(struct se_wwn *);
+static void efct_lio_npiv_drop_sport(struct se_wwn *);
+static int efct_lio_parse_wwn(const char *, u64 *, u8 npiv);
+static int efct_lio_parse_npiv_wwn(const char *name, size_t size,
+				   u64 *wwpn, u64 *wwnn);
+static struct se_portal_group *efct_lio_make_tpg(struct se_wwn *,
+						 const char *);
+static struct se_portal_group *efct_lio_npiv_make_tpg(struct se_wwn *,
+						      const char *);
+static void efct_lio_drop_tpg(struct se_portal_group *);
+static struct se_wwn *efct_lio_npiv_make_sport(struct target_fabric_configfs *,
+					       struct config_group *,
+					       const char *);
+static int
+efct_lio_parse_npiv_wwn(const char *name, size_t size, u64 *wwpn, u64 *wwnn);
+static void efct_lio_npiv_drop_tpg(struct se_portal_group *);
+static int efct_lio_async_worker(struct efct_s *efct);
+static void efct_lio_sg_unmap(struct efct_io_s *io);
+static int efct_lio_abort_tgt_cb(struct efct_io_s *io,
+				 enum efct_scsi_io_status_e scsi_status,
+				    u32 flags, void *arg);
+
+static int efct_lio_init_nodeacl(struct se_node_acl *, const char *);
+
+static int efct_lio_check_demo_mode_login_only(struct se_portal_group *);
+static int efct_lio_npiv_check_demo_mode_login_only(struct se_portal_group *);
+
+/* Start items for efct_lio_tpg_attrib_cit */
+
+#define DEF_EFCT_TPG_ATTRIB(name)					  \
+									  \
+static ssize_t efct_lio_tpg_attrib_##name##_show(			  \
+		struct config_item *item, char *page)			  \
+{									  \
+	struct se_portal_group *se_tpg = to_tpg(item);			  \
+	struct efct_lio_tpg *tpg = container_of(se_tpg,			  \
+			struct efct_lio_tpg, tpg);			  \
+									  \
+	return sprintf(page, "%u\n", tpg->tpg_attrib.name);		  \
+}									  \
+									  \
+static ssize_t efct_lio_tpg_attrib_##name##_store(			  \
+		struct config_item *item, const char *page, size_t count) \
+{									  \
+	struct se_portal_group *se_tpg = to_tpg(item);			  \
+	struct efct_lio_tpg *tpg = container_of(se_tpg,			  \
+					struct efct_lio_tpg, tpg);	  \
+	struct efct_lio_tpg_attrib *a = &tpg->tpg_attrib;		  \
+	unsigned long val;						  \
+	int ret;							  \
+									  \
+	ret = kstrtoul(page, 0, &val);					  \
+	if (ret < 0) {							  \
+		pr_err("kstrtoul() failed with ret: %d\n", ret);	  \
+		return -EINVAL;						  \
+	}								  \
+									  \
+	if (val != 0 && val != 1) {					  \
+		pr_err("Illegal boolean value %lu\n", val);		  \
+		return -EINVAL;						  \
+	}								  \
+									  \
+	a->name = val;							  \
+									  \
+	return count;							  \
+}									  \
+CONFIGFS_ATTR(efct_lio_tpg_attrib_, name)
+
+DEF_EFCT_TPG_ATTRIB(generate_node_acls);
+DEF_EFCT_TPG_ATTRIB(cache_dynamic_acls);
+DEF_EFCT_TPG_ATTRIB(demo_mode_write_protect);
+DEF_EFCT_TPG_ATTRIB(prod_mode_write_protect);
+DEF_EFCT_TPG_ATTRIB(demo_mode_login_only);
+DEF_EFCT_TPG_ATTRIB(session_deletion_wait);
+
+static struct configfs_attribute *efct_lio_tpg_attrib_attrs[] = {
+	&efct_lio_tpg_attrib_attr_generate_node_acls,
+	&efct_lio_tpg_attrib_attr_cache_dynamic_acls,
+	&efct_lio_tpg_attrib_attr_demo_mode_write_protect,
+	&efct_lio_tpg_attrib_attr_prod_mode_write_protect,
+	&efct_lio_tpg_attrib_attr_demo_mode_login_only,
+	&efct_lio_tpg_attrib_attr_session_deletion_wait,
+	NULL,
+};
+
+#define DEF_EFCT_NPIV_TPG_ATTRIB(name)					   \
+									   \
+static ssize_t efct_lio_npiv_tpg_attrib_##name##_show(			   \
+		struct config_item *item, char *page)			   \
+{									   \
+	struct se_portal_group *se_tpg = to_tpg(item);			   \
+	struct efct_lio_tpg *tpg = container_of(se_tpg,			   \
+			struct efct_lio_tpg, tpg);			   \
+									   \
+	return sprintf(page, "%u\n", tpg->tpg_attrib.name);		   \
+}									   \
+									   \
+static ssize_t efct_lio_npiv_tpg_attrib_##name##_store(			   \
+		struct config_item *item, const char *page, size_t count)  \
+{									   \
+	struct se_portal_group *se_tpg = to_tpg(item);			   \
+	struct efct_lio_tpg *tpg = container_of(se_tpg,			   \
+			struct efct_lio_tpg, tpg);			   \
+	struct efct_lio_tpg_attrib *a = &tpg->tpg_attrib;		   \
+	unsigned long val;						   \
+	int ret;							   \
+									   \
+	ret = kstrtoul(page, 0, &val);					   \
+	if (ret < 0) {							   \
+		pr_err("kstrtoul() failed with ret: %d\n", ret);	   \
+		return -EINVAL;						   \
+	}								   \
+									   \
+	if (val != 0 && val != 1) {					   \
+		pr_err("Illegal boolean value %lu\n", val);		   \
+		return -EINVAL;						   \
+	}								   \
+									   \
+	a->name = val;							   \
+									   \
+	return count;							   \
+}									   \
+CONFIGFS_ATTR(efct_lio_npiv_tpg_attrib_, name)
+
+DEF_EFCT_NPIV_TPG_ATTRIB(generate_node_acls);
+DEF_EFCT_NPIV_TPG_ATTRIB(cache_dynamic_acls);
+DEF_EFCT_NPIV_TPG_ATTRIB(demo_mode_write_protect);
+DEF_EFCT_NPIV_TPG_ATTRIB(prod_mode_write_protect);
+DEF_EFCT_NPIV_TPG_ATTRIB(demo_mode_login_only);
+DEF_EFCT_NPIV_TPG_ATTRIB(session_deletion_wait);
+
+static struct configfs_attribute *efct_lio_npiv_tpg_attrib_attrs[] = {
+	&efct_lio_npiv_tpg_attrib_attr_generate_node_acls,
+	&efct_lio_npiv_tpg_attrib_attr_cache_dynamic_acls,
+	&efct_lio_npiv_tpg_attrib_attr_demo_mode_write_protect,
+	&efct_lio_npiv_tpg_attrib_attr_prod_mode_write_protect,
+	&efct_lio_npiv_tpg_attrib_attr_demo_mode_login_only,
+	&efct_lio_npiv_tpg_attrib_attr_session_deletion_wait,
+	NULL,
+};
+
+static ssize_t
+efct_lio_wwn_version_show(struct config_item *item, char *page)
+{
+	return sprintf(page, "Emulex EFCT fabric module version %s\n",
+		       __stringify(EFCT_LIO_VERSION));
+}
+
+CONFIGFS_ATTR_RO(efct_lio_wwn_, version);
+static struct configfs_attribute *efct_lio_wwn_attrs[] = {
+			&efct_lio_wwn_attr_version, NULL };
+
+static ssize_t
+efct_lio_tpg_enable_show(struct config_item *item, char *page)
+{
+	struct se_portal_group *se_tpg = to_tpg(item);
+	struct efct_lio_tpg *tpg = container_of(se_tpg,
+						struct efct_lio_tpg, tpg);
+
+	return snprintf(page, PAGE_SIZE, "%d\n", atomic_read(&tpg->enabled));
+}
+
+static ssize_t
+efct_lio_tpg_enable_store(struct config_item *item, const char *page,
+			  size_t count)
+{
+	struct se_portal_group *se_tpg = to_tpg(item);
+	struct efct_lio_tpg *tpg = container_of(se_tpg,
+						struct efct_lio_tpg, tpg);
+	unsigned long op;
+	int ret;
+	struct efct_s *efct;
+	struct efc_lport *efc;
+
+	if (!tpg->sport || !tpg->sport->efct) {
+		pr_err("%s: Unable to find EFCT device\n", __func__);
+		return -EINVAL;
+	}
+
+	efct = tpg->sport->efct;
+	efc = efct->efcport;
+
+	if (kstrtoul(page, 0, &op) < 0)
+		return -EINVAL;
+	if (op == 1) {
+		atomic_set(&tpg->enabled, 1);
+		efc_log_debug(efct, "enable portal group %d\n", tpg->tpgt);
+
+		ret = efct_xport_control(efct->xport, EFCT_XPORT_PORT_ONLINE);
+		if (ret) {
+			efct->tgt_efct.lio_sport = NULL;
+			efc_log_test(efct, "cannot bring port online\n");
+			return ret;
+		}
+
+	} else if (op == 0) {
+		efc_log_debug(efct, "disable portal group %d\n", tpg->tpgt);
+
+		if (efc->domain && efc->domain->sport)
+			efct_scsi_tgt_del_sport(efc, efc->domain->sport);
+
+		atomic_set(&tpg->enabled, 0);
+	} else {
+		return -EINVAL;
+	}
+	return count;
+}
+
+static ssize_t
+efct_lio_npiv_tpg_enable_show(struct config_item *item, char *page)
+{
+	struct se_portal_group *se_tpg = to_tpg(item);
+	struct efct_lio_tpg *tpg = container_of(se_tpg,
+						struct efct_lio_tpg, tpg);
+
+	return snprintf(page, PAGE_SIZE, "%d\n", atomic_read(&tpg->enabled));
+}
+
+static ssize_t
+efct_lio_npiv_tpg_enable_store(struct config_item *item, const char *page,
+			       size_t count)
+{
+	struct se_portal_group *se_tpg = to_tpg(item);
+	struct efct_lio_tpg *tpg = container_of(se_tpg,
+						struct efct_lio_tpg, tpg);
+	unsigned long op;
+	struct efct_lio_vport *lio_vport = tpg->vport;
+	struct efct_lio_vport_data_t *vport_data;
+	int ret = -1;
+	struct efct_s *efct;
+	struct efc_lport *efc;
+	unsigned long flags = 0;
+
+	if (kstrtoul(page, 0, &op) < 0)
+		return -EINVAL;
+
+	if (!lio_vport) {
+		pr_err("Unable to find vport\n");
+		return -EINVAL;
+	}
+	efct = lio_vport->efct;
+	efc = efct->efcport;
+
+	if (op == 1) {
+		atomic_set(&tpg->enabled, 1);
+		efc_log_debug(efct, "enable portal group %d\n", tpg->tpgt);
+
+		if (efc->domain) {
+			ret = efc_sport_vport_new(efc->domain,
+						  lio_vport->npiv_wwpn,
+						  lio_vport->npiv_wwnn,
+						  U32_MAX, false, true,
+						  NULL, NULL, true);
+			if (ret != 0) {
+				efc_log_err(efct, "Failed to create Vport\n");
+				return ret;
+			}
+			return count;
+		}
+
+		vport_data = kmalloc(sizeof(*vport_data), GFP_KERNEL);
+		if (!vport_data)
+			return ret;
+
+		memset(vport_data, 0, sizeof(struct efct_lio_vport_data_t));
+		vport_data->phy_wwpn            = lio_vport->wwpn;
+		vport_data->vport_wwpn          = lio_vport->npiv_wwpn;
+		vport_data->vport_wwnn          = lio_vport->npiv_wwnn;
+		vport_data->target_mode         = 1;
+		vport_data->initiator_mode      = 0;
+		vport_data->lio_vport           = lio_vport;
+
+		/* There is no domain.  Add to pending list. When the
+		 * domain is created, the driver will create the vport.
+		 */
+		efc_log_test(efct, "link down, move to pending\n");
+		spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
+		INIT_LIST_HEAD(&vport_data->list_entry);
+		list_add_tail(&vport_data->list_entry,
+			      &efct->tgt_efct.vport_pending_enable_list);
+		spin_unlock_irqrestore(&efct->tgt_efct.efct_lio_lock,
+				       flags);
+
+	} else if (op == 0) {
+		struct efct_lio_vport_data_t *virt_target_data, *next;
+
+		efc_log_debug(efct, "disable portal group %d\n", tpg->tpgt);
+
+		atomic_set(&tpg->enabled, 0);
+		/* only physical sport should exist, free lio_sport
+		 * allocated in efct_lio_make_sport
+		 */
+		if (efc->domain) {
+			efc_sport_vport_del(efct->efcport, efc->domain,
+					    lio_vport->npiv_wwpn,
+					    lio_vport->npiv_wwnn);
+		} else {
+			spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
+			list_for_each_entry_safe(virt_target_data, next,
+				&efct->tgt_efct.vport_pending_enable_list,
+				list_entry) {
+				if (virt_target_data->lio_vport == lio_vport) {
+					list_del(&virt_target_data->list_entry);
+					kfree(virt_target_data);
+					break;
+				}
+			}
+			spin_unlock_irqrestore(&efct->tgt_efct.efct_lio_lock,
+					       flags);
+		}
+	} else {
+		return -EINVAL;
+	}
+	return count;
+}
+
+CONFIGFS_ATTR(efct_lio_tpg_, enable);
+static struct configfs_attribute *efct_lio_tpg_attrs[] = {
+				&efct_lio_tpg_attr_enable, NULL };
+CONFIGFS_ATTR(efct_lio_npiv_tpg_, enable);
+static struct configfs_attribute *efct_lio_npiv_tpg_attrs[] = {
+				&efct_lio_npiv_tpg_attr_enable, NULL };
+
+static struct efct_lio_tpg *
+efct_get_vport_tpg(struct efc_node_s *node)
+{
+	struct efct_s *efct;
+	u64 wwpn = node->sport->wwpn;
+	struct efct_lio_vport_list_t *vport, *next;
+	struct efct_lio_vport *lio_vport = NULL;
+	struct efct_lio_tpg *tpg = NULL;
+	unsigned long flags = 0;
+
+	efct = node->efc->base;
+	spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
+		list_for_each_entry_safe(vport, next,
+				 &efct->tgt_efct.vport_list, list_entry) {
+			lio_vport = vport->lio_vport;
+			if (wwpn && lio_vport &&
+			    lio_vport->npiv_wwpn == wwpn) {
+				efc_log_test(efct, "found tpg on vport\n");
+				tpg = lio_vport->tpg;
+				break;
+			}
+		}
+	spin_unlock_irqrestore(&efct->tgt_efct.efct_lio_lock, flags);
+	return tpg;
+}
+
+/* local static data */
+static const struct target_core_fabric_ops efct_lio_ops = {
+	.fabric_name			= FABRIC_NAME,
+	.module				= THIS_MODULE,
+	.node_acl_size			= sizeof(struct efct_lio_nacl),
+	.max_data_sg_nents		= 65535,
+	.tpg_get_wwn			= efct_lio_get_fabric_wwn,
+	.tpg_get_tag			= efct_lio_get_tag,
+	.fabric_init_nodeacl		= efct_lio_init_nodeacl,
+	.tpg_check_demo_mode		= efct_lio_check_demo_mode,
+	.tpg_check_demo_mode_cache      = efct_lio_check_demo_mode_cache,
+	.tpg_check_demo_mode_write_protect = efct_lio_check_demo_write_protect,
+	.tpg_check_prod_mode_write_protect = efct_lio_check_prod_write_protect,
+	.tpg_get_inst_index		= efct_lio_tpg_get_inst_index,
+	.check_stop_free		= efct_lio_check_stop_free,
+	.aborted_task			= efct_lio_aborted_task,
+	.release_cmd			= efct_lio_release_cmd,
+	.close_session			= efct_lio_close_session,
+	.sess_get_index			= efct_lio_sess_get_index,
+	.write_pending			= efct_lio_write_pending,
+	.set_default_node_attributes	= efct_lio_set_default_node_attrs,
+	.get_cmd_state			= efct_lio_get_cmd_state,
+	.queue_data_in			= efct_lio_queue_data_in,
+	.queue_status			= efct_lio_queue_status,
+	.queue_tm_rsp			= efct_lio_queue_tm_rsp,
+	.fabric_make_wwn		= efct_lio_make_sport,
+	.fabric_drop_wwn		= efct_lio_drop_sport,
+	.fabric_make_tpg		= efct_lio_make_tpg,
+	.fabric_drop_tpg		= efct_lio_drop_tpg,
+	.tpg_check_demo_mode_login_only = efct_lio_check_demo_mode_login_only,
+	.tpg_check_prot_fabric_only	= NULL,
+	.sess_get_initiator_sid		= NULL,
+	.tfc_wwn_attrs			= efct_lio_wwn_attrs,
+	.tfc_tpg_base_attrs		= efct_lio_tpg_attrs,
+	.tfc_tpg_attrib_attrs           = efct_lio_tpg_attrib_attrs,
+};
+
+/* local static data */
+static const struct target_core_fabric_ops efct_lio_npiv_ops = {
+	.fabric_name			= FABRIC_NAME_NPIV,
+	.module				= THIS_MODULE,
+	.node_acl_size			= sizeof(struct efct_lio_nacl),
+	.max_data_sg_nents		= 65535,
+	.tpg_get_wwn			= efct_lio_get_npiv_fabric_wwn,
+	.tpg_get_tag			= efct_lio_get_npiv_tag,
+	.fabric_init_nodeacl		= efct_lio_init_nodeacl,
+	.tpg_check_demo_mode		= efct_lio_check_demo_mode,
+	.tpg_check_demo_mode_cache      = efct_lio_check_demo_mode_cache,
+	.tpg_check_demo_mode_write_protect =
+					efct_lio_npiv_check_demo_write_protect,
+	.tpg_check_prod_mode_write_protect =
+					efct_lio_npiv_check_prod_write_protect,
+	.tpg_get_inst_index		= efct_lio_tpg_get_inst_index,
+	.check_stop_free		= efct_lio_check_stop_free,
+	.aborted_task			= efct_lio_aborted_task,
+	.release_cmd			= efct_lio_release_cmd,
+	.close_session			= efct_lio_close_session,
+	.sess_get_index			= efct_lio_sess_get_index,
+	.write_pending			= efct_lio_write_pending,
+	.set_default_node_attributes	= efct_lio_set_default_node_attrs,
+	.get_cmd_state			= efct_lio_get_cmd_state,
+	.queue_data_in			= efct_lio_queue_data_in,
+	.queue_status			= efct_lio_queue_status,
+	.queue_tm_rsp			= efct_lio_queue_tm_rsp,
+	.fabric_make_wwn		= efct_lio_npiv_make_sport,
+	.fabric_drop_wwn		= efct_lio_npiv_drop_sport,
+	.fabric_make_tpg		= efct_lio_npiv_make_tpg,
+	.fabric_drop_tpg		= efct_lio_npiv_drop_tpg,
+	.tpg_check_demo_mode_login_only =
+				efct_lio_npiv_check_demo_mode_login_only,
+	.tpg_check_prot_fabric_only	= NULL,
+	.sess_get_initiator_sid		= NULL,
+	.tfc_wwn_attrs			= efct_lio_wwn_attrs,
+	.tfc_tpg_base_attrs		= efct_lio_npiv_tpg_attrs,
+	.tfc_tpg_attrib_attrs		= efct_lio_npiv_tpg_attrib_attrs,
+};
+
+static struct target_fabric_configfs *fabric;
+static struct target_fabric_configfs *npiv_fabric;
+
+#define LIO_IOFMT "[%04x][i:%0*x t:%0*x h:%04x][c:%02x]"
+#define LIO_TMFIOFMT "[%04x][i:%0*x t:%0*x h:%04x][f:%02x]"
+#define LIO_IOFMT_ITT_SIZE(efct)	4
+
+#define efct_lio_io_printf(io, fmt, ...) \
+	efc_log_debug(io->efct, "[%s]" LIO_IOFMT " " fmt,	\
+	io->node->display_name, io->instance_index,		\
+	LIO_IOFMT_ITT_SIZE(io->efct), io->init_task_tag,		\
+	LIO_IOFMT_ITT_SIZE(io->efct), io->tgt_task_tag, io->hw_tag,\
+	(io->tgt_io.cdb ? io->tgt_io.cdb[0] : 0xFF), ##__VA_ARGS__)
+#define efct_lio_tmfio_printf(io, fmt, ...) \
+	efc_log_debug(io->efct, "[%s]" LIO_TMFIOFMT " " fmt,\
+	io->node->display_name, io->instance_index,		\
+	LIO_IOFMT_ITT_SIZE(io->efct), io->init_task_tag,		\
+	LIO_IOFMT_ITT_SIZE(io->efct), io->tgt_task_tag, io->hw_tag,\
+	io->tgt_io.tmf,  ##__VA_ARGS__)
+
+#define efct_lio_io_trace(io, fmt, ...)					\
+	do {								\
+		if (EFCT_LOG_ENABLE_LIO_IO_TRACE(io->efct))		\
+			efct_lio_io_printf(io, fmt, ##__VA_ARGS__);	\
+	} while (0)
+
+#define api_trace(efct)							\
+	do {								\
+		if (EFCT_LOG_ENABLE_LIO_TRACE(efct))			\
+			efc_log_debug(efct, "*****\n");		\
+	} while (0)
+
+#define efct_lio_io_state_trace(io, value) (io->tgt_io.state |= value)
+
+/* Check if node is with valid initiator NPORT ID or not */
+
+static bool efct_lio_node_is_initiator(struct efc_node_s *node)
+{
+	if (!node)
+		return 0;
+	if (node->rnode.fc_id && node->rnode.fc_id != FC_FID_FLOGI &&
+	    node->rnode.fc_id != FC_FID_DIR_SERV &&
+	    node->rnode.fc_id != FC_FID_FCTRL) {
+		return 1;
+	}
+
+	return 0;
+}
+
+static int  efct_lio_tgt_session_data(struct efct_s *efct, u64 wwpn,
+				      char *buf, int size)
+{
+	struct efc_sli_port_s *sport = NULL;
+	struct efc_node_s *node = NULL;
+	struct efc_lport *efc = efct->efcport;
+	u16 loop_id = 0;
+	int off = 0, rc = 0;
+
+	if (!efc->domain) {
+		efc_log_err(efct, "failed to find efct/domain\n");
+		return -1;
+	}
+
+	list_for_each_entry(sport, &efc->domain->sport_list, list_entry) {
+		if (sport->wwpn == wwpn) {
+			list_for_each_entry(node, &sport->node_list,
+					    list_entry) {
+				/* Dump sessions only remote NPORT
+				 * sessions
+				 */
+				if (efct_lio_node_is_initiator(node)) {
+					rc = snprintf(buf + off,
+						      size - off,
+						"0x%016llx,0x%08x,0x%04x\n",
+						be64_to_cpup((__force __be64 *)
+								node->wwpn),
+						node->rnode.fc_id,
+						loop_id);
+					if (rc < 0)
+						break;
+					off += rc;
+				}
+			}
+		}
+	}
+
+	buf[size - 1] = '\0';
+	return 0;
+}
+
+static int efct_debugfs_session_open(struct inode *inode, struct file *filp)
+{
+	struct efct_lio_sport *sport = inode->i_private;
+	int size = 17 * PAGE_SIZE; /* > 34 byte per session*2048 sessions */
+
+	if (!(filp->f_mode & FMODE_READ)) {
+		filp->private_data = sport;
+		return 0;
+	}
+
+	filp->private_data = kmalloc(size, GFP_KERNEL);
+	if (!filp->private_data)
+		return -ENOMEM;
+
+	memset(filp->private_data, 0, size);
+	efct_lio_tgt_session_data(sport->efct, sport->wwpn, filp->private_data,
+				  size);
+	return 0;
+}
+
+static int efct_debugfs_session_close(struct inode *inode, struct file *filp)
+{
+	if (filp->f_mode & FMODE_READ)
+		kfree(filp->private_data);
+
+	return 0;
+}
+
+static ssize_t efct_debugfs_session_read(struct file *filp, char __user *buf,
+					 size_t count, loff_t *ppos)
+{
+	if (!(filp->f_mode & FMODE_READ))
+		return -EPERM;
+	return simple_read_from_buffer(buf, count, ppos, filp->private_data,
+				       strlen(filp->private_data));
+}
+
+static int efct_npiv_debugfs_session_open(struct inode *inode,
+					  struct file *filp)
+{
+	struct efct_lio_vport *sport = inode->i_private;
+	int size = 17 * PAGE_SIZE; /* > 34 byte per session*2048 sessions */
+
+	if (!(filp->f_mode & FMODE_READ)) {
+		filp->private_data = sport;
+		return 0;
+	}
+
+	filp->private_data = kmalloc(size, GFP_KERNEL);
+	if (!filp->private_data)
+		return -ENOMEM;
+
+	memset(filp->private_data, 0, size);
+	efct_lio_tgt_session_data(sport->efct, sport->npiv_wwpn,
+				  filp->private_data, size);
+	return 0;
+}
+
+static ssize_t efct_debugfs_session_write(struct file *filp,
+					  const char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	return 0;
+}
+
+static const struct file_operations efct_debugfs_session_fops = {
+	.owner		= THIS_MODULE,
+	.open		= efct_debugfs_session_open,
+	.release	= efct_debugfs_session_close,
+	.read		= efct_debugfs_session_read,
+	.write		= efct_debugfs_session_write,
+	.llseek		= default_llseek,
+};
+
+static const struct file_operations efct_npiv_debugfs_session_fops = {
+	.owner		= THIS_MODULE,
+	.open		= efct_npiv_debugfs_session_open,
+	.release	= efct_debugfs_session_close,
+	.read		= efct_debugfs_session_read,
+	.write		= efct_debugfs_session_write,
+	.llseek		= default_llseek,
+};
+
+static char *efct_lio_get_fabric_wwn(struct se_portal_group *se_tpg)
+{
+	struct efct_lio_tpg *tpg = container_of(se_tpg,
+						struct efct_lio_tpg, tpg);
+
+	return tpg->sport->wwpn_str;
+}
+
+static char *efct_lio_get_npiv_fabric_wwn(struct se_portal_group *se_tpg)
+{
+	struct efct_lio_tpg *tpg = container_of(se_tpg,
+						struct efct_lio_tpg, tpg);
+
+	return tpg->vport->wwpn_str;
+}
+
+static u16 efct_lio_get_tag(struct se_portal_group *se_tpg)
+{
+	struct efct_lio_tpg *tpg = container_of(se_tpg,
+						struct efct_lio_tpg, tpg);
+
+	return tpg->tpgt;
+}
+
+static u16 efct_lio_get_npiv_tag(struct se_portal_group *se_tpg)
+{
+	struct efct_lio_tpg *tpg = container_of(se_tpg,
+						struct efct_lio_tpg, tpg);
+
+	return tpg->tpgt;
+}
+
+static int efct_lio_check_demo_mode(struct se_portal_group *se_tpg)
+{
+	return 1;
+}
+
+static int efct_lio_check_demo_mode_cache(struct se_portal_group *se_tpg)
+{
+	return 1;
+}
+
+static int efct_lio_check_demo_write_protect(struct se_portal_group *se_tpg)
+{
+	struct efct_lio_tpg *tpg = container_of(se_tpg,
+						struct efct_lio_tpg, tpg);
+
+	return tpg->tpg_attrib.demo_mode_write_protect;
+}
+
+static int
+efct_lio_npiv_check_demo_write_protect(struct se_portal_group *se_tpg)
+{
+	struct efct_lio_tpg *tpg = container_of(se_tpg,
+						struct efct_lio_tpg, tpg);
+
+	return tpg->tpg_attrib.demo_mode_write_protect;
+}
+
+static int efct_lio_check_prod_write_protect(struct se_portal_group *se_tpg)
+{
+	struct efct_lio_tpg *tpg = container_of(se_tpg,
+						struct efct_lio_tpg, tpg);
+
+	return tpg->tpg_attrib.prod_mode_write_protect;
+}
+
+static int
+efct_lio_npiv_check_prod_write_protect(struct se_portal_group *se_tpg)
+{
+	struct efct_lio_tpg *tpg = container_of(se_tpg,
+						struct efct_lio_tpg, tpg);
+
+	return tpg->tpg_attrib.prod_mode_write_protect;
+}
+
+static u32 efct_lio_tpg_get_inst_index(struct se_portal_group *se_tpg)
+{
+	return 0;
+}
+
+/* This function is called by LIO so the fabric driver can "ACK"
+ * when LIO performs transport_cmd_check_stop(). This is done to
+ * avoid a race between 1. the call to transport_generic_free_cmd()
+ * (after posting of a response -- .queue_status()) and 2. the
+ * accounting/cleanup of the se_cmd in transport_cmd_check_stop()
+ * itself.
+ * See TARGET_SCF_ACK_KREF for more details.
+ */
+static int efct_lio_check_stop_free(struct se_cmd *se_cmd)
+{
+	struct efct_scsi_tgt_io_s *ocp = container_of(se_cmd,
+						     struct efct_scsi_tgt_io_s,
+						     cmd);
+	struct efct_io_s *io = container_of(ocp, struct efct_io_s, tgt_io);
+
+	efct_lio_io_trace(io, "%s\n", __func__);
+	efct_lio_io_state_trace(io, EFCT_LIO_STATE_TFO_CHK_STOP_FREE);
+	return target_put_sess_cmd(se_cmd);
+}
+
+/* command has been aborted, cleanup here */
+static void efct_lio_aborted_task(struct se_cmd *se_cmd)
+{
+	int rc;
+	struct efct_scsi_tgt_io_s *ocp = container_of(se_cmd,
+						     struct efct_scsi_tgt_io_s,
+						     cmd);
+	struct efct_io_s *io = container_of(ocp, struct efct_io_s, tgt_io);
+
+	efct_lio_io_trace(io, "%s\n", __func__);
+	efct_lio_io_state_trace(io, EFCT_LIO_STATE_TFO_ABORTED_TASK);
+
+	if (!(se_cmd->transport_state & CMD_T_ABORTED) || ocp->rsp_sent)
+		return;
+
+	/*
+	 * if io is non-null, take a reference out on it so it isn't
+	 * freed until the abort operation is complete.
+	 */
+	if (kref_get_unless_zero(&io->ref) == 0) {
+		/* command no longer active */
+		struct efct_s *efct = io->efct;
+
+		efc_log_test(efct,
+			      "success: command no longer active (exists=%d)\n",
+			     (io != NULL));
+		return;
+	}
+
+	efct_lio_io_printf(io, "CMD_T_ABORTED set, aborting=%d\n",
+			   ocp->aborting);
+	ocp->aborting = true;
+	/* set to non-success so data moves won't continue */
+	ocp->err = EFCT_SCSI_STATUS_ABORTED;
+
+	/* wait until abort is complete; once we return, LIO will call
+	 * queue_tm_rsp() which will send response to TMF
+	 */
+	init_completion(&io->tgt_io.done);
+
+	rc = efct_scsi_tgt_abort_io(io, efct_lio_abort_tgt_cb, NULL);
+	if (rc == 0) {
+		/* wait for abort to complete before returning */
+		rc = wait_for_completion_timeout(&io->tgt_io.done,
+						 usecs_to_jiffies(10000000));
+
+		/* done with reference on aborted IO */
+		kref_put(&io->ref, io->release);
+
+		if (rc) {
+			efct_lio_io_printf(io,
+					   "abort completed successfully\n");
+			/* check if TASK_ABORTED status should be sent
+			 * for this IO
+			 */
+		} else {
+			efct_lio_io_printf(io,
+					   "timeout waiting for abort completed\n");
+		}
+	} else {
+		efct_lio_io_printf(io, "Failed to abort\n");
+	}
+}
+
+/* called when se_cmd's ref count goes to 0 */
+static void efct_lio_release_cmd(struct se_cmd *se_cmd)
+{
+	struct efct_scsi_tgt_io_s *ocp = container_of(se_cmd,
+						     struct efct_scsi_tgt_io_s,
+						     cmd);
+	struct efct_io_s *io = container_of(ocp, struct efct_io_s, tgt_io);
+	struct efct_s *efct = io->efct;
+
+	efct_lio_io_state_trace(io, EFCT_LIO_STATE_TFO_RELEASE_CMD);
+	efct_lio_io_trace(io, "%s\n", __func__);
+	efct_scsi_io_complete(io);
+	atomic_sub_return(1, &efct->tgt_efct.ios_in_use);
+	efct_lio_io_state_trace(io, EFCT_LIO_STATE_SCSI_CMPL_CMD);
+}
+
+static void efct_lio_close_session(struct se_session *se_sess)
+{
+	struct efc_node_s *node = se_sess->fabric_sess_ptr;
+	struct efct_s *efct = NULL;
+	int rc;
+
+	pr_debug("se_sess=%p node=%p", se_sess, node);
+
+	if (node) {
+		efct = node->efc->base;
+		rc = efct_xport_control(efct->xport,
+					EFCT_XPORT_POST_NODE_EVENT, node,
+			EFCT_XPORT_SHUTDOWN, NULL);
+		if (rc != 0) {
+			efc_log_test(efct,
+				      "Failed to shutdown session %p node %p\n",
+				     se_sess, node);
+			return;
+		}
+
+	} else {
+		pr_debug("node is NULL");
+	}
+}
+
+static u32 efct_lio_sess_get_index(struct se_session *se_sess)
+{
+	return 0;
+}
+
+static void efct_lio_set_default_node_attrs(struct se_node_acl *nacl)
+{
+}
+
+static int efct_lio_get_cmd_state(struct se_cmd *se_cmd)
+{
+	return 0;
+}
+
+/**
+ * @brief Housekeeping for LIO SG mapping.
+ *
+ * @param io Pointer to IO context.
+ *
+ * @return count Count returned by pci_map_sg.
+ */
+static int
+efct_lio_sg_map(struct efct_io_s *io)
+{
+	struct efct_scsi_tgt_io_s *ocp = &io->tgt_io;
+	struct se_cmd *cmd = &ocp->cmd;
+
+	ocp->seg_map_cnt = pci_map_sg(io->efct->pcidev, cmd->t_data_sg,
+				      cmd->t_data_nents, cmd->data_direction);
+	if (ocp->seg_map_cnt == 0)
+		return -EFAULT;
+	return 0;
+}
+
+/**
+ * @brief Housekeeping for LIO SG unmapping.
+ *
+ * @param io Pointer to IO context.
+ *
+ * @return None.
+ */
+static void
+efct_lio_sg_unmap(struct efct_io_s *io)
+{
+	struct efct_scsi_tgt_io_s *ocp = &io->tgt_io;
+	struct se_cmd *cmd = &ocp->cmd;
+
+	efct_lio_io_trace(io, "%s\n", __func__);
+	if (WARN_ON(!ocp->seg_map_cnt || !cmd->t_data_sg))
+		return;
+
+	pci_unmap_sg(io->efct->pcidev, cmd->t_data_sg,
+		     ocp->seg_map_cnt, cmd->data_direction);
+	ocp->seg_map_cnt = 0;
+}
+
+static int
+efct_lio_status_done(struct efct_io_s *io,
+		     enum efct_scsi_io_status_e scsi_status,
+		     u32 flags, void *arg)
+{
+	struct efct_scsi_tgt_io_s *ocp = &io->tgt_io;
+
+	efct_lio_io_state_trace(io, EFCT_LIO_STATE_SCSI_RSP_DONE);
+	if (scsi_status != EFCT_SCSI_STATUS_GOOD) {
+		efct_lio_io_printf(io, "callback completed with error=%d\n",
+				   scsi_status);
+		ocp->err = scsi_status;
+	}
+	if (ocp->seg_map_cnt)
+		efct_lio_sg_unmap(io);
+
+	efct_lio_io_trace(io, "status=%d, err=%d flags=0x%x, dir=%d\n",
+			  scsi_status, ocp->err, flags, ocp->ddir);
+
+	transport_generic_free_cmd(&io->tgt_io.cmd, 0);
+	efct_lio_io_state_trace(io, EFCT_LIO_STATE_TGT_GENERIC_FREE);
+	return 0;
+}
+
+static int
+efct_lio_datamove_done(struct efct_io_s *io,
+		       enum efct_scsi_io_status_e scsi_status,
+		      u32 flags, void *arg)
+{
+	struct efct_scsi_tgt_io_s *ocp = &io->tgt_io;
+	struct se_cmd *cmd = &io->tgt_io.cmd;
+	int rc;
+
+	efct_lio_io_state_trace(io, EFCT_LIO_STATE_SCSI_DATA_DONE);
+	if (scsi_status != EFCT_SCSI_STATUS_GOOD) {
+		efct_lio_io_printf(io, "callback completed with error=%d\n",
+				   scsi_status);
+		ocp->err = scsi_status;
+	}
+	efct_lio_io_trace(io, "seg_map_cnt=%d\n", ocp->seg_map_cnt);
+	if (ocp->seg_map_cnt) {
+		if (ocp->err == EFCT_SCSI_STATUS_GOOD &&
+		    ocp->cur_seg < ocp->seg_cnt) {
+			efct_lio_io_trace(io, "continuing cmd at segm=%d\n",
+					  ocp->cur_seg);
+			if (ocp->ddir == DDIR_FROM_INITIATOR)
+				rc = efct_lio_write_pending(&ocp->cmd);
+			else
+				rc = efct_lio_queue_data_in(&ocp->cmd);
+			if (rc == 0)
+				return 0;
+			ocp->err = EFCT_SCSI_STATUS_ERROR;
+			efct_lio_io_printf(io, "could not continue command\n");
+		}
+		efct_lio_sg_unmap(io);
+	}
+
+	if (io->tgt_io.aborting) {
+		/* If this command is in the process of being aborted,
+		 * free here; I/O will be completed when abort is complete
+		 * (kref taken for abort)
+		 */
+		efct_lio_io_printf(io, "IO done aborted\n");
+		return 0;
+	}
+
+	if (ocp->ddir == DDIR_FROM_INITIATOR) {
+		efct_lio_io_trace(io, "Write done, trans_state=0x%x\n",
+				  io->tgt_io.cmd.transport_state);
+		if (scsi_status != EFCT_SCSI_STATUS_GOOD) {
+			transport_generic_request_failure(&io->tgt_io.cmd,
+					TCM_CHECK_CONDITION_ABORT_CMD);
+			efct_lio_io_state_trace(io,
+				EFCT_LIO_STATE_TGT_GENERIC_REQ_FAILURE);
+		} else {
+			efct_lio_io_state_trace(io,
+						EFCT_LIO_STATE_TGT_EXECUTE_CMD);
+			target_execute_cmd(&io->tgt_io.cmd);
+		}
+	} else {
+		if ((flags & EFCT_SCSI_IO_CMPL_RSP_SENT) == 0) {
+			struct efct_scsi_cmd_resp_s rsp;
+			/* send check condition if an error occurred */
+			memset(&rsp, 0, sizeof(rsp));
+			rsp.scsi_status = cmd->scsi_status;
+			rsp.sense_data = (uint8_t *)io->tgt_io.sense_buffer;
+			rsp.sense_data_length = cmd->scsi_sense_length;
+
+			/* Check for residual underrun or overrun */
+			if (cmd->se_cmd_flags & SCF_OVERFLOW_BIT)
+				rsp.residual = -cmd->residual_count;
+			else if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT)
+				rsp.residual = cmd->residual_count;
+
+			rc = efct_scsi_send_resp(io, 0, &rsp,
+						 efct_lio_status_done, NULL);
+			efct_lio_io_state_trace(io,
+						EFCT_LIO_STATE_SCSI_SEND_RSP);
+			if (rc != 0) {
+				efct_lio_io_printf(io,
+						   "Read done, failed to send rsp, rc=%d\n",
+				      rc);
+				transport_generic_free_cmd(&io->tgt_io.cmd, 0);
+				efct_lio_io_state_trace(io,
+					EFCT_LIO_STATE_TGT_GENERIC_FREE);
+			} else {
+				ocp->rsp_sent = true;
+			}
+		} else {
+			ocp->rsp_sent = true;
+			transport_generic_free_cmd(&io->tgt_io.cmd, 0);
+			efct_lio_io_state_trace(io,
+					EFCT_LIO_STATE_TGT_GENERIC_FREE);
+		}
+	}
+	return 0;
+}
+
+static int
+efct_lio_tmf_done(struct efct_io_s *io, enum efct_scsi_io_status_e scsi_status,
+		  u32 flags, void *arg)
+{
+	efct_lio_tmfio_printf(io, "cmd=%p status=%d, flags=0x%x\n",
+			      &io->tgt_io.cmd, scsi_status, flags);
+
+	transport_generic_free_cmd(&io->tgt_io.cmd, 0);
+	efct_lio_io_state_trace(io, EFCT_LIO_STATE_TGT_GENERIC_FREE);
+	return 0;
+}
+
+static int
+efct_lio_null_tmf_done(struct efct_io_s *tmfio,
+		       enum efct_scsi_io_status_e scsi_status,
+		      u32 flags, void *arg)
+{
+	efct_lio_tmfio_printf(tmfio, "cmd=%p status=%d, flags=0x%x\n",
+			      &tmfio->tgt_io.cmd, scsi_status, flags);
+
+	/* free struct efct_io_s only, no active se_cmd */
+	efct_scsi_io_complete(tmfio);
+	return 0;
+}
+
+static int
+efct_lio_write_pending(struct se_cmd *cmd)
+{
+	struct efct_scsi_tgt_io_s *ocp = container_of(cmd,
+						     struct efct_scsi_tgt_io_s,
+						     cmd);
+	struct efct_io_s *io = container_of(ocp, struct efct_io_s, tgt_io);
+	struct efct_scsi_sgl_s *sgl = io->sgl;
+	struct scatterlist *sg;
+	u32 flags = 0, cnt, curcnt;
+	u64 length = 0;
+	int rc = 0;
+
+	efct_lio_io_state_trace(io, EFCT_LIO_STATE_TFO_WRITE_PENDING);
+	efct_lio_io_trace(io, "trans_state=0x%x se_cmd_flags=0x%x\n",
+			  cmd->transport_state, cmd->se_cmd_flags);
+
+	if (ocp->seg_cnt == 0) {
+		ocp->seg_cnt = cmd->t_data_nents;
+		ocp->cur_seg = 0;
+		if (efct_lio_sg_map(io)) {
+			efct_lio_io_printf(io, "efct_lio_sg_map failed\n");
+			return -EFAULT;
+		}
+	}
+	curcnt = (ocp->seg_map_cnt - ocp->cur_seg);
+	curcnt = (curcnt < io->sgl_allocated) ? curcnt : io->sgl_allocated;
+	/* find current sg */
+	for (cnt = 0, sg = cmd->t_data_sg; cnt < ocp->cur_seg; cnt++,
+	     sg = sg_next(sg))
+		;
+
+	for (cnt = 0; cnt < curcnt; cnt++, sg = sg_next(sg)) {
+		sgl[cnt].addr = sg_dma_address(sg);
+		sgl[cnt].dif_addr = 0;
+		sgl[cnt].len = sg_dma_len(sg);
+		length += sgl[cnt].len;
+		ocp->cur_seg++;
+	}
+	if (ocp->cur_seg == ocp->seg_cnt)
+		flags = EFCT_SCSI_LAST_DATAPHASE;
+	rc = efct_scsi_recv_wr_data(io, flags, NULL, sgl, curcnt, length,
+				    efct_lio_datamove_done, NULL);
+	return rc;
+}
+
+static int
+efct_lio_queue_data_in(struct se_cmd *cmd)
+{
+	struct efct_scsi_tgt_io_s *ocp = container_of(cmd,
+						     struct efct_scsi_tgt_io_s,
+						     cmd);
+	struct efct_io_s *io = container_of(ocp, struct efct_io_s, tgt_io);
+	struct efct_scsi_sgl_s *sgl = io->sgl;
+	struct scatterlist *sg = NULL;
+	uint flags = 0, cnt = 0, curcnt = 0;
+	u64 length = 0;
+	int rc = 0;
+
+	efct_lio_io_state_trace(io, EFCT_LIO_STATE_TFO_QUEUE_DATA_IN);
+	efct_lio_io_trace(io, "trans_state=0x%x se_cmd_flags=0x%x\n",
+			  cmd->transport_state, cmd->se_cmd_flags);
+
+	if (ocp->seg_cnt == 0) {
+		if (cmd->data_length) {
+			ocp->seg_cnt = cmd->t_data_nents;
+			ocp->cur_seg = 0;
+			if (efct_lio_sg_map(io)) {
+				efct_lio_io_printf(io,
+						   "efct_lio_sg_map failed\n");
+				return -EAGAIN;
+			}
+		} else {
+			/* If command length is 0, send the response status */
+			struct efct_scsi_cmd_resp_s rsp;
+
+			memset(&rsp, 0, sizeof(rsp));
+			efct_lio_io_printf(io,
+					   "cmd : %p length 0, send status\n",
+					   cmd);
+			return efct_scsi_send_resp(io, 0, &rsp,
+						  efct_lio_status_done, NULL);
+		}
+	}
+	curcnt = min(ocp->seg_map_cnt - ocp->cur_seg, io->sgl_allocated);
+
+	while (cnt < curcnt) {
+		sg = &cmd->t_data_sg[ocp->cur_seg];
+		sgl[cnt].addr = sg_dma_address(sg);
+		sgl[cnt].dif_addr = 0;
+		if (ocp->transferred_len + sg_dma_len(sg) >= cmd->data_length)
+			sgl[cnt].len = cmd->data_length - ocp->transferred_len;
+		else
+			sgl[cnt].len = sg_dma_len(sg);
+
+		ocp->transferred_len += sgl[cnt].len;
+		length += sgl[cnt].len;
+		ocp->cur_seg++;
+		cnt++;
+		if (ocp->transferred_len == cmd->data_length)
+			break;
+	}
+
+	if (ocp->transferred_len == cmd->data_length) {
+		flags = EFCT_SCSI_LAST_DATAPHASE;
+		ocp->seg_cnt = ocp->cur_seg; // Reset to only segs we use.
+	}
+
+	/* If there is residual, disable Auto Good Response */
+	if (cmd->residual_count)
+		flags |= EFCT_SCSI_NO_AUTO_RESPONSE;
+
+	rc = efct_scsi_send_rd_data(io, flags, NULL, sgl, curcnt, length,
+				    efct_lio_datamove_done, NULL);
+	efct_lio_io_state_trace(io, EFCT_LIO_STATE_SCSI_SEND_RD_DATA);
+	return rc;
+}
+
+static int
+efct_lio_abort_tgt_cb(struct efct_io_s *io,
+		      enum efct_scsi_io_status_e scsi_status,
+		      u32 flags, void *arg)
+{
+	efct_lio_io_printf(io, "%s\n", __func__);
+	complete(&io->tgt_io.done);
+	return 0;
+}
+
+static int
+efct_lio_queue_status(struct se_cmd *cmd)
+{
+	struct efct_scsi_cmd_resp_s rsp;
+	struct efct_scsi_tgt_io_s *ocp = container_of(cmd,
+						     struct efct_scsi_tgt_io_s,
+						     cmd);
+	struct efct_io_s *io = container_of(ocp, struct efct_io_s, tgt_io);
+	int rc = 0;
+
+	efct_lio_io_state_trace(io, EFCT_LIO_STATE_TFO_QUEUE_STATUS);
+	efct_lio_io_trace(io,
+			  "status=0x%x trans_state=0x%x se_cmd_flags=0x%x sns_len=%d\n",
+		cmd->scsi_status, cmd->transport_state, cmd->se_cmd_flags,
+		cmd->scsi_sense_length);
+
+	memset(&rsp, 0, sizeof(rsp));
+	rsp.scsi_status = cmd->scsi_status;
+	rsp.sense_data = (u8 *)io->tgt_io.sense_buffer;
+	rsp.sense_data_length = cmd->scsi_sense_length;
+
+	/* Check for residual underrun or overrun, mark negitive value for
+	 * underrun to recognize in HW
+	 */
+	if (cmd->se_cmd_flags & SCF_OVERFLOW_BIT)
+		rsp.residual = -cmd->residual_count;
+	else if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT)
+		rsp.residual = cmd->residual_count;
+
+	rc = efct_scsi_send_resp(io, 0, &rsp, efct_lio_status_done, NULL);
+	efct_lio_io_state_trace(io, EFCT_LIO_STATE_SCSI_SEND_RSP);
+	if (rc == 0)
+		ocp->rsp_sent = true;
+	return rc;
+}
+
+static void efct_lio_queue_tm_rsp(struct se_cmd *cmd)
+{
+	struct efct_scsi_tgt_io_s *ocp = container_of(cmd,
+						     struct efct_scsi_tgt_io_s,
+						     cmd);
+	struct efct_io_s *tmfio = container_of(ocp, struct efct_io_s, tgt_io);
+	struct se_tmr_req *se_tmr = cmd->se_tmr_req;
+	u8 rspcode;
+
+	efct_lio_tmfio_printf(tmfio, "cmd=%p function=0x%x tmr->response=%d\n",
+			      cmd, se_tmr->function, se_tmr->response);
+	switch (se_tmr->response) {
+	case TMR_FUNCTION_COMPLETE:
+		rspcode = EFCT_SCSI_TMF_FUNCTION_COMPLETE;
+		break;
+	case TMR_TASK_DOES_NOT_EXIST:
+		rspcode = EFCT_SCSI_TMF_FUNCTION_IO_NOT_FOUND;
+		break;
+	case TMR_LUN_DOES_NOT_EXIST:
+		rspcode = EFCT_SCSI_TMF_INCORRECT_LOGICAL_UNIT_NUMBER;
+		break;
+	case TMR_FUNCTION_REJECTED:
+	default:
+		rspcode = EFCT_SCSI_TMF_FUNCTION_REJECTED;
+		break;
+	}
+	efct_scsi_send_tmf_resp(tmfio, rspcode, NULL, efct_lio_tmf_done, NULL);
+}
+
+static struct se_wwn *
+efct_lio_make_sport(struct target_fabric_configfs *tf,
+		    struct config_group *group, const char *name)
+{
+	struct efct_lio_sport *lio_sport;
+	struct efct_s *efct;
+	int efctidx, ret;
+	u64 wwpn;
+	char *sessions_name;
+
+	ret = efct_lio_parse_wwn(name, &wwpn, 0);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/* Now search for the HBA that has this WWPN */
+	for (efctidx = 0; efctidx < MAX_EFCT_DEVICES; efctidx++) {
+		u64 pwwn;
+		u8 pn[8];
+
+		efct = efct_devices[efctidx];
+		if (!efct)
+			continue;
+		memcpy(pn, efct_hw_get_ptr(&efct->hw, EFCT_HW_WWN_PORT),
+		       sizeof(pn));
+		ARRAY2WWN(pwwn, pn);
+		if (pwwn == wwpn)
+			break;
+	}
+	if (efctidx == MAX_EFCT_DEVICES) {
+		pr_err("cannot find EFCT for wwpn %s\n", name);
+		return ERR_PTR(-ENXIO);
+	}
+	efct = efct_devices[efctidx];
+	lio_sport = kzalloc(sizeof(*lio_sport), GFP_KERNEL);
+	if (!lio_sport)
+		return ERR_PTR(-ENOMEM);
+	lio_sport->efct = efct;
+	lio_sport->wwpn = wwpn;
+	FABRIC_SNPRINTF(lio_sport->wwpn_str, sizeof(lio_sport->wwpn_str),
+			"naa.", wwpn);
+	efct->tgt_efct.lio_sport = lio_sport;
+
+	sessions_name = kasprintf(GFP_KERNEL, "efct-sessions-%d",
+				  efct->instance_index);
+	if (sessions_name && efct->sess_debugfs_dir)
+		lio_sport->sessions = debugfs_create_file(sessions_name,
+							  0644,
+						efct->sess_debugfs_dir,
+						lio_sport,
+						&efct_debugfs_session_fops);
+	kfree(sessions_name);
+
+	return &lio_sport->sport_wwn;
+}
+
+static struct se_wwn *
+efct_lio_npiv_make_sport(struct target_fabric_configfs *tf,
+			 struct config_group *group, const char *name)
+{
+	struct efct_lio_vport *lio_vport;
+	struct efct_s *efct;
+	int efctidx, ret = -1;
+	u64 p_wwpn, npiv_wwpn, npiv_wwnn;
+	char *p, tmp[128];
+	struct efct_lio_vport_list_t *vport_list;
+	char *sessions_name;
+	struct fc_vport *new_fc_vport;
+	struct fc_vport_identifiers vport_id;
+	unsigned long flags = 0;
+
+	snprintf(tmp, 128, "%s", name);
+
+	p = strchr(tmp, '@');
+
+	if (!p) {
+		pr_err("Unable to find separator operator(@)\n");
+		return ERR_PTR(ret);
+	}
+	*p++ = '\0';
+
+	ret = efct_lio_parse_wwn(tmp, &p_wwpn, 0);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = efct_lio_parse_npiv_wwn(p, strlen(p) + 1, &npiv_wwpn, &npiv_wwnn);
+	if (ret)
+		return ERR_PTR(ret);
+
+	 /* Now search for the HBA that has this WWPN */
+	for (efctidx = 0; efctidx < MAX_EFCT_DEVICES; efctidx++) {
+		u64 pwwn;
+		u8 pn[8];
+
+		efct = efct_devices[efctidx];
+		if (!efct)
+			continue;
+		if (!efct->xport->req_wwpn) {
+			memcpy(pn, efct_hw_get_ptr(&efct->hw,
+				   EFCT_HW_WWN_PORT), sizeof(pn));
+			ARRAY2WWN(pwwn, pn);
+		} else {
+			pwwn = efct->xport->req_wwpn;
+		}
+		if (pwwn == p_wwpn)
+			break;
+	}
+	if (efctidx == MAX_EFCT_DEVICES) {
+		pr_err("cannot find EFCT for base wwpn %s\n", name);
+		return ERR_PTR(-ENXIO);
+	}
+	efct = efct_devices[efctidx];
+	lio_vport = kzalloc(sizeof(*lio_vport), GFP_KERNEL);
+	if (!lio_vport)
+		return ERR_PTR(-ENOMEM);
+
+	lio_vport->efct = efct;
+	lio_vport->wwpn = p_wwpn;
+	lio_vport->npiv_wwpn = npiv_wwpn;
+	lio_vport->npiv_wwnn = npiv_wwnn;
+
+	FABRIC_SNPRINTF(lio_vport->wwpn_str, sizeof(lio_vport->wwpn_str),
+			"naa.", npiv_wwpn);
+
+	vport_list = kmalloc(sizeof(*vport_list), GFP_KERNEL);
+	if (!vport_list) {
+		kfree(lio_vport);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	memset(vport_list, 0, sizeof(struct efct_lio_vport_list_t));
+	vport_list->lio_vport = lio_vport;
+	spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
+	INIT_LIST_HEAD(&vport_list->list_entry);
+	list_add_tail(&vport_list->list_entry, &efct->tgt_efct.vport_list);
+	spin_unlock_irqrestore(&efct->tgt_efct.efct_lio_lock, flags);
+
+	sessions_name = kasprintf(GFP_KERNEL, "sessions-npiv-%d",
+				  efct->instance_index);
+	if (sessions_name && efct->sess_debugfs_dir)
+		lio_vport->sessions = debugfs_create_file(sessions_name,
+							  0644,
+					   efct->sess_debugfs_dir,
+					   lio_vport,
+					   &efct_npiv_debugfs_session_fops);
+	kfree(sessions_name);
+	memset(&vport_id, 0, sizeof(vport_id));
+	vport_id.port_name = npiv_wwpn;
+	vport_id.node_name = npiv_wwnn;
+	vport_id.roles = FC_PORT_ROLE_FCP_INITIATOR;
+	vport_id.vport_type = FC_PORTTYPE_NPIV;
+	vport_id.disable = false;
+
+	new_fc_vport = fc_vport_create(efct->shost, 0, &vport_id);
+	if (!new_fc_vport) {
+		efc_log_err(efct, "fc_vport_create failed\n");
+		kfree(lio_vport);
+		kfree(vport_list);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	lio_vport->fc_vport = new_fc_vport;
+
+	return &lio_vport->vport_wwn;
+}
+
+static void
+efct_lio_drop_sport(struct se_wwn *wwn)
+{
+	struct efct_lio_sport *lio_sport = container_of(wwn,
+					    struct efct_lio_sport, sport_wwn);
+	struct efct_s *efct = lio_sport->efct;
+
+	api_trace(efct);
+
+	/* only physical sport should exist, free lio_sport allocated
+	 * in efct_lio_make_sport
+	 */
+
+	debugfs_remove(lio_sport->sessions);
+	lio_sport->sessions = NULL;
+
+	kfree(efct->tgt_efct.lio_sport);
+	efct->tgt_efct.lio_sport = NULL;
+}
+
+static void
+efct_lio_npiv_drop_sport(struct se_wwn *wwn)
+{
+	struct efct_lio_vport *lio_vport = container_of(wwn,
+			struct efct_lio_vport, vport_wwn);
+	struct efct_lio_vport_list_t *vport, *next_vport;
+	struct efct_s *efct = lio_vport->efct;
+	unsigned long flags = 0;
+
+	api_trace(efct);
+
+	spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
+
+	debugfs_remove(lio_vport->sessions);
+
+	if (lio_vport->fc_vport)
+		fc_vport_terminate(lio_vport->fc_vport);
+
+	lio_vport->sessions = NULL;
+
+	list_for_each_entry_safe(vport, next_vport, &efct->tgt_efct.vport_list,
+				 list_entry) {
+		if (vport->lio_vport == lio_vport) {
+			list_del(&vport->list_entry);
+			kfree(vport->lio_vport);
+			kfree(vport);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&efct->tgt_efct.efct_lio_lock, flags);
+}
+
+static struct se_portal_group *
+efct_lio_make_tpg(struct se_wwn *wwn, const char *name)
+{
+	struct efct_lio_sport *lio_sport = container_of(wwn,
+					    struct efct_lio_sport, sport_wwn);
+	struct efct_lio_tpg *tpg;
+	struct efct_s *efct;
+	unsigned long n;
+	int ret;
+
+	api_trace(lio_sport->efct);
+	if (strstr(name, "tpgt_") != name)
+		return ERR_PTR(-EINVAL);
+	if (kstrtoul(name + 5, 10, &n) || n > USHRT_MAX)
+		return ERR_PTR(-EINVAL);
+
+	tpg = kzalloc(sizeof(*tpg), GFP_KERNEL);
+	if (!tpg)
+		return ERR_PTR(-ENOMEM);
+
+	tpg->sport = lio_sport;
+	tpg->tpgt = n;
+	atomic_set(&tpg->enabled, 0);
+
+	tpg->tpg_attrib.generate_node_acls = 1;
+	tpg->tpg_attrib.demo_mode_write_protect = 1;
+	tpg->tpg_attrib.cache_dynamic_acls = 1;
+	tpg->tpg_attrib.demo_mode_login_only = 1;
+	tpg->tpg_attrib.session_deletion_wait = 1;
+
+	ret = core_tpg_register(wwn, &tpg->tpg, SCSI_PROTOCOL_FCP);
+	if (ret < 0) {
+		kfree(tpg);
+		return NULL;
+	}
+	efct = lio_sport->efct;
+	efct->tgt_efct.tpg = tpg;
+	efc_log_debug(efct, "create portal group %d\n", tpg->tpgt);
+
+	return &tpg->tpg;
+}
+
+static void
+efct_lio_drop_tpg(struct se_portal_group *se_tpg)
+{
+	struct efct_lio_tpg *tpg = container_of(se_tpg,
+						struct efct_lio_tpg, tpg);
+
+	efc_log_debug(tpg->sport->efct, "drop portal group %d\n", tpg->tpgt);
+	tpg->sport->efct->tgt_efct.tpg = NULL;
+	core_tpg_deregister(se_tpg);
+	kfree(tpg);
+}
+
+static struct se_portal_group *
+efct_lio_npiv_make_tpg(struct se_wwn *wwn, const char *name)
+{
+	struct efct_lio_vport *lio_vport = container_of(wwn,
+			struct efct_lio_vport, vport_wwn);
+	struct efct_lio_tpg *tpg;
+	struct efct_s *efct;
+	unsigned long n;
+	int ret;
+
+	efct = lio_vport->efct;
+	if (strstr(name, "tpgt_") != name)
+		return ERR_PTR(-EINVAL);
+	if (kstrtoul(name + 5, 10, &n) || n > USHRT_MAX)
+		return ERR_PTR(-EINVAL);
+
+	if (n != 1) {
+		efc_log_err(efct, "Invalid tpgt index: %ld provided\n", n);
+		return ERR_PTR(-EINVAL);
+	}
+
+	tpg = kzalloc(sizeof(*tpg), GFP_KERNEL);
+	if (!tpg)
+		return ERR_PTR(-ENOMEM);
+
+	tpg->vport = lio_vport;
+	tpg->tpgt = n;
+	atomic_set(&tpg->enabled, 0);
+
+	tpg->tpg_attrib.generate_node_acls = 1;
+	tpg->tpg_attrib.demo_mode_write_protect = 1;
+	tpg->tpg_attrib.cache_dynamic_acls = 1;
+	tpg->tpg_attrib.demo_mode_login_only = 1;
+	tpg->tpg_attrib.session_deletion_wait = 1;
+
+	ret = core_tpg_register(wwn, &tpg->tpg, SCSI_PROTOCOL_FCP);
+
+	if (ret < 0) {
+		kfree(tpg);
+		return NULL;
+	}
+	lio_vport->tpg = tpg;
+	efc_log_debug(efct, "create vport portal group %d\n", tpg->tpgt);
+
+	return &tpg->tpg;
+}
+
+static void
+efct_lio_npiv_drop_tpg(struct se_portal_group *se_tpg)
+{
+	struct efct_lio_tpg *tpg = container_of(se_tpg,
+						struct efct_lio_tpg, tpg);
+
+	efc_log_debug(tpg->vport->efct, "drop npiv portal group %d\n",
+		       tpg->tpgt);
+	core_tpg_deregister(se_tpg);
+	kfree(tpg);
+}
+
+static int
+efct_lio_parse_wwn(const char *name, u64 *wwp, u8 npiv)
+{
+	int arr[8];
+	int amt;
+
+	if (npiv) {
+		amt = sscanf(name, "%02x%02x%02x%02x%02x%02x%02x%02x",
+			     &arr[0], &arr[1], &arr[2], &arr[3], &arr[4],
+				 &arr[5], &arr[6], &arr[7]);
+	} else {
+		amt = sscanf(name,
+			     "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
+			     &arr[0], &arr[1], &arr[2], &arr[3], &arr[4],
+			     &arr[5], &arr[6], &arr[7]);
+	}
+	if (amt != 8)
+		return -EINVAL;
+	ARRAY2WWN(*wwp, arr);
+	return 0;
+}
+
+static int
+efct_lio_parse_npiv_wwn(const char *name, size_t size, u64 *wwpn, u64 *wwnn)
+{
+	unsigned int cnt = size;
+	int rc;
+
+	*wwpn = *wwnn = 0;
+	if (name[cnt - 1] == '\n' || name[cnt - 1] == 0)
+		cnt--;
+
+	/* validate we have enough characters for WWPN */
+	if ((cnt != (16 + 1 + 16)) || (name[16] != ':'))
+		return -EINVAL;
+
+	rc = efct_lio_parse_wwn(&name[0], wwpn, 1);
+	if (rc != 0)
+		return rc;
+
+	rc = efct_lio_parse_wwn(&name[17], wwnn, 1);
+	if (rc != 0)
+		return rc;
+
+	return 0;
+}
+
+static int
+efct_lio_init_nodeacl(struct se_node_acl *se_nacl, const char *name)
+{
+	struct efct_lio_nacl *nacl;
+	u64 wwnn;
+
+	if (efct_lio_parse_wwn(name, &wwnn, 0) < 0)
+		return -EINVAL;
+
+	nacl = container_of(se_nacl, struct efct_lio_nacl, se_node_acl);
+	nacl->nport_wwnn = wwnn;
+
+	FABRIC_SNPRINTF(nacl->nport_name, sizeof(nacl->nport_name), "", wwnn);
+	return 0;
+}
+
+static int efct_lio_check_demo_mode_login_only(struct se_portal_group *stpg)
+{
+	struct efct_lio_tpg *tpg = container_of(stpg, struct efct_lio_tpg, tpg);
+
+	return tpg->tpg_attrib.demo_mode_login_only;
+}
+
+static int
+efct_lio_npiv_check_demo_mode_login_only(struct se_portal_group *stpg)
+{
+	struct efct_lio_tpg *tpg = container_of(stpg, struct efct_lio_tpg, tpg);
+
+	return tpg->tpg_attrib.demo_mode_login_only;
+}
+
+/*
+ * Attribute data and functions
+ */
+/***************************************************************************
+ * Functions required by SCSI base driver API
+ */
+
+/**
+ * @ingroup scsi_api_target
+ * @brief Initializes any target fields on the efct structure.
+ *
+ * @par Description
+ * Called by OS initialization code when a new device is discovered.
+ *
+ * @param efct Pointer to efct.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+int efct_scsi_tgt_new_device(struct efct_s *efct)
+{
+	int rc = 0;
+	u32 total_ios;
+	struct efct_lio_worker_s *worker = NULL;
+
+	/* Get the max settings */
+	efct->tgt_efct.max_sge =
+			efct_scsi_get_property(efct, EFCT_SCSI_MAX_SGE);
+	efct->tgt_efct.max_sgl =
+			efct_scsi_get_property(efct, EFCT_SCSI_MAX_SGL);
+
+	/* initialize IO watermark fields */
+	atomic_set(&efct->tgt_efct.ios_in_use, 0);
+	total_ios = efct_scsi_get_property(efct, EFCT_SCSI_MAX_IOS);
+	efc_log_debug(efct, "total_ios=%d\n", total_ios);
+	efct->tgt_efct.watermark_min =
+			(total_ios * EFCT_WATERMARK_LOW_PCT) / 100;
+	efct->tgt_efct.watermark_max =
+			(total_ios * EFCT_WATERMARK_HIGH_PCT) / 100;
+	atomic_set(&efct->tgt_efct.io_high_watermark,
+		   efct->tgt_efct.watermark_max);
+	atomic_set(&efct->tgt_efct.watermark_hit, 0);
+	atomic_set(&efct->tgt_efct.initiator_count, 0);
+
+	/* Create kernel worker thread to service async requests
+	 * (new/delete initiator, new cmd/tmf). Previously, a worker thread
+	 * was needed to make upcalls into LIO because the HW completion
+	 * context ran in an interrupt context (tasklet).
+	 * This is no longer necessary now that HW completions run in a
+	 * kernel thread context. However, performance is much better when
+	 * these types of reqs have their own thread.
+	 *
+	 * Note: We've seen better performance when IO completion (non-async)
+	 * upcalls into LIO are not given an additional kernel thread.
+	 * Thus,make such upcalls directly from the HW completion kernel thread
+	 */
+
+	worker = &efct->tgt_efct.async_worker;
+	efct_mqueue_init(efct, &worker->wq);
+
+	worker->thread = kthread_create((int(*)(void *)) efct_lio_async_worker,
+					efct, "efct_lio_async_worker");
+
+	if (IS_ERR(worker->thread)) {
+		efc_log_err(efct, "kthread_create failed: %ld\n",
+			     PTR_ERR(worker->thread));
+		worker->thread = NULL;
+		return -1;
+	}
+
+	wake_up_process(worker->thread);
+
+	spin_lock_init(&efct->tgt_efct.efct_lio_lock);
+	INIT_LIST_HEAD(&efct->tgt_efct.vport_pending_enable_list);
+	INIT_LIST_HEAD(&efct->tgt_efct.vport_list);
+
+	return rc;
+}
+
+/**
+ * @ingroup scsi_api_target
+ * @brief Tears down target members of efct structure.
+ *
+ * @par Description
+ * Called by OS code when device is removed.
+ *
+ * @param efct Pointer to efct.
+ * @param worker Pointer to the worker thread structure.
+ *
+ * @return Returns 0 on success, a negative error code value on failure.
+ */
+static int
+efct_lio_terminate_worker_thread(struct efct_s *efct,
+				 struct efct_lio_worker_s *worker)
+{
+	struct efct_lio_wq_data_s *wq_data;
+	u32 rc = 0;
+
+	api_trace(efct);
+
+	wq_data = kzalloc(sizeof(*wq_data), GFP_ATOMIC);
+
+	init_completion(&worker->done);
+
+	if (wq_data) {
+		/* send stop message */
+		wq_data->message = EFCT_LIO_WQ_STOP;
+		wq_data->ptr = NULL;
+		efct_mqueue_put(&worker->wq, wq_data);
+	} else {
+		/* mark thread for terminate (not ideal -- blocking) */
+		/* thread will stop when timeout is hit */
+		if (!worker->thread)
+			return -1;
+
+		/* Call stop */
+		kthread_stop(worker->thread);
+	}
+
+	/* Wait for worker thread to report that it has stopped */
+	rc = wait_for_completion_timeout(&worker->done,
+					 usecs_to_jiffies(10000000));
+	if (!rc)
+		efc_log_info(efct, "worker thread timed out\n");
+	efct_mqueue_free(&worker->wq);
+	return 0;
+}
+
+/**
+ * @ingroup scsi_api_target
+ * @brief Tears down target members of efct structure.
+ *
+ * @par Description
+ * Called by OS code when device is removed.
+ *
+ * @param efct Pointer to efct.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+int efct_scsi_tgt_del_device(struct efct_s *efct)
+{
+	int rc = 0;
+
+	api_trace(efct);
+
+	if (efct_lio_terminate_worker_thread(efct,
+					     &efct->tgt_efct.async_worker))
+		rc = -1;
+	return rc;
+}
+
+/**
+ * @brief Initialize SCSI IO.
+ *
+ * @par Description
+ * Initialize SCSI IO, this function is called once per IO during IO pool
+ * allocation so that the target server may initialize any of its own private
+ * data.
+ *
+ * @param io Pointer to SCSI IO object.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+int
+efct_scsi_tgt_io_init(struct efct_io_s *io)
+{
+	return 0;
+}
+
+/**
+ * @brief Uninitialize SCSI IO.
+ *
+ * @par Description
+ * Uninitialize target server private data in a SCSI io object.
+ *
+ * @param io Pointer to SCSI IO object.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+int
+efct_scsi_tgt_io_exit(struct efct_io_s *io)
+{
+	return 0;
+}
+
+/**
+ * @ingroup scsi_api_target
+ * @brief Accept new domain notification.
+ *
+ * @par Description
+ * Called by base driver when new domain is discovered.  A target-server
+ * uses this call to prepare for new remote node notifications
+ * arising from efct_scsi_new_initiator().
+ * @n @n
+ * The domain context has an element <b>struct efct_scsi_tgt_domain_s
+ * tgt_domain</b> which is declared by the target-server code and is used
+ * for target-server private data.
+ * @n @n
+ * This function will only be called if the base-driver has been enabled
+ * for target capability.
+ * @n @n
+ * @b Note: This call is made to target-server backends.
+ * The efct_scsi_ini_new_domain() function is called to
+ * initiator-client backends.
+ *
+ * @param domain Pointer to domain.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+int
+efct_scsi_tgt_new_domain(struct efc_lport *efc, struct efc_domain_s *domain)
+{
+	int status = 0;
+	struct efct_s *efct = domain->efc->base;
+	struct efct_lio_vport_data_t *virt_target_data, *next;
+	unsigned long flags = 0;
+
+	api_trace(efct);
+	spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
+	list_for_each_entry_safe(virt_target_data, next,
+		 &efct->tgt_efct.vport_pending_enable_list, list_entry) {
+		list_del(&virt_target_data->list_entry);
+
+		status = efc_sport_vport_new(domain,
+					     virt_target_data->vport_wwpn,
+					     virt_target_data->vport_wwnn,
+					     U32_MAX,
+					     virt_target_data->initiator_mode,
+					     virt_target_data->target_mode,
+					     virt_target_data, NULL, true);
+		if (status != 0) {
+			/* Put this back on list and try again next time */
+			efc_log_test(efct,
+				      "Could not create new vport for WWPN:0x%llx\n",
+				 virt_target_data->vport_wwpn);
+			list_add(&efct->tgt_efct.vport_pending_enable_list,
+				 &virt_target_data->list_entry);
+		} else {
+			efc_log_debug(efct,
+				       "Created new vport for WWPN: 0x%llx\n",
+				      virt_target_data->vport_wwpn);
+			kfree(virt_target_data);
+		}
+	}
+	spin_unlock_irqrestore(&efct->tgt_efct.efct_lio_lock, flags);
+	return status;
+}
+
+/**
+ * @ingroup scsi_api_target
+ * @brief accept domain lost notification.
+ *
+ * @par Description
+ * Called by the base driver when a domain goes away. A target-server
+ * uses this call to clean up all domain scoped resources.
+ * @n @n
+ * @b Note: This call is made to target-server backends.
+ * The efct_scsi_ini_del_domain() function is called to
+ * initiator-client backends.
+ *
+ * @param domain Pointer to domain.
+ *
+ * @return None.
+ */
+void
+efct_scsi_tgt_del_domain(struct efc_lport *efc, struct efc_domain_s *domain)
+{
+	struct efct_s *efct = domain->efc->base;
+
+	api_trace(efct);
+}
+
+/**
+ * @ingroup scsi_api_target
+ * @brief accept new sli port notification
+ *
+ * @par Description
+ * Called by the base drive when new sli port (sport) is discovered.
+ * A target-server will use this call to prepare for new remote node
+ * notifications arising from efct_scsi_new_initiator().
+ * @n @n
+ * This function will only be called if the base-driver has been
+ * enabled for target capability.
+ * @n @n
+ * @b Note: This call is made to target-server backends. The
+ * efct_scsi_ini_new_sport() function is called to initiator-client
+ * backends.
+ *
+ * @param sport Pointer to sport.
+ *
+ * @return Returns 0 for success, or a negative error code value on failure.
+ */
+int
+efct_scsi_tgt_new_sport(struct efc_lport *efc, struct efc_sli_port_s *sport)
+{
+	struct efct_s *efct = sport->efc->base;
+
+	efc_log_debug(efct, "New SPORT: %s bound to %s\n", sport->display_name,
+		       efct->tgt_efct.lio_sport->wwpn_str);
+
+	return 0;
+}
+
+/**
+ * @ingroup scsi_api_target
+ * @brief Accept sli port gone notification.
+ *
+ * @par Description
+ * Called by the base driver when a sport goes away.  A target-server
+ * uses this call to clean up all sport scoped resources.
+ * @n @n
+ * @b Note: This call is made to target-server backends.
+ * The efct_scsi_ini_del_sport() function is called to initiator-client
+ * backends.
+ *
+ * @param sport Pointer to SPORT structure.
+ *
+ * @return None.
+ */
+void
+efct_scsi_tgt_del_sport(struct efc_lport *efc, struct efc_sli_port_s *sport)
+{
+	efc_log_debug(efc, "Del SPORT: %s\n",
+		       sport->display_name);
+}
+
+/**
+ * @ingroup scsi_api_target
+ * @brief Validate new initiator.
+ *
+ * @par Description
+ * Sent by the base driver to validate a remote initiator.
+ * The target-server returns TRUE if this initiator should be accepted.
+ * @n @n
+ * This function is only called if the base driver is enabled for
+ * target capability.
+ *
+ * @param node Pointer to remote initiator node to validate.
+ *
+ * @return TRUE if initiator should be accepted, or FALSE if it
+ * should be rejected.
+ *
+ */
+int
+efct_scsi_validate_initiator(struct efc_lport *efc, struct efc_node_s *node)
+{
+	/*
+	 * Since LIO only supports initiator validation at thread level,
+	 * we are open minded and accept all callers.
+	 */
+	return 1;
+}
+
+/**
+ * @ingroup scsi_api_target
+ * @brief Receive notification of a new SCSI initiator node.
+ *
+ * @par Description
+ * Sent by the base driver to notify a target-server of the presence of a new
+ * remote initiator. The target-server may use this call to prepare for
+ * inbound IO from this node.
+ * @n @n
+ * The struct efc_node_s structure has and element of type efct_scsi_tgt_node_s
+ * named tgt_node that is declared and used by a target-server for private
+ * information.
+ * @n @n
+ * @b Note: This function is only called if the base driver is enabled for
+ * target capability.
+ *
+ * @param node Pointer to new remote initiator node.
+ *
+ * @return None.
+ *
+ */
+int efct_scsi_new_initiator(struct efc_lport *efc, struct efc_node_s *node)
+{
+	struct efct_s *efct = node->efc->base;
+	struct efct_lio_wq_data_s *wq_data;
+
+	/*
+	 * Since LIO only supports initiator validation at thread level,
+	 * we are open minded and accept all callers.
+	 */
+	wq_data = kzalloc(sizeof(*wq_data), GFP_ATOMIC);
+	if (!wq_data)
+		return -ENOMEM;
+
+	wq_data->message = EFCT_LIO_WQ_NEW_INITIATOR;
+	wq_data->ptr = node;
+	efct_mqueue_put(&efct->tgt_efct.async_worker.wq, wq_data);
+	return 0;
+}
+
+/**
+ * @ingroup scsi_api_target
+ * @brief Delete a SCSI initiator node.
+ *
+ * @par Description
+ * Sent by the base driver to notify a target server that a remote initiator
+ * is now gone. The base driver will have terminated all outstanding IOs and
+ * the target-server will receive appropriate completions.
+ * @n @n
+ * @b Note: This function is only called if the base driver is enabled for
+ * target capability.
+ *
+ * @param node Pointer node being deleted.
+ * @param reason Indicates whether the initiator is missing or deleted.
+ *
+ * @return None.
+ *
+ */
+int
+efct_scsi_del_initiator(struct efc_lport *efc, struct efc_node_s *node,
+			int reason)
+{
+	struct efct_s *efct = node->efc->base;
+	struct efct_lio_wq_data_s *wq_data;
+	int watermark;
+	int initiator_count;
+
+	if (reason == EFCT_SCSI_INITIATOR_MISSING)
+		return EFCT_SCSI_CALL_COMPLETE;
+
+	api_trace(efct);
+	wq_data = kmalloc(sizeof(*wq_data), GFP_ATOMIC);
+	if (!wq_data) {
+		efc_log_err(efct, "failed to allocate work queue entry\n");
+		return EFCT_SCSI_CALL_COMPLETE;
+	}
+	memset(wq_data, 0, sizeof(*wq_data));
+	wq_data->message = EFCT_LIO_WQ_UNREG_SESSION;
+	wq_data->ptr = node;
+	efct_mqueue_put(&efct->tgt_efct.async_worker.wq, wq_data);
+
+	/*
+	 * update IO watermark: decrement initiator count
+	 */
+	initiator_count =
+		atomic_sub_return(1, &efct->tgt_efct.initiator_count);
+	watermark = (efct->tgt_efct.watermark_max -
+			initiator_count * EFCT_IO_WATERMARK_PER_INITIATOR);
+	watermark = (efct->tgt_efct.watermark_min > watermark) ?
+			efct->tgt_efct.watermark_min : watermark;
+	atomic_set(&efct->tgt_efct.io_high_watermark, watermark);
+
+	return EFCT_SCSI_CALL_ASYNC;
+}
+
+const char *efct_lio_get_msg_name(enum efct_lio_wq_msg_s msg)
+{
+	switch (msg) {
+	case EFCT_LIO_WQ_SUBMIT_CMD:
+		return "EFCT_LIO_WQ_SUBMIT_CMD";
+	case EFCT_LIO_WQ_UNREG_SESSION:
+		return "EFCT_LIO_WQ_UNREG_SESSION";
+	case EFCT_LIO_WQ_NEW_INITIATOR:
+		return "EFCT_LIO_WQ_NEW_INITIATOR";
+	case EFCT_LIO_WQ_STOP:
+		return "EFCT_LIO_WQ_STOP";
+	default:
+		break;
+	}
+	return "unknown";
+}
+
+static int efct_session_cb(struct se_portal_group *se_tpg,
+			   struct se_session *se_sess, void *private)
+{
+	struct efc_node_s *node = private;
+	struct efct_scsi_tgt_node_s *tgt_node = NULL;
+
+	tgt_node = kzalloc(sizeof(*tgt_node), GFP_KERNEL);
+	if (!tgt_node)
+		return -1;
+
+	tgt_node->session = se_sess;
+	node->tgt_node = tgt_node;
+
+	return 0;
+}
+
+/**
+ * @brief Worker thread for LIO commands.
+ *
+ * @par Description
+ * This thread is used to make LIO upcalls associated with
+ * asynchronous requests (i.e. new commands received, register
+ * sessions, unregister sessions).
+ *
+ * @param mythread Pointer to the thread object.
+ *
+ * @return Always returns 0.
+ */
+static int efct_lio_async_worker(struct efct_s *efct)
+{
+	struct efct_lio_wq_data_s *wq_data;
+	struct efc_node_s *node;
+	struct se_session *se_sess;
+	int done = 0;
+	bool free_data = true;
+	struct efct_scsi_tgt_io_s *ocp;
+	int dir, rc = 0;
+	struct efct_io_s *io;
+	struct efct_io_s *tmfio;
+	struct efct_scsi_tgt_node_s *tgt_node = NULL;
+
+	while (!done) {
+		/* Poll with a timeout, to keep the kernel from complaining
+		 * of not periodically running
+		 */
+		wq_data = efct_mqueue_get(&efct->tgt_efct.async_worker.wq,
+					  10000000);
+		if (kthread_should_stop())
+			break;
+
+		if (!wq_data)
+			continue;
+
+		switch (wq_data->message) {
+		case EFCT_LIO_WQ_UNREG_SESSION:
+			node = wq_data->ptr;
+			tgt_node = node->tgt_node;
+			se_sess = tgt_node->session;
+
+			if (!se_sess) {
+				/* base driver has sent back-to-back requests
+				 * to unreg session with no intervening
+				 * register
+				 */
+				efc_log_test(efct,
+					      "unreg session for NULL session\n");
+				efc_scsi_del_initiator_complete(node->efc,
+								node);
+				break;
+			}
+
+			efc_log_debug(efct, "unreg session se_sess=%p node=%p\n",
+				       se_sess, node);
+
+			/* first flag all session commands to complete */
+			target_sess_cmd_list_set_waiting(se_sess);
+
+			/* now wait for session commands to complete */
+			target_wait_for_sess_cmds(se_sess);
+			target_remove_session(se_sess);
+
+			kfree(node->tgt_node);
+
+			node->tgt_node = NULL;
+			efc_scsi_del_initiator_complete(node->efc, node);
+			break;
+		case EFCT_LIO_WQ_NEW_INITIATOR: {
+			char wwpn[FABRIC_SNPRINTF_LEN];
+			struct efct_lio_tpg *tpg = NULL;
+			struct se_portal_group *se_tpg;
+			struct se_session *se_sess;
+			int watermark;
+			int initiator_count;
+
+			/*
+			 * Find the sport
+			 */
+			node = wq_data->ptr;
+			/* Check to see if it's belongs to vport,
+			 * if not get physical port
+			 */
+			tpg = efct_get_vport_tpg(node);
+			if (tpg) {
+				se_tpg = &tpg->tpg;
+			} else if (efct->tgt_efct.tpg) {
+				tpg = efct->tgt_efct.tpg;
+				se_tpg = &tpg->tpg;
+			} else {
+				efc_log_err(efct, "failed to init session\n");
+				break;
+			}
+
+			/*
+			 * Format the FCP Initiator port_name into colon
+			 * separated values to match the format by our explicit
+			 * ConfigFS NodeACLs.
+			 */
+			FABRIC_SNPRINTF(wwpn, sizeof(wwpn), "",
+					efc_node_get_wwpn(node));
+
+			se_sess = target_setup_session(se_tpg, 0, 0,
+						       TARGET_PROT_NORMAL,
+						       wwpn, node,
+						       efct_session_cb);
+			if (IS_ERR(se_sess)) {
+				efc_log_err(efct, "failed to setup session\n");
+				break;
+			}
+
+			efc_log_debug(efct, "new initiator se_sess=%p node=%p\n",
+				      se_sess, node);
+
+			/* update IO watermark: increment initiator count */
+			initiator_count =
+			atomic_add_return(1, &efct->tgt_efct.initiator_count);
+			watermark = (efct->tgt_efct.watermark_max -
+			     initiator_count * EFCT_IO_WATERMARK_PER_INITIATOR);
+			watermark = (efct->tgt_efct.watermark_min > watermark) ?
+				efct->tgt_efct.watermark_min : watermark;
+			atomic_set(&efct->tgt_efct.io_high_watermark,
+				   watermark);
+
+			break;
+		}
+		case EFCT_LIO_WQ_STOP:
+			done = 1;
+			break;
+
+		case EFCT_LIO_WQ_SUBMIT_CMD:
+			free_data = false;
+			ocp = wq_data->ptr;
+			io = container_of(ocp, struct efct_io_s, tgt_io);
+			switch (ocp->ddir) {
+			case DDIR_TO_INITIATOR:
+				dir = DMA_FROM_DEVICE;
+				break;
+			case DDIR_FROM_INITIATOR:
+				dir = DMA_TO_DEVICE;
+				break;
+			case DDIR_BIDIR:
+				dir = DMA_BIDIRECTIONAL;
+				break;
+			case DDIR_NONE:
+			default:
+				dir = DMA_NONE;
+				break;
+			}
+			tgt_node = io->node->tgt_node;
+
+			se_sess = tgt_node->session;
+			if (se_sess) {
+				rc = target_submit_cmd(&io->tgt_io.cmd,
+						       se_sess,
+						ocp->cdb,
+						&io->tgt_io.sense_buffer[0],
+						ocp->lun, io->exp_xfer_len,
+						ocp->task_attr, dir,
+						TARGET_SCF_ACK_KREF);
+				efct_lio_io_state_trace(io,
+						EFCT_LIO_STATE_TGT_SUBMIT_CMD);
+
+				/* This can actually happen if IOs are going
+				 * one when efctLio.py --delete is performed!!!
+				 */
+				WARN_ON(rc && (rc != -ESHUTDOWN));
+			}
+			break;
+		case EFCT_LIO_WQ_SUBMIT_TMF:
+			free_data = false;
+			ocp = wq_data->ptr;
+			tmfio = container_of(ocp, struct efct_io_s, tgt_io);
+
+			tgt_node = tmfio->node->tgt_node;
+
+			se_sess = tgt_node->session;
+			if (se_sess) {
+				rc = target_submit_tmr(&ocp->cmd,
+						se_sess, &ocp->sense_buffer[0],
+						ocp->lun,
+						&ocp->io_to_abort->tgt_io.cmd,
+						ocp->tmf, GFP_KERNEL,
+						tmfio->init_task_tag,
+						TARGET_SCF_ACK_KREF);
+				efct_lio_io_state_trace(tmfio,
+						EFCT_LIO_STATE_TGT_SUBMIT_TMR);
+				if (rc) {
+					efct_scsi_send_tmf_resp(tmfio,
+						EFCT_SCSI_TMF_FUNCTION_REJECTED,
+						NULL, efct_lio_null_tmf_done,
+						NULL);
+				}
+			}
+			break;
+		default:
+			efc_log_test(efct, "UNKNOWN message=%d\n",
+				      wq_data->message);
+			break;
+		}
+		if (free_data)
+			kfree(wq_data);
+	}
+
+	complete(&efct->tgt_efct.async_worker.done);
+
+	return 0;
+}
+
+/**
+ * @ingroup scsi_api_target
+ * @brief Receive FCP SCSI command.
+ *
+ * @par Description
+ * Called by the base driver when a new SCSI command has been received.
+ * The target server will process the command, and issue data and/or
+ * response phase requests to the base driver.
+ * @n @n
+ * The IO context (struct efct_io_s) structure has an element of type
+ * struct efct_scsi_tgt_io_s named tgt_io that is declared and used by
+ * a target server for private information.
+ *
+ * @param io Pointer to IO context.
+ * @param lun LUN for this IO.
+ * @param cdb Pointer to SCSI CDB.
+ * @param cdb_len Length of CDB in bytes.
+ * @param flags Command flags.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+int efct_scsi_recv_cmd(struct efct_io_s *io, uint64_t lun, u8 *cdb,
+		       u32 cdb_len, u32 flags)
+{
+	struct efct_scsi_tgt_io_s *ocp = &io->tgt_io;
+	struct efct_s *efct = io->efct;
+	struct efct_lio_wq_data_s *wq_data;
+	char *ddir;
+
+	memset(ocp, 0, sizeof(struct efct_scsi_tgt_io_s));
+	efct_lio_io_state_trace(io, EFCT_LIO_STATE_SCSI_RECV_CMD);
+	atomic_add_return(1, &efct->tgt_efct.ios_in_use);
+
+	/* check against watermark and send TASK_SET_FULL? */
+
+	/* set target timeout */
+	io->timeout = efct->target_io_timer_sec;
+
+	if (flags & EFCT_SCSI_CMD_SIMPLE)
+		ocp->task_attr = TCM_SIMPLE_TAG;
+	else if (flags & EFCT_SCSI_CMD_HEAD_OF_QUEUE)
+		ocp->task_attr = TCM_HEAD_TAG;
+	else if (flags & EFCT_SCSI_CMD_ORDERED)
+		ocp->task_attr = TCM_ORDERED_TAG;
+	else if (flags & EFCT_SCSI_CMD_ACA)
+		ocp->task_attr = TCM_ACA_TAG;
+
+	switch (flags & (EFCT_SCSI_CMD_DIR_IN | EFCT_SCSI_CMD_DIR_OUT)) {
+	case EFCT_SCSI_CMD_DIR_IN:
+		ddir = "FROM_INITIATOR";
+		ocp->ddir = DDIR_FROM_INITIATOR;
+		break;
+	case EFCT_SCSI_CMD_DIR_OUT:
+		ddir = "TO_INITIATOR";
+		ocp->ddir = DDIR_TO_INITIATOR;
+		break;
+	case EFCT_SCSI_CMD_DIR_IN | EFCT_SCSI_CMD_DIR_OUT:
+		ddir = "BIDIR";
+		ocp->ddir = DDIR_BIDIR;
+		break;
+	default:
+		ddir = "NONE";
+		ocp->ddir = DDIR_NONE;
+		break;
+	}
+	ocp->cdb = cdb;
+	ocp->lun = lun;
+	efct_lio_io_trace(io, "new cmd=0x%x ddir=%s dl=%u\n",
+			  cdb[0], ddir, io->exp_xfer_len);
+	wq_data = &ocp->wq_data;
+	wq_data->message = EFCT_LIO_WQ_SUBMIT_CMD;
+	wq_data->ptr = ocp;
+	efct_mqueue_put(&efct->tgt_efct.async_worker.wq, wq_data);
+	return 0;
+}
+
+/**
+ * @ingroup scsi_api_target
+ * @brief Receive FCP SCSI Command with first burst data.
+ *
+ * @par Description
+ * Receive a new FCP SCSI command from the base driver with first burst data.
+ *
+ * @param io Pointer to IO context.
+ * @param lun LUN for this IO.
+ * @param cdb Pointer to SCSI CDB.
+ * @param cdb_len Length of CDB in bytes.
+ * @param flags Command flags.
+ * @param first_burst_buffers First burst buffers.
+ * @param first_burst_bytes Number of bytes received in the first burst.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+
+int efct_scsi_recv_cmd_first_burst(struct efct_io_s *io, uint64_t lun,
+				   u8 *cdb, u32 cdb_len, u32 flags,
+	struct efc_dma_s first_burst_buffers[], u32 first_burst_bytes)
+{
+	api_trace(io->efct);
+	return -1;
+}
+
+/**
+ * @ingroup scsi_api_target
+ * @brief receive a TMF command IO
+ *
+ * @par Description
+ * Called by the base driver when a SCSI TMF command has been received.
+ * The target server will process the command, aborting commands as
+ * needed, and post a response using efct_scsi_send_resp().
+ * @n @n
+ * The IO context (struct efct_io_s) structure has an element of type
+ * struct efct_scsi_tgt_io_s named tgt_io that is declared and used by
+ * a target-server for private information.
+ * @n @n
+ * If the target-server walks the nodes active_ios linked list, and
+ * starts IO abort processing, the code <b>must</b> be sure not to abort
+ * the IO passed into the efct_scsi_recv_tmf() command.
+ *
+ * @param tmfio Pointer to IO context.
+ * @param lun Logical unit value.
+ * @param cmd Command request.
+ * @param io_to_abort Pointer to IO object to abort for TASK_ABORT
+ *	(NULL for all other TMF).
+ * @param flags Flags.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+int
+efct_scsi_recv_tmf(struct efct_io_s *tmfio, u32 lun,
+		   enum efct_scsi_tmf_cmd_e cmd,
+		  struct efct_io_s *io_to_abort, u32 flags)
+{
+	unsigned char tmr_func;
+	struct efct_lio_wq_data_s *wq_data;
+	struct efct_s *efct = tmfio->efct;
+	struct efct_scsi_tgt_io_s *ocp = &tmfio->tgt_io;
+
+	memset(ocp, 0, sizeof(struct efct_scsi_tgt_io_s));
+	efct_lio_io_state_trace(tmfio, EFCT_LIO_STATE_SCSI_RECV_TMF);
+	atomic_add_return(1, &efct->tgt_efct.ios_in_use);
+	efct_lio_tmfio_printf(tmfio, "%s: new tmf %x lun=%u\n",
+			      tmfio->display_name, cmd, lun);
+
+	switch (cmd) {
+	case EFCT_SCSI_TMF_ABORT_TASK:
+		tmr_func = TMR_ABORT_TASK;
+		break;
+	case EFCT_SCSI_TMF_ABORT_TASK_SET:
+		tmr_func = TMR_ABORT_TASK_SET;
+		break;
+	case EFCT_SCSI_TMF_CLEAR_TASK_SET:
+		tmr_func = TMR_CLEAR_TASK_SET;
+		break;
+	case EFCT_SCSI_TMF_LOGICAL_UNIT_RESET:
+		tmr_func = TMR_LUN_RESET;
+		break;
+	case EFCT_SCSI_TMF_CLEAR_ACA:
+		tmr_func = TMR_CLEAR_ACA;
+		break;
+	case EFCT_SCSI_TMF_TARGET_RESET:
+		tmr_func = TMR_TARGET_WARM_RESET;
+		break;
+	case EFCT_SCSI_TMF_QUERY_ASYNCHRONOUS_EVENT:
+	case EFCT_SCSI_TMF_QUERY_TASK_SET:
+	default:
+		efct_scsi_send_tmf_resp(tmfio, EFCT_SCSI_TMF_FUNCTION_REJECTED,
+					NULL, efct_lio_null_tmf_done, NULL);
+		return 0;
+	}
+
+	/* queue work to async worker */
+	tmfio->tgt_io.tmf = tmr_func;
+	tmfio->tgt_io.lun = lun;
+	tmfio->tgt_io.io_to_abort = io_to_abort;
+	wq_data = &tmfio->tgt_io.wq_data;
+	wq_data->message = EFCT_LIO_WQ_SUBMIT_TMF;
+	wq_data->ptr = &tmfio->tgt_io;
+	efct_mqueue_put(&efct->tgt_efct.async_worker.wq, wq_data);
+	return 0;
+}
+
+/**
+ * @ingroup scsi_api_target
+ * @brief Driver-wide initialization for target-server.
+ *
+ * @par Description
+ * Called by OS initialization prior to PCI device discovery.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+int efct_scsi_tgt_driver_init(void)
+{
+	int rc;
+
+	/* Register the top level struct config_item_type with TCM core */
+	rc = target_register_template(&efct_lio_ops);
+	if (rc < 0) {
+		pr_err("target_fabric_configfs_register failed with %d\n", rc);
+		return rc;
+	}
+	rc = target_register_template(&efct_lio_npiv_ops);
+	if (rc < 0) {
+		pr_err("target_fabric_configfs_register failed with %d\n", rc);
+		target_unregister_template(&efct_lio_ops);
+		return rc;
+	}
+	return 0;
+}
+
+/**
+ * @ingroup scsi_api_target
+ * @brief Driver-wide cleanup for target server.
+ *
+ * @par Description
+ * Called by OS driver-wide exit/cleanup.
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+int efct_scsi_tgt_driver_exit(void)
+{
+	target_unregister_template(&efct_lio_ops);
+	target_unregister_template(&efct_lio_npiv_ops);
+	fabric = NULL;
+	npiv_fabric = NULL;
+	return 0;
+}
+
+int
+efct_scsi_get_block_vaddr(struct efct_io_s *io, uint64_t blocknumber,
+			  struct efct_scsi_vaddr_len_s addrlen[],
+	u32 max_addrlen, void **dif_vaddr)
+{
+	return -1;
+}
diff --git a/drivers/scsi/elx/efct/efct_lio.h b/drivers/scsi/elx/efct/efct_lio.h
new file mode 100644
index 000000000000..90bbd6c3759e
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_lio.h
@@ -0,0 +1,371 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#if !defined(__EFCT_LIO_H__)
+#define __EFCT_LIO_H__
+
+#define EFCT_INCLUDE_LIO
+
+#include "efct_scsi.h"
+#include <target/target_core_base.h>
+
+enum efct_lio_wq_msg_s {
+	EFCT_LIO_WQ_SUBMIT_CMD,
+	EFCT_LIO_WQ_SUBMIT_TMF,
+	EFCT_LIO_WQ_UNREG_SESSION,
+	EFCT_LIO_WQ_NEW_INITIATOR,
+	EFCT_LIO_WQ_STOP,
+};
+
+struct efct_lio_wq_data_s {
+	enum efct_lio_wq_msg_s message;
+	void *ptr;
+	struct {
+		struct efct_io_s *tmfio;
+		u64 lun;
+		enum efct_scsi_tmf_cmd_e cmd;
+		struct efct_io_s *abortio;
+		u32 flags;
+	} tmf;
+};
+
+/**
+ * @brief EFCT message queue object
+ *
+ * The EFCT message queue may be used to pass
+ * messages between two threads (or an ISR and thread).
+ * A message is defined here as a pointer to an instance
+ * of application specific data (message data).
+ * The message queue allocates a message header,
+ * saves the message data pointer, and places the
+ * header on the message queue's linked list.
+ * completion is used to synchronize access
+ * to the message queue consumer.
+ *
+ */
+
+struct efct_mqueue_s {
+	struct efct_s *efct;
+	spinlock_t lock;		/* message queue lock */
+	struct completion prod;		/* producer*/
+	struct list_head queue;
+};
+
+struct efct_lio_worker_s {
+	struct task_struct *thread;
+	struct efct_mqueue_s wq;
+	struct completion done;
+};
+
+/**
+ * @brief target private efct structure
+ */
+struct efct_scsi_tgt_s {
+	u32 max_sge;
+	u32 max_sgl;
+
+	/*
+	 * Variables used to send task set full. We are using a high watermark
+	 * method to send task set full. We will reserve a fixed number of IOs
+	 * per initiator plus a fudge factor. Once we reach this number,
+	 * then the target will start sending task set full/busy responses.
+	 */
+	atomic_t initiator_count;	/**< count of initiators */
+	atomic_t ios_in_use;	/**< num of IOs in use */
+	atomic_t io_high_watermark;	/**< used to send task set full */
+	/**< used to track how often IO pool almost empty */
+	atomic_t watermark_hit;
+	int watermark_min;		/**< lower limit for watermark */
+	int watermark_max;		/**< upper limit for watermark */
+
+	struct efct_lio_sport *lio_sport;
+	struct efct_lio_tpg *tpg;
+	/**< list of VPORTS waiting to be created */
+	struct list_head vport_pending_enable_list;
+	struct list_head vport_list;		/**< list of existing VPORTS*/
+	/* Protects vport list*/
+	spinlock_t	efct_lio_lock;
+
+	u64 wwnn;
+
+	/* worker thread for making upcalls related to asynchronous
+	 * events e.g. node (session) found, node (session) deleted,
+	 * new command received
+	 */
+	struct efct_lio_worker_s async_worker;
+};
+
+/**
+ * @brief target private domain structure
+ */
+
+struct efct_scsi_tgt_domain_s {
+	/* efct_lio decls */
+	;
+};
+
+/**
+ * @brief target private sport structure
+ */
+
+struct efct_scsi_tgt_sport_s {
+	struct efct_lio_sport *lio_sport;
+};
+
+/**
+ * @brief target private node structure
+ */
+
+#define SCSI_TRANSPORT_ID_FCP   0
+
+struct efct_scsi_tgt_node_s {
+	struct se_session *session;
+};
+
+/**
+ * @brief target private IO structure
+ */
+
+struct efct_scsi_tgt_io_s {
+	struct se_cmd cmd;
+	unsigned char sense_buffer[TRANSPORT_SENSE_BUFFER];
+	enum {
+		DDIR_NONE, DDIR_FROM_INITIATOR, DDIR_TO_INITIATOR, DDIR_BIDIR
+	} ddir;
+	int task_attr;
+	struct completion done;			/* for synchronizing aborts */
+	u64 lun;
+
+#define EFCT_LIO_STATE_SCSI_RECV_CMD		(1 << 0)
+#define EFCT_LIO_STATE_TGT_SUBMIT_CMD		(1 << 1)
+#define EFCT_LIO_STATE_TFO_QUEUE_DATA_IN	(1 << 2)
+#define EFCT_LIO_STATE_TFO_WRITE_PENDING	(1 << 3)
+#define EFCT_LIO_STATE_TGT_EXECUTE_CMD		(1 << 4)
+#define EFCT_LIO_STATE_SCSI_SEND_RD_DATA	(1 << 5)
+#define EFCT_LIO_STATE_TFO_CHK_STOP_FREE	(1 << 6)
+#define EFCT_LIO_STATE_SCSI_DATA_DONE		(1 << 7)
+#define EFCT_LIO_STATE_TFO_QUEUE_STATUS		(1 << 8)
+#define EFCT_LIO_STATE_SCSI_SEND_RSP		(1 << 9)
+#define EFCT_LIO_STATE_SCSI_RSP_DONE		(1 << 10)
+#define EFCT_LIO_STATE_TGT_GENERIC_FREE		(1 << 11)
+#define EFCT_LIO_STATE_SCSI_RECV_TMF		(1 << 12)
+#define EFCT_LIO_STATE_TGT_SUBMIT_TMR		(1 << 13)
+#define EFCT_LIO_STATE_TFO_WRITE_PEND_STATUS	(1 << 14)
+#define EFCT_LIO_STATE_TGT_GENERIC_REQ_FAILURE  (1 << 15)
+
+#define EFCT_LIO_STATE_TFO_ABORTED_TASK		(1 << 29)
+#define EFCT_LIO_STATE_TFO_RELEASE_CMD		(1 << 30)
+#define EFCT_LIO_STATE_SCSI_CMPL_CMD		(1 << 31)
+	u32 state;
+	u8 *cdb;
+	u8 tmf;
+	struct efct_io_s *io_to_abort;
+	u32 cdb_len;
+	u32 seg_map_cnt;	/* current number of segments mapped for dma */
+	u32 seg_cnt;	/* total segment count for i/o */
+	u32 cur_seg;	/* current segment counter */
+	enum efct_scsi_io_status_e err;	/* current error */
+	/* context associated with thread work queue request */
+	struct efct_lio_wq_data_s wq_data;
+	bool	aborting;  /* IO is in process of being aborted */
+	bool	rsp_sent; /* a response has been sent for this IO */
+	uint32_t transferred_len;
+};
+
+/* Handler return codes */
+enum {
+	SCSI_HANDLER_DATAPHASE_STARTED = 1,
+	SCSI_HANDLER_RESP_STARTED,
+	SCSI_HANDLER_VALIDATED_DATAPHASE_STARTED,
+	SCSI_CMD_NOT_SUPPORTED,
+	};
+
+#define scsi_pack_result(key, code, qualifier) (((key & 0xff) << 16) | \
+				((code && 0xff) << 8) | (qualifier & 0xff))
+
+int efct_scsi_tgt_driver_init(void);
+int efct_scsi_tgt_driver_exit(void);
+int scsi_dataphase_cb(struct efct_io_s *io,
+		      enum efct_scsi_io_status_e scsi_status,
+		      u32 flags, void *arg);
+const char *efct_lio_get_msg_name(enum efct_lio_wq_msg_s msg);
+
+#define FABRIC_SNPRINTF_LEN     32
+struct efct_lio_vport {
+	u64 wwpn;
+	u64 npiv_wwpn;
+	u64 npiv_wwnn;
+	unsigned char wwpn_str[FABRIC_SNPRINTF_LEN];
+	struct se_wwn vport_wwn;
+	struct efct_lio_tpg *tpg;
+	struct efct_s *efct;
+	struct dentry *sessions;
+	struct Scsi_Host *shost;
+	struct fc_vport *fc_vport;
+	atomic_t enable;
+};
+
+/***************************************************************************
+ * Message Queues
+ *
+ */
+
+/**
+ * @brief EFCT message queue message
+ *
+ */
+
+struct efct_mqueue_hdr_s {
+	struct list_head list_entry;
+	void *msgdata;				/**< message data (payload) */
+};
+
+/*
+ * Define a structure used to pass to the interrupt handlers and the tasklets.
+ */
+struct efct_os_intr_context_s {
+	struct efct_s *efct;
+	u32 index;
+	struct completion done;
+	struct task_struct *thread;
+};
+
+/**
+ * @brief initialize an EFCT message queue
+ *
+ * The elements of the message queue  are initialized
+ *
+ * @param os OS handle
+ * @param q pointer to message queue
+ *
+ * @return returns 0 for success, a negative error code value for failure.
+ */
+
+static inline int
+efct_mqueue_init(struct efct_s *efct, struct efct_mqueue_s *q)
+{
+	memset(q, 0, sizeof(*q));
+	q->efct = efct;
+	spin_lock_init(&q->lock);
+	init_completion(&q->prod);
+	INIT_LIST_HEAD(&q->queue);
+	return 0;
+}
+
+/**
+ * @brief put a message in a message queue
+ *
+ * A message header is allocated, it's payload set to point to the
+ * requested message data, and the
+ * header posted to the message queue.
+ *
+ * @param q pointer to message queue
+ * @param msgdata pointer to message data
+ *
+ * @return returns 0 for success, a negative error code value for failure.
+ */
+
+static inline int
+efct_mqueue_put(struct efct_mqueue_s *q, void *msgdata)
+{
+	struct efct_mqueue_hdr_s *hdr = NULL;
+	unsigned long flags = 0;
+
+	hdr = kmalloc(sizeof(*hdr), GFP_ATOMIC);
+	if (!hdr)
+		return -1;
+
+	memset(hdr, 0, sizeof(*hdr));
+	hdr->msgdata = msgdata;
+
+	/* lock the queue wide lock, add to tail of linked list
+	 * and wake up the completion.
+	 */
+	spin_lock_irqsave(&q->lock, flags);
+		INIT_LIST_HEAD(&hdr->list_entry);
+		list_add_tail(&hdr->list_entry, &q->queue);
+	spin_unlock_irqrestore(&q->lock, flags);
+	complete(&q->prod);
+	return 0;
+}
+
+/**
+ * @brief read next message
+ *
+ * Reads next message header from the message queue, or times out.
+ * The timeout_usec value
+ * if zero will try one time, if negative will try forever, and if positive
+ * will try for that many micro-seconds.
+ *
+ * @param q pointer to message queue
+ * @param timeout_usec timeout
+ * (0 - try once, < 0 try forever, > 0 try micro-seconds)
+ *
+ * @return returns pointer to next message, or NULL
+ */
+
+static inline void *
+efct_mqueue_get(struct efct_mqueue_s *q, int timeout_usec)
+{
+	int rc;
+	struct efct_mqueue_hdr_s *hdr = NULL;
+	void *msgdata = NULL;
+	unsigned long flags = 0;
+
+	if (!q) {
+		pr_err("%s: q is NULL\n", __func__);
+		return NULL;
+	}
+
+	rc = wait_for_completion_timeout(&q->prod,
+					 usecs_to_jiffies(timeout_usec));
+	if (!rc)
+		return NULL;
+
+	spin_lock_irqsave(&q->lock, flags);
+	if (!list_empty(&q->queue)) {
+		hdr = list_first_entry(&q->queue,
+				       struct efct_mqueue_hdr_s, list_entry);
+		list_del(&hdr->list_entry);
+	}
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	if (hdr) {
+		msgdata = hdr->msgdata;
+		kfree(hdr);
+	}
+	return msgdata;
+}
+
+/**
+ * @brief free an EFCT message queue
+ *
+ * The message queue and its resources are free'd.
+ * In this case, the message queue is
+ * drained, and all the messages free'd
+ *
+ * @param q pointer to message queue
+ *
+ * @return none
+ */
+
+static inline void
+efct_mqueue_free(struct efct_mqueue_s *q)
+{
+	struct efct_mqueue_hdr_s *hdr;
+	struct efct_mqueue_hdr_s *next;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&q->lock, flags);
+	list_for_each_entry_safe(hdr, next, &q->queue, list_entry) {
+		pr_err("Warning: freeing queue, payload %p may leak\n",
+			    hdr->msgdata);
+		kfree(hdr);
+	}
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+
+#endif /*__EFCT_LIO_H__ */
-- 
2.13.7

