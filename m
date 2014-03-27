From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 0/7] Performance improvements for LSI SCSI cards
Date: Thu, 27 Mar 2014 16:40:29 -0400
Message-ID: <cover.1395952569.git.matthew.r.wilcox@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36842 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376AbaC0Uks (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2014 16:40:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com

The host lock is a serious scalability problem on 2-socket and larger
systems which are doing a lot of I/O.  Before removing the temporary
usgae of DEF_SCSI_QCMD, we need to remove all uses of serial_number.

An unrelated performance issue is that reusing the most recent
driver-specific data structure to track the I/O instead of the least
recently used keeps the cache-hot lines in use, which is a nice
performance improvement.  It's already present in the mpt3sas driver,
it just didn't make it into the fusion or mpt2sas drivers yet.

Matthew Wilcox (7):
  mpt3sas: Remove uses of serial_number
  mpt3sas: Remove use of DEF_SCSI_QCMD
  mpt2sas: Remove uses of serial_number
  mpt2sas: Remove use of DEF_SCSI_QCMD
  mpt2sas: Add free smids to the head, not tail of list
  fusion: Add free msg frames to the head, not tail of list
  fusion: Remove use of DEF_SCSI_QCMD

 drivers/message/fusion/mptbase.c     |  2 +-
 drivers/message/fusion/mptfc.c       | 12 +++++-------
 drivers/message/fusion/mptsas.c      | 10 ++++------
 drivers/message/fusion/mptscsih.c    |  8 +++-----
 drivers/message/fusion/mptscsih.h    |  2 +-
 drivers/message/fusion/mptspi.c      | 12 +++++-------
 drivers/scsi/mpt2sas/mpt2sas_base.c  |  8 ++++----
 drivers/scsi/mpt2sas/mpt2sas_base.h  |  2 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c   |  2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 24 +++++++++---------------
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 24 +++++++++---------------
 13 files changed, 45 insertions(+), 65 deletions(-)

-- 
1.9.0

