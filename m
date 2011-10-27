From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH] scsi_dh_alua: Fix the time inteval for alua rtpg commands
Date: Thu, 27 Oct 2011 14:36:32 -0400
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD91050E54E@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:32732 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362Ab1J0Sgv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2011 14:36:51 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, hare@suse.de

This patch corrects the retry interval for alua rtpg command. Purpose was to retry the commands in seconds.
But that was not happening. Reason is msleep takes argument in milliseconds.

Also added minor text after successful attach. 

Signed-off-by: Babu Moger <babu.moger@netapp.com>
CC: Hannes Reinecke <hare@suse.de> 
---

--- linux-3.1-rc4/drivers/scsi/device_handler/scsi_dh_alua.c.orig	2011-10-26 11:36:11.000000000 -0500
+++ linux-3.1-rc4/drivers/scsi/device_handler/scsi_dh_alua.c	2011-10-27 12:50:41.000000000 -0500
@@ -507,7 +507,7 @@ static int alua_rtpg(struct scsi_device 
 	int len, k, off, valid_states = 0;
 	unsigned char *ucp;
 	unsigned err;
-	unsigned long expiry, interval = 1;
+	unsigned long expiry, interval = 1000;
 
 	expiry = round_jiffies_up(jiffies + ALUA_FAILOVER_TIMEOUT);
  retry:
@@ -734,6 +734,7 @@ static int alua_bus_attach(struct scsi_d
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	sdev->scsi_dh_data = scsi_dh_data;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+	sdev_printk(KERN_NOTICE, sdev, "%s: Attached\n", ALUA_DH_NAME);
 
 	return 0;
 


