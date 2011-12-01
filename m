From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] [SCSI] mpt2sas: Fix possible integer truncation of cpu_count
Date: Wed, 30 Nov 2011 16:30:33 -0800
Message-ID: <1322699433-22886-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog103.obsmtp.com ([74.125.245.74]:60025 "HELO
	na3sys010aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753001Ab1LAAaj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2011 19:30:39 -0500
Received: by mail-gx0-f170.google.com with SMTP id v1so658050ggn.29
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2011 16:30:38 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>, linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

When computing reply_queue_count (the number of MSI-X vectors to use),
the driver does

	ioc->reply_queue_count = min_t(u8, ioc->cpu_count,
	    ioc->msix_vector_count);

However, on a big machine, ioc->cpu_count could be outside the range
that fits in a u8; eg a system with 256 CPUs will end up
reply_queue_count set to 0.

Fix this by calculating the minimum as ints and then letting the
assignment to reply_queue_count handle integer demotion.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index beda04a..9596ced 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1346,7 +1346,7 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 	if (_base_check_enable_msix(ioc) != 0)
 		goto try_ioapic;
 
-	ioc->reply_queue_count = min_t(u8, ioc->cpu_count,
+	ioc->reply_queue_count = min_t(int, ioc->cpu_count,
 	    ioc->msix_vector_count);
 
 	entries = kcalloc(ioc->reply_queue_count, sizeof(struct msix_entry),
-- 
1.7.5.4

