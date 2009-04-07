From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] scsi_transport_fc.c : .29 merge fix for FC passthru patch
Date: Tue, 7 Apr 2009 13:48:42 -0400
Message-ID: <1239126522.8975.2.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:64226 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758589AbZDGRsz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 13:48:55 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n37Hmq5m011741
	for <linux-scsi@vger.kernel.org>; Tue, 7 Apr 2009 10:48:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

James,

It appears that the latest merge of scsi-misc-2.6 picked up a kernel change
that killed the bus_id element from struct device.

Here's a quick patch to resolve the inconsistency.  I assumed this was easier
than regen-ing the fc pass-thru patch.

This patch to be applied on top of the fc-pass-thru patch.

-- james s


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 scsi_transport_fc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2009-04-07 13:38:38.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2009-04-07 13:39:18.000000000 -0400
@@ -3920,7 +3920,7 @@ fc_bsg_rportadd(struct Scsi_Host *shost,
 	if (!q) {
 		printk(KERN_ERR "%s: bsg interface failed to "
 				"initialize - no request queue\n",
-				 dev->bus_id);
+				 dev->kobj.name);
 		return -ENOMEM;
 	}
 
@@ -3933,7 +3933,7 @@ fc_bsg_rportadd(struct Scsi_Host *shost,
 	if (err) {
 		printk(KERN_ERR "%s: bsg interface failed to "
 				"initialize - register queue\n",
-				 dev->bus_id);
+				 dev->kobj.name);
 		blk_cleanup_queue(q);
 		return err;
 	}


