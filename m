From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 01/11] mpt2sas: Corrected time stamp
Date: Wed, 17 Mar 2010 16:21:33 +0530
Message-ID: <20100317105121.GB21264@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:51635 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754337Ab0CQLWb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2010 07:22:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


incorrect timestamp on 32 bit platforms: The upper 32 bit of
the timestamp was getting truncated when converting seconds to
milliseconds, which was due to the variable being long. To fix the problem,
the variable needs to be u64. Also the microseconds conversion to
milliseconds was incorrect; it should be divide by 1000 instead of divide by
8.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---


diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index da4bfbf..79ab9fa 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3006,8 +3006,8 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	 * since epoch ~ midnight January 1, 1970.
 	 */
 	do_gettimeofday(&current_time);
-	mpi_request.TimeStamp = (current_time.tv_sec * 1000) +
-	    (current_time.tv_usec >> 3);
+	mpi_request.TimeStamp = cpu_to_le64((u64)current_time.tv_sec * 1000 +
+	    (current_time.tv_usec / 1000));
 
 	if (ioc->logging_level & MPT_DEBUG_INIT) {
 		u32 *mfp;
