From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 00/12] iscsi-target: iSCSI target v4.1.0-rc1 series initial merge
Date: Mon, 21 Mar 2011 18:42:19 -0700
Message-ID: <1300758151-8211-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm28.bullet.mail.bf1.yahoo.com ([98.139.212.187]:46969 "HELO
	nm28.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754756Ab1CVBmh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 21:42:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James,

Here is an initial mergeable + squashable version of iscsi_target_mod.

Please merge patch #1 as a seperate libiscsi commit with Mike's signoff,
and squash #2 -> #12 using the commit message message of patch #2 for
an initial mergeable commit.

I will follow with any comments from Chrisopth, Mike & Co.

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (12):
  iscsi: Resolve iscsi_proto.h naming conflicts with
    drivers/target/iscsi
  iscsi-target: Add iSCSI fabric support for target v4
  iscsi-target: Add TCM v4 compatiable ConfigFS control plane
  iscsi-target: Add configfs fabric dependent statistics
  iscsi-target: Add TPG and Device logic
  iscsi-target: Add iSCSI Login Negotiation and Parameter logic
  iscsi-target: Add CHAP Authentication support using libcrypto
  iscsi-target: Add Sequence/PDU list + DataIN response logic
  iscsi-target: Add iSCSI Error Recovery Hierarchy support
  iscsi-target: Add support for task management operations
  iscsi-target: Add misc utility and debug logic
  iscsi-target: Add Makefile/Kconfig and update TCM top level

 drivers/infiniband/ulp/iser/iser_initiator.c      |    2 +-
 drivers/scsi/be2iscsi/be_main.h                   |    4 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                    |    8 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                  |    2 +-
 drivers/scsi/libiscsi.c                           |    6 +-
 drivers/target/Kconfig                            |    1 +
 drivers/target/Makefile                           |    1 +
 drivers/target/iscsi/Kconfig                      |   17 +
 drivers/target/iscsi/Makefile                     |   20 +
 drivers/target/iscsi/iscsi_target.c               | 5047 +++++++++++++++++++++
 drivers/target/iscsi/iscsi_target.h               |   32 +
 drivers/target/iscsi/iscsi_target_auth.c          |  496 ++
 drivers/target/iscsi/iscsi_target_auth.h          |   32 +
 drivers/target/iscsi/iscsi_target_configfs.c      | 1922 ++++++++
 drivers/target/iscsi/iscsi_target_configfs.h      |    7 +
 drivers/target/iscsi/iscsi_target_core.h          |  882 ++++
 drivers/target/iscsi/iscsi_target_datain_values.c |  531 +++
 drivers/target/iscsi/iscsi_target_datain_values.h |   15 +
 drivers/target/iscsi/iscsi_target_debug.h         |  113 +
 drivers/target/iscsi/iscsi_target_device.c        |  107 +
 drivers/target/iscsi/iscsi_target_device.h        |    9 +
 drivers/target/iscsi/iscsi_target_erl0.c          | 1005 ++++
 drivers/target/iscsi/iscsi_target_erl0.h          |   17 +
 drivers/target/iscsi/iscsi_target_erl1.c          | 1305 ++++++
 drivers/target/iscsi/iscsi_target_erl1.h          |   28 +
 drivers/target/iscsi/iscsi_target_erl2.c          |  483 ++
 drivers/target/iscsi/iscsi_target_erl2.h          |   18 +
 drivers/target/iscsi/iscsi_target_login.c         | 1282 ++++++
 drivers/target/iscsi/iscsi_target_login.h         |   13 +
 drivers/target/iscsi/iscsi_target_nego.c          | 1068 +++++
 drivers/target/iscsi/iscsi_target_nego.h          |   19 +
 drivers/target/iscsi/iscsi_target_nodeattrib.c    |  264 ++
 drivers/target/iscsi/iscsi_target_nodeattrib.h    |   14 +
 drivers/target/iscsi/iscsi_target_parameters.c    | 1909 ++++++++
 drivers/target/iscsi/iscsi_target_parameters.h    |  271 ++
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  |  667 +++
 drivers/target/iscsi/iscsi_target_seq_pdu_list.h  |   88 +
 drivers/target/iscsi/iscsi_target_stat.c          |  950 ++++
 drivers/target/iscsi/iscsi_target_stat.h          |   64 +
 drivers/target/iscsi/iscsi_target_tmr.c           |  854 ++++
 drivers/target/iscsi/iscsi_target_tmr.h           |   14 +
 drivers/target/iscsi/iscsi_target_tpg.c           |  788 ++++
 drivers/target/iscsi/iscsi_target_tpg.h           |   43 +
 drivers/target/iscsi/iscsi_target_tq.c            |  552 +++
 drivers/target/iscsi/iscsi_target_tq.h            |   89 +
 drivers/target/iscsi/iscsi_target_util.c          | 2526 +++++++++++
 drivers/target/iscsi/iscsi_target_util.h          |  117 +
 include/scsi/iscsi_proto.h                        |   30 +-
 48 files changed, 23713 insertions(+), 19 deletions(-)
 create mode 100644 drivers/target/iscsi/Kconfig
 create mode 100644 drivers/target/iscsi/Makefile
 create mode 100644 drivers/target/iscsi/iscsi_target.c
 create mode 100644 drivers/target/iscsi/iscsi_target.h
 create mode 100644 drivers/target/iscsi/iscsi_target_auth.c
 create mode 100644 drivers/target/iscsi/iscsi_target_auth.h
 create mode 100644 drivers/target/iscsi/iscsi_target_configfs.c
 create mode 100644 drivers/target/iscsi/iscsi_target_configfs.h
 create mode 100644 drivers/target/iscsi/iscsi_target_core.h
 create mode 100644 drivers/target/iscsi/iscsi_target_datain_values.c
 create mode 100644 drivers/target/iscsi/iscsi_target_datain_values.h
 create mode 100644 drivers/target/iscsi/iscsi_target_debug.h
 create mode 100644 drivers/target/iscsi/iscsi_target_device.c
 create mode 100644 drivers/target/iscsi/iscsi_target_device.h
 create mode 100644 drivers/target/iscsi/iscsi_target_erl0.c
 create mode 100644 drivers/target/iscsi/iscsi_target_erl0.h
 create mode 100644 drivers/target/iscsi/iscsi_target_erl1.c
 create mode 100644 drivers/target/iscsi/iscsi_target_erl1.h
 create mode 100644 drivers/target/iscsi/iscsi_target_erl2.c
 create mode 100644 drivers/target/iscsi/iscsi_target_erl2.h
 create mode 100644 drivers/target/iscsi/iscsi_target_login.c
 create mode 100644 drivers/target/iscsi/iscsi_target_login.h
 create mode 100644 drivers/target/iscsi/iscsi_target_nego.c
 create mode 100644 drivers/target/iscsi/iscsi_target_nego.h
 create mode 100644 drivers/target/iscsi/iscsi_target_nodeattrib.c
 create mode 100644 drivers/target/iscsi/iscsi_target_nodeattrib.h
 create mode 100644 drivers/target/iscsi/iscsi_target_parameters.c
 create mode 100644 drivers/target/iscsi/iscsi_target_parameters.h
 create mode 100644 drivers/target/iscsi/iscsi_target_seq_pdu_list.c
 create mode 100644 drivers/target/iscsi/iscsi_target_seq_pdu_list.h
 create mode 100644 drivers/target/iscsi/iscsi_target_stat.c
 create mode 100644 drivers/target/iscsi/iscsi_target_stat.h
 create mode 100644 drivers/target/iscsi/iscsi_target_tmr.c
 create mode 100644 drivers/target/iscsi/iscsi_target_tmr.h
 create mode 100644 drivers/target/iscsi/iscsi_target_tpg.c
 create mode 100644 drivers/target/iscsi/iscsi_target_tpg.h
 create mode 100644 drivers/target/iscsi/iscsi_target_tq.c
 create mode 100644 drivers/target/iscsi/iscsi_target_tq.h
 create mode 100644 drivers/target/iscsi/iscsi_target_util.c
 create mode 100644 drivers/target/iscsi/iscsi_target_util.h

-- 
1.7.4.1

