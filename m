From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: [PATCH]st: clear driver data from struct device when released
Date: Tue, 30 Apr 2013 02:07:11 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB34392AF6@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:47885 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025Ab3D3CIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Apr 2013 22:08:11 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Patch to clear driver specific data from struct device associated with
a tape drive when released by st unload or because there was a problem
attaching to the device. Currently set in st_probe but never cleared.

Signed-off-by: Shane Seymour <shane.seymour@hp.com>
Tested-by: Shane Seymour <shane.seymour@hp.com>
---
diff -uprN linux-3.9-vanilla/drivers/scsi/st.c linux-3.9/drivers/scsi/st.c
--- linux-3.9-vanilla/drivers/scsi/st.c	2013-04-29 01:36:01.000000000 +0100
+++ linux-3.9/drivers/scsi/st.c	2013-04-30 02:39:51.000000000 +0100
@@ -4212,6 +4212,7 @@ static int st_probe(struct device *dev)
 
 out_remove_devs:
 	remove_cdevs(tpnt);
+	dev_set_drvdata(dev, NULL);
 	spin_lock(&st_index_lock);
 	idr_remove(&st_index_idr, tpnt->index);
 	spin_unlock(&st_index_lock);
@@ -4258,6 +4259,7 @@ static void scsi_tape_release(struct kre
 	struct scsi_tape *tpnt = to_scsi_tape(kref);
 	struct gendisk *disk = tpnt->disk;
 
+	dev_set_drvdata(&tpnt->device->sdev_gendev, NULL);
 	tpnt->device = NULL;
 
 	if (tpnt->buffer) {
