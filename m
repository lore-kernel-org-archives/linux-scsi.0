From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] serialize bus scanning
Date: Wed, 10 Sep 2003 17:57:42 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030910075741.GC1532@krispykreme>
References: <20030825122416.GE15506@lst.de> <20030827202908.GB7852@krispykreme> <20030827203544.GA27020@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:56717 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S264762AbTIJIC1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 04:02:27 -0400
Content-Disposition: inline
In-Reply-To: <20030827203544.GA27020@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

 
> you can just add a per-host mutex and lock it in the same places as
> indicated by the comment in the patch.  

How does this look? This restores the ability to do parallel scsi scan
via sysfs.

Anton

--

Change scsi_scan_mutex from global to per host, which is needed for
parallel SCSI probe.


 gr16_work-anton/drivers/scsi/hosts.c     |    2 ++
 gr16_work-anton/drivers/scsi/scsi_scan.c |   15 ++++-----------
 gr16_work-anton/include/scsi/scsi_host.h |    6 ++++++
 3 files changed, 12 insertions(+), 11 deletions(-)

diff -puN drivers/scsi/scsi_scan.c~per_host_scan_mutex drivers/scsi/scsi_scan.c
--- gr16_work/drivers/scsi/scsi_scan.c~per_host_scan_mutex	2003-09-07 00:01:57.000000000 -0500
+++ gr16_work-anton/drivers/scsi/scsi_scan.c	2003-09-07 00:01:57.000000000 -0500
@@ -95,13 +95,6 @@ MODULE_PARM_DESC(max_report_luns,
 		 " between 1 and 16384)");
 #endif
 
-/*
- * This mutex serializes all scsi scanning activity from kernel- and
- * userspace.  It could easily be made per-host but I'd like to avoid
- * the overhead for now.
- */
-static DECLARE_MUTEX(scsi_scan_mutex);
-
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
  * @sreq:	used to send the command
@@ -1075,11 +1068,11 @@ struct scsi_device *scsi_add_device(stru
 	struct scsi_device *sdev;
 	int res;
 
-	down(&scsi_scan_mutex);
+	down(&shost->scan_mutex);
 	res = scsi_probe_and_add_lun(shost, channel, id, lun, NULL, &sdev, 1);
 	if (res != SCSI_SCAN_LUN_PRESENT)
 		sdev = ERR_PTR(-ENODEV);
-	up(&scsi_scan_mutex);
+	up(&shost->scan_mutex);
 
 	return sdev;
 }
@@ -1202,13 +1195,13 @@ int scsi_scan_host_selected(struct Scsi_
 	    ((lun != SCAN_WILD_CARD) && (lun > shost->max_lun)))
 		return -EINVAL;
 
-	down(&scsi_scan_mutex);
+	down(&shost->scan_mutex);
 	if (channel == SCAN_WILD_CARD) 
 		for (channel = 0; channel <= shost->max_channel; channel++)
 			scsi_scan_channel(shost, channel, id, lun, rescan);
 	else
 		scsi_scan_channel(shost, channel, id, lun, rescan);
-	up(&scsi_scan_mutex);
+	up(&shost->scan_mutex);
 
 	return 0;
 }
diff -puN include/scsi/scsi_host.h~per_host_scan_mutex include/scsi/scsi_host.h
--- gr16_work/include/scsi/scsi_host.h~per_host_scan_mutex	2003-09-07 00:01:57.000000000 -0500
+++ gr16_work-anton/include/scsi/scsi_host.h	2003-09-10 02:53:34.000000000 -0500
@@ -480,6 +480,12 @@ struct Scsi_Host {
 	struct list_head sht_legacy_list;
 
 	/*
+	 * This mutex serializes all scsi scanning activity from kernel- and
+	 * userspace.
+	 */
+	struct semaphore scan_mutex;
+
+	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
 	 * alignment to a long boundary.
diff -puN drivers/scsi/hosts.c~per_host_scan_mutex drivers/scsi/hosts.c
--- gr16_work/drivers/scsi/hosts.c~per_host_scan_mutex	2003-09-07 00:01:57.000000000 -0500
+++ gr16_work-anton/drivers/scsi/hosts.c	2003-09-07 00:01:57.000000000 -0500
@@ -214,6 +214,8 @@ struct Scsi_Host *scsi_host_alloc(struct
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
 
+	init_MUTEX(&shost->scan_mutex);
+
 	shost->host_no = scsi_host_next_hn++; /* XXX(hch): still racy */
 	shost->dma_channel = 0xff;
 

_
