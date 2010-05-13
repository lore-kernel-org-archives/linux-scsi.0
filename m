From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] libata: use the enlarged capacity after late HPA unlock
Date: Thu, 13 May 2010 17:56:45 +0200
Message-ID: <1273766206-17402-4-git-send-email-tj@kernel.org>
References: <1273766206-17402-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1273766206-17402-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, linux-kernel@vger.kernel.org
Cc: ben@decadent.org.uk, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

After late HPA unlock, libata kept using the original capacity
ignoring the new larger native capacity.  Enlarging device on the fly
doesn't cause any harm.  Use the larger native capacity instead.  This
will enable on-demand HPA unlocking.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/libata-core.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 86f405b..9d6e92d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4212,9 +4212,8 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 	    dev->n_sectors > n_sectors && dev->n_sectors == n_native_sectors) {
 		ata_dev_printk(dev, KERN_WARNING,
 			       "new n_sectors matches native, probably "
-			       "late HPA unlock, continuing\n");
-		/* keep using the old n_sectors */
-		dev->n_sectors = n_sectors;
+			       "late HPA unlock, n_sectors updated\n");
+		/* use the larger n_sectors */
 		return 0;
 	}
 
-- 
1.6.4.2
