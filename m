Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD011C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 05:49:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B19DC20717
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 05:49:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="rxBCQMId"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgC0FtA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 01:49:00 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30008 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725942AbgC0FtA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 01:49:00 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02R5jEVk032430
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2020 22:48:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=qQBAB8GzXWllPVGNpmhZaMQdeaddr3uZnTy++rYkIDM=;
 b=rxBCQMId3hNRZzZwoN7B5n3rIBcUT+G3wV5sEKRYV9f6mfCxi38wpM6j8Z7dxrjtbdtW
 4oAlWYUf9OW6XvMDxeqbozIFis7fkbfwJfZ4L6rWF9bAGy9gbGR3Uvrqsq6bLI+zthXJ
 OQHLE/FZscj+t9tZUjqCXRVyvz57B10wffoTbhZZ7TNmoFRNmHdMIdsmqC5KfWiBgUKv
 Pza/dXBL3WIGxJnot1HmezUheK9xi9MpMfzXnDWVJTFKPzgw0MyL2mKF4IhZw8blnw5E
 2koZ3RdKDV9jeMrx7pUrqBGx/4ij8TXP1NSOxegSg73by6z5Y85cvQ0k0PPb03Ui83Xa ww== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 300bpcyqp1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2020 22:48:59 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Mar
 2020 22:48:56 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Mar 2020 22:48:56 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 5EDC63F7040;
        Thu, 26 Mar 2020 22:48:56 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02R5mua5015990;
        Thu, 26 Mar 2020 22:48:56 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02R5muMv015989;
        Thu, 26 Mar 2020 22:48:56 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH 2/3] bnx2fc: Fix scsi command completion after cleanup is posted.
Date:   Thu, 26 Mar 2020 22:48:48 -0700
Message-ID: <20200327054849.15947-3-skashyap@marvell.com>
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

Driver received a scsi completion after it posted the cleanup
request. This leads to a problem that one of the ref count wasn't
released leading to flush_active_ios to struck. The callback from
libfc never returned and other ports were not processed leading to
APD.

- The patch will decrease the refcnt as well try to complete if
something is waiting for completion.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 9ab9152..2b070f0 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1917,6 +1917,12 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 		/* we will not receive ABTS response for this IO */
 		BNX2FC_IO_DBG(io_req, "Timer context finished processing "
 			   "this scsi cmd\n");
+		if (test_and_clear_bit(BNX2FC_FLAG_IO_CLEANUP,
+				       &io_req->req_flags)) {
+			BNX2FC_IO_DBG(io_req,
+				      "Actual completion after cleanup request cleaning up\n");
+			bnx2fc_process_cleanup_compl(io_req, task, num_rq);
+		}
 		return;
 	}
 
-- 
1.8.3.1

