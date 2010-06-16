From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 0/9] hpsa driver updates June 16, 2010
Date: Wed, 16 Jun 2010 13:51:09 -0500
Message-ID: <20100616184510.22798.26206.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:17613 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759345Ab0FPSqL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2010 14:46:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andriusb@redhat.com, James.Bottomley@HansenPartnership.com, dab@hp.com, thenzl@redhat.com, mikem@beardog.cce.hp.com

The following series implements support for new controllers,
allows the "hpsa_allow_any=1" boot parameter to enable the
driver to work with old Compaq branded controllers, fixes a
problem with the hard-reset of newer controllers which was
preventing kdump from working (except 640x, p800), provides
separate interrupt handler functions for intx and msi/msix
boards for efficiency on the msi/msix supporting boards, and
prevents the the driver from attempting to allocate a negative
amount of memory in the event the controller claims to support
zero commands (guard against buggy firmware.)

---

Stephen M. Cameron (9):
      hpsa: add new controllers
      hpsa: Make "hpsa_allow_any=1" boot param enable Compaq Smart Arrays.
      hpsa: make hpsa_find_memory_BAR not require the per HBA structure.
      hpsa: factor out hpsa_find_cfg_addrs.
      hpsa: factor out the code to reset controllers on driver load
      hpsa: Fix hard reset code.
      hpsa: forbid hard reset of 640x boards
      hpsa: separate intx and msi/msix interrupt handlers
      hpsa: sanitize max commands


 drivers/scsi/hpsa.c     |  346 ++++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/hpsa_cmd.h |    4 +
 2 files changed, 266 insertions(+), 84 deletions(-)

-- 

This series of patches depends on a bunch of patches that were sent
to linux-scsi back in May, but do not currently appear to be in
anyone's tree so far that I can see.  The patches below are the ones
the above patches depend on.  (If it would be better to resend all the
patches at once, I can do that.)

  1. 2010-06-11  [PATCH] hpsa: fix use of uninitialized variable in    linux-scs Stephen M. Cameron
...
  7. 2010-05-27  [PATCH 24/24] hpsa: add entry to MAINTAINERS          linux-scs Stephen M. Cameron
  8. 2010-05-27  [PATCH 23/24] hpsa: fix block fetch table problem.    linux-scs Stephen M. Cameron
  9. 2010-05-27  [PATCH 22/24] hpsa: expose controller firmware revisi linux-scs Stephen M. Cameron
 10. 2010-05-27  [PATCH 21/24] hpsa: Add hpsa.txt to Documentation/scs linux-scs Stephen M. Cameron
 11. 2010-05-27  [PATCH 20/24] hpsa: remove unused firm_ver member of  linux-scs Stephen M. Cameron
 12. 2010-05-27  [PATCH 19/24] hpsa: factor out hpsa_enter_performant_ linux-scs Stephen M. Cameron
 13. 2010-05-27  [PATCH 18/24] hpsa: remove unused variable trans_offs linux-scs Stephen M. Cameron
 14. 2010-05-27  [PATCH 17/24] hpsa: factor out hpsa_wait_for_mode_cha linux-scs Stephen M. Cameron
 15. 2010-05-27  [PATCH 16/24] hpsa: mark hpsa_mark_hpsa_put_ctlr_into linux-scs Stephen M. Cameron
 16. 2010-05-27  [PATCH 15/24] hpsa: clean up debug ifdefs             linux-scs Stephen M. Cameron
 17. 2010-05-27  [PATCH 14/24] hpsa: check that simple mode is support linux-scs Stephen M. Cameron
 18. 2010-05-27  [PATCH 13/24] hpsa: factor out hpsa_enter_simple_mode linux-scs Stephen M. Cameron
 19. 2010-05-27  [PATCH 12/24] hpsa: factor out hpsa_p600_dma_prefetch linux-scs Stephen M. Cameron
 20. 2010-05-27  [PATCH 11/24] hpsa: factor out hpsa_enable_scsi_prefe linux-scs Stephen M. Cameron
 21. 2010-05-27  [PATCH 10/24] hpsa: factor out hpsa-CISS-signature-pr linux-scs Stephen M. Cameron
 22. 2010-05-27  [PATCH 09/24] hpsa: hpsa factor out hpsa_find_board_p linux-scs Stephen M. Cameron
 23. 2010-05-27  [PATCH 08/24] hpsa: fix leak of ioremapped memory     linux-scs Stephen M. Cameron
 24. 2010-05-27  [PATCH 07/24] hpsa: factor out hpsa_find_cfgtables    linux-scs Stephen M. Cameron
 25. 2010-05-27  [PATCH 06/24] hpsa: factor out hpsa_wait_for_board_re linux-scs Stephen M. Cameron
 26. 2010-05-27  [PATCH 05/24] hpsa: factor out hpsa_find_memory_BAR   linux-scs Stephen M. Cameron
 27. 2010-05-27  [PATCH 04/24] hpsa: remove redundant board_id paramet linux-scs Stephen M. Cameron
 28. 2010-05-27  [PATCH 03/24] hpsa: factor out hpsa_board_disabled    linux-scs Stephen M. Cameron
 29. 2010-05-27  [PATCH 02/24] hpsa: factor out hpsa_lookup_board_id   linux-scs Stephen M. Cameron
 30. 2010-05-27  [PATCH 01/24] hpsa: save pdev pointer in per hba stru linux-scs Stephen M. Cameron

-- steve

