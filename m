From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] scsi fixes for 2.6.25-rc2
Date: Sat, 23 Feb 2008 09:13:33 -0600
Message-ID: <1203779614.3139.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42151 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754321AbYBWPQ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Feb 2008 10:16:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is the latest crop of bug fixes plus one new driver: mvsas.  We're
still in the throes of trying to fix aic94xx/libsas error handling, so
the fix here isn't complete (but it is much better than before).

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Adrian Bunk (4):
      qlogicpt: section fixes
      mptbase: fix use-after-free's
      iscsi transport: make 2 functions static
      lpfc: make lpfc_disable_node() static

Alan Cox (1):
      megaraid: outb_p extermination

Daniel Drake (1):
      arcmsr: fix message allocation

David Somayajulu (1):
      qla4xxx: fix up residual handling

FUJITA Tomonori (5):
      stex: stex_internal_copy should be called with sg_count in struct st_ccb
      stex: stex_direct_copy shouldn't call dma_map_sg
      ips: fix data buffer accessors conversion bug
      qla2xxx: fix compile warning for printk format
      scsi_debug: disable clustering

James Bottomley (7):
      libsas: correctly flush the LU queue on error recovery
      aic94xx: fix sequencer hang on error recovery
      libsas: fix error handling
      gdth: don't call pci_free_consistent under spinlock
      aic7xx: mitigate HOST_MSG_LOOP invalid SCB ff panic
      fas216: fix up the previous fas216 commit
      aic94xx: fix REQ_TASK_ABORT and REQ_DEVICE_RESET

Jeff Garzik (1):
      mvsas: Add Marvell 6440 SAS/SATA driver

Kai Makisara (1):
      st: compile fix when DEBUG set to one

Ke Wei (1):
      mvsas: convert from rough draft to working driver

Kyle McMartin (1):
      mpt fusion: kill warnings in mptbase.h on parisc64

Matthew Wilcox (1):
      lpfc: Balance locking

Yinghai Lu (1):
      ses: fix data corruption


And the diffstat:

 drivers/message/fusion/mptbase.c    |    4 
 drivers/message/fusion/mptbase.h    |    2 
 drivers/scsi/Kconfig                |   10 
 drivers/scsi/Makefile               |    1 
 drivers/scsi/aic7xxx/aic7xxx_core.c |   11 
 drivers/scsi/aic94xx/aic94xx_scb.c  |   14 
 drivers/scsi/aic94xx/aic94xx_tmf.c  |    4 
 drivers/scsi/arcmsr/arcmsr_hba.c    |   26 
 drivers/scsi/arm/fas216.h           |    2 
 drivers/scsi/gdth_proc.c            |    6 
 drivers/scsi/ips.c                  |    2 
 drivers/scsi/libsas/sas_scsi_host.c |   68 
 drivers/scsi/lpfc/lpfc_crtn.h       |    1 
 drivers/scsi/lpfc/lpfc_hbadisc.c    |    2 
 drivers/scsi/lpfc/lpfc_sli.c        |   18 
 drivers/scsi/megaraid.c             |   10 
 drivers/scsi/mvsas.c                | 2981 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_dfs.c      |    2 
 drivers/scsi/qla4xxx/ql4_isr.c      |    3 
 drivers/scsi/qlogicpti.c            |   12 
 drivers/scsi/scsi_debug.c           |    2 
 drivers/scsi/scsi_transport_iscsi.c |    4 
 drivers/scsi/ses.c                  |  126 -
 drivers/scsi/st.c                   |   11 
 drivers/scsi/st.h                   |    1 
 drivers/scsi/stex.c                 |   44 
 26 files changed, 3184 insertions(+), 183 deletions(-)

James


