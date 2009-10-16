From: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 7/7] zfcp: Adapt change_queue_depth for queue
	full tracking
Date: Thu, 15 Oct 2009 17:47:11 -0700
Message-ID: <20091016004711.22451.2885.stgit@vifc.jf.intel.com>
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

From: Christof Schmitt <christof.schmitt-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>

Adapt the change_queue_depth callback in zfcp for the new reason
parameter. Simply pass each call back to the SCSI midlayer, there are
no resource adjustments necessary for zfcp.

Signed-off-by: Christof Schmitt <christof.schmitt-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>

Removes check for (depth <= default_depth) in case of
SCSI_QDEPTH_RAMP_UP call back, not needed after added
max_queue_depth per sdev.

Signed-off-by: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/s390/scsi/zfcp_scsi.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index ad11547..f546559 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -32,10 +32,19 @@ char *zfcp_get_fcp_sns_info_ptr(struct fcp_rsp_iu *fcp_rsp_iu)
 static int zfcp_scsi_change_queue_depth(struct scsi_device *sdev, int depth,
 					int reason)
 {
-	if (reason != SCSI_QDEPTH_DEFAULT)
+	switch (reason) {
+	case SCSI_QDEPTH_DEFAULT:
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
+		break;
+	case SCSI_QDEPTH_QFULL:
+		scsi_track_queue_full(sdev, depth);
+		break;
+	case SCSI_QDEPTH_RAMP_UP:
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
+		break;
+	default:
 		return -EOPNOTSUPP;
-
-	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
+	}
 	return sdev->queue_depth;
 }
