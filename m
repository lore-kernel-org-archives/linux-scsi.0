From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/2] target: 64-bit LUN support
Date: Wed, 10 Jun 2015 08:41:21 +0200
Message-ID: <1433918483-46849-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbbFJGl0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2015 02:41:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>

Hi Nic,

here's now the patchset for making LIO-target support 64-bit LUNs.
Pretty straightforward, plus an additional patch to remove the
now obsolete limitation on 256 LUNs per TPG. There had been a
comment in the header that REPORT LUN emulation would only support
up to one page in payload, but I couldn't find any evidence for
this in the code.

As usual, comments and reviews are welcome.

Patchset is relative to the 'for-next' branch of target-pending.

Hannes Reinecke (2):
  target: use 64-bit LUNs
  target: Remove TARGET_MAX_LUNS_PER_TRANSPORT

 drivers/target/iscsi/iscsi_target_tmr.c      |  4 +--
 drivers/target/loopback/tcm_loop.c           |  4 +--
 drivers/target/target_core_alua.c            |  2 +-
 drivers/target/target_core_configfs.c        | 12 ++++----
 drivers/target/target_core_device.c          | 39 ++++++++++---------------
 drivers/target/target_core_fabric_configfs.c | 24 ++++------------
 drivers/target/target_core_internal.h        | 10 +++----
 drivers/target/target_core_pr.c              | 43 ++++++++++++++--------------
 drivers/target/target_core_pr.h              |  6 ++--
 drivers/target/target_core_tpg.c             | 13 ++-------
 drivers/target/target_core_transport.c       |  6 ++--
 drivers/target/target_core_ua.c              |  8 +++---
 drivers/target/target_core_ua.h              |  2 +-
 drivers/xen/xen-scsiback.c                   |  7 +++--
 include/target/target_core_base.h            | 22 +++++++-------
 include/target/target_core_fabric.h          | 10 +++----
 16 files changed, 90 insertions(+), 122 deletions(-)

-- 
1.8.5.2

