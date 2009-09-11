From: "Anil Veerabhadrappa" <anilgv@broadcom.com>
Subject: [PATCH 1/1] BNX2I - Fix context mapping issue for architectures
 with PAGE_SIZE != 4096
Date: Fri, 11 Sep 2009 10:38:26 -0700
Message-ID: <1252690706.27482.61.camel@anilgv-desktop>
References: <1245805860.9829.50.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3567 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755727AbZIKRid (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Sep 2009 13:38:33 -0400
In-Reply-To: <1245805860.9829.50.camel@anilgv-desktop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, michaelc@cs.wisc.edu, mchan@broadcom.com

    [BNX2I] Fix context mapping issue for architectures with PAGE_SIZE != 4096

    * 5706/5708/5709 devices allow driver/user to set page size. By default
      it is set to 4096
    * Current drivers do not program this register based on architecture type
      (e.g. x86 = 4K, IA64 = 16K) and by choice lets device use the defaults
    * So while mapping connection context memory (doorebll registers),
      driver has to match page size used by the device. Included change fixes
      the issue we uncovered during IA64 testing

Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i.h     |    2 ++
 drivers/scsi/bnx2i/bnx2i_hwi.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index d7576f2..5edde1a 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -100,6 +100,8 @@
 #define CTX_OFFSET 			0x10000
 #define MAX_CID_CNT			0x4000
 
+#define BNX2I_570X_PAGE_SIZE_DEFAULT	4096
+
 /* 5709 context registers */
 #define BNX2_MQ_CONFIG2			0x00003d00
 #define BNX2_MQ_CONFIG2_CONT_SZ		(0x7L<<4)
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 906cef5..0afde71 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -2386,7 +2386,7 @@ int bnx2i_map_ep_dbell_regs(struct bnx2i_endpoint *ep)
 		ctx_sz = (config2 & BNX2_MQ_CONFIG2_CONT_SZ) >> 3;
 		if (ctx_sz)
 			reg_off = CTX_OFFSET + MAX_CID_CNT * MB_KERNEL_CTX_SIZE
-				  + PAGE_SIZE *
+				  + BNX2I_570X_PAGE_SIZE_DEFAULT *
 				  (((cid_num - first_l4l5) / ctx_sz) + 256);
 		else
 			reg_off = CTX_OFFSET + (MB_KERNEL_CTX_SIZE * cid_num);
-- 
1.5.4.3




