From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 01/10] aacraid: Removed unnecessary checks for NULL
Date: Mon, 25 Apr 2016 23:30:55 -0700
Message-ID: <20160426063055.28402.80755.stgit@pmcuser-System-Product-Name>
References: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0068.outbound.protection.outlook.com ([207.46.100.68]:24563
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752501AbcDZGf4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 02:35:56 -0400
In-Reply-To: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc: aacraid@pmc-sierra.com, gana.sridaran@microsemi.com, scott.benesh@microsemi.com, vishal.josemannanal@microsemi.com, RaghavaAditya.Renukunta@microsemi.com

Current driver checks for NULL return from aac_fib_alloc_tag, but it not
possible for it to return NULL.

Fixed by: Remove all the checks for NULL returns from aac_fib_alloc_tag

Suggested-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c |   22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 7dfd0fa..6678d1f 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -555,8 +555,6 @@ static int aac_get_container_name(struct scsi_cmnd * scsicmd)
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 
 	cmd_fibcontext = aac_fib_alloc_tag(dev, scsicmd);
-	if (!cmd_fibcontext)
-		return -ENOMEM;
 
 	aac_fib_init(cmd_fibcontext);
 	dinfo = (struct aac_get_name *) fib_data(cmd_fibcontext);
@@ -1037,8 +1035,6 @@ static int aac_get_container_serial(struct scsi_cmnd * scsicmd)
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 
 	cmd_fibcontext = aac_fib_alloc_tag(dev, scsicmd);
-	if (!cmd_fibcontext)
-		return -ENOMEM;
 
 	aac_fib_init(cmd_fibcontext);
 	dinfo = (struct aac_get_serial *) fib_data(cmd_fibcontext);
@@ -1950,10 +1946,6 @@ static int aac_read(struct scsi_cmnd * scsicmd)
 	 *	Alocate and initialize a Fib
 	 */
 	cmd_fibcontext = aac_fib_alloc_tag(dev, scsicmd);
-	if (!cmd_fibcontext) {
-		printk(KERN_WARNING "aac_read: fib allocation failed\n");
-		return -1;
-	}
 
 	status = aac_adapter_read(cmd_fibcontext, scsicmd, lba, count);
 
@@ -2048,16 +2040,6 @@ static int aac_write(struct scsi_cmnd * scsicmd)
 	 *	Allocate and initialize a Fib then setup a BlockWrite command
 	 */
 	cmd_fibcontext = aac_fib_alloc_tag(dev, scsicmd);
-	if (!cmd_fibcontext) {
-		/* FIB temporarily unavailable,not catastrophic failure */
-
-		/* scsicmd->result = DID_ERROR << 16;
-		 * scsicmd->scsi_done(scsicmd);
-		 * return 0;
-		 */
-		printk(KERN_WARNING "aac_write: fib allocation failed\n");
-		return -1;
-	}
 
 	status = aac_adapter_write(cmd_fibcontext, scsicmd, lba, count, fua);
 
@@ -2283,8 +2265,6 @@ static int aac_start_stop(struct scsi_cmnd *scsicmd)
 	 *	Allocate and initialize a Fib
 	 */
 	cmd_fibcontext = aac_fib_alloc_tag(aac, scsicmd);
-	if (!cmd_fibcontext)
-		return SCSI_MLQUEUE_HOST_BUSY;
 
 	aac_fib_init(cmd_fibcontext);
 
@@ -3184,8 +3164,6 @@ static int aac_send_srb_fib(struct scsi_cmnd* scsicmd)
 	 *	Allocate and initialize a Fib then setup a BlockWrite command
 	 */
 	cmd_fibcontext = aac_fib_alloc_tag(dev, scsicmd);
-	if (!cmd_fibcontext)
-		return -1;
 
 	status = aac_adapter_scsi(cmd_fibcontext, scsicmd);
 

