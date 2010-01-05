From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH resend] scsi: remove superfluous NULL pointer check from scsi_kill_request()
Date: Tue, 5 Jan 2010 20:15:16 +0100
Message-ID: <201001052015.16855.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:53134 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab0AETRB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2010 14:17:01 -0500
Received: by fxm25 with SMTP id 25so10103670fxm.21
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jan 2010 11:17:00 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Dan Carpenter <error27@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Eugene Teo <eteo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>

>From Dan's list:

drivers/scsi/scsi_lib.c +1365 scsi_kill_request(9) warning: variable derefenced in initializer 'cmd'
drivers/scsi/scsi_lib.c +1365 scsi_kill_request(9) warning: variable derefenced before check 'cmd'

We dereference cmd (and possible OOPS if cmd == NULL) before starting
the request so just remove the superfluous debugging code altogether.

[ bart: the potential NULL pointer dereference was finally fixed in
  (much later than mine) commit 03b1470 but my patch is still valid ]

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Eugene Teo <eteo@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/scsi_lib.c |    6 ------
 1 file changed, 6 deletions(-)

Index: b/drivers/scsi/scsi_lib.c
===================================================================
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1366,12 +1366,6 @@ static void scsi_kill_request(struct req
 
 	blk_start_request(req);
 
-	if (unlikely(cmd == NULL)) {
-		printk(KERN_CRIT "impossible request in %s.\n",
-				 __func__);
-		BUG();
-	}
-
 	sdev = cmd->device;
 	starget = scsi_target(sdev);
 	shost = sdev->host;
