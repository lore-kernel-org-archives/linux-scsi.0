From: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 4/7] fcoe,
	libfc: fix an libfc issue with queue ramp down in libfc
Date: Thu, 15 Oct 2009 17:46:55 -0700
Message-ID: <20091016004655.22451.7688.stgit@vifc.jf.intel.com>
References: <20091016004639.22451.76363.stgit@vifc.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <20091016004639.22451.76363.stgit-M4Lc0Xp98oKtqXYlAKuG4QC/G2K4zDHf@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, christof.schmitt-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

The cmd_per_lun value is used by scsi-ml as fall back lowest
queue_depth value but in case of libfc cmd_per_lun is set to
same value as max queue_depth = 32.

So this patch reduces cmd_per_lun value to 3 and configures
each lun with default max queue_depth 32 in fc_slave_alloc.

Signed-off-by: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/scsi/fcoe/fcoe.c    |    2 +-
 drivers/scsi/libfc/fc_fcp.c |   14 ++++++--------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 704b8e0..64fd867 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -137,7 +137,7 @@ static struct scsi_host_template fcoe_shost_template = {
 	.change_queue_depth = fc_change_queue_depth,
 	.change_queue_type = fc_change_queue_type,
 	.this_id = -1,
-	.cmd_per_lun = 32,
+	.cmd_per_lun = 3,
 	.can_queue = FCOE_MAX_OUTSTANDING_COMMANDS,
 	.use_clustering = ENABLE_CLUSTERING,
 	.sg_tablesize = SG_ALL,
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 6c189be..e0916fd 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2031,18 +2031,16 @@ EXPORT_SYMBOL(fc_eh_host_reset);
 int fc_slave_alloc(struct scsi_device *sdev)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
-	int queue_depth;
 
 	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
 
-	if (sdev->tagged_supported) {
-		if (sdev->host->hostt->cmd_per_lun)
-			queue_depth = sdev->host->hostt->cmd_per_lun;
-		else
-			queue_depth = FC_FCP_DFLT_QUEUE_DEPTH;
-		scsi_activate_tcq(sdev, queue_depth);
-	}
+	if (sdev->tagged_supported)
+		scsi_activate_tcq(sdev, FC_FCP_DFLT_QUEUE_DEPTH);
+	else
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev),
+					FC_FCP_DFLT_QUEUE_DEPTH);
+
 	return 0;
 }
 EXPORT_SYMBOL(fc_slave_alloc);
