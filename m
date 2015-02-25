From: Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: [PATCH] qla2xxx: Remove use of 'struct timeval'
Date: Wed, 25 Feb 2015 07:45:12 +0530
Message-ID: <20150225021512.GA2837@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41469 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbbBYCPX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Feb 2015 21:15:23 -0500
Received: by pdno5 with SMTP id o5so1232138pdn.8
        for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2015 18:15:23 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

struct register_host_info stores a 64-bit UTC system time timestamp.
This patch removes the use of 'struct timeval' to obtain that timestamp
as its tv_sec value will overflow on 32-bit systems in year 2038 beyond.
The patch uses ktime_get_real_seconds() which returns a 64-bit seconds value.

Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
---
 drivers/scsi/qla2xxx/qla_mr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 6d190b4..d64a64a 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -6,6 +6,7 @@
  */
 #include "qla_def.h"
 #include <linux/delay.h>
+#include <linux/ktime.h>
 #include <linux/pci.h>
 #include <linux/ratelimit.h>
 #include <linux/vmalloc.h>
@@ -1812,7 +1813,6 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 	struct host_system_info *phost_info;
 	struct register_host_info *preg_hsi;
 	struct new_utsname *p_sysid = NULL;
-	struct timeval tv;
 
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
@@ -1886,8 +1886,7 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 			    p_sysid->domainname, DOMNAME_LENGTH);
 			strncpy(phost_info->hostdriver,
 			    QLA2XXX_VERSION, VERSION_LENGTH);
-			do_gettimeofday(&tv);
-			preg_hsi->utc = (uint64_t)tv.tv_sec;
+			preg_hsi->utc = (uint64_t)ktime_get_real_seconds();
 			ql_dbg(ql_dbg_init, vha, 0x0149,
 			    "ISP%04X: Host registration with firmware\n",
 			    ha->pdev->device);
-- 
2.2.0.rc0.207.ga3a616c

