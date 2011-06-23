From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 0/4 v2] BNX2I: Code and performance optimization
Date: Thu, 23 Jun 2011 15:51:33 -0700
Message-ID: <1308869497-2709-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1927 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760098Ab1FWWvu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2011 18:51:50 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

This patch set contains a collection of code and performance optimization
changes.

Changes from v2:
- Comments from Mike Christie to use sc->request->cpu instead of the newly
defined bnx2i_cmd->cpu
- Comments from Fubo Chen to process the work in the percpu io completion
kthread before calling schedule() to avoid potential race condition.

Your comments are welcome.  Please review.

Thanks,
Eddie

Eddie Wai (4):
  BNX2I: Added the use of kthreads to handle SCSI cmd completion
  BNX2I: Modified to skip CNIC registration if iSCSI is not supported
  BNX2I: Changed the nopout_wqe->lun memcpy to use sizeof instead
  BNX2I: Updated copyright and bump version

 drivers/scsi/bnx2i/57xx_iscsi_constants.h |    2 +-
 drivers/scsi/bnx2i/57xx_iscsi_hsi.h       |    2 +-
 drivers/scsi/bnx2i/bnx2i.h                |   33 +++++-
 drivers/scsi/bnx2i/bnx2i_hwi.c            |  187 ++++++++++++++++++++++++-----
 drivers/scsi/bnx2i/bnx2i_init.c           |  153 +++++++++++++++++++++---
 drivers/scsi/bnx2i/bnx2i_iscsi.c          |   38 +++++-
 drivers/scsi/bnx2i/bnx2i_sysfs.c          |    2 +-
 7 files changed, 358 insertions(+), 59 deletions(-)


