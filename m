From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: acornscsi: fix build error
Date: Mon, 11 Sep 2017 22:00:57 +0200
Message-ID: <20170911200115.3119398-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Russell King <linux@armlinux.org.uk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

A cleanup patch introduced a fatal typo from inbalanced curly
braces:

drivers/scsi/arm/acornscsi.c: In function 'acornscsi_host_reset':
drivers/scsi/arm/acornscsi.c:2773:1: error: ISO C90 forbids mixed declarations and code [-Werror=declaration-after-statement]
drivers/scsi/arm/acornscsi.c:2795:12: error: invalid storage class for function 'acornscsi_show_info'
 static int acornscsi_show_info(struct seq_file *m, struct Scsi_Host *instance)

The same patch incorrectly changed the argument type of the reset
handler, as shown by this warning:

drivers/scsi/arm/acornscsi.c:2888:27: error: initialization of 'int (*)(struct scsi_cmnd *)' from incompatible pointer type 'int (*)(struct Scsi_Host *)' [-Werror=incompatible-pointer-types]
  .eh_host_reset_handler = acornscsi_host_reset,

This removes one the extraneous opening brace and reverts the
argument type change.

Fixes: 74fa80ee3fae ("scsi: acornscsi: move bus reset to host reset")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/arm/acornscsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 690816f3c6af..8d54283a99b2 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2725,9 +2725,9 @@ int acornscsi_abort(struct scsi_cmnd *SCpnt)
  * Params   : SCpnt  - command causing reset
  * Returns  : one of SCSI_RESET_ macros
  */
-int acornscsi_host_reset(struct Scsi_Host *shpnt)
+int acornscsi_host_reset(struct scsi_cmnd *SCpnt)
 {
-	AS_Host *host = (AS_Host *)shpnt->hostdata;
+	AS_Host *host = (AS_Host *)SCpnt->device->host->hostdata;
 	struct scsi_cmnd *SCptr;
     
     host->stats.resets += 1;
@@ -2741,7 +2741,7 @@ int acornscsi_host_reset(struct Scsi_Host *shpnt)
 
 	printk(KERN_WARNING "acornscsi_reset: ");
 	print_sbic_status(asr, ssr, host->scsi.phase);
-	for (devidx = 0; devidx < 9; devidx ++) {
+	for (devidx = 0; devidx < 9; devidx ++)
 	    acornscsi_dumplog(host, devidx);
     }
 #endif
-- 
2.9.0
