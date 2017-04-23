From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] scsi: pmcraid: fix lock imbalance in
 pmcraid_reset_reload()
Date: Sun, 23 Apr 2017 01:36:35 -0700
Message-ID: <20170423083635.GB30869@infradead.org>
References: <20170420175549.3435196-1-arnd@arndb.de>
 <20170420175549.3435196-2-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170420175549.3435196-2-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>, Quentin Lambert <lambert.quentin@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 20, 2017 at 07:54:46PM +0200, Arnd Bergmann wrote:
> sparse found a bug that has always been present since the driver
> was merged:
> 
> drivers/scsi/pmcraid.c:2353:12: warning: context imbalance in 'pmcraid_reset_reload' - different lock contexts for basic block
> 
> This adds the missing unlock at the end of the function. I could
> not figure out if this will happen in practice, but I could not
> prove that it doesn't happen, so to be on the safe side, let's
> backport this fix.
> 
> Cc: stable@vger.kernel.org
> Fixes: 89a368104150 ("[SCSI] pmcraid: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID controller")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/pmcraid.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index 096c704ca39a..35087e94c2ad 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -2411,8 +2411,11 @@ static int pmcraid_reset_reload(
>  		scsi_unblock_requests(pinstance->host);
>  		if (pinstance->ioa_state == target_state)
>  			reset = 0;
> +		spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
>  	}
>  
> +	spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
> +

This looks weird.  Using a proper goto label to unwind seem like the
best way to go, e.g. this patch:

---
>From 8c58854f345bd87789b68eba2b2f72d0cac952fa Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Sun, 23 Apr 2017 10:33:23 +0200
Subject: pmcraid: fix lock imbalance in pmcraid_reset_reload()

sparse found a bug that has always been present since the driver was
merged:

drivers/scsi/pmcraid.c:2353:12: warning: context imbalance in 'pmcraid_reset_reload' - different lock contexts for basic block

Fix this by using a common unlock goto label, and also reduce the
indentation level in the function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/pmcraid.c | 59 ++++++++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 49e70a383afa..3cc858f45838 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -2373,46 +2373,43 @@ static int pmcraid_reset_reload(
 		spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
 
 		if (pinstance->ioa_state == IOA_STATE_DEAD) {
-			spin_unlock_irqrestore(pinstance->host->host_lock,
-					       lock_flags);
 			pmcraid_info("reset_reload: IOA is dead\n");
-			return reset;
-		} else if (pinstance->ioa_state == target_state) {
+			goto out_unlock;
+		}
+
+		if (pinstance->ioa_state == target_state) {
 			reset = 0;
+			goto out_unlock;
 		}
 	}
 
-	if (reset) {
-		pmcraid_info("reset_reload: proceeding with reset\n");
-		scsi_block_requests(pinstance->host);
-		reset_cmd = pmcraid_get_free_cmd(pinstance);
-
-		if (reset_cmd == NULL) {
-			pmcraid_err("no free cmnd for reset_reload\n");
-			spin_unlock_irqrestore(pinstance->host->host_lock,
-					       lock_flags);
-			return reset;
-		}
+	pmcraid_info("reset_reload: proceeding with reset\n");
+	scsi_block_requests(pinstance->host);
+	reset_cmd = pmcraid_get_free_cmd(pinstance);
+	if (reset_cmd == NULL) {
+		pmcraid_err("no free cmnd for reset_reload\n");
+		goto out_unlock;
+	}
 
-		if (shutdown_type == SHUTDOWN_NORMAL)
-			pinstance->ioa_bringdown = 1;
+	if (shutdown_type == SHUTDOWN_NORMAL)
+		pinstance->ioa_bringdown = 1;
 
-		pinstance->ioa_shutdown_type = shutdown_type;
-		pinstance->reset_cmd = reset_cmd;
-		pinstance->force_ioa_reset = reset;
-		pmcraid_info("reset_reload: initiating reset\n");
-		pmcraid_ioa_reset(reset_cmd);
-		spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
-		pmcraid_info("reset_reload: waiting for reset to complete\n");
-		wait_event(pinstance->reset_wait_q,
-			   !pinstance->ioa_reset_in_progress);
+	pinstance->ioa_shutdown_type = shutdown_type;
+	pinstance->reset_cmd = reset_cmd;
+	pinstance->force_ioa_reset = reset;
+	pmcraid_info("reset_reload: initiating reset\n");
+	pmcraid_ioa_reset(reset_cmd);
+	spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
+	pmcraid_info("reset_reload: waiting for reset to complete\n");
+	wait_event(pinstance->reset_wait_q,
+		   !pinstance->ioa_reset_in_progress);
 
-		pmcraid_info("reset_reload: reset is complete !!\n");
-		scsi_unblock_requests(pinstance->host);
-		if (pinstance->ioa_state == target_state)
-			reset = 0;
-	}
+	pmcraid_info("reset_reload: reset is complete !!\n");
+	scsi_unblock_requests(pinstance->host);
+	return pinstance->ioa_state != target_state;
 
+out_unlock:
+	spin_unlock_irqrestore(pinstance->host->host_lock, lock_flags);
 	return reset;
 }
 
-- 
2.11.0
