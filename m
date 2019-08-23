Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A4D2C3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B7CA22CE3
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:53:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Rr3uom8g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389898AbfHWJxV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 05:53:21 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8442 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389683AbfHWJxT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 05:53:19 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7N9nS1m027881
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:53:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=NChN1AwprGiO0ZO4Sgscoaqi5YLkhwKXG4dNT/9GHB8=;
 b=Rr3uom8gwm7qIL3CRhqvKF2PM0952kbFnQD9SMeY2JJMmYoZ9OheBIdYCkCE5rQgLuU0
 Iqc7+LEOb5MaQcTX6og5Yhobjj7HZz2y10z2zgInMbZpob/i3rYG3tRX9uw5P0Nuh1Q1
 8xNs0nP8r3pOHNZ6I/FyE6McYcM/NSzmPmUjQveBmEK6C9j99paCIxqyo164LaPQHzms
 jjutfP/AIbFnIYG/jsaiWoKohAtvRNWng/c4c7DYt2RR4JFJlbSKiTXIkHL/Rx5y6b4l
 5ycjvQEUcYiuXXpQQDZ9l2Hh2qw1DJp8If7BajVRBDO0WCjH0SbmwCGKiOqmiTDUkUC5 4w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uhag27tvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:53:18 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 23 Aug
 2019 02:53:16 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 23 Aug 2019 02:53:16 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 63BF73F703F;
        Fri, 23 Aug 2019 02:53:16 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7N9rG7B007913;
        Fri, 23 Aug 2019 02:53:16 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7N9rGIG007912;
        Fri, 23 Aug 2019 02:53:16 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <gbasrur@marvell.com>, <svernekar@marvell.com>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH 10/14] qedf: Check for module unloading bit before processing link update AEN.
Date:   Fri, 23 Aug 2019 02:52:40 -0700
Message-ID: <20190823095244.7830-11-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190823095244.7830-1-skashyap@marvell.com>
References: <20190823095244.7830-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-23_03:2019-08-21,2019-08-23 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

- Prevent race where we're removing the module and we get link update

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 50b1fa8..ab9a932 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -533,6 +533,16 @@ static void qedf_link_update(void *dev, struct qed_link_output *link)
 {
 	struct qedf_ctx *qedf = (struct qedf_ctx *)dev;
 
+	/*
+	 * Prevent race where we're removing the module and we get link update
+	 * for qed.
+	 */
+	if (test_bit(QEDF_UNLOADING, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "Ignore link update, driver getting unload.\n");
+		return;
+	}
+
 	if (link->link_up) {
 		if (atomic_read(&qedf->link_state) == QEDF_LINK_UP) {
 			QEDF_INFO((&qedf->dbg_ctx), QEDF_LOG_DISC,
-- 
1.8.3.1

