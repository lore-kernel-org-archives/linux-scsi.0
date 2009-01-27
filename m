From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] scsi_scan.c : add missing interim SDEV_DEL state if
	slave_alloc fails
Date: Tue, 27 Jan 2009 10:39:58 -0500
Message-ID: <1233070798.22506.5.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46288 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbZA0PkG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jan 2009 10:40:06 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n0RFe5hm022939
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2009 07:40:05 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


We were running i/o and performing a bunch of hba resets in a loop.
This forces a lot of target removes and rescans. Since the resets
are occuring during scan it's causing the scan i/o to timeout or fail,
invoking error recovery, etc.  We end up getting a nasty crash
in scsi_scan.c due to references to old sdevs that had some
lingering references that kept them around.

Fix by setting device state to SDEV_DEL if the LLD's slave_alloc
fails. This will fail reference taking in subsequent teardown/scan paths.

-- james s


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 scsi_scan.c |    1 +
 1 file changed, 1 insertion(+)


diff -upNr a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	2009-01-27 09:44:31.000000000 -0500
+++ b/drivers/scsi/scsi_scan.c	2009-01-27 10:12:04.000000000 -0500
@@ -310,6 +310,7 @@ static struct scsi_device *scsi_alloc_sd
 			 */
 			if (ret == -ENXIO)
 				display_failure_msg = 0;
+			scsi_device_set_state(sdev, SDEV_DEL);
 			goto out_device_destroy;
 		}
 	}


