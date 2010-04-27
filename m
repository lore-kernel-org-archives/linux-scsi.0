From: akpm@linux-foundation.org
Subject: [patch 15/28] scsi: remove superfluous NULL pointer check from scsi_kill_request()
Date: Tue, 27 Apr 2010 14:22:59 -0700
Message-ID: <201004272122.o3RLMxss020816@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757159Ab0D0Vat (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2010 17:30:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bzolnier@gmail.com, corbet@lwn.net, error27@gmail.com, eteo@redhat.com

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Dan's list included:

drivers/scsi/scsi_lib.c +1365 scsi_kill_request(9) warning: variable derefenced in initializer 'cmd'
drivers/scsi/scsi_lib.c +1365 scsi_kill_request(9) warning: variable derefenced before check 'cmd'

We dereference cmd (and possible OOPS if cmd == NULL) before starting the
request so just remove the superfluous debugging code altogether.

[ bart: the potential NULL pointer dereference was finally fixed in
  (much later than mine) commit 03b1470 but my patch is still valid ]

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Eugene Teo <eteo@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_lib.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/scsi/scsi_lib.c~scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request
+++ a/drivers/scsi/scsi_lib.c
@@ -1372,12 +1372,6 @@ static void scsi_kill_request(struct req
 
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
_
