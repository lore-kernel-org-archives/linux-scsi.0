From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH as448] Fix reference to deallocated memory in sr.c
Date: Tue, 18 Jan 2005 09:56:22 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0501180955020.1457-100000@ida.rowland.org>
References: <Pine.LNX.4.44L0.0501141052040.1341-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:2052 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261312AbVARO4Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 09:56:25 -0500
In-Reply-To: <Pine.LNX.4.44L0.0501141052040.1341-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

When I posted a patch last week to fix a reference to deallocated memory 
in sd.c, I forgot to check whether the same problem exists in sr.c.  It 
does, and here's the patch to fix it.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

===== drivers/scsi/sr.c 1.78 vs edited =====
--- 1.78/drivers/scsi/sr.c	2005-01-11 11:57:28 -05:00
+++ edited/drivers/scsi/sr.c	2005-01-18 09:53:50 -05:00
@@ -152,9 +152,11 @@
 
 static inline void scsi_cd_put(struct scsi_cd *cd)
 {
+	struct scsi_device *sdev = cd->device;
+
 	down(&sr_ref_sem);
 	kref_put(&cd->kref, sr_kref_release);
-	scsi_device_put(cd->device);
+	scsi_device_put(sdev);
 	up(&sr_ref_sem);
 }
 

