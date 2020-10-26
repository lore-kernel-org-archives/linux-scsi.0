Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11346C2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 16:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5FB72242A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 16:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603728437;
	bh=UuOAjqv/tTImmhISQwNWEjfqoWITfI3gf+j5nxHvAf8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=K+ZJUVNkWUmbPg0D+1/BNt6fhli4gj56kQh5XQl8ETMMXJYRpRkBxrk5TEzlQbW+S
	 W/IUQcUxmXDig2un96rWp9pMrRWXn/E2BQWy4hz0OTQDUECzVQQ7K+6Ah/JNEfnWFf
	 0oLJJHswf5axtWhpUqQYnexaxPv0efa4Xl6vd0e8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1784965AbgJZQHO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 12:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1775114AbgJZQHO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Oct 2020 12:07:14 -0400
Received: from localhost.localdomain (unknown [192.30.34.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D83E222404;
        Mon, 26 Oct 2020 16:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603728433;
        bh=UuOAjqv/tTImmhISQwNWEjfqoWITfI3gf+j5nxHvAf8=;
        h=From:To:Cc:Subject:Date:From;
        b=AxrQslD1sIweQTaJEKAt5vEuscv8JbVCIZlj1JHhcHO9GG2H9CZgFPLIXVgqMb7ef
         gOa3o4B/I8nEjVBnHkNVP/3+ewhvHdjucgedvqQ/wNMDOCgOq9nCyUvUU5rc8/NpPK
         x/3taEhy5Ulj8EQtDFkzL12vPJmytaXGF/1QtYW4=
From:   Arnd Bergmann <arnd@kernel.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 1/2] libfc: move scsi/fc_encode.h to libfc
Date:   Mon, 26 Oct 2020 17:06:12 +0100
Message-Id: <20201026160705.3706396-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Most of this file is only used inside of libfc, so move
it to where it is actually used, with only fc_fill_fc_hdr()
left inside of the header.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/bnx2fc/bnx2fc.h                  |  1 -
 drivers/scsi/libfc/fc_elsct.c                 |  2 +-
 .../scsi => drivers/scsi/libfc}/fc_encode.h   | 30 +------------------
 drivers/scsi/libfc/fc_exch.c                  |  1 -
 drivers/scsi/libfc/fc_fcp.c                   |  2 +-
 drivers/scsi/libfc/fc_libfc.c                 |  2 +-
 drivers/scsi/libfc/fc_lport.c                 |  2 +-
 drivers/scsi/libfc/fc_rport.c                 |  2 +-
 drivers/scsi/qedf/qedf.h                      |  1 -
 drivers/target/tcm_fc/tfc_cmd.c               |  1 -
 drivers/target/tcm_fc/tfc_io.c                |  1 -
 include/scsi/fc_frame.h                       | 30 +++++++++++++++++++
 12 files changed, 36 insertions(+), 39 deletions(-)
 rename {include/scsi => drivers/scsi/libfc}/fc_encode.h (96%)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index b6e8ed757252..b4cea8b06ea1 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -51,7 +51,6 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/libfc.h>
 #include <scsi/libfcoe.h>
-#include <scsi/fc_encode.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/fc/fc_fip.h>
diff --git a/drivers/scsi/libfc/fc_elsct.c b/drivers/scsi/libfc/fc_elsct.c
index 13a2e7c33cb1..8d3006edbe12 100644
--- a/drivers/scsi/libfc/fc_elsct.c
+++ b/drivers/scsi/libfc/fc_elsct.c
@@ -15,7 +15,7 @@
 #include <scsi/fc/fc_ns.h>
 #include <scsi/fc/fc_els.h>
 #include <scsi/libfc.h>
-#include <scsi/fc_encode.h>
+#include "fc_encode.h"
 #include "fc_libfc.h"
 
 /**
diff --git a/include/scsi/fc_encode.h b/drivers/scsi/libfc/fc_encode.h
similarity index 96%
rename from include/scsi/fc_encode.h
rename to drivers/scsi/libfc/fc_encode.h
index c6660205d73f..18203cae04b2 100644
--- a/include/scsi/fc_encode.h
+++ b/drivers/scsi/libfc/fc_encode.h
@@ -9,6 +9,7 @@
 #define _FC_ENCODE_H_
 #include <asm/unaligned.h>
 #include <linux/utsname.h>
+#include <scsi/fc/fc_ms.h>
 
 /*
  * F_CTL values for simple requests and responses.
@@ -39,35 +40,6 @@ struct fc_ct_req {
 	} payload;
 };
 
-static inline void __fc_fill_fc_hdr(struct fc_frame_header *fh,
-				    enum fc_rctl r_ctl,
-				    u32 did, u32 sid, enum fc_fh_type type,
-				    u32 f_ctl, u32 parm_offset)
-{
-	WARN_ON(r_ctl == 0);
-	fh->fh_r_ctl = r_ctl;
-	hton24(fh->fh_d_id, did);
-	hton24(fh->fh_s_id, sid);
-	fh->fh_type = type;
-	hton24(fh->fh_f_ctl, f_ctl);
-	fh->fh_cs_ctl = 0;
-	fh->fh_df_ctl = 0;
-	fh->fh_parm_offset = htonl(parm_offset);
-}
-
-/**
- * fill FC header fields in specified fc_frame
- */
-static inline void fc_fill_fc_hdr(struct fc_frame *fp, enum fc_rctl r_ctl,
-				  u32 did, u32 sid, enum fc_fh_type type,
-				  u32 f_ctl, u32 parm_offset)
-{
-	struct fc_frame_header *fh;
-
-	fh = fc_frame_header_get(fp);
-	__fc_fill_fc_hdr(fh, r_ctl, did, sid, type, f_ctl, parm_offset);
-}
-
 /**
  * fc_adisc_fill() - Fill in adisc request frame
  * @lport: local port.
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 851335f09221..d71afae6191c 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -20,7 +20,6 @@
 #include <scsi/fc/fc_fc2.h>
 
 #include <scsi/libfc.h>
-#include <scsi/fc_encode.h>
 
 #include "fc_libfc.h"
 
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 7cfeb6886237..b43b5f62ee3e 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -26,8 +26,8 @@
 #include <scsi/fc/fc_fc2.h>
 
 #include <scsi/libfc.h>
-#include <scsi/fc_encode.h>
 
+#include "fc_encode.h"
 #include "fc_libfc.h"
 
 static struct kmem_cache *scsi_pkt_cachep;
diff --git a/drivers/scsi/libfc/fc_libfc.c b/drivers/scsi/libfc/fc_libfc.c
index 19c4ab4e0f4d..0e6a1355d020 100644
--- a/drivers/scsi/libfc/fc_libfc.c
+++ b/drivers/scsi/libfc/fc_libfc.c
@@ -12,8 +12,8 @@
 #include <linux/module.h>
 
 #include <scsi/libfc.h>
-#include <scsi/fc_encode.h>
 
+#include "fc_encode.h"
 #include "fc_libfc.h"
 
 MODULE_AUTHOR("Open-FCoE.org");
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 6557fda85c5c..22826544da7e 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -84,9 +84,9 @@
 #include <scsi/fc/fc_gs.h>
 
 #include <scsi/libfc.h>
-#include <scsi/fc_encode.h>
 #include <linux/scatterlist.h>
 
+#include "fc_encode.h"
 #include "fc_libfc.h"
 
 /* Fabric IDs to use for point-to-point mode, chosen on whims. */
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index a60b228d13f1..56003208d2e7 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -58,8 +58,8 @@
 #include <asm/unaligned.h>
 
 #include <scsi/libfc.h>
-#include <scsi/fc_encode.h>
 
+#include "fc_encode.h"
 #include "fc_libfc.h"
 
 static struct workqueue_struct *rport_event_queue;
diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index 0e2cbb164eeb..88a592d09433 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -11,7 +11,6 @@
 #include <scsi/fc/fc_fip.h>
 #include <scsi/fc/fc_fc2.h>
 #include <scsi/scsi_tcq.h>
-#include <scsi/fc_encode.h>
 #include <linux/version.h>
 
 
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index a7ed56602c6c..9c8c38a549c6 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -19,7 +19,6 @@
 #include <asm/unaligned.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/libfc.h>
-#include <scsi/fc_encode.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 6a38ff936389..bbe2e29612fa 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -28,7 +28,6 @@
 #include <linux/ratelimit.h>
 #include <asm/unaligned.h>
 #include <scsi/libfc.h>
-#include <scsi/fc_encode.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
diff --git a/include/scsi/fc_frame.h b/include/scsi/fc_frame.h
index 41df2ba9dbaa..d544dc5057fc 100644
--- a/include/scsi/fc_frame.h
+++ b/include/scsi/fc_frame.h
@@ -246,4 +246,34 @@ static inline bool fc_frame_is_cmd(const struct fc_frame *fp)
  */
 void fc_frame_leak_check(void);
 
+static inline void __fc_fill_fc_hdr(struct fc_frame_header *fh,
+				    enum fc_rctl r_ctl,
+				    u32 did, u32 sid, enum fc_fh_type type,
+				    u32 f_ctl, u32 parm_offset)
+{
+	WARN_ON(r_ctl == 0);
+	fh->fh_r_ctl = r_ctl;
+	hton24(fh->fh_d_id, did);
+	hton24(fh->fh_s_id, sid);
+	fh->fh_type = type;
+	hton24(fh->fh_f_ctl, f_ctl);
+	fh->fh_cs_ctl = 0;
+	fh->fh_df_ctl = 0;
+	fh->fh_parm_offset = htonl(parm_offset);
+}
+
+/**
+ * fill FC header fields in specified fc_frame
+ */
+static inline void fc_fill_fc_hdr(struct fc_frame *fp, enum fc_rctl r_ctl,
+				  u32 did, u32 sid, enum fc_fh_type type,
+				  u32 f_ctl, u32 parm_offset)
+{
+	struct fc_frame_header *fh;
+
+	fh = fc_frame_header_get(fp);
+	__fc_fill_fc_hdr(fh, r_ctl, did, sid, type, f_ctl, parm_offset);
+}
+
+
 #endif /* _FC_FRAME_H_ */
-- 
2.27.0

