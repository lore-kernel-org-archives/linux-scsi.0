Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1D9C433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Feb 2022 12:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbiBFMz5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Feb 2022 07:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235893AbiBFMzz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Feb 2022 07:55:55 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E68C06173B;
        Sun,  6 Feb 2022 04:55:53 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V3gnuuW_1644152150;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V3gnuuW_1644152150)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 06 Feb 2022 20:55:51 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, jinpu.wang@cloud.ionos.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] scsi: pm8001: clean up some inconsistent indenting
Date:   Sun,  6 Feb 2022 20:55:48 +0800
Message-Id: <20220206125548.110945-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Eliminate the follow smatch warning:
drivers/scsi/pm8001/pm8001_ctl.c:760 pm8001_update_flash() warn:
inconsistent indenting

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 65 +++++++++++++++++---------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 41a63c9b719b..213ebf39261f 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -755,36 +755,41 @@ static int pm8001_update_flash(struct pm8001_hba_info *pm8001_ha)
 			fwControl->retcode = 0;/* OUT */
 			fwControl->offset = loopNumber * IOCTL_BUF_SIZE;/*OUT */
 
-		/* for the last chunk of data in case file size is not even with
-		4k, load only the rest*/
-		if (((loopcount-loopNumber) == 1) &&
-			((partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE)) {
-			fwControl->len =
-				(partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE;
-			memcpy((u8 *)fwControl->buffer,
-				(u8 *)pm8001_ha->fw_image->data + sizeRead,
-				(partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE);
-			sizeRead +=
-				(partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE;
-		} else {
-			memcpy((u8 *)fwControl->buffer,
-				(u8 *)pm8001_ha->fw_image->data + sizeRead,
-				IOCTL_BUF_SIZE);
-			sizeRead += IOCTL_BUF_SIZE;
-		}
-
-		pm8001_ha->nvmd_completion = &completion;
-		ret = PM8001_CHIP_DISP->fw_flash_update_req(pm8001_ha, payload);
-		if (ret) {
-			pm8001_ha->fw_status = FAIL_OUT_MEMORY;
-			goto out;
-		}
-		wait_for_completion(&completion);
-		if (fwControl->retcode > FLASH_UPDATE_IN_PROGRESS) {
-			pm8001_ha->fw_status = fwControl->retcode;
-			ret = -EFAULT;
-			goto out;
-		}
+			/* for the last chunk of data in case file
+			 * size is not even with 4k, load only the rest
+			 */
+			if (((loopcount-loopNumber) == 1) &&
+				((partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE)) {
+				fwControl->len =
+					(partitionSize + HEADER_LEN) %
+					IOCTL_BUF_SIZE;
+				memcpy((u8 *)fwControl->buffer,
+					(u8 *)pm8001_ha->fw_image->data + sizeRead,
+					(partitionSize + HEADER_LEN) %
+					IOCTL_BUF_SIZE);
+				sizeRead +=
+					(partitionSize + HEADER_LEN) %
+					IOCTL_BUF_SIZE;
+			} else {
+				memcpy((u8 *)fwControl->buffer,
+					(u8 *)pm8001_ha->fw_image->data + sizeRead,
+					IOCTL_BUF_SIZE);
+				sizeRead += IOCTL_BUF_SIZE;
+			}
+
+			pm8001_ha->nvmd_completion = &completion;
+			ret = PM8001_CHIP_DISP->fw_flash_update_req(pm8001_ha,
+				payload);
+			if (ret) {
+				pm8001_ha->fw_status = FAIL_OUT_MEMORY;
+				goto out;
+			}
+			wait_for_completion(&completion);
+			if (fwControl->retcode > FLASH_UPDATE_IN_PROGRESS) {
+				pm8001_ha->fw_status = fwControl->retcode;
+				ret = -EFAULT;
+				goto out;
+			}
 		}
 	}
 out:
-- 
2.20.1.7.g153144c

