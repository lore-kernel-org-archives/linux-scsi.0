From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 04/18] be2iscsi: Fix MSIX support in SKH-R to 32
Date: Fri,  5 Apr 2013 20:38:24 -0700
Message-ID: <1365219519-3457-4-git-send-email-jayamohan.kallickal@emulex.com>
References: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:53799 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162255Ab3DFDiz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Apr 2013 23:38:55 -0400
Received: by mail-pb0-f52.google.com with SMTP id mc8so2316210pbc.11
        for <linux-scsi@vger.kernel.org>; Fri, 05 Apr 2013 20:38:54 -0700 (PDT)
In-Reply-To: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

This patch limits the max number of msix vectors to 32.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |    1 +
 drivers/scsi/be2iscsi/be_main.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 3fb997f..72e4052 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4835,6 +4835,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	case OC_SKH_ID1:
 		phba->generation = BE_GEN4;
 		phba->iotask_fn = beiscsi_iotask_v2;
+		break;
 	default:
 		phba->generation = 0;
 	}
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 5946577..e53d087 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -66,7 +66,7 @@
 
 #define MAX_CPUS		64
 #define BEISCSI_MAX_NUM_CPUS	7
-#define OC_SKH_MAX_NUM_CPUS	63
+#define OC_SKH_MAX_NUM_CPUS	31
 
 
 #define BEISCSI_SGLIST_ELEMENTS	30
-- 
1.7.10.4

