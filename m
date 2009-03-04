From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch 12/15] scsi: fix /proc memory leak in the SCSI core
Date: Wed, 4 Mar 2009 15:57:27 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0903041552560.793-100000@iolanthe.rowland.org>
References: <200903042006.n24K6FOo029295@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56692 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754217AbZCDU53 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2009 15:57:29 -0500
In-Reply-To: <200903042006.n24K6FOo029295@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Wed, 4 Mar 2009 akpm@linux-foundation.org wrote:

> From: Alan Stern <stern@rowland.harvard.edu>
> 
> The SCSI core calls scsi_proc_hostdir_add() from within scsi_host_alloc(),
> but the corresponding scsi_proc_hostdir_rm() routine is called from within
> scsi_remove_host().  As a result, if a host is allocated and then
> deallocated without ever being registered, the host's directory in /proc
> is leaked.
> 
> This patch (as1181) fixes this bug in the SCSI core by moving
> scsi_proc_hostdir_add() into scsi_host_add().

Andrew:

I sent James an updated version of this patch, but I forgot to CC you
-- sorry!  He seemed to think that the approach used in the revised
patch is superior, but I haven't gotten any definite feedback about it
yet.

The revised patch is below.

Alan Stern



---------------------------------------------------------------------

The SCSI core calls scsi_proc_hostdir_add() from within
scsi_host_alloc(), but the corresponding scsi_proc_hostdir_rm()
routine is called from within scsi_remove_host().  As a result, if a
host is allocated and then deallocated without ever being registered,
the host's directory in /proc is leaked.

This patch (as1181b) fixes this bug in the SCSI core by moving
scsi_proc_hostdir_rm() into scsi_host_dev_release().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/hosts.c
===================================================================
--- usb-2.6.orig/drivers/scsi/hosts.c
+++ usb-2.6/drivers/scsi/hosts.c
@@ -176,7 +176,6 @@ void scsi_remove_host(struct Scsi_Host *
 	transport_unregister_device(&shost->shost_gendev);
 	device_unregister(&shost->shost_dev);
 	device_del(&shost->shost_gendev);
-	scsi_proc_hostdir_rm(shost->hostt);
 }
 EXPORT_SYMBOL(scsi_remove_host);
 
@@ -270,6 +269,8 @@ static void scsi_host_dev_release(struct
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
 
+	scsi_proc_hostdir_rm(shost->hostt);
+
 	if (shost->ehandler)
 		kthread_stop(shost->ehandler);
 	if (shost->work_q)

