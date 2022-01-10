Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 648AFC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jan 2022 05:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiAJFDH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jan 2022 00:03:07 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3962 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235068AbiAJFC7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jan 2022 00:02:59 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 209KQlqh023499
        for <linux-scsi@vger.kernel.org>; Sun, 9 Jan 2022 21:02:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=bbCSfZd5E3Cl48CN2MbTlmEuTVTUJRAjXxaoNtWNZCY=;
 b=jJXG6h/96crPqhsjAmuYLlmOuGxXbEmy89SpL3zRjC6qlWXRcYZZLHG3eo7MPr8tC61/
 U+UTvbLzCE/13SqNZxhTkIuK4Hhmw6ochz3iCDtv8hSKZTHOXJYuUHzwbNp5vi6ky8RI
 P+t7Gm/81YqcCQEjS89FZGaeFhlFqDU1t5fvZwebs2HV/HSVrQFvyrwkelGnNKc+FvdY
 n3i744HUXDsBiL0TWDySXdr87oDkYd/tOOu9vxYe2s9tMYvjOCmUJlAPPIgz9wPzamHR
 rP4R7D0+OCatJ+mPEiOBAmghyz4A0XBrOg8F0P7csCdI+B+pzW91xFdA82UZ1IhAFD+J Qw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dfy8nhjf0-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 09 Jan 2022 21:02:58 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 9 Jan
 2022 21:02:55 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 9 Jan 2022 21:02:55 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 073573F70A9;
        Sun,  9 Jan 2022 21:02:55 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 20A52svp004025;
        Sun, 9 Jan 2022 21:02:54 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 20A52sSx004024;
        Sun, 9 Jan 2022 21:02:54 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 08/17] qla2xxx: Show wrong FDMI data for 64G adaptor
Date:   Sun, 9 Jan 2022 21:02:09 -0800
Message-ID: <20220110050218.3958-9-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220110050218.3958-1-njavali@marvell.com>
References: <20220110050218.3958-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: ZN9TCfsLnas70vjs_u-1QupaDNXZHcQE
X-Proofpoint-ORIG-GUID: ZN9TCfsLnas70vjs_u-1QupaDNXZHcQE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-10_01,2022-01-07_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bikash Hazarika <bhazarika@marvell.com>

Corrected transmission speed mask values for FC.
Supported Speed: 16 32 20 Gb/s   ===> It should be 64 instead of 20
Supported Speed: 16G 32G 48G  ===>  It should be 64G instead of 48G

Cc: stable@vger.kernel.org
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a5fc01b4fa96..bc0c5df77801 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2891,7 +2891,11 @@ struct ct_fdmi2_hba_attributes {
 #define FDMI_PORT_SPEED_8GB		0x10
 #define FDMI_PORT_SPEED_16GB		0x20
 #define FDMI_PORT_SPEED_32GB		0x40
-#define FDMI_PORT_SPEED_64GB		0x80
+#define FDMI_PORT_SPEED_20GB		0x80
+#define FDMI_PORT_SPEED_40GB		0x100
+#define FDMI_PORT_SPEED_128GB		0x200
+#define FDMI_PORT_SPEED_64GB		0x400
+#define FDMI_PORT_SPEED_256GB		0x800
 #define FDMI_PORT_SPEED_UNKNOWN		0x8000
 
 #define FC_CLASS_2	0x04
-- 
2.23.1

