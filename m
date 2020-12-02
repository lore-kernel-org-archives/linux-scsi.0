Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 123CFC64E7B
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1A40221FC
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgLBNZb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 08:25:31 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54764 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725920AbgLBNZa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 08:25:30 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B2DF3rI015920
        for <linux-scsi@vger.kernel.org>; Wed, 2 Dec 2020 05:24:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=MLl4ZuTPPWOfE5r4WxxDpBiexXwJNP0vlcStaCke+KE=;
 b=dSjey+5X4wyDosj92qeyg8qeEiba3/V3Ywb8YDESl5CJsn9HwYEDv+79qaIhS+acrwXW
 0XXU7rji0XXhdhSDG+CvkVZY/4/Q4ITlA1r+/X1dkWC6OTzFVraBYXrxqMtbg2WLK/47
 VL2WKsAhJEuKXAQ7wWG5iGH85Wjwp8YCib5xnHFgAn0qX971mbj/lGuRWUT7vyPjOU1M
 VxGFgnRHmTdujLqyynJPk582eq4pZzFI/YUOisgTOy+5Vqz4QTlMJuFSJDY+ceuZPJGe
 9WmQqy46zO7OPizwSkFMhuIbfGHVD8FgQSMOYQCnO+iSU8eQG9OH+DxDOQEULK1voTIt Ig== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 3568jf8fu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Dec 2020 05:24:50 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Dec
 2020 05:24:49 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Dec 2020 05:24:49 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 55A273F703F;
        Wed,  2 Dec 2020 05:24:49 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B2DOnvf020030;
        Wed, 2 Dec 2020 05:24:49 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B2DOnDl020029;
        Wed, 2 Dec 2020 05:24:49 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 03/15] qla2xxx: limit interrupt vectors to number of cpu
Date:   Wed, 2 Dec 2020 05:23:00 -0800
Message-ID: <20201202132312.19966-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201202132312.19966-1-njavali@marvell.com>
References: <20201202132312.19966-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_06:2020-11-30,2020-12-02 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Driver created too many QPairs(126) with 28xx adapter.
Limit the number of CPUs to lower wasted resources.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index a24b82de4aab..77dd7630c3f8 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3952,10 +3952,12 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 	if (USER_CTRL_IRQ(ha) || !ha->mqiobase) {
 		/* user wants to control IRQ setting for target mode */
 		ret = pci_alloc_irq_vectors(ha->pdev, min_vecs,
-		    ha->msix_count, PCI_IRQ_MSIX);
+		    min((u16)ha->msix_count, (u16)num_online_cpus()),
+		    PCI_IRQ_MSIX);
 	} else
 		ret = pci_alloc_irq_vectors_affinity(ha->pdev, min_vecs,
-		    ha->msix_count, PCI_IRQ_MSIX | PCI_IRQ_AFFINITY,
+		    min((u16)ha->msix_count, (u16)num_online_cpus()),
+		    PCI_IRQ_MSIX | PCI_IRQ_AFFINITY,
 		    &desc);
 
 	if (ret < 0) {
-- 
2.19.0.rc0

