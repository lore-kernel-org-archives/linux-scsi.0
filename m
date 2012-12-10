From: Hiral Patel <hiralpat@cisco.com>
Subject: [PATCH 04/10] fnic: Fix SGEs limit
Date: Mon, 10 Dec 2012 01:21:32 -0800
Message-ID: <1355131299-3313-4-git-send-email-hiralpat@cisco.com>
References: <1355131299-3313-1-git-send-email-hiralpat@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtv-iport-2.cisco.com ([173.36.130.13]:19633 "EHLO
	mtv-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab2LJJ0Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Dec 2012 04:26:24 -0500
In-Reply-To: <1355131299-3313-1-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Hiral Patel <hiralpat@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>

Driver allows IOs with more SGEs than max SGEs supported by Palo. The current max SGEs
supported by the fnic driver is 1024. The current register settings on Palo supports
a max of 256 only. Palo would return any IO with more than 256 SGEs with an error
indicating INVALID_SGLS. Fnic driver should limit the max supported SGLs in
the driver to 256 to avoid this error.

Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
Signed-off-by: Hiral Patel <hiralpat@cisco.com>
---
 drivers/scsi/fnic/fnic_io.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_io.h b/drivers/scsi/fnic/fnic_io.h
index f0b8969..3455c34 100644
--- a/drivers/scsi/fnic/fnic_io.h
+++ b/drivers/scsi/fnic/fnic_io.h
@@ -21,7 +21,7 @@
 #include <scsi/fc/fc_fcp.h>
 
 #define FNIC_DFLT_SG_DESC_CNT  32
-#define FNIC_MAX_SG_DESC_CNT        1024    /* Maximum descriptors per sgl */
+#define FNIC_MAX_SG_DESC_CNT        256     /* Maximum descriptors per sgl */
 #define FNIC_SG_DESC_ALIGN          16      /* Descriptor address alignment */
 
 struct host_sg_desc {
-- 
1.7.9.5

