From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.27-rc6
Date: Mon, 29 Sep 2008 09:10:38 -0500
Message-ID: <1222697438.3150.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60680 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759AbYI2OLJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2008 10:11:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Just three.  One is to prevent an I/O hang when we get an error on a
split request (affects USB devices with the last sector bug).  One is to
defer enabling qla2xxx interrupts until the device is fully initialised
(fixes intermittent oops on NULL deref in the driver) and one is to make
the qlogicpti fill its continuation segments correctly (fixes data
corruption on various sun systems)

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Andrew Vasquez (1):
      qla2xxx: Defer enablement of RISC interrupts until ISP initialization comp

Boaz Harrosh (1):
      qlogicpti: fix sg list traversal error in continuation entries

James Bottomley (1):
      Fix hang with split requests

And the diffstat:

 drivers/scsi/qla2xxx/qla_isr.c |    1 -
 drivers/scsi/qla2xxx/qla_os.c  |    2 ++
 drivers/scsi/qlogicpti.c       |    1 +
 drivers/scsi/scsi_lib.c        |    3 ++-
 4 files changed, 5 insertions(+), 2 deletions(-)

The entire diff is attached below.

James

---

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 45a3b93..bf41887 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1834,7 +1834,6 @@ clear_risc_ints:
 		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_HOST_INT);
 	}
 	spin_unlock_irq(&ha->hardware_lock);
-	ha->isp_ops->enable_intrs(ha);
 
 fail:
 	return ret;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 26afe44..6d0f0e5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1740,6 +1740,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		goto probe_failed;
 
+	ha->isp_ops->enable_intrs(ha);
+
 	scsi_scan_host(host);
 
 	qla2x00_alloc_sysfs_attr(ha);
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 4a1cf63..9053508 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -914,6 +914,7 @@ static inline int load_cmd(struct scsi_cmnd *Cmnd, struct Command_Entry *cmd,
 				ds[i].d_count = sg_dma_len(s);
 			}
 			sg_count -= n;
+			sg = s;
 		}
 	} else {
 		cmd->dataseg[0].d_base = 0;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ff5d56b..62307bd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -852,7 +852,7 @@ static void scsi_end_bidi_request(struct scsi_cmnd *cmd)
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	int this_count = scsi_bufflen(cmd);
+	int this_count;
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int error = 0;
@@ -908,6 +908,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	 */
 	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
 		return;
+	this_count = blk_rq_bytes(req);
 
 	/* good_bytes = 0, or (inclusive) there were leftovers and
 	 * result = 0, so scsi_end_request couldn't retry.


