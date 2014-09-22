From: Chris J Arges <chris.j.arges@canonical.com>
Subject: [PATCH] mptfusion: enable no_write_same in scsi_host_template
Date: Mon, 22 Sep 2014 12:56:59 -0500
Message-ID: <1411408690-4766-1-git-send-email-chris.j.arges@canonical.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:36978 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbaIVSAe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2014 14:00:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vget.kernel.org
Cc: bruce.lucas@mongodb.com, Chris J Arges <chris.j.arges@canonical.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

When using a virtual SCSI disk in a VMWare VM if blkdev_issue_zeroout is used
data can be improperly zeroed out using the mptfusion driver. This patch
disables write_same for this driver which ensures that manual zeroing out
is used instead.

BugLink: http://bugs.launchpad.net/bugs/1371591
Reported-by: Bruce Lucas <bruce.lucas@mongodb.com>
Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
---
 drivers/message/fusion/mptspi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 787933d..2fcc9bd 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -850,6 +850,7 @@ static struct scsi_host_template mptspi_driver_template = {
 	.cmd_per_lun			= 7,
 	.use_clustering			= ENABLE_CLUSTERING,
 	.shost_attrs			= mptscsih_host_attrs,
+	.no_write_same                  = 1,
 };
 
 static int mptspi_write_spi_device_pg1(struct scsi_target *starget,
-- 
1.9.1

