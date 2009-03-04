From: akpm@linux-foundation.org
Subject: [patch 12/15] scsi: fix /proc memory leak in the SCSI core
Date: Wed, 04 Mar 2009 12:06:15 -0800
Message-ID: <200903042006.n24K6FOo029295@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754384AbZCDUXn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2009 15:23:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, stern@rowland.harvard.edu

From: Alan Stern <stern@rowland.harvard.edu>

The SCSI core calls scsi_proc_hostdir_add() from within scsi_host_alloc(),
but the corresponding scsi_proc_hostdir_rm() routine is called from within
scsi_remove_host().  As a result, if a host is allocated and then
deallocated without ever being registered, the host's directory in /proc
is leaked.

This patch (as1181) fixes this bug in the SCSI core by moving
scsi_proc_hostdir_add() into scsi_host_add().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hosts.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/hosts.c~scsi-fix-proc-memory-leak-in-the-scsi-core drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c~scsi-fix-proc-memory-leak-in-the-scsi-core
+++ a/drivers/scsi/hosts.c
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
_
