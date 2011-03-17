From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] libsas: check dev->gone before submitting sata i/o
Date: Wed, 16 Mar 2011 17:55:00 -0700
Message-ID: <20110317005339.24231.41265.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: james.bottomley@suse.de
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jeffrey.d.skirvin@intel.com, jacek.danecki@intel.com, linux-ide@vger.kernel.org, dmilburn@redhat.com, edmund.nadolski@intel.com
List-Id: linux-scsi@vger.kernel.org

Head off doomed-to-fail i/o in sas_queuecommand before sending it down
the ata path.

Before:
sd 7:0:0:0: [sdd] Synchronizing SCSI cache
ata8: no sense translation for status: 0x00
ata8: translated ATA stat/err 0x00/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata8.00: device reported invalid CHS sector 0
ata8: status=0x00 { }
ata8: no sense translation for status: 0x00
ata8: translated ATA stat/err 0x00/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata8.00: device reported invalid CHS sector 0
ata8: status=0x00 { }
ata8: no sense translation for status: 0x00
ata8: translated ATA stat/err 0x00/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata8.00: device reported invalid CHS sector 0
ata8: status=0x00 { }
sd 7:0:0:0: [sdd]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 7:0:0:0: [sdd]  Sense Key : Aborted Command [current] [descriptor]
sd 7:0:0:0: [sdd]  Add. Sense: No additional sense information
sd 7:0:0:0: [sdd] Stopping disk

After:
sd 9:0:0:0: [sdd] Synchronizing SCSI cache
sd 9:0:0:0: [sdd]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 9:0:0:0: [sdd] Stopping disk
sd 9:0:0:0: [sdd] START_STOP FAILED
sd 9:0:0:0: [sdd]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK

This is a cosmetic change as sata i/o can still leak to a gone device,
but this addresses the nominal hotplug case when releasing the target.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
This is neither critical, nor complete (i/o can still sneak in after the
check), but it makes device removal cleaner in the nominal case (sync cache
commands triggered by scsi_target removal never enter ata_sas_queuecmd()).

However, with the pending/more critical "libsas: fix/amend device gone
notification in sas_deform_port()" we could go all the way and make it
impossible to submit i/o to a sata device that libsas has marked as
gone, and delete the gone check that happens in sas_ata_qc_issue(). But,
that is encoding more libsas/libata host_lock assumptions...

--
Dan

[1]: http://marc.info/?l=linux-scsi&m=129791105419577&w=2

 drivers/scsi/libsas/sas_scsi_host.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 1787bd2..ce3efff 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -218,6 +218,13 @@ int sas_queuecommand(struct scsi_cmnd *cmd,
 		struct sas_ha_struct *sas_ha = dev->port->ha;
 		struct sas_task *task;
 
+		/* If the device fell off, no sense in issuing commands */
+		if (dev->gone) {
+			cmd->result = DID_BAD_TARGET << 16;
+			scsi_done(cmd);
+			goto out;
+		}
+
 		if (dev_is_sata(dev)) {
 			unsigned long flags;
 
@@ -228,13 +235,6 @@ int sas_queuecommand(struct scsi_cmnd *cmd,
 			goto out;
 		}
 
-		/* If the device fell off, no sense in issuing commands */
-		if (dev->gone) {
-			cmd->result = DID_BAD_TARGET << 16;
-			scsi_done(cmd);
-			goto out;
-		}
-
 		res = -ENOMEM;
 		task = sas_create_task(cmd, dev, GFP_ATOMIC);
 		if (!task)

