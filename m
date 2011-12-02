From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: [PATCH] [SCSI] mpt2sas: Fix possible integer truncation of
 cpu_count
Date: Fri, 2 Dec 2011 09:22:00 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A604726F2D61@inbmail02.lsi.com>
References: <1322699433-22886-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:57822 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756485Ab1LBDwH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2011 22:52:07 -0500
In-Reply-To: <1322699433-22886-1-git-send-email-roland@kernel.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, James Bottomley <jejb@kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The patch seem to be fine.
Please consider this patch as acked by me.

Regards,
Nagalakshmi


-----Original Message-----
From: Roland Dreier [mailto:roland@purestorage.com] On Behalf Of Roland Dreier
Sent: Thursday, December 01, 2011 6:01 AM
To: James E.J. Bottomley
Cc: Nandigama, Nagalakshmi; linux-scsi@vger.kernel.org
Subject: [PATCH] [SCSI] mpt2sas: Fix possible integer truncation of cpu_count

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

