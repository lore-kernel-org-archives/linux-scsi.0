From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.17-rc3
Date: Wed, 02 May 2018 07:53:04 -0700
Message-ID: <1525272784.4115.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Three small bug fixes: an illegally overlapping memcmp in target code,
a potential infinite loop in isci under certain rare phy conditions and
an ATA queue depth (performance) correction for storvsc.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bryant G Ly (1):
      scsi: target: Fix fortify_panic kernel exception

Colin Ian King (1):
      scsi: isci: Fix infinite loop in while loop

Long Li (1):
      scsi: storvsc: Set up correct queue depth values for IDE devices

And the diffstat:

 drivers/scsi/isci/port_config.c     | 3 +--
 drivers/scsi/storvsc_drv.c          | 7 +++++--
 drivers/target/target_core_iblock.c | 8 ++++----
 3 files changed, 10 insertions(+), 8 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/isci/port_config.c b/drivers/scsi/isci/port_config.c
index edb7be786c65..9e8de1462593 100644
--- a/drivers/scsi/isci/port_config.c
+++ b/drivers/scsi/isci/port_config.c
@@ -291,7 +291,7 @@ sci_mpc_agent_validate_phy_configuration(struct isci_host *ihost,
 		 * Note: We have not moved the current phy_index so we will actually
 		 *       compare the startting phy with itself.
 		 *       This is expected and required to add the phy to the port. */
-		while (phy_index < SCI_MAX_PHYS) {
+		for (; phy_index < SCI_MAX_PHYS; phy_index++) {
 			if ((phy_mask & (1 << phy_index)) == 0)
 				continue;
 			sci_phy_get_sas_address(&ihost->phys[phy_index],
@@ -311,7 +311,6 @@ sci_mpc_agent_validate_phy_configuration(struct isci_host *ihost,
 					      &ihost->phys[phy_index]);
 
 			assigned_phy_mask |= (1 << phy_index);
-			phy_index++;
 		}
 
 	}
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 8c51d628b52e..a2ec0bc9e9fa 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1722,11 +1722,14 @@ static int storvsc_probe(struct hv_device *device,
 		max_targets = STORVSC_MAX_TARGETS;
 		max_channels = STORVSC_MAX_CHANNELS;
 		/*
-		 * On Windows8 and above, we support sub-channels for storage.
+		 * On Windows8 and above, we support sub-channels for storage
+		 * on SCSI and FC controllers.
 		 * The number of sub-channels offerred is based on the number of
 		 * VCPUs in the guest.
 		 */
-		max_sub_channels = (num_cpus / storvsc_vcpus_per_sub_channel);
+		if (!dev_is_ide)
+			max_sub_channels =
+				(num_cpus - 1) / storvsc_vcpus_per_sub_channel;
 	}
 
 	scsi_driver.can_queue = (max_outstanding_req_per_channel *
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 07c814c42648..60429011292a 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -427,8 +427,8 @@ iblock_execute_zero_out(struct block_device *bdev, struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct scatterlist *sg = &cmd->t_data_sg[0];
-	unsigned char *buf, zero = 0x00, *p = &zero;
-	int rc, ret;
+	unsigned char *buf, *not_zero;
+	int ret;
 
 	buf = kmap(sg_page(sg)) + sg->offset;
 	if (!buf)
@@ -437,10 +437,10 @@ iblock_execute_zero_out(struct block_device *bdev, struct se_cmd *cmd)
 	 * Fall back to block_execute_write_same() slow-path if
 	 * incoming WRITE_SAME payload does not contain zeros.
 	 */
-	rc = memcmp(buf, p, cmd->data_length);
+	not_zero = memchr_inv(buf, 0x00, cmd->data_length);
 	kunmap(sg_page(sg));
 
-	if (rc)
+	if (not_zero)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	ret = blkdev_issue_zeroout(bdev,
