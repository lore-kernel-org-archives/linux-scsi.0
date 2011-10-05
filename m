From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.1-rc9
Date: Wed, 05 Oct 2011 08:25:05 -0700
Message-ID: <1317828305.7238.5.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is two oops fixes.  However, the oopses are unlikely to trigger
(although once you know how to do it, the libsas one is easy).

The head sha1 is

commit a73914c35b05d80f8ce78288e10056c91090b666

The fix is available here:

git://bedivere.hansenpartnership.com/git/scsi-rc-fixes-2.6.git

The short changelog is:

Mark Salyzyn (1):
      libsas: fix panic when single phy is disabled on a wide port

Roland Dreier (1):
      qla2xxx: Fix crash in qla2x00_abort_all_cmds() on unload

And the diffstat:

 drivers/scsi/libsas/sas_expander.c |   10 ++++++----
 drivers/scsi/qla2xxx/qla_os.c      |    9 +++++----
 2 files changed, 11 insertions(+), 8 deletions(-)

Full diff is below

James

---

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index c9e3dc0..16ad97d 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1769,10 +1769,12 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
 		sas_disable_routing(parent, phy->attached_sas_addr);
 	}
 	memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
-	sas_port_delete_phy(phy->port, phy->phy);
-	if (phy->port->num_phys == 0)
-		sas_port_delete(phy->port);
-	phy->port = NULL;
+	if (phy->port) {
+		sas_port_delete_phy(phy->port, phy->phy);
+		if (phy->port->num_phys == 0)
+			sas_port_delete(phy->port);
+		phy->port = NULL;
+	}
 }
 
 static int sas_discover_bfs_by_root_level(struct domain_device *root,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4cace3f..1e69527 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1328,10 +1328,9 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 					qla2x00_sp_compl(ha, sp);
 				} else {
 					ctx = sp->ctx;
-					if (ctx->type == SRB_LOGIN_CMD ||
-					    ctx->type == SRB_LOGOUT_CMD) {
-						ctx->u.iocb_cmd->free(sp);
-					} else {
+					if (ctx->type == SRB_ELS_CMD_RPT ||
+					    ctx->type == SRB_ELS_CMD_HST ||
+					    ctx->type == SRB_CT_CMD) {
 						struct fc_bsg_job *bsg_job =
 						    ctx->u.bsg_job;
 						if (bsg_job->request->msgcode
@@ -1343,6 +1342,8 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 						kfree(sp->ctx);
 						mempool_free(sp,
 							ha->srb_mempool);
+					} else {
+						ctx->u.iocb_cmd->free(sp);
 					}
 				}
 			}
