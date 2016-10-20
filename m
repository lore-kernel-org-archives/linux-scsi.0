From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 02/10] mpt3sas: Fix for incorrect numbers for MSIX vectors  enabled when  non RDPQ card is enumerated first.
Date: Thu, 20 Oct 2016 17:50:10 +0530
Message-ID: <1476966018-10457-3-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:33930 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757934AbcJTMVH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2016 08:21:07 -0400
Received: by mail-qk0-f179.google.com with SMTP id f128so87110172qkb.1
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2016 05:21:07 -0700 (PDT)
In-Reply-To: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, Sathya Prakash <sathya.prakash@broadcom.com>

No. of MSIX vectors supported = min (Total no. of CPU cores,
MSIX vectors supported by card)

when RDPQ is disabled "max_msix_vectors" module parameter which was
declared as global was set to '8' and hence if there are more than one card
in system among which if RDPQ disabled card is enumerated first then only 8
MSIX vectors was getting enabled for all the cards(including RDPQ enabled
card,which can support more than 8 MSIX vectors).

Used local variable instead of global variable ,if RDPQ is disabled this
local variable is set to '8' else it is set to "max_msix_vectors" (by
default this is set to -1, whose value can be set by user during driver
load time).So now regardless of whether RDPQ disabled card is enumerated
first or RDPQ enabled card is enumerated first , MSIX vectors enabled
depends on the cards capability.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index a1a5ceb..4ea81e1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1959,7 +1959,7 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 {
 	struct msix_entry *entries, *a;
 	int r;
-	int i;
+	int i, local_max_msix_vectors;
 	u8 try_msix = 0;
 
 	if (msix_disable == -1 || msix_disable == 0)
@@ -1979,13 +1979,15 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	  ioc->cpu_count, max_msix_vectors);
 
 	if (!ioc->rdpq_array_enable && max_msix_vectors == -1)
-		max_msix_vectors = 8;
+		local_max_msix_vectors = 8;
+	else
+		local_max_msix_vectors = max_msix_vectors;
 
-	if (max_msix_vectors > 0) {
-		ioc->reply_queue_count = min_t(int, max_msix_vectors,
+	if (local_max_msix_vectors > 0) {
+		ioc->reply_queue_count = min_t(int, local_max_msix_vectors,
 			ioc->reply_queue_count);
 		ioc->msix_vector_count = ioc->reply_queue_count;
-	} else if (max_msix_vectors == 0)
+	} else if (local_max_msix_vectors == 0)
 		goto try_ioapic;
 
 	if (ioc->msix_vector_count < ioc->cpu_count)
-- 
1.8.3.1

