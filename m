From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [10/15] qla2xxx: Use readX_relaxed
Date: Thu, 6 May 2004 22:56:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040507055615.GA4943@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:29427 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263185AbUEGFyb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 01:54:31 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1931 04/04/30 14:32:56 andrew.vasquez@apc.qlogic.com +3 -0
  Jeremy Higdon <jeremy () sgi ! com>:
  
  	For those to whom this is new (it was discussed on linux-kernel
  	and linux-ia64 I believe), normal PCI register reads imply that
  	PCI DMA writes that occured prior to the PCI MMR (memory mapped
  	register) read (on the PCI bus) will be reflected in system
  	memory once the MMR read is complete.
  
  	On our platforms, we can speed up the MMR read significantly if
  	that ordering requirement is "relaxed".
  
  	So I attempted to find the common register reads that don't
  	have a need for this ordering so that I could make them use
  	this faster read.

 drivers/scsi/qla2xxx/qla_def.h  |    3 +++
 drivers/scsi/qla2xxx/qla_iocb.c |    6 +++---
 drivers/scsi/qla2xxx/qla_isr.c  |    2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	Mon May  3 15:15:38 2004
+++ b/drivers/scsi/qla2xxx/qla_def.h	Mon May  3 15:15:38 2004
@@ -154,6 +154,9 @@
 #define RD_REG_BYTE(addr)		readb(addr)
 #define RD_REG_WORD(addr)		readw(addr)
 #define RD_REG_DWORD(addr)		readl(addr)
+#define RD_REG_BYTE_RELAXED(addr)	readb_relaxed(addr)
+#define RD_REG_WORD_RELAXED(addr)	readw_relaxed(addr)
+#define RD_REG_DWORD_RELAXED(addr)	readl_relaxed(addr)
 #define WRT_REG_BYTE(addr, data)	writeb(data,addr)
 #define WRT_REG_WORD(addr, data)	writew(data,addr)
 #define WRT_REG_DWORD(addr, data)	writel(data,addr)
diff -Nru a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
--- a/drivers/scsi/qla2xxx/qla_iocb.c	Mon May  3 15:15:38 2004
+++ b/drivers/scsi/qla2xxx/qla_iocb.c	Mon May  3 15:15:38 2004
@@ -390,7 +390,7 @@
 
 	if (ha->req_q_cnt < (sp->req_cnt + 2)) {
 		/* Calculate number of free request entries */
-		cnt = RD_REG_WORD(ISP_REQ_Q_OUT(ha, reg));
+		cnt = RD_REG_WORD_RELAXED(ISP_REQ_Q_OUT(ha, reg));
 		if (ha->req_ring_index < cnt)
 			ha->req_q_cnt = cnt - ha->req_ring_index;
 		else
@@ -499,7 +499,7 @@
 
 	/* Set chip new ring index. */
 	WRT_REG_WORD(ISP_REQ_Q_IN(ha, reg), ha->req_ring_index);
-	RD_REG_WORD(ISP_REQ_Q_IN(ha, reg));	/* PCI Posting. */
+	RD_REG_WORD_RELAXED(ISP_REQ_Q_IN(ha, reg));	/* PCI Posting. */
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return (QLA_SUCCESS);
@@ -748,5 +748,5 @@
 
 	/* Set chip new ring index. */
 	WRT_REG_WORD(ISP_REQ_Q_IN(ha, reg), ha->req_ring_index);
-	RD_REG_WORD(ISP_REQ_Q_IN(ha, reg));	/* PCI Posting. */
+	RD_REG_WORD_RELAXED(ISP_REQ_Q_IN(ha, reg));	/* PCI Posting. */
 }
diff -Nru a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c	Mon May  3 15:15:38 2004
+++ b/drivers/scsi/qla2xxx/qla_isr.c	Mon May  3 15:15:38 2004
@@ -165,7 +165,7 @@
 				break;
 			}
 			WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
-			RD_REG_WORD(&reg->hccr);
+			RD_REG_WORD_RELAXED(&reg->hccr);
 		}
 	}
 
