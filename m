From: Himangi Saraogi <himangi774@gmail.com>
Subject: [PATCH] target/configfs: Remove unnecessary null test
Date: Thu, 17 Jul 2014 02:29:53 +0530
Message-ID: <20140716205953.GA3231@himangi-Dell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
List-Id: linux-scsi@vger.kernel.org

This patch removes the null test on lun_cg. lun_cg is initialized
at the beginning of the function to &lun->lun_group. Since lun_cg is
dereferenced prior to the null test, it must be a valid pointer.

The following Coccinelle script is used for detecting the change:

@r@
expression e,f;
identifier g,y;
statement S1,S2;
@@

*e = &f->g
<+...
 f->y
 ...+>
*if (e != NULL || ...)
 S1 else S2

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/target/target_core_fabric_configfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 7de9f04..7228a18 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -917,8 +917,7 @@ static struct config_group *target_fabric_make_lun(
 
 	return &lun->lun_group;
 out:
-	if (lun_cg)
-		kfree(lun_cg->default_groups);
+	kfree(lun_cg->default_groups);
 	return ERR_PTR(errno);
 }
 
-- 
1.9.1
