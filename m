Return-Path: <SRS0=xWhZ=DN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB3DC41604
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 06:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC81420797
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 06:17:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="JvnKUbpN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgJFGRH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 02:17:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44980 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726118AbgJFGRH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 02:17:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09665U1f003207
        for <linux-scsi@vger.kernel.org>; Mon, 5 Oct 2020 23:17:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=m+vgW4jQUgwDS0hi2BSKriq2kRjK89Ox+0hJp0DHLHo=;
 b=JvnKUbpNhVFw7nQBsk+1jeG5+b+iLFEjv9pFayV6d29aq3F+zIZQSQLG6SX1o5AEZcbS
 L5/Nox6+mmt8jAjcG0vBRCsohbyYD7I50c4lTdpIArxaDoXR6kBLbYG9dWskMIAldBj7
 0dqRj5JEbUGcLwWSaouN0Ob3il+wKhbrTJVlr70Ivn10JIJvanq/Lp56TQXung2KpAXS
 gbf98q1kfVix9C4vA3S1dlT3+YFIvm4Gh1wkCnuxVBky25gU7TiMgIm6w84nIWst4Fqd
 QMsJ8dGtzblYCW3NK4fv554H8BJNNM/3OPziCaKnsHNs9ejZ1Brp1v01DE5yTAlhP3EV Ag== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 33xrtnfcp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 05 Oct 2020 23:17:05 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 5 Oct
 2020 23:17:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 5 Oct 2020 23:17:04 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 15ED43F7041;
        Mon,  5 Oct 2020 23:17:04 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0966H3fk028721;
        Mon, 5 Oct 2020 23:17:03 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0966H3qf028720;
        Mon, 5 Oct 2020 23:17:03 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 1/5] scsi: fc: Update formal FPIN descriptor definitions
Date:   Mon, 5 Oct 2020 23:16:11 -0700
Message-ID: <20201006061615.28674-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201006061615.28674-1-njavali@marvell.com>
References: <20201006061615.28674-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-06_02:2020-10-06,2020-10-06 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shyam Sundar <ssundar@marvell.com>

Add Fabric Performance Impact Notification (FPIN) descriptor definition
for the following FPINs:
Delivery Notification Descriptor
Peer Congestion Notification Descriptor
Congestion Notification Descriptor

Signed-off-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 include/uapi/scsi/fc/fc_els.h | 114 +++++++++++++++++++++++++++++++++-
 1 file changed, 113 insertions(+), 1 deletion(-)

diff --git a/include/uapi/scsi/fc/fc_els.h b/include/uapi/scsi/fc/fc_els.h
index 8c704e510e39..91d4be987220 100644
--- a/include/uapi/scsi/fc/fc_els.h
+++ b/include/uapi/scsi/fc/fc_els.h
@@ -916,7 +916,9 @@ enum fc_els_clid_ic {
 	ELS_CLID_IC_LIP =	8,	/* receiving LIP */
 };
 
-
+/*
+ * Link Integrity event types
+ */
 enum fc_fpin_li_event_types {
 	FPIN_LI_UNKNOWN =		0x0,
 	FPIN_LI_LINK_FAILURE =		0x1,
@@ -943,6 +945,54 @@ enum fc_fpin_li_event_types {
 	{ FPIN_LI_DEVICE_SPEC,		"Device Specific" },		\
 }
 
+/*
+ * Delivery event types
+ */
+enum fc_fpin_deli_event_types {
+	FPIN_DELI_UNKNOWN =		0x0,
+	FPIN_DELI_TIMEOUT =		0x1,
+	FPIN_DELI_UNABLE_TO_ROUTE =	0x2,
+	FPIN_DELI_DEVICE_SPEC =		0xF,
+};
+
+/*
+ * Initializer useful for decoding table.
+ * Please keep this in sync with the above definitions.
+ */
+#define FC_FPIN_DELI_EVT_TYPES_INIT {					\
+	{ FPIN_DELI_UNKNOWN,		"Unknown" },			\
+	{ FPIN_DELI_TIMEOUT,		"Timeout" },			\
+	{ FPIN_DELI_UNABLE_TO_ROUTE,	"Unable to Route" },		\
+	{ FPIN_DELI_DEVICE_SPEC,	"Device Specific" },		\
+}
+
+/*
+ * Congestion event types
+ */
+enum fc_fpin_congn_event_types {
+	FPIN_CONGN_CLEAR =		0x0,
+	FPIN_CONGN_LOST_CREDIT =	0x1,
+	FPIN_CONGN_CREDIT_STALL =	0x2,
+	FPIN_CONGN_OVERSUBSCRIPTION =	0x3,
+	FPIN_CONGN_DEVICE_SPEC =	0xF,
+};
+
+/*
+ * Initializer useful for decoding table.
+ * Please keep this in sync with the above definitions.
+ */
+#define FC_FPIN_CONGN_EVT_TYPES_INIT {					\
+	{ FPIN_CONGN_CLEAR,		"Clear" },			\
+	{ FPIN_CONGN_LOST_CREDIT,	"Lost Credit" },		\
+	{ FPIN_CONGN_CREDIT_STALL,	"Credit Stall" },		\
+	{ FPIN_CONGN_OVERSUBSCRIPTION,	"Oversubscription" },		\
+	{ FPIN_CONGN_DEVICE_SPEC,	"Device Specific" },		\
+}
+
+enum fc_fpin_congn_severity_types {
+	FPIN_CONGN_SEVERITY_WARNING =	0xF1,
+	FPIN_CONGN_SEVERITY_ERROR =	0xF7,
+};
 
 /*
  * Link Integrity Notification Descriptor
@@ -974,6 +1024,68 @@ struct fc_fn_li_desc {
 					 */
 };
 
+/*
+ * Delivery Notification Descriptor
+ */
+struct fc_fn_deli_desc {
+	__be32		desc_tag;	/* Descriptor Tag (0x00020002) */
+	__be32		desc_len;	/* Length of Descriptor (in bytes).
+					 * Size of descriptor excluding
+					 * desc_tag and desc_len fields.
+					 */
+	__be64		detecting_wwpn;	/* Port Name that detected event */
+	__be64		attached_wwpn;	/* Port Name of device attached to
+					 * detecting Port Name
+					 */
+	__be32		deli_reason_code;/* see enum fc_fpin_deli_event_types */
+};
+
+/*
+ * Peer Congestion Notification Descriptor
+ */
+struct fc_fn_peer_congn_desc {
+	__be32		desc_tag;	/* Descriptor Tag (0x00020003) */
+	__be32		desc_len;	/* Length of Descriptor (in bytes).
+					 * Size of descriptor excluding
+					 * desc_tag and desc_len fields.
+					 */
+	__be64		detecting_wwpn;	/* Port Name that detected event */
+	__be64		attached_wwpn;	/* Port Name of device attached to
+					 * detecting Port Name
+					 */
+	__be16		event_type;	/* see enum fc_fpin_congn_event_types */
+	__be16		event_modifier;	/* Implementation specific value
+					 * describing the event type
+					 */
+	__be32		event_period;	/* duration (ms) of the detected
+					 * congestion event
+					 */
+	__be32		pname_count;	/* number of portname_list elements */
+	__be64		pname_list[0];	/* list of N_Port_Names accessible
+					 * through the attached port
+					 */
+};
+
+/*
+ * Congestion Notification Descriptor
+ */
+struct fc_fn_congn_desc {
+	__be32		desc_tag;	/* Descriptor Tag (0x00020004) */
+	__be32		desc_len;	/* Length of Descriptor (in bytes).
+					 * Size of descriptor excluding
+					 * desc_tag and desc_len fields.
+					 */
+	__be16		event_type;	/* see enum fc_fpin_congn_event_types */
+	__be16		event_modifier;	/* Implementation specific value
+					 * describing the event type
+					 */
+	__be32		event_period;	/* duration (ms) of the detected
+					 * congestion event
+					 */
+	__u8		severity;	/* command */
+	__u8		resv[3];	/* reserved - must be zero */
+};
+
 /*
  * ELS_FPIN - Fabric Performance Impact Notification
  */
-- 
2.19.0.rc0

