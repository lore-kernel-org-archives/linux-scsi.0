From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 4/5] hpsa: fix potential array overflow in
	hpsa_update_scsi_devices
Date: Wed, 26 Oct 2011 16:21:12 -0500
Message-ID: <20111026212112.15570.72971.stgit@beardog.cce.hp.com>
References: <20111026212006.15570.26229.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111026212006.15570.26229.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Scott Teel <scott.teel@hp.com>

The currentsd[] array in hpsa_update_scsi_devices had room for
256 devices.  The code was iterating over however many physical
and logical devices plus an additional number of possible external
MSA2XXX controllers, which together could potentially exceed 256.

We increased the size of the currentsd array to 1024 + 1024 + 32 + 1
elements to reflect a reasonable maximum possible number of devices
which might be encountered.  We also don't just walk off the end
of the array if the array controller reports more devices than we
are prepared to handle, we just ignore the excessive devices.

Signed-off-by: Scott Teel <scott.teel@hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c     |    8 +++++++-
 drivers/scsi/hpsa.h     |    1 -
 drivers/scsi/hpsa_cmd.h |    5 ++++-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index d359186..646516f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1734,7 +1734,6 @@ static int add_msa2xxx_enclosure_device(struct ctlr_info *h,
 	if (is_scsi_rev_5(h))
 		return 0; /* p1210m doesn't need to do this. */
 
-#define MAX_MSA2XXX_ENCLOSURES 32
 	if (*nmsa2xxx_enclosures >= MAX_MSA2XXX_ENCLOSURES) {
 		dev_warn(&h->pdev->dev, "Maximum number of MSA2XXX "
 			"enclosures exceeded.  Check your hardware "
@@ -1868,6 +1867,13 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 
 	/* Allocate the per device structures */
 	for (i = 0; i < ndevs_to_allocate; i++) {
+		if (i >= HPSA_MAX_DEVICES) {
+			dev_warn(&h->pdev->dev, "maximum devices (%d) exceeded."
+				"  %d devices ignored.\n", HPSA_MAX_DEVICES,
+				ndevs_to_allocate - HPSA_MAX_DEVICES);
+			break;
+		}
+
 		currentsd[i] = kzalloc(sizeof(*currentsd[i]), GFP_KERNEL);
 		if (!currentsd[i]) {
 			dev_warn(&h->pdev->dev, "out of memory at %s:%d\n",
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 4de9f71..73858bc 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -102,7 +102,6 @@ struct ctlr_info {
 	struct Scsi_Host *scsi_host;
 	spinlock_t devlock; /* to protect hba[ctlr]->dev[];  */
 	int ndevices; /* number of used elements in .dev[] array. */
-#define HPSA_MAX_DEVICES 256
 	struct hpsa_scsi_dev_t *dev[HPSA_MAX_DEVICES];
 	/*
 	 * Performant mode tables.
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 55d741b..3fd4715 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -123,8 +123,11 @@ union u64bit {
 
 /* FIXME this is a per controller value (barf!) */
 #define HPSA_MAX_TARGETS_PER_CTLR 16
-#define HPSA_MAX_LUN 256
+#define HPSA_MAX_LUN 1024
 #define HPSA_MAX_PHYS_LUN 1024
+#define MAX_MSA2XXX_ENCLOSURES 32
+#define HPSA_MAX_DEVICES (HPSA_MAX_PHYS_LUN + HPSA_MAX_LUN + \
+	MAX_MSA2XXX_ENCLOSURES + 1) /* + 1 is for the controller itself */
 
 /* SCSI-3 Commands */
 #pragma pack(1)
