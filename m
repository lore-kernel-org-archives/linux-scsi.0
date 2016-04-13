From: Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: [PATCH] mpt3sas: Remove usage of 'struct timeval'
Date: Wed, 13 Apr 2016 00:01:40 -0700
Message-ID: <20160413070140.GA35235@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:35219 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934151AbcDMJRr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2016 05:17:47 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: MPT-FusionLinux.pdl@broadcom.com
Cc: Arnd Bergmann <arnd@arndb.de>, y2038@lists.linaro.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jejb@linux.vnet.ibm.com

'struct timeval' will have its tv_sec value overflow on 32-bit systems
in year 2038 and beyond. This patch replaces the use of struct timeval
for computing mpi_request.TimeStamp, and instead uses ktime_t which provides
64-bit seconds value. The timestamp computed remains unaffected (milliseconds
since Unix epoch).

Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 8c44b9c..326c152 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -57,6 +57,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
 #include <linux/time.h>
+#include <linux/ktime.h>
 #include <linux/kthread.h>
 #include <linux/aer.h>

@@ -4387,7 +4388,7 @@ _base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 	Mpi2IOCInitRequest_t mpi_request;
 	Mpi2IOCInitReply_t mpi_reply;
 	int i, r = 0;
-	struct timeval current_time;
+	ktime_t current_time;
 	u16 ioc_status;
 	u32 reply_post_free_array_sz = 0;
 	Mpi2IOCInitRDPQArrayEntry *reply_post_free_array = NULL;
@@ -4449,9 +4450,8 @@ _base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 	/* This time stamp specifies number of milliseconds
 	 * since epoch ~ midnight January 1, 1970.
 	 */
-	do_gettimeofday(&current_time);
-	mpi_request.TimeStamp = cpu_to_le64((u64)current_time.tv_sec * 1000 +
-	    (current_time.tv_usec / 1000));
+	current_time = ktime_get_real();
+	mpi_request.TimeStamp = cpu_to_le64(ktime_to_ms(current_time));

 	if (ioc->logging_level & MPT_DEBUG_INIT) {
 		__le32 *mfp;
--
2.8.0.rc3.226.g39d4020

