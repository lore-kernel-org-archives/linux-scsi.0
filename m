From: Andrew Morton <akpm@osdl.org>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Wed, 15 Sep 2004 16:13:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040915161346.78f0229e.akpm@osdl.org>
References: <20040915155132.177b51f2.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:22171 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S267696AbUIOXMr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 19:12:47 -0400
In-Reply-To: <20040915155132.177b51f2.pj@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Paul Jackson <pj@sgi.com>
Cc: linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, jbarnes@cthulhu.engr.sgi.com

Paul Jackson <pj@sgi.com> wrote:
>
> Jeremy Higdon recommended I send this to you.  I am running into
> a fatal problem with SCSI QLA2, unable to boot using the latest *-mm
> on SGI's SN2 hardware (don't know if other hardware involved or not).

Do you have this?


From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Hmm, there seems to be some merging problems in changeset 1.44 for qla_os.c
-- the 'DMA pool/api usage' patch I sent is not completely integrated
(appears to be massaging problems while attempting to apply on top off
1.43).

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 25-akpm/drivers/scsi/qla2xxx/qla_os.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_os.c~qlogic-oops-fix drivers/scsi/qla2xxx/qla_os.c
--- 25/drivers/scsi/qla2xxx/qla_os.c~qlogic-oops-fix	Tue Sep 14 16:20:34 2004
+++ 25-akpm/drivers/scsi/qla2xxx/qla_os.c	Tue Sep 14 16:20:34 2004
@@ -2892,6 +2892,19 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 			continue;
 		}
 
+		/* get consistent memory allocated for init control block */
+		ha->init_cb = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
+		    &ha->init_cb_dma);
+		if (ha->init_cb == NULL) {
+			qla_printk(KERN_WARNING, ha,
+			    "Memory Allocation failed - init_cb\n");
+
+			qla2x00_mem_free(ha);
+			msleep(100);
+
+			continue;
+		}
+		memset(ha->init_cb, 0, sizeof(init_cb_t));
 
 		/* Get consistent memory allocated for Get Port Database cmd */
 		ha->iodesc_pd = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
@@ -2983,21 +2996,6 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 			memset(ha->ct_sns, 0, sizeof(struct ct_sns_pkt));
 		}
 
-		/* Get consistent memory allocated for Get Port Database cmd */
-		ha->iodesc_pd = pci_alloc_consistent(ha->pdev,
-		    PORT_DATABASE_SIZE, &ha->iodesc_pd_dma);
-		if (ha->iodesc_pd == NULL) {
-			/* error */
-			qla_printk(KERN_WARNING, ha,
-			    "Memory Allocation failed - iodesc_pd\n");
-
-			qla2x00_mem_free(ha);
-			msleep(100);
-
-			continue;
-		}
-		memset(ha->iodesc_pd, 0, PORT_DATABASE_SIZE);
-
 		/* Done all allocations without any error. */
 		status = 0;
 
_

