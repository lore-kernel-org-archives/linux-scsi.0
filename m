From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/4] scsi: pmcraid: fix lock imbalance in pmcraid_reset_reload()
Date: Thu, 20 Apr 2017 19:54:46 +0200
Message-ID: <20170420175549.3435196-2-arnd@arndb.de>
References: <20170420175549.3435196-1-arnd@arndb.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170420175549.3435196-1-arnd@arndb.de>
Sender: stable-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>, Quentin Lambert <lambert.quentin@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

sparse found a bug that has always been present since the driver
was merged:

drivers/scsi/pmcraid.c:2353:12: warning: context imbalance in 'pmcraid_reset_reload' - different lock contexts for basic block

This adds the missing unlock at the end of the function. I could
not figure out if this will happen in practice, but I could not
prove that it doesn't happen, so to be on the safe side, let's
backport this fix.

Cc: stable@vger.kernel.org
Fixes: 89a368104150 ("[SCSI] pmcraid: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID controller")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/pmcraid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 096c704ca39a..35087e94c2ad 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -2411,8 +2411,11 @@ static int pmcraid_reset_reload(
 		scsi_unblock_requests(pinstance->host);
 		if (pinstance->ioa_state == target_state)
 			reset = 0;
+		spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
 	}
 
+	spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+
 	return reset;
 }
 
-- 
2.9.0
