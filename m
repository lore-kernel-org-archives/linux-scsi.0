From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 08/10] hpsa: eliminate 8 external target limitation
Date: Thu, 19 Jan 2012 14:01:19 -0600
Message-ID: <20120119200119.17835.89463.stgit@beardog.cce.hp.com>
References: <20120119200042.17835.93058.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120119200042.17835.93058.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, scott.teel@hp.com, akpm@linux-foundation.org, stable@kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Scott Teel <scott.teel@hp.com>

Driver limits SAS external target IDs to range 1-8.
Need to increase limit and clean up overlapping concepts of targets and paths
in the code.

There are several defined constants that control this:
HPSA_MAX_TARGETS_PER_CTLR     16
MAX_MSA2XXX_ENCLOSURES        32
HPSA_MAX_PATHS                8

We can condense this to one constant:
MAX_EXT_TARGETS               32

SAS switches allow for 8 connections, and there is capacity for 4 switches per
enclosure in largest blade enclosure type.

Signed-off-by: Scott Teel <scott.teel@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c     |   16 ++++++++--------
 drivers/scsi/hpsa_cmd.h |    5 ++---
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ea9b685..39ac161 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1692,9 +1692,9 @@ static int add_msa2xxx_enclosure_device(struct ctlr_info *h,
 	if (is_scsi_rev_5(h))
 		return 0; /* p1210m doesn't need to do this. */
 
-	if (*nmsa2xxx_enclosures >= MAX_MSA2XXX_ENCLOSURES) {
-		dev_warn(&h->pdev->dev, "Maximum number of MSA2XXX "
-			"enclosures exceeded.  Check your hardware "
+	if (*nmsa2xxx_enclosures >= MAX_EXT_TARGETS) {
+		dev_warn(&h->pdev->dev, "Maximum number of external "
+			"target devices exceeded.  Check your hardware "
 			"configuration.");
 		return 0;
 	}
@@ -1800,7 +1800,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 	int reportlunsize = sizeof(*physdev_list) + HPSA_MAX_PHYS_LUN * 8;
 	int i, nmsa2xxx_enclosures, ndevs_to_allocate;
 	int raid_ctlr_position;
-	DECLARE_BITMAP(lunzerobits, HPSA_MAX_TARGETS_PER_CTLR);
+	DECLARE_BITMAP(lunzerobits, MAX_EXT_TARGETS);
 
 	currentsd = kzalloc(sizeof(*currentsd) * HPSA_MAX_DEVICES, GFP_KERNEL);
 	physdev_list = kzalloc(reportlunsize, GFP_KERNEL);
@@ -1817,11 +1817,11 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 			logdev_list, &nlogicals))
 		goto out;
 
-	/* We might see up to 32 MSA2xxx enclosures, actually 8 of them
-	 * but each of them 4 times through different paths.  The plus 1
-	 * is for the RAID controller.
+	/* We might see up to the maximum number of logical and physical disks
+	 * plus external target devices, and a device for the local RAID
+	 * controller.
 	 */
-	ndevs_to_allocate = nphysicals + nlogicals + MAX_MSA2XXX_ENCLOSURES + 1;
+	ndevs_to_allocate = nphysicals + nlogicals + MAX_EXT_TARGETS + 1;
 
 	/* Allocate the per device structures */
 	for (i = 0; i < ndevs_to_allocate; i++) {
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 516d6e5..8049815 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -122,12 +122,11 @@ union u64bit {
 };
 
 /* FIXME this is a per controller value (barf!) */
-#define HPSA_MAX_TARGETS_PER_CTLR 16
 #define HPSA_MAX_LUN 1024
 #define HPSA_MAX_PHYS_LUN 1024
-#define MAX_MSA2XXX_ENCLOSURES 32
+#define MAX_EXT_TARGETS 32
 #define HPSA_MAX_DEVICES (HPSA_MAX_PHYS_LUN + HPSA_MAX_LUN + \
-	MAX_MSA2XXX_ENCLOSURES + 1) /* + 1 is for the controller itself */
+	MAX_EXT_TARGETS + 1) /* + 1 is for the controller itself */
 
 /* SCSI-3 Commands */
 #pragma pack(1)
