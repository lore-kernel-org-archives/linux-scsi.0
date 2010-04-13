From: <"huangj@blc-10-6:$"@brocade.com>
Subject: [PATCH] bfa: fix compilation warning in powerpc
Date: Tue, 13 Apr 2010 12:11:08 -0700
Message-ID: <1271185868-28661-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:51023 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857Ab0DMTLT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2010 15:11:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sfr@canb.auug.org.au, James.Bottomley@suse.de
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jing Huang <huangj@brocade.com>

From: Jing Huang <huangj@brocade.com>

Fix the compilation warning in powerpc. The same change also fixes endian
issue we found in powerpc test. This patch has been tested in x86 and
powerpc platform. it is created using scsi-misc-2.6.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_os_inc.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_os_inc.h b/drivers/scsi/bfa/bfa_os_inc.h
index 4eb1330..bd1cd3e 100644
--- a/drivers/scsi/bfa/bfa_os_inc.h
+++ b/drivers/scsi/bfa/bfa_os_inc.h
@@ -176,12 +176,12 @@ int bfa_os_MWB(void *);
 #define bfa_os_addr_t char __iomem *
 #define bfa_os_panic()
 
-#define bfa_os_reg_read(_raddr) bfa_os_wtole(readl(_raddr))
-#define bfa_os_reg_write(_raddr, _val) writel(bfa_os_wtole((_val)), (_raddr))
+#define bfa_os_reg_read(_raddr) readl(_raddr)
+#define bfa_os_reg_write(_raddr, _val) writel((_val), (_raddr))
 #define bfa_os_mem_read(_raddr, _off)                                   \
-	bfa_os_ntohl(readl(((_raddr) + (_off))))
+	bfa_os_swap32(readl(((_raddr) + (_off))))
 #define bfa_os_mem_write(_raddr, _off, _val)                            \
-	writel(bfa_os_htonl((_val)), ((_raddr) + (_off)))
+	writel(bfa_os_swap32((_val)), ((_raddr) + (_off)))
 
 #define BFA_TRC_TS(_trcm)						\
 			({						\
-- 
1.6.5.2

