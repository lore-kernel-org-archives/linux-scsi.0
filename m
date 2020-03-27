Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA08C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 05:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64A5F20663
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 05:49:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="g/fL+eQO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgC0FtD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 01:49:03 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7776 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725942AbgC0FtC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 01:49:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02R5idPu003459
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2020 22:49:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=CEVvSXM7dK4DjRZLfw8KioyiLljk9ICB8Bj8fjmB+48=;
 b=g/fL+eQOOa3ak5VfLIvhef45y1cOKlH4Kb85zntroURaCeb2r48ZqunU+DHe0Gw0WnbJ
 8KKSqJQF/Vx+AuhDZ0qudNlerK/APSdrVhskITvUedVJn1moa+tP/0D5E+89czS+V8JZ
 PFTISwbBYDvXDyLcOtdzE6KLuCtMu2R/CMWppKr4ncYXoOHX5gyAhkG8cmLYPScT1jsg
 u1CwwNsMTu8JDlTCBD0ytwAfJTHvFT5tDUaE8yz/u8quIAVJMiNXHLciNfGdM5hvHTf9
 cc7k61LjD7rxmnYn8zSMdGZcgOyKU/Hnf2M4wh9qdlvL1Rm2OCmbAHYrkRlPyiEvv0HO CQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9p1dg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2020 22:49:02 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Mar
 2020 22:49:00 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Mar
 2020 22:48:59 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Mar 2020 22:48:59 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8C1543F703F;
        Thu, 26 Mar 2020 22:48:59 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02R5mxan015994;
        Thu, 26 Mar 2020 22:48:59 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02R5mxK7015993;
        Thu, 26 Mar 2020 22:48:59 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH 3/3] bnx2fc: Update the driver version to 2.12.13.
Date:   Thu, 26 Mar 2020 22:48:49 -0700
Message-ID: <20200327054849.15947-4-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200327054849.15947-1-skashyap@marvell.com>
References: <20200327054849.15947-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-26_14:2020-03-26,2020-03-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

- Update version to 2.12.13.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 15fa8e2..b6e8ed7 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -66,7 +66,7 @@
 #include "bnx2fc_constants.h"
 
 #define BNX2FC_NAME		"bnx2fc"
-#define BNX2FC_VERSION		"2.12.10"
+#define BNX2FC_VERSION		"2.12.13"
 
 #define PFX			"bnx2fc: "
 
-- 
1.8.3.1

