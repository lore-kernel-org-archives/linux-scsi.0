From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 01/11] megaraid_sas : Do not scan non syspd drives
Date: Fri, 12 Sep 2014 18:57:13 +0530
Message-ID: <201409121329.s8CDTZNF022240@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0061.outbound.protection.outlook.com ([157.56.111.61]:37426
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753963AbaILN1i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2014 09:27:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, aradford@gmail.com

Resending the patch. Addressed the review comments from Tomas Henzl.

Current driver allow device scan for all the devices on channel 0 and 1.
E.a If we have two single drive raid volumes, we may see prints like below.
First two prints are for physical device which are used to form VD. 
Prints like this creates confusion as it is really not required to scan any
hidden physical devices. 

scsi1 : LSI SAS based MegaRAID driver
scsi 1:0:0:0: Direct-Access     LSI      MR9361-8i        4.21 PQ: 0 ANSI: 5
scsi 1:0:1:0: Direct-Access     LSI      MR9361-8i        4.21 PQ: 0 ANSI: 5
scsi 1:2:0:0: Direct-Access     LSI      MR9361-8i        4.21 PQ: 0 ANSI: 5
scsi 1:2:1:0: Direct-Access     LSI      MR9361-8i        4.21 PQ: 0 ANSI: 5

When slave_alloc called, sdev-type will not be set, so current code will always
return "0" in slave_alloc callback.
This patch make sure that driver return "-ENXIO" for non-syspd devices.

After this patch, we will see prints in syslog only for devices which are exposed. 
For current example, below print will be available in syslog.

scsi1 : LSI SAS based MegaRAID driver
scsi 1:2:0:0: Direct-Access     LSI      MR9361-8i        4.21 PQ: 0 ANSI: 5
scsi 1:2:1:0: Direct-Access     LSI      MR9361-8i        4.21 PQ: 0 ANSI: 5

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 35 ++++---------------------------
 1 file changed, 4 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ff44f2c..a894f13 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1628,36 +1628,12 @@ static struct megasas_instance *megasas_lookup_instance(u16 host_no)
 
 static int megasas_slave_configure(struct scsi_device *sdev)
 {
-	u16             pd_index = 0;
-	struct  megasas_instance *instance ;
-
-	instance = megasas_lookup_instance(sdev->host->host_no);
-
-	/*
-	* Don't export physical disk devices to the disk driver.
-	*
-	* FIXME: Currently we don't export them to the midlayer at all.
-	*        That will be fixed once LSI engineers have audited the
-	*        firmware for possible issues.
-	*/
-	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS &&
-				sdev->type == TYPE_DISK) {
-		pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
-								sdev->id;
-		if (instance->pd_list[pd_index].driveState ==
-						MR_PD_STATE_SYSTEM) {
-			blk_queue_rq_timeout(sdev->request_queue,
-				MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
-			return 0;
-		}
-		return -ENXIO;
-	}
-
 	/*
 	* The RAID firmware may require extended timeouts.
 	*/
 	blk_queue_rq_timeout(sdev->request_queue,
 		MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
+
 	return 0;
 }
 
@@ -1666,18 +1642,15 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 	u16             pd_index = 0;
 	struct megasas_instance *instance ;
 	instance = megasas_lookup_instance(sdev->host->host_no);
-	if ((sdev->channel < MEGASAS_MAX_PD_CHANNELS) &&
-				(sdev->type == TYPE_DISK)) {
+	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS) {
 		/*
 		 * Open the OS scan to the SYSTEM PD
 		 */
 		pd_index =
 			(sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
 			sdev->id;
-		if ((instance->pd_list[pd_index].driveState ==
-					MR_PD_STATE_SYSTEM) &&
-			(instance->pd_list[pd_index].driveType ==
-						TYPE_DISK)) {
+		if (instance->pd_list[pd_index].driveState ==
+					MR_PD_STATE_SYSTEM) {
 			return 0;
 		}
 		return -ENXIO;
-- 
1.8.3.1

