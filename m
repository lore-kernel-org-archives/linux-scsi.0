From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] Compile fix for AIC7xxx
Date: Sun, 7 Jul 2002 17:29:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020707172943.M27706@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-scsi@vger.kernel.org


Trivial missed fix for this driver:

diff -urNX dontdiff linux-2.5.25/drivers/scsi/aic7xxx_old.c linux-2.5.25-mm/drivers/scsi/aic7xxx_old.c
--- linux-2.5.25/drivers/scsi/aic7xxx_old.c	Fri Jul  5 16:42:22 2002
+++ linux-2.5.25-mm/drivers/scsi/aic7xxx_old.c	Sun Jul  7 08:11:24 2002
@@ -3070,7 +3070,7 @@
        * we check data_cmnd[0].  This catches the conditions for st.c, but
        * I'm still not sure if request.cmd is valid for sg devices.
        */
-      if ( (rq_data_dir(&cmd->request) == WRITE) || (cmd->data_cmnd[0] == WRITE_6) ||
+      if ( (rq_data_dir(cmd->request) == WRITE) || (cmd->data_cmnd[0] == WRITE_6) ||
            (cmd->data_cmnd[0] == WRITE_FILEMARKS) )
       {
         sp->w_total++;
@@ -4280,7 +4280,7 @@
       {
         printk(INFO_LEAD "Underflow - Wanted %u, %s %u, residual SG "
           "count %d.\n", p->host_no, CTL_OF_SCB(scb), cmd->underflow,
-          (rq_data_dir(&cmd->request) == WRITE) ? "wrote" : "read", actual,
+          (rq_data_dir(cmd->request) == WRITE) ? "wrote" : "read", actual,
           hscb->residual_SG_segment_count);
         printk(INFO_LEAD "status 0x%x.\n", p->host_no, CTL_OF_SCB(scb),
           hscb->target_status);

-- 
Revolutions do not require corporate support.
