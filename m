From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [RESEND PATCH] sci: ufs: Fix module autoload for OF platform driver
Date: Tue, 20 Oct 2015 16:09:53 +0100
Message-ID: <1445353793-2508-1-git-send-email-luisbg@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, JBottomley@odin.com, vinholikatti@gmail.com, Luis de Bethencourt <luis@debethencourt.com>, Luis de Bethencourt <luisbg@osg.samsung.com>
List-Id: linux-scsi@vger.kernel.org

From: Luis de Bethencourt <luis@debethencourt.com>

This platform driver has a OF device ID table but the OF module
alias information is not created so module autoloading won't work.

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---

Hi,

This is a resend of a patch sent September 18 [0]

This patch adds the missing MODULE_DEVICE_TABLE() for OF to export
that information so modules have the correct aliases built-in and
autoloading works correctly.

A longer explanation by Javier Canillas can be found here:
https://lkml.org/lkml/2015/7/30/519

Thanks,
Luis

[0] https://lkml.org/lkml/2015/9/18/676

 drivers/scsi/ufs/ufshcd-pltfrm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 7db9564..7f3b0cf 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -375,6 +375,7 @@ static const struct of_device_id ufs_of_match[] = {
 	{ .compatible = "jedec,ufs-1.1"},
 	{},
 };
+MODULE_DEVICE_TABLE(of, ufs_of_match);
 
 static const struct dev_pm_ops ufshcd_dev_pm_ops = {
 	.suspend	= ufshcd_pltfrm_suspend,
-- 
2.5.3
