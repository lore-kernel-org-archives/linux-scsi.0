From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.0-rc7
Date: Fri, 22 Feb 2019 19:08:00 -0800
Message-ID: <1550891280.3577.36.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Four small fixes: three in drivers and one in the core.  The core fix
is also minor in scope since the bug it fixes is only known to affect
systems using SCSI reservations.  Of the driver bugs, the libsas one is
 the most major because it can lead to multiple disks on the same
expander not being exposed.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Anoob Soman (1):
      scsi: libiscsi: Fix race between iscsi_xmit_task and iscsi_complete_task

John Garry (1):
      scsi: libsas: Fix rphy phy_identifier for PHYs with end devices attached

Martin Wilck (1):
      scsi: core: reset host byte in DID_NEXUS_FAILURE case

Masato Suzuki (1):
      scsi: sd_zbc: Fix sd_zbc_report_zones() buffer allocation

And the diffstat:

 drivers/scsi/libiscsi.c            | 6 ++++++
 drivers/scsi/libsas/sas_expander.c | 2 ++
 drivers/scsi/scsi_lib.c            | 1 +
 drivers/scsi/sd_zbc.c              | 8 +++++---
 4 files changed, 14 insertions(+), 3 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index b8d325ce8754..120fc520f27a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1459,7 +1459,13 @@ static int iscsi_xmit_task(struct iscsi_conn *conn)
 	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx))
 		return -ENODATA;
 
+	spin_lock_bh(&conn->session->back_lock);
+	if (conn->task == NULL) {
+		spin_unlock_bh(&conn->session->back_lock);
+		return -ENODATA;
+	}
 	__iscsi_get_task(task);
+	spin_unlock_bh(&conn->session->back_lock);
 	spin_unlock_bh(&conn->session->frwd_lock);
 	rc = conn->session->tt->xmit_task(task);
 	spin_lock_bh(&conn->session->frwd_lock);
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 17eb4185f29d..f21c93bbb35c 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -828,6 +828,7 @@ static struct domain_device *sas_ex_discover_end_dev(
 		rphy = sas_end_device_alloc(phy->port);
 		if (!rphy)
 			goto out_free;
+		rphy->identify.phy_identifier = phy_id;
 
 		child->rphy = rphy;
 		get_device(&rphy->dev);
@@ -854,6 +855,7 @@ static struct domain_device *sas_ex_discover_end_dev(
 
 		child->rphy = rphy;
 		get_device(&rphy->dev);
+		rphy->identify.phy_identifier = phy_id;
 		sas_fill_in_rphy(child, rphy);
 
 		list_add_tail(&child->disco_list_node, &parent->port->disco_list);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6d65ac584eba..f8d51c3d5582 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -655,6 +655,7 @@ static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
 		set_host_byte(cmd, DID_OK);
 		return BLK_STS_TARGET;
 	case DID_NEXUS_FAILURE:
+		set_host_byte(cmd, DID_OK);
 		return BLK_STS_NEXUS;
 	case DID_ALLOC_FAILURE:
 		set_host_byte(cmd, DID_OK);
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index fff86940388b..a340af797a85 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -142,10 +142,12 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 		return -EOPNOTSUPP;
 
 	/*
-	 * Get a reply buffer for the number of requested zones plus a header.
-	 * For ATA, buffers must be aligned to 512B.
+	 * Get a reply buffer for the number of requested zones plus a header,
+	 * without exceeding the device maximum command size. For ATA disks,
+	 * buffers must be aligned to 512B.
 	 */
-	buflen = roundup((nrz + 1) * 64, 512);
+	buflen = min(queue_max_hw_sectors(disk->queue) << 9,
+		     roundup((nrz + 1) * 64, 512));
 	buf = kmalloc(buflen, gfp_mask);
 	if (!buf)
 		return -ENOMEM;
