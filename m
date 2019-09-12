Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA335C4CEC5
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 15:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8202C20830
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 15:22:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="FUPK7Okd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733001AbfILPW1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 11:22:27 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31204 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732699AbfILPW0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 11:22:26 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CFKPBt022303;
        Thu, 12 Sep 2019 08:20:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=9f2/nX7i5ENX6341kDyVATfy0Nk3wp8SV+Pz1XirF+4=;
 b=FUPK7Okd9kdlwz++rIEjGst4cmxPaiIgeTX54WYKVkKzNLp/qYiy4Eeb0w5QzOSneaou
 +IPA28bIYycNFRf+vtvN4gP+ugakaL6ZftqLI1QTmP4VZunR4Vnx+2L+cCja7eKFZlFK
 53wiGalcMQ+bneF6rf7QNffSEtE8cV2OWvkv7h8/kgOxWm/scU7W0ootQlLoI60gorm5
 7A+fbGW/6ZneJfFPr0+HItGyr8da78yLnssBsXRr5kG44wcVAwUczNqS8zRZsE/L3Z43
 jgD3tbTle3zXdsTH3G9vMiWqbXJmhO6OHqOkG0E4sKidKgxoLRf2XM7IexacJrP9okau +Q== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uxshkfypg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 08:20:25 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 12 Sep
 2019 08:20:20 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 12 Sep 2019 08:20:20 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0E9413F7040;
        Thu, 12 Sep 2019 08:20:20 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x8CFKJgO002650;
        Thu, 12 Sep 2019 08:20:19 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x8CFKJBF002649;
        Thu, 12 Sep 2019 08:20:19 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 10/14] qla2xxx: Set remove flag for all VP
Date:   Thu, 12 Sep 2019 08:19:45 -0700
Message-ID: <20190912151949.2348-11-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190912151949.2348-1-hmadhani@marvell.com>
References: <20190912151949.2348-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_08:2019-09-11,2019-09-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

During driver unload, the remove flag will be set for all
scsi_qla_host/NPIV. This allows each NPIV to see the flag
instead of reaching for base_vha to search for it.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 27a22839c23d..45b2daa3ad9d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3508,6 +3508,29 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ret;
 }
 
+static void __qla_set_remove_flag(scsi_qla_host_t *base_vha)
+{
+	scsi_qla_host_t *vp;
+	unsigned long flags;
+	struct qla_hw_data *ha;
+
+	if (!base_vha)
+		return;
+
+	ha = base_vha->hw;
+
+	spin_lock_irqsave(&ha->vport_slock, flags);
+	list_for_each_entry(vp, &ha->vp_list, list)
+		set_bit(PFLG_DRIVER_REMOVING, &vp->pci_flags);
+
+	/*
+	 * Indicate device removal to prevent future board_disable
+	 * and wait until any pending board_disable has completed.
+	 */
+	set_bit(PFLG_DRIVER_REMOVING, &base_vha->pci_flags);
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
+}
+
 static void
 qla2x00_shutdown(struct pci_dev *pdev)
 {
@@ -3524,7 +3547,7 @@ qla2x00_shutdown(struct pci_dev *pdev)
 	 * Prevent future board_disable and wait
 	 * until any pending board_disable has completed.
 	 */
-	set_bit(PFLG_DRIVER_REMOVING, &vha->pci_flags);
+	__qla_set_remove_flag(vha);
 	cancel_work_sync(&ha->board_disable);
 
 	if (!atomic_read(&pdev->enable_cnt))
@@ -3680,10 +3703,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	ha = base_vha->hw;
 	ql_log(ql_log_info, base_vha, 0xb079,
 	    "Removing driver\n");
-
-	/* Indicate device removal to prevent future board_disable and wait
-	 * until any pending board_disable has completed. */
-	set_bit(PFLG_DRIVER_REMOVING, &base_vha->pci_flags);
+	__qla_set_remove_flag(base_vha);
 	cancel_work_sync(&ha->board_disable);
 
 	/*
-- 
2.12.0

