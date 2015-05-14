From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] scsi: fix Wunused-but-set-variable buildwarning
Date: Thu, 14 May 2015 20:12:46 +0200
Message-ID: <1431627166-12729-1-git-send-email-hofrat@osadl.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vasu Dev <vasu.dev@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
List-Id: linux-scsi@vger.kernel.org

commit "[SCSI] libfc: remove tgt_flags from fc_fcp_pkt struct"
removed the last usage of rpriv (rpriv->flags) but forgot to remove
the unused rpriv struct resulting in:
  drivers/scsi/libfc/fc_fcp.c: In function 'fc_queuecommand':
  drivers/scsi/libfc/fc_fcp.c:1795:30: warning: variable 'rpriv' set 
  but not used [-Wunused-but-set-variable]
so simply drop its declaration and setting.

Patch was compile tested with x86_64_defconfig + SCSI_LOWLEVEL=y,
CONFIG_SCSI_FC_ATTRS=m, CONFIG_LIBFC=m

Patch is against 4.1-rc3 (localversion-next is -next-20150514)

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

 drivers/scsi/libfc/fc_fcp.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index c438b81..fee6928 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1792,7 +1792,6 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 	struct fc_lport *lport = shost_priv(shost);
 	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
 	struct fc_fcp_pkt *fsp;
-	struct fc_rport_libfc_priv *rpriv;
 	int rval;
 	int rc = 0;
 	struct fc_stats *stats;
@@ -1814,8 +1813,6 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 		goto out;
 	}
 
-	rpriv = rport->dd_data;
-
 	if (!fc_fcp_lport_queue_ready(lport)) {
 		if (lport->qfull)
 			fc_fcp_can_queue_ramp_down(lport);
-- 
1.7.10.4
