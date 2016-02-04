From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v1 00/12] be2iscsi: Important fixes for 11.0.0.0 in 4.6/scsi-queue
Date: Thu,  4 Feb 2016 15:49:08 +0530
Message-ID: <1454581160-31869-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:62101 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965094AbcBDKhl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 05:37:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

This driver update has critical fixes for following issues:
- Management tasks with incorrect ExpStatSn
- WRB allocation failures in IO path
- MCC WRB leak

Jitendra Bhivare (12):
  be2iscsi: Remove unused mcc_cq_lock
  be2iscsi: Use macros for MCC WRB and CQE fields
  be2iscsi: Remove redundant MCC processing code
  be2iscsi: Rename MCC and BMBX processing functions
  be2iscsi: Remove be_mbox_notify_wait function
  be2iscsi: Fix be_mcc_compl_poll to use tag_state
  be2iscsi: Cleanup processing of BMBX completion
  be2iscsi: Fix MCC WRB leak in open_connection
  be2iscsi: Couple MCC tag and WRB alloc and free
  be2iscsi: Fix ExpStatSn in management tasks
  be2iscsi: _bh for io_sgl_lock and mgmt_sgl_lock
  be2iscsi: Add lock to protect WRB alloc and free

 drivers/scsi/be2iscsi/be.h       |  11 +-
 drivers/scsi/be2iscsi/be_cmds.c  | 522 +++++++++++++++++----------------------
 drivers/scsi/be2iscsi/be_cmds.h  |  32 +--
 drivers/scsi/be2iscsi/be_iscsi.c |   8 +-
 drivers/scsi/be2iscsi/be_main.c  |  73 +++---
 drivers/scsi/be2iscsi/be_main.h  |   2 +
 drivers/scsi/be2iscsi/be_mgmt.c  | 167 +++++--------
 7 files changed, 355 insertions(+), 460 deletions(-)

-- 
2.5.0

