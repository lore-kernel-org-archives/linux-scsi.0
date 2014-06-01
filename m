From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 0/2] Include protection information in iscsi header
Date: Sun,  1 Jun 2014 19:19:39 +0300
Message-ID: <1401639581-20111-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, oren@mellanox.com
List-Id: linux-scsi@vger.kernel.org

At the SCSI transport level, there is no distinction between
user data and protection information. Thus, iscsi header field
"expected data transfer length" should include protection
information.

This set modifies both the iscsi initiator (patch #1), and
target (patch #2) to expect data length which includes
protection information.

Although these patches involve 3 subsystems with different
maintainers (scsi, iser, target) I would prefer seeing these
patches included together.

Sagi Grimberg (2):
  libiscsi, iser: Adjust data_length to include protection information
  TARGET/sbc,loopback: Adjust command data length in case pi exists on
    the wire

 drivers/infiniband/ulp/iser/iser_initiator.c |   34 +++++++-----------------
 drivers/scsi/libiscsi.c                      |   35 +++++++++++++++++++++++++-
 drivers/target/loopback/tcm_loop.c           |   35 +++++++++++++++++++++++---
 drivers/target/target_core_sbc.c             |   15 +++++++++-
 include/scsi/libiscsi.h                      |   19 ++++++++++++++
 5 files changed, 107 insertions(+), 31 deletions(-)
