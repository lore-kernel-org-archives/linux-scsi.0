Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E4FC47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 12:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCC78610A1
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 12:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhFCMUe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:20:34 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:13426 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229765AbhFCMUe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 08:20:34 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 153CAO7M011040
        for <linux-scsi@vger.kernel.org>; Thu, 3 Jun 2021 05:18:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=Q9U88xC49m5YWxGPIUgLDyr6ZS/eDaNiREhQ9H1KR/g=;
 b=co7RFv9PBdeBdRPhdNuA8gjghHEe/YKw8RXYk8d+QX4t8pzcdysRysZiHcq0hl8C4PA6
 st8gL/D2wKPjgu+NFrjOvVkBrMzzer4shEslqqdPJC9PqxbYpx2zwjOTNl/qjtO7fvaW
 TtU4Ap7MdkI2G/jLPQqb4Xiz0WAfgbZ4DAORIAnVQpikDKsCsjxQiLvSwngtbLfct1c7
 s8SgBXBxAUDkBvprNnHgP2yft1/Uf+iHeZeClduz5ZVHto8LrENCfPw6biGsnuGAkwPu
 ZUmgEZLdjl4PqoEtGS4z92WfS0kBIxs502ZRXew3nd078FuuPZc8kdFpwHXYJwiSpmOl uA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 38xe7xuhfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jun 2021 05:18:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 05:18:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 05:18:48 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 96B133F703F;
        Thu,  3 Jun 2021 05:18:48 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 153CImFk010156;
        Thu, 3 Jun 2021 05:18:48 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 153CImDo010155;
        Thu, 3 Jun 2021 05:18:48 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 5/5] fc: FDMI enhancement
Date:   Thu, 3 Jun 2021 05:16:23 -0700
Message-ID: <20210603121623.10084-6-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210603121623.10084-1-jhasan@marvell.com>
References: <20210603121623.10084-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: x3xiDx5xf2t3eY0r1fR7fAz7QztsTcaO
X-Proofpoint-GUID: x3xiDx5xf2t3eY0r1fR7fAz7QztsTcaO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-03_08:2021-06-02,2021-06-03 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Added RHBA and RPA attributes type and length.
As par FC_GC_7 document section "Table 400 – Attribute Entry Types and associated Values"
ascii type attributes length can be vary from "4 to 256 byte".
If we keep all RHBA ascii attributes length 256 then total length is 
going upto 2750, which is far more than 2048 (max frame size).

In libfc we do have logic to split FCP commands but not for CT commands.
Practically all version/names get covered with in 64 bytes except OS 
name, for that we need 128 bytes.
Hence length of all RBHA ascii attributes length reduced to 64 bytes
and 128 bytes in case OS name.

RPA attributes total length is with in frame size.

Signed-off-by: Javed Hasan <jhasan@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 include/scsi/fc/fc_ms.h | 55 +++++++++++++++++++++++++++++++++++------
 1 file changed, 48 insertions(+), 7 deletions(-)

diff --git a/include/scsi/fc/fc_ms.h b/include/scsi/fc/fc_ms.h
index 800d53dc9470..00191695233a 100644
--- a/include/scsi/fc/fc_ms.h
+++ b/include/scsi/fc/fc_ms.h
@@ -24,6 +24,12 @@
  */
 #define	FC_FDMI_SUBTYPE	    0x10 /* fs_ct_hdr.ct_fs_subtype */
 
+/*
+ * Management server FDMI specifications.
+ */
+#define	FDMI_V1	    1 /* FDMI version 1 specifications */
+#define	FDMI_V2	    2 /* FDMI version 2 specifications */
+
 /*
  * Management server FDMI Requests.
  */
@@ -57,6 +63,13 @@ enum fc_fdmi_hba_attr_type {
 	FC_FDMI_HBA_ATTR_FIRMWAREVERSION = 0x0009,
 	FC_FDMI_HBA_ATTR_OSNAMEVERSION = 0x000A,
 	FC_FDMI_HBA_ATTR_MAXCTPAYLOAD = 0x000B,
+	FC_FDMI_HBA_ATTR_NODESYMBLNAME = 0x000C,
+	FC_FDMI_HBA_ATTR_VENDORSPECIFICINFO = 0x000D,
+	FC_FDMI_HBA_ATTR_NUMBEROFPORTS = 0x000E,
+	FC_FDMI_HBA_ATTR_FABRICNAME = 0x000F,
+	FC_FDMI_HBA_ATTR_BIOSVERSION = 0x0010,
+	FC_FDMI_HBA_ATTR_BIOSSTATE = 0x0011,
+	FC_FDMI_HBA_ATTR_VENDORIDENTIFIER = 0x00E0,
 };
 
 /*
@@ -65,14 +78,21 @@ enum fc_fdmi_hba_attr_type {
 #define FC_FDMI_HBA_ATTR_NODENAME_LEN		8
 #define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN	64
 #define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN	64
-#define FC_FDMI_HBA_ATTR_MODEL_LEN		256
-#define FC_FDMI_HBA_ATTR_MODELDESCR_LEN		256
-#define FC_FDMI_HBA_ATTR_HARDWAREVERSION_LEN	256
-#define FC_FDMI_HBA_ATTR_DRIVERVERSION_LEN	256
-#define FC_FDMI_HBA_ATTR_OPTIONROMVERSION_LEN	256
-#define FC_FDMI_HBA_ATTR_FIRMWAREVERSION_LEN	256
-#define FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN	256
+#define FC_FDMI_HBA_ATTR_MODEL_LEN		64
+#define FC_FDMI_HBA_ATTR_MODELDESCR_LEN		64
+#define FC_FDMI_HBA_ATTR_HARDWAREVERSION_LEN	64
+#define FC_FDMI_HBA_ATTR_DRIVERVERSION_LEN	64
+#define FC_FDMI_HBA_ATTR_OPTIONROMVERSION_LEN	64
+#define FC_FDMI_HBA_ATTR_FIRMWAREVERSION_LEN	64
+#define FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN	128
 #define FC_FDMI_HBA_ATTR_MAXCTPAYLOAD_LEN	4
+#define FC_FDMI_HBA_ATTR_NODESYMBLNAME_LEN	64
+#define FC_FDMI_HBA_ATTR_VENDORSPECIFICINFO_LEN	4
+#define FC_FDMI_HBA_ATTR_NUMBEROFPORTS_LEN	4
+#define FC_FDMI_HBA_ATTR_FABRICNAME_LEN	8
+#define FC_FDMI_HBA_ATTR_BIOSVERSION_LEN	64
+#define FC_FDMI_HBA_ATTR_BIOSSTATE_LEN    4
+#define FC_FDMI_HBA_ATTR_VENDORIDENTIFIER_LEN 8
 
 /*
  * Port Attribute Type
@@ -84,6 +104,16 @@ enum fc_fdmi_port_attr_type {
 	FC_FDMI_PORT_ATTR_MAXFRAMESIZE = 0x0004,
 	FC_FDMI_PORT_ATTR_OSDEVICENAME = 0x0005,
 	FC_FDMI_PORT_ATTR_HOSTNAME = 0x0006,
+	FC_FDMI_PORT_ATTR_NODENAME = 0x0007,
+	FC_FDMI_PORT_ATTR_PORTNAME = 0x0008,
+	FC_FDMI_PORT_ATTR_SYMBOLICNAME = 0x0009,
+	FC_FDMI_PORT_ATTR_PORTTYPE = 0x000A,
+	FC_FDMI_PORT_ATTR_SUPPORTEDCLASSSRVC = 0x000B,
+	FC_FDMI_PORT_ATTR_FABRICNAME = 0x000C,
+	FC_FDMI_PORT_ATTR_CURRENTFC4TYPE = 0x000D,
+	FC_FDMI_PORT_ATTR_PORTSTATE = 0x101,
+	FC_FDMI_PORT_ATTR_DISCOVEREDPORTS = 0x102,
+	FC_FDMI_PORT_ATTR_PORTID = 0x103,
 };
 
 /*
@@ -95,6 +125,17 @@ enum fc_fdmi_port_attr_type {
 #define FC_FDMI_PORT_ATTR_MAXFRAMESIZE_LEN	4
 #define FC_FDMI_PORT_ATTR_OSDEVICENAME_LEN	256
 #define FC_FDMI_PORT_ATTR_HOSTNAME_LEN		256
+#define FC_FDMI_PORT_ATTR_NODENAME_LEN		8
+#define FC_FDMI_PORT_ATTR_PORTNAME_LEN		8
+#define FC_FDMI_PORT_ATTR_SYMBOLICNAME_LEN	256
+#define FC_FDMI_PORT_ATTR_PORTTYPE_LEN		4
+#define FC_FDMI_PORT_ATTR_SUPPORTEDCLASSSRVC_LEN	4
+#define FC_FDMI_PORT_ATTR_FABRICNAME_LEN	8
+#define FC_FDMI_PORT_ATTR_CURRENTFC4TYPE_LEN	32
+#define FC_FDMI_PORT_ATTR_PORTSTATE_LEN		4
+#define FC_FDMI_PORT_ATTR_DISCOVEREDPORTS_LEN	4
+#define FC_FDMI_PORT_ATTR_PORTID_LEN		4
+
 
 /*
  * HBA Attribute ID
-- 
2.26.2

