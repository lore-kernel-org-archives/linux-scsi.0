From: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org
Subject: [PATCH 05/13] libfc: rename target reset
Date: Sun, 29 Jun 2008 13:23:55 -0500
Message-ID: <1214763843-5548-6-git-send-email-michaelc@cs.wisc.edu>
References: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-2-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-3-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-4-git-send-email-michaelc@cs.wisc.edu>
	<1214763843-5548-5-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1214763843-5548-5-git-send-email-michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

Rename target reset function to lun reset because that is what it sends.
Also make it static because it is not exported and not used in other
files.

Signed-off-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
---
 drivers/scsi/libfc/fc_scsi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_scsi.c b/drivers/scsi/libfc/fc_scsi.c
index a438aa0..ec7f3dd 100644
--- a/drivers/scsi/libfc/fc_scsi.c
+++ b/drivers/scsi/libfc/fc_scsi.c
@@ -1128,10 +1128,10 @@ retry:
 }
 
 /*
- * Scsi target reset handler- send a LUN RESET to the device
+ * Scsi device reset handler- send a LUN RESET to the device
  * and wait for reset reply
  */
-int fc_target_reset(struct fc_lport *lp, struct fc_scsi_pkt *fsp)
+static int fc_lun_reset(struct fc_lport *lp, struct fc_scsi_pkt *fsp)
 {
 	unsigned long flags;
 	u32 idx;
@@ -2115,7 +2115,7 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 		/*
 		 * flush outstanding commands
 		 */
-		rc = fc_target_reset(lp, sp);
+		rc = fc_lun_reset(lp, sp);
 		sp->state = FC_SRB_FREE;
 		fc_scsi_pkt_free(sp);
 	}
-- 
1.5.4.1
