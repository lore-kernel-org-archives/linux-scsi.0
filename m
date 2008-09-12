From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH 4/5] fusion prevent DV deadlock
Date: Fri, 12 Sep 2008 21:02:16 +0200
Message-ID: <200809122102.17306.bs@q-leap.de>
References: <200809122057.41565.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:41666 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034AbYILTCW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2008 15:02:22 -0400
In-Reply-To: <200809122057.41565.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Eric Moore <Eric.Moore@lsi.com>, Sathya Prakash <Sathya.Prakash@lsi.com>

The mpt fusion driver will do a domain revalidation on an ion reset, this
DV might cause a live deadlock. The problem has been entirely analyzed in
this thread, but so far no real solution has been implemented.
This patch simply disables the domain revalidation, if it will run into
the deadlock.

Signed-off-by: Bernd Schubert <bs@q-leap.de>

 drivers/message/fusion/mptspi.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


Index: linux-2.6.26/drivers/message/fusion/mptspi.c
===================================================================
--- linux-2.6.26.orig/drivers/message/fusion/mptspi.c
+++ linux-2.6.26/drivers/message/fusion/mptspi.c
@@ -672,12 +672,24 @@ static void mptspi_dv_device(struct _MPT
 {
 	VirtTarget *vtarget = scsi_target(sdev)->hostdata;
 	MPT_ADAPTER *ioc = hd->ioc;
+	unsigned long nr_requests = sdev->request_queue->nr_requests;
+	struct request_list *rl = &sdev->request_queue->rq;
 
 	/* no DV on RAID devices */
 	if (sdev->channel == 0 &&
 	    mptspi_is_raid(hd, sdev->id))
 		return;
 
+	if (rl->count[0] + 1 >= nr_requests
+	||  rl->count[1] + 1 >= nr_requests) {
+		/* we must NOT do a DV after an error recovery, when we
+		 * don't have left a space in the request list, since
+		 * this will cause a live dead lock */
+		starget_printk(KERN_INFO, scsi_target(sdev), MYIOC_s_FMT
+		    "Skipping DV, to prevent dead lock!\n", ioc->name);
+		return;
+	}
+
 	/* If this is a piece of a RAID, then quiesce first */
 	if (sdev->channel == 1 &&
 	    mptscsih_quiesce_raid(hd, 1, vtarget->channel, vtarget->id) < 0) {
