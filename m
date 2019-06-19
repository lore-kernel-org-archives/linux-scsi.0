From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: mvsas: Use struct_size() in kzalloc()
Date: Wed, 19 Jun 2019 09:02:27 -0500
Message-ID: <20190619140227.GA9877@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct mvs_info {
        ...
        struct mvs_slot_info slot_info[0];
};

instance = kzalloc(sizeof(sizeof(*mvi) + count * sizeof(struct mvs_slot_info),
                   GFP_KERNEL);

Instead of leaving these open-coded and prone to type mistakes, we can
now use the new struct_size() helper:

instance = kzalloc(struct_size(mvi, slot_info, count), GFP_KERNEL);

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/mvsas/mv_init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index da719b0694dc..3f2022fd2335 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -350,9 +350,9 @@ static struct mvs_info *mvs_pci_alloc(struct pci_dev *pdev,
 	struct mvs_info *mvi = NULL;
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
 
-	mvi = kzalloc(sizeof(*mvi) +
-		(1L << mvs_chips[ent->driver_data].slot_width) *
-		sizeof(struct mvs_slot_info), GFP_KERNEL);
+	mvi = kzalloc(struct_size(mvi, slot_info,
+		      1L << mvs_chips[ent->driver_data].slot_width),
+		      GFP_KERNEL);
 	if (!mvi)
 		return NULL;
 
-- 
2.21.0
