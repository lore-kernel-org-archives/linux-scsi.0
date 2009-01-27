From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] [Repost] scsi_scan.c : add missing interim SDEV_DEL state
	if slave_alloc fails
Date: Tue, 27 Jan 2009 11:41:36 -0500
Message-ID: <1233074496.28964.0.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52686 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbZA0Qlk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jan 2009 11:41:40 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n0RGfd8f029477
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2009 08:41:40 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Reworked per James's suggestion
----

We were running i/o and performing a bunch of hba resets in a loop.
This forces a lot of target removes and then rescans. Since the
resets are occuring during scan it's causing the scan i/o to timeout,
invoking error recovery, etc.  We end up getting some nasty crashing
in scsi_scan.c due to references to old sdevs that are failing 
but had some lingering references that kept them around.

Fix by setting device state to SDEV_DEL if the LLD's slave_alloc
fails.

-- james s


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 scsi_scan.c |    1 +
 1 file changed, 1 insertion(+)


diff -upNr a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	2009-01-27 09:44:31.000000000 -0500
+++ b/drivers/scsi/scsi_scan.c	2009-01-27 11:39:52.000000000 -0500
@@ -317,6 +317,7 @@ static struct scsi_device *scsi_alloc_sd
 	return sdev;
 
 out_device_destroy:
+	scsi_device_set_state(sdev, SDEV_DEL);
 	transport_destroy_device(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_gendev);
 out:


