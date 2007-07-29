From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/6] aha152x.c - use bounce buffer
Date: Sun, 29 Jul 2007 22:18:20 +0300
Message-ID: <46ACE7FC.8030202@panasas.com>
References: <46ACE62F.4070108@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:5446 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760093AbXG2TSb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jul 2007 15:18:31 -0400
In-Reply-To: <46ACE62F.4070108@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, =?ISO-8859-1?Q?=22J=FC?= =?ISO-8859-1?Q?rgen_E=2E_Fischer=22?= <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>


Cause highmem buffers to be bounced to low memory until this
driver supports highmem addresses.  Otherwise it just oopses
on NULL buffer addresses.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

---
 drivers/scsi/aha152x.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 0afc0c9..c841f11 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -3474,6 +3474,12 @@ static int aha152x_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start
 	return thislength < length ? thislength : length;
 }
 
+static int aha152x_adjust_queue(struct scsi_device *device)
+{
+	blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_HIGH);
+	return 0;
+}
+
 static struct scsi_host_template aha152x_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= AHA152X_REVID,
@@ -3490,6 +3496,7 @@ static struct scsi_host_template aha152x_driver_template = {
 	.sg_tablesize			= SG_ALL,
 	.cmd_per_lun			= 1,
 	.use_clustering			= DISABLE_CLUSTERING,
+	.slave_alloc			= aha152x_adjust_queue,
 };
 
 #if !defined(PCMCIA)
-- 
1.5.2.2.249.g45fd


