From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.13-rc2
Date: Tue, 25 Jul 2017 16:23:53 -0700
Message-ID: <1501025033.3689.47.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Three small fixes.  The transfer size fixes are actually correcting
some performance drops on the hpsa and smartpqi cards.  The cards
actually have an internal cache for request speed up but bypass it for
transfers > 1MB.  Since 4.3 the efficiency of our merges has rendered
the cache mostly unused, so limit transfers to under 1MB to recover the
cache boost.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Johannes Thumshirn (1):
      scsi: sg: fix static checker warning in sg_is_valid_dxfer

Yadan Fan (2):
      scsi: smartpqi: limit transfer length to 1MB
      scsi: hpsa: limit transfer length to 1MB

And the diffstat:

 drivers/scsi/hpsa.c              | 2 +-
 drivers/scsi/sg.c                | 7 +++++--
 drivers/scsi/smartpqi/smartpqi.h | 2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8914eab84337..4f7cdb28bd38 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -938,7 +938,7 @@ static struct scsi_host_template hpsa_driver_template = {
 #endif
 	.sdev_attrs = hpsa_sdev_attrs,
 	.shost_attrs = hpsa_shost_attrs,
-	.max_sectors = 8192,
+	.max_sectors = 1024,
 	.no_write_same = 1,
 };
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 1e82d4128a84..4fe606b000b4 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -759,8 +759,11 @@ static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
 			return false;
 		return true;
 	case SG_DXFER_FROM_DEV:
-		if (hp->dxfer_len < 0)
-			return false;
+		/*
+		 * for SG_DXFER_FROM_DEV we always set dxfer_len to > 0. dxferp
+		 * can either be NULL or != NULL so there's no point in checking
+		 * it either. So just return true.
+		 */
 		return true;
 	case SG_DXFER_TO_DEV:
 	case SG_DXFER_TO_FROM_DEV:
diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 07ec8a8877de..e164ffade38a 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -690,7 +690,7 @@ struct pqi_config_table_heartbeat {
 
 #define PQI_MAX_OUTSTANDING_REQUESTS		((u32)~0)
 #define PQI_MAX_OUTSTANDING_REQUESTS_KDUMP	32
-#define PQI_MAX_TRANSFER_SIZE			(4 * 1024U * 1024U)
+#define PQI_MAX_TRANSFER_SIZE			(1024U * 1024U)
 #define PQI_MAX_TRANSFER_SIZE_KDUMP		(512 * 1024U)
 
 #define RAID_MAP_MAX_ENTRIES		1024
