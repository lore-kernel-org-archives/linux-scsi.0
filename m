From: Jeremy Higdon <jeremy@sgi.com>
Subject: [PATCH] 2.6.3 qla2xxx driver -- use readX_relaxed
Date: Wed, 25 Feb 2004 20:05:35 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040226040535.GA559454@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:60600 "EHLO zok.sgi.com")
	by vger.kernel.org with ESMTP id S262657AbUBZEFg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2004 23:05:36 -0500
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by zok.sgi.com (8.12.9/8.12.9/linux-outbound_gateway-1.1) with ESMTP id i1Q45aF6028387
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2004 20:05:36 -0800
Received: from classic.engr.sgi.com (classic.engr.sgi.com [163.154.5.111])
	by cthulhu.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id i1Q45Zio14053719
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2004 20:05:35 -0800 (PST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbarnes@cthulhu.engr.sgi.com

I'm submitting a patch for comment and consideration.  The relaxed read
interface was added a few weeks back, and this patch lets the qla2xxx driver
take advantage of it.

For those to whom this is new (it was discussed on linux-kernel and linux-ia64
I believe), normal PCI register reads imply that PCI DMA writes that occured
prior to the PCI MMR (memory mapped register) read (on the PCI bus) will be
reflected in system memory once the MMR read is complete.

On our platforms, we can speed up the MMR read significantly if that ordering
requirement is "relaxed".

So I attempted to find the common register reads that don't have a need
for this ordering so that I could make them use this faster read.

I did not change this line (111 of drivers/scsi/qla2xxx/qla_isr.c),
because it may in some cases imply that a DMA write has completed.

		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);


Andrew, if you have a chance to look at this and incorporate it in the
driver, it would be great.  Also, any comments would be welcome.

thanks

jeremy

===== drivers/scsi/qla2xxx/qla_def.h 1.5 vs edited =====
--- 1.5/drivers/scsi/qla2xxx/qla_def.h	Mon Feb  2 08:02:02 2004
+++ edited/drivers/scsi/qla2xxx/qla_def.h	Wed Feb 25 16:14:18 2004
@@ -154,6 +154,9 @@
 #define RD_REG_BYTE(addr)		readb(addr)
 #define RD_REG_WORD(addr)		readw(addr)
 #define RD_REG_DWORD(addr)		readl(addr)
+#define RD_REG_BYTE_relaxed(addr)	readb_relaxed(addr)
+#define RD_REG_WORD_relaxed(addr)	readw_relaxed(addr)
+#define RD_REG_DWORD_relaxed(addr)	readl_relaxed(addr)
 #define WRT_REG_BYTE(addr, data)	writeb(data,addr)
 #define WRT_REG_WORD(addr, data)	writew(data,addr)
 #define WRT_REG_DWORD(addr, data)	writel(data,addr)
===== drivers/scsi/qla2xxx/qla_iocb.c 1.2 vs edited =====
--- 1.2/drivers/scsi/qla2xxx/qla_iocb.c	Mon Feb  2 07:41:39 2004
+++ edited/drivers/scsi/qla2xxx/qla_iocb.c	Wed Feb 25 01:23:36 2004
@@ -388,7 +388,7 @@
 
 	if (ha->req_q_cnt < (req_cnt + 2)) {
 		/* Calculate number of free request entries */
-		cnt = RD_REG_WORD(ISP_REQ_Q_OUT(ha, reg));
+		cnt = RD_REG_WORD_relaxed(ISP_REQ_Q_OUT(ha, reg));
 		if (ha->req_ring_index < cnt)
 			ha->req_q_cnt = cnt - ha->req_ring_index;
 		else
@@ -496,7 +496,7 @@
 
 	/* Set chip new ring index. */
 	WRT_REG_WORD(ISP_REQ_Q_IN(ha, reg), ha->req_ring_index);
-	RD_REG_WORD(ISP_REQ_Q_IN(ha, reg));	/* PCI Posting. */
+	RD_REG_WORD_relaxed(ISP_REQ_Q_IN(ha, reg));	/* PCI Posting. */
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return (QLA_SUCCESS);
@@ -748,5 +748,5 @@
 
 	/* Set chip new ring index. */
 	WRT_REG_WORD(ISP_REQ_Q_IN(ha, reg), ha->req_ring_index);
-	RD_REG_WORD(ISP_REQ_Q_IN(ha, reg));	/* PCI Posting. */
+	RD_REG_WORD_relaxed(ISP_REQ_Q_IN(ha, reg));	/* PCI Posting. */
 }
===== drivers/scsi/qla2xxx/qla_isr.c 1.5 vs edited =====
--- 1.5/drivers/scsi/qla2xxx/qla_isr.c	Tue Feb 10 13:51:30 2004
+++ edited/drivers/scsi/qla2xxx/qla_isr.c	Wed Feb 25 01:18:04 2004
@@ -165,7 +165,7 @@
 				break;
 			}
 			WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
-			RD_REG_WORD(&reg->hccr);
+			RD_REG_WORD_relaxed(&reg->hccr);
 		}
 	}
 
