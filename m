From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [V2 PATCH 0/8] bnx2fc bug fixes
Date: Thu, 17 Mar 2011 17:13:23 -0700
Message-ID: <1300407203.644.403.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4417 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590Ab1CRANg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2011 20:13:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Nithin Sujir <nsujir@broadcom.com>, Michael Chan <mchan@broadcom.com>

James, Please pick up this patchset instead of the ones that we submitted
previously. Documented the changes in this patchset below. Thanks!

Bug fixes as listed below. Descriptions are in individual patches.

Changes in V2:
	- Reduce BNX2FC_MAX_OUTSTANDING commands inline with FW requirements
	- Replaced rtnl_trylock/restart_sys with rtnl_lock()
	- Use max payload size of 2048 instead of 2112.
	- Added MODULE_STATE_LIVE removal patch.

Bhanu Prakash Gollapudi (4):
  bnx2fc: Avoid holding cq_lock when iounmap() is called
  bnx2fc: common free list for cleanup commands
  bnx2fc: Fix MTU issue by using static MTU
  bnx2fc: Remove unnecessary module state checks

Michael Chan (1):
  bnx2fc: Remove network bonding checking

Nithin Nayak Sujir (3):
  bnx2fc: Remove rtnl_trylock/restart_syscall checks
  bnx2fc: Call bnx2fc_return_rqe and bnx2fc_get_next_rqe with tgt lock
    held
  bnx2fc: Bump version to 1.0.1

 drivers/scsi/bnx2fc/bnx2fc.h      |   20 +++++---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   88 +++---------------------------------
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  |   15 +++++-
 drivers/scsi/bnx2fc/bnx2fc_io.c   |   73 ++++++++++++++++++++----------
 drivers/scsi/bnx2fc/bnx2fc_tgt.c  |    4 +-
 5 files changed, 83 insertions(+), 117 deletions(-)




