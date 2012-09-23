From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.6-rc6
Date: Sun, 23 Sep 2012 08:09:36 +0100
Message-ID: <1348384176.2549.5.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of four essential fixes: two oops related (bnx2i,
virtio-scsi), one data corruption related (hpsa) and one failure to boot
due to interrupt routing issues (mpt2ss).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Eddie Wai (1):
      bnx2i: Fixed NULL ptr deference for 1G bnx2 Linux iSCSI offload

Stephen M. Cameron (1):
      hpsa: fix handling of protocol error

Wang Sen (1):
      scsi: virtio-scsi: Fix address translation failure of HighMem pages used by sg list

sreekanth.reddy@lsi.com (1):
      mpt2sas: Fix for issue - Unable to boot from the drive connected to HBA

And the diffstat:

 drivers/scsi/bnx2i/bnx2i_hwi.c      | 3 +++
 drivers/scsi/hpsa.c                 | 3 ++-
 drivers/scsi/mpt2sas/mpt2sas_base.c | 7 +++++++
 drivers/scsi/virtio_scsi.c          | 2 +-
 4 files changed, 13 insertions(+), 2 deletions(-)

Full diff is appended below.

James

---
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 33d6630..91eec60 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1264,6 +1264,9 @@ int bnx2i_send_fw_iscsi_init_msg(struct bnx2i_hba *hba)
 	int rc = 0;
 	u64 mask64;
 
+	memset(&iscsi_init, 0x00, sizeof(struct iscsi_kwqe_init1));
+	memset(&iscsi_init2, 0x00, sizeof(struct iscsi_kwqe_init2));
+
 	bnx2i_adjust_qp_size(hba);
 
 	iscsi_init.flags =
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 796482b..2b4261c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1315,8 +1315,9 @@ static void complete_scsi_command(struct CommandList *cp)
 	}
 		break;
 	case CMD_PROTOCOL_ERR:
+		cmd->result = DID_ERROR << 16;
 		dev_warn(&h->pdev->dev, "cp %p has "
-			"protocol error \n", cp);
+			"protocol error\n", cp);
 		break;
 	case CMD_HARDWARE_ERR:
 		cmd->result = DID_ERROR << 16;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index b25757d..9d5a56c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1209,6 +1209,13 @@ _base_check_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 	u16 message_control;
 
 
+	/* Check whether controller SAS2008 B0 controller,
+	   if it is SAS2008 B0 controller use IO-APIC instead of MSIX */
+	if (ioc->pdev->device == MPI2_MFGPAGE_DEVID_SAS2008 &&
+	    ioc->pdev->revision == 0x01) {
+		return -EINVAL;
+	}
+
 	base = pci_find_capability(ioc->pdev, PCI_CAP_ID_MSIX);
 	if (!base) {
 		dfailprintk(ioc, printk(MPT2SAS_INFO_FMT "msix not "
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index c7030fb..3e79a2f 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -331,7 +331,7 @@ static void virtscsi_map_sgl(struct scatterlist *sg, unsigned int *p_idx,
 	int i;
 
 	for_each_sg(table->sgl, sg_elem, table->nents, i)
-		sg_set_buf(&sg[idx++], sg_virt(sg_elem), sg_elem->length);
+		sg[idx++] = *sg_elem;
 
 	*p_idx = idx;
 }
