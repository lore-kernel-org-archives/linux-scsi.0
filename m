From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 1/1] Fusion: SAS: don't set queue depth to 1 when sdev->id
 is greater than sh->max_id
Date: Wed, 21 May 2008 15:21:28 -0500
Message-ID: <48348448.4020508@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57601 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763168AbYEUUVd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2008 16:21:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

This patch was originally part of a patch posted March 13, 2008.
I'm breaking this out into a separate patch as it's only somewhat related.
Applies cleanly against Sathya's latest patch and will apply correctly
(offset +29) to 2.6.26-rc3-git3.

--

Change mptscsih_slave_configure so it doesn't set the queue depth to 1 for SAS
protocol when sdev->id is greater than sh->max_id.   The sas transport
layer assigns the target ids, incrementing with each hotplug add.  With
large topologies, it doesn't take long to hit this threshold.

Signed-off-by: Michael Reed <mdr@sgi.com>


--- linux-2.6.26-rc3-git3.orig/drivers/message/fusion/mptscsih.c	2008-05-21 15:06:59.212691745 -0500
+++ linux-2.6.26-rc3-git3/drivers/message/fusion/mptscsih.c	2008-05-21 15:08:04.323836957 -0500
@@ -2422,12 +2422,6 @@ mptscsih_slave_configure(struct scsi_dev
 		    ioc->name, sdev->sdtr, sdev->wdtr,
 		    sdev->ppr, sdev->inquiry_len));
 
-	if (sdev->id > sh->max_id) {
-		/* error case, should never happen */
-		scsi_adjust_queue_depth(sdev, 0, 1);
-		goto slave_configure_exit;
-	}
-
 	vdevice->configured_lun = 1;
 	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH);
 
@@ -2441,8 +2435,6 @@ mptscsih_slave_configure(struct scsi_dev
 		    ioc->name, vtarget->negoFlags, vtarget->maxOffset,
 		    vtarget->minSyncFactor));
 
-slave_configure_exit:
-
 	dsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		"tagged %d, simple %d, ordered %d\n",
 		ioc->name,sdev->tagged_supported, sdev->simple_tags,
