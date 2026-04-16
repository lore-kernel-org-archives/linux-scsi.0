Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD9C19C542
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 16:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776357467; cv=none; b=YDTCoA0eWUkSWd4+2ktgC36BLi/kmYejo+Vd2j8am1e3uvO3lCukXj4h+6gFyrOh/ngkioqjyrXNyw+KOBCyHVHyKOBluB3q4fJVqnV7D/2siTKja+atynCw/KdbBEqQ7EPBOOvGNRmsvr6rlf9WPT1m+6rnSZVs5nSOwKblDGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776357467; c=relaxed/simple;
	bh=4dUK042S04f6Ngulx4j2587L1mwoQ9tM4afToCAZ9Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=av9sLYEc5uVlQoChlCSzuLdjqJPGuvPuNl6EyPI+w6vR3FDR32AABUgQ5daczpX/KKQ6AYpFGZnW7o/mN9yNDET/RqEHSaQA3wRrYOqAtFSsS/xw0GeVmuv0arbJQXl+wpjdpA3bVaok+GPE2Ekjwzy5r2D97QS+xiAUf6FSRug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cgOOUZmL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cgOOUZmL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776357465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5YcXzabZ0hjR/dPtJDF2CETcLub0Z7/Bn8+4moy4VwY=;
	b=cgOOUZmLiqtipNV3EDgL14Gk3aSCj94oX9Pymd+yFdWk0egtBC+q7kAGRvLH8gNhtf9mu7
	zZcKvs0cyMRerEPdITTUQ1iWfqGpB+tGNoNkaBmP64+yzMBsbT3MRAY7ZEHM4F8inEbLfj
	xu3Sy2czrX5OiGU7mHSSWCs9VjKRAzA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-599-AZwI81tIOHK4THSQJ1_S6w-1; Thu,
 16 Apr 2026 12:37:41 -0400
X-MC-Unique: AZwI81tIOHK4THSQJ1_S6w-1
X-Mimecast-MFC-AGG-ID: AZwI81tIOHK4THSQJ1_S6w_1776357461
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C6AD01956062;
	Thu, 16 Apr 2026 16:37:40 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.rmtusma.csb (unknown [10.2.16.92])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CCAAF195608E;
	Thu, 16 Apr 2026 16:37:39 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com,
	james.bottomley@hansenpartnership.com,
	loberman@redhat.com
Subject: [PATCH 1/2] scsi: tcm_qla2xxx: Remove FC-specific SCSI command jammer
Date: Fri, 17 Apr 2026 00:37:26 +0800
Message-ID: <20260416163727.1144923-2-loberman@redhat.com>
In-Reply-To: <20260416163727.1144923-1-loberman@redhat.com>
References: <20260416163727.1144923-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

The jam_host tpg_attrib and CONFIG_TCM_QLA2XXX_DEBUG Kconfig option
introduced in commit 54a5e73f4d6e ("tcm_qla2xxx Add SCSI command
jammer/discard capability") are superseded by the transport-agnostic
initiator-side scsi_jammer module introduced in patch 2/2.

The original implementation had several limitations that motivated this
replacement:

  - Required LIO configured in target mode with a QLogic qla2xxx HBA,
    making it unavailable for iSCSI, FCoE, SAS, and any other transport.
  - Operated on the target side, meaning a separate target host was
    needed to test initiator error recovery.
  - tcm_qla2xxx target mode has effectively been retired and is no
    longer a viable dependency for a general-purpose test tool.
  - Only supported command discard (drop); no stall or flap modes.

The replacement in patch 2/2 operates on the initiator side at the
queuecommand level of the SCSI mid-layer, requires no target-side
configuration, and works identically across all transports that present
a Scsi_Host.

Note: Documentation/scsi/tcm_qla2xxx.txt was already removed from the
tree prior to this patch and does not require deletion here.

Remove CONFIG_TCM_QLA2XXX_DEBUG from Kconfig, the jam_host field from
struct tcm_qla2xxx_tpg_attrib, and all associated #ifdef blocks from
tcm_qla2xxx.c.

Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/qla2xxx/Kconfig       |  9 ---------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 23 -----------------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |  1 -
 3 files changed, 33 deletions(-)

diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
index 6946d7155bc2..e26b14463c4d 100644
--- a/drivers/scsi/qla2xxx/Kconfig
+++ b/drivers/scsi/qla2xxx/Kconfig
@@ -37,12 +37,3 @@ config TCM_QLA2XXX
 	  Say Y here to enable the TCM_QLA2XXX fabric module for QLogic 24xx+
 	  series target mode HBAs.
 
-if TCM_QLA2XXX
-config TCM_QLA2XXX_DEBUG
-	bool "TCM_QLA2XXX fabric module DEBUG mode for QLogic 24xx+ series target mode HBAs"
-	default n
-	help
-	  Say Y here to enable the TCM_QLA2XXX fabric module DEBUG for
-	  QLogic 24xx+ series target mode HBAs.
-	  This will include code to enable the SCSI command jammer.
-endif
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 28df9025def0..1c6d658d9c7c 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -450,13 +450,6 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct se_session *se_sess;
 	struct fc_port *sess;
-#ifdef CONFIG_TCM_QLA2XXX_DEBUG
-	struct se_portal_group *se_tpg;
-	struct tcm_qla2xxx_tpg *tpg;
-#endif
-	int rc, target_flags = TARGET_SCF_ACK_KREF;
-	unsigned long flags;
-
 	if (bidi)
 		target_flags |= TARGET_SCF_BIDI_OP;
 
@@ -475,15 +468,6 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 		return -EINVAL;
 	}
 
-#ifdef CONFIG_TCM_QLA2XXX_DEBUG
-	se_tpg = se_sess->se_tpg;
-	tpg = container_of(se_tpg, struct tcm_qla2xxx_tpg, se_tpg);
-	if (unlikely(tpg->tpg_attrib.jam_host)) {
-		/* return, and dont run target_submit_cmd,discarding command */
-		return 0;
-	}
-#endif
-	cmd->qpair->tgt_counters.qla_core_sbt_cmd++;
 
 	spin_lock_irqsave(&sess->sess_cmd_lock, flags);
 	list_add_tail(&cmd->sess_cmd_list, &sess->sess_cmd_list);
@@ -903,9 +887,6 @@ DEF_QLA_TPG_ATTRIB(cache_dynamic_acls);
 DEF_QLA_TPG_ATTRIB(demo_mode_write_protect);
 DEF_QLA_TPG_ATTRIB(prod_mode_write_protect);
 DEF_QLA_TPG_ATTRIB(demo_mode_login_only);
-#ifdef CONFIG_TCM_QLA2XXX_DEBUG
-DEF_QLA_TPG_ATTRIB(jam_host);
-#endif
 
 static struct configfs_attribute *tcm_qla2xxx_tpg_attrib_attrs[] = {
 	&tcm_qla2xxx_tpg_attrib_attr_generate_node_acls,
@@ -913,9 +894,6 @@ static struct configfs_attribute *tcm_qla2xxx_tpg_attrib_attrs[] = {
 	&tcm_qla2xxx_tpg_attrib_attr_demo_mode_write_protect,
 	&tcm_qla2xxx_tpg_attrib_attr_prod_mode_write_protect,
 	&tcm_qla2xxx_tpg_attrib_attr_demo_mode_login_only,
-#ifdef CONFIG_TCM_QLA2XXX_DEBUG
-	&tcm_qla2xxx_tpg_attrib_attr_jam_host,
-#endif
 	NULL,
 };
 
@@ -1030,7 +1008,6 @@ static struct se_portal_group *tcm_qla2xxx_make_tpg(struct se_wwn *wwn,
 	tpg->tpg_attrib.demo_mode_write_protect = 1;
 	tpg->tpg_attrib.cache_dynamic_acls = 1;
 	tpg->tpg_attrib.demo_mode_login_only = 1;
-	tpg->tpg_attrib.jam_host = 0;
 
 	ret = core_tpg_register(wwn, &tpg->se_tpg, SCSI_PROTOCOL_FCP);
 	if (ret < 0) {
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index 147cf6c90366..0f1650f83124 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -34,7 +34,6 @@ struct tcm_qla2xxx_tpg_attrib {
 	int prod_mode_write_protect;
 	int demo_mode_login_only;
 	int fabric_prot_type;
-	int jam_host;
 };
 
 struct tcm_qla2xxx_tpg {
-- 
2.53.0

