From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH][sas] Fix potential NULL pointer dereference bug in sas_smp_handler()
Date: Fri, 27 Jul 2007 21:58:41 +0200
Message-ID: <200707272158.41374.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:30366 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765470AbXG0T75 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 15:59:57 -0400
Received: by ug-out-1314.google.com with SMTP id j3so764601ugf
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jul 2007 12:59:56 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, James Bottomley <James.Bottomley@steeleye.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jesper Juhl <jesper.juhl@gmail.com>


Hi,

The Coverity checker found a problem in 
drivers/scsi/libsas/sas_expander.c::sas_smp_handler().
We dereference a pointer before testing if it is NULL. Easily fixed 
in this case by simply moving an assignment down a bit.

Please consider for inclusion.

Patch has been compile tested only.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/scsi/libsas/sas_expander.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index b500f0c..7871406 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1879,7 +1879,7 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		    struct request *req)
 {
 	struct domain_device *dev;
-	int ret, type = rphy->identify.device_type;
+	int ret, type;
 	struct request *rsp = req->next_rq;
 
 	if (!rsp) {
@@ -1895,6 +1895,8 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		return -EINVAL;
 	}
 
+	type = rphy->identify.device_type;
+
 	if (type != SAS_EDGE_EXPANDER_DEVICE &&
 	    type != SAS_FANOUT_EXPANDER_DEVICE) {
 		printk("%s: can we send a smp request to a device?\n",





  PS. Please keep me on Cc when replying.


