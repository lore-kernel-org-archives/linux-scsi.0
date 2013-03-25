From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/5] libfc, bnx2fc, fcoe fixes for 3.9-rc
Date: Mon, 25 Mar 2013 16:35:39 -0700
Message-ID: <20130325233539.17257.76078.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49517 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338Ab3CYXfn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Mar 2013 19:35:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This series fixes a few critical issues with FCoE in 3.9.

1) bnx2fc had incorrect scsi host linkage in sysfs which prevents fcoemon
   (fcoe userspace daemon) from interacting with it correctly.

2) 3 patches fix VN2VN mode configuration with new FCoE control interfaces.

3) Fixed lockdep warning

These patches are needed to allow fcoe to move to the new sysfs interfaces.

I would like to see these pushed upstream for 3.9-rc. A pull-request mail
will immediately follow this series.

---

Robert Love (5):
      bnx2fc: Make the fcoe_cltr the SCSI host parent
      fcoe: Fix deadlock between create and destroy paths
      libfc, fcoe, bnx2fc: Always use fcoe_disc_init for discovery layer initialization
      libfc, fcoe, bnx2fc: Split fc_disc_init into fc_disc_{init, config}
      libfcoe: Fix fcoe_sysfs VN2VN mode


 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    6 ++--
 drivers/scsi/fcoe/fcoe.c          |   15 +++++++--
 drivers/scsi/fcoe/fcoe_ctlr.c     |   60 ++++++++++++++++++++++++++++---------
 drivers/scsi/libfc/fc_disc.c      |   26 +++++++++++-----
 include/scsi/libfc.h              |    3 +-
 5 files changed, 80 insertions(+), 30 deletions(-)

-- 
Thanks, //Rob
