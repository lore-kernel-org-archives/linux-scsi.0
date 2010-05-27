From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 00/24] hpsa updates for May 2010
Date: Thu, 27 May 2010 15:12:36 -0500
Message-ID: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:39917 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab0E0UIF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:08:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

hpsa: The following series implements mostly small cleanups in the
initialization code with the aim to make hpsa_pci_init() a little
smaller and more readable.  Fixed a bug that some ioremapped 
memory was not being unmapped in all cases.  Fixed a minor
bug that would cause large commands (many scatter gather elements)
to not be fetched out of host memory in a single transaction.  Added
some documentation and an entry in MAINTAINERS.  Added /sys entry
to show controller firmware revision.

---

Stephen M. Cameron (24):
      hpsa: save pdev pointer in per hba structure early to avoid passing it around so much.
      hpsa: factor out hpsa_lookup_board_id
      hpsa: factor out hpsa_board_disabled
      hpsa: remove redundant board_id parameter from hpsa_interrupt_mode
      hpsa: factor out hpsa_find_memory_BAR
      hpsa: factor out hpsa_wait_for_board_ready
      hpsa: factor out hpsa_find_cfgtables
      hpsa: fix leak of ioremapped memory
      hpsa: hpsa factor out hpsa_find_board_params
      hpsa: factor out hpsa-CISS-signature-present
      hpsa: factor out hpsa_enable_scsi_prefetch
      hpsa: factor out hpsa_p600_dma_prefetch_quirk
      hpsa: factor out hpsa_enter_simple_mode
      hpsa: check that simple mode is supported
      hpsa: clean up debug ifdefs
      hpsa: mark hpsa_mark_hpsa_put_ctlr_into_performant_mode as __devinit
      hpsa: factor out hpsa_wait_for_mode_change_ack
      hpsa: remove unused variable trans_offset
      hpsa: factor out hpsa_enter_performant_mode
      hpsa: remove unused firm_ver member of the per-hba structure
      hpsa: Add hpsa.txt to Documentation/scsi
      hpsa: expose controller firmware revision via /sys.
      hpsa: fix block fetch table problem.
      hpsa: add entry to MAINTAINERS


 Documentation/scsi/hpsa.txt |  107 ++++++++++
 MAINTAINERS                 |    8 +
 drivers/scsi/hpsa.c         |  440 ++++++++++++++++++++++++++-----------------
 drivers/scsi/hpsa.h         |    1 
 4 files changed, 381 insertions(+), 175 deletions(-)
 create mode 100644 Documentation/scsi/hpsa.txt

-- 
Signature
