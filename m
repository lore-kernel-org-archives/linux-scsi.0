From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v2 0/3] Include protection information in transport header
Date: Wed, 11 Jun 2014 12:09:56 +0300
Message-ID: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:58193 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755767AbaFKJKF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2014 05:10:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, martin.petersen@oracle.com, nab@linux-iscsi.org, roland@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org

At the SCSI transport level, there is no distinction between
user data and protection information. Thus, iscsi header field
"expected data transfer length" should include protection
information.

Patch #1 introduces scsi helper scsi_transfer_length which computes
wire transfer byte count.

Patch #2 modifies iscsi initiator to set correct wire transfer length
in iscsi header data_length field (and modifies iser accordingly).

Patch #3 modifies target core to re-calculate the pure data length
in case of PI presence over the wire (and modifies loopback transport
to align with other transports).

Changes from v1:
- scsi_cmnd: Rewrite scsi_transfer_length as MKP suggested
- Target/sbc: re-calculate the data_length in case PI exists
  on the wire (instead od deacrease data -= prot)

Changes from v0:
- Introduce scsi helpers to compute correct transfer length in the
  presence of protection information.
- Modify iscsi to set correct transfer length using scsi helpers
- Modify loopback transport to set correct transfer length using
  scsi helpers

Sagi Grimberg (3):
  scsi_cmnd: Introduce scsi_transfer_length helper
  libiscsi, iser: Adjust data_length to include protection information
  TARGET/sbc,loopback: Adjust command data length in case pi exists on
    the wire

 drivers/infiniband/ulp/iser/iser_initiator.c |   34 +++++++------------------
 drivers/scsi/libiscsi.c                      |   18 +++++++-------
 drivers/target/loopback/tcm_loop.c           |   15 +++++++++--
 drivers/target/target_core_sbc.c             |   15 ++++++++++-
 include/scsi/scsi_cmnd.h                     |   17 +++++++++++++
 5 files changed, 61 insertions(+), 38 deletions(-)

