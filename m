Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.69.126.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794027523;
	b=LONt0iwonaiz5VuIlpJRLUA8SeZHmZx3eZZTRZ9zdQCYyEFJ9FxOx53em5sFvoV/AsMW
	 C/qzg4jTwknAww23yX9JgbMi1Lf+vzUjXphhtvbv31X84r7Jp/UI0OdHEFw3WDsJYMw63
	 pi8EgR1/yp8YDe00C2mIbkKV7xB32oar+62zJ4F4BLz0cgllVUBrjZYV3+9OO080MJfm9
	 +W/U8n5fRu0gfCDIlEHnz5lEnDtlkZCers7db7aroVq6OZvDmzqryFNJXknqF5r8baX3F
	 ZAwigl6mffpM0LZ5ORMQZa2Qg5naf3xWCdtqEZwpotDEr2+4aqbUvQ1EXvssWLvSGgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794027523;
	h=DMARC-Filter:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=1bTtNFV/Bu4+73VR+qsp/TjUmYM1wg48VgWH87SF0IQ=;
	b=WMATonoZR2TZf3M8Os0Cq0WmmitkjTF45JkV6+hn5mrfYCfrxdqZ3LEaQiTpujf64RcN
	 10gSP83D6nU5BMnbDrv1EtqM2+0MjF0fYiEcthKe+JRNwydcl8gquxxSH2Kf/yx7qXxVp
	 tHUwhX2jz9PyLZ0IlbGEaNm0t8EuVL1hWQghk/cxkRWzFW0PV8xVg5vzj5PtCIDhk7X9P
	 1Z1/PXYmZJBr1OE3AyupGfq5dZFSIFlonUlLCDwvtBw9QhLR7cSgJCTbUlyZHM8HEkW3T
	 KMtTfMoiGTpXykZq8/hxv6swIfZ59RuHt5ye3qLv1Bz4XEu1lK8kp95OXoZwhR9XsnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=weissschuh.net;
	spf=pass smtp.mailfrom=weissschuh.net;
	dkim=pass header.d=weissschuh.net header.i=@weissschuh.net header.a=rsa-sha256 header.s=mail header.b=RzRY5X79;
	arc=none smtp.remote-ip=159.69.126.157
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445BC606A332;
	Sat,  7 Nov 2026 04:58:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 445BC606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.a=rsa-sha256 header.s=mail header.b=RzRY5X79
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1794027520;
	bh=zzPq0yx98v9qgci1ljkgjVHCyityc7I6CwSkGlufbI8=;
	h=From:Date:Subject:To:Cc:From;
	b=RzRY5X799bC8zD79IorLpikFmarwEWLNwkqlP/zotyBsvwRLwFf/pbx8yYEQZxtZy
	 1RwHGwxUsFC3sqksIRsOfePpd3d5hgVQVBeYs3s2KoKD6Rd2+CbcnPY5JGXK/XDgor
	 SLOiQ1WxFrjGacSX4/wM+4KIkIcWSuupSPKiJ4JY=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Sat, 07 Nov 2026 04:58:28 +0000
Subject: [PATCH] scsi: target: Constify struct configfs_attribute pointers
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261107-configfs-const-target-v1-1-a1bf9511386c@weissschuh.net>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/y2NwQ6CMBBEf4XsmSYtEov+CvGAZVvXQ9HdxZgQ/
 t2C3OYlM28WEGRCgWu1AOOHhKZcwNUVhMeQExoaC0Njm7Nz1psw5UgpyhZEjQ6cUI1tve9OXes
 uNkLZvhgjfXdvf/uzzPcnBt1kR4PxPZdDPWrr+gMhXVcKjgAAAA==
X-Change-ID: 20261107-configfs-const-target-04778384190f
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794027515; l=32698;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=zzPq0yx98v9qgci1ljkgjVHCyityc7I6CwSkGlufbI8=;
 b=UQKggzBScDYw23lgHVTuJ0XAbuTq/I2p9ZlsxTiHvRcT3dqTgdIEFVBuL/j3P618bOLv/9lFM
 i6uPmhSkSupD1m5WaMhnsUVZVWBO8cvn1vuz0Z2pquTO0ZDOLbn3X3b
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

In preparation for the constification of configfs attributes, make the
pointers to struct configfs_attribute in the target subsystem and its
drivers const and use the new ct_attrs_const field of struct
config_item_type.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
This is only sent to the target subsystem maintainers and not the driver
maintainers to avoid spamming the maintainers.
---
 drivers/infiniband/ulp/srpt/ib_srpt.c        |  6 ++---
 drivers/scsi/elx/efct/efct_lio.c             |  8 +++----
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     |  2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |  6 ++---
 drivers/target/iscsi/iscsi_target_configfs.c | 22 ++++++++---------
 drivers/target/loopback/tcm_loop.c           |  6 ++---
 drivers/target/sbp/sbp_target.c              |  6 ++---
 drivers/target/target_core_configfs.c        | 36 ++++++++++++++--------------
 drivers/target/target_core_fabric_configfs.c | 16 ++++++-------
 drivers/target/target_core_user.c            |  6 ++---
 drivers/target/tcm_fc/tfc_conf.c             |  4 ++--
 drivers/target/tcm_remote/tcm_remote.c       |  2 +-
 drivers/usb/gadget/function/f_tcm.c          |  4 ++--
 drivers/vhost/scsi.c                         |  6 ++---
 drivers/xen/xen-scsiback.c                   |  6 ++---
 include/target/target_core_backend.h         | 10 ++++----
 include/target/target_core_fabric.h          | 22 ++++++++---------
 17 files changed, 84 insertions(+), 84 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 43c3ff1ad8e7..1ffa76381df5 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3676,7 +3676,7 @@ CONFIGFS_ATTR(srpt_tpg_attrib_,  srp_max_rsp_size);
 CONFIGFS_ATTR(srpt_tpg_attrib_,  srp_sq_size);
 CONFIGFS_ATTR(srpt_tpg_attrib_,  use_srq);
 
-static struct configfs_attribute *srpt_tpg_attrib_attrs[] = {
+static const struct configfs_attribute *const srpt_tpg_attrib_attrs[] = {
 	&srpt_tpg_attrib_attr_srp_max_rdma_size,
 	&srpt_tpg_attrib_attr_srp_max_rsp_size,
 	&srpt_tpg_attrib_attr_srp_sq_size,
@@ -3767,7 +3767,7 @@ static ssize_t srpt_rdma_cm_port_store(struct config_item *item,
 
 CONFIGFS_ATTR(srpt_, rdma_cm_port);
 
-static struct configfs_attribute *srpt_da_attrs[] = {
+static const struct configfs_attribute *const srpt_da_attrs[] = {
 	&srpt_attr_rdma_cm_port,
 	NULL,
 };
@@ -3895,7 +3895,7 @@ static ssize_t srpt_wwn_version_show(struct config_item *item, char *buf)
 
 CONFIGFS_ATTR_RO(srpt_wwn_, version);
 
-static struct configfs_attribute *srpt_wwn_attrs[] = {
+static const struct configfs_attribute *const srpt_wwn_attrs[] = {
 	&srpt_wwn_attr_version,
 	NULL,
 };
diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
index 67d686dd6fb3..226501eb46de 100644
--- a/drivers/scsi/elx/efct/efct_lio.c
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -1509,7 +1509,7 @@ DEF_EFCT_TPG_ATTRIB(prod_mode_write_protect);
 DEF_EFCT_TPG_ATTRIB(demo_mode_login_only);
 DEF_EFCT_TPG_ATTRIB(session_deletion_wait);
 
-static struct configfs_attribute *efct_lio_tpg_attrib_attrs[] = {
+static const struct configfs_attribute *const efct_lio_tpg_attrib_attrs[] = {
 	&efct_lio_tpg_attrib_attr_generate_node_acls,
 	&efct_lio_tpg_attrib_attr_cache_dynamic_acls,
 	&efct_lio_tpg_attrib_attr_demo_mode_write_protect,
@@ -1565,7 +1565,7 @@ DEF_EFCT_NPIV_TPG_ATTRIB(prod_mode_write_protect);
 DEF_EFCT_NPIV_TPG_ATTRIB(demo_mode_login_only);
 DEF_EFCT_NPIV_TPG_ATTRIB(session_deletion_wait);
 
-static struct configfs_attribute *efct_lio_npiv_tpg_attrib_attrs[] = {
+static const struct configfs_attribute *const efct_lio_npiv_tpg_attrib_attrs[] = {
 	&efct_lio_npiv_tpg_attrib_attr_generate_node_acls,
 	&efct_lio_npiv_tpg_attrib_attr_cache_dynamic_acls,
 	&efct_lio_npiv_tpg_attrib_attr_demo_mode_write_protect,
@@ -1576,10 +1576,10 @@ static struct configfs_attribute *efct_lio_npiv_tpg_attrib_attrs[] = {
 };
 
 CONFIGFS_ATTR(efct_lio_tpg_, enable);
-static struct configfs_attribute *efct_lio_tpg_attrs[] = {
+static const struct configfs_attribute *const efct_lio_tpg_attrs[] = {
 				&efct_lio_tpg_attr_enable, NULL };
 CONFIGFS_ATTR(efct_lio_npiv_tpg_, enable);
-static struct configfs_attribute *efct_lio_npiv_tpg_attrs[] = {
+static const struct configfs_attribute *const efct_lio_npiv_tpg_attrs[] = {
 				&efct_lio_npiv_tpg_attr_enable, NULL };
 
 static const struct target_core_fabric_ops efct_lio_ops = {
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 92b26f7fec50..75e3c2adea0c 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3939,7 +3939,7 @@ static ssize_t ibmvscsis_wwn_version_show(struct config_item *item,
 }
 CONFIGFS_ATTR_RO(ibmvscsis_wwn_, version);
 
-static struct configfs_attribute *ibmvscsis_wwn_attrs[] = {
+static const struct configfs_attribute *const ibmvscsis_wwn_attrs[] = {
 	&ibmvscsis_wwn_attr_version,
 	NULL,
 };
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 3be23ed067e6..43802b3b081f 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -907,7 +907,7 @@ DEF_QLA_TPG_ATTRIB(demo_mode_login_only);
 DEF_QLA_TPG_ATTRIB(jam_host);
 #endif
 
-static struct configfs_attribute *tcm_qla2xxx_tpg_attrib_attrs[] = {
+static const struct configfs_attribute *const tcm_qla2xxx_tpg_attrib_attrs[] = {
 	&tcm_qla2xxx_tpg_attrib_attr_generate_node_acls,
 	&tcm_qla2xxx_tpg_attrib_attr_cache_dynamic_acls,
 	&tcm_qla2xxx_tpg_attrib_attr_demo_mode_write_protect,
@@ -990,7 +990,7 @@ static ssize_t tcm_qla2xxx_tpg_fabric_prot_type_show(struct config_item *item,
 CONFIGFS_ATTR_RO(tcm_qla2xxx_tpg_, dynamic_sessions);
 CONFIGFS_ATTR(tcm_qla2xxx_tpg_, fabric_prot_type);
 
-static struct configfs_attribute *tcm_qla2xxx_tpg_attrs[] = {
+static const struct configfs_attribute *const tcm_qla2xxx_tpg_attrs[] = {
 	&tcm_qla2xxx_tpg_attr_dynamic_sessions,
 	&tcm_qla2xxx_tpg_attr_fabric_prot_type,
 	NULL,
@@ -1791,7 +1791,7 @@ static ssize_t tcm_qla2xxx_wwn_version_show(struct config_item *item,
 
 CONFIGFS_ATTR_RO(tcm_qla2xxx_wwn_, version);
 
-static struct configfs_attribute *tcm_qla2xxx_wwn_attrs[] = {
+static const struct configfs_attribute *const tcm_qla2xxx_wwn_attrs[] = {
 	&tcm_qla2xxx_wwn_attr_version,
 	NULL,
 };
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index e1aa0af52c65..d826416f0f8a 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -139,7 +139,7 @@ static ssize_t lio_target_np_cxgbit_store(struct config_item *item,
 }
 CONFIGFS_ATTR(lio_target_np_, cxgbit);
 
-static struct configfs_attribute *lio_target_portal_attrs[] = {
+static const struct configfs_attribute *const lio_target_portal_attrs[] = {
 	&lio_target_np_attr_iser,
 	&lio_target_np_attr_cxgbit,
 	NULL,
@@ -344,7 +344,7 @@ static ssize_t iscsi_nacl_attrib_authentication_store(struct config_item *item,
 
 CONFIGFS_ATTR(iscsi_nacl_attrib_, authentication);
 
-static struct configfs_attribute *lio_target_nacl_attrib_attrs[] = {
+static const struct configfs_attribute *const lio_target_nacl_attrib_attrs[] = {
 	&iscsi_nacl_attrib_attr_dataout_timeout,
 	&iscsi_nacl_attrib_attr_dataout_timeout_retries,
 	&iscsi_nacl_attrib_attr_default_erl,
@@ -451,7 +451,7 @@ CONFIGFS_ATTR_RO(iscsi_nacl_auth_, name)
 
 DEF_NACL_AUTH_INT(authenticate_target);
 
-static struct configfs_attribute *lio_target_nacl_auth_attrs[] = {
+static const struct configfs_attribute *const lio_target_nacl_auth_attrs[] = {
 	&iscsi_nacl_auth_attr_userid,
 	&iscsi_nacl_auth_attr_password,
 	&iscsi_nacl_auth_attr_authenticate_target,
@@ -502,7 +502,7 @@ ISCSI_NACL_PARAM(DataPDUInOrder);
 ISCSI_NACL_PARAM(DataSequenceInOrder);
 ISCSI_NACL_PARAM(ErrorRecoveryLevel);
 
-static struct configfs_attribute *lio_target_nacl_param_attrs[] = {
+static const struct configfs_attribute *const lio_target_nacl_param_attrs[] = {
 	&iscsi_nacl_param_attr_MaxConnections,
 	&iscsi_nacl_param_attr_InitialR2T,
 	&iscsi_nacl_param_attr_ImmediateData,
@@ -715,7 +715,7 @@ CONFIGFS_ATTR_RO(lio_target_nacl_, info);
 CONFIGFS_ATTR(lio_target_nacl_, cmdsn_depth);
 CONFIGFS_ATTR(lio_target_nacl_, tag);
 
-static struct configfs_attribute *lio_target_initiator_attrs[] = {
+static const struct configfs_attribute *const lio_target_initiator_attrs[] = {
 	&lio_target_nacl_attr_info,
 	&lio_target_nacl_attr_cmdsn_depth,
 	&lio_target_nacl_attr_tag,
@@ -795,7 +795,7 @@ DEF_TPG_ATTRIB(fabric_prot_type);
 DEF_TPG_ATTRIB(tpg_enabled_sendtargets);
 DEF_TPG_ATTRIB(login_keys_workaround);
 
-static struct configfs_attribute *lio_target_tpg_attrib_attrs[] = {
+static const struct configfs_attribute *const lio_target_tpg_attrib_attrs[] = {
 	&iscsi_tpg_attrib_attr_authentication,
 	&iscsi_tpg_attrib_attr_login_timeout,
 	&iscsi_tpg_attrib_attr_generate_node_acls,
@@ -899,7 +899,7 @@ CONFIGFS_ATTR_RO(iscsi_tpg_auth_, name);
 
 DEF_TPG_AUTH_INT(authenticate_target);
 
-static struct configfs_attribute *lio_target_tpg_auth_attrs[] = {
+static const struct configfs_attribute *const lio_target_tpg_auth_attrs[] = {
 	&iscsi_tpg_auth_attr_userid,
 	&iscsi_tpg_auth_attr_password,
 	&iscsi_tpg_auth_attr_authenticate_target,
@@ -991,7 +991,7 @@ DEF_TPG_PARAM(OFMarker);
 DEF_TPG_PARAM(IFMarkInt);
 DEF_TPG_PARAM(OFMarkInt);
 
-static struct configfs_attribute *lio_target_tpg_param_attrs[] = {
+static const struct configfs_attribute *const lio_target_tpg_param_attrs[] = {
 	&iscsi_tpg_param_attr_AuthMethod,
 	&iscsi_tpg_param_attr_HeaderDigest,
 	&iscsi_tpg_param_attr_DataDigest,
@@ -1028,7 +1028,7 @@ static ssize_t lio_target_tpg_dynamic_sessions_show(struct config_item *item,
 
 CONFIGFS_ATTR_RO(lio_target_tpg_, dynamic_sessions);
 
-static struct configfs_attribute *lio_target_tpg_attrs[] = {
+static const struct configfs_attribute *const lio_target_tpg_attrs[] = {
 	&lio_target_tpg_attr_dynamic_sessions,
 	NULL,
 };
@@ -1176,7 +1176,7 @@ static ssize_t lio_target_wwn_cpus_allowed_list_store(
 
 CONFIGFS_ATTR(lio_target_wwn_, cpus_allowed_list);
 
-static struct configfs_attribute *lio_target_wwn_attrs[] = {
+static const struct configfs_attribute *const lio_target_wwn_attrs[] = {
 	&lio_target_wwn_attr_lio_version,
 	&lio_target_wwn_attr_cpus_allowed_list,
 	NULL,
@@ -1354,7 +1354,7 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
 
 CONFIGFS_ATTR(iscsi_disc_, enforce_discovery_auth);
 
-static struct configfs_attribute *lio_target_discovery_auth_attrs[] = {
+static const struct configfs_attribute *const lio_target_discovery_auth_attrs[] = {
 	&iscsi_disc_attr_userid,
 	&iscsi_disc_attr_password,
 	&iscsi_disc_attr_authenticate_target,
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index d29830b951f7..ceec0f19ec1b 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -647,7 +647,7 @@ static ssize_t tcm_loop_tpg_attrib_fabric_prot_type_store(
 
 CONFIGFS_ATTR(tcm_loop_tpg_attrib_, fabric_prot_type);
 
-static struct configfs_attribute *tcm_loop_tpg_attrib_attrs[] = {
+static const struct configfs_attribute *const tcm_loop_tpg_attrib_attrs[] = {
 	&tcm_loop_tpg_attrib_attr_fabric_prot_type,
 	NULL,
 };
@@ -890,7 +890,7 @@ CONFIGFS_ATTR(tcm_loop_tpg_, nexus);
 CONFIGFS_ATTR(tcm_loop_tpg_, transport_status);
 CONFIGFS_ATTR_RO(tcm_loop_tpg_, address);
 
-static struct configfs_attribute *tcm_loop_tpg_attrs[] = {
+static const struct configfs_attribute *const tcm_loop_tpg_attrs[] = {
 	&tcm_loop_tpg_attr_nexus,
 	&tcm_loop_tpg_attr_transport_status,
 	&tcm_loop_tpg_attr_address,
@@ -1059,7 +1059,7 @@ static ssize_t tcm_loop_wwn_version_show(struct config_item *item, char *page)
 
 CONFIGFS_ATTR_RO(tcm_loop_wwn_, version);
 
-static struct configfs_attribute *tcm_loop_wwn_attrs[] = {
+static const struct configfs_attribute *const tcm_loop_wwn_attrs[] = {
 	&tcm_loop_wwn_attr_version,
 	NULL,
 };
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 896fc0f0379f..bf7e6604242a 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -2055,7 +2055,7 @@ static ssize_t sbp_wwn_version_show(struct config_item *item, char *page)
 
 CONFIGFS_ATTR_RO(sbp_wwn_, version);
 
-static struct configfs_attribute *sbp_wwn_attrs[] = {
+static const struct configfs_attribute *const sbp_wwn_attrs[] = {
 	&sbp_wwn_attr_version,
 	NULL,
 };
@@ -2133,7 +2133,7 @@ static int sbp_enable_tpg(struct se_portal_group *se_tpg, bool enable)
 
 CONFIGFS_ATTR(sbp_tpg_, directory_id);
 
-static struct configfs_attribute *sbp_tpg_base_attrs[] = {
+static const struct configfs_attribute *const sbp_tpg_base_attrs[] = {
 	&sbp_tpg_attr_directory_id,
 	NULL,
 };
@@ -2241,7 +2241,7 @@ CONFIGFS_ATTR(sbp_tpg_attrib_, mgt_orb_timeout);
 CONFIGFS_ATTR(sbp_tpg_attrib_, max_reconnect_timeout);
 CONFIGFS_ATTR(sbp_tpg_attrib_, max_logins_per_lun);
 
-static struct configfs_attribute *sbp_tpg_attrib_attrs[] = {
+static const struct configfs_attribute *const sbp_tpg_attrib_attrs[] = {
 	&sbp_tpg_attrib_attr_mgt_orb_timeout,
 	&sbp_tpg_attrib_attr_max_reconnect_timeout,
 	&sbp_tpg_attrib_attr_max_logins_per_lun,
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 2b19a956007b..2958709a63e1 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -47,7 +47,7 @@ static void target_core_setup_##_name##_cit(struct target_backend *tb)	\
 									\
 	cit->ct_item_ops = _item_ops;					\
 	cit->ct_group_ops = _group_ops;					\
-	cit->ct_attrs = _attrs;						\
+	cit->ct_attrs_const = _attrs;					\
 	cit->ct_owner = tb->ops->owner;					\
 	pr_debug("Setup generic %s\n", __stringify(_name));		\
 }
@@ -59,7 +59,7 @@ static void target_core_setup_##_name##_cit(struct target_backend *tb)	\
 									\
 	cit->ct_item_ops = _item_ops;					\
 	cit->ct_group_ops = _group_ops;					\
-	cit->ct_attrs = tb->ops->tb_##_name##_attrs;			\
+	cit->ct_attrs_const = tb->ops->tb_##_name##_attrs;		\
 	cit->ct_owner = tb->ops->owner;					\
 	pr_debug("Setup generic %s\n", __stringify(_name));		\
 }
@@ -293,7 +293,7 @@ static const struct configfs_group_operations target_core_fabric_group_ops = {
 /*
  * All item attributes appearing in /sys/kernel/target/ appear here.
  */
-static struct configfs_attribute *target_core_fabric_item_attrs[] = {
+static const struct configfs_attribute *const target_core_fabric_item_attrs[] = {
 	&target_core_item_attr_version,
 	&target_core_item_attr_dbroot,
 	NULL,
@@ -304,7 +304,7 @@ static struct configfs_attribute *target_core_fabric_item_attrs[] = {
  */
 static const struct config_item_type target_core_fabrics_item = {
 	.ct_group_ops	= &target_core_fabric_group_ops,
-	.ct_attrs	= target_core_fabric_item_attrs,
+	.ct_attrs_const	= target_core_fabric_item_attrs,
 	.ct_owner	= THIS_MODULE,
 };
 
@@ -1333,7 +1333,7 @@ CONFIGFS_ATTR_RO(, atomic_max_boundary);
  * interpreter.  Any backend using spc_parse_cdb should be using
  * these.
  */
-struct configfs_attribute *sbc_attrib_attrs[] = {
+const struct configfs_attribute *const sbc_attrib_attrs[] = {
 	&attr_emulate_model_alias,
 	&attr_emulate_dpo,
 	&attr_emulate_fua_write,
@@ -1385,7 +1385,7 @@ EXPORT_SYMBOL(sbc_attrib_attrs);
  * In this case we only provide a few read-only attributes for
  * backwards compatibility.
  */
-struct configfs_attribute *passthrough_attrib_attrs[] = {
+const struct configfs_attribute *const passthrough_attrib_attrs[] = {
 	&attr_hw_pi_prot_type,
 	&attr_hw_block_size,
 	&attr_hw_max_sectors,
@@ -1403,7 +1403,7 @@ EXPORT_SYMBOL(passthrough_attrib_attrs);
  * pr related dev_attrib attributes for devices passing through CDBs,
  * but allowing in core pr emulation.
  */
-struct configfs_attribute *passthrough_pr_attrib_attrs[] = {
+const struct configfs_attribute *const passthrough_pr_attrib_attrs[] = {
 	&attr_enforce_pr_isids,
 	&attr_force_pr_aptpl,
 	NULL,
@@ -1866,7 +1866,7 @@ CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_target_port);
 CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_scsi_target_device);
 CONFIGFS_ATTR(target_wwn_, pd_text_id_info);
 
-static struct configfs_attribute *target_core_dev_wwn_attrs[] = {
+static const struct configfs_attribute *const target_core_dev_wwn_attrs[] = {
 	&target_wwn_attr_vendor_id,
 	&target_wwn_attr_product_id,
 	&target_wwn_attr_revision,
@@ -2334,7 +2334,7 @@ CONFIGFS_ATTR_RO(target_pr_, res_type);
 CONFIGFS_ATTR_RO(target_pr_, res_aptpl_active);
 CONFIGFS_ATTR(target_pr_, res_aptpl_metadata);
 
-static struct configfs_attribute *target_core_dev_pr_attrs[] = {
+static const struct configfs_attribute *const target_core_dev_pr_attrs[] = {
 	&target_pr_attr_res_holder,
 	&target_pr_attr_res_pr_all_tgt_pts,
 	&target_pr_attr_res_pr_generation,
@@ -2758,7 +2758,7 @@ CONFIGFS_ATTR(target_dev_, enable);
 CONFIGFS_ATTR(target_dev_, alua_lu_gp);
 CONFIGFS_ATTR(target_dev_, lba_map);
 
-static struct configfs_attribute *target_core_dev_attrs[] = {
+static const struct configfs_attribute *const target_core_dev_attrs[] = {
 	&target_dev_attr_info,
 	&target_dev_attr_control,
 	&target_dev_attr_alias,
@@ -2865,7 +2865,7 @@ static ssize_t target_lu_gp_members_show(struct config_item *item, char *page)
 CONFIGFS_ATTR(target_lu_gp_, lu_gp_id);
 CONFIGFS_ATTR_RO(target_lu_gp_, members);
 
-static struct configfs_attribute *target_core_alua_lu_gp_attrs[] = {
+static const struct configfs_attribute *const target_core_alua_lu_gp_attrs[] = {
 	&target_lu_gp_attr_lu_gp_id,
 	&target_lu_gp_attr_members,
 	NULL,
@@ -2885,7 +2885,7 @@ static const struct configfs_item_operations target_core_alua_lu_gp_ops = {
 
 static const struct config_item_type target_core_alua_lu_gp_cit = {
 	.ct_item_ops		= &target_core_alua_lu_gp_ops,
-	.ct_attrs		= target_core_alua_lu_gp_attrs,
+	.ct_attrs_const		= target_core_alua_lu_gp_attrs,
 	.ct_owner		= THIS_MODULE,
 };
 
@@ -3280,7 +3280,7 @@ CONFIGFS_ATTR(target_tg_pt_gp_, preferred);
 CONFIGFS_ATTR(target_tg_pt_gp_, tg_pt_gp_id);
 CONFIGFS_ATTR_RO(target_tg_pt_gp_, members);
 
-static struct configfs_attribute *target_core_alua_tg_pt_gp_attrs[] = {
+static const struct configfs_attribute *const target_core_alua_tg_pt_gp_attrs[] = {
 	&target_tg_pt_gp_attr_alua_access_state,
 	&target_tg_pt_gp_attr_alua_access_status,
 	&target_tg_pt_gp_attr_alua_access_type,
@@ -3315,7 +3315,7 @@ static const struct configfs_item_operations target_core_alua_tg_pt_gp_ops = {
 
 static const struct config_item_type target_core_alua_tg_pt_gp_cit = {
 	.ct_item_ops		= &target_core_alua_tg_pt_gp_ops,
-	.ct_attrs		= target_core_alua_tg_pt_gp_attrs,
+	.ct_attrs_const		= target_core_alua_tg_pt_gp_attrs,
 	.ct_owner		= THIS_MODULE,
 };
 
@@ -3386,7 +3386,7 @@ TB_CIT_SETUP(dev_alua_tg_pt_gps, NULL, &target_core_alua_tg_pt_gps_group_ops, NU
  */
 static const struct config_item_type target_core_alua_cit = {
 	.ct_item_ops		= NULL,
-	.ct_attrs		= NULL,
+	.ct_attrs_const		= NULL,
 	.ct_owner		= THIS_MODULE,
 };
 
@@ -3608,7 +3608,7 @@ static void target_core_hba_release(struct config_item *item)
 	core_delete_hba(hba);
 }
 
-static struct configfs_attribute *target_core_hba_attrs[] = {
+static const struct configfs_attribute *const target_core_hba_attrs[] = {
 	&target_attr_hba_info,
 	&target_attr_hba_mode,
 	NULL,
@@ -3621,7 +3621,7 @@ static const struct configfs_item_operations target_core_hba_item_ops = {
 static const struct config_item_type target_core_hba_cit = {
 	.ct_item_ops		= &target_core_hba_item_ops,
 	.ct_group_ops		= &target_core_hba_group_ops,
-	.ct_attrs		= target_core_hba_attrs,
+	.ct_attrs_const		= target_core_hba_attrs,
 	.ct_owner		= THIS_MODULE,
 };
 
@@ -3703,7 +3703,7 @@ static const struct configfs_group_operations target_core_group_ops = {
 static const struct config_item_type target_core_cit = {
 	.ct_item_ops	= NULL,
 	.ct_group_ops	= &target_core_group_ops,
-	.ct_attrs	= NULL,
+	.ct_attrs_const	= NULL,
 	.ct_owner	= THIS_MODULE,
 };
 
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index ab8f81650710..61929f28fcc5 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -41,7 +41,7 @@ static void target_fabric_setup_##_name##_cit(struct target_fabric_configfs *tf)
 									\
 	cit->ct_item_ops = _item_ops;					\
 	cit->ct_group_ops = _group_ops;					\
-	cit->ct_attrs = _attrs;						\
+	cit->ct_attrs_const = _attrs;					\
 	cit->ct_owner = tf->tf_ops->module;				\
 	pr_debug("Setup generic %s\n", __stringify(_name));		\
 }
@@ -50,11 +50,11 @@ static void target_fabric_setup_##_name##_cit(struct target_fabric_configfs *tf)
 static void target_fabric_setup_##_name##_cit(struct target_fabric_configfs *tf) \
 {									\
 	struct config_item_type *cit = &tf->tf_##_name##_cit;		\
-	struct configfs_attribute **attrs = tf->tf_ops->tfc_##_name##_attrs; \
+	const struct configfs_attribute *const *attrs = tf->tf_ops->tfc_##_name##_attrs; \
 									\
 	cit->ct_item_ops = _item_ops;					\
 	cit->ct_group_ops = _group_ops;					\
-	cit->ct_attrs = attrs;						\
+	cit->ct_attrs_const = attrs;					\
 	cit->ct_owner = tf->tf_ops->module;				\
 	pr_debug("Setup generic %s\n", __stringify(_name));		\
 }
@@ -205,7 +205,7 @@ static ssize_t target_fabric_mappedlun_write_protect_store(
 
 CONFIGFS_ATTR(target_fabric_mappedlun_, write_protect);
 
-static struct configfs_attribute *target_fabric_mappedlun_attrs[] = {
+static const struct configfs_attribute *const target_fabric_mappedlun_attrs[] = {
 	&target_fabric_mappedlun_attr_write_protect,
 	NULL,
 };
@@ -609,7 +609,7 @@ CONFIGFS_ATTR(target_fabric_port_, alua_tg_pt_offline);
 CONFIGFS_ATTR(target_fabric_port_, alua_tg_pt_status);
 CONFIGFS_ATTR(target_fabric_port_, alua_tg_pt_write_md);
 
-static struct configfs_attribute *target_fabric_port_attrs[] = {
+static const struct configfs_attribute *const target_fabric_port_attrs[] = {
 	&target_fabric_port_attr_alua_tg_pt_gp,
 	&target_fabric_port_attr_alua_tg_pt_offline,
 	&target_fabric_port_attr_alua_tg_pt_status,
@@ -892,7 +892,7 @@ static int
 target_fabric_setup_tpg_base_cit(struct target_fabric_configfs *tf)
 {
 	struct config_item_type *cit = &tf->tf_tpg_base_cit;
-	struct configfs_attribute **attrs = NULL;
+	const struct configfs_attribute **attrs = NULL;
 	size_t nr_attrs = 0;
 	int i = 0;
 
@@ -921,7 +921,7 @@ target_fabric_setup_tpg_base_cit(struct target_fabric_configfs *tf)
 	attrs[i++] = &target_fabric_tpg_base_attr_rtpi;
 
 	cit->ct_item_ops = &target_fabric_tpg_base_item_ops;
-	cit->ct_attrs = attrs;
+	cit->ct_attrs_const = attrs;
 	cit->ct_owner = tf->tf_ops->module;
 	pr_debug("Setup generic tpg_base\n");
 
@@ -1117,7 +1117,7 @@ target_fabric_wwn_direct_submit_supported_show(struct config_item *item,
 }
 CONFIGFS_ATTR_RO(target_fabric_wwn_, direct_submit_supported);
 
-static struct configfs_attribute *target_fabric_wwn_param_attrs[] = {
+static const struct configfs_attribute *const target_fabric_wwn_param_attrs[] = {
 	&target_fabric_wwn_attr_cmd_completion_affinity,
 	&target_fabric_wwn_attr_default_complete_type,
 	&target_fabric_wwn_attr_direct_complete_supported,
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 07b514678176..50f3e03ba015 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -3149,7 +3149,7 @@ static ssize_t tcmu_free_kept_buf_store(struct config_item *item, const char *pa
 }
 CONFIGFS_ATTR_WO(tcmu_, free_kept_buf);
 
-static struct configfs_attribute *tcmu_attrib_attrs[] = {
+static const struct configfs_attribute *const tcmu_attrib_attrs[] = {
 	&tcmu_attr_cmd_time_out,
 	&tcmu_attr_qfull_time_out,
 	&tcmu_attr_max_data_area_mb,
@@ -3163,9 +3163,9 @@ static struct configfs_attribute *tcmu_attrib_attrs[] = {
 	NULL,
 };
 
-static struct configfs_attribute **tcmu_attrs;
+static const struct configfs_attribute **tcmu_attrs;
 
-static struct configfs_attribute *tcmu_action_attrs[] = {
+static const struct configfs_attribute *const tcmu_action_attrs[] = {
 	&tcmu_attr_block_dev,
 	&tcmu_attr_reset_ring,
 	&tcmu_attr_free_kept_buf,
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 3920fb02d9fc..81d72fa6a384 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -185,7 +185,7 @@ static ssize_t ft_nacl_tag_store(struct config_item *item,
 
 CONFIGFS_ATTR(ft_nacl_, tag);
 
-static struct configfs_attribute *ft_nacl_base_attrs[] = {
+static const struct configfs_attribute *const ft_nacl_base_attrs[] = {
 	&ft_nacl_attr_port_name,
 	&ft_nacl_attr_node_name,
 	&ft_nacl_attr_tag,
@@ -375,7 +375,7 @@ static ssize_t ft_wwn_version_show(struct config_item *item, char *page)
 
 CONFIGFS_ATTR_RO(ft_wwn_, version);
 
-static struct configfs_attribute *ft_wwn_attrs[] = {
+static const struct configfs_attribute *const ft_wwn_attrs[] = {
 	&ft_wwn_attr_version,
 	NULL,
 };
diff --git a/drivers/target/tcm_remote/tcm_remote.c b/drivers/target/tcm_remote/tcm_remote.c
index 03b00f6eca58..4e23999117ee 100644
--- a/drivers/target/tcm_remote/tcm_remote.c
+++ b/drivers/target/tcm_remote/tcm_remote.c
@@ -225,7 +225,7 @@ static ssize_t tcm_remote_wwn_version_show(struct config_item *item, char *page)
 
 CONFIGFS_ATTR_RO(tcm_remote_wwn_, version);
 
-static struct configfs_attribute *tcm_remote_wwn_attrs[] = {
+static const struct configfs_attribute *const tcm_remote_wwn_attrs[] = {
 	&tcm_remote_wwn_attr_version,
 	NULL,
 };
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 9e6d4f39900a..07ee34e53225 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1811,7 +1811,7 @@ static ssize_t usbg_wwn_version_show(struct config_item *item,  char *page)
 
 CONFIGFS_ATTR_RO(usbg_wwn_, version);
 
-static struct configfs_attribute *usbg_wwn_attrs[] = {
+static const struct configfs_attribute *const usbg_wwn_attrs[] = {
 	&usbg_wwn_attr_version,
 	NULL,
 };
@@ -1978,7 +1978,7 @@ static ssize_t tcm_usbg_tpg_nexus_store(struct config_item *item,
 
 CONFIGFS_ATTR(tcm_usbg_tpg_, nexus);
 
-static struct configfs_attribute *usbg_base_attrs[] = {
+static const struct configfs_attribute *const usbg_base_attrs[] = {
 	&tcm_usbg_tpg_attr_nexus,
 	NULL,
 };
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index e44044449cef..e349f1958ed6 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2663,7 +2663,7 @@ static ssize_t vhost_scsi_tpg_attrib_fabric_prot_type_show(
 
 CONFIGFS_ATTR(vhost_scsi_tpg_attrib_, fabric_prot_type);
 
-static struct configfs_attribute *vhost_scsi_tpg_attrib_attrs[] = {
+static const struct configfs_attribute *const vhost_scsi_tpg_attrib_attrs[] = {
 	&vhost_scsi_tpg_attrib_attr_fabric_prot_type,
 	NULL,
 };
@@ -2855,7 +2855,7 @@ static ssize_t vhost_scsi_tpg_nexus_store(struct config_item *item,
 
 CONFIGFS_ATTR(vhost_scsi_tpg_, nexus);
 
-static struct configfs_attribute *vhost_scsi_tpg_attrs[] = {
+static const struct configfs_attribute *const vhost_scsi_tpg_attrs[] = {
 	&vhost_scsi_tpg_attr_nexus,
 	NULL,
 };
@@ -2999,7 +2999,7 @@ vhost_scsi_wwn_version_show(struct config_item *item, char *page)
 
 CONFIGFS_ATTR_RO(vhost_scsi_wwn_, version);
 
-static struct configfs_attribute *vhost_scsi_wwn_attrs[] = {
+static const struct configfs_attribute *const vhost_scsi_wwn_attrs[] = {
 	&vhost_scsi_wwn_attr_version,
 	NULL,
 };
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index c7036e0e41bd..836c8419f014 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1518,7 +1518,7 @@ static ssize_t scsiback_tpg_param_alias_store(struct config_item *item,
 
 CONFIGFS_ATTR(scsiback_tpg_param_, alias);
 
-static struct configfs_attribute *scsiback_param_attrs[] = {
+static const struct configfs_attribute *const scsiback_param_attrs[] = {
 	&scsiback_tpg_param_attr_alias,
 	NULL,
 };
@@ -1713,7 +1713,7 @@ static ssize_t scsiback_tpg_nexus_store(struct config_item *item,
 
 CONFIGFS_ATTR(scsiback_tpg_, nexus);
 
-static struct configfs_attribute *scsiback_tpg_attrs[] = {
+static const struct configfs_attribute *const scsiback_tpg_attrs[] = {
 	&scsiback_tpg_attr_nexus,
 	NULL,
 };
@@ -1728,7 +1728,7 @@ scsiback_wwn_version_show(struct config_item *item, char *page)
 
 CONFIGFS_ATTR_RO(scsiback_wwn_, version);
 
-static struct configfs_attribute *scsiback_wwn_attrs[] = {
+static const struct configfs_attribute *const scsiback_wwn_attrs[] = {
 	&scsiback_wwn_attr_version,
 	NULL,
 };
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index e32de80854b6..8f4f3e0bfa30 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -58,8 +58,8 @@ struct target_backend_ops {
 	int (*format_prot)(struct se_device *);
 	void (*free_prot)(struct se_device *);
 
-	struct configfs_attribute **tb_dev_attrib_attrs;
-	struct configfs_attribute **tb_dev_action_attrs;
+	const struct configfs_attribute *const *tb_dev_attrib_attrs;
+	const struct configfs_attribute *const *tb_dev_action_attrs;
 };
 
 struct exec_cmd_ops {
@@ -104,9 +104,9 @@ int	transport_set_vpd_assoc(struct t10_vpd *, unsigned char *);
 int	transport_set_vpd_ident_type(struct t10_vpd *, unsigned char *);
 int	transport_set_vpd_ident(struct t10_vpd *, unsigned char *);
 
-extern struct configfs_attribute *sbc_attrib_attrs[];
-extern struct configfs_attribute *passthrough_attrib_attrs[];
-extern struct configfs_attribute *passthrough_pr_attrib_attrs[];
+extern const struct configfs_attribute *const sbc_attrib_attrs[];
+extern const struct configfs_attribute *const passthrough_attrib_attrs[];
+extern const struct configfs_attribute *const passthrough_pr_attrib_attrs[];
 
 /* core helpers also used by command snooping in pscsi */
 void	*transport_kmap_data_sg(struct se_cmd *);
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 390ace5bb252..963fb8761bf5 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -102,17 +102,17 @@ struct target_core_fabric_ops {
 	void (*fabric_drop_np)(struct se_tpg_np *);
 	int (*fabric_init_nodeacl)(struct se_node_acl *, const char *);
 
-	struct configfs_attribute **tfc_discovery_attrs;
-	struct configfs_attribute **tfc_wwn_attrs;
-	struct configfs_attribute **tfc_tpg_base_attrs;
-	struct configfs_attribute **tfc_tpg_np_base_attrs;
-	struct configfs_attribute **tfc_tpg_attrib_attrs;
-	struct configfs_attribute **tfc_tpg_auth_attrs;
-	struct configfs_attribute **tfc_tpg_param_attrs;
-	struct configfs_attribute **tfc_tpg_nacl_base_attrs;
-	struct configfs_attribute **tfc_tpg_nacl_attrib_attrs;
-	struct configfs_attribute **tfc_tpg_nacl_auth_attrs;
-	struct configfs_attribute **tfc_tpg_nacl_param_attrs;
+	const struct configfs_attribute *const *tfc_discovery_attrs;
+	const struct configfs_attribute *const *tfc_wwn_attrs;
+	const struct configfs_attribute *const *tfc_tpg_base_attrs;
+	const struct configfs_attribute *const *tfc_tpg_np_base_attrs;
+	const struct configfs_attribute *const *tfc_tpg_attrib_attrs;
+	const struct configfs_attribute *const *tfc_tpg_auth_attrs;
+	const struct configfs_attribute *const *tfc_tpg_param_attrs;
+	const struct configfs_attribute *const *tfc_tpg_nacl_base_attrs;
+	const struct configfs_attribute *const *tfc_tpg_nacl_attrib_attrs;
+	const struct configfs_attribute *const *tfc_tpg_nacl_auth_attrs;
+	const struct configfs_attribute *const *tfc_tpg_nacl_param_attrs;
 
 	/*
 	 * Set this member variable if the SCSI transport protocol

---
base-commit: ddfe51b0a0f5dc9e415cc2c8ad8db17532dd426b
change-id: 20261107-configfs-const-target-04778384190f

Best regards,
--  
Thomas Weißschuh <linux@weissschuh.net>

