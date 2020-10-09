Return-Path: <SRS0=VN9r=DQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E56D1C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 09:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 804B92225D
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 09:38:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ehxQn99e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733113AbgJIJiN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Oct 2020 05:38:13 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6276 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733101AbgJIJiM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2020 05:38:12 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0999Oc2d015655
        for <linux-scsi@vger.kernel.org>; Fri, 9 Oct 2020 02:38:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=cQBdxQJStHqjru4l8pqTeXBb8mlByaUrYricZZ3gM98=;
 b=ehxQn99ewvR1P8aRTgUmT9YCbrY42HayJ6uSOYdKnRhSWrtrqe5+jFVY/3VmejelDUvk
 haKIWaHQOMJxu/0udx1byGtpqPd/30hmsHVdB9piBDFFZiqCXUcGPQOeQQFwTufDntNo
 HrkV/0yLbS1QRRTcT8nYNGKOu9sc8Cu0u1E4cGyrPqKLRReJDUWyHaWk7jgrCG5+Ka3J
 LS+fIGs80J+gySwpUe45wd1/srS5OzmZN6gmP5WdVdHHK8v5Indw7XcOo2HFm4WajLjX
 3skb3KUTIO3sq5pxsPbvhULkeC5YIw92knFyJT85OWHqkGWSkSX25izGwKfO/cseTRz0 LA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3429hh247t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2020 02:38:11 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 02:38:09 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 02:38:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Oct 2020 02:38:08 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 56A853F703F;
        Fri,  9 Oct 2020 02:38:08 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0999c8I5004246;
        Fri, 9 Oct 2020 02:38:08 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0999c8ZW004237;
        Fri, 9 Oct 2020 02:38:08 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 3/4] scsi:libfc: FDMI enhancement.
Date:   Fri, 9 Oct 2020 02:36:30 -0700
Message-ID: <20201009093631.4182-4-jhasan@marvell.com>
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

Added all the attributes for RHBA and RPA registration.
Fall back mechanism is added in between RBHA V2 and
RHBA V1 attributes. In case RHBA get failed
for RBHA V2 attributes, then we fall back to  RHBA V1
attributes registration.

Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/libfc/fc_lport.c | 64 +++++++++++++++++++++++++++++++----
 1 file changed, 58 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index b84dbc316df1..9b32930b5c67 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1185,7 +1185,7 @@ static void fc_lport_ms_resp(struct fc_seq *sp, struct fc_frame *fp,
 	struct fc_lport *lport = lp_arg;
 	struct fc_frame_header *fh;
 	struct fc_ct_hdr *ct;
-
+	struct fc_host_attrs *fc_host = shost_to_fc_host(lport->host);
 	FC_LPORT_DBG(lport, "Received a ms %s\n", fc_els_resp_type(fp));
 
 	if (fp == ERR_PTR(-FC_EX_CLOSED))
@@ -1219,7 +1219,13 @@ static void fc_lport_ms_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 		switch (lport->state) {
 		case LPORT_ST_RHBA:
-			if (ntohs(ct->ct_cmd) == FC_FS_ACC)
+			if ((ntohs(ct->ct_cmd) == FC_FS_RJT) && fc_host->fdmi_version == FDMI_V2) {
+				FC_LPORT_DBG(lport, "Error for FDMI-V2, fall back to FDMI-V1\n");
+				fc_host->fdmi_version = FDMI_V1;
+
+				fc_lport_enter_ms(lport, LPORT_ST_RHBA);
+
+			} else if (ntohs(ct->ct_cmd) == FC_FS_ACC)
 				fc_lport_enter_ms(lport, LPORT_ST_RPA);
 			else /* Error Skip RPA */
 				fc_lport_enter_scr(lport);
@@ -1433,7 +1439,7 @@ static void fc_lport_enter_ms(struct fc_lport *lport, enum fc_lport_state state)
 	int size = sizeof(struct fc_ct_hdr);
 	size_t len;
 	int numattrs;
-
+	struct fc_host_attrs *fc_host = shost_to_fc_host(lport->host);
 	lockdep_assert_held(&lport->lp_mutex);
 
 	FC_LPORT_DBG(lport, "Entered %s state from %s state\n",
@@ -1446,10 +1452,10 @@ static void fc_lport_enter_ms(struct fc_lport *lport, enum fc_lport_state state)
 	case LPORT_ST_RHBA:
 		cmd = FC_FDMI_RHBA;
 		/* Number of HBA Attributes */
-		numattrs = 10;
+		numattrs = 11;
 		len = sizeof(struct fc_fdmi_rhba);
 		len -= sizeof(struct fc_fdmi_attr_entry);
-		len += (numattrs * FC_FDMI_ATTR_ENTRY_HEADER_LEN);
+
 		len += FC_FDMI_HBA_ATTR_NODENAME_LEN;
 		len += FC_FDMI_HBA_ATTR_MANUFACTURER_LEN;
 		len += FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN;
@@ -1460,6 +1466,21 @@ static void fc_lport_enter_ms(struct fc_lport *lport, enum fc_lport_state state)
 		len += FC_FDMI_HBA_ATTR_OPTIONROMVERSION_LEN;
 		len += FC_FDMI_HBA_ATTR_FIRMWAREVERSION_LEN;
 		len += FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN;
+		len += FC_FDMI_HBA_ATTR_MAXCTPAYLOAD_LEN;
+
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
+		len += (numattrs * FC_FDMI_ATTR_ENTRY_HEADER_LEN);
 
 		size += len;
 		break;
@@ -1469,7 +1490,6 @@ static void fc_lport_enter_ms(struct fc_lport *lport, enum fc_lport_state state)
 		numattrs = 6;
 		len = sizeof(struct fc_fdmi_rpa);
 		len -= sizeof(struct fc_fdmi_attr_entry);
-		len += (numattrs * FC_FDMI_ATTR_ENTRY_HEADER_LEN);
 		len += FC_FDMI_PORT_ATTR_FC4TYPES_LEN;
 		len += FC_FDMI_PORT_ATTR_SUPPORTEDSPEED_LEN;
 		len += FC_FDMI_PORT_ATTR_CURRENTPORTSPEED_LEN;
@@ -1477,6 +1497,22 @@ static void fc_lport_enter_ms(struct fc_lport *lport, enum fc_lport_state state)
 		len += FC_FDMI_PORT_ATTR_OSDEVICENAME_LEN;
 		len += FC_FDMI_PORT_ATTR_HOSTNAME_LEN;
 
+		if (fc_host->fdmi_version == FDMI_V2) {
+			numattrs += 10;
+			len += FC_FDMI_PORT_ATTR_NODENAME_LEN;
+			len += FC_FDMI_PORT_ATTR_PORTNAME_LEN;
+			len += FC_FDMI_PORT_ATTR_SYMBOLICNAME_LEN;
+			len += FC_FDMI_PORT_ATTR_PORTTYPE_LEN;
+			len += FC_FDMI_PORT_ATTR_SUPPORTEDCLASSSRVC_LEN;
+			len += FC_FDMI_PORT_ATTR_FABRICNAME_LEN;
+			len += FC_FDMI_PORT_ATTR_CURRENTFC4TYPE_LEN;
+			len += FC_FDMI_PORT_ATTR_PORTSTATE_LEN;
+			len += FC_FDMI_PORT_ATTR_DISCOVEREDPORTS_LEN;
+			len += FC_FDMI_PORT_ATTR_PORTID_LEN;
+		}
+
+		len += (numattrs * FC_FDMI_ATTR_ENTRY_HEADER_LEN);
+
 		size += len;
 		break;
 	case LPORT_ST_DPRT:
@@ -1546,6 +1582,7 @@ static void fc_lport_timeout(struct work_struct *work)
 	struct fc_lport *lport =
 		container_of(work, struct fc_lport,
 			     retry_work.work);
+	struct fc_host_attrs *fc_host = shost_to_fc_host(lport->host);
 
 	mutex_lock(&lport->lp_mutex);
 
@@ -1573,6 +1610,13 @@ static void fc_lport_timeout(struct work_struct *work)
 		fc_lport_enter_fdmi(lport);
 		break;
 	case LPORT_ST_RHBA:
+		if (fc_host->fdmi_version == FDMI_V2) {
+			FC_LPORT_DBG(lport, "timeout for FDMI-V2 RHBA,fall back to FDMI-V1\n");
+			fc_host->fdmi_version = FDMI_V1;
+			fc_lport_enter_ms(lport, LPORT_ST_RHBA);
+			break;
+		}
+		fallthrough;
 	case LPORT_ST_RPA:
 	case LPORT_ST_DHBA:
 	case LPORT_ST_DPRT:
@@ -1839,6 +1883,13 @@ EXPORT_SYMBOL(fc_lport_config);
  */
 int fc_lport_init(struct fc_lport *lport)
 {
+	struct fc_host_attrs *fc_host;
+
+	fc_host = shost_to_fc_host(lport->host);
+
+	/* Set FDMI version to FDMI-2 specification*/
+	fc_host->fdmi_version = FDMI_V2;
+
 	fc_host_port_type(lport->host) = FC_PORTTYPE_NPORT;
 	fc_host_node_name(lport->host) = lport->wwnn;
 	fc_host_port_name(lport->host) = lport->wwpn;
@@ -1847,6 +1898,7 @@ int fc_lport_init(struct fc_lport *lport)
 	       sizeof(fc_host_supported_fc4s(lport->host)));
 	fc_host_supported_fc4s(lport->host)[2] = 1;
 	fc_host_supported_fc4s(lport->host)[7] = 1;
+	fc_host_num_discovered_ports(lport->host) = 4;
 
 	/* This value is also unchanging */
 	memset(fc_host_active_fc4s(lport->host), 0,
-- 
2.18.2

