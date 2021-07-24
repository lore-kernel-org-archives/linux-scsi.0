Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D55DC4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 17:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D4C060E98
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 17:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhGXQjJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jul 2021 12:39:09 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:46950 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229461AbhGXQjI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 24 Jul 2021 12:39:08 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 60473128035C;
        Sat, 24 Jul 2021 10:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1627147180;
        bh=JgTMpGUv0Z5sytMpSJR9vxj8MWh6yRMbsrUMcqmgYI8=;
        h=Message-ID:Subject:From:To:Date:From;
        b=uOMZ92HuL4CL7QPtet0R+x1Z5kpBQCnszyAP2N8FykaHEsa7Q58I5ymPQhXYClS8n
         1qdkj0oMaLSpEIgUN6bMxwmWhH+08H8zG4LomJroaVXI84US4mCaOrjounVT7jjvTC
         AUX9Ec/OzHXxSP+rnMUCL2cNd0iWbY/rIVt2Pbf8=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id j798SlnCqots; Sat, 24 Jul 2021 10:19:40 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 05FAC1280358;
        Sat, 24 Jul 2021 10:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1627147180;
        bh=JgTMpGUv0Z5sytMpSJR9vxj8MWh6yRMbsrUMcqmgYI8=;
        h=Message-ID:Subject:From:To:Date:From;
        b=uOMZ92HuL4CL7QPtet0R+x1Z5kpBQCnszyAP2N8FykaHEsa7Q58I5ymPQhXYClS8n
         1qdkj0oMaLSpEIgUN6bMxwmWhH+08H8zG4LomJroaVXI84US4mCaOrjounVT7jjvTC
         AUX9Ec/OzHXxSP+rnMUCL2cNd0iWbY/rIVt2Pbf8=
Message-ID: <f3170ad9241f47278fa2bcb8c2e95a7e1b7dba68.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.14-rc2
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 24 Jul 2021 10:19:38 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Four fixes, all in drivers, all of which can lead to user visible
problems in certain situations.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

David Disseldorp (1):
      scsi: target: Fix NULL dereference on XCOPY completion

Dmitry Bogdanov (1):
      scsi: target: Fix protect handling in WRITE SAME(32)

Mike Christie (1):
      scsi: iscsi: Fix iface sysfs attr detection

Sreekanth Reddy (1):
      scsi: mpt3sas: Transition IOC to Ready state during shutdown

And the diffstat:

 drivers/scsi/mpt3sas/mpt3sas_base.c    | 32 ++++++------
 drivers/scsi/mpt3sas/mpt3sas_base.h    |  4 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c   |  7 ++-
 drivers/scsi/scsi_transport_iscsi.c    | 90 +++++++++++++---------------------
 drivers/target/target_core_sbc.c       | 35 +++++++------
 drivers/target/target_core_transport.c |  2 +-
 6 files changed, 78 insertions(+), 92 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index c39955239d1c..19b1c0cf5f2a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2983,13 +2983,13 @@ _base_check_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
- * _base_free_irq - free irq
+ * mpt3sas_base_free_irq - free irq
  * @ioc: per adapter object
  *
  * Freeing respective reply_queue from the list.
  */
-static void
-_base_free_irq(struct MPT3SAS_ADAPTER *ioc)
+void
+mpt3sas_base_free_irq(struct MPT3SAS_ADAPTER *ioc)
 {
 	struct adapter_reply_queue *reply_q, *next;
 
@@ -3191,12 +3191,12 @@ _base_check_and_enable_high_iops_queues(struct MPT3SAS_ADAPTER *ioc,
 }
 
 /**
- * _base_disable_msix - disables msix
+ * mpt3sas_base_disable_msix - disables msix
  * @ioc: per adapter object
  *
  */
-static void
-_base_disable_msix(struct MPT3SAS_ADAPTER *ioc)
+void
+mpt3sas_base_disable_msix(struct MPT3SAS_ADAPTER *ioc)
 {
 	if (!ioc->msix_enable)
 		return;
@@ -3304,8 +3304,8 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	for (i = 0; i < ioc->reply_queue_count; i++) {
 		r = _base_request_irq(ioc, i);
 		if (r) {
-			_base_free_irq(ioc);
-			_base_disable_msix(ioc);
+			mpt3sas_base_free_irq(ioc);
+			mpt3sas_base_disable_msix(ioc);
 			goto try_ioapic;
 		}
 	}
@@ -3342,8 +3342,8 @@ mpt3sas_base_unmap_resources(struct MPT3SAS_ADAPTER *ioc)
 
 	dexitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
-	_base_free_irq(ioc);
-	_base_disable_msix(ioc);
+	mpt3sas_base_free_irq(ioc);
+	mpt3sas_base_disable_msix(ioc);
 
 	kfree(ioc->replyPostRegisterIndex);
 	ioc->replyPostRegisterIndex = NULL;
@@ -7613,14 +7613,14 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
- * _base_make_ioc_ready - put controller in READY state
+ * mpt3sas_base_make_ioc_ready - put controller in READY state
  * @ioc: per adapter object
  * @type: FORCE_BIG_HAMMER or SOFT_RESET
  *
  * Return: 0 for success, non-zero for failure.
  */
-static int
-_base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc, enum reset_type type)
+int
+mpt3sas_base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc, enum reset_type type)
 {
 	u32 ioc_state;
 	int rc;
@@ -7897,7 +7897,7 @@ mpt3sas_base_free_resources(struct MPT3SAS_ADAPTER *ioc)
 	if (ioc->chip_phys && ioc->chip) {
 		mpt3sas_base_mask_interrupts(ioc);
 		ioc->shost_recovery = 1;
-		_base_make_ioc_ready(ioc, SOFT_RESET);
+		mpt3sas_base_make_ioc_ready(ioc, SOFT_RESET);
 		ioc->shost_recovery = 0;
 	}
 
@@ -8017,7 +8017,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	ioc->build_sg_mpi = &_base_build_sg;
 	ioc->build_zero_len_sge_mpi = &_base_build_zero_len_sge;
 
-	r = _base_make_ioc_ready(ioc, SOFT_RESET);
+	r = mpt3sas_base_make_ioc_ready(ioc, SOFT_RESET);
 	if (r)
 		goto out_free_resources;
 
@@ -8471,7 +8471,7 @@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 	_base_pre_reset_handler(ioc);
 	mpt3sas_wait_for_commands_to_complete(ioc);
 	mpt3sas_base_mask_interrupts(ioc);
-	r = _base_make_ioc_ready(ioc, type);
+	r = mpt3sas_base_make_ioc_ready(ioc, type);
 	if (r)
 		goto out;
 	_base_clear_outstanding_commands(ioc);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index d4834c8ee9c0..0c6c3df0038d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1730,6 +1730,10 @@ do {	ioc_err(ioc, "In func: %s\n", __func__); \
 	status, mpi_request, sz); } while (0)
 
 int mpt3sas_wait_for_ioc(struct MPT3SAS_ADAPTER *ioc, int wait_count);
+int
+mpt3sas_base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc, enum reset_type type);
+void mpt3sas_base_free_irq(struct MPT3SAS_ADAPTER *ioc);
+void mpt3sas_base_disable_msix(struct MPT3SAS_ADAPTER *ioc);
 
 /* scsih shared API */
 struct scsi_cmnd *mpt3sas_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 866d118f7931..8e64a6f14542 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11295,7 +11295,12 @@ scsih_shutdown(struct pci_dev *pdev)
 
 	_scsih_ir_shutdown(ioc);
 	_scsih_nvme_shutdown(ioc);
-	mpt3sas_base_detach(ioc);
+	mpt3sas_base_mask_interrupts(ioc);
+	ioc->shost_recovery = 1;
+	mpt3sas_base_make_ioc_ready(ioc, SOFT_RESET);
+	ioc->shost_recovery = 0;
+	mpt3sas_base_free_irq(ioc);
+	mpt3sas_base_disable_msix(ioc);
 }
 
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index b07105ae7c91..d8b05d8b5470 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -439,39 +439,10 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct iscsi_iface *iface = iscsi_dev_to_iface(dev);
 	struct iscsi_transport *t = iface->transport;
-	int param;
-	int param_type;
+	int param = -1;
 
 	if (attr == &dev_attr_iface_enabled.attr)
 		param = ISCSI_NET_PARAM_IFACE_ENABLE;
-	else if (attr == &dev_attr_iface_vlan_id.attr)
-		param = ISCSI_NET_PARAM_VLAN_ID;
-	else if (attr == &dev_attr_iface_vlan_priority.attr)
-		param = ISCSI_NET_PARAM_VLAN_PRIORITY;
-	else if (attr == &dev_attr_iface_vlan_enabled.attr)
-		param = ISCSI_NET_PARAM_VLAN_ENABLED;
-	else if (attr == &dev_attr_iface_mtu.attr)
-		param = ISCSI_NET_PARAM_MTU;
-	else if (attr == &dev_attr_iface_port.attr)
-		param = ISCSI_NET_PARAM_PORT;
-	else if (attr == &dev_attr_iface_ipaddress_state.attr)
-		param = ISCSI_NET_PARAM_IPADDR_STATE;
-	else if (attr == &dev_attr_iface_delayed_ack_en.attr)
-		param = ISCSI_NET_PARAM_DELAYED_ACK_EN;
-	else if (attr == &dev_attr_iface_tcp_nagle_disable.attr)
-		param = ISCSI_NET_PARAM_TCP_NAGLE_DISABLE;
-	else if (attr == &dev_attr_iface_tcp_wsf_disable.attr)
-		param = ISCSI_NET_PARAM_TCP_WSF_DISABLE;
-	else if (attr == &dev_attr_iface_tcp_wsf.attr)
-		param = ISCSI_NET_PARAM_TCP_WSF;
-	else if (attr == &dev_attr_iface_tcp_timer_scale.attr)
-		param = ISCSI_NET_PARAM_TCP_TIMER_SCALE;
-	else if (attr == &dev_attr_iface_tcp_timestamp_en.attr)
-		param = ISCSI_NET_PARAM_TCP_TIMESTAMP_EN;
-	else if (attr == &dev_attr_iface_cache_id.attr)
-		param = ISCSI_NET_PARAM_CACHE_ID;
-	else if (attr == &dev_attr_iface_redirect_en.attr)
-		param = ISCSI_NET_PARAM_REDIRECT_EN;
 	else if (attr == &dev_attr_iface_def_taskmgmt_tmo.attr)
 		param = ISCSI_IFACE_PARAM_DEF_TASKMGMT_TMO;
 	else if (attr == &dev_attr_iface_header_digest.attr)
@@ -508,6 +479,38 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 		param = ISCSI_IFACE_PARAM_STRICT_LOGIN_COMP_EN;
 	else if (attr == &dev_attr_iface_initiator_name.attr)
 		param = ISCSI_IFACE_PARAM_INITIATOR_NAME;
+
+	if (param != -1)
+		return t->attr_is_visible(ISCSI_IFACE_PARAM, param);
+
+	if (attr == &dev_attr_iface_vlan_id.attr)
+		param = ISCSI_NET_PARAM_VLAN_ID;
+	else if (attr == &dev_attr_iface_vlan_priority.attr)
+		param = ISCSI_NET_PARAM_VLAN_PRIORITY;
+	else if (attr == &dev_attr_iface_vlan_enabled.attr)
+		param = ISCSI_NET_PARAM_VLAN_ENABLED;
+	else if (attr == &dev_attr_iface_mtu.attr)
+		param = ISCSI_NET_PARAM_MTU;
+	else if (attr == &dev_attr_iface_port.attr)
+		param = ISCSI_NET_PARAM_PORT;
+	else if (attr == &dev_attr_iface_ipaddress_state.attr)
+		param = ISCSI_NET_PARAM_IPADDR_STATE;
+	else if (attr == &dev_attr_iface_delayed_ack_en.attr)
+		param = ISCSI_NET_PARAM_DELAYED_ACK_EN;
+	else if (attr == &dev_attr_iface_tcp_nagle_disable.attr)
+		param = ISCSI_NET_PARAM_TCP_NAGLE_DISABLE;
+	else if (attr == &dev_attr_iface_tcp_wsf_disable.attr)
+		param = ISCSI_NET_PARAM_TCP_WSF_DISABLE;
+	else if (attr == &dev_attr_iface_tcp_wsf.attr)
+		param = ISCSI_NET_PARAM_TCP_WSF;
+	else if (attr == &dev_attr_iface_tcp_timer_scale.attr)
+		param = ISCSI_NET_PARAM_TCP_TIMER_SCALE;
+	else if (attr == &dev_attr_iface_tcp_timestamp_en.attr)
+		param = ISCSI_NET_PARAM_TCP_TIMESTAMP_EN;
+	else if (attr == &dev_attr_iface_cache_id.attr)
+		param = ISCSI_NET_PARAM_CACHE_ID;
+	else if (attr == &dev_attr_iface_redirect_en.attr)
+		param = ISCSI_NET_PARAM_REDIRECT_EN;
 	else if (iface->iface_type == ISCSI_IFACE_TYPE_IPV4) {
 		if (attr == &dev_attr_ipv4_iface_ipaddress.attr)
 			param = ISCSI_NET_PARAM_IPV4_ADDR;
@@ -598,32 +601,7 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 		return 0;
 	}
 
-	switch (param) {
-	case ISCSI_IFACE_PARAM_DEF_TASKMGMT_TMO:
-	case ISCSI_IFACE_PARAM_HDRDGST_EN:
-	case ISCSI_IFACE_PARAM_DATADGST_EN:
-	case ISCSI_IFACE_PARAM_IMM_DATA_EN:
-	case ISCSI_IFACE_PARAM_INITIAL_R2T_EN:
-	case ISCSI_IFACE_PARAM_DATASEQ_INORDER_EN:
-	case ISCSI_IFACE_PARAM_PDU_INORDER_EN:
-	case ISCSI_IFACE_PARAM_ERL:
-	case ISCSI_IFACE_PARAM_MAX_RECV_DLENGTH:
-	case ISCSI_IFACE_PARAM_FIRST_BURST:
-	case ISCSI_IFACE_PARAM_MAX_R2T:
-	case ISCSI_IFACE_PARAM_MAX_BURST:
-	case ISCSI_IFACE_PARAM_CHAP_AUTH_EN:
-	case ISCSI_IFACE_PARAM_BIDI_CHAP_EN:
-	case ISCSI_IFACE_PARAM_DISCOVERY_AUTH_OPTIONAL:
-	case ISCSI_IFACE_PARAM_DISCOVERY_LOGOUT_EN:
-	case ISCSI_IFACE_PARAM_STRICT_LOGIN_COMP_EN:
-	case ISCSI_IFACE_PARAM_INITIATOR_NAME:
-		param_type = ISCSI_IFACE_PARAM;
-		break;
-	default:
-		param_type = ISCSI_NET_PARAM;
-	}
-
-	return t->attr_is_visible(param_type, param);
+	return t->attr_is_visible(ISCSI_NET_PARAM, param);
 }
 
 static struct attribute *iscsi_iface_attrs[] = {
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index b32f4ee88e79..ca1b2312d6e7 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -25,7 +25,7 @@
 #include "target_core_alua.h"
 
 static sense_reason_t
-sbc_check_prot(struct se_device *, struct se_cmd *, unsigned char *, u32, bool);
+sbc_check_prot(struct se_device *, struct se_cmd *, unsigned char, u32, bool);
 static sense_reason_t sbc_execute_unmap(struct se_cmd *cmd);
 
 static sense_reason_t
@@ -279,14 +279,14 @@ static inline unsigned long long transport_lba_64_ext(unsigned char *cdb)
 }
 
 static sense_reason_t
-sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *ops)
+sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags, struct sbc_ops *ops)
 {
 	struct se_device *dev = cmd->se_dev;
 	sector_t end_lba = dev->transport->get_blocks(dev) + 1;
 	unsigned int sectors = sbc_get_write_same_sectors(cmd);
 	sense_reason_t ret;
 
-	if ((flags[0] & 0x04) || (flags[0] & 0x02)) {
+	if ((flags & 0x04) || (flags & 0x02)) {
 		pr_err("WRITE_SAME PBDATA and LBDATA"
 			" bits not supported for Block Discard"
 			" Emulation\n");
@@ -308,7 +308,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	}
 
 	/* We always have ANC_SUP == 0 so setting ANCHOR is always an error */
-	if (flags[0] & 0x10) {
+	if (flags & 0x10) {
 		pr_warn("WRITE SAME with ANCHOR not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
@@ -316,7 +316,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	 * Special case for WRITE_SAME w/ UNMAP=1 that ends up getting
 	 * translated into block discard requests within backend code.
 	 */
-	if (flags[0] & 0x08) {
+	if (flags & 0x08) {
 		if (!ops->execute_unmap)
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 
@@ -331,7 +331,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	if (!ops->execute_write_same)
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 
-	ret = sbc_check_prot(dev, cmd, &cmd->t_task_cdb[0], sectors, true);
+	ret = sbc_check_prot(dev, cmd, flags >> 5, sectors, true);
 	if (ret)
 		return ret;
 
@@ -717,10 +717,9 @@ sbc_set_prot_op_checks(u8 protect, bool fabric_prot, enum target_prot_type prot_
 }
 
 static sense_reason_t
-sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
+sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char protect,
 	       u32 sectors, bool is_write)
 {
-	u8 protect = cdb[1] >> 5;
 	int sp_ops = cmd->se_sess->sup_prot_ops;
 	int pi_prot_type = dev->dev_attrib.pi_prot_type;
 	bool fabric_prot = false;
@@ -768,7 +767,7 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 		fallthrough;
 	default:
 		pr_err("Unable to determine pi_prot_type for CDB: 0x%02x "
-		       "PROTECT: 0x%02x\n", cdb[0], protect);
+		       "PROTECT: 0x%02x\n", cmd->t_task_cdb[0], protect);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -843,7 +842,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, false);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, false);
 		if (ret)
 			return ret;
 
@@ -857,7 +856,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, false);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, false);
 		if (ret)
 			return ret;
 
@@ -871,7 +870,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, false);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, false);
 		if (ret)
 			return ret;
 
@@ -892,7 +891,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, true);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, true);
 		if (ret)
 			return ret;
 
@@ -906,7 +905,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, true);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, true);
 		if (ret)
 			return ret;
 
@@ -921,7 +920,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		ret = sbc_check_prot(dev, cmd, cdb, sectors, true);
+		ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, true);
 		if (ret)
 			return ret;
 
@@ -980,7 +979,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 			size = sbc_get_size(cmd, 1);
 			cmd->t_task_lba = get_unaligned_be64(&cdb[12]);
 
-			ret = sbc_setup_write_same(cmd, &cdb[10], ops);
+			ret = sbc_setup_write_same(cmd, cdb[10], ops);
 			if (ret)
 				return ret;
 			break;
@@ -1079,7 +1078,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		size = sbc_get_size(cmd, 1);
 		cmd->t_task_lba = get_unaligned_be64(&cdb[2]);
 
-		ret = sbc_setup_write_same(cmd, &cdb[1], ops);
+		ret = sbc_setup_write_same(cmd, cdb[1], ops);
 		if (ret)
 			return ret;
 		break;
@@ -1097,7 +1096,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		 * Follow sbcr26 with WRITE_SAME (10) and check for the existence
 		 * of byte 1 bit 3 UNMAP instead of original reserved field
 		 */
-		ret = sbc_setup_write_same(cmd, &cdb[1], ops);
+		ret = sbc_setup_write_same(cmd, cdb[1], ops);
 		if (ret)
 			return ret;
 		break;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7e35eddd9eb7..26ceabe34de5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -886,7 +886,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 	INIT_WORK(&cmd->work, success ? target_complete_ok_work :
 		  target_complete_failure_work);
 
-	if (wwn->cmd_compl_affinity == SE_COMPL_AFFINITY_CPUID)
+	if (!wwn || wwn->cmd_compl_affinity == SE_COMPL_AFFINITY_CPUID)
 		cpu = cmd->cpuid;
 	else
 		cpu = wwn->cmd_compl_affinity;

