Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E3DC433E2
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 07:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2C9A2145D
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 07:46:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgIGHqM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 03:46:12 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:45624 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727827AbgIGHqI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Sep 2020 03:46:08 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4F469A6421ECB9EAE0F3;
        Mon,  7 Sep 2020 15:46:07 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Mon, 7 Sep 2020
 15:46:01 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <mdr@sgi.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yanaijie@huawei.com>, <tbogendoerfer@suse.de>,
        <linux-scsi@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: [PATCH 4/4] scsi: qla1280: remove set but not used variable in qla1280_status_entry()
Date:   Mon, 7 Sep 2020 15:45:18 +0800
Message-ID: <20200907074518.2326360-5-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200907074518.2326360-1-yanaijie@huawei.com>
References: <20200907074518.2326360-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This addresses the following gcc warning with "make W=1":

drivers/scsi/qla1280.c: In function ‘qla1280_status_entry’:
drivers/scsi/qla1280.c:3607:28: warning: variable ‘lun’ set but not used
[-Wunused-but-set-variable]
 3607 |  unsigned int bus, target, lun;
      |                            ^~~
drivers/scsi/qla1280.c:3607:20: warning: variable ‘target’ set but not
used [-Wunused-but-set-variable]
 3607 |  unsigned int bus, target, lun;
      |                    ^~~~~~
drivers/scsi/qla1280.c:3607:15: warning: variable ‘bus’ set but not used
[-Wunused-but-set-variable]
 3607 |  unsigned int bus, target, lun;
      |               ^~~

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/qla1280.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index fe4b88aaf5cb..545936cb3980 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -3601,7 +3601,6 @@ static void
 qla1280_status_entry(struct scsi_qla_host *ha, struct response *pkt,
 		     struct list_head *done_q)
 {
-	unsigned int bus, target, lun;
 	int sense_sz;
 	struct srb *sp;
 	struct scsi_cmnd *cmd;
@@ -3627,11 +3626,6 @@ qla1280_status_entry(struct scsi_qla_host *ha, struct response *pkt,
 
 	cmd = sp->cmd;
 
-	/* Generate LU queue on cntrl, target, LUN */
-	bus = SCSI_BUS_32(cmd);
-	target = SCSI_TCN_32(cmd);
-	lun = SCSI_LUN_32(cmd);
-
 	if (comp_status || scsi_status) {
 		dprintk(3, "scsi: comp_status = 0x%x, scsi_status = "
 			"0x%x, handle = 0x%x\n", comp_status,
@@ -3670,7 +3664,8 @@ qla1280_status_entry(struct scsi_qla_host *ha, struct response *pkt,
 
 			dprintk(2, "qla1280_status_entry: Check "
 				"condition Sense data, b %i, t %i, "
-				"l %i\n", bus, target, lun);
+				"l %i\n", SCSI_BUS_32(cmd), SCSI_TCN_32(cmd),
+				SCSI_LUN_32(cmd));
 			if (sense_sz)
 				qla1280_dump_buffer(2,
 						    (char *)cmd->sense_buffer,
-- 
2.25.4

