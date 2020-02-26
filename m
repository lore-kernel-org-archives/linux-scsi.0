Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B84DBC4BA24
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F82E24672
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:43:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="IEkM9X/z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgBZWnL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:43:11 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25482 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727761AbgBZWnL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 17:43:11 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QMeNj7006110;
        Wed, 26 Feb 2020 14:41:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=zLQ3/8PmJEq8wcSG/mrPn3mOx2leQyUdPNux7EESj80=;
 b=IEkM9X/zawxNUIDRzCtO0l+gatc7S4W04U3nhEi9jAXgKLfeMAGUqypgQdeKQzQMw3aK
 DXUycKMHSZZ+HgUw1JPbdJMgAG9RSY9TVcNrI3EtHsNydYfw3ECO36uc7Hfk7ey8l0jA
 sPtbfvdGpCZIxEa1D/jmCDjLtIEWjEz4vVP08axlFTtyKdb65Yi+bwWqabM3paYmgch+
 9R732AO0fmQ7YJw6GP93c3hQS0t3/2je2ZNQi9Ur6GfGZv0Jbpl8Tbg5+kouq9mlwfGd
 w0LHPM5WhQ1P8RduucBwqIPiY8Hj2unaTgfT5v98fIZqp80MpXS8J7EpzL4U2/X1LWWX 0Q== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ydchtd6nr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Feb 2020 14:41:10 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:41:08 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 Feb 2020 14:41:08 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 4F1533F703F;
        Wed, 26 Feb 2020 14:41:08 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01QMf8Ih024621;
        Wed, 26 Feb 2020 14:41:08 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01QMf8O2024620;
        Wed, 26 Feb 2020 14:41:08 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 15/18] qla2xxx: Remove restriction of FC T10-PI and FC-NVMe
Date:   Wed, 26 Feb 2020 14:40:19 -0800
Message-ID: <20200226224022.24518-16-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200226224022.24518-1-hmadhani@marvell.com>
References: <20200226224022.24518-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_09:2020-02-26,2020-02-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

T10-PI and FC-NVMe are not mutually exclusive of each
other. This patch removes restrictions where if FC-NVMe
is enabled T10-PI defaults to disabled.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 80c5c7b16150..6973fe400ce4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -123,11 +123,7 @@ MODULE_PARM_DESC(ql2xmaxqdepth,
 		"Maximum queue depth to set for each LUN. "
 		"Default is 64.");
 
-#if (IS_ENABLED(CONFIG_NVME_FC))
-int ql2xenabledif;
-#else
 int ql2xenabledif = 2;
-#endif
 module_param(ql2xenabledif, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xenabledif,
 		" Enable T10-CRC-DIF:\n"
-- 
2.12.0

