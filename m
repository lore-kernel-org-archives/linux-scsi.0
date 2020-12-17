Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF356C4361B
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 10:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81BF62389A
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 10:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgLQKw5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 05:52:57 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51134 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726012AbgLQKw5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Dec 2020 05:52:57 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BHAp7PU029399;
        Thu, 17 Dec 2020 02:52:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=KtPxjcbHEvRzTGfWUpOO7zi76gq4aXppa2JKaXpwUyU=;
 b=Hlb6L6/jqjshYrGQN5p1nOLA7br4hh/RfL+RHFqUFbsf+nYir+U8jnOUvl6lL5LBKrLs
 RI1COI1UVNIfzwdhZxeEYxSCswLzPdOMGFFzcadOzw0BRMPoOPzUFFRbPO49lkx45RiS
 U1NoZHGZk957IKqCqNMeEvTV4eIxMJDFf7wRGJmocd/0kFUDPkZ1t4jU2EcJDh46Lv6y
 Aw3CZUpyfHXvOxkGNiqdBZXsEbOn/Hh6eQuU4qla4sIFdcYZhHGlcBk5Ld82vlqYWMnt
 WKrgm5YLflHbiYWiPIxYAyr+r7LiZJynivCqkyx0EBCKIykIrDxnH4X8cYK3f5rDVEhf Vg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35cx8tf9px-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 02:52:10 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 02:52:08 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Dec 2020 02:52:09 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 1F2333F703F;
        Thu, 17 Dec 2020 02:52:09 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0BHAq8s2008090;
        Thu, 17 Dec 2020 02:52:08 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0BHAq8qZ008089;
        Thu, 17 Dec 2020 02:52:08 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH] qedi: Correct max length of CHAP secret
Date:   Thu, 17 Dec 2020 02:51:44 -0800
Message-ID: <20201217105144.8055-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_07:2020-12-15,2020-12-17 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The CHAP secret displayed garbage characters causing iSCSI login
authentication failure. Correct the CHAP password max length.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qedi/qedi_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index f5fc7f518f8a..47ad64b06623 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2245,7 +2245,7 @@ qedi_show_boot_tgt_info(struct qedi_ctx *qedi, int type,
 			     chap_name);
 		break;
 	case ISCSI_BOOT_TGT_CHAP_SECRET:
-		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
+		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN,
 			     chap_secret);
 		break;
 	case ISCSI_BOOT_TGT_REV_CHAP_NAME:
@@ -2253,7 +2253,7 @@ qedi_show_boot_tgt_info(struct qedi_ctx *qedi, int type,
 			     mchap_name);
 		break;
 	case ISCSI_BOOT_TGT_REV_CHAP_SECRET:
-		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
+		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN,
 			     mchap_secret);
 		break;
 	case ISCSI_BOOT_TGT_FLAGS:
-- 
2.23.1

