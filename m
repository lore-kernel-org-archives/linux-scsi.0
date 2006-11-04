From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill scsi_assign_lock
Date: Sat, 4 Nov 2006 20:11:36 +0100
Message-ID: <20061104191136.GC23477@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:55235 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1753633AbWKDTLi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Nov 2006 14:11:38 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

scsi_assign_lock has been unused for a long time and is a bad idea
in general, so kill it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/Documentation/scsi/scsi_mid_low_api.txt
===================================================================
--- scsi-misc-2.6.orig/Documentation/scsi/scsi_mid_low_api.txt	2006-07-09 17:27:57.000000000 +0200
+++ scsi-misc-2.6/Documentation/scsi/scsi_mid_low_api.txt	2006-11-02 16:53:18.000000000 +0100
@@ -375,7 +375,6 @@
    scsi_add_device - creates new scsi device (lu) instance
    scsi_add_host - perform sysfs registration and set up transport class
    scsi_adjust_queue_depth - change the queue depth on a SCSI device
-   scsi_assign_lock - replace default host_lock with given lock
    scsi_bios_ptable - return copy of block device's partition table
    scsi_block_requests - prevent further commands being queued to given host
    scsi_deactivate_tcq - turn off tag command queueing
@@ -489,20 +488,6 @@
 
 
 /**
- * scsi_assign_lock - replace default host_lock with given lock
- * @shost: a pointer to a scsi host instance
- * @lock: pointer to lock to replace host_lock for this host
- *
- *      Returns nothing
- *
- *      Might block: no
- *
- *      Defined in: include/scsi/scsi_host.h .
- **/
-void scsi_assign_lock(struct Scsi_Host *shost, spinlock_t *lock)
-
-
-/**
  * scsi_bios_ptable - return copy of block device's partition table
  * @dev:        pointer to block device
  *
@@ -1366,17 +1351,11 @@
 Each struct Scsi_Host instance has a spin_lock called struct 
 Scsi_Host::default_lock which is initialized in scsi_host_alloc() [found in 
 hosts.c]. Within the same function the struct Scsi_Host::host_lock pointer
-is initialized to point at default_lock with the scsi_assign_lock() function.
-Thereafter lock and unlock operations performed by the mid level use the
-struct Scsi_Host::host_lock pointer.
-
-LLDs can override the use of struct Scsi_Host::default_lock by
-using scsi_assign_lock(). The earliest opportunity to do this would
-be in the detect() function after it has invoked scsi_register(). It
-could be replaced by a coarser grain lock (e.g. per driver) or a
-lock of equal granularity (i.e. per host). Using finer grain locks 
-(e.g. per SCSI device) may be possible by juggling locks in
-queuecommand().
+is initialized to point at default_lock.  Thereafter lock and unlock
+operations performed by the mid level use the struct Scsi_Host::host_lock
+pointer.  Previously drivers could override the host_lock pointer but
+this is not allowed anymore.
+
 
 Autosense
 =========
Index: scsi-misc-2.6/drivers/scsi/hosts.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/hosts.c	2006-10-30 17:00:22.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/hosts.c	2006-11-02 16:53:18.000000000 +0100
@@ -301,8 +301,8 @@
 	if (!shost)
 		return NULL;
 
-	spin_lock_init(&shost->default_lock);
-	scsi_assign_lock(shost, &shost->default_lock);
+	shost->host_lock = &shost->default_lock;
+	spin_lock_init(shost->host_lock);
 	shost->shost_state = SHOST_CREATED;
 	INIT_LIST_HEAD(&shost->__devices);
 	INIT_LIST_HEAD(&shost->__targets);
Index: scsi-misc-2.6/include/scsi/scsi_host.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_host.h	2006-10-30 17:00:35.000000000 +0100
+++ scsi-misc-2.6/include/scsi/scsi_host.h	2006-11-02 16:53:18.000000000 +0100
@@ -651,11 +651,6 @@
 
 extern u64 scsi_calculate_bounce_limit(struct Scsi_Host *);
 
-static inline void scsi_assign_lock(struct Scsi_Host *shost, spinlock_t *lock)
-{
-	shost->host_lock = lock;
-}
-
 static inline struct device *scsi_get_device(struct Scsi_Host *shost)
 {
         return shost->shost_gendev.parent;
