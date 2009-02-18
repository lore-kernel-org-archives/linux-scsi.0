From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH (resend)]: SCSI: fix /proc memory leak in the SCSI core
Date: Wed, 18 Feb 2009 10:52:06 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0902181048210.3186-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:41816 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750740AbZBRPwI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Feb 2009 10:52:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>

The SCSI core calls scsi_proc_hostdir_add() from within
scsi_host_alloc(), but the corresponding scsi_proc_hostdir_rm()
routine is called from within scsi_remove_host().  As a result, if a
host is allocated and then deallocated without ever being registered,
the host's directory in /proc is leaked.

This patch (as1181) fixes this bug in the SCSI core by moving
scsi_proc_hostdir_add() into scsi_host_add().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Note: This is a repost of a bug-fix patch that was first submitted on 
December 1.

After looking through the documentation and code for the SCSI legacy 
API, I can't find anything incompatible with this change.  However I 
don't have any hardware with a legacy driver so I can't actually make 
the test.


Index: usb-2.6/drivers/scsi/hosts.c
===================================================================
--- usb-2.6.orig/drivers/scsi/hosts.c
+++ usb-2.6/drivers/scsi/hosts.c
@@ -206,9 +206,10 @@ int scsi_add_host(struct Scsi_Host *shos
 	if (error)
 		goto fail;
 
+	scsi_proc_hostdir_add(shost->hostt);
+
 	if (!shost->shost_gendev.parent)
 		shost->shost_gendev.parent = dev ? dev : &platform_bus;
-
 	error = device_add(&shost->shost_gendev);
 	if (error)
 		goto out;
@@ -259,6 +260,7 @@ int scsi_add_host(struct Scsi_Host *shos
  out_del_gendev:
 	device_del(&shost->shost_gendev);
  out:
+	scsi_proc_hostdir_rm(shost->hostt);
 	scsi_destroy_command_freelist(shost);
  fail:
 	return error;
@@ -407,7 +409,6 @@ struct Scsi_Host *scsi_host_alloc(struct
 		goto fail_kfree;
 	}
 
-	scsi_proc_hostdir_add(shost->hostt);
 	return shost;
 
  fail_kfree:

