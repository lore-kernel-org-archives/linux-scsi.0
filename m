From: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 3/7] libfc: convert libfc calling
	scsi_track_queue_full
Date: Thu, 15 Oct 2009 17:46:50 -0700
Message-ID: <20091016004650.22451.31779.stgit@vifc.jf.intel.com>
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

From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

This converts the libfc using scsi_track_queue_full to
track the queue full from the change_queue_depth callback.

Signed-off-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Signed-off-by: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/scsi/libfc/fc_fcp.c |   27 +++++++++------------------
 1 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 958788f..6c189be 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1814,21 +1814,6 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 			sc_cmd->result = DID_OK << 16;
 			if (fsp->scsi_resid)
 				CMD_RESID_LEN(sc_cmd) = fsp->scsi_resid;
-		} else if (fsp->cdb_status == QUEUE_FULL) {
-			struct scsi_device *tmp_sdev;
-			struct scsi_device *sdev = sc_cmd->device;
-
-			shost_for_each_device(tmp_sdev, sdev->host) {
-				if (tmp_sdev->id != sdev->id)
-					continue;
-
-				if (tmp_sdev->queue_depth > 1) {
-					scsi_track_queue_full(tmp_sdev,
-							      tmp_sdev->
-							      queue_depth - 1);
-				}
-			}
-			sc_cmd->result = (DID_OK << 16) | fsp->cdb_status;
 		} else {
 			/*
 			 * transport level I/O was ok but scsi
@@ -2064,10 +2049,16 @@ EXPORT_SYMBOL(fc_slave_alloc);
 
 int fc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
-	if (reason != SCSI_QDEPTH_DEFAULT)
+	switch (reason) {
+	case SCSI_QDEPTH_DEFAULT:
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+		break;
+	case SCSI_QDEPTH_QFULL:
+		scsi_track_queue_full(sdev, qdepth);
+		break;
+	default:
 		return -EOPNOTSUPP;
-
-	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+	}
 	return sdev->queue_depth;
 }
 EXPORT_SYMBOL(fc_change_queue_depth);
