From: Tapasweni Pathak <tapaswenipathak@gmail.com>
Subject: [PATCH] drivers: scsi: ufs: Fix possible null derefrence
Date: Wed, 4 Mar 2015 18:19:48 +0530
Message-ID: <20150304124948.GA3288@kt-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tapaswenipathak@gmail.com, julia.lawall@lip6.fr
List-Id: linux-scsi@vger.kernel.org

Check for null before being dereferenced to avoid a invalid null
dereference.

Found using Coccinelle.

Signed-off-by: Tapasweni Pathak <tapaswenipathak@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/scsi/ufs/ufshcd.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5d60a86..c54e64f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4268,12 +4268,15 @@ static int ufshcd_config_vreg(struct device *dev,
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
1.7.9.5
