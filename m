From: Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: [PATCH] scsi: Remove usage of struct timeval
Date: Wed, 4 Feb 2015 08:39:54 +0530
Message-ID: <20150204030954.GA3729@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53684 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbbBDDKA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2015 22:10:00 -0500
Received: by mail-pa0-f47.google.com with SMTP id lj1so104362625pab.6
        for <linux-scsi@vger.kernel.org>; Tue, 03 Feb 2015 19:09:59 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>

struct timeval will have its tv_sec field overflow on 32-bit systems
in year 2038 and beyond. This patch removes the usage of struct timeval
and instead uses 64-bit ktime_t to get the current milliseconds
to populate pmcraid_timestamp_data.

Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
---
 drivers/scsi/pmcraid.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 8c27b6a..98af06f 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -25,6 +25,7 @@
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/types.h>
+#include <linux/ktime.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/ioport.h>
@@ -5569,11 +5570,9 @@ static void pmcraid_set_timestamp(struct pmcraid_cmd *cmd)
 	__be32 time_stamp_len = cpu_to_be32(PMCRAID_TIMESTAMP_LEN);
 	struct pmcraid_ioadl_desc *ioadl = ioarcb->add_data.u.ioadl;
 
-	struct timeval tv;
 	__le64 timestamp;
 
-	do_gettimeofday(&tv);
-	timestamp = tv.tv_sec * 1000;
+	timestamp = ktime_to_ms(ktime_get_real());
 
 	pinstance->timestamp_data->timestamp[0] = (__u8)(timestamp);
 	pinstance->timestamp_data->timestamp[1] = (__u8)((timestamp) >> 8);
-- 
2.2.0.rc0.207.ga3a616c

