From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC 00/12] iSCSI target v4.1.0-rc1 series
Date: Tue,  1 Mar 2011 19:33:49 -0800
Message-ID: <1299036841-23677-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm8-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.230]:39435 "HELO
	nm8-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757726Ab1CBDeN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2011 22:34:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings folks,

This RFC series is a 'for-39' item for the RisingTide Systems iSCSI target fabric
module compatiable with the mainline TCM v4.0 / >= .38-rc target infrastructure
code.  The following commits been broken up into individual sections to make
reviewing easier for those fimilar with the iSCSI protocol.

At this point the code has been converted to use include/scsi/iscsi_proto.h
structure and flag/bit definitions and legacy internal iscsi_protocol.h has
been removed.  There where some minor PDU namespace changes/bugfix to existing
iscsi_proto.h code plus changing existing libiscsi LLDs currently using these
defs.  These external changes have been included as patch #1.

>From there patches #2 -> #12 should be semi self explanatory for iscsi-target
from individual high level commit messages.  This series includes a number of
recent mainline cleanups for iSCSI target in lio-core-2.6.git/lio-4.1, and
includes new iscsi_target_stat.c code using iSCSI fabric dependent ConfigFS
statistic groups.  Also note that all legacy ProcFS based code has been removed
from this series.

Please note this code is against the latest TCM v4.0 patch series for-39 here:

[PATCH 0/5] target updates for scsi-post-merge .39 (round one, v2)
http://marc.info/?l=linux-scsi&m=129893866530385&w=2

This full RFC series with latest v4.0 'for-39' code is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-39-iscsi-target

Please review and comment,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (12):
  iscsi: Resolve iscsi_proto.h naming conflicts with
    drivers/target/iscsi
  iscsi-target: Add primary iSCSI request/response state machine logic
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
 drivers/target/iscsi/iscsi_auth_chap.c            |  502 ++
 drivers/target/iscsi/iscsi_auth_chap.h            |   33 +
 drivers/target/iscsi/iscsi_debug.h                |  113 +
 drivers/target/iscsi/iscsi_parameters.c           | 2078 +++++++
 drivers/target/iscsi/iscsi_parameters.h           |  271 +
 drivers/target/iscsi/iscsi_seq_and_pdu_list.c     |  712 +++
 drivers/target/iscsi/iscsi_seq_and_pdu_list.h     |   88 +
 drivers/target/iscsi/iscsi_target.c               | 6043 +++++++++++++++++++++
 drivers/target/iscsi/iscsi_target.h               |   49 +
 drivers/target/iscsi/iscsi_target_configfs.c      | 1617 ++++++
 drivers/target/iscsi/iscsi_target_configfs.h      |    9 +
 drivers/target/iscsi/iscsi_target_core.h          | 1019 ++++
 drivers/target/iscsi/iscsi_target_datain_values.c |  550 ++
 drivers/target/iscsi/iscsi_target_datain_values.h |   16 +
 drivers/target/iscsi/iscsi_target_device.c        |  128 +
 drivers/target/iscsi/iscsi_target_device.h        |    9 +
 drivers/target/iscsi/iscsi_target_erl0.c          | 1086 ++++
 drivers/target/iscsi/iscsi_target_erl0.h          |   19 +
 drivers/target/iscsi/iscsi_target_erl1.c          | 1382 +++++
 drivers/target/iscsi/iscsi_target_erl1.h          |   35 +
 drivers/target/iscsi/iscsi_target_erl2.c          |  535 ++
 drivers/target/iscsi/iscsi_target_erl2.h          |   21 +
 drivers/target/iscsi/iscsi_target_login.c         | 1411 +++++
 drivers/target/iscsi/iscsi_target_login.h         |   15 +
 drivers/target/iscsi/iscsi_target_nego.c          | 1116 ++++
 drivers/target/iscsi/iscsi_target_nego.h          |   20 +
 drivers/target/iscsi/iscsi_target_nodeattrib.c    |  300 +
 drivers/target/iscsi/iscsi_target_nodeattrib.h    |   14 +
 drivers/target/iscsi/iscsi_target_stat.c          |  955 ++++
 drivers/target/iscsi/iscsi_target_stat.h          |   79 +
 drivers/target/iscsi/iscsi_target_tmr.c           |  908 ++++
 drivers/target/iscsi/iscsi_target_tmr.h           |   17 +
 drivers/target/iscsi/iscsi_target_tpg.c           | 1185 ++++
 drivers/target/iscsi/iscsi_target_tpg.h           |   71 +
 drivers/target/iscsi/iscsi_target_util.c          | 2852 ++++++++++
 drivers/target/iscsi/iscsi_target_util.h          |  128 +
 drivers/target/iscsi/iscsi_thread_queue.c         |  635 +++
 drivers/target/iscsi/iscsi_thread_queue.h         |  103 +
 include/scsi/iscsi_proto.h                        |   30 +-
 48 files changed, 26196 insertions(+), 19 deletions(-)
 create mode 100644 drivers/target/iscsi/Kconfig
 create mode 100644 drivers/target/iscsi/Makefile
 create mode 100644 drivers/target/iscsi/iscsi_auth_chap.c
 create mode 100644 drivers/target/iscsi/iscsi_auth_chap.h
 create mode 100644 drivers/target/iscsi/iscsi_debug.h
 create mode 100644 drivers/target/iscsi/iscsi_parameters.c
 create mode 100644 drivers/target/iscsi/iscsi_parameters.h
 create mode 100644 drivers/target/iscsi/iscsi_seq_and_pdu_list.c
 create mode 100644 drivers/target/iscsi/iscsi_seq_and_pdu_list.h
 create mode 100644 drivers/target/iscsi/iscsi_target.c
 create mode 100644 drivers/target/iscsi/iscsi_target.h
 create mode 100644 drivers/target/iscsi/iscsi_target_configfs.c
 create mode 100644 drivers/target/iscsi/iscsi_target_configfs.h
 create mode 100644 drivers/target/iscsi/iscsi_target_core.h
 create mode 100644 drivers/target/iscsi/iscsi_target_datain_values.c
 create mode 100644 drivers/target/iscsi/iscsi_target_datain_values.h
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
 create mode 100644 drivers/target/iscsi/iscsi_target_stat.c
 create mode 100644 drivers/target/iscsi/iscsi_target_stat.h
 create mode 100644 drivers/target/iscsi/iscsi_target_tmr.c
 create mode 100644 drivers/target/iscsi/iscsi_target_tmr.h
 create mode 100644 drivers/target/iscsi/iscsi_target_tpg.c
 create mode 100644 drivers/target/iscsi/iscsi_target_tpg.h
 create mode 100644 drivers/target/iscsi/iscsi_target_util.c
 create mode 100644 drivers/target/iscsi/iscsi_target_util.h
 create mode 100644 drivers/target/iscsi/iscsi_thread_queue.c
 create mode 100644 drivers/target/iscsi/iscsi_thread_queue.h

-- 
1.7.4.1

