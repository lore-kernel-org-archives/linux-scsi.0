From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 5/5] [TCM_Loop]: Add support for multi-fabric CDB level emulation
Date: Wed, 12 May 2010 00:35:57 -0700
Message-ID: <1273649757-21815-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp109.sbc.mail.gq1.yahoo.com ([67.195.14.39]:37905 "HELO
	smtp109.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751584Ab0ELFTI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 May 2010 01:19:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.e>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for SAS, FC and iSCSI CDB level fabric emulation
using the new generic target_core_fabric_lib.c handlers into TCM_Loop code.
It works by searching for the following prefixes in the configfs group provided
name at 'mkdir -p /sys/kernel/config/target/loopback/$WWN' time:

	*) naa. -> SCSI_PROTOCOL_SAS

	*) fc. -> SCSI_PROTOCOL_FCP

	*) iqn. -> SCSI_PROTOCOL_ISCSI

to determine the ProtoID for struct tcm_loop_hba->tl_proto_id in order to configure the
emulated Target Ports in tcm_loop_make_scsi_hba(), and emulated Initiator Ports
in tcm_loop_tpg_store_nexus().  Note that passed 'fc.' prefix is stripped to follow
existing TCM_FC naming, while the 'naa.' and 'iqn.' prefixes are currently left with their
prefixes in tact.

Once the ProtoID is first determined in tcm_loop_make_scsi_hba(), the fabric prefix
of the Initiator Port value written into /sys/kernel/config/target/loopback/$WWN/tpgt_$TPGT/nexus
must match the Target Ports being referenced during virtual I_T Nexus creation time.

The following TCM_Loop functions have updated to the handle the initial 3 multi-protocol cases
using the generic target_core_fabric_lib.c code:

	*) tcm_loop_get_fabric_proto_ident()

	*) tcm_loop_get_pr_transport_id()

	*) tcm_loop_get_pr_transport_id_len()

	*) tcm_loop_parse_pr_out_transport_id()

Note that currently only a single nexus is supported per TCM_Loop endpoint context, but
that multiple target endpoints running with different ProtoIDs can map the same
TCM backstore multiple times using different emulated I_T Nexuses.

So far >= SPC-3 PR and ALUA emulation for the three SCSI protocol fabrics are able to
function with the Linux/SCSI struct scsi_device and SG_IO driven by the TCM_Loop LLD.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_loop/tcm_loop_configfs.c |  140 ++++++++++++++++++-------
 drivers/target/tcm_loop/tcm_loop_core.h     |    7 +-
 drivers/target/tcm_loop/tcm_loop_fabric.c   |  147 +++++++++++++++++----------
 3 files changed, 199 insertions(+), 95 deletions(-)

diff --git a/drivers/target/tcm_loop/tcm_loop_configfs.c b/drivers/target/tcm_loop/tcm_loop_configfs.c
index 094f394..e2093c2 100644
--- a/drivers/target/tcm_loop/tcm_loop_configfs.c
+++ b/drivers/target/tcm_loop/tcm_loop_configfs.c
@@ -1,8 +1,8 @@
 /*******************************************************************************
  * Filename:  tcm_loop_configfs.c
  *
- * This file contains the configfs implementation for TCM_Loop Virtual SAS
- * target to Linux/SCSI SAS initiator node
+ * This file contains configfs implemenation for initiator and target
+ * side CDB level emulation of SAS, FC and iSCSI ports to Linux/SCSI LUNs.
  *
  * Copyright (c) 2009, 2010 Rising Tide, Inc.
  * Copyright (c) 2009, 2010 Linux-iSCSI.org
@@ -40,6 +40,7 @@
 #include <target/target_core_transport.h>
 #include <target/target_core_fabric_ops.h>
 #include <target/target_core_fabric_configfs.h>
+#include <target/target_core_fabric_lib.h>
 #include <target/target_core_device.h>
 #include <target/target_core_tpg.h>
 #include <target/target_core_configfs.h>
@@ -58,6 +59,22 @@ struct target_fabric_configfs *tcm_loop_fabric_configfs;
 
 static int tcm_loop_hba_no_cnt;
 
+static char *tcm_loop_dump_proto_id(struct tcm_loop_hba *tl_hba)
+{
+	switch (tl_hba->tl_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+		return "SAS";
+	case SCSI_PROTOCOL_FCP:
+		return "FCP";
+	case SCSI_PROTOCOL_ISCSI:
+		return "iSCSI";
+	default:
+		break;
+	}
+
+	return "Unknown";
+}
+
 /* Start items for tcm_loop_port_cit */
 
 int tcm_loop_port_link(
@@ -113,6 +130,7 @@ static int tcm_loop_make_nexus(
 	const char *name)
 {
 	se_portal_group_t *se_tpg;
+	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
 	struct tcm_loop_nexus *tl_nexus;
 
 	if (tl_tpg->tl_hba->tl_nexus) {
@@ -152,7 +170,8 @@ static int tcm_loop_make_nexus(
 			tl_nexus->se_sess, (void *)tl_nexus);
 
 	printk(KERN_INFO "TCM_Loop_ConfigFS: Established I_T Nexus to emulated"
-			" SAS Initiator Port: %s\n", name);
+		" %s Initiator Port: %s\n", tcm_loop_dump_proto_id(tl_hba),
+		name);
 	return 0;
 
 out:
@@ -164,13 +183,14 @@ static void tcm_loop_drop_nexus(
 	struct tcm_loop_tpg *tpg)
 {
 	struct tcm_loop_nexus *tl_nexus;
+	struct tcm_loop_hba *tl_hba = tpg->tl_hba;
 
 	tl_nexus = tpg->tl_hba->tl_nexus;
 	if (!(tl_nexus))
 		return;
 
 	printk(KERN_INFO "TCM_Loop_ConfigFS: Removing I_T Nexus to emulated"
-		" SAS Initiator Port: %s\n",
+		" %s Initiator Port: %s\n", tcm_loop_dump_proto_id(tl_hba),
 		tl_nexus->se_sess->se_node_acl->initiatorname);
 	/*
 	 * Release the SCSI I_T Nexus to the emulated SAS Target Port
@@ -195,7 +215,7 @@ static ssize_t tcm_loop_tpg_show_nexus(
 	if (!(tl_nexus))
 		return -ENODEV;
 
-	ret = snprintf(page, PAGE_SIZE, "%s",
+	ret = snprintf(page, PAGE_SIZE, "%s\n",
 		tl_nexus->se_sess->se_node_acl->initiatorname);
 
 	return ret;
@@ -208,7 +228,8 @@ static ssize_t tcm_loop_tpg_store_nexus(
 {
 	struct tcm_loop_tpg *tl_tpg = container_of(se_tpg,
 			struct tcm_loop_tpg, tl_se_tpg);
-	unsigned char i_port[TL_NAA_SAS_ADDR_LEN], *ptr;
+	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
+	unsigned char i_port[TL_WWN_ADDR_LEN], *ptr, *port_ptr;
 	int ret;
 	/*
 	 * Shutdown the active I_T nexus if 'NULL' is passed..
@@ -218,29 +239,61 @@ static ssize_t tcm_loop_tpg_store_nexus(
 		return count;
 	}
 	/*
-	 * Otherwise validate the passed NAA WWN for the virtual SAS
-	 * Initiator port, and call tcm_loop_make_nexus()
+	 * Otherwise make sure the passed virtual Initiator port WWN matches
+	 * the fabric protocol_id set in tcm_loop_make_scsi_hba(), and call
+	 * tcm_loop_make_nexus()
 	 */
-	if (strlen(page) > TL_NAA_SAS_ADDR_LEN) {
+	if (strlen(page) > TL_WWN_ADDR_LEN) {
 		printk(KERN_ERR "Emulated NAA Sas Address: %s, exceeds"
-			" max: %d\n", page, TL_NAA_SAS_ADDR_LEN);
+				" max: %d\n", page, TL_WWN_ADDR_LEN);
 		return -EINVAL;
 	}
-	snprintf(&i_port[0], TL_NAA_SAS_ADDR_LEN, "%s", page);
+	snprintf(&i_port[0], TL_WWN_ADDR_LEN, "%s", page);
 
 	ptr = strstr(i_port, "naa.");
-	if (!(ptr)) {
-		printk(KERN_ERR "Unable to locate \"naa.\" prefix for emulated"
-                        " SAS Initiator Port\n");
-		return -EINVAL;
+	if (ptr) {
+		if (tl_hba->tl_proto_id != SCSI_PROTOCOL_SAS) {
+			printk(KERN_ERR "Passed SAS Initiator Port %s does not"
+				" match target port protoid: %s\n", i_port,
+				tcm_loop_dump_proto_id(tl_hba));
+			return -EINVAL;
+		}
+		port_ptr = &i_port[0];
+		goto check_newline;
+	}
+	ptr = strstr(i_port, "fc.");
+	if (ptr) {
+		if (tl_hba->tl_proto_id != SCSI_PROTOCOL_FCP) {
+			printk(KERN_ERR "Passed FCP Initiator Port %s does not"
+				" match target port protoid: %s\n", i_port,
+				tcm_loop_dump_proto_id(tl_hba));
+			return -EINVAL;
+		}
+		port_ptr = &i_port[3]; /* Skip over "fc." */
+		goto check_newline;
 	}
+	ptr = strstr(i_port, "iqn.");
+	if (ptr) {
+		if (tl_hba->tl_proto_id != SCSI_PROTOCOL_ISCSI) {
+			printk(KERN_ERR "Passed iSCSI Initiator Port %s does not"
+				" match target port protoid: %s\n", i_port,
+				tcm_loop_dump_proto_id(tl_hba));
+			return -EINVAL;
+		}
+		port_ptr = &i_port[0];
+		goto check_newline;
+	}
+	printk(KERN_ERR "Unable to locate prefix for emulated Initiator Port:"
+			" %s\n", i_port);
+	return -EINVAL;
 	/*
 	 * Clear any trailing newline for the NAA WWN
 	 */
+check_newline:
 	if (i_port[strlen(i_port)-1] == '\n')
 		i_port[strlen(i_port)-1] = '\0';
 		
-	ret = tcm_loop_make_nexus(tl_tpg, i_port);
+	ret = tcm_loop_make_nexus(tl_tpg, port_ptr);
 	if (ret < 0)
 		return ret;
 
@@ -294,8 +347,8 @@ struct se_portal_group_s *tcm_loop_make_naa_tpg(
 	if (ret < 0)
 		return ERR_PTR(-ENOMEM);
 
-	printk(KERN_INFO "TCM_Loop_ConfigFS: Allocated Emulated SAS"
-		" Target Port %s,t,0x%04x\n",
+	printk(KERN_INFO "TCM_Loop_ConfigFS: Allocated Emulated %s"
+		" Target Port %s,t,0x%04x\n", tcm_loop_dump_proto_id(tl_hba),
 		config_item_name(&wwn->wwn_group.cg_item), tpgt);
 
 	return &tl_tpg->tl_se_tpg;
@@ -321,8 +374,8 @@ void tcm_loop_drop_naa_tpg(
 	 */
 	core_tpg_deregister(se_tpg);
 
-	printk(KERN_INFO "TCM_Loop_ConfigFS: Deallocated Emulated SAS"
-		" Target Port %s,t,0x%04x\n",
+	printk(KERN_INFO "TCM_Loop_ConfigFS: Deallocated Emulated %s"
+		" Target Port %s,t,0x%04x\n", tcm_loop_dump_proto_id(tl_hba),
 		config_item_name(&wwn->wwn_group.cg_item), tpgt);
 }
 
@@ -338,7 +391,7 @@ struct se_wwn_s *tcm_loop_make_scsi_hba(
 	struct tcm_loop_hba *tl_hba;
 	struct Scsi_Host *sh;
 	char *ptr;
-	int ret;
+	int ret, off = 0;
 
 	tl_hba = kzalloc(sizeof(struct tcm_loop_hba), GFP_KERNEL);
 	if (!(tl_hba)) {
@@ -346,28 +399,39 @@ struct se_wwn_s *tcm_loop_make_scsi_hba(
                 return ERR_PTR(-ENOMEM);
         }
 	/*
-	 * Locate the emulated SAS Target Port name in NAA IEEE Registered
-	 * Extended DESIGNATOR field format with the 'naa.' string prefix from
-	 * the passed configfs directory name.
-	 *
-	 * This code assume the actual NAA identifier is parsed to follow spc4
-	 * in userspace.,
+	 * Determine the emulated Protocol Identifier and Target Port Name
+	 * based on the incoming configfs directory name.
 	 */
 	ptr = strstr(name, "naa.");
-	if (!(ptr)) {
-		printk(KERN_ERR "Unable to locate \"naa.\" prefix for emulated"
-			" SAS Target Port\n");
-		return ERR_PTR(-EINVAL);
+	if (ptr) {
+		tl_hba->tl_proto_id = SCSI_PROTOCOL_SAS;
+		goto check_len;
+	}
+	ptr = strstr(name, "fc.");      
+	if (ptr) {
+		tl_hba->tl_proto_id = SCSI_PROTOCOL_FCP;
+		off = 3; /* Skip over "fc." */
+		goto check_len;
+	}
+	ptr = strstr(name, "iqn.");
+	if (ptr) {
+		tl_hba->tl_proto_id = SCSI_PROTOCOL_ISCSI;
+		goto check_len;
 	}
-	ptr++;
 
-	if (strlen(name) > TL_NAA_SAS_ADDR_LEN) {
-		printk(KERN_ERR "Emulated NAA Sas Address: %s, exceeds"
-			" max: %d\n", name, TL_NAA_SAS_ADDR_LEN);
+	printk(KERN_ERR "Unable to locate prefix for emulated Target Port:"
+			" %s\n", name);
+	return ERR_PTR(-EINVAL);
+
+check_len:
+	if (strlen(name) > TL_WWN_ADDR_LEN) {
+		printk(KERN_ERR "Emulated NAA %s Address: %s, exceeds"
+			" max: %d\n", name, tcm_loop_dump_proto_id(tl_hba),
+			TL_WWN_ADDR_LEN);
 		kfree(tl_hba);
 		return ERR_PTR(-EINVAL);
 	}
-	snprintf(&tl_hba->naa_sas_address[0], TL_NAA_SAS_ADDR_LEN, "%s", name);
+	snprintf(&tl_hba->tl_wwn_address[0], TL_WWN_ADDR_LEN, "%s", &name[off]);
 
 	/*
 	 * Setup the tl_hba->tl_hba_qobj
@@ -405,8 +469,8 @@ struct se_wwn_s *tcm_loop_make_scsi_hba(
 
 	tcm_loop_hba_no_cnt++;
 	printk(KERN_INFO "TCM_Loop_ConfigFS: Allocated emulated Target"
-		" SAS Address: %s at Linux/SCSI Host ID: %d\n",
-			name, sh->host_no);
+		" %s Address: %s at Linux/SCSI Host ID: %d\n",
+		tcm_loop_dump_proto_id(tl_hba), name, sh->host_no);
 
 	return &tl_hba->tl_hba_wwn;
 out:
diff --git a/drivers/target/tcm_loop/tcm_loop_core.h b/drivers/target/tcm_loop/tcm_loop_core.h
index a160082..20be0d8 100644
--- a/drivers/target/tcm_loop/tcm_loop_core.h
+++ b/drivers/target/tcm_loop/tcm_loop_core.h
@@ -1,5 +1,5 @@
-#define TCM_LOOP_VERSION		"v1.0"
-#define TL_NAA_SAS_ADDR_LEN		64
+#define TCM_LOOP_VERSION		"v2.0"
+#define TL_WWN_ADDR_LEN			256
 #define TL_TPGS_PER_HBA			32
 /*
  * Defaults for struct scsi_host_template tcm_loop_driver_template
@@ -57,7 +57,8 @@ struct tcm_loop_tpg {
 };
 
 struct tcm_loop_hba {
-	unsigned char naa_sas_address[TL_NAA_SAS_ADDR_LEN];
+	u8 tl_proto_id;
+	unsigned char tl_wwn_address[TL_WWN_ADDR_LEN];
 	struct se_hba_s *se_hba;
 	struct se_lun_s *tl_hba_lun;
 	struct se_port_s *tl_hba_lun_sep;
diff --git a/drivers/target/tcm_loop/tcm_loop_fabric.c b/drivers/target/tcm_loop/tcm_loop_fabric.c
index 30a90ec..46d2aa9 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric.c
@@ -1,13 +1,13 @@
 /*******************************************************************************
  * Filename:  tcm_loop_fabric.c
  *
- * This file contains the TCM fabric module for initiator side virtual SAS
- * using emulated target mode SAS ports
+ * This file contains the TCM loopback fabric module for initiator and target
+ * side CDB level emulation of SAS, FC and iSCSI ports to Linux/SCSI LUNs.
  *
- * Copyright (c) 2009 Rising Tide, Inc.
- * Copyright (c) 2009 Linux-iSCSI.org
+ * Copyright (c) 2009, 2010 Rising Tide, Inc.
+ * Copyright (c) 2009, 2010 Linux-iSCSI.org
  *
- * Copyright (c) 2009 Nicholas A. Bellinger <nab@linux-iscsi.org>
+ * Copyright (c) 2009, 2010  Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -35,6 +35,7 @@
 #include <target/target_core_base.h>
 #include <target/target_core_transport.h>
 #include <target/target_core_fabric_ops.h>
+#include <target/target_core_fabric_lib.h>
 #include <target/target_core_device.h>
 #include <target/target_core_tpg.h>
 #include <target/target_core_configfs.h>
@@ -53,11 +54,30 @@ char *tcm_loop_get_fabric_name(void)
 
 u8 tcm_loop_get_fabric_proto_ident(se_portal_group_t *se_tpg)
 {
+	struct tcm_loop_tpg *tl_tpg =
+			(struct tcm_loop_tpg *)se_tpg->se_tpg_fabric_ptr;
+	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
 	/*
-	 * Return a SAS Serial SCSI Protocol identifier for loopback operations
-	 * This is defined in  section 7.5.1 Table 362 in spc4r17
+	 * tl_proto_id is set at tcm_loop_configfs.c:tcm_loop_make_scsi_hba()
+	 * time based on the protocol dependent prefix of the passed configfs group.
+	 *
+	 * Based upon tl_proto_id, TCM_Loop emulates the requested fabric
+	 * ProtocolID using target_core_fabric_lib.c symbols.
 	 */
-	return 0x6;
+	switch (tl_hba->tl_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+		return sas_get_fabric_proto_ident(se_tpg);
+	case SCSI_PROTOCOL_FCP:
+		return fc_get_fabric_proto_ident(se_tpg);
+	case SCSI_PROTOCOL_ISCSI:
+		return iscsi_get_fabric_proto_ident(se_tpg);
+	default:
+		printk(KERN_ERR "Unknown tl_proto_id: 0x%02x, using"
+			" SAS emulation\n", tl_hba->tl_proto_id);
+		break;
+	}
+
+	return sas_get_fabric_proto_ident(se_tpg);
 }
 
 char *tcm_loop_get_endpoint_wwn(se_portal_group_t *se_tpg)
@@ -67,7 +87,7 @@ char *tcm_loop_get_endpoint_wwn(se_portal_group_t *se_tpg)
 	/*
 	 * Return the passed NAA identifier for the SAS Target Port
 	 */
-	return &tl_tpg->tl_hba->naa_sas_address[0];
+	return &tl_tpg->tl_hba->tl_wwn_address[0];
 }
 
 u16 tcm_loop_get_tag(se_portal_group_t *se_tpg)
@@ -94,33 +114,28 @@ u32 tcm_loop_get_pr_transport_id(
 	int *format_code,
 	unsigned char *buf)
 {
-	unsigned char binary, *ptr;
-	int i;
-	u32 off = 4;
-	/*
-	 * Set PROTOCOL IDENTIFIER to 6h for SAS
-	 */
-	buf[0] = 0x06;
-	/*
-	 * From spc4r17, 7.5.4.7 TransportID for initiator ports using SCSI
-	 * over SAS Serial SCSI Protocol
-	 * 
-	 * For TCM_Loop, we use the configfs group name of INIT_SAS_ADDRESS:
-	 * and converting the 16-byte ASCII value into a 8-byte binary hex
-	 * buffer.
-	 *
-	 * target/loopback/naa.<TGT_SAS_ADDRESS>/nexus/naa.<INIt_SAS_ADDRESS>
-	 */
-	ptr = &se_nacl->initiatorname[4]; /* Skip over 'naa. prefix */
-
-	for (i = 0; i < 16; i += 2) {
-		binary = transport_asciihex_to_binaryhex(&ptr[i]);	
-		buf[off++] = binary;
+	struct tcm_loop_tpg *tl_tpg =
+			(struct tcm_loop_tpg *)se_tpg->se_tpg_fabric_ptr;
+	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
+
+	switch (tl_hba->tl_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+		return sas_get_pr_transport_id(se_tpg, se_nacl, pr_reg,
+					format_code, buf);
+	case SCSI_PROTOCOL_FCP:
+		return fc_get_pr_transport_id(se_tpg, se_nacl, pr_reg,
+					format_code, buf);
+	case SCSI_PROTOCOL_ISCSI:
+		return iscsi_get_pr_transport_id(se_tpg, se_nacl, pr_reg,
+					format_code, buf);
+	default:
+		printk(KERN_ERR "Unknown tl_proto_id: 0x%02x, using"
+			" SAS emulation\n", tl_hba->tl_proto_id);
+		break;
 	}
-	/*
-	 * The SAS Transport ID is a hardcoded 24-byte length
-	 */
-	return 24;
+
+	return sas_get_pr_transport_id(se_tpg, se_nacl, pr_reg,
+			format_code, buf);
 }
 
 u32 tcm_loop_get_pr_transport_id_len(
@@ -129,14 +144,28 @@ u32 tcm_loop_get_pr_transport_id_len(
 	t10_pr_registration_t *pr_reg,
 	int *format_code)
 {
-	*format_code = 0;
-	/*
-	 * From spc4r17, 7.5.4.7 TransportID for initiator ports using SCSI
-	 * over SAS Serial SCSI Protocol
-	 *
-	 * The SAS Transport ID is a hardcoded 24-byte length
-	 */
-	return 24;
+	struct tcm_loop_tpg *tl_tpg =
+			(struct tcm_loop_tpg *)se_tpg->se_tpg_fabric_ptr;
+	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
+
+	switch (tl_hba->tl_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+		return sas_get_pr_transport_id_len(se_tpg, se_nacl, pr_reg,
+					format_code);
+	case SCSI_PROTOCOL_FCP:
+		return fc_get_pr_transport_id_len(se_tpg, se_nacl, pr_reg,
+					format_code);
+	case SCSI_PROTOCOL_ISCSI:
+		return iscsi_get_pr_transport_id_len(se_tpg, se_nacl, pr_reg,
+					format_code);
+	default:
+		printk(KERN_ERR "Unknown tl_proto_id: 0x%02x, using"
+			" SAS emulation\n", tl_hba->tl_proto_id);
+		break;
+	}
+
+	return sas_get_pr_transport_id_len(se_tpg, se_nacl, pr_reg,
+			format_code);
 }
 
 /*
@@ -149,18 +178,28 @@ char *tcm_loop_parse_pr_out_transport_id(
 	u32 *out_tid_len,
 	char **port_nexus_ptr)
 {
-	/*
-	 * Assume the FORMAT CODE 00b from spc4r17, 7.5.4.7 TransportID
-	 * for initiator ports using SCSI over SAS Serial SCSI Protocol
-	 *
-	 * The TransportID for a SAS Initiator Port is of fixed size of
-	 * 24 bytes, and SAS does not contain a I_T nexus identifier,
-	 * so we return the **port_nexus_ptr set to NULL.
-	 */
-	*port_nexus_ptr = NULL;
-	*out_tid_len = 24;
+	struct tcm_loop_tpg *tl_tpg =
+			(struct tcm_loop_tpg *)se_tpg->se_tpg_fabric_ptr;
+	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
+
+	switch (tl_hba->tl_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+		return sas_parse_pr_out_transport_id(se_tpg, buf, out_tid_len,
+					port_nexus_ptr);
+	case SCSI_PROTOCOL_FCP:
+		return fc_parse_pr_out_transport_id(se_tpg, buf, out_tid_len,
+					port_nexus_ptr);
+	case SCSI_PROTOCOL_ISCSI:
+		return iscsi_parse_pr_out_transport_id(se_tpg, buf, out_tid_len,
+					port_nexus_ptr);
+	default:
+		printk(KERN_ERR "Unknown tl_proto_id: 0x%02x, using"
+			" SAS emulation\n", tl_hba->tl_proto_id);
+		break;
+	}
 
-	return (char *)&buf[4];
+	return sas_parse_pr_out_transport_id(se_tpg, buf, out_tid_len,
+			port_nexus_ptr);
 }
 
 /*
-- 
1.5.6.5

