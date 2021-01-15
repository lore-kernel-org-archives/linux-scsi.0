Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B59C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 09:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44E7020793
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 09:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbhAOJ7H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jan 2021 04:59:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36059 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728746AbhAOJ7G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2021 04:59:06 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1l0Ls8-0000g2-KJ; Fri, 15 Jan 2021 09:58:24 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: pm80xx: clean up indentation of a code block
Date:   Fri, 15 Jan 2021 09:58:24 +0000
Message-Id: <20210115095824.9170-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

A block of code is indented one level too deeply, clean this
up.

Addresses-Coverity: ("Indentation does not match nesting level")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 34 ++++++++++++++------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index e7fef42b4f6c..6fd206abc9fc 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -358,26 +358,22 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 					MEMBASE_II_SHIFT_REGISTER,
 					pm8001_ha->fatal_forensic_shift_offset);
 		}
-			/* Read the next block of the debug data.*/
-			length_to_read = pm8001_mr32(fatal_table_address,
-			MPI_FATAL_EDUMP_TABLE_ACCUM_LEN) -
-			pm8001_ha->forensic_preserved_accumulated_transfer;
-			if (length_to_read != 0x0) {
-				pm8001_ha->forensic_fatal_step = 0;
-				goto moreData;
-			} else {
-				pm8001_ha->forensic_info.data_buf.direct_data +=
-				sprintf(
-				pm8001_ha->forensic_info.data_buf.direct_data,
+		/* Read the next block of the debug data.*/
+		length_to_read = pm8001_mr32(fatal_table_address,
+		MPI_FATAL_EDUMP_TABLE_ACCUM_LEN) -
+		pm8001_ha->forensic_preserved_accumulated_transfer;
+		if (length_to_read != 0x0) {
+			pm8001_ha->forensic_fatal_step = 0;
+			goto moreData;
+		} else {
+			pm8001_ha->forensic_info.data_buf.direct_data +=
+			sprintf(pm8001_ha->forensic_info.data_buf.direct_data,
 				"%08x ", 4);
-				pm8001_ha->forensic_info.data_buf.read_len
-								= 0xFFFFFFFF;
-				pm8001_ha->forensic_info.data_buf.direct_len
-								=  0;
-				pm8001_ha->forensic_info.data_buf.direct_offset
-								= 0;
-				pm8001_ha->forensic_info.data_buf.read_len = 0;
-			}
+			pm8001_ha->forensic_info.data_buf.read_len = 0xFFFFFFFF;
+			pm8001_ha->forensic_info.data_buf.direct_len =  0;
+			pm8001_ha->forensic_info.data_buf.direct_offset = 0;
+			pm8001_ha->forensic_info.data_buf.read_len = 0;
+		}
 	}
 	offset = (int)((char *)pm8001_ha->forensic_info.data_buf.direct_data
 			- (char *)buf);
-- 
2.29.2

