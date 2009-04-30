From: David VomLehn <dvomlehn@cisco.com>
Subject: [PATCH 5/5] USB: Wait for USB and SCSI block boot devices
Date: Wed, 29 Apr 2009 17:12:55 -0700
Message-ID: <20090430001255.GA3897@cuplxvomd02.corp.sa.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761551AbZD3ANS@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-usb@vger.kernel.org
Cc: gregkh@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu

Add synchronization for USB and SCSI block devices.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu
Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 drivers/scsi/scsi_scan.c  |    2 ++
 drivers/usb/storage/usb.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 6f51ca4..735b061 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1834,6 +1834,7 @@ static int do_scan_async(void *_data)
 	struct async_scan_data *data = _data;
 	do_scsi_scan_host(data->shost);
 	scsi_finish_async_scan(data);
+	bootdev_probe_done(BOOTDEV_BLOCK_MASK);
 	return 0;
 }
 
@@ -1855,6 +1856,7 @@ void scsi_scan_host(struct Scsi_Host *shost)
 		return;
 	}
 
+	bootdev_found(BOOTDEV_BLOCK_MASK);
 	p = kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
 	if (IS_ERR(p))
 		do_scan_async(data);
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 8060b85..c128c44 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -810,6 +810,7 @@ static int usb_stor_scan_thread(void * __us)
 
 	printk(KERN_DEBUG
 		"usb-storage: device found at %d\n", us->pusb_dev->devnum);
+	bootdev_found(BOOTDEV_BLOCK_MASK);
 
 	set_freezable();
 	/* Wait for the timeout to expire or for a disconnect */
@@ -837,6 +838,7 @@ static int usb_stor_scan_thread(void * __us)
 		/* Should we unbind if no devices were detected? */
 	}
 
+	bootdev_probe_done(BOOTDEV_BLOCK_MASK);
 	complete_and_exit(&us->scanning_done, 0);
 }
 
