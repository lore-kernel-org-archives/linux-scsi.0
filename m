From: Sagi Grimberg <sagig@mellanox.com>
Subject: [RFC] Simlify dif_verify routines and fixup fileio protection information code.
Date: Mon, 13 Apr 2015 20:19:33 +0300
Message-ID: <1428945575-30839-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1327.ztomy.com ([193.47.165.129]:58529 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932351AbbDMRUA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Apr 2015 13:20:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Akinobu Mita <akinobu.mita@gmail.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>

Hey All,

This set follows the patchset from Akinobu Mita that addresses
DIF bounce buffer sgl construction. Instead of trying to fix these
bugs, this removes it altogether and work with cmd->t_prot_sg
directly.

The first patch is a simplification of the DIF verify varius
routines leaving a single generic sbc_dif_verify that handles
the protection information sgl we are working on.

The second patch uses this simplification to remove the local
prot_fd bounce buffer altogether.

This passed minimal IO testing.

Sagi Grimberg (2):
  target: Merge sbc_verify_dif_read|write
  target/file: Remove fd_prot bounce buffer

 drivers/target/target_core_file.c      |  140 +++++++-------------------------
 drivers/target/target_core_file.h      |    6 --
 drivers/target/target_core_rd.c        |   20 +++--
 drivers/target/target_core_sbc.c       |   94 ++--------------------
 drivers/target/target_core_transport.c |   17 ++--
 include/target/target_core_backend.h   |    8 +-
 6 files changed, 62 insertions(+), 223 deletions(-)
