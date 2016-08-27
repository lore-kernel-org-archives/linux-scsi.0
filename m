From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH] fix:pmcraid: mark symbols static where possible
Date: Sat, 27 Aug 2016 23:49:24 +0800
Message-ID: <1472312964-20944-1-git-send-email-baoyou.xie@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:32993 "EHLO
        mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753511AbcH0PuM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Aug 2016 11:50:12 -0400
Received: by mail-pa0-f44.google.com with SMTP id cy9so15269882pac.0
        for <linux-scsi@vger.kernel.org>; Sat, 27 Aug 2016 08:50:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@linaro.org, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn

We get 4 warnings about global functions without a declaration
in the scsi pmcraid driver when building with W=1:
drivers/scsi/pmcraid.c:309:6: warning: no previous prototype for 'pmcraid_init_cmdblk' [-Wmissing-prototypes]
drivers/scsi/pmcraid.c:404:6: warning: no previous prototype for 'pmcraid_return_cmd' [-Wmissing-prototypes]
drivers/scsi/pmcraid.c:1713:6: warning: no previous prototype for 'pmcraid_ioasc_logger' [-Wmissing-prototypes]
drivers/scsi/pmcraid.c:3141:1: warning: no previous prototype for 'pmcraid_init_ioadls' [-Wmissing-prototypes]

In fact, these functions are only used in the file in which it is declared
and don't need a declaration, but can be made static.
so this patch marks it 'static'.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/scsi/pmcraid.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index b2a8820..68a5c34 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -306,7 +306,7 @@ static int pmcraid_change_queue_depth(struct scsi_device *scsi_dev, int depth)
  * Return Value
  *	 None
  */
-void pmcraid_init_cmdblk(struct pmcraid_cmd *cmd, int index)
+static void pmcraid_init_cmdblk(struct pmcraid_cmd *cmd, int index)
 {
 	struct pmcraid_ioarcb *ioarcb = &(cmd->ioa_cb->ioarcb);
 	dma_addr_t dma_addr = cmd->ioa_cb_bus_addr;
@@ -401,7 +401,7 @@ static struct pmcraid_cmd *pmcraid_get_free_cmd(
  * Return Value:
  *	nothing
  */
-void pmcraid_return_cmd(struct pmcraid_cmd *cmd)
+static void pmcraid_return_cmd(struct pmcraid_cmd *cmd)
 {
 	struct pmcraid_instance *pinstance = cmd->drv_inst;
 	unsigned long lock_flags;
@@ -1710,7 +1710,7 @@ static struct pmcraid_ioasc_error *pmcraid_get_error_info(u32 ioasc)
  * @ioasc: ioasc code
  * @cmd: pointer to command that resulted in 'ioasc'
  */
-void pmcraid_ioasc_logger(u32 ioasc, struct pmcraid_cmd *cmd)
+static void pmcraid_ioasc_logger(u32 ioasc, struct pmcraid_cmd *cmd)
 {
 	struct pmcraid_ioasc_error *error_info = pmcraid_get_error_info(ioasc);
 
@@ -3137,7 +3137,7 @@ static int pmcraid_eh_host_reset_handler(struct scsi_cmnd *scmd)
  *   returns pointer pmcraid_ioadl_desc, initialized to point to internal
  *   or external IOADLs
  */
-struct pmcraid_ioadl_desc *
+static struct pmcraid_ioadl_desc *
 pmcraid_init_ioadls(struct pmcraid_cmd *cmd, int sgcount)
 {
 	struct pmcraid_ioadl_desc *ioadl;
-- 
2.7.4

