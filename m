From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 3/4] mpt2sas: fix oops when firmware sends large sense buffer size
Date: Thu, 9 Apr 2009 03:43:02 -0600
Message-ID: <20090409094300.GA7077@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og59.obsmtp.com ([64.18.14.183]:46431 "EHLO
	chip3og59.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937458AbZDIXjh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2009 19:39:37 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id n39NHqsU028036
	for <linux-scsi@vger.kernel.org>; Thu, 9 Apr 2009 16:17:52 -0700 (PDT)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id n39NHr4e030401
	for <linux-scsi@vger.kernel.org>; Thu, 9 Apr 2009 16:17:53 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

There is a bug in firmware where the reply message frame says there is a
16kb sense buffer, when in reality its only 20 bytes.  This fix insures
the memcpy action doesn't corrupte the memory beyond the 90 bytes allocated in
the scsi command for sense buffer.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uaprN a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2009-04-09 16:33:21.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2009-04-09 16:42:31.000000000 -0600
@@ -2863,8 +2863,9 @@ scsih_io_done(struct MPT2SAS_ADAPTER *io
 		struct sense_info data;
 		const void *sense_data = mpt2sas_base_get_sense_buffer(ioc,
 		    smid);
-		memcpy(scmd->sense_buffer, sense_data,
+		u32 sz = min_t(u32, SCSI_SENSE_BUFFERSIZE,
 		    le32_to_cpu(mpi_reply->SenseCount));
+		memcpy(scmd->sense_buffer, sense_data, sz);
 		_scsih_normalize_sense(scmd->sense_buffer, &data);
 		/* failure prediction threshold exceeded */
 		if (data.asc == 0x5D)
