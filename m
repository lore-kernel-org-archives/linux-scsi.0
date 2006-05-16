From: James Smart <James.Smart@Emulex.Com>
Subject: [REPOST #2][PATCH] update max sdev block limit
Date: Tue, 16 May 2006 16:13:36 -0400
Message-ID: <1147810416.3634.0.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:9368 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1750712AbWEPULM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 16:11:12 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k4GKBAoi014105
	for <linux-scsi@vger.kernel.org>; Tue, 16 May 2006 13:11:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Updated patch to address comments from Pat Mansfield and Michael Reed:
Bumped max to 600 (10mins). Set default dev_loss_tmo to a value other
than the max (30s).
----
Updated patch to address comments from Andreas Herrman, who noted that
the initialization, with the HZ, was inconsistent with its use in the
FC transport.
--
This patch ups the maximum limit for how long an sdev is allowed to
be blocked. Originally, the value was 60 seconds. However, we are aware
of array failover and switch reboot times that can be as high
as 90 seconds. We're proposing to change the max to 120 seconds.

-- james s


Signed-off-by: James Smart <James.Smart@emulex.com>

diff -upNr a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	2006-05-10 11:36:25.000000000 -0400
+++ b/drivers/scsi/scsi_priv.h	2006-05-16 13:55:45.000000000 -0400
@@ -127,7 +127,7 @@ extern struct bus_type scsi_bus_type;
  * classes.
  */
 
-#define SCSI_DEVICE_BLOCK_MAX_TIMEOUT	(HZ*60)
+#define SCSI_DEVICE_BLOCK_MAX_TIMEOUT	600	/* units in seconds */
 extern int scsi_internal_device_block(struct scsi_device *sdev);
 extern int scsi_internal_device_unblock(struct scsi_device *sdev);
 
diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2006-05-11 10:31:54.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2006-05-16 13:57:55.000000000 -0400
@@ -368,7 +368,7 @@ static DECLARE_TRANSPORT_CLASS(fc_rport_
  *   should insulate the loss of a remote port.
  *   The maximum will be capped by the value of SCSI_DEVICE_BLOCK_MAX_TIMEOUT.
  */
-static unsigned int fc_dev_loss_tmo = SCSI_DEVICE_BLOCK_MAX_TIMEOUT;
+static unsigned int fc_dev_loss_tmo = 60;		/* seconds */
 
 module_param_named(dev_loss_tmo, fc_dev_loss_tmo, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(dev_loss_tmo,


