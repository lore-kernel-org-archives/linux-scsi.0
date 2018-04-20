From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] [RESEND 2] scsi: esas2r: use ktime_get_real_seconds()
Date: Fri, 20 Apr 2018 18:02:09 +0200
Message-ID: <20180420160219.3560091-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bradley Grove <linuxdrivers@attotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Tomas Henzl <thenzl@redhat.com>, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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
Originally submitted in November 2017, no reply.
Sent again in January, still no reply.

Resending once more now, could you please apply the trivial patch?
---
 drivers/scsi/esas2r/esas2r_init.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 9dffcb28c9b7..9db645dde35e 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -1202,8 +1202,6 @@ static bool esas2r_format_init_msg(struct esas2r_adapter *a,
 	case ESAS2R_INIT_MSG_START:
 	case ESAS2R_INIT_MSG_REINIT:
 	{
-		struct timeval now;
-		do_gettimeofday(&now);
 		esas2r_hdebug("CFG init");
 		esas2r_build_cfg_req(a,
 				     rq,
@@ -1212,7 +1210,8 @@ static bool esas2r_format_init_msg(struct esas2r_adapter *a,
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
