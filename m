From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 5/16] ufs: fix error return code
Date: Sun,  5 Apr 2015 14:06:25 +0200
Message-ID: <1428235596-4757-6-git-send-email-Julia.Lawall@lip6.fr>
References: <1428235596-4757-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1428235596-4757-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: kernel-janitors-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Return a negative error code on failure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret; expression e1,e2;
@@
(
if (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

This patch also changes the subsequent dev_err call to use err rather
than recomputing PTR_ERR(hba->devfreq).  The format of the error value
is changed from %ld to %d to reflect the type or err.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/scsi/ufs/ufshcd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2aa85e3..8b802d1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5506,8 +5506,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		hba->devfreq = devfreq_add_device(dev, &ufs_devfreq_profile,
 						   "simple_ondemand", NULL);
 		if (IS_ERR(hba->devfreq)) {
-			dev_err(hba->dev, "Unable to register with devfreq %ld\n",
-					PTR_ERR(hba->devfreq));
+			err = PTR_ERR(hba->devfreq);
+			dev_err(hba->dev, "Unable to register with devfreq %d\n",
+					err);
 			goto out_remove_scsi_host;
 		}
 		/* Suspend devfreq until the UFS device is detected */

