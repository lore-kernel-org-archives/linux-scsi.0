From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 4/7] scsi: trace: fix transfer length 0 for 6-byte r/w commands
Date: Sat, 16 May 2015 16:17:50 +0900
Message-ID: <1431760673-7180-5-git-send-email-akinobu.mita@gmail.com>
References: <1431760673-7180-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35969 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbbEPHSg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 May 2015 03:18:36 -0400
Received: by pabts4 with SMTP id ts4so53484974pab.3
        for <linux-scsi@vger.kernel.org>; Sat, 16 May 2015 00:18:36 -0700 (PDT)
In-Reply-To: <1431760673-7180-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>

For 6-byte r/w commands, transfer length 0 means 256 blocks of data,
not 0 block.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_trace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index 08bb47b..104e817 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -35,6 +35,8 @@ scsi_trace_rw6(struct trace_seq *p, unsigned char *cdb, int len)
 	lba |=  (cdb[2] << 8);
 	lba |=   cdb[3];
 	txlen = cdb[4];
+	if (txlen == 0)
+		txlen = 256;
 
 	trace_seq_printf(p, "lba=%llu txlen=%llu",
 			 (unsigned long long)lba, (unsigned long long)txlen);
-- 
1.9.1

