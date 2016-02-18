From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v2 1/2] mpt3sas: Free memory pools before retrying to allocate with different value.
Date: Thu, 18 Feb 2016 14:09:45 +0530
Message-ID: <1455784786-19086-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34020 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030341AbcBRIkp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2016 03:40:45 -0500
Received: by mail-pa0-f43.google.com with SMTP id fy10so27074095pac.1
        for <linux-scsi@vger.kernel.org>; Thu, 18 Feb 2016 00:40:45 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>

From: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>

Deallocate resources before reallocating of the same in retry_allocation
path of _base_allocate_memory_pools()

Signed-off-by: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index afdb13a..5bbbbf2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3414,6 +3414,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc,  int sleep_flag)
 			goto out;
 		retry_sz = 64;
 		ioc->hba_queue_depth -= retry_sz;
+		_base_release_memory_pools(ioc);
 		goto retry_allocation;
 	}
 
-- 
1.8.3.1

