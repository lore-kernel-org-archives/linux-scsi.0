From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [12/15] qla2xxx: RIO/ZIO fixes
Date: Thu, 6 May 2004 22:57:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040507055745.GA4960@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:38655 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263191AbUEGF4B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 01:56:01 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1933 04/04/30 15:24:16 andrew.vasquez@apc.qlogic.com +1 -0
  RIO/ZIO fixes:
  
  	o Reduce register access during RIO operation by checking
  	  for a 'dirtied' signature.
  
  	o Fix problem where ZIO mode handling could result in a 
  	  nasty recursive call-frame.

 drivers/scsi/qla2xxx/qla_os.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Mon May  3 15:16:15 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Mon May  3 15:16:15 2004
@@ -837,7 +837,7 @@
 		device_reg_t *reg;
 		reg = ha->iobase;
 		
-		if (RD_REG_WORD(ISP_RSP_Q_IN(ha, reg)) != ha->rsp_ring_index) {
+		if (ha->response_ring_ptr->signature != RESPONSE_PROCESSED) {
 			spin_lock_irqsave(&ha->hardware_lock, flags);	
 			qla2x00_process_response_queue(ha);
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -4243,9 +4243,6 @@
 	spin_lock_irqsave(&ha->hardware_lock,flags);
 	qla2x00_process_response_queue(ha);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	if (!list_empty(&ha->done_queue))
-		qla2x00_done(ha);
 }
 
 /*
