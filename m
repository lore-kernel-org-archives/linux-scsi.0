From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [6/15]  qla2xxx: LoopID downcast fix
Date: Thu, 6 May 2004 22:53:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040507055315.GA4915@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:47489 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263182AbUEGFvb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 01:51:31 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1927 04/04/30 11:12:45 andrew.vasquez@apc.qlogic.com +2 -0
  Fix problem where the driver would incorrectly down-cast the target
  loop_id while retrieving link statistics.

 drivers/scsi/qla2xxx/qla_gbl.h |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h	Mon May  3 15:14:24 2004
+++ b/drivers/scsi/qla2xxx/qla_gbl.h	Mon May  3 15:14:24 2004
@@ -198,7 +198,7 @@
 qla2x00_get_port_name(scsi_qla_host_t *, uint16_t, uint8_t *, uint8_t);
 
 extern uint8_t
-qla2x00_get_link_status(scsi_qla_host_t *, uint8_t, link_stat_t *, uint16_t *);
+qla2x00_get_link_status(scsi_qla_host_t *, uint16_t, link_stat_t *, uint16_t *);
 
 extern int
 qla2x00_lip_reset(scsi_qla_host_t *);
diff -Nru a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c	Mon May  3 15:14:24 2004
+++ b/drivers/scsi/qla2xxx/qla_mbx.c	Mon May  3 15:14:24 2004
@@ -1607,7 +1607,7 @@
  *	BIT_1 = mailbox error.
  */
 uint8_t
-qla2x00_get_link_status(scsi_qla_host_t *ha, uint8_t loop_id,
+qla2x00_get_link_status(scsi_qla_host_t *ha, uint16_t loop_id,
     link_stat_t *ret_buf, uint16_t *status)
 {
 	int rval;
