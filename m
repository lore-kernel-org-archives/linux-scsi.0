From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/4] scsi: pmcraid: fix minor sparse warnings
Date: Thu, 20 Apr 2017 19:54:48 +0200
Message-ID: <20170420175549.3435196-4-arnd@arndb.de>
References: <20170420175549.3435196-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170420175549.3435196-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Johannes Berg <johannes.berg@intel.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

pmcraid_minor is only used in this one file and should be 'static' as suggested
by sparse:

drivers/scsi/pmcraid.c:80:1: warning: symbol 'pmcraid_minor' was not declared. Should it be static?

In Linux coding style, a literal '0' integer should not be used to represent
a NULL pointer:

drivers/scsi/pmcraid.c:348:29: warning: Using plain integer as NULL pointer
drivers/scsi/pmcraid.c:4824:49: warning: Using plain integer as NULL pointer

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/pmcraid.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 58c7511c5bd5..63298f017171 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -77,7 +77,7 @@ static atomic_t pmcraid_adapter_count = ATOMIC_INIT(0);
  */
 static unsigned int pmcraid_major;
 static struct class *pmcraid_class;
-DECLARE_BITMAP(pmcraid_minor, PMCRAID_MAX_ADAPTERS);
+static DECLARE_BITMAP(pmcraid_minor, PMCRAID_MAX_ADAPTERS);
 
 /*
  * Module parameters
@@ -345,7 +345,7 @@ static void pmcraid_init_cmdblk(struct pmcraid_cmd *cmd, int index)
 	cmd->scsi_cmd = NULL;
 	cmd->release = 0;
 	cmd->completion_req = 0;
-	cmd->sense_buffer = 0;
+	cmd->sense_buffer = NULL;
 	cmd->sense_buffer_dma = 0;
 	cmd->dma_handle = 0;
 	init_timer(&cmd->timer);
@@ -4824,7 +4824,7 @@ static int pmcraid_allocate_host_rrqs(struct pmcraid_instance *pinstance)
 					buffer_size,
 					&(pinstance->hrrq_start_bus_addr[i]));
 
-		if (pinstance->hrrq_start[i] == 0) {
+		if (!pinstance->hrrq_start[i]) {
 			pmcraid_err("pci_alloc failed for hrrq vector : %d\n",
 				    i);
 			pmcraid_release_host_rrqs(pinstance, i);
-- 
2.9.0
