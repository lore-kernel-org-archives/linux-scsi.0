Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16982C43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 05:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D80F9218AC
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 05:27:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="A8BKKyDs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbgIHF14 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 01:27:56 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:57188 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726387AbgIHF14 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 01:27:56 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0885Pi87023737;
        Mon, 7 Sep 2020 22:27:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=60ElqxE7KLSoLi6sho+TKtCtZ1n/iElwM0UcPlrT/r4=;
 b=A8BKKyDsEJ2L7UIks3z0DxhKulqOlEpE8UQWMr3gj1786iRBkIxsg1WDEvIEEONVmf4G
 SCIgTZCKYpFnLArpY6+PWAgOCqw3DTORDzgKi9HE12pWqwgyNmSz1SKkDER/LxGp3+zT
 kyHjuNK2wyczN16xHgw6ZUiwvJAcimu1Rg1AhHyjg22QGbyexLJ8cZCYvujEGR0ut7B9
 +5D2wMgb0K5sIqtBUDGkS69nfQs2qkwDg4eOi033bPAM8AgFYtJUdiHVZjX6/bleRw9E
 dzALAbc8kcn34SaFdNFYKV8/onHe2NKDPnhKR6ZP2E5Oxel7JVYQO9rhz6kjeKyB8p8B gQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 33c81pt6fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 22:27:50 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 22:27:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Sep 2020 22:27:49 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A48EC3F703F;
        Mon,  7 Sep 2020 22:27:49 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0885Rn2A022009;
        Mon, 7 Sep 2020 22:27:49 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0885Rnu8022008;
        Mon, 7 Sep 2020 22:27:49 -0700
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 8/8] qedi: Add support for handling the pcie errors.
Date:   Mon, 7 Sep 2020 22:24:12 -0700
Message-ID: <20200908052412.21917-9-mrangankar@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200908052412.21917-1-mrangankar@marvell.com>
References: <20200908052412.21917-1-mrangankar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_02:2020-09-07,2020-09-08 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The error recovery is handled by management firmware (MFW) with the help of
qed/qedi drivers. Upon detecting the errors, driver informs MFW about this
event which in turn starts a recovery process. MFW sends ERROR_RECOVERY
notification to the driver which performs the required cleanup/recovery
from the driver side.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_main.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 28b5d6670580..24564fff3e93 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2389,6 +2389,25 @@ static int qedi_setup_boot_info(struct qedi_ctx *qedi)
 	return -ENOMEM;
 }
 
+static pci_ers_result_t qedi_io_error_detected(struct pci_dev *pdev,
+					       pci_channel_state_t state)
+{
+	struct qedi_ctx *qedi = pci_get_drvdata(pdev);
+
+	QEDI_ERR(&qedi->dbg_ctx, "%s: PCI error detected [%d]\n",
+		 __func__, state);
+
+	if (test_and_set_bit(QEDI_IN_RECOVERY, &qedi->flags)) {
+		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
+			  "Recovery already in progress.\n");
+		return PCI_ERS_RESULT_NONE;
+	}
+
+	qedi_ops->common->recovery_process(qedi->cdev);
+
+	return PCI_ERS_RESULT_CAN_RECOVER;
+}
+
 static void __qedi_remove(struct pci_dev *pdev, int mode)
 {
 	struct qedi_ctx *qedi = pci_get_drvdata(pdev);
@@ -2818,12 +2837,17 @@ MODULE_DEVICE_TABLE(pci, qedi_pci_tbl);
 
 static enum cpuhp_state qedi_cpuhp_state;
 
+static struct pci_error_handlers qedi_err_handler = {
+	.error_detected = qedi_io_error_detected,
+};
+
 static struct pci_driver qedi_pci_driver = {
 	.name = QEDI_MODULE_NAME,
 	.id_table = qedi_pci_tbl,
 	.probe = qedi_probe,
 	.remove = qedi_remove,
 	.shutdown = qedi_shutdown,
+	.err_handler = &qedi_err_handler,
 };
 
 static int __init qedi_init(void)
-- 
2.25.0

