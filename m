From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH linux-misc-2.6] scsi: remove volatile from scsi data structures
Date: Sun, 10 Apr 2005 13:14:04 +0900
Message-ID: <20050410041404.GA24158@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.204]:58950 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261428AbVDJEOJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Apr 2005 00:14:09 -0400
Received: by rproxy.gmail.com with SMTP id g11so1905533rne
        for <linux-scsi@vger.kernel.org>; Sat, 09 Apr 2005 21:14:09 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

 Hello, James.
 Hello, Christoph.

 This patch removes volatile qualifier from scsi_device->device_busy,
Scsi_Host->host_busy and ->host_failed as the volatile qualifiers
don't serve any purpose now.  While at it, convert those fields from
unsigned short to unsigned int as suggested by Christoph.


Signed-off-by: Tejun Heo <htejun@gmail.com>


Index: scsi-reqfn-export/include/scsi/scsi_device.h
===================================================================
--- scsi-reqfn-export.orig/include/scsi/scsi_device.h	2005-04-10 13:03:14.000000000 +0900
+++ scsi-reqfn-export/include/scsi/scsi_device.h	2005-04-10 13:04:42.000000000 +0900
@@ -43,7 +43,8 @@ struct scsi_device {
 	struct list_head    siblings;   /* list of all devices on this host */
 	struct list_head    same_target_siblings; /* just the devices sharing same target id */
 
-	volatile unsigned short device_busy;	/* commands actually active on low-level */
+	unsigned int device_busy;	/* commands actually active on
+					 * low-level. protected by queue_lock. */
 	spinlock_t sdev_lock;           /* also the request queue_lock */
 	spinlock_t list_lock;
 	struct list_head cmd_list;	/* queue of in use SCSI Command structures */
Index: scsi-reqfn-export/include/scsi/scsi_host.h
===================================================================
--- scsi-reqfn-export.orig/include/scsi/scsi_host.h	2005-04-10 13:03:14.000000000 +0900
+++ scsi-reqfn-export/include/scsi/scsi_host.h	2005-04-10 13:04:42.000000000 +0900
@@ -448,8 +448,14 @@ struct Scsi_Host {
 	wait_queue_head_t       host_wait;
 	struct scsi_host_template *hostt;
 	struct scsi_transport_template *transportt;
-	volatile unsigned short host_busy;   /* commands actually active on low-level */
-	volatile unsigned short host_failed; /* commands that failed. */
+
+	/*
+	 * The following two fields are protected with host_lock;
+	 * however, eh routines can safely access during eh processing
+	 * without acquiring the lock.
+	 */
+	unsigned int host_busy;		   /* commands actually active on low-level */
+	unsigned int host_failed;	   /* commands that failed. */
     
 	unsigned short host_no;  /* Used for IOCTL_GET_IDLUN, /proc/scsi et al. */
 	int resetting; /* if set, it means that last_reset is a valid value */
