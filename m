Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCBEC4708F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 17:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5C26613BD
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 17:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbhFARYa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 13:24:30 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63360 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231918AbhFARY3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 13:24:29 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 151HGgCS008804
        for <linux-scsi@vger.kernel.org>; Tue, 1 Jun 2021 10:22:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=EuKAYSLcW4i+JIRER6K2JULXOR4xFtAzh0EoIYKMmgI=;
 b=IFCOHiwIfU3ZfSv+UBSjb+xxkyP/JHazyLxOEJSTHIizTqYUs3VjKpvq5Uc8iq6Wfnkb
 Ewh3xBSZsOhdEY7V9EoSwvUarmUtbhhAZYIAAVmfoLNBJcZ+IXRfiHNgD/CE4yxMJVcy
 BLD4+24j2DgS8Ktz+8pBD7ZL300D3sDXC+/Iy1nxrV74kLDLZ5XPKzlXR8uII0b/fF9K
 HPf5+jkXfJO1zg+TaS+wZzdxOR84sCCt8kinoJrKwxDnQzCDaSmpPm3U1vBAO0IGLu2T
 l92XHhjBO1t/EWQRRa1+5IETo4hzet5Z9pyCBMCMwKjXwcLlFj+DpVA7UGdu71QEra4Y 7Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 38vtnjd8hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jun 2021 10:22:47 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Jun
 2021 10:22:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Jun 2021 10:22:45 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 03B0F3F7044;
        Tue,  1 Jun 2021 10:22:44 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 151HMinp031989;
        Tue, 1 Jun 2021 10:22:44 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 151HMivR031988;
        Tue, 1 Jun 2021 10:22:44 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 1/2] scsi: fc: Corrected RHBA attributes length
Date:   Tue, 1 Jun 2021 10:21:55 -0700
Message-ID: <20210601172156.31942-2-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210601172156.31942-1-jhasan@marvell.com>
References: <20210601172156.31942-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: uaxEaeapbfglYwM0r-5I4A-YPopxkaC0
X-Proofpoint-ORIG-GUID: uaxEaeapbfglYwM0r-5I4A-YPopxkaC0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-01_08:2021-06-01,2021-06-01 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 -As per document of FC-GS-5, attribute lengths of node_name
  and manufacturer should in range of "4 to 64 Bytes" only.

Signed-off-by: Javed Hasan <jhasan@marvell.com>

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

