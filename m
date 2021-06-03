Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC98C47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 09:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A71C7613EE
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 09:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhFCKAw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 06:00:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:64632 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229922AbhFCJ7L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 05:59:11 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1539oWHT001485
        for <linux-scsi@vger.kernel.org>; Thu, 3 Jun 2021 02:57:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=DiAqF89WnpSNLX8tWTnJQ3ZcqvEIryaGLqy91hw1FJI=;
 b=coBkfQr8HP3bWtkeKHUBuenS2/MgINlCH+d5XxKtQOwwDaJb+7obY0Dx9yETcer4TZNH
 tzG35FMIeC3ZS3cVxxrEuYAsdiev8kvMLHCH78Ynl8bYcELu91aWvwQ+rQXqa2/fKWHR
 +yNMlHViAz8DRyC0Ht+i9ZX5s+LwSEpj5GbzCS3VzlPgdHW0SvMfB5A6daEWhl2I9Sc7
 YHmYyDMLY1MVAciq9g6VkV3MPwAhlqzIXn95IR1WW+MOKVNK+uYEi3p4M7ybnSCTun2o
 nD9T8TLKuFyld7CNOILdtnsYNryquZGOsaBfxWAyBVWNMrQQ8uYKQ75fkIrGoWzkEFsQ 3Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 38xe7xu4qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jun 2021 02:57:27 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 02:57:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 02:57:25 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B7A243F703F;
        Thu,  3 Jun 2021 02:57:25 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1539vPdj007366;
        Thu, 3 Jun 2021 02:57:25 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1539vPYT007365;
        Thu, 3 Jun 2021 02:57:25 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 1/2] scsi: fc: Corrected RHBA attributes length
Date:   Thu, 3 Jun 2021 02:56:36 -0700
Message-ID: <20210603095637.7319-2-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210603095637.7319-1-jhasan@marvell.com>
References: <20210603095637.7319-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: F-ULkvx3pnnl_fMJcKQlBVn4IQd1-SHr
X-Proofpoint-GUID: F-ULkvx3pnnl_fMJcKQlBVn4IQd1-SHr
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-03_06:2021-06-02,2021-06-03 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 -As per document of FC-GS-5, attribute lengths of node_name
  and manufacturer should in range of "4 to 64 Bytes" only.

Fixes: e721eb0616f6 ("scsi: scsi_transport_fc: Match HBA Attribute Length with HBAAPI V2.0 definitions")
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 include/scsi/fc/fc_ms.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/scsi/fc/fc_ms.h b/include/scsi/fc/fc_ms.h
index 9e273fed0a85..800d53dc9470 100644
--- a/include/scsi/fc/fc_ms.h
+++ b/include/scsi/fc/fc_ms.h
@@ -63,8 +63,8 @@ enum fc_fdmi_hba_attr_type {
  * HBA Attribute Length
  */
 #define FC_FDMI_HBA_ATTR_NODENAME_LEN		8
-#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN	80
-#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN	80
+#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN	64
+#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN	64
 #define FC_FDMI_HBA_ATTR_MODEL_LEN		256
 #define FC_FDMI_HBA_ATTR_MODELDESCR_LEN		256
 #define FC_FDMI_HBA_ATTR_HARDWAREVERSION_LEN	256
-- 
2.26.2

