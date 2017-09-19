From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.14-rc1
Date: Tue, 19 Sep 2017 16:37:19 -0700
Message-ID: <1505864239.2971.42.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of five small fixes: one is a null deref fix which is
pretty critical for the fc transport class and one fixes a potential
security issue of sg leaking kernel information.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Arnd Bergmann (1):
      scsi: acornscsi: fix build error

Christoph Hellwig (1):
      scsi: scsi_transport_fc: fix NULL pointer dereference in fc_bsg_job_timeout

Hannes Reinecke (2):
      scsi: sg: fixup infoleak when using SG_GET_REQUEST_TABLE
      scsi: sg: factor out sg_fill_request_table()

Lukas Czerner (1):
      scsi: sd: Remove unnecessary condition in sd_read_block_limits()

and the diffstat:

 drivers/scsi/arm/acornscsi.c     |  6 ++--
 drivers/scsi/scsi_transport_fc.c |  2 +-
 drivers/scsi/sd.c                |  2 --
 drivers/scsi/sg.c                | 64 ++++++++++++++++++++++------------------
 4 files changed, 40 insertions(+), 34 deletions(-)

With full diff below

James

---

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 690816f3c6af..421fe869a11e 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2725,9 +2725,9 @@ int acornscsi_abort(struct scsi_cmnd *SCpnt)
  * Params   : SCpnt  - command causing reset
  * Returns  : one of SCSI_RESET_ macros
  */
-int acornscsi_host_reset(struct Scsi_Host *shpnt)
+int acornscsi_host_reset(struct scsi_cmnd *SCpnt)
 {
-	AS_Host *host = (AS_Host *)shpnt->hostdata;
+	AS_Host *host = (AS_Host *)SCpnt->device->host->hostdata;
 	struct scsi_cmnd *SCptr;
     
     host->stats.resets += 1;
@@ -2741,7 +2741,7 @@ int acornscsi_host_reset(struct Scsi_Host *shpnt)
 
 	printk(KERN_WARNING "acornscsi_reset: ");
 	print_sbic_status(asr, ssr, host->scsi.phase);
-	for (devidx = 0; devidx < 9; devidx ++) {
+	for (devidx = 0; devidx < 9; devidx++)
 	    acornscsi_dumplog(host, devidx);
     }
 #endif
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 3c6bc0081fcb..ba9d70f8a6a1 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3571,7 +3571,7 @@ fc_vport_sched_delete(struct work_struct *work)
 static enum blk_eh_timer_return
 fc_bsg_job_timeout(struct request *req)
 {
-	struct bsg_job *job = (void *) req->special;
+	struct bsg_job *job = blk_mq_rq_to_pdu(req);
 	struct Scsi_Host *shost = fc_bsg_to_shost(job);
 	struct fc_rport *rport = fc_bsg_to_rport(job);
 	struct fc_internal *i = to_fc_internal(shost->transportt);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 11c1738c2100..fb9f8b5f4673 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2915,8 +2915,6 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 				sd_config_discard(sdkp, SD_LBP_WS16);
 			else if (sdkp->lbpws10)
 				sd_config_discard(sdkp, SD_LBP_WS10);
-			else if (sdkp->lbpu && sdkp->max_unmap_blocks)
-				sd_config_discard(sdkp, SD_LBP_UNMAP);
 			else
 				sd_config_discard(sdkp, SD_LBP_DISABLE);
 		}
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index cf0e71db9e51..0419c2298eab 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -828,6 +828,39 @@ static int max_sectors_bytes(struct request_queue *q)
 	return max_sectors << 9;
 }
 
+static void
+sg_fill_request_table(Sg_fd *sfp, sg_req_info_t *rinfo)
+{
+	Sg_request *srp;
+	int val;
+	unsigned int ms;
+
+	val = 0;
+	list_for_each_entry(srp, &sfp->rq_list, entry) {
+		if (val > SG_MAX_QUEUE)
+			break;
+		rinfo[val].req_state = srp->done + 1;
+		rinfo[val].problem =
+			srp->header.masked_status &
+			srp->header.host_status &
+			srp->header.driver_status;
+		if (srp->done)
+			rinfo[val].duration =
+				srp->header.duration;
+		else {
+			ms = jiffies_to_msecs(jiffies);
+			rinfo[val].duration =
+				(ms > srp->header.duration) ?
+				(ms - srp->header.duration) : 0;
+		}
+		rinfo[val].orphan = srp->orphan;
+		rinfo[val].sg_io_owned = srp->sg_io_owned;
+		rinfo[val].pack_id = srp->header.pack_id;
+		rinfo[val].usr_ptr = srp->header.usr_ptr;
+		val++;
+	}
+}
+
 static long
 sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
@@ -1012,38 +1045,13 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 			return -EFAULT;
 		else {
 			sg_req_info_t *rinfo;
-			unsigned int ms;
 
-			rinfo = kmalloc(SZ_SG_REQ_INFO * SG_MAX_QUEUE,
-								GFP_KERNEL);
+			rinfo = kzalloc(SZ_SG_REQ_INFO * SG_MAX_QUEUE,
+					GFP_KERNEL);
 			if (!rinfo)
 				return -ENOMEM;
 			read_lock_irqsave(&sfp->rq_list_lock, iflags);
-			val = 0;
-			list_for_each_entry(srp, &sfp->rq_list, entry) {
-				if (val >= SG_MAX_QUEUE)
-					break;
-				memset(&rinfo[val], 0, SZ_SG_REQ_INFO);
-				rinfo[val].req_state = srp->done + 1;
-				rinfo[val].problem =
-					srp->header.masked_status &
-					srp->header.host_status &
-					srp->header.driver_status;
-				if (srp->done)
-					rinfo[val].duration =
-						srp->header.duration;
-				else {
-					ms = jiffies_to_msecs(jiffies);
-					rinfo[val].duration =
-						(ms > srp->header.duration) ?
-						(ms - srp->header.duration) : 0;
-				}
-				rinfo[val].orphan = srp->orphan;
-				rinfo[val].sg_io_owned = srp->sg_io_owned;
-				rinfo[val].pack_id = srp->header.pack_id;
-				rinfo[val].usr_ptr = srp->header.usr_ptr;
-				val++;
-			}
+			sg_fill_request_table(sfp, rinfo);
 			read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 			result = __copy_to_user(p, rinfo,
 						SZ_SG_REQ_INFO * SG_MAX_QUEUE);
