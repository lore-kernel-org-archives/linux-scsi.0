From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/6] fcoe: VN2VN target mode fixes
Date: Mon,  4 Jul 2016 10:29:17 +0200
Message-ID: <1467620963-67047-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40740 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbcGDI3d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jul 2016 04:29:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

When setting up a VN2VN FCoE target there is no real need to
run fcoeadm, especially if DCB is disabled.
So this patchset implements a VIP VLAN responder which can be
enabled by writing to the sysfs attribute 'fip_vlan_responder'.
Additionally there are some fixes for VN2VN mode, most notably
the multicast address update when changing modes.

As usual, comments and reviews are welcome.

Hannes Reinecke (6):
  fc_fip: Update to latest FC-BB-6 draft
  fcoe: use enum for fip_mode
  fcoe: fcoe->realdev is always set
  fcoe: Update multicast addresses on FIP mode change
  fcoe: implement FIP VLAN responder
  fcoe: Use default VLAN for FIP VLAN discovery

 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   6 +-
 drivers/scsi/fcoe/fcoe.c          |  95 ++++++++++++++--
 drivers/scsi/fcoe/fcoe.h          |   1 +
 drivers/scsi/fcoe/fcoe_ctlr.c     | 234 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/fcoe/fcoe_sysfs.c    |  39 +++++++
 drivers/scsi/fnic/fnic_fcs.c      |   6 +-
 drivers/scsi/fnic/fnic_fip.h      |   8 --
 include/scsi/fc/fc_fip.h          |  21 +++-
 include/scsi/libfc.h              |   1 +
 include/scsi/libfcoe.h            |  19 ++--
 10 files changed, 391 insertions(+), 39 deletions(-)

-- 
1.8.5.6

