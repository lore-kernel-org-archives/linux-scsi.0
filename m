From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] scsi: remove superfluous NULL pointer check from scsi_kill_request()
Date: Sun, 26 Jul 2009 16:29:25 +0200
Message-ID: <200907261629.26529.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751897AbZGYOee@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com
List-Id: linux-scsi@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] scsi: remove superfluous NULL pointer check from scsi_kill_request()

>From Dan's list:

drivers/scsi/scsi_lib.c +1365 scsi_kill_request(9) warning: variable derefenced in initializer 'cmd'
drivers/scsi/scsi_lib.c +1365 scsi_kill_request(9) warning: variable derefenced before check 'cmd'

We dereference cmd (and possible OOPS if cmd == NULL) before starting
the request so just remove the superfluous debugging code altogether.

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: corbet@lwn.net
Cc: eteo@redhat.com
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/scsi_lib.c |    6 ------
 1 file changed, 6 deletions(-)

Index: b/drivers/scsi/scsi_lib.c
===================================================================
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1365,12 +1365,6 @@ static void scsi_kill_request(struct req
 
 	blk_start_request(req);
 
-	if (unlikely(cmd == NULL)) {
-		printk(KERN_CRIT "impossible request in %s.\n",
-				 __func__);
-		BUG();
-	}
-
 	scsi_init_cmd_errh(cmd);
 	cmd->result = DID_NO_CONNECT << 16;
 	atomic_inc(&cmd->device->iorequest_cnt);
