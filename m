From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] Two small fixes for sym53c8xx_2
Date: Tue, 11 Feb 2003 15:12:42 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030211151242.J5992@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Gerard Roudier <groudier@free.fr>
Cc: linux-scsi@vger.kernel.org, Grant Grundler <grundler@parisc-linux.org>


Both of these patches are originally by Grant Grundler.  They've been
tested in the PA-RISC tree for a few months, and I'm forwarding them along.

First patch:

pci_set_dma_mask returns 0 if the card can perform DMA as specified,
so the sense of the test is wrong.

diff -urpNX build-tools/dontdiff linus-2.5/drivers/scsi/sym53c8xx_2/sym_glue.c parisc-2.5/drivers/scsi/sym53c8xx_2/sym_glue.c
--- linus-2.5/drivers/scsi/sym53c8xx_2/sym_glue.c	Mon Feb 10 15:31:51 2003
+++ parisc-2.5/drivers/scsi/sym53c8xx_2/sym_glue.c	Mon Feb 10 15:36:04 2003
@@ -1876,7 +1876,7 @@ static int sym_setup_bus_dma_mask(hcb_p 
 					sym_name(np));
 		}
 		else {
-			if (!pci_set_dma_mask(np->s.device, 0xffffffffUL))
+			if (pci_set_dma_mask(np->s.device, 0xffffffffUL))
 				goto out_err32;
 		}
 	}

Second patch:

Here's the cvs log message Grant used when committing it:

2.4.18-pa57 fix sym53c8xx_2 "giving up" data page fault
c3k has a narrow Bus and the sym53c8xx_2 doesn't know that.
It trips over bad parity, prints "giving up..." msg and then
data page faults (code 15). Problem is coalescing of free'd
data buffers exceeds the max size the driver is expecting to handle
and walk off the end of an array (h[i]) of pointers.

diff -urpNX build-tools/dontdiff linus-2.5/drivers/scsi/sym53c8xx_2/sym_malloc.c parisc-2.5/drivers/scsi/sym53c8xx_2/sym_malloc.c
--- linus-2.5/drivers/scsi/sym53c8xx_2/sym_malloc.c	Thu Jul 18 09:53:28 2002
+++ parisc-2.5/drivers/scsi/sym53c8xx_2/sym_malloc.c	Thu Jul 25 00:39:33 2002
@@ -143,12 +143,15 @@ static void ___sym_mfree(m_pool_p mp, vo
 	a = (m_addr_t) ptr;
 
 	while (1) {
-#ifdef SYM_MEM_FREE_UNUSED
 		if (s == SYM_MEM_CLUSTER_SIZE) {
+#ifdef SYM_MEM_FREE_UNUSED
 			M_FREE_MEM_CLUSTER(a);
+#else
+			((m_link_p) a)->next = h[i].next;
+			h[i].next = (m_link_p) a;
+#endif
 			break;
 		}
-#endif
 		b = a ^ s;
 		q = &h[i];
 		while (q->next && q->next != (m_link_p) b) {

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
