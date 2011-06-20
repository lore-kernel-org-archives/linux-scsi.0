From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH v2 00/12] libfc, libfcoe and fcoe updates for scsi-misc
Date: Mon, 20 Jun 2011 16:58:48 -0700
Message-ID: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31171 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135Ab1FTX6s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2011 19:58:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following series contains target offload patches and
a few bug fixes. The main change that this series presents
is target mode offload support. These are the same offloads
that the initiator uses, so there is no new hardware support.
There is a new hook in the netdev_ops structure to setup
a DDP context for an offloadable exchange. If ndo_fcoe_ddp_target
is present on the netdevice the fcoe stack will make use of
it. This interfce was merged at the v3.0 merge window, so
all depedencies should already be complete and in-kernel.

Aside from this feature there are a few fixes to tcm_fc as
well as libfc and fcoe.

All patches were tested against scsi-misc on the day of
this posting.

---

Kiran Patil (8):
      tcm_fc: Fix warning in file tfc_io
      libfc: Enhancement to RPORT state machine applicable only for VN2VN mode
      fcoe: Unable to select the exchangeID from offload pool for storage targets
      fcoe: Round-robin based selection of CPU for post-processing of incoming commands
      fcoe: Amends previous patch, Round-robin based selection of CPU for post processing of incoming request for FCoE target
      libfc:Fix for exchange/seq loopup failure when FCoE stack is used as target and connected to windows initaitor
      tcm_fc: Fix ft_send_tm-bug and drop ft_get_lun_for_cmd usage
      tcm_fc: Fixing reference counting problem which was causing ft_sess to be deleted.

Neerav Parikh (1):
      fcoe: Rearrange fcoe port and NPIV port cleanup

Vasu Dev (1):
      libfc: post reset event on lport reset

Yi Zou (2):
      libfc, tcm_fc: add ddp_targ() to libfc function template to supprot FCoE DDP in target mode
      fcoe: support ndo_fcoe_ddp_target() for DDP in FCoE targe


 drivers/scsi/fcoe/fcoe.c        |  174 ++++++++++++++++++++++++++++++---------
 drivers/scsi/libfc/fc_exch.c    |   26 +++++-
 drivers/scsi/libfc/fc_lport.c   |    2 
 drivers/scsi/libfc/fc_rport.c   |   14 +++
 drivers/target/tcm_fc/tcm_fc.h  |    2 
 drivers/target/tcm_fc/tfc_cmd.c |   88 +++++++++++---------
 drivers/target/tcm_fc/tfc_io.c  |    2 
 include/scsi/libfc.h            |    8 ++
 8 files changed, 233 insertions(+), 83 deletions(-)

-- 
Thanks, //Rob
