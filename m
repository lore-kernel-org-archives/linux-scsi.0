From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 3/10] mpt2sas : fix oops when firmware sends large sense buffer size
Date: Tue, 21 Apr 2009 15:38:43 -0600
Message-ID: <20090421213841.GD18563@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og58.obsmtp.com ([64.18.14.181]:36781 "EHLO
	chip3og58.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbZDUVhE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 17:37:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

There is a bug in firmware where the reply message frame says there is a
16kb sense buffer, when in reality its only 20 bytes.  This fix insures
the memcpy action doesn't corrupte the memory beyond the 90 bytes allocated in
the scsi command for sense buffer.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uarpN a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
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
