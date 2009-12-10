From: Swen Schillig <swen.schillig@googlemail.com>
Subject: [RFC] let LLD handle bsg_job_timeout
Date: Thu, 10 Dec 2009 09:45:23 +0100
Message-ID: <1260434723.2955.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:35072 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583AbZLJIpV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2009 03:45:21 -0500
Received: by fxm5 with SMTP id 5so8595324fxm.28
        for <linux-scsi@vger.kernel.org>; Thu, 10 Dec 2009 00:45:26 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de

The current fc_bsg_job_timeout function offers 
only two possibilities to a LLD to deal with timed out requests.
Either you deal with it offering a callback or not, 
in both scenarios the environment is cleaned up afterwards.

Unfortunately we (zfcp) don't have the option
to easily abort a request. Our hardware is running its 
own timer taking care of requests but unfortunately our only chance is
to wait until we receive a response. Up until then we need
the environment because the hardware might write into the provided
buffers.

The following code snippet would solve the issue for us
but maybe someone has a better idea on how to deal with the
described situation.

Cheers Swen
---
 drivers/scsi/scsi_transport_fc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: HEAD/drivers/scsi/scsi_transport_fc.c
===================================================================
--- HEAD.orig/drivers/scsi/scsi_transport_fc.c
+++ HEAD/drivers/scsi/scsi_transport_fc.c
@@ -3500,7 +3500,10 @@ fc_bsg_job_timeout(struct request *req)
 	if (!done && i->f->bsg_timeout) {
 		/* call LLDD to abort the i/o as it has timed out */
 		err = i->f->bsg_timeout(job);
-		if (err)
+		if (err == -EAGAIN) {
+			job->ref_cnt--;
+			return BLK_EH_RESET_TIMER;
+		} else if (err)
 			printk(KERN_ERR "ERROR: FC BSG request timeout - LLD "
 				"abort failed with status %d\n", err);
 	}
 


