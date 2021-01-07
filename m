Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC827C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 00:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 870BD23123
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 00:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbhAGAv4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 19:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbhAGAvz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 19:51:55 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541B4C0612A7
        for <linux-scsi@vger.kernel.org>; Wed,  6 Jan 2021 16:51:00 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id n3so3239633pjm.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jan 2021 16:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4itcc8R/D4NS8ldrUhY6XKVSzR7GSv6iWWKv8oMUJ+Q=;
        b=KbSQntlCq6+3OQ5T6FroSEg146vSHHAjGCq+/8FjymjdGDuRhx/raAgLjhYch+cYA3
         OzQ9mDLQyVQXHwly6TQ3WXFKbj9hzg2jS+zGCu7XtrlonszSbw4bSSrAv7/aFTUnbabs
         3HMj+gGy5Cpzq6k1E0D5nsuCw7DnG6FF8DtxEEpLbEglIjIrAJ7RfT3MGk+N5Fdcvkzv
         2a1Nhq0dkMkATXgtc8/L0/OLNSlAxDidCSXsbvxhVzB5hfjCjH6RlWw8gIcvr5320nV8
         stxPcsTlQWz/auJupKopSkC/br1sr5lysVhoB0N68+6Ga1ItVYqDzxYR7mdule9AU4AS
         uILw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4itcc8R/D4NS8ldrUhY6XKVSzR7GSv6iWWKv8oMUJ+Q=;
        b=tSadJLr4VzLidDRGjN36wcSilKjlFNdyQOdsS9zpUpl7uZhbV7TDFJAE7lfugfZIDI
         AixwWu3fHWwv3vnvdEmkIm0dOBjK8LXuvevLQd+99UGj2NlS6o10h1ynQMMkw1SpzLRi
         UKeba4GrdbivbmdLXefAuKfVh7bgalR/mxXKxvdMT/3UMFGtnfHQAnUn6hnP8M8KXCzY
         V0hJUSYocwNnrKuLL97Hay8K71+ZVaa5NBO5PEYvJTChu+r+geOh8YuyTzx8Dt4pstxk
         vIHD8+/oN0huE4IPmluTuvikpLrOr9UFnJhn5lk+oaZNYhVBvbAB9dsPqJTAZw6b4P+n
         jIuA==
X-Gm-Message-State: AOAM530KmeSEXonIyyrp+Mh2WVaxOhwnN5iwDr9Zac/Q8nv+x59k+ddq
        Q2R1Lppr+mxm5uIXpgc5AF9m98l1wxxW8Q==
X-Google-Smtp-Source: ABdhPJw5UKscmReXRJ7IcB/7pkj8P6BmmUrgmZ4IHkJWlfrtPuyfsv+iBJXiDPtrz09ckWnKswJQKQ==
X-Received: by 2002:a17:90a:6604:: with SMTP id l4mr6717600pjj.119.1609980658847;
        Wed, 06 Jan 2021 16:50:58 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w27sm3600634pfq.104.2021.01.06.16.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 16:50:58 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v6 25/31] elx: efct: LIO backend interface routines
Date:   Wed,  6 Jan 2021 16:50:24 -0800
Message-Id: <20210107005030.2929-26-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107005030.2929-1-jsmart2021@gmail.com>
References: <20210107005030.2929-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
LIO backend template registration and template functions.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/elx/efct/efct_lio.c | 1689 ++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_lio.h |  189 ++++
 2 files changed, 1878 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_lio.c
 create mode 100644 drivers/scsi/elx/efct/efct_lio.h

diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
new file mode 100644
index 000000000000..9a5aeef3ecab
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -0,0 +1,1689 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include <target/target_core_base.h>
+#include <target/target_core_fabric.h>
+#include "efct_driver.h"
+#include "efct_lio.h"
+
+/*
+ * lio_wq is used to call the LIO backed during creation or deletion of
+ * sessions. This brings serialization to the session management as we create
+ * single threaded work queue.
+ */
+static struct workqueue_struct *lio_wq;
+
+static int
+efct_format_wwn(char *str, size_t len, const char *pre, u64 wwn)
+{
+	u8 a[8];
+
+	put_unaligned_be64(wwn, a);
+	return snprintf(str, len, "%s%8phC", pre, a);
+}
+
+static int
+efct_lio_parse_wwn(const char *name, u64 *wwp, u8 npiv)
+{
+	int num;
+	u8 b[8];
+
+	if (npiv) {
+		num = sscanf(name,
+			     "%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx",
+			     &b[0], &b[1], &b[2], &b[3], &b[4], &b[5], &b[6],
+			     &b[7]);
+	} else {
+		num = sscanf(name,
+		      "%02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx",
+			     &b[0], &b[1], &b[2], &b[3], &b[4], &b[5], &b[6],
+			     &b[7]);
+	}
+
+	if (num != 8)
+		return -EINVAL;
+
+	*wwp = get_unaligned_be64(b);
+	return EFC_SUCCESS;
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
+	if (rc)
+		return rc;
+
+	rc = efct_lio_parse_wwn(&name[17], wwnn, 1);
+	if (rc)
+		return rc;
+
+	return EFC_SUCCESS;
+}
+
+static ssize_t
+efct_lio_tpg_enable_show(struct config_item *item, char *page)
+{
+	struct se_portal_group *se_tpg = to_tpg(item);
+	struct efct_lio_tpg *tpg =
+		container_of(se_tpg, struct efct_lio_tpg, tpg);
+
+	return snprintf(page, PAGE_SIZE, "%d\n", atomic_read(&tpg->enabled));
+}
+
+static ssize_t
+efct_lio_tpg_enable_store(struct config_item *item, const char *page,
+			  size_t count)
+{
+	struct se_portal_group *se_tpg = to_tpg(item);
+	struct efct_lio_tpg *tpg =
+		container_of(se_tpg, struct efct_lio_tpg, tpg);
+	struct efct *efct;
+	struct efc *efc;
+	unsigned long op;
+
+	if (!tpg->nport || !tpg->nport->efct) {
+		pr_err("%s: Unable to find EFCT device\n", __func__);
+		return -EINVAL;
+	}
+
+	efct = tpg->nport->efct;
+	efc = efct->efcport;
+
+	if (kstrtoul(page, 0, &op) < 0)
+		return -EINVAL;
+
+	if (op == 1) {
+		int ret;
+
+		atomic_set(&tpg->enabled, 1);
+		efc_log_debug(efct, "enable portal group %d\n", tpg->tpgt);
+
+		ret = efct_xport_control(efct->xport, EFCT_XPORT_PORT_ONLINE);
+		if (ret) {
+			efct->tgt_efct.lio_nport = NULL;
+			efc_log_debug(efct, "cannot bring port online\n");
+			return ret;
+		}
+	} else if (op == 0) {
+		efc_log_debug(efct, "disable portal group %d\n", tpg->tpgt);
+
+		if (efc->domain && efc->domain->nport)
+			efct_scsi_tgt_del_nport(efc, efc->domain->nport);
+
+		atomic_set(&tpg->enabled, 0);
+	} else {
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+static ssize_t
+efct_lio_npiv_tpg_enable_show(struct config_item *item, char *page)
+{
+	struct se_portal_group *se_tpg = to_tpg(item);
+	struct efct_lio_tpg *tpg =
+		container_of(se_tpg, struct efct_lio_tpg, tpg);
+
+	return snprintf(page, PAGE_SIZE, "%d\n", atomic_read(&tpg->enabled));
+}
+
+static ssize_t
+efct_lio_npiv_tpg_enable_store(struct config_item *item, const char *page,
+			       size_t count)
+{
+	struct se_portal_group *se_tpg = to_tpg(item);
+	struct efct_lio_tpg *tpg =
+		container_of(se_tpg, struct efct_lio_tpg, tpg);
+	struct efct_lio_vport *lio_vport = tpg->vport;
+	struct efct *efct;
+	struct efc *efc;
+	unsigned long op;
+
+	if (kstrtoul(page, 0, &op) < 0)
+		return -EINVAL;
+
+	if (!lio_vport) {
+		pr_err("Unable to find vport\n");
+		return -EINVAL;
+	}
+
+	efct = lio_vport->efct;
+	efc = efct->efcport;
+
+	if (op == 1) {
+		atomic_set(&tpg->enabled, 1);
+		efc_log_debug(efct, "enable portal group %d\n", tpg->tpgt);
+
+		if (efc->domain) {
+			int ret;
+
+			ret = efc_nport_vport_new(efc->domain,
+						  lio_vport->npiv_wwpn,
+						  lio_vport->npiv_wwnn,
+						  U32_MAX, false, true,
+						  NULL, NULL);
+			if (ret != 0) {
+				efc_log_err(efct, "Failed to create Vport\n");
+				return ret;
+			}
+			return count;
+		}
+
+		if (!(efc_vport_create_spec(efc, lio_vport->npiv_wwnn,
+					    lio_vport->npiv_wwpn, U32_MAX,
+					    false, true, NULL, NULL)))
+			return -ENOMEM;
+
+	} else if (op == 0) {
+		efc_log_debug(efct, "disable portal group %d\n", tpg->tpgt);
+
+		atomic_set(&tpg->enabled, 0);
+		/* only physical nport should exist, free lio_nport
+		 * allocated in efct_lio_make_nport
+		 */
+		if (efc->domain) {
+			efc_nport_vport_del(efct->efcport, efc->domain,
+					    lio_vport->npiv_wwpn,
+					    lio_vport->npiv_wwnn);
+			return count;
+		}
+	} else {
+		return -EINVAL;
+	}
+	return count;
+}
+
+static char *efct_lio_get_fabric_wwn(struct se_portal_group *se_tpg)
+{
+	struct efct_lio_tpg *tpg =
+		container_of(se_tpg, struct efct_lio_tpg, tpg);
+
+	return tpg->nport->wwpn_str;
+}
+
+static char *efct_lio_get_npiv_fabric_wwn(struct se_portal_group *se_tpg)
+{
+	struct efct_lio_tpg *tpg =
+		container_of(se_tpg, struct efct_lio_tpg, tpg);
+
+	return tpg->vport->wwpn_str;
+}
+
+static u16 efct_lio_get_tag(struct se_portal_group *se_tpg)
+{
+	struct efct_lio_tpg *tpg =
+		container_of(se_tpg, struct efct_lio_tpg, tpg);
+
+	return tpg->tpgt;
+}
+
+static u16 efct_lio_get_npiv_tag(struct se_portal_group *se_tpg)
+{
+	struct efct_lio_tpg *tpg =
+		container_of(se_tpg, struct efct_lio_tpg, tpg);
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
+	struct efct_lio_tpg *tpg =
+		container_of(se_tpg, struct efct_lio_tpg, tpg);
+
+	return tpg->tpg_attrib.demo_mode_write_protect;
+}
+
+static int
+efct_lio_npiv_check_demo_write_protect(struct se_portal_group *se_tpg)
+{
+	struct efct_lio_tpg *tpg =
+		container_of(se_tpg, struct efct_lio_tpg, tpg);
+
+	return tpg->tpg_attrib.demo_mode_write_protect;
+}
+
+static int efct_lio_check_prod_write_protect(struct se_portal_group *se_tpg)
+{
+	struct efct_lio_tpg *tpg =
+		container_of(se_tpg, struct efct_lio_tpg, tpg);
+
+	return tpg->tpg_attrib.prod_mode_write_protect;
+}
+
+static int
+efct_lio_npiv_check_prod_write_protect(struct se_portal_group *se_tpg)
+{
+	struct efct_lio_tpg *tpg =
+		container_of(se_tpg, struct efct_lio_tpg, tpg);
+
+	return tpg->tpg_attrib.prod_mode_write_protect;
+}
+
+static u32 efct_lio_tpg_get_inst_index(struct se_portal_group *se_tpg)
+{
+	return EFC_SUCCESS;
+}
+
+static int efct_lio_check_stop_free(struct se_cmd *se_cmd)
+{
+	struct efct_scsi_tgt_io *ocp =
+		container_of(se_cmd, struct efct_scsi_tgt_io, cmd);
+	struct efct_io *io = container_of(ocp, struct efct_io, tgt_io);
+
+	efct_set_lio_io_state(io, EFCT_LIO_STATE_TFO_CHK_STOP_FREE);
+	return target_put_sess_cmd(se_cmd);
+}
+
+static int
+efct_lio_abort_tgt_cb(struct efct_io *io,
+		      enum efct_scsi_io_status scsi_status,
+		      u32 flags, void *arg)
+{
+	efct_lio_io_printf(io, "%s\n", __func__);
+	return EFC_SUCCESS;
+}
+
+static void
+efct_lio_aborted_task(struct se_cmd *se_cmd)
+{
+	struct efct_scsi_tgt_io *ocp =
+		container_of(se_cmd, struct efct_scsi_tgt_io, cmd);
+	struct efct_io *io = container_of(ocp, struct efct_io, tgt_io);
+
+	efct_set_lio_io_state(io, EFCT_LIO_STATE_TFO_ABORTED_TASK);
+
+	if (!(se_cmd->transport_state & CMD_T_ABORTED) || ocp->rsp_sent)
+		return;
+
+	/* command has been aborted, cleanup here */
+	ocp->aborting = true;
+	ocp->err = EFCT_SCSI_STATUS_ABORTED;
+	/* terminate the exchange */
+	efct_scsi_tgt_abort_io(io, efct_lio_abort_tgt_cb, NULL);
+}
+
+static void efct_lio_release_cmd(struct se_cmd *se_cmd)
+{
+	struct efct_scsi_tgt_io *ocp =
+		container_of(se_cmd, struct efct_scsi_tgt_io, cmd);
+	struct efct_io *io = container_of(ocp, struct efct_io, tgt_io);
+	struct efct *efct = io->efct;
+
+	efct_set_lio_io_state(io, EFCT_LIO_STATE_TFO_RELEASE_CMD);
+	efct_set_lio_io_state(io, EFCT_LIO_STATE_SCSI_CMPL_CMD);
+	efct_scsi_io_complete(io);
+	atomic_sub_return(1, &efct->tgt_efct.ios_in_use);
+}
+
+static void efct_lio_close_session(struct se_session *se_sess)
+{
+	struct efc_node *node = se_sess->fabric_sess_ptr;
+	struct efct *efct = NULL;
+	int rc;
+
+	pr_debug("se_sess=%p node=%p", se_sess, node);
+
+	if (!node) {
+		pr_debug("node is NULL");
+		return;
+	}
+
+	efct = node->efc->base;
+	rc = efct_xport_control(efct->xport, EFCT_XPORT_POST_NODE_EVENT, node,
+				EFCT_XPORT_SHUTDOWN);
+	if (rc != 0) {
+		efc_log_debug(efct,
+			      "Failed to shutdown session %p node %p\n",
+			     se_sess, node);
+		return;
+	}
+}
+
+static u32 efct_lio_sess_get_index(struct se_session *se_sess)
+{
+	return EFC_SUCCESS;
+}
+
+static void efct_lio_set_default_node_attrs(struct se_node_acl *nacl)
+{
+}
+
+static int efct_lio_get_cmd_state(struct se_cmd *se_cmd)
+{
+	return EFC_SUCCESS;
+}
+
+static int
+efct_lio_sg_map(struct efct_io *io)
+{
+	struct efct_scsi_tgt_io *ocp = &io->tgt_io;
+	struct se_cmd *cmd = &ocp->cmd;
+
+	ocp->seg_map_cnt = pci_map_sg(io->efct->pci, cmd->t_data_sg,
+				      cmd->t_data_nents, cmd->data_direction);
+	if (ocp->seg_map_cnt == 0)
+		return -EFAULT;
+	return EFC_SUCCESS;
+}
+
+static void
+efct_lio_sg_unmap(struct efct_io *io)
+{
+	struct efct_scsi_tgt_io *ocp = &io->tgt_io;
+	struct se_cmd *cmd = &ocp->cmd;
+
+	if (WARN_ON(!ocp->seg_map_cnt || !cmd->t_data_sg))
+		return;
+
+	pci_unmap_sg(io->efct->pci, cmd->t_data_sg,
+		     ocp->seg_map_cnt, cmd->data_direction);
+	ocp->seg_map_cnt = 0;
+}
+
+static int
+efct_lio_status_done(struct efct_io *io,
+		     enum efct_scsi_io_status scsi_status,
+		     u32 flags, void *arg)
+{
+	struct efct_scsi_tgt_io *ocp = &io->tgt_io;
+
+	efct_set_lio_io_state(io, EFCT_LIO_STATE_SCSI_RSP_DONE);
+	if (scsi_status != EFCT_SCSI_STATUS_GOOD) {
+		efct_lio_io_printf(io, "callback completed with error=%d\n",
+				   scsi_status);
+		ocp->err = scsi_status;
+	}
+	if (ocp->seg_map_cnt)
+		efct_lio_sg_unmap(io);
+
+	efct_lio_io_printf(io, "status=%d, err=%d flags=0x%x, dir=%d\n",
+				scsi_status, ocp->err, flags, ocp->ddir);
+
+	efct_set_lio_io_state(io, EFCT_LIO_STATE_TGT_GENERIC_FREE);
+	transport_generic_free_cmd(&io->tgt_io.cmd, 0);
+	return EFC_SUCCESS;
+}
+
+static int
+efct_lio_datamove_done(struct efct_io *io, enum efct_scsi_io_status scsi_status,
+		       u32 flags, void *arg);
+
+static int
+efct_lio_write_pending(struct se_cmd *cmd)
+{
+	struct efct_scsi_tgt_io *ocp =
+		container_of(cmd, struct efct_scsi_tgt_io, cmd);
+	struct efct_io *io = container_of(ocp, struct efct_io, tgt_io);
+	struct efct_scsi_sgl *sgl = io->sgl;
+	struct scatterlist *sg;
+	u32 flags = 0, cnt, curcnt;
+	u64 length = 0;
+	int rc = 0;
+
+	efct_set_lio_io_state(io, EFCT_LIO_STATE_TFO_WRITE_PENDING);
+	efct_lio_io_printf(io, "trans_state=0x%x se_cmd_flags=0x%x\n",
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
+		;/* do nothing */
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
+	rc = efct_scsi_recv_wr_data(io, flags, sgl, curcnt, length,
+				    efct_lio_datamove_done, NULL);
+	return rc;
+}
+
+static int
+efct_lio_queue_data_in(struct se_cmd *cmd)
+{
+	struct efct_scsi_tgt_io *ocp =
+		container_of(cmd, struct efct_scsi_tgt_io, cmd);
+	struct efct_io *io = container_of(ocp, struct efct_io, tgt_io);
+	struct efct_scsi_sgl *sgl = io->sgl;
+	struct scatterlist *sg = NULL;
+	uint flags = 0, cnt = 0, curcnt = 0;
+	u64 length = 0;
+	int rc = 0;
+
+	efct_set_lio_io_state(io, EFCT_LIO_STATE_TFO_QUEUE_DATA_IN);
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
+			struct efct_scsi_cmd_resp rsp;
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
+		ocp->seg_cnt = ocp->cur_seg;
+	}
+
+	/* If there is residual, disable Auto Good Response */
+	if (cmd->residual_count)
+		flags |= EFCT_SCSI_NO_AUTO_RESPONSE;
+
+	rc = efct_scsi_send_rd_data(io, flags, sgl, curcnt, length,
+				    efct_lio_datamove_done, NULL);
+	efct_set_lio_io_state(io, EFCT_LIO_STATE_SCSI_SEND_RD_DATA);
+	return rc;
+}
+
+static void
+efct_lio_send_resp(struct efct_io *io, enum efct_scsi_io_status scsi_status,
+		   u32 flags)
+{
+	struct efct_scsi_cmd_resp rsp;
+	struct efct_scsi_tgt_io *ocp = &io->tgt_io;
+	struct se_cmd *cmd = &io->tgt_io.cmd;
+	int rc;
+
+	if (flags & EFCT_SCSI_IO_CMPL_RSP_SENT) {
+		ocp->rsp_sent = true;
+		efct_set_lio_io_state(io, EFCT_LIO_STATE_TGT_GENERIC_FREE);
+		transport_generic_free_cmd(&io->tgt_io.cmd, 0);
+		return;
+	}
+
+	/* send check condition if an error occurred */
+	memset(&rsp, 0, sizeof(rsp));
+	rsp.scsi_status = cmd->scsi_status;
+	rsp.sense_data = (uint8_t *)io->tgt_io.sense_buffer;
+	rsp.sense_data_length = cmd->scsi_sense_length;
+
+	/* Check for residual underrun or overrun */
+	if (cmd->se_cmd_flags & SCF_OVERFLOW_BIT)
+		rsp.residual = -cmd->residual_count;
+	else if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT)
+		rsp.residual = cmd->residual_count;
+
+	rc = efct_scsi_send_resp(io, 0, &rsp, efct_lio_status_done, NULL);
+	efct_set_lio_io_state(io, EFCT_LIO_STATE_SCSI_SEND_RSP);
+	if (rc != 0) {
+		efct_lio_io_printf(io, "Read done, send rsp failed %d\n", rc);
+		efct_set_lio_io_state(io, EFCT_LIO_STATE_TGT_GENERIC_FREE);
+		transport_generic_free_cmd(&io->tgt_io.cmd, 0);
+	} else {
+		ocp->rsp_sent = true;
+	}
+}
+
+static int
+efct_lio_datamove_done(struct efct_io *io, enum efct_scsi_io_status scsi_status,
+		       u32 flags, void *arg)
+{
+	struct efct_scsi_tgt_io *ocp = &io->tgt_io;
+
+	efct_set_lio_io_state(io, EFCT_LIO_STATE_SCSI_DATA_DONE);
+	if (scsi_status != EFCT_SCSI_STATUS_GOOD) {
+		efct_lio_io_printf(io, "callback completed with error=%d\n",
+				   scsi_status);
+		ocp->err = scsi_status;
+	}
+	efct_lio_io_printf(io, "seg_map_cnt=%d\n", ocp->seg_map_cnt);
+	if (ocp->seg_map_cnt) {
+		if (ocp->err == EFCT_SCSI_STATUS_GOOD &&
+		    ocp->cur_seg < ocp->seg_cnt) {
+			int rc;
+
+			efct_lio_io_printf(io, "continuing cmd at segm=%d\n",
+					  ocp->cur_seg);
+			if (ocp->ddir == DMA_TO_DEVICE)
+				rc = efct_lio_write_pending(&ocp->cmd);
+			else
+				rc = efct_lio_queue_data_in(&ocp->cmd);
+			if (!rc)
+				return EFC_SUCCESS;
+
+			ocp->err = EFCT_SCSI_STATUS_ERROR;
+			efct_lio_io_printf(io, "could not continue command\n");
+		}
+		efct_lio_sg_unmap(io);
+	}
+
+	if (io->tgt_io.aborting) {
+		efct_lio_io_printf(io, "IO done aborted\n");
+		return EFC_SUCCESS;
+	}
+
+	if (ocp->ddir == DMA_TO_DEVICE) {
+		efct_lio_io_printf(io, "Write done, trans_state=0x%x\n",
+				  io->tgt_io.cmd.transport_state);
+		if (scsi_status != EFCT_SCSI_STATUS_GOOD) {
+			transport_generic_request_failure(&io->tgt_io.cmd,
+					TCM_CHECK_CONDITION_ABORT_CMD);
+			efct_set_lio_io_state(io,
+				EFCT_LIO_STATE_TGT_GENERIC_REQ_FAILURE);
+		} else {
+			efct_set_lio_io_state(io,
+						EFCT_LIO_STATE_TGT_EXECUTE_CMD);
+			target_execute_cmd(&io->tgt_io.cmd);
+		}
+	} else {
+		efct_lio_send_resp(io, scsi_status, flags);
+	}
+	return EFC_SUCCESS;
+}
+
+static int
+efct_lio_tmf_done(struct efct_io *io, enum efct_scsi_io_status scsi_status,
+		  u32 flags, void *arg)
+{
+	efct_lio_tmfio_printf(io, "cmd=%p status=%d, flags=0x%x\n",
+			      &io->tgt_io.cmd, scsi_status, flags);
+
+	efct_set_lio_io_state(io, EFCT_LIO_STATE_TGT_GENERIC_FREE);
+	transport_generic_free_cmd(&io->tgt_io.cmd, 0);
+	return EFC_SUCCESS;
+}
+
+static int
+efct_lio_null_tmf_done(struct efct_io *tmfio,
+		       enum efct_scsi_io_status scsi_status,
+		      u32 flags, void *arg)
+{
+	efct_lio_tmfio_printf(tmfio, "cmd=%p status=%d, flags=0x%x\n",
+			      &tmfio->tgt_io.cmd, scsi_status, flags);
+
+	/* free struct efct_io only, no active se_cmd */
+	efct_scsi_io_complete(tmfio);
+	return EFC_SUCCESS;
+}
+
+static int
+efct_lio_queue_status(struct se_cmd *cmd)
+{
+	struct efct_scsi_cmd_resp rsp;
+	struct efct_scsi_tgt_io *ocp =
+		container_of(cmd, struct efct_scsi_tgt_io, cmd);
+	struct efct_io *io = container_of(ocp, struct efct_io, tgt_io);
+	int rc = 0;
+
+	efct_set_lio_io_state(io, EFCT_LIO_STATE_TFO_QUEUE_STATUS);
+	efct_lio_io_printf(io,
+		"status=0x%x trans_state=0x%x se_cmd_flags=0x%x sns_len=%d\n",
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
+	efct_set_lio_io_state(io, EFCT_LIO_STATE_SCSI_SEND_RSP);
+	if (rc == 0)
+		ocp->rsp_sent = true;
+	return rc;
+}
+
+static void efct_lio_queue_tm_rsp(struct se_cmd *cmd)
+{
+	struct efct_scsi_tgt_io *ocp =
+		container_of(cmd, struct efct_scsi_tgt_io, cmd);
+	struct efct_io *tmfio = container_of(ocp, struct efct_io, tgt_io);
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
+static struct efct *efct_find_wwpn(u64 wwpn)
+{
+	struct efct *efct;
+
+	 /* Search for the HBA that has this WWPN */
+	list_for_each_entry(efct, &efct_devices, list_entry) {
+
+		if (wwpn == efct_get_wwpn(&efct->hw))
+			return efct;
+	}
+
+	return NULL;
+}
+
+static struct se_wwn *
+efct_lio_make_nport(struct target_fabric_configfs *tf,
+		    struct config_group *group, const char *name)
+{
+	struct efct_lio_nport *lio_nport;
+	struct efct *efct;
+	int ret;
+	u64 wwpn;
+
+	ret = efct_lio_parse_wwn(name, &wwpn, 0);
+	if (ret)
+		return ERR_PTR(ret);
+
+	efct = efct_find_wwpn(wwpn);
+	if (!efct) {
+		pr_err("cannot find EFCT for base wwpn %s\n", name);
+		return ERR_PTR(-ENXIO);
+	}
+
+	lio_nport = kzalloc(sizeof(*lio_nport), GFP_KERNEL);
+	if (!lio_nport)
+		return ERR_PTR(-ENOMEM);
+
+	lio_nport->efct = efct;
+	lio_nport->wwpn = wwpn;
+	efct_format_wwn(lio_nport->wwpn_str, sizeof(lio_nport->wwpn_str),
+			"naa.", wwpn);
+	efct->tgt_efct.lio_nport = lio_nport;
+
+	return &lio_nport->nport_wwn;
+}
+
+static struct se_wwn *
+efct_lio_npiv_make_nport(struct target_fabric_configfs *tf,
+			 struct config_group *group, const char *name)
+{
+	struct efct_lio_vport *lio_vport;
+	struct efct *efct;
+	int ret = -1;
+	u64 p_wwpn, npiv_wwpn, npiv_wwnn;
+	char *p, *pbuf, tmp[128];
+	struct efct_lio_vport_list_t *vport_list;
+	struct fc_vport *new_fc_vport;
+	struct fc_vport_identifiers vport_id;
+	unsigned long flags = 0;
+
+	snprintf(tmp, sizeof(tmp), "%s", name);
+	pbuf = &tmp[0];
+
+	p = strsep(&pbuf, "@");
+
+	if (!p || !pbuf) {
+		pr_err("Unable to find separator operator(@)\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	ret = efct_lio_parse_wwn(p, &p_wwpn, 0);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = efct_lio_parse_npiv_wwn(pbuf, strlen(pbuf), &npiv_wwpn,
+				      &npiv_wwnn);
+	if (ret)
+		return ERR_PTR(ret);
+
+	efct = efct_find_wwpn(p_wwpn);
+	if (!efct) {
+		pr_err("cannot find EFCT for base wwpn %s\n", name);
+		return ERR_PTR(-ENXIO);
+	}
+
+	lio_vport = kzalloc(sizeof(*lio_vport), GFP_KERNEL);
+	if (!lio_vport)
+		return ERR_PTR(-ENOMEM);
+
+	lio_vport->efct = efct;
+	lio_vport->wwpn = p_wwpn;
+	lio_vport->npiv_wwpn = npiv_wwpn;
+	lio_vport->npiv_wwnn = npiv_wwnn;
+
+	efct_format_wwn(lio_vport->wwpn_str, sizeof(lio_vport->wwpn_str),
+			"naa.", npiv_wwpn);
+
+	vport_list = kzalloc(sizeof(*vport_list), GFP_KERNEL);
+	if (!vport_list) {
+		kfree(lio_vport);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	vport_list->lio_vport = lio_vport;
+	spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
+	INIT_LIST_HEAD(&vport_list->list_entry);
+	list_add_tail(&vport_list->list_entry, &efct->tgt_efct.vport_list);
+	spin_unlock_irqrestore(&efct->tgt_efct.efct_lio_lock, flags);
+
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
+efct_lio_drop_nport(struct se_wwn *wwn)
+{
+	struct efct_lio_nport *lio_nport =
+		container_of(wwn, struct efct_lio_nport, nport_wwn);
+	struct efct *efct = lio_nport->efct;
+
+	/* only physical nport should exist, free lio_nport allocated
+	 * in efct_lio_make_nport.
+	 */
+	kfree(efct->tgt_efct.lio_nport);
+	efct->tgt_efct.lio_nport = NULL;
+}
+
+static void
+efct_lio_npiv_drop_nport(struct se_wwn *wwn)
+{
+	struct efct_lio_vport *lio_vport =
+		container_of(wwn, struct efct_lio_vport, vport_wwn);
+	struct efct_lio_vport_list_t *vport, *next_vport;
+	struct efct *efct = lio_vport->efct;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
+
+	if (lio_vport->fc_vport)
+		fc_vport_terminate(lio_vport->fc_vport);
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
+	struct efct_lio_nport *lio_nport =
+		container_of(wwn, struct efct_lio_nport, nport_wwn);
+	struct efct_lio_tpg *tpg;
+	struct efct *efct;
+	unsigned long n;
+	int ret;
+
+	if (strstr(name, "tpgt_") != name)
+		return ERR_PTR(-EINVAL);
+	if (kstrtoul(name + 5, 10, &n) || n > USHRT_MAX)
+		return ERR_PTR(-EINVAL);
+
+	tpg = kzalloc(sizeof(*tpg), GFP_KERNEL);
+	if (!tpg)
+		return ERR_PTR(-ENOMEM);
+
+	tpg->nport = lio_nport;
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
+	efct = lio_nport->efct;
+	efct->tgt_efct.tpg = tpg;
+	efc_log_debug(efct, "create portal group %d\n", tpg->tpgt);
+
+	xa_init(&efct->lookup);
+	return &tpg->tpg;
+}
+
+static void
+efct_lio_drop_tpg(struct se_portal_group *se_tpg)
+{
+	struct efct_lio_tpg *tpg =
+		container_of(se_tpg, struct efct_lio_tpg, tpg);
+
+	struct efct *efct = tpg->nport->efct;
+
+	efc_log_debug(efct, "drop portal group %d\n", tpg->tpgt);
+	tpg->nport->efct->tgt_efct.tpg = NULL;
+	core_tpg_deregister(se_tpg);
+	xa_destroy(&efct->lookup);
+	kfree(tpg);
+}
+
+static struct se_portal_group *
+efct_lio_npiv_make_tpg(struct se_wwn *wwn, const char *name)
+{
+	struct efct_lio_vport *lio_vport =
+		container_of(wwn, struct efct_lio_vport, vport_wwn);
+	struct efct_lio_tpg *tpg;
+	struct efct *efct;
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
+	struct efct_lio_tpg *tpg =
+		container_of(se_tpg, struct efct_lio_tpg, tpg);
+
+	efc_log_debug(tpg->vport->efct, "drop npiv portal group %d\n",
+		       tpg->tpgt);
+	core_tpg_deregister(se_tpg);
+	kfree(tpg);
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
+	efct_format_wwn(nacl->nport_name, sizeof(nacl->nport_name), "", wwnn);
+	return EFC_SUCCESS;
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
+static struct efct_lio_tpg *
+efct_get_vport_tpg(struct efc_node *node)
+{
+	struct efct *efct;
+	u64 wwpn = node->nport->wwpn;
+	struct efct_lio_vport_list_t *vport, *next;
+	struct efct_lio_vport *lio_vport = NULL;
+	struct efct_lio_tpg *tpg = NULL;
+	unsigned long flags = 0;
+
+	efct = node->efc->base;
+	spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
+	list_for_each_entry_safe(vport, next, &efct->tgt_efct.vport_list,
+				 list_entry) {
+		lio_vport = vport->lio_vport;
+		if (wwpn && lio_vport && lio_vport->npiv_wwpn == wwpn) {
+			efc_log_debug(efct, "found tpg on vport\n");
+			tpg = lio_vport->tpg;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&efct->tgt_efct.efct_lio_lock, flags);
+	return tpg;
+}
+
+static void
+_efct_tgt_node_free(struct kref *arg)
+{
+	struct efct_node *tgt_node = container_of(arg, struct efct_node, ref);
+	struct efc_node *node = tgt_node->node;
+
+	efc_scsi_del_initiator_complete(node->efc, node);
+	kfree(tgt_node);
+}
+
+static int efct_session_cb(struct se_portal_group *se_tpg,
+			   struct se_session *se_sess, void *private)
+{
+	struct efc_node *node = private;
+	struct efct_node *tgt_node = NULL;
+	struct efct *efct = node->efc->base;
+	u64 id;
+	u32 rc;
+
+	tgt_node = kzalloc(sizeof(*tgt_node), GFP_KERNEL);
+	if (!tgt_node)
+		return EFC_FAIL;
+
+	/* initialize refcount */
+	kref_init(&tgt_node->ref);
+	tgt_node->release = _efct_tgt_node_free;
+
+	tgt_node->session = se_sess;
+	node->tgt_node = tgt_node;
+	tgt_node->efct = efct;
+
+	tgt_node->node = node;
+
+	tgt_node->node_fc_id = node->rnode.fc_id;
+	tgt_node->port_fc_id = node->nport->fc_id;
+	tgt_node->vpi = node->nport->indicator;
+	tgt_node->rpi = node->rnode.indicator;
+
+	spin_lock_init(&tgt_node->active_ios_lock);
+	INIT_LIST_HEAD(&tgt_node->active_ios);
+
+	id = (u64) tgt_node->port_fc_id << 32 | tgt_node->node_fc_id;
+	efc_log_err(efct, "New Node id: %llx node:%p\n", id, tgt_node);
+	rc = xa_err(xa_store(&efct->lookup, id, tgt_node, GFP_KERNEL));
+	if (rc)
+		efc_log_err(efct, "Node lookup store failed: %d\n", rc);
+
+	efc_scsi_sess_reg_complete(node, EFC_SUCCESS);
+	return EFC_SUCCESS;
+}
+
+int efct_scsi_tgt_new_device(struct efct *efct)
+{
+	int rc = 0;
+	u32 total_ios;
+
+	/* Get the max settings */
+	efct->tgt_efct.max_sge = sli_get_max_sge(&efct->hw.sli);
+	efct->tgt_efct.max_sgl = sli_get_max_sgl(&efct->hw.sli);
+
+	/* initialize IO watermark fields */
+	atomic_set(&efct->tgt_efct.ios_in_use, 0);
+	total_ios = efct->hw.config.n_io;
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
+	lio_wq = create_singlethread_workqueue("efct_lio_worker");
+	if (!lio_wq) {
+		efc_log_err(efct, "workqueue create failed\n");
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&efct->tgt_efct.efct_lio_lock);
+	INIT_LIST_HEAD(&efct->tgt_efct.vport_list);
+
+	return rc;
+}
+
+int efct_scsi_tgt_del_device(struct efct *efct)
+{
+	flush_workqueue(lio_wq);
+
+	return EFC_SUCCESS;
+}
+
+int
+efct_scsi_tgt_new_nport(struct efc *efc, struct efc_nport *nport)
+{
+	struct efct *efct = nport->efc->base;
+
+	efc_log_debug(efct, "New SPORT: %s bound to %s\n", nport->display_name,
+		       efct->tgt_efct.lio_nport->wwpn_str);
+
+	return EFC_SUCCESS;
+}
+
+void
+efct_scsi_tgt_del_nport(struct efc *efc, struct efc_nport *nport)
+{
+	efc_log_debug(efc, "Del SPORT: %s\n", nport->display_name);
+}
+
+static void efct_lio_setup_session(struct work_struct *work)
+{
+	struct efct_lio_wq_data *wq_data =
+		container_of(work, struct efct_lio_wq_data, work);
+	struct efct *efct = wq_data->efct;
+	struct efc_node *node = wq_data->ptr;
+	char wwpn[WWN_NAME_LEN];
+	struct efct_lio_tpg *tpg = NULL;
+	struct se_portal_group *se_tpg;
+	struct se_session *se_sess;
+	int watermark;
+	int ini_count;
+
+	/* Check to see if it's belongs to vport,
+	 * if not get physical port
+	 */
+	tpg = efct_get_vport_tpg(node);
+	if (tpg) {
+		se_tpg = &tpg->tpg;
+	} else if (efct->tgt_efct.tpg) {
+		tpg = efct->tgt_efct.tpg;
+		se_tpg = &tpg->tpg;
+	} else {
+		efc_log_err(efct, "failed to init session\n");
+		return;
+	}
+
+	/*
+	 * Format the FCP Initiator port_name into colon
+	 * separated values to match the format by our explicit
+	 * ConfigFS NodeACLs.
+	 */
+	efct_format_wwn(wwpn, sizeof(wwpn), "",	efc_node_get_wwpn(node));
+
+	se_sess = target_setup_session(se_tpg, 0, 0, TARGET_PROT_NORMAL, wwpn,
+				       node, efct_session_cb);
+	if (IS_ERR(se_sess)) {
+		efc_log_err(efct, "failed to setup session\n");
+		kfree(wq_data);
+		efc_scsi_sess_reg_complete(node, EFC_FAIL);
+		return;
+	}
+
+	efc_log_debug(efct, "new initiator sess=%p node=%p\n", se_sess, node);
+
+	/* update IO watermark: increment initiator count */
+	ini_count = atomic_add_return(1, &efct->tgt_efct.initiator_count);
+	watermark = efct->tgt_efct.watermark_max -
+		    ini_count * EFCT_IO_WATERMARK_PER_INITIATOR;
+	watermark = (efct->tgt_efct.watermark_min > watermark) ?
+			efct->tgt_efct.watermark_min : watermark;
+	atomic_set(&efct->tgt_efct.io_high_watermark, watermark);
+
+	kfree(wq_data);
+}
+
+int efct_scsi_new_initiator(struct efc *efc, struct efc_node *node)
+{
+	struct efct *efct = node->efc->base;
+	struct efct_lio_wq_data *wq_data;
+
+	/*
+	 * Since LIO only supports initiator validation at thread level,
+	 * we are open minded and accept all callers.
+	 */
+	wq_data = kzalloc(sizeof(*wq_data), GFP_ATOMIC);
+	if (!wq_data)
+		return -ENOMEM;
+
+	wq_data->ptr = node;
+	wq_data->efct = efct;
+	INIT_WORK(&wq_data->work, efct_lio_setup_session);
+	queue_work(lio_wq, &wq_data->work);
+	return EFCT_SCSI_CALL_ASYNC;
+}
+
+static void efct_lio_remove_session(struct work_struct *work)
+{
+	struct efct_lio_wq_data *wq_data =
+		container_of(work, struct efct_lio_wq_data, work);
+	struct efct *efct = wq_data->efct;
+	struct efc_node *node = wq_data->ptr;
+	struct efct_node *tgt_node = NULL;
+	struct se_session *se_sess;
+
+	tgt_node = node->tgt_node;
+	se_sess = tgt_node->session;
+
+	if (!se_sess) {
+		/* base driver has sent back-to-back requests
+		 * to unreg session with no intervening
+		 * register
+		 */
+		efc_log_err(efct, "unreg session for NULL session\n");
+		efc_scsi_del_initiator_complete(node->efc, node);
+		return;
+	}
+
+	efc_log_debug(efct, "unreg session se_sess=%p node=%p\n",
+		       se_sess, node);
+
+	/* first flag all session commands to complete */
+	target_stop_session(se_sess);
+
+	/* now wait for session commands to complete */
+	target_wait_for_sess_cmds(se_sess);
+	target_remove_session(se_sess);
+
+	kref_put(&tgt_node->ref, tgt_node->release);
+
+	kfree(wq_data);
+}
+
+int efct_scsi_del_initiator(struct efc *efc, struct efc_node *node, int reason)
+{
+	struct efct *efct = node->efc->base;
+	struct efct_node *tgt_node = node->tgt_node;
+	struct efct_lio_wq_data *wq_data;
+	int watermark;
+	int ini_count;
+	u64 id;
+
+	if (reason == EFCT_SCSI_INITIATOR_MISSING)
+		return EFCT_SCSI_CALL_COMPLETE;
+
+	wq_data = kzalloc(sizeof(*wq_data), GFP_ATOMIC);
+	if (!wq_data)
+		return EFCT_SCSI_CALL_COMPLETE;
+
+	id = (u64) tgt_node->port_fc_id << 32 | tgt_node->node_fc_id;
+	xa_erase(&efct->lookup, id);
+
+	wq_data->ptr = node;
+	wq_data->efct = efct;
+	INIT_WORK(&wq_data->work, efct_lio_remove_session);
+	queue_work(lio_wq, &wq_data->work);
+
+	/*
+	 * update IO watermark: decrement initiator count
+	 */
+	ini_count = atomic_sub_return(1, &efct->tgt_efct.initiator_count);
+
+	watermark = efct->tgt_efct.watermark_max -
+		    ini_count * EFCT_IO_WATERMARK_PER_INITIATOR;
+	watermark = (efct->tgt_efct.watermark_min > watermark) ?
+			efct->tgt_efct.watermark_min : watermark;
+	atomic_set(&efct->tgt_efct.io_high_watermark, watermark);
+
+	return EFCT_SCSI_CALL_ASYNC;
+}
+
+int efct_scsi_recv_cmd(struct efct_io *io, uint64_t lun, u8 *cdb,
+		       u32 cdb_len, u32 flags)
+{
+	struct efct_scsi_tgt_io *ocp = &io->tgt_io;
+	struct efct *efct = io->efct;
+	char *ddir;
+	struct efct_node *tgt_node = NULL;
+	struct se_session *se_sess;
+	int rc = 0;
+
+	memset(ocp, 0, sizeof(struct efct_scsi_tgt_io));
+	efct_set_lio_io_state(io, EFCT_LIO_STATE_SCSI_RECV_CMD);
+	atomic_add_return(1, &efct->tgt_efct.ios_in_use);
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
+		ocp->ddir = DMA_TO_DEVICE;
+		break;
+	case EFCT_SCSI_CMD_DIR_OUT:
+		ddir = "TO_INITIATOR";
+		ocp->ddir = DMA_FROM_DEVICE;
+		break;
+	case EFCT_SCSI_CMD_DIR_IN | EFCT_SCSI_CMD_DIR_OUT:
+		ddir = "BIDIR";
+		ocp->ddir = DMA_BIDIRECTIONAL;
+		break;
+	default:
+		ddir = "NONE";
+		ocp->ddir = DMA_NONE;
+		break;
+	}
+
+	ocp->lun = lun;
+	efct_lio_io_printf(io, "new cmd=0x%x ddir=%s dl=%u\n",
+			  cdb[0], ddir, io->exp_xfer_len);
+
+	tgt_node = io->node;
+	se_sess = tgt_node->session;
+	if (se_sess) {
+		efct_set_lio_io_state(io, EFCT_LIO_STATE_TGT_SUBMIT_CMD);
+		rc = target_submit_cmd(&io->tgt_io.cmd, se_sess,
+				       cdb, &io->tgt_io.sense_buffer[0],
+				       ocp->lun, io->exp_xfer_len,
+				       ocp->task_attr, ocp->ddir,
+				       TARGET_SCF_ACK_KREF);
+		if (rc) {
+			efc_log_err(efct, "failed to submit cmd se_cmd: %p\n",
+				    &ocp->cmd);
+			efct_scsi_io_free(io);
+		}
+	}
+
+	return rc;
+}
+
+int
+efct_scsi_recv_tmf(struct efct_io *tmfio, u32 lun, enum efct_scsi_tmf_cmd cmd,
+		   struct efct_io *io_to_abort, u32 flags)
+{
+	unsigned char tmr_func;
+	struct efct *efct = tmfio->efct;
+	struct efct_scsi_tgt_io *ocp = &tmfio->tgt_io;
+	struct efct_node *tgt_node = NULL;
+	struct se_session *se_sess;
+	int rc;
+
+	memset(ocp, 0, sizeof(struct efct_scsi_tgt_io));
+	efct_set_lio_io_state(tmfio, EFCT_LIO_STATE_SCSI_RECV_TMF);
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
+		goto tmf_fail;
+	}
+
+	tmfio->tgt_io.tmf = tmr_func;
+	tmfio->tgt_io.lun = lun;
+	tmfio->tgt_io.io_to_abort = io_to_abort;
+
+	tgt_node = tmfio->node;
+
+	se_sess = tgt_node->session;
+	if (!se_sess)
+		return EFC_SUCCESS;
+
+	rc = target_submit_tmr(&ocp->cmd, se_sess, NULL, lun, ocp, tmr_func,
+			GFP_ATOMIC, tmfio->init_task_tag, TARGET_SCF_ACK_KREF);
+
+	efct_set_lio_io_state(tmfio, EFCT_LIO_STATE_TGT_SUBMIT_TMR);
+	if (rc)
+		goto tmf_fail;
+
+	return EFC_SUCCESS;
+
+tmf_fail:
+	efct_scsi_send_tmf_resp(tmfio, EFCT_SCSI_TMF_FUNCTION_REJECTED,
+				NULL, efct_lio_null_tmf_done, NULL);
+	return EFC_SUCCESS;
+}
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
+		return ret;						  \
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
+		return ret;						   \
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
+CONFIGFS_ATTR(efct_lio_tpg_, enable);
+static struct configfs_attribute *efct_lio_tpg_attrs[] = {
+				&efct_lio_tpg_attr_enable, NULL };
+CONFIGFS_ATTR(efct_lio_npiv_tpg_, enable);
+static struct configfs_attribute *efct_lio_npiv_tpg_attrs[] = {
+				&efct_lio_npiv_tpg_attr_enable, NULL };
+
+static const struct target_core_fabric_ops efct_lio_ops = {
+	.module				= THIS_MODULE,
+	.fabric_name			= "efct",
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
+	.fabric_make_wwn		= efct_lio_make_nport,
+	.fabric_drop_wwn		= efct_lio_drop_nport,
+	.fabric_make_tpg		= efct_lio_make_tpg,
+	.fabric_drop_tpg		= efct_lio_drop_tpg,
+	.tpg_check_demo_mode_login_only = efct_lio_check_demo_mode_login_only,
+	.tpg_check_prot_fabric_only	= NULL,
+	.sess_get_initiator_sid		= NULL,
+	.tfc_tpg_base_attrs		= efct_lio_tpg_attrs,
+	.tfc_tpg_attrib_attrs           = efct_lio_tpg_attrib_attrs,
+};
+
+static const struct target_core_fabric_ops efct_lio_npiv_ops = {
+	.module				= THIS_MODULE,
+	.fabric_name			= "efct_npiv",
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
+	.fabric_make_wwn		= efct_lio_npiv_make_nport,
+	.fabric_drop_wwn		= efct_lio_npiv_drop_nport,
+	.fabric_make_tpg		= efct_lio_npiv_make_tpg,
+	.fabric_drop_tpg		= efct_lio_npiv_drop_tpg,
+	.tpg_check_demo_mode_login_only =
+				efct_lio_npiv_check_demo_mode_login_only,
+	.tpg_check_prot_fabric_only	= NULL,
+	.sess_get_initiator_sid		= NULL,
+	.tfc_tpg_base_attrs		= efct_lio_npiv_tpg_attrs,
+	.tfc_tpg_attrib_attrs		= efct_lio_npiv_tpg_attrib_attrs,
+};
+
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
+	return EFC_SUCCESS;
+}
+
+int efct_scsi_tgt_driver_exit(void)
+{
+	target_unregister_template(&efct_lio_ops);
+	target_unregister_template(&efct_lio_npiv_ops);
+	return EFC_SUCCESS;
+}
diff --git a/drivers/scsi/elx/efct/efct_lio.h b/drivers/scsi/elx/efct/efct_lio.h
new file mode 100644
index 000000000000..86337f2417b0
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_lio.h
@@ -0,0 +1,189 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#ifndef __EFCT_LIO_H__
+#define __EFCT_LIO_H__
+
+#include "efct_scsi.h"
+#include <target/target_core_base.h>
+
+#define efct_lio_io_printf(io, fmt, ...)			\
+	efc_log_debug(io->efct,					\
+		"[%s] [%04x][i:%04x t:%04x h:%04x]" fmt,\
+		io->node->display_name, io->instance_index,	\
+		io->init_task_tag, io->tgt_task_tag, io->hw_tag,\
+		##__VA_ARGS__)
+
+#define efct_lio_tmfio_printf(io, fmt, ...)			\
+	efc_log_debug(io->efct,					\
+		"[%s] [%04x][i:%04x t:%04x h:%04x][f:%02x]" fmt,\
+		io->node->display_name, io->instance_index,	\
+		io->init_task_tag, io->tgt_task_tag, io->hw_tag,\
+		io->tgt_io.tmf,  ##__VA_ARGS__)
+
+#define efct_set_lio_io_state(io, value) (io->tgt_io.state |= value)
+
+struct efct_lio_wq_data {
+	struct efct		*efct;
+	void			*ptr;
+	struct work_struct	work;
+};
+
+/* Target private efct structure */
+struct efct_scsi_tgt {
+	u32			max_sge;
+	u32			max_sgl;
+
+	/*
+	 * Variables used to send task set full. We are using a high watermark
+	 * method to send task set full. We will reserve a fixed number of IOs
+	 * per initiator plus a fudge factor. Once we reach this number,
+	 * then the target will start sending task set full/busy responses.
+	 */
+	atomic_t		initiator_count;
+	atomic_t		ios_in_use;
+	atomic_t		io_high_watermark;
+
+	atomic_t		watermark_hit;
+	int			watermark_min;
+	int			watermark_max;
+
+	struct efct_lio_nport	*lio_nport;
+	struct efct_lio_tpg	*tpg;
+
+	struct list_head	vport_list;
+	/* Protects vport list*/
+	spinlock_t		efct_lio_lock;
+
+	u64			wwnn;
+};
+
+struct efct_scsi_tgt_nport {
+	struct efct_lio_nport	*lio_nport;
+};
+
+struct efct_node {
+	struct list_head	list_entry;
+	struct kref		ref;
+	void			(*release)(struct kref *arg);
+	struct efct		*efct;
+	struct efc_node		*node;
+	struct se_session	*session;
+	spinlock_t		active_ios_lock;
+	struct list_head	active_ios;
+	char			display_name[EFC_NAME_LENGTH];
+	u32			port_fc_id;
+	u32			node_fc_id;
+	u32			vpi;
+	u32			rpi;
+	u32			abort_cnt;
+};
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
+#define EFCT_LIO_STATE_SCSI_CMPL_CMD		(1u << 31)
+
+struct efct_scsi_tgt_io {
+	struct se_cmd		cmd;
+	unsigned char		sense_buffer[TRANSPORT_SENSE_BUFFER];
+	enum dma_data_direction	ddir;
+	int			task_attr;
+	u64			lun;
+
+	u32			state;
+	u8			tmf;
+	struct efct_io		*io_to_abort;
+	u32			seg_map_cnt;
+	u32			seg_cnt;
+	u32			cur_seg;
+	enum efct_scsi_io_status err;
+	bool			aborting;
+	bool			rsp_sent;
+	uint32_t		transferred_len;
+};
+
+/* Handler return codes */
+enum {
+	SCSI_HANDLER_DATAPHASE_STARTED = 1,
+	SCSI_HANDLER_RESP_STARTED,
+	SCSI_HANDLER_VALIDATED_DATAPHASE_STARTED,
+	SCSI_CMD_NOT_SUPPORTED,
+};
+
+#define WWN_NAME_LEN		32
+struct efct_lio_vport {
+	u64			wwpn;
+	u64			npiv_wwpn;
+	u64			npiv_wwnn;
+	unsigned char		wwpn_str[WWN_NAME_LEN];
+	struct se_wwn		vport_wwn;
+	struct efct_lio_tpg	*tpg;
+	struct efct		*efct;
+	struct Scsi_Host	*shost;
+	struct fc_vport		*fc_vport;
+	atomic_t		enable;
+};
+
+struct efct_lio_nport {
+	u64			wwpn;
+	unsigned char		wwpn_str[WWN_NAME_LEN];
+	struct se_wwn		nport_wwn;
+	struct efct_lio_tpg	*tpg;
+	struct efct		*efct;
+	atomic_t		enable;
+};
+
+struct efct_lio_tpg_attrib {
+	u32			generate_node_acls;
+	u32			cache_dynamic_acls;
+	u32			demo_mode_write_protect;
+	u32			prod_mode_write_protect;
+	u32			demo_mode_login_only;
+	bool			session_deletion_wait;
+};
+
+struct efct_lio_tpg {
+	struct se_portal_group	tpg;
+	struct efct_lio_nport	*nport;
+	struct efct_lio_vport	*vport;
+	struct efct_lio_tpg_attrib tpg_attrib;
+	unsigned short		tpgt;
+	atomic_t		enabled;
+};
+
+struct efct_lio_nacl {
+	u64			nport_wwnn;
+	char			nport_name[WWN_NAME_LEN];
+	struct se_session	*session;
+	struct se_node_acl	se_node_acl;
+};
+
+struct efct_lio_vport_list_t {
+	struct list_head	list_entry;
+	struct efct_lio_vport	*lio_vport;
+};
+
+int efct_scsi_tgt_driver_init(void);
+int efct_scsi_tgt_driver_exit(void);
+
+#endif /*__EFCT_LIO_H__ */
-- 
2.26.2

