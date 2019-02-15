From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.0-rc
Date: Fri, 15 Feb 2019 11:17:11 -0800
Message-ID: <1550258231.3406.15.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Two fairly small fixes: the qla one is a panic inducing use after free
and the entropy fix may seem minor but it has had huge userspace impact
thanks to an unrelated change in openssl that causes sshd to refuse
logins until it has enough entropy for the session keys, which causes
tens of minutes delay before the affected systems allow logins after
reboot.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bill Kuzeja (1):
      scsi: qla2xxx: Fix panic from use after free in qla2x00_async_tm_cmd

James Bottomley (1):
      scsi: sd: fix entropy gathering for most rotational disks

And the diffstat:

 drivers/scsi/qla2xxx/qla_init.c |  4 ++--
 drivers/scsi/sd.c               | 12 +++++++++---
 2 files changed, 11 insertions(+), 5 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 364bb52ed2a6..109587e62983 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1785,13 +1785,13 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 
 		/* Issue Marker IOCB */
 		qla2x00_marker(vha, vha->hw->req_q_map[0],
-		    vha->hw->rsp_q_map[0], sp->fcport->loop_id, lun,
+		    vha->hw->rsp_q_map[0], fcport->loop_id, lun,
 		    flags == TCF_LUN_RESET ? MK_SYNC_ID_LUN : MK_SYNC_ID);
 	}
 
 done_free_sp:
 	sp->free(sp);
-	sp->fcport->flags &= ~FCF_ASYNC_SENT;
+	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
 	return rval;
 }
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b2da8a00ec33..5464d467e23e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2951,9 +2951,6 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 	if (rot == 1) {
 		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
 		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
-	} else {
-		blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
-		blk_queue_flag_set(QUEUE_FLAG_ADD_RANDOM, q);
 	}
 
 	if (sdkp->device->type == TYPE_ZBC) {
@@ -3090,6 +3087,15 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
 
+		/*
+		 * set the default to rotational.  All non-rotational devices
+		 * support the block characteristics VPD page, which will
+		 * cause this to be updated correctly and any device which
+		 * doesn't support it should be treated as rotational.
+		 */
+		blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
+		blk_queue_flag_set(QUEUE_FLAG_ADD_RANDOM, q);
+
 		if (scsi_device_supports_vpd(sdp)) {
 			sd_read_block_provisioning(sdkp);
 			sd_read_block_limits(sdkp);
