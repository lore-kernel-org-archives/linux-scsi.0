From: Luis de Bethencourt <luis@debethencourt.com>
Subject: [PATCH] sci: ufs: Fix module autoload for OF platform driver
Date: Fri, 18 Sep 2015 19:32:38 +0200
Message-ID: <20150918173238.GA29298@goodgumbo.baconseed.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This platform driver has a OF device ID table but the OF module
alias information is not created so module autoloading won't work.

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---

Hello,

This patch adds the missing MODULE_DEVICE_TABLE() for OF to export
that information so modules have the correct aliases built-in and
autoloading works correctly.

A longer explanation by Javier Canillas can be found here:
https://lkml.org/lkml/2015/7/30/519

Thanks,
Luis

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
2.4.6
