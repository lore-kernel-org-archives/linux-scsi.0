Return-Path: <SRS0=VN9r=DQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1F0C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 09:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA9822225B
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 09:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="WCKr4GEL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733111AbgJIJhZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Oct 2020 05:37:25 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9338 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733112AbgJIJhY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2020 05:37:24 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0999OjIZ015757
        for <linux-scsi@vger.kernel.org>; Fri, 9 Oct 2020 02:37:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Lk3TdvCm/VTnc+TQiR6aJwsE1Y5kSpIfg3su5rVa2Bk=;
 b=WCKr4GELNuBNtF1MHNso8wBGESbOGbNz9jOBhlrdorJa4rhB2mawVg0hgRrmZnzY2s3h
 Y6Umo1PaQyE6XrlHZ51x+FwwaYM+kh+zFzcEMh8bId/RDVro8mArYC4a/0tWhl7IRKF+
 kWpM27snb0uwFaC2zCoE8gc06prJwJ9Fx2oIHmyRgx7ijkz2ncERfNii4j/WbGMdGmcM
 qgORxaRVD7DFOpC9717pxO9kgJimO/GTD7LbuqMUWG4ouiGcwdxGuOMlrsCe94/thCWS
 uORY7rQLaI+4x5Ud/9Jm6pBKuawkLkhWKZ+gXhr89c0zZvKrlUImZRuYCpSJ5Wwcy9XC pA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 3429hh2467-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2020 02:37:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 02:37:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 02:37:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Oct 2020 02:37:20 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 157C63F703F;
        Fri,  9 Oct 2020 02:37:20 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0999bJ5c004230;
        Fri, 9 Oct 2020 02:37:19 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0999bJvx004220;
        Fri, 9 Oct 2020 02:37:19 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 1/4] include:scsi: FDMI enhancement
Date:   Fri, 9 Oct 2020 02:36:28 -0700
Message-ID: <20201009093631.4182-2-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201009093631.4182-1-jhasan@marvell.com>
References: <20201009093631.4182-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_05:2020-10-09,2020-10-09 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All the attributes added for RHBA and RPA registration.
Fall back mechanism is added in between RBHA V2 and
RHBA V1 attributes. In case RHBA get failed
for RBHA V2 attributes, then we fall back to  RHBA V1
attributes registration.

Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 include/scsi/fc_encode.h         | 249 ++++++++++++++++++++++++++++++-
 include/scsi/scsi_transport_fc.h |  25 +++-
 2 files changed, 270 insertions(+), 4 deletions(-)

diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
index c6660205d73f..57aae3e25c43 100644
--- a/include/scsi/fc_encode.h
+++ b/include/scsi/fc_encode.h
@@ -210,10 +210,11 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 	struct fc_fdmi_attr_entry *entry;
 	struct fs_fdmi_attrs *hba_attrs;
 	int numattrs = 0;
+	struct fc_host_attrs *fc_host = shost_to_fc_host(lport->host);
 
 	switch (op) {
 	case FC_FDMI_RHBA:
-		numattrs = 10;
+		numattrs = 11;
 		len = sizeof(struct fc_fdmi_rhba);
 		len -= sizeof(struct fc_fdmi_attr_entry);
 		len += (numattrs * FC_FDMI_ATTR_ENTRY_HEADER_LEN);
@@ -227,8 +228,21 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 		len += FC_FDMI_HBA_ATTR_OPTIONROMVERSION_LEN;
 		len += FC_FDMI_HBA_ATTR_FIRMWAREVERSION_LEN;
 		len += FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN;
+		len += FC_FDMI_HBA_ATTR_MAXCTPAYLOAD_LEN;
+
+		if (fc_host->fdmi_version == FDMI_V2) {
+			numattrs += 7;
+			len += FC_FDMI_HBA_ATTR_NODESYMBLNAME_LEN;
+			len += FC_FDMI_HBA_ATTR_VENDORSPECIFICINFO_LEN;
+			len += FC_FDMI_HBA_ATTR_NUMBEROFPORTS_LEN;
+			len += FC_FDMI_HBA_ATTR_FABRICNAME_LEN;
+			len += FC_FDMI_HBA_ATTR_BIOSVERSION_LEN;
+			len += FC_FDMI_HBA_ATTR_BIOSSTATE_LEN;
+			len += FC_FDMI_HBA_ATTR_VENDORIDENTIFIER_LEN;
+		}
+
 		ct = fc_ct_hdr_fill(fp, op, len, FC_FST_MGMT,
-				    FC_FDMI_SUBTYPE);
+				FC_FDMI_SUBTYPE);
 
 		/* HBA Identifier */
 		put_unaligned_be64(lport->wwpn, &ct->payload.rhba.hbaid.id);
@@ -333,7 +347,7 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 				   &entry->type);
 		put_unaligned_be16(len, &entry->len);
 		strncpy((char *)&entry->value,
-			fc_host_optionrom_version(lport->host),
+			"unknown",
 			FC_FDMI_HBA_ATTR_OPTIONROMVERSION_LEN);
 
 		/* Firmware Version */
@@ -361,6 +375,100 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 			"%s v%s",
 			init_utsname()->sysname,
 			init_utsname()->release);
+
+		/* Max CT payload */
+		entry = (struct fc_fdmi_attr_entry *)((char *)entry->value +
+					FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN);
+		len = FC_FDMI_ATTR_ENTRY_HEADER_LEN;
+		len += FC_FDMI_HBA_ATTR_MAXCTPAYLOAD_LEN;
+		put_unaligned_be16(FC_FDMI_HBA_ATTR_MAXCTPAYLOAD,
+				&entry->type);
+		put_unaligned_be16(len, &entry->len);
+		put_unaligned_be32(fc_host_max_ct_payload(lport->host),
+				&entry->value);
+
+		if (fc_host->fdmi_version == FDMI_V2) {
+			/* Node symbolic name */
+			entry = (struct fc_fdmi_attr_entry *)((char *)entry->value +
+				FC_FDMI_HBA_ATTR_MAXCTPAYLOAD_LEN);
+			len = FC_FDMI_ATTR_ENTRY_HEADER_LEN;
+			len += FC_FDMI_HBA_ATTR_NODESYMBLNAME_LEN;
+			put_unaligned_be16(FC_FDMI_HBA_ATTR_NODESYMBLNAME,
+				&entry->type);
+			put_unaligned_be16(len, &entry->len);
+			strncpy((char *)&entry->value,
+				fc_host_symbolic_name(lport->host),
+				FC_FDMI_HBA_ATTR_NODESYMBLNAME_LEN);
+
+			/* Vendor specific info */
+			entry = (struct fc_fdmi_attr_entry *)((char *)entry->value +
+					FC_FDMI_HBA_ATTR_NODESYMBLNAME_LEN);
+			len = FC_FDMI_ATTR_ENTRY_HEADER_LEN;
+			len += FC_FDMI_HBA_ATTR_VENDORSPECIFICINFO_LEN;
+			put_unaligned_be16(FC_FDMI_HBA_ATTR_VENDORSPECIFICINFO,
+				   &entry->type);
+			put_unaligned_be16(len, &entry->len);
+			put_unaligned_be32(fc_host_num_ports(lport->host),
+				   &entry->value);
+
+			/* Number of ports */
+			entry = (struct fc_fdmi_attr_entry *)((char *)entry->value +
+					FC_FDMI_HBA_ATTR_VENDORSPECIFICINFO_LEN);
+			len = FC_FDMI_ATTR_ENTRY_HEADER_LEN;
+			len += FC_FDMI_HBA_ATTR_NUMBEROFPORTS_LEN;
+			put_unaligned_be16(FC_FDMI_HBA_ATTR_NUMBEROFPORTS,
+				   &entry->type);
+			put_unaligned_be16(len, &entry->len);
+			put_unaligned_be32(fc_host_num_ports(lport->host),
+				   &entry->value);
+
+			/* Fabric name */
+			entry = (struct fc_fdmi_attr_entry *)((char *)entry->value +
+				FC_FDMI_HBA_ATTR_NUMBEROFPORTS_LEN);
+			len = FC_FDMI_ATTR_ENTRY_HEADER_LEN;
+			len += FC_FDMI_HBA_ATTR_FABRICNAME_LEN;
+			put_unaligned_be16(FC_FDMI_HBA_ATTR_FABRICNAME,
+				&entry->type);
+			put_unaligned_be16(len, &entry->len);
+			put_unaligned_be64(fc_host_fabric_name(lport->host),
+			   &entry->value);
+
+			/* BIOS version */
+			entry = (struct fc_fdmi_attr_entry *)((char *)entry->value +
+				FC_FDMI_HBA_ATTR_FABRICNAME_LEN);
+			len = FC_FDMI_ATTR_ENTRY_HEADER_LEN;
+			len += FC_FDMI_HBA_ATTR_BIOSVERSION_LEN;
+			put_unaligned_be16(FC_FDMI_HBA_ATTR_BIOSVERSION,
+				&entry->type);
+			put_unaligned_be16(len, &entry->len);
+				strncpy((char *)&entry->value,
+				fc_host_bootbios_version(lport->host),
+				FC_FDMI_HBA_ATTR_BIOSVERSION_LEN);
+
+			/* BIOS state */
+			entry = (struct fc_fdmi_attr_entry *)((char *)entry->value +
+					FC_FDMI_HBA_ATTR_BIOSVERSION_LEN);
+			len = FC_FDMI_ATTR_ENTRY_HEADER_LEN;
+			len += FC_FDMI_HBA_ATTR_BIOSSTATE_LEN;
+			put_unaligned_be16(FC_FDMI_HBA_ATTR_BIOSSTATE,
+				   &entry->type);
+			put_unaligned_be16(len, &entry->len);
+			put_unaligned_be32(fc_host_bootbios_state(lport->host),
+				   &entry->value);
+
+			/* Vendor identifier  */
+			entry = (struct fc_fdmi_attr_entry *)((char *)entry->value +
+				FC_FDMI_HBA_ATTR_BIOSSTATE_LEN);
+			len = FC_FDMI_ATTR_ENTRY_HEADER_LEN;
+			len += FC_FDMI_HBA_ATTR_VENDORIDENTIFIER_LEN;
+			put_unaligned_be16(FC_FDMI_HBA_ATTR_VENDORIDENTIFIER,
+				&entry->type);
+			put_unaligned_be16(len, &entry->len);
+			strncpy((char *)&entry->value,
+				fc_host_vendor_identifier(lport->host),
+				FC_FDMI_HBA_ATTR_VENDORIDENTIFIER_LEN);
+		}
+
 		break;
 	case FC_FDMI_RPA:
 		numattrs = 6;
@@ -373,6 +481,25 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 		len += FC_FDMI_PORT_ATTR_MAXFRAMESIZE_LEN;
 		len += FC_FDMI_PORT_ATTR_OSDEVICENAME_LEN;
 		len += FC_FDMI_PORT_ATTR_HOSTNAME_LEN;
+
+
+		if (fc_host->fdmi_version == FDMI_V2) {
+			numattrs += 10;
+
+			len += FC_FDMI_PORT_ATTR_NODENAME_LEN;
+			//Port name already added in RPA1
+			len += FC_FDMI_PORT_ATTR_PORTNAME_LEN;
+			len += FC_FDMI_PORT_ATTR_SYMBOLICNAME_LEN;
+			len += FC_FDMI_PORT_ATTR_PORTTYPE_LEN;
+			len += FC_FDMI_PORT_ATTR_SUPPORTEDCLASSSRVC_LEN;
+			len += FC_FDMI_PORT_ATTR_FABRICNAME_LEN;
+			len += FC_FDMI_PORT_ATTR_CURRENTFC4TYPE_LEN;
+			len += FC_FDMI_PORT_ATTR_PORTSTATE_LEN;
+			len += FC_FDMI_PORT_ATTR_DISCOVEREDPORTS_LEN;
+			len += FC_FDMI_PORT_ATTR_PORTID_LEN;
+
+		}
+
 		ct = fc_ct_hdr_fill(fp, op, len, FC_FST_MGMT,
 				    FC_FDMI_SUBTYPE);
 
@@ -461,6 +588,122 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 			strncpy((char *)&entry->value,
 				init_utsname()->nodename,
 				FC_FDMI_PORT_ATTR_HOSTNAME_LEN);
+
+
+		if (fc_host->fdmi_version == FDMI_V2) {
+
+			/* Node name */
+			entry = (struct fc_fdmi_attr_entry *)((char *)entry->value +
+					FC_FDMI_PORT_ATTR_HOSTNAME_LEN);
+			len = FC_FDMI_ATTR_ENTRY_HEADER_LEN;
+			len += FC_FDMI_PORT_ATTR_NODENAME_LEN;
+			put_unaligned_be16(FC_FDMI_PORT_ATTR_NODENAME,
+				   &entry->type);
+			put_unaligned_be16(len, &entry->len);
+			put_unaligned_be64(fc_host_node_name(lport->host),
+				   &entry->value);
+
+			/* Port name  */
+			entry = (struct fc_fdmi_attr_entry *)((char *)entry->value +
+					FC_FDMI_PORT_ATTR_NODENAME_LEN);
+			len = FC_FDMI_ATTR_ENTRY_HEADER_LEN;
+			len += FC_FDMI_PORT_ATTR_PORTNAME_LEN;
+			put_unaligned_be16(FC_FDMI_PORT_ATTR_PORTNAME,
+				   &entry->type);
+			put_unaligned_be16(len, &entry->len);
+			put_unaligned_be64(lport->wwpn,
+				   &entry->value);
+
+			/* Port symbolic name */
+			entry = (struct fc_fdmi_attr_entry *)((char *)entry->value +
+					FC_FDMI_PORT_ATTR_PORTNAME_LEN);
+			len = FC_FDMI_ATTR_ENTRY_HEADER_LEN;
+			len += FC_FDMI_PORT_ATTR_SYMBOLICNAME_LEN;
+			put_unaligned_be16(FC_FDMI_PORT_ATTR_SYMBOLICNAME,
+				   &entry->type);
+			put_unaligned_be16(len, &entry->len);
+			strncpy((char *)&entry->value,
+				fc_host_symbolic_name(lport->host),
+				FC_FDMI_PORT_ATTR_SYMBOLICNAME_LEN);
+
+			/* Port type */
+			entry = (struct fc_fdmi_attr_entry *)((char *)entry->value +
+					FC_FDMI_PORT_ATTR_SYMBOLICNAME_LEN);
+			len = FC_FDMI_ATTR_ENTRY_HEADER_LEN;
+			len += FC_FDMI_PORT_ATTR_PORTTYPE_LEN;
+			put_unaligned_be16(FC_FDMI_PORT_ATTR_PORTTYPE,
+				   &entry->type);
+			put_unaligned_be16(len, &entry->len);
+			put_unaligned_be32(fc_host_port_type(lport->host),
+				   &entry->value);
+
+			/* Supported class of service */
+			entry = (struct fc_fdmi_attr_entry *)((char *)entry->value +
+					FC_FDMI_PORT_ATTR_PORTTYPE_LEN);
+			len = FC_FDMI_ATTR_ENTRY_HEADER_LEN;
+			len += FC_FDMI_PORT_ATTR_SUPPORTEDCLASSSRVC_LEN;
+			put_unaligned_be16(FC_FDMI_PORT_ATTR_SUPPORTEDCLASSSRVC,
+				   &entry->type);
+			put_unaligned_be16(len, &entry->len);
+			put_unaligned_be32(fc_host_supported_classes(lport->host),
+				   &entry->value);
+
+			/* Port Fabric name */
+			entry = (struct fc_fdmi_attr_entry *)((char *)entry->value +
+					FC_FDMI_PORT_ATTR_SUPPORTEDCLASSSRVC_LEN);
+			len = FC_FDMI_ATTR_ENTRY_HEADER_LEN;
+			len += FC_FDMI_PORT_ATTR_FABRICNAME_LEN;
+			put_unaligned_be16(FC_FDMI_PORT_ATTR_FABRICNAME,
+				   &entry->type);
+			put_unaligned_be16(len, &entry->len);
+			put_unaligned_be64(fc_host_fabric_name(lport->host),
+				   &entry->value);
+
+			/* Port active FC-4 */
+			entry = (struct fc_fdmi_attr_entry *)((char *)entry->value +
+					FC_FDMI_PORT_ATTR_FABRICNAME_LEN);
+			len = FC_FDMI_ATTR_ENTRY_HEADER_LEN;
+			len += FC_FDMI_PORT_ATTR_CURRENTFC4TYPE_LEN;
+			put_unaligned_be16(FC_FDMI_PORT_ATTR_CURRENTFC4TYPE,
+				   &entry->type);
+			put_unaligned_be16(len, &entry->len);
+			memcpy(&entry->value, fc_host_active_fc4s(lport->host),
+		       FC_FDMI_PORT_ATTR_CURRENTFC4TYPE_LEN);
+
+			/* Port state */
+			entry = (struct fc_fdmi_attr_entry *)((char *)entry->value +
+					FC_FDMI_PORT_ATTR_CURRENTFC4TYPE_LEN);
+			len = FC_FDMI_ATTR_ENTRY_HEADER_LEN;
+			len += FC_FDMI_PORT_ATTR_PORTSTATE_LEN;
+			put_unaligned_be16(FC_FDMI_PORT_ATTR_PORTSTATE,
+				   &entry->type);
+			put_unaligned_be16(len, &entry->len);
+			put_unaligned_be32(fc_host_port_state(lport->host),
+				   &entry->value);
+
+			/* Discovered ports */
+			entry = (struct fc_fdmi_attr_entry *)((char *)entry->value +
+					FC_FDMI_PORT_ATTR_PORTSTATE_LEN);
+			len = FC_FDMI_ATTR_ENTRY_HEADER_LEN;
+			len += FC_FDMI_PORT_ATTR_DISCOVEREDPORTS_LEN;
+			put_unaligned_be16(FC_FDMI_PORT_ATTR_DISCOVEREDPORTS,
+				   &entry->type);
+			put_unaligned_be16(len, &entry->len);
+			put_unaligned_be32(fc_host_num_discovered_ports(lport->host),
+				   &entry->value);
+
+			/* Port ID */
+			entry = (struct fc_fdmi_attr_entry *)((char *)entry->value +
+					FC_FDMI_PORT_ATTR_DISCOVEREDPORTS_LEN);
+			len = FC_FDMI_ATTR_ENTRY_HEADER_LEN;
+			len += FC_FDMI_PORT_ATTR_PORTID_LEN;
+			put_unaligned_be16(FC_FDMI_PORT_ATTR_PORTID,
+				   &entry->type);
+			put_unaligned_be16(len, &entry->len);
+			put_unaligned_be32(fc_host_port_id(lport->host),
+				   &entry->value);
+		}
+
 		break;
 	case FC_FDMI_DPRT:
 		len = sizeof(struct fc_fdmi_dprt);
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 1c7dd35cb7a0..d718a54bb0fb 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -482,10 +482,11 @@ enum fc_host_event_code  {
  * managed by the transport w/o driver interaction.
  */
 
+#define FC_VENDOR_IDENTIFIER	8
 #define FC_FC4_LIST_SIZE		32
 #define FC_SYMBOLIC_NAME_SIZE		256
 #define FC_VERSION_STRING_SIZE		64
-#define FC_SERIAL_NUMBER_SIZE		80
+#define FC_SERIAL_NUMBER_SIZE		64
 
 struct fc_host_attrs {
 	/* Fixed Attributes */
@@ -497,6 +498,10 @@ struct fc_host_attrs {
 	u32 supported_speeds;
 	u32 maxframe_size;
 	u16 max_npiv_vports;
+	u32 max_ct_payload;
+	u32 num_ports;
+	u32 num_discovered_ports;
+	u32 bootbios_state;
 	char serial_number[FC_SERIAL_NUMBER_SIZE];
 	char manufacturer[FC_SERIAL_NUMBER_SIZE];
 	char model[FC_SYMBOLIC_NAME_SIZE];
@@ -505,6 +510,9 @@ struct fc_host_attrs {
 	char driver_version[FC_VERSION_STRING_SIZE];
 	char firmware_version[FC_VERSION_STRING_SIZE];
 	char optionrom_version[FC_VERSION_STRING_SIZE];
+	char vendor_identifier[FC_VENDOR_IDENTIFIER];
+	char bootbios_version[FC_SYMBOLIC_NAME_SIZE];
+
 
 	/* Dynamic Attributes */
 	u32 port_id;
@@ -537,6 +545,9 @@ struct fc_host_attrs {
 
 	/* bsg support */
 	struct request_queue *rqst_q;
+
+	/* FDMI support version*/
+	u8 fdmi_version;
 };
 
 #define shost_to_fc_host(x) \
@@ -616,6 +627,18 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->devloss_work_q)
 #define fc_host_dev_loss_tmo(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->dev_loss_tmo)
+#define fc_host_max_ct_payload(x)  \
+	(((struct fc_host_attrs *)(x)->shost_data)->max_ct_payload)
+#define fc_host_vendor_identifier(x)  \
+	(((struct fc_host_attrs *)(x)->shost_data)->vendor_identifier)
+#define fc_host_num_discovered_ports(x)  \
+	(((struct fc_host_attrs *)(x)->shost_data)->num_discovered_ports)
+#define fc_host_num_ports(x)  \
+	(((struct fc_host_attrs *)(x)->shost_data)->num_ports)
+#define fc_host_bootbios_version(x)  \
+	(((struct fc_host_attrs *)(x)->shost_data)->bootbios_version)
+#define fc_host_bootbios_state(x)  \
+	(((struct fc_host_attrs *)(x)->shost_data)->bootbios_state)
 
 /* The functions by which the transport class and the driver communicate */
 struct fc_function_template {
-- 
2.18.2

