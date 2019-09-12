Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A452C4CEC6
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 15:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 235702081B
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 15:20:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="bgFTlOnX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733025AbfILPT7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 11:19:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19872 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732699AbfILPT7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 11:19:59 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CFHAhW011748;
        Thu, 12 Sep 2019 08:19:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=1rWNBEEr0vY3n2QT3xNKY/wPVa8KDfSimot+VnN+lc4=;
 b=bgFTlOnXMrTip6XOgpLCjUYmYQ1J7mRZFRZagOwhEkDOnIXcMoHuK7j2BdOOvLTa1Sxk
 yy1O3CgpJpfk/1eq9qNrq+B9SqYU3NuXK5F23TYTp4cQN4JDzknOg/vZaXdic91SlGis
 oj4KdOB39yF+qcvXypBBqsyIHS+Dr5mmvvOMG/SaQLKa49blTiLTmoY9vNYALTcvtAVN
 2ABmce2fCzvL/KuOJCpz3vmgIe7uI+12pzU+WHNXat4bb7VWx6aM38yEiPwYXw/lfbNh
 G5qTCndJOXScMPoKAsoK/kBSxRk35JGsoy3hQVkcipBteRBUcrgOlUwiFxkQQYdhnHc0 tg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uvc2jy5nc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 08:19:55 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 12 Sep
 2019 08:19:53 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 12 Sep 2019 08:19:53 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id EFEC73F703F;
        Thu, 12 Sep 2019 08:19:52 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x8CFJqLK002387;
        Thu, 12 Sep 2019 08:19:52 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x8CFJqX5002386;
        Thu, 12 Sep 2019 08:19:52 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 01/14] qla2xxx: Silence fwdump template message
Date:   Thu, 12 Sep 2019 08:19:36 -0700
Message-ID: <20190912151949.2348-2-hmadhani@marvell.com>
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

Print fwdt template is present or not, only
when ql2xextended_error_logging is enabled.

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f869a5668a83..a98f857b3d72 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3282,7 +3282,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 
 		for (j = 0; j < 2; j++, fwdt++) {
 			if (!fwdt->template) {
-				ql_log(ql_log_warn, vha, 0x00ba,
+				ql_dbg(ql_dbg_init, vha, 0x00ba,
 				    "-> fwdt%u no template\n", j);
 				continue;
 			}
-- 
2.12.0

