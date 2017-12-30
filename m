From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.15-rc5
Date: Sat, 30 Dec 2017 14:25:30 -0800
Message-ID: <1514672730.3109.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Two simple fixes, both of which cause I/O hangs.  The storvsc one is
from the hyper-v which can hang under certain hot add/remove conditions
and the other is generally, where removing a target and a device in
close proximity can result in the release method being executed twice
(and subsequent list and other corruption and an eventual panic).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Cathy Avery (1):
      scsi: storvsc: Fix scsi_cmd error assignments in storvsc_handle_error

Hannes Reinecke (1):
      scsi: core: check for device state in __scsi_remove_target()

And the diffstat:


 drivers/scsi/scsi_sysfs.c  | 5 ++++-
 drivers/scsi/storvsc_drv.c | 3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index a9996c16f4ae..26ce17178401 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1415,7 +1415,10 @@ static void __scsi_remove_target(struct scsi_target *starget)
 		 * check.
 		 */
 		if (sdev->channel != starget->channel ||
-		    sdev->id != starget->id ||
+		    sdev->id != starget->id)
+			continue;
+		if (sdev->sdev_state == SDEV_DEL ||
+		    sdev->sdev_state == SDEV_CANCEL ||
 		    !get_device(&sdev->sdev_gendev))
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 1b06cf0375dc..3b3d1d050cac 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -953,10 +953,11 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 		case TEST_UNIT_READY:
 			break;
 		default:
-			set_host_byte(scmnd, DID_TARGET_FAILURE);
+			set_host_byte(scmnd, DID_ERROR);
 		}
 		break;
 	case SRB_STATUS_INVALID_LUN:
+		set_host_byte(scmnd, DID_NO_CONNECT);
 		do_work = true;
 		process_err_fn = storvsc_remove_lun;
 		break;
