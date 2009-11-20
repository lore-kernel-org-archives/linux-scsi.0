From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/9] libfc, libfcoe and fcoe updates for scsi-misc.git (2.6.33)
Date: Fri, 20 Nov 2009 14:54:36 -0800
Message-ID: <20091120225436.495.88600.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:32762 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbZKTWyn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2009 17:54:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

The following series adds the following-

1) Support for a link status error block (LESB) command.

2) A performance optimization. If an incoming FCP frame is already on the correct CPU then bypass the Rx threads and process in irq context.

3) At least one fix.

---

Chris Leech (1):
      fcoe: allow SCSI-FCP to be processed directly in softirq context

Yi Zou (8):
      libfc: add support of receiving ELS_RLS
      fcoe, libfc: add get_lesb() to allow LLD to fill the link error status block (LESB)
      libfc: add fcoe_fc_els_lesb to fc_fcoe.h for FC-BB-5 LESB definitions
      libfcoe: add tracking FIP Missing Discovery Advertisement count
      libfcoe: add tracking FIP Virtual Link Failure count
      libfcoe: add checking disable flag in FIP_FKA_ADV
      libfc: add FC-BB-5 LESB counters to fcoe_dev_stats
      libfc: fix payload size passed to fc_frame_alloc() in fc_lport_els_request


 drivers/scsi/fcoe/fcoe.c      |  279 +++++++++++++++++++++++++----------------
 drivers/scsi/fcoe/libfcoe.c   |   20 +++
 drivers/scsi/libfc/fc_lport.c |    3 
 drivers/scsi/libfc/fc_rport.c |   76 +++++++++++
 include/scsi/fc/fc_fcoe.h     |   12 ++
 include/scsi/fc/fc_fip.h      |   12 ++
 include/scsi/libfc.h          |   10 +
 include/scsi/libfcoe.h        |    1 
 8 files changed, 299 insertions(+), 114 deletions(-)

-- 
//Rob
