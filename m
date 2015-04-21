From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 0/4] target: Fix several problems related to T10-PI support
Date: Wed, 22 Apr 2015 08:46:13 +0900
Message-ID: <1429659977-7156-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33701 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965211AbbDUXqf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2015 19:46:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

This patchset aims to fix several problems related to T10-PI support.

These patches can be applied on top of Sagi's "[v1] Simlify dif_verify
routines and fixup fileio protection information code" patchset.

* Changes from v1:
- Reduce code duplication a bit in target_read_prot_action()
- Fix sbc_dif_verify() for WRITE_SAME command
- Fix inverted rw argument for fd_do_rw()
- Perform DIF verify before write for WRITE_SAME

Akinobu Mita (4):
  target: ensure se_cmd->t_prot_sg is allocated when required
  target: Abandon odd SG mapping for data transfer memory
  target: Fix sbc_dif_generate() and sbc_dif_verify() for WRITE SAME
  target/file: enable WRITE SAME when protection info is enabled

 drivers/target/target_core_file.c      | 18 ++++++++----
 drivers/target/target_core_sbc.c       | 49 +++++++++++++++++++++++++++++--
 drivers/target/target_core_transport.c | 53 +++++++++++++++++++---------------
 include/target/target_core_backend.h   |  2 +-
 include/target/target_core_base.h      |  1 +
 5 files changed, 91 insertions(+), 32 deletions(-)

Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

-- 
1.9.1

