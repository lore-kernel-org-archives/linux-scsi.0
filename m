From: Hiral Patel <hiralpat@cisco.com>
Subject: [PATCH 04/10] fnic: Fix SGEs limit
Date: Tue, 12 Feb 2013 17:00:59 -0800
Message-ID: <1360717265-14130-2-git-send-email-hiralpat@cisco.com>
References: <1360717265-14130-1-git-send-email-hiralpat@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtv-iport-1.cisco.com ([173.36.130.12]:6230 "EHLO
	mtv-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab3BMBG6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2013 20:06:58 -0500
In-Reply-To: <1360717265-14130-1-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, Hiral Patel <hiralpat@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>

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

