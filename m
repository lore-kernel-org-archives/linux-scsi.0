From: Li Dongyang <dongyang.li@anu.edu.au>
Subject: [REPOST PATCH] scsi: ses: don't ask for diagnostic pages repeatedly during probe
Date: Tue, 14 Nov 2017 10:48:04 +1100
Message-ID: <20171113234804.4675-1-dongyang.li@anu.edu.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from maildrop2.anu.edu.au ([130.56.64.108]:52444 "EHLO
        maildrop2.anu.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751521AbdKMXs5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2017 18:48:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

We are testing if there is a match with the ses device in a loop
by calling ses_match_to_enclosure(), which will issue scsi receive
diagnostics commands to the ses device for every device on the
same host.
On one of our boxes with 840 disks, it takes a long time to load
the driver:

[root@g1b-oss06 ~]# time modprobe ses

real	40m48.247s
user	0m0.001s
sys	0m0.196s

With the patch:

[root@g1b-oss06 ~]# time modprobe ses

real	0m17.915s
user	0m0.008s
sys	0m0.053s

Note that we still need to refresh page 10 when we see a new disk
to create the link.

Signed-off-by: Li Dongyang <dongyang.li@anu.edu.au>
---
 drivers/scsi/ses.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 11826c5c2dd4..62f04c0511cf 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -615,13 +615,16 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 }
 
 static void ses_match_to_enclosure(struct enclosure_device *edev,
-				   struct scsi_device *sdev)
+				   struct scsi_device *sdev,
+				   int refresh)
 {
+	struct scsi_device *edev_sdev = to_scsi_device(edev->edev.parent);
 	struct efd efd = {
 		.addr = 0,
 	};
 
-	ses_enclosure_data_process(edev, to_scsi_device(edev->edev.parent), 0);
+	if (refresh)
+		ses_enclosure_data_process(edev, edev_sdev, 0);
 
 	if (scsi_is_sas_rphy(sdev->sdev_target->dev.parent))
 		efd.addr = sas_get_address(sdev);
@@ -652,7 +655,7 @@ static int ses_intf_add(struct device *cdev,
 		struct enclosure_device *prev = NULL;
 
 		while ((edev = enclosure_find(&sdev->host->shost_gendev, prev)) != NULL) {
-			ses_match_to_enclosure(edev, sdev);
+			ses_match_to_enclosure(edev, sdev, 1);
 			prev = edev;
 		}
 		return -ENODEV;
@@ -768,7 +771,7 @@ static int ses_intf_add(struct device *cdev,
 	shost_for_each_device(tmp_sdev, sdev->host) {
 		if (tmp_sdev->lun != 0 || scsi_device_enclosure(tmp_sdev))
 			continue;
-		ses_match_to_enclosure(edev, tmp_sdev);
+		ses_match_to_enclosure(edev, tmp_sdev, 0);
 	}
 
 	return 0;
-- 
2.14.2
