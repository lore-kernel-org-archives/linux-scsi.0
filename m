From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [1/18]  qla2xxx: Add wmb() to critical paths
Date: Mon, 21 Jun 2004 22:49:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622054901.GA8385@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:929 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266564AbUFVFpR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:45:17 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1837 04/06/03 15:00:49 andrew.vasquez@apc.qlogic.com +2 -0
  Add memory barriers to ensure that all load operations have
  completed before the (MMIO) write to the ISP's registers.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_iocb.c |    2 ++
 drivers/scsi/qla2xxx/qla_rscn.c |    4 ++++
 2 files changed, 6 insertions(+)

diff -Nru a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
--- a/drivers/scsi/qla2xxx/qla_iocb.c	2004-06-21 15:36:18 -07:00
+++ b/drivers/scsi/qla2xxx/qla_iocb.c	2004-06-21 15:36:18 -07:00
@@ -481,6 +481,7 @@
 
 	/* Set total data segment count. */
 	cmd_pkt->entry_count = (uint8_t)sp->req_cnt;
+	wmb();
 
 	/* Adjust ring index. */
 	ha->req_ring_index++;
@@ -541,6 +542,7 @@
 		pkt->lun = cpu_to_le16(lun);
 		SET_TARGET_ID(ha, pkt->target, loop_id);
 	}
+	wmb();
 
 	/* Issue command to ISP */
 	qla2x00_isp_cmd(ha);
diff -Nru a/drivers/scsi/qla2xxx/qla_rscn.c b/drivers/scsi/qla2xxx/qla_rscn.c
--- a/drivers/scsi/qla2xxx/qla_rscn.c	2004-06-21 15:36:18 -07:00
+++ b/drivers/scsi/qla2xxx/qla_rscn.c	2004-06-21 15:36:18 -07:00
@@ -438,6 +438,7 @@
 	    cpu_to_le16(iodesc->remote_fcport->loop_id);
 	mbxentry->mb2 = LSW(handle_to_abort);
 	mbxentry->mb3 = MSW(handle_to_abort);
+	wmb();
 
 	qla2x00_add_iodesc_timer(iodesc);
 
@@ -514,6 +515,7 @@
 	mbxentry->mb6 = cpu_to_le16(MSW(MSD(ha->iodesc_pd_dma)));
 	mbxentry->mb7 = cpu_to_le16(LSW(MSD(ha->iodesc_pd_dma)));
 	mbxentry->mb10 = __constant_cpu_to_le16(BIT_0);
+	wmb();
 
 	qla2x00_add_iodesc_timer(iodesc);
 
@@ -625,6 +627,7 @@
 	mbxentry->mb0 = __constant_cpu_to_le16(MBC_LOGOUT_FABRIC_PORT);
 	mbxentry->mb1 = mbxentry->loop_id.extended =
 	    cpu_to_le16(iodesc->remote_fcport->loop_id);
+	wmb();
 
 	qla2x00_add_iodesc_timer(iodesc);
 
@@ -702,6 +705,7 @@
 	mbxentry->mb2 = cpu_to_le16(d_id->b.domain);
 	mbxentry->mb3 = cpu_to_le16(d_id->b.area << 8 | d_id->b.al_pa);
 	mbxentry->mb10 = __constant_cpu_to_le16(BIT_0);
+	wmb();
 
 	qla2x00_add_iodesc_timer(iodesc);
 
