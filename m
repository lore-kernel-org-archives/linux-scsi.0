From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 01/11] mpt3sas: set default value for cb_idx
Date: Thu, 21 Dec 2017 23:31:37 -0800
Message-ID: <1513927907-19735-2-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1513927907-19735-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:44126 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751428AbdLVHcP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Dec 2017 02:32:15 -0500
Received: by mail-wm0-f68.google.com with SMTP id t8so20002617wmc.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2017 23:32:15 -0800 (PST)
In-Reply-To: <1513927907-19735-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Hannes Reinecke <hare@suse.de>, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>

From: Hannes Reinecke <hare@suse.de>

No functional change

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
---
 drivers/scsi/mpt3sas/modules.order  | 2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c | 5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/modules.order b/drivers/scsi/mpt3sas/modules.order
index 352a4dd..5052fdf 100644
--- a/drivers/scsi/mpt3sas/modules.order
+++ b/drivers/scsi/mpt3sas/modules.order
@@ -1 +1 @@
-kernel/drivers/scsi/mpt3sas/mpt3sas.ko
+kernel//opt/upstream_io_tag/linux/drivers/scsi/mpt3sas/mpt3sas.ko
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 8027de4..0119a39 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -899,7 +899,7 @@ static u8
 _base_get_cb_idx(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
 	int i;
-	u8 cb_idx;
+	u8 cb_idx = 0xFF;
 
 	if (smid < ioc->hi_priority_smid) {
 		i = smid - 1;
@@ -910,8 +910,7 @@ _base_get_cb_idx(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 	} else if (smid <= ioc->hba_queue_depth) {
 		i = smid - ioc->internal_smid;
 		cb_idx = ioc->internal_lookup[i].cb_idx;
-	} else
-		cb_idx = 0xFF;
+	}
 	return cb_idx;
 }
 
-- 
2.5.5
