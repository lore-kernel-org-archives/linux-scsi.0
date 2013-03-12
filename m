From: jayamohank@gmail.com
Subject: [PATCH 04/15] be2iscsi: Fix MSIx support in SKH-R to 32
Date: Mon, 11 Mar 2013 21:39:34 -0700
Message-ID: <1363063186-4902-4-git-send-email-jayamohan.kallickal@emulex.com>
References: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:36310 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3CLEkD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Mar 2013 00:40:03 -0400
Received: by mail-pb0-f43.google.com with SMTP id md12so4552401pbc.2
        for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2013 21:40:02 -0700 (PDT)
In-Reply-To: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>

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

