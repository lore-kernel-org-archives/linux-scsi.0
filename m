From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [3/15] qla2xxx:  Increase MBX IOXB timeout
Date: Sun, 14 Mar 2004 00:24:24 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314082424.GA3402@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:55987 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263315AbUCNIV4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 03:21:56 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

ChangeSet
  1.1659 04/02/28 21:50:11 andrew.vasquez@qlogic.com +1 -0
  Fix a problem where during heavy I/O the driver would
  improperly timeout an outstanding MBX IOCB before the
  firmware itself had a chance to issue and wait for the
  command to timeout.

  drivers/scsi/qla2xxx/qla_rscn.c
    1.3 04/02/28 21:50:05 andrew.vasquez@qlogic.com +5 -3
    Wait at most 4 * R_A_TOV before timing-out an MBX IOCB.

 drivers/scsi/qla2xxx/qla_rscn.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b11k/12_mbx_iocb_timeout.patch

diff -Nru a/drivers/scsi/qla2xxx/qla_rscn.c b/drivers/scsi/qla2xxx/qla_rscn.c
--- a/drivers/scsi/qla2xxx/qla_rscn.c	Fri Mar 12 17:06:46 2004
+++ b/drivers/scsi/qla2xxx/qla_rscn.c	Fri Mar 12 17:06:46 2004
@@ -292,15 +292,17 @@
  *
  * NOTE:
  * The firmware shall timeout an outstanding mailbox IOCB in 2 * R_A_TOV (in
- * tenths of a second).  The driver will wait 2.5 * R_A_TOV before scheduling
- * a recovery (big hammer).
+ * tenths of a second) after it hits the wire.  But, if there are any request
+ * resource contraints (i.e. during heavy I/O), exchanges can be held off for
+ * at most R_A_TOV.  Therefore, the driver will wait 4 * R_A_TOV before
+ * scheduling a recovery (big hammer).
  */
 static inline void
 qla2x00_add_iodesc_timer(struct io_descriptor *iodesc)
 {
 	unsigned long timeout;
 
-	timeout = ((iodesc->ha->r_a_tov * 2) + (iodesc->ha->r_a_tov / 2)) / 10;
+	timeout = (iodesc->ha->r_a_tov * 4) / 10;
 	init_timer(&iodesc->timer);
 	iodesc->timer.data = (unsigned long) iodesc;
 	iodesc->timer.expires = jiffies + (timeout * HZ);
