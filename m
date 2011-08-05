From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH v2 00/18] bnx2fc version 1.0.5
Date: Thu, 4 Aug 2011 17:38:34 -0700
Message-ID: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4919 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755895Ab1HEAjI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 20:39:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, robert.w.love@intel.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

v2 submittal:
Minor changes to patch 5, 8 and patch 13.
Patch 5  - Removed unnecessary printk
Patch 8  - Added code to ignore netdev events other than UNREGISTER for vlan interface
patch 13 - Error handling fixed for tgt_init_err.
--------

This patchset contains bnx2fc bug fixes.  Please note that patch 15 is
'fcoe/libfcoe' patch, which moves LLD common code from fcoe driver to
fcoe_transport, to enable patch 16 and 17.

Bhanu Prakash Gollapudi (18):
  bnx2fc: Reset the max receive frame size
  bnx2fc: Bug fixes in percpu_thread_create/destroy
  bnx2fc: Enable bsg_request support for bnx2fc
  bnx2fc: Remove erroneous kref_get on IO request
  bnx2fc: Do not attempt destroying NPIV port twice
  bnx2fc: Change function names of
    bnx2fc_netdev_setup/bnx2fc_netdev_cleanup
  bnx2fc: Reorganize cleanup code between interface_cleanup and
    if_destory
  bnx2fc: Handle NETDEV_UNREGISTER for vlan devices
  bnx2fc: Clear DESTROY_CMPL flag after firmware destroy
  bnx2fc: Do not reuse the fcoe connection id immediately
  bnx2fc: IO errors when receiving unsolicited LOGO
  bnx2fc: Fix NULL pointer deref during arm_cq.
  bnx2fc: code cleanup in bnx2fc_offload_session
  bnx2fc: Drop incoming ABTS
  fcoe: Move common functions to fcoe_transport library
  bnx2fc: Obtain WWNN/WWPN from the shared memory
  bnx2fc: Prevent creating of NPIV port with duplicate WWN
  bnx2fc: Bump version to 1.0.5

 drivers/scsi/bnx2fc/bnx2fc.h       |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c  |  191 ++++++++++++++++++++++++------------
 drivers/scsi/bnx2fc/bnx2fc_hwi.c   |   10 ++-
 drivers/scsi/bnx2fc/bnx2fc_io.c    |    7 --
 drivers/scsi/bnx2fc/bnx2fc_tgt.c   |   27 +++---
 drivers/scsi/fcoe/fcoe.c           |   66 +------------
 drivers/scsi/fcoe/fcoe.h           |   10 --
 drivers/scsi/fcoe/fcoe_transport.c |   72 ++++++++++++++
 include/scsi/libfcoe.h             |    3 +
 9 files changed, 225 insertions(+), 163 deletions(-)


