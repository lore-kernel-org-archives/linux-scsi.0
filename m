From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.9-rc1
Date: Fri, 21 Oct 2016 12:39:11 -0400
Message-ID: <1477067951.2922.56.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41232 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755972AbcJUQjP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Oct 2016 12:39:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Five small fixes.  Some of these, like the nested spinlock overwriting
saved flags and the Kasan use after free look serious, but they seem
not to have been picked up in testing or seen in the field.  The
biggest user visible issue is probably the wrong device handler for
Clariion, which means that alua doesn't bind to the array like it
should.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Brian King (1):
      scsi: ipr: Fix async error WARN_ON

Dan Carpenter (1):
      scsi: zfcp: spin_lock_irqsave() is not nestable

Ming Lei (2):
      scsi: Remove one useless stack variable
      scsi: Fix use-after-free

Xose Vazquez Perez (1):
      scsi: Replace wrong device handler name for CLARiiON arrays

And the diffstat:

 drivers/s390/scsi/zfcp_dbf.c | 2 +-
 drivers/scsi/ipr.c           | 3 +--
 drivers/scsi/scsi_dh.c       | 6 +++---
 drivers/scsi/scsi_scan.c     | 6 +-----
 4 files changed, 6 insertions(+), 11 deletions(-)

With full diff below.

James

---

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 637cf89..5810019 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -384,7 +384,7 @@ void zfcp_dbf_san(char *tag, struct zfcp_dbf *dbf,
 	/* if (len > rec_len):
 	 * dump data up to cap_len ignoring small duplicate in rec->payload
 	 */
-	spin_lock_irqsave(&dbf->pay_lock, flags);
+	spin_lock(&dbf->pay_lock);
 	memset(payload, 0, sizeof(*payload));
 	memcpy(payload->area, paytag, ZFCP_DBF_TAG_LEN);
 	payload->fsf_req_id = req_id;
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index a8762a3..5324741 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -2586,7 +2586,6 @@ static void ipr_process_error(struct ipr_cmnd *ipr_cmd)
 	struct ipr_hostrcb *hostrcb = ipr_cmd->u.hostrcb;
 	u32 ioasc = be32_to_cpu(ipr_cmd->s.ioasa.hdr.ioasc);
 	u32 fd_ioasc;
-	char *envp[] = { "ASYNC_ERR_LOG=1", NULL };
 
 	if (ioa_cfg->sis64)
 		fd_ioasc = be32_to_cpu(hostrcb->hcam.u.error64.fd_ioasc);
@@ -2607,8 +2606,8 @@ static void ipr_process_error(struct ipr_cmnd *ipr_cmd)
 	}
 
 	list_add_tail(&hostrcb->queue, &ioa_cfg->hostrcb_report_q);
+	schedule_work(&ioa_cfg->work_q);
 	hostrcb = ipr_get_free_hostrcb(ioa_cfg);
-	kobject_uevent_env(&ioa_cfg->host->shost_dev.kobj, KOBJ_CHANGE, envp);
 
 	ipr_send_hcam(ioa_cfg, IPR_HCAM_CDB_OP_CODE_LOG_DATA, hostrcb);
 }
diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 54d446c..b8d3b97 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -36,9 +36,9 @@ struct scsi_dh_blist {
 };
 
 static const struct scsi_dh_blist scsi_dh_blist[] = {
-	{"DGC", "RAID",			"clariion" },
-	{"DGC", "DISK",			"clariion" },
-	{"DGC", "VRAID",		"clariion" },
+	{"DGC", "RAID",			"emc" },
+	{"DGC", "DISK",			"emc" },
+	{"DGC", "VRAID",		"emc" },
 
 	{"COMPAQ", "MSA1000 VOLUME",	"hp_sw" },
 	{"COMPAQ", "HSV110",		"hp_sw" },
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 212e98d..6f7128f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1307,7 +1307,6 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
 static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 				enum scsi_scan_mode rescan)
 {
-	char devname[64];
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	unsigned int length;
 	u64 lun;
@@ -1349,9 +1348,6 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 		}
 	}
 
-	sprintf(devname, "host %d channel %d id %d",
-		shost->host_no, sdev->channel, sdev->id);
-
 	/*
 	 * Allocate enough to hold the header (the same size as one scsi_lun)
 	 * plus the number of luns we are requesting.  511 was the default
@@ -1470,12 +1466,12 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
  out_err:
 	kfree(lun_data);
  out:
-	scsi_device_put(sdev);
 	if (scsi_device_created(sdev))
 		/*
 		 * the sdev we used didn't appear in the report luns scan
 		 */
 		__scsi_remove_device(sdev);
+	scsi_device_put(sdev);
 	return ret;
 }
 
