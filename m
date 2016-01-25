From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH, RESEND 3] qla2xxx: Remove use of 'struct timeval'
Date: Mon, 25 Jan 2016 23:00:20 +0100
Message-ID: <3640852.TIcaPixAiA@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:60920 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbcAYWAk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2016 17:00:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Tina Ruchandani <ruchandani.tina@gmail.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, y2038@lists.linaro.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>

From: Tina Ruchandani <ruchandani.tina@gmail.com>

struct register_host_info stores a 64-bit UTC system time timestamp.
This patch removes the use of 'struct timeval' to obtain that timestamp
as its tv_sec value will overflow on 32-bit systems in year 2038 beyond.
The patch uses ktime_get_real_seconds() which returns a 64-bit seconds value.

Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Acked-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Resent with correct author field and added Ack

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index b5029e543b91..15dff7099955 100644
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

