From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 06/07] scsi: Delete scsi_{add|delete}_timer() from scsi_mid_low_api.txt
Date: Mon, 11 Apr 2005 03:45:36 +0900 (KST)
Message-ID: <20050410184215.11E583D9@htj.dyndns.org>
References: <20050410184214.4AAD0992@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.194]:54827 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261574AbVDJSpp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Apr 2005 14:45:45 -0400
Received: by wproxy.gmail.com with SMTP id 68so2417177wra
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2005 11:45:42 -0700 (PDT)
In-Reply-To: <20050410184214.4AAD0992@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

06_scsi_timer_update_api_doc.patch

	As scsi_{add|delete}_timer() got unexported, remove them from
	the API doc.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi_mid_low_api.txt |   41 -----------------------------------------
 1 files changed, 41 deletions(-)

Index: scsi-reqfn-export/Documentation/scsi/scsi_mid_low_api.txt
===================================================================
--- scsi-reqfn-export.orig/Documentation/scsi/scsi_mid_low_api.txt	2005-04-11 03:42:09.000000000 +0900
+++ scsi-reqfn-export/Documentation/scsi/scsi_mid_low_api.txt	2005-04-11 03:42:13.000000000 +0900
@@ -373,13 +373,11 @@ Summary:
    scsi_activate_tcq - turn on tag command queueing
    scsi_add_device - creates new scsi device (lu) instance
    scsi_add_host - perform sysfs registration and SCSI bus scan.
-   scsi_add_timer - (re-)start timer on a SCSI command.
    scsi_adjust_queue_depth - change the queue depth on a SCSI device
    scsi_assign_lock - replace default host_lock with given lock
    scsi_bios_ptable - return copy of block device's partition table
    scsi_block_requests - prevent further commands being queued to given host
    scsi_deactivate_tcq - turn off tag command queueing
-   scsi_delete_timer - cancel timer on a SCSI command.
    scsi_host_alloc - return a new scsi_host instance whose refcount==1
    scsi_host_get - increments Scsi_Host instance's refcount
    scsi_host_put - decrements Scsi_Host instance's refcount (free if 0)
@@ -461,27 +459,6 @@ int scsi_add_host(struct Scsi_Host *shos
 
 
 /**
- * scsi_add_timer - (re-)start timer on a SCSI command.
- * @scmd:    pointer to scsi command instance
- * @timeout: duration of timeout in "jiffies"
- * @complete: pointer to function to call if timeout expires
- *
- *      Returns nothing
- *
- *      Might block: no
- *
- *      Notes: Each scsi command has its own timer, and as it is added
- *      to the queue, we set up the timer. When the command completes, 
- *      we cancel the timer. An LLD can use this function to change
- *      the existing timeout value.
- *
- *      Defined in: drivers/scsi/scsi_error.c
- **/
-void scsi_add_timer(struct scsi_cmnd *scmd, int timeout, 
-                    void (*complete)(struct scsi_cmnd *))
-
-
-/**
  * scsi_adjust_queue_depth - allow LLD to change queue depth on a SCSI device
  * @sdev:       pointer to SCSI device to change queue depth on
  * @tagged:     0 - no tagged queuing
@@ -569,24 +546,6 @@ void scsi_deactivate_tcq(struct scsi_dev
 
 
 /**
- * scsi_delete_timer - cancel timer on a SCSI command.
- * @scmd:    pointer to scsi command instance
- *
- *      Returns 1 if able to cancel timer else 0 (i.e. too late or already
- *      cancelled).
- *
- *      Might block: no [may in the future if it invokes del_timer_sync()]
- *
- *      Notes: All commands issued by upper levels already have a timeout
- *      associated with them. An LLD can use this function to cancel the
- *      timer.
- *
- *      Defined in: drivers/scsi/scsi_error.c
- **/
-int scsi_delete_timer(struct scsi_cmnd *scmd)
-
-
-/**
  * scsi_host_alloc - create a scsi host adapter instance and perform basic
  *                   initialization.
  * @sht:        pointer to scsi host template

