From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] scsi: ufs: ufshcd: fix potential NULL pointer dereference in
 ufshcd_config_vreg
Date: Mon, 20 Nov 2017 08:12:29 -0600
Message-ID: <20171120141229.GA2130@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

_vreg_ is being dereferenced before it is null checked, hence there is a
potential null pointer dereference.

Fix this by moving the pointer dereference after _vreg_ has been null
checked.

This issue was detected with the help of Coccinelle.

Fixes: aa4976130934 ("ufs: Add regulator enable support")
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/scsi/ufs/ufshcd.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 011c336..a355d98 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6559,12 +6559,15 @@ static int ufshcd_config_vreg(struct device *dev,
 		struct ufs_vreg *vreg, bool on)
 {
 	int ret = 0;
-	struct regulator *reg = vreg->reg;
-	const char *name = vreg->name;
+	struct regulator *reg;
+	const char *name;
 	int min_uV, uA_load;
 
 	BUG_ON(!vreg);
 
+	reg = vreg->reg;
+	name = vreg->name;
+
 	if (regulator_count_voltages(reg) > 0) {
 		min_uV = on ? vreg->min_uV : 0;
 		ret = regulator_set_voltage(reg, min_uV, vreg->max_uV);
-- 
2.7.4
