From: Hifumi Hisashi <hifumi.hisashi@lab.ntt.co.jp>
Subject: [PATCH] SYNCHRONIZE_CACHE on umount
Date: Thu, 12 Jan 2006 18:07:43 +0900
Message-ID: <6.0.0.20.2.20060112180316.04202110@129.60.53.12>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:27590 "EHLO
	tama55.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1030312AbWALJHo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 04:07:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

Hi.
When a SCSI HDD(WCE bit is set) is umounted, SYNCHRONIZE_CACHE(35h)
command is not issued under current sd driver.

When an IDE HDD is umounted, FLUSH CACHE is issued through
idedisk_release().
I suppose that the sd driver also needs to flush cache through umount.

Thanks.

Signed-off-by: Hifumi Hisashi <hifumi.hisashi@lab.ntt.co.jp>

--- linux-2.6.15/drivers/scsi/sd.c      2006-01-12 16:23:44.000000000 +0900
+++ linux-2.6.15_fix/drivers/scsi/sd.c  2006-01-12 16:43:04.000000000 +0900
@@ -503,6 +503,8 @@

         SCSI_LOG_HLQUEUE(3, printk("sd_release: disk=%s\n", disk->disk_name));

+       if (sdkp->WCE)
+               sd_sync_cache(sdev);
         if (!--sdkp->openers && sdev->removable) {
                 if (scsi_block_when_processing_errors(sdev))
                         scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);

