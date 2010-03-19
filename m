From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 5/5] bfa: sg addr big endian fix
Date: Fri, 19 Mar 2010 11:07:36 -0700
Message-ID: <1269022056-13611-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:34423 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865Ab0CSSRs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Mar 2010 14:17:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com

sg address in IO request is not set up correctly for big endian platform.
add new macros to properly swap the address.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_ioim.c   |    4 ++--
 drivers/scsi/bfa/bfa_os_inc.h |   15 +++++++++++++++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioim.c b/drivers/scsi/bfa/bfa_ioim.c
index 8a1be20..687f3d6 100644
--- a/drivers/scsi/bfa/bfa_ioim.c
+++ b/drivers/scsi/bfa/bfa_ioim.c
@@ -758,7 +758,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	sge = &m->sges[0];
 	if (ioim->nsges) {
 		sg = (struct scatterlist *)scsi_sglist(cmnd);
-		addr = (u64) sg_dma_address(sg);
+		addr = bfa_os_sgaddr(sg_dma_address(sg));
 		sge->sga = *(union bfi_addr_u *) &addr;
 		pgdlen = sg_dma_len(sg);
 		sge->sg_len = pgdlen;
@@ -891,7 +891,7 @@ bfa_ioim_sgpg_setup(struct bfa_ioim_s *ioim)
 
 		pgcumsz = 0;
 		for (i = 0; i < nsges; i++, sge++, sgeid++, sg = sg_next(sg)) {
-			addr = (u64) sg_dma_address(sg);
+			addr = bfa_os_sgaddr(sg_dma_address(sg));
 			sge->sga = *(union bfi_addr_u *) &addr;
 			sge->sg_len = sg_dma_len(sg);
 			pgcumsz += sge->sg_len;
diff --git a/drivers/scsi/bfa/bfa_os_inc.h b/drivers/scsi/bfa/bfa_os_inc.h
index 10a89f7..4eb1330 100644
--- a/drivers/scsi/bfa/bfa_os_inc.h
+++ b/drivers/scsi/bfa/bfa_os_inc.h
@@ -50,6 +50,10 @@
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/scsi_transport.h>
 
+#ifdef __BIG_ENDIAN
+#define __BIGENDIAN
+#endif
+
 #define BFA_ERR			KERN_ERR
 #define BFA_WARNING		KERN_WARNING
 #define BFA_NOTICE		KERN_NOTICE
@@ -123,6 +127,15 @@ int bfa_os_MWB(void *);
 	(((_x) & 0x00ff0000) >> 8)	|	\
 	(((_x) & 0xff000000) >> 24))
 
+#define bfa_os_swap_sgaddr(_x)	((u64)(					\
+	(((u64)(_x) & (u64)0x00000000000000ffull) << 32)	|	\
+	(((u64)(_x) & (u64)0x000000000000ff00ull) << 32)	|	\
+	(((u64)(_x) & (u64)0x0000000000ff0000ull) << 32)	|	\
+	(((u64)(_x) & (u64)0x00000000ff000000ull) << 32)	|	\
+	(((u64)(_x) & (u64)0x000000ff00000000ull) >> 32)	|	\
+	(((u64)(_x) & (u64)0x0000ff0000000000ull) >> 32)	|	\
+	(((u64)(_x) & (u64)0x00ff000000000000ull) >> 32)	|	\
+	(((u64)(_x) & (u64)0xff00000000000000ull) >> 32)))
 
 #ifndef __BIGENDIAN
 #define bfa_os_htons(_x) ((u16)((((_x) & 0xff00) >> 8) | \
@@ -133,6 +146,7 @@ int bfa_os_MWB(void *);
 #define bfa_os_hton3b(_x)	bfa_swap_3b(_x)
 
 #define bfa_os_wtole(_x)   (_x)
+#define bfa_os_sgaddr(_x)  (_x)
 
 #else
 
@@ -141,6 +155,7 @@ int bfa_os_MWB(void *);
 #define bfa_os_hton3b(_x)  (_x)
 #define bfa_os_htonll(_x)  (_x)
 #define bfa_os_wtole(_x)   bfa_os_swap32(_x)
+#define bfa_os_sgaddr(_x)  bfa_os_swap_sgaddr(_x)
 
 #endif
 
-- 
1.6.5.2

