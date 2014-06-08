From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v1 0/3] Include protection information in iscsi header
Date: Sun,  8 Jun 2014 13:27:05 +0300
Message-ID: <1402223228-23768-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:45818 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751907AbaFHK1N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 Jun 2014 06:27:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, martin.petersen@oracle.com, nab@linux-iscsi.org, roland@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org

At the SCSI transport level, there is no distinction between
user data and protection information. Thus, iscsi header field
"expected data transfer length" should include protection
information.

Patch #1 introduces scsi helpers scsi_transfer_length (compute
wire transfer byte count) and scsi_prot_len (compute protection
information byte count).

Patch #2 modifies iscsi initiator to set correct wire transfer length
in iscsi header data_length field (and modifies iser accordingly).

Patch #3 modifies target core to expect protection information included
in the wire transfer length (and modifies loopback transport to do so).

I have 2 patches that convert lpfc/qla2xxx drivers to use scsi helpers
but these are completely untested at the moment. Once we get this set
to land upstream, I can queue them up as RFCs.

Changes from v0:
- Introduce scsi helpers to compute correct transfer length in the
  presence of protection information (instead of having each transport
  doing the same computation).
- Modify iscsi to set correct transfer length using scsi helpers
- Modify loopback transport to set correct transfer length using
  scsi helpers

Sagi Grimberg (3):
  scsi_cmnd: Introduce scsi_transfer_length helper
  libiscsi, iser: Adjust data_length to include protection information
  TARGET/sbc,loopback: Adjust command data length in case pi exists on
    the wire

 drivers/infiniband/ulp/iser/iser_initiator.c |   34 ++++++----------------
 drivers/scsi/libiscsi.c                      |   18 ++++++------
 drivers/target/loopback/tcm_loop.c           |   15 ++++++++--
 drivers/target/target_core_sbc.c             |   15 ++++++++-
 include/scsi/scsi_cmnd.h                     |   39 ++++++++++++++++++++++++++
 5 files changed, 83 insertions(+), 38 deletions(-)

