Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB3CC2BA19
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 06:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84363214D8
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 06:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgDRGkC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Apr 2020 02:40:02 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:46784 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbgDRGkB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Apr 2020 02:40:01 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EC554D323AF2793408FD;
        Sat, 18 Apr 2020 14:39:57 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Sat, 18 Apr 2020
 14:39:49 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <kartilak@cisco.com>, <sebaddel@cisco.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: snic: make snic_io_exch_ver_cmpl_handler() void
Date:   Sat, 18 Apr 2020 15:06:15 +0800
Message-ID: <20200418070615.11603-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This function do not need a return value and no users use it's return
value. So we can make it void.

This also fixes the coccicheck warning:

drivers/scsi/snic/snic_ctl.c:163:5-8: Unneeded variable: "ret". Return
"0" on line 228

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/snic/snic.h     | 2 +-
 drivers/scsi/snic/snic_ctl.c | 5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
index de0ab5fc8474..f4c666285bba 100644
--- a/drivers/scsi/snic/snic.h
+++ b/drivers/scsi/snic/snic.h
@@ -399,7 +399,7 @@ void snic_handle_link_event(struct snic *);
 void snic_handle_link(struct work_struct *);
 
 int snic_queue_exch_ver_req(struct snic *);
-int snic_io_exch_ver_cmpl_handler(struct snic *, struct snic_fw_req *);
+void snic_io_exch_ver_cmpl_handler(struct snic *, struct snic_fw_req *);
 
 int snic_queue_wq_desc(struct snic *, void *os_buf, u16 len);
 
diff --git a/drivers/scsi/snic/snic_ctl.c b/drivers/scsi/snic/snic_ctl.c
index 449b03f3bbd3..4cd86115cfb2 100644
--- a/drivers/scsi/snic/snic_ctl.c
+++ b/drivers/scsi/snic/snic_ctl.c
@@ -151,7 +151,7 @@ snic_queue_exch_ver_req(struct snic *snic)
 /*
  * snic_io_exch_ver_cmpl_handler
  */
-int
+void
 snic_io_exch_ver_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 {
 	struct snic_req_info *rqi = NULL;
@@ -160,7 +160,6 @@ snic_io_exch_ver_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 	u32 cmnd_id, hid, max_sgs;
 	ulong ctx = 0;
 	unsigned long flags;
-	int ret = 0;
 
 	SNIC_HOST_INFO(snic->shost, "Exch Ver Compl Received.\n");
 	snic_io_hdr_dec(&fwreq->hdr, &typ, &hdr_stat, &cmnd_id, &hid, &ctx);
@@ -224,8 +223,6 @@ snic_io_exch_ver_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 	snic_release_untagged_req(snic, rqi);
 
 	SNIC_HOST_INFO(snic->shost, "Exch_cmpl Done, hdr_stat %d.\n", hdr_stat);
-
-	return ret;
 } /* end of snic_io_exch_ver_cmpl_handler */
 
 /*
-- 
2.21.1

