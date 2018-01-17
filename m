From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] [RESEND] scsi: esas2r: use ktime_get_real_seconds()
Date: Wed, 17 Jan 2018 16:14:58 +0100
Message-ID: <20180117151508.3283064-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:63715 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753657AbeAQPPn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2018 10:15:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bradley Grove <linuxdrivers@attotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Tomas Henzl <thenzl@redhat.com>, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

do_gettimeofday() is deprecated because of the y2038 overflow.
Here, we use the result to pass into a 32-bit field in the firmware,
which still risks an overflow, but if the firmware is written
to expect unsigned values, it can at least last until y2106,
and there is not much we can do about it.

This changes do_gettimeofday() to ktime_get_real_seconds(), which
at least simplifies the code a bit, and avoids the deprecated
interface. I'm adding a comment about the overflow to document
what happens.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Originally submitted in November 2017, no reply so I'm resending
now, with Thomas and Christoph on Cc, as both have worked on
this driver in the past.
---
 drivers/scsi/esas2r/esas2r_init.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 5b14dd29b764..67b3e3354e3c 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -1223,8 +1223,6 @@ static bool esas2r_format_init_msg(struct esas2r_adapter *a,
 	case ESAS2R_INIT_MSG_START:
 	case ESAS2R_INIT_MSG_REINIT:
 	{
-		struct timeval now;
-		do_gettimeofday(&now);
 		esas2r_hdebug("CFG init");
 		esas2r_build_cfg_req(a,
 				     rq,
@@ -1233,7 +1231,8 @@ static bool esas2r_format_init_msg(struct esas2r_adapter *a,
 				     NULL);
 		ci = (struct atto_vda_cfg_init *)&rq->vrq->cfg.data.init;
 		ci->sgl_page_size = cpu_to_le32(sgl_page_size);
-		ci->epoch_time = cpu_to_le32(now.tv_sec);
+		/* firmware interface overflows in y2106 */
+		ci->epoch_time = cpu_to_le32(ktime_get_real_seconds());
 		rq->flags |= RF_FAILURE_OK;
 		a->init_msg = ESAS2R_INIT_MSG_INIT;
 		break;
-- 
2.9.0
