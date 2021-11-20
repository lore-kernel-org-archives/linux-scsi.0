Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BFA6C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 04:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhKVEdh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Nov 2021 23:33:37 -0500
Received: from mailgw.kylinos.cn ([123.150.8.42]:15825 "EHLO nksmu.kylinos.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229870AbhKVEdg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 21 Nov 2021 23:33:36 -0500
X-UUID: 5057995b7f234a8b99c4f879a224f744-20211122
X-UUID: 5057995b7f234a8b99c4f879a224f744-20211122
X-User: wenzhiwei@kylinos.cn
Received: from localhost.localdomain [(172.17.127.26)] by nksmu.kylinos.cn
        (envelope-from <wenzhiwei@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 437737254; Mon, 22 Nov 2021 12:39:05 +0800
From:   Wen Zhiwei <wenzhiwei@kylinos.cn>
To:     subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: be2iscsi:Fix the problem that the array may be out of bounds
Date:   Sat, 20 Nov 2021 08:32:33 +0800
Message-Id: <20211120003233.69789-1-wenzhiwei@kylinos.cn>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

By observing that the value of ulp_num may be
'BEISCSI_ULP_COUNT',this will cause the problem
of data out of bounds.Increase judgments to
eliminate risks.

Signed-off-by: Wen Zhiwei <wenzhiwei@kylinos.cn>
---
 drivers/scsi/be2iscsi/be_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index ab55681145f8..392a53184a00 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3947,7 +3947,8 @@ static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
 	for (ulp_num = 0; ulp_num < BEISCSI_ULP_COUNT; ulp_num++)
 		if (test_bit(ulp_num, &phba->fw_config.ulp_supported))
 			break;
-
+	if (ulp_num >= BEISCSI_ULP_COUNT)
+		return -ENOMEM;
 	ulp_icd_start = phba->fw_config.iscsi_icd_start[ulp_num];
 
 	arr_index = 0;
-- 
2.30.0

