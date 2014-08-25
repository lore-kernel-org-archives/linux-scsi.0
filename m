From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented and
 there's not way to prevent the kernel from using the 2nd cdb byte for the LUN
Date: Mon, 25 Aug 2014 21:19:10 +0000
Message-ID: <bug-80711-11613-rcYoQoRlyT@https.bugzilla.kernel.org/>
References: <bug-80711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41655 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933469AbaHYVTO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2014 17:19:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0EBBF201DC
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2014 21:19:13 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 80FFA201CE
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2014 21:19:10 +0000 (UTC)
In-Reply-To: <bug-80711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=80711

--- Comment #20 from Alan Stern <stern@rowland.harvard.edu> ---
On Mon, 25 Aug 2014, Alan Stern wrote:

> On Mon, 25 Aug 2014, James Bottomley wrote:
> 
> > On Mon, 2014-08-25 at 10:44 -0400, Alan Stern wrote:
> > 
> > > James, can you explain how the INQUIRY command in scsi_probe_lun()  
> > > managed to work back in the days when multi-lun SCSI-2 devices were
> > > common?  sdev->scsi_level doesn't get set when sdev is allocated, so it
> > > initially contains 0, so the LUN bits won't get filled in when the
> > > first INQUIRY command is sent.  Then how could the target know which
> > > logical unit the INQUIRY was meant for?
> > 
> > Best guess, some patches over the course of time altered the way we do
> > this and no-one noticed.  I think it was probably the introduction of
> > the unknown SCSI data level that caused the breakage.
> 
> Heh.  The change was made by commit 4d7db04a7a69 ([SCSI] add
> SCSI_UNKNOWN and LUN transfer limit restrictions) back in 2006 -- the
> 2.6.17 kernel.  If nobody has complained in all this time then it's
> probably not worth changing.

It turns out the code is already there, and I didn't realize because I
was looking at the wrong source file.  scsi_sysfs_device_initialize()
already does:

    sdev->scsi_level = starget->scsi_level;

Here's the update to the patch, adding an appropriate comment and
setting the new sdev->lun_in_sdb flag properly:

Alan Stern


Index: usb-3.16/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-3.16.orig/drivers/scsi/scsi_sysfs.c
+++ usb-3.16/drivers/scsi/scsi_sysfs.c
@@ -1238,7 +1238,19 @@ void scsi_sysfs_device_initialize(struct
     sdev->sdev_dev.class = &sdev_class;
     dev_set_name(&sdev->sdev_dev, "%d:%d:%d:%d",
              sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
+    /*
+     * Get a default scsi_level from the target (derived from sibling
+     * devices).  This is the best we can do for guessing how to set
+     * sdev->lun_in_cdb for the initial INQUIRY command.  For LUN 0 the
+     * setting doesn't matter, because all the bits are zero anyway.
+     * But it does matter for higher LUNs.
+     */
     sdev->scsi_level = starget->scsi_level;
+    if (sdev->scsi_level <= SCSI_2 &&
+            sdev->scsi_level != SCSI_UNKNOWN &&
+            !shost->no_scsi2_lun_in_cdb)
+        sdev->lun_in_cdb = 1;
+
     transport_setup_device(&sdev->sdev_gendev);
     spin_lock_irqsave(shost->host_lock, flags);
     list_add_tail(&sdev->same_target_siblings, &starget->devices);

-- 
You are receiving this mail because:
You are the assignee for the bug.
