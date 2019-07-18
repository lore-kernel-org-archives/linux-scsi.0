From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: pmcraid: Use dma_pool_zalloc rather than
 dma_pool_alloc
Date: Thu, 18 Jul 2019 11:37:14 -0700
Message-ID: <649403d7dbf2e4e21a96bd9a20b7cb659b97fe38.camel@perches.com>
References: <20190718181051.22882-1-gomonovych@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190718181051.22882-1-gomonovych@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vasyl Gomonovych <gomonovych@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2019-07-18 at 20:10 +0200, Vasyl Gomonovych wrote:
> Use *_pool_zalloc rather than *_pool_alloc followed by memset with 0
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/alloc/pool_zalloc-simple.cocci.
[]
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
[]
> @@ -4653,9 +4653,7 @@ static int pmcraid_allocate_control_blocks(struct pmcraid_instance *pinstance)
>  		return -ENOMEM;
>  
>  	for (i = 0; i < PMCRAID_MAX_CMD; i++) {
> -		pinstance->cmd_list[i]->ioa_cb =
> -			dma_pool_alloc(
> -				pinstance->control_pool,
> +		pinstance->cmd_list[i]->ioa_cb = dma_pool_zalloc(pinstance->control_pool,
>  				GFP_KERNEL,
>  				&(pinstance->cmd_list[i]->ioa_cb_bus_addr));
>  
> @@ -4663,8 +4661,6 @@ static int pmcraid_allocate_control_blocks(struct pmcraid_instance *pinstance)
>  			pmcraid_release_control_blocks(pinstance, i);
>  			return -ENOMEM;
>  		}
> -		memset(pinstance->cmd_list[i]->ioa_cb, 0,
> -			sizeof(struct pmcraid_control_block));
>  	}
>  	return 0;
>  }

While this change is somewhat overdone as only
dma_pool_alloc could be changed to dma_pool_zalloc
on the same line without rewrapping other arguments,
I'd generally write this with a temporary like:
---
 drivers/scsi/pmcraid.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 71ff3936da4f..88e7b18ad44d 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4653,19 +4653,17 @@ static int pmcraid_allocate_control_blocks(struct pmcraid_instance *pinstance)
 		return -ENOMEM;
 
 	for (i = 0; i < PMCRAID_MAX_CMD; i++) {
-		pinstance->cmd_list[i]->ioa_cb =
-			dma_pool_alloc(
-				pinstance->control_pool,
-				GFP_KERNEL,
-				&(pinstance->cmd_list[i]->ioa_cb_bus_addr));
+		struct pmcraid_cmd *cmd = pinstance->cmd_list[i];
 
-		if (!pinstance->cmd_list[i]->ioa_cb) {
+		cmd->ioa_cb = dma_pool_zalloc(pinstance->control_pool,
+					      GFP_KERNEL,
+					      &cmd->ioa_cb_bus_addr);
+		if (!cmd->ioa_cb) {
 			pmcraid_release_control_blocks(pinstance, i);
 			return -ENOMEM;
 		}
-		memset(pinstance->cmd_list[i]->ioa_cb, 0,
-			sizeof(struct pmcraid_control_block));
 	}
+
 	return 0;
 }
 
