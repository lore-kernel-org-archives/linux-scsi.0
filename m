From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] SCSI: Decode UNMAP bit in WRITE SAME(10)
Date: Tue, 08 Mar 2011 02:05:01 -0500
Message-ID: <yq1wrkaccte.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:34174 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab1CHHFM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2011 02:05:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com


As of SBC3r26 WRITE SAME(10) supports the UNMAP bit.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index b587289..2bea4f0 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -59,6 +59,10 @@ scsi_trace_rw10(struct trace_seq *p, unsigned char *cdb, int len)
 	trace_seq_printf(p, "lba=%llu txlen=%llu protect=%u",
 			 (unsigned long long)lba, (unsigned long long)txlen,
 			 cdb[1] >> 5);
+
+	if (cdb[0] == WRITE_SAME)
+		trace_seq_printf(p, " unmap=%u", cdb[1] >> 3 & 1);
+
 	trace_seq_putc(p, 0);
 
 	return ret;
