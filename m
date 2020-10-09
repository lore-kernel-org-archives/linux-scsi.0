Return-Path: <SRS0=VN9r=DQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C9F1C433E7
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 09:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC5CD2225A
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 09:37:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QZyfd6+A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733113AbgJIJhs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Oct 2020 05:37:48 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37102 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733111AbgJIJhs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2020 05:37:48 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0999OW5h015636
        for <linux-scsi@vger.kernel.org>; Fri, 9 Oct 2020 02:37:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Ocz/JBoLt+YV/H2/Lco47BsE2GaPpy2sUspWJHB9Ipk=;
 b=QZyfd6+AN8ZjF191nxWJEo9NUBDQatDSJQC8gzUVFrG5UUU/kELwnN9wTFjVPJAGSQCl
 RC+ZLmELRMeeJL1Yo9o/SMyQHNmqKKKqaV2dq6nBJKFh5jct412MYs4acXsrx8kp7U6h
 X59iXxxu1r3Es8zGUDnRO6UdukwJUTDHSPD1+6yZqmONAneJwOoFDND3JPvmFGboQTM2
 iiUtTuBl/kxT6vHUqVBHiJlAJ48xkBc+S02T0iR3YimW5wB1nGZteSW35jvc1kOSRVSP
 2WWpmVgX32LPLkL90PBqLk2GB0uOeh2gtrDSDO9MI+0liXCW9GoPBt9C2GGECbqDhQ8p zQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 3429hh2472-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2020 02:37:46 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 02:37:45 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 02:37:44 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Oct 2020 02:37:44 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3674E3F703F;
        Fri,  9 Oct 2020 02:37:44 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0999bigT004234;
        Fri, 9 Oct 2020 02:37:44 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0999biAX004233;
        Fri, 9 Oct 2020 02:37:44 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 2/4] include:scsi:fc: FDMI enhancement
Date:   Fri, 9 Oct 2020 02:36:29 -0700
Message-ID: <20201009093631.4182-3-jhasan@marvell.com>
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
 include/scsi/fc/fc_ms.h | 59 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 9 deletions(-)

diff --git a/include/scsi/fc/fc_ms.h b/include/scsi/fc/fc_ms.h
index 9e273fed0a85..abbd6bacc888 100644
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
@@ -57,22 +63,36 @@ enum fc_fdmi_hba_attr_type {
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
  * HBA Attribute Length
  */
 #define FC_FDMI_HBA_ATTR_NODENAME_LEN		8
-#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN	80
-#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN	80
-#define FC_FDMI_HBA_ATTR_MODEL_LEN		256
-#define FC_FDMI_HBA_ATTR_MODELDESCR_LEN		256
-#define FC_FDMI_HBA_ATTR_HARDWAREVERSION_LEN	256
-#define FC_FDMI_HBA_ATTR_DRIVERVERSION_LEN	256
-#define FC_FDMI_HBA_ATTR_OPTIONROMVERSION_LEN	256
-#define FC_FDMI_HBA_ATTR_FIRMWAREVERSION_LEN	256
-#define FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN	256
+#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN	64
+#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN	64
+#define FC_FDMI_HBA_ATTR_MODEL_LEN		100
+#define FC_FDMI_HBA_ATTR_MODELDESCR_LEN		100
+#define FC_FDMI_HBA_ATTR_HARDWAREVERSION_LEN	100
+#define FC_FDMI_HBA_ATTR_DRIVERVERSION_LEN	100
+#define FC_FDMI_HBA_ATTR_OPTIONROMVERSION_LEN	100
+#define FC_FDMI_HBA_ATTR_FIRMWAREVERSION_LEN	100
+#define FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN	100
 #define FC_FDMI_HBA_ATTR_MAXCTPAYLOAD_LEN	4
+#define FC_FDMI_HBA_ATTR_NODESYMBLNAME_LEN	100
+#define FC_FDMI_HBA_ATTR_VENDORSPECIFICINFO_LEN	4
+#define FC_FDMI_HBA_ATTR_NUMBEROFPORTS_LEN	4
+#define FC_FDMI_HBA_ATTR_FABRICNAME_LEN	8
+#define FC_FDMI_HBA_ATTR_BIOSVERSION_LEN	100
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
2.18.2

