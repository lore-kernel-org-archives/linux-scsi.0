From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 00/11] iSER target initial support for T10-DIF offload
Date: Thu,  9 Jan 2014 18:40:47 +0200
Message-ID: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:57673 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753378AbaAIQlF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jan 2014 11:41:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, martin.petersen@oracle.com, nab@linux-iscsi.org, ogerlitz@mellanox.com, oren@mellanox.com

Hey Nic, MKP, SCSI and RDMA folks,

This patchset adds basic support for T10-DIF protection information offload
in iSER target on top of Nic's recent work and RDMA signature verbs API.

This code was tested with my own implementation of the target core T10-PI support
which was designed mainly to activate the transport DIF offload. In order to
actually get Linux SCSI target to work with iSER T10-DIF offload a couple of
patches needs to be added to Nic's work which is ongoing.

Apart from doing the actual iser implementation for  T10-DIF offload, this
series would help to see the full picture by:

* Showing how the T10-DIF offload verbs are used
* Showing how fabric transport offload plugs into the target core

The T10-DIF signature offload verbs and mlx5 driver implementation patches are available
from the for-next branch of git://beany.openfabrics.org/~ogerlitz/linux-2.6.git
as the below commits:

2b4316b IB/mlx5: Publish support in signature feature
ef3130d IB/mlx5: Collect signature error completion
c1b37b1 IB/mlx5: Support IB_WR_REG_SIG_MR
f5d8496 IB/mlx5: Keep mlx5 MRs in a radix tree under device
72a72ee IB/mlx5: remove MTT access mode from umr flags helper function
ccb0a907 IB/mlx5: Break wqe handling to begin & finish routines
cda0569 IB/mlx5: Initialize mlx5_ib_qp signature related
33b4079 IB/mlx5, mlx5_core: Support for create_mr and destroy_mr
8b343e6 IB/core: Introduce Signature Verbs API
c1b0358 IB/core: Introduce protected memory regions

Sagi Grimberg (11):
  Target/core: Fixes for isert compilation
  IB/isert: seperate connection protection domains and dma MRs
  IB/isert: Avoid frwr notation, user fastreg
  IB/isert: Move fastreg descriptor creation to a function
  Target/iscsi: Add T10-PI indication for iscsi_portal_group
  IB/isert: Initialize T10-PI resources
  IB/isert: pass scatterlist instead of cmd to fast_reg_mr routine
  IB/isert: pass mr and frpl to isert_fast_reg_mr routine
  IB/isert: Accept RDMA_WRITE completions
  IB/isert: Support T10-PI protected transactions
  Target/configfs: Expose iSCSI network portal group T10-PI support

 drivers/infiniband/ulp/isert/ib_isert.c      |  708 +++++++++++++++++++------
 drivers/infiniband/ulp/isert/ib_isert.h      |   29 +-
 drivers/target/iscsi/iscsi_target_configfs.c |    6 +
 drivers/target/iscsi/iscsi_target_core.h     |    5 +-
 drivers/target/iscsi/iscsi_target_tpg.c      |   21 +
 drivers/target/iscsi/iscsi_target_tpg.h      |    1 +
 include/target/target_core_base.h            |   22 +-
 7 files changed, 603 insertions(+), 189 deletions(-)

