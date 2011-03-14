From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v2 00/12] iSCSI target v4.1.0-rc1 series for .39
Date: Mon, 14 Mar 2011 04:56:57 -0700
Message-ID: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm18-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.138]:39725 "HELO
	nm18-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754493Ab1CNMDn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 08:03:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings folks,

This is the second RFC series for the RisingTide Systems iSCSI target fabric
module compatible with mainline TCM v4 -> for-39 target infrastructure code.
The following commits been broken up into individual sections to make reviewing
easier for those fimilar with the iSCSI protocol.  This series will be submitted
as a single commit following mainline convention for an initial merge as the .39
window opens later week.

At this point the code has been fully converted to use include/scsi/iscsi_proto.h
PDU struct request/response and flag/bit definitions, and the legacy internal
iscsi_protocol.h definitions have been removed from this series.  There are
some minor PDU namespace changes and a SNACK PDU definition fix to mainline
include/scsi/iscsi_proto.h code, plus changing the handful of existing libiscsi
based LLDs currently using the libiscsi SCSI Command / Response PDU definitions.
These changes external to iSCSI target code have been included as patch #1.
(mnc and hare please review)

>From there patches #2 -> #12 should be self explanatory for iscsi-target from
individual high level commit messages.  This series includes a number of
recent upstream improvements and cleanups to iscsi_target_mod.ko in
lio-core-2.6.git/lio-4.1, and includes iscsi_target_stat.c using the new
TCM v4 fabric dependent statistic groups.  Also note that all legacy ProcFS
based code for iSCSI MIBs has been converted into ConfigFS based attributes
or otherwise removed for mainline. (hch, boaz and tomo-san please review)

Please note this code is intended to be applied against the latest 'for-39'
target series posed here:

[PATCH 00/21] target patches for .39 scsi-misc (v3)
http://marc.info/?l=linux-scsi&m=130010108521141&w=2

The changes from RFC-v1 -> RFC-v2 include:

*) Drop extra crc32c_intel libcrypto magic from iscsi_login_setup_crypto()
*) Fix padded login response payload breakage from initial iscsi_proto.h
   conversion
*) Cleanups for iscsi_target_core.h and conversion a number of definitions
   to enums and inline defs
*) Removal of '__' prefix around u32 and friends
*) Other miscellanous checkpatch.pl cleanups

The full RFC-v2 series with latest target 'for-39' code is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-39-iscsi-target-v2

Please add your comments folks, and I will plan to respin an updated merge
commit upon review.

Thanks!

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
 drivers/target/iscsi/iscsi_parameters.c           | 2054 ++++++++
 drivers/target/iscsi/iscsi_parameters.h           |  271 +
 drivers/target/iscsi/iscsi_seq_and_pdu_list.c     |  712 +++
 drivers/target/iscsi/iscsi_seq_and_pdu_list.h     |   88 +
 drivers/target/iscsi/iscsi_target.c               | 5844 +++++++++++++++++++++
 drivers/target/iscsi/iscsi_target.h               |   49 +
 drivers/target/iscsi/iscsi_target_configfs.c      | 1610 ++++++
 drivers/target/iscsi/iscsi_target_configfs.h      |    9 +
 drivers/target/iscsi/iscsi_target_core.h          |  962 ++++
 drivers/target/iscsi/iscsi_target_datain_values.c |  549 ++
 drivers/target/iscsi/iscsi_target_datain_values.h |   15 +
 drivers/target/iscsi/iscsi_target_device.c        |  128 +
 drivers/target/iscsi/iscsi_target_device.h        |    9 +
 drivers/target/iscsi/iscsi_target_erl0.c          | 1085 ++++
 drivers/target/iscsi/iscsi_target_erl0.h          |   19 +
 drivers/target/iscsi/iscsi_target_erl1.c          | 1381 +++++
 drivers/target/iscsi/iscsi_target_erl1.h          |   35 +
 drivers/target/iscsi/iscsi_target_erl2.c          |  534 ++
 drivers/target/iscsi/iscsi_target_erl2.h          |   20 +
 drivers/target/iscsi/iscsi_target_login.c         | 1381 +++++
 drivers/target/iscsi/iscsi_target_login.h         |   14 +
 drivers/target/iscsi/iscsi_target_nego.c          | 1113 ++++
 drivers/target/iscsi/iscsi_target_nego.h          |   19 +
 drivers/target/iscsi/iscsi_target_nodeattrib.c    |  300 ++
 drivers/target/iscsi/iscsi_target_nodeattrib.h    |   14 +
 drivers/target/iscsi/iscsi_target_stat.c          |  955 ++++
 drivers/target/iscsi/iscsi_target_stat.h          |   79 +
 drivers/target/iscsi/iscsi_target_tmr.c           |  908 ++++
 drivers/target/iscsi/iscsi_target_tmr.h           |   16 +
 drivers/target/iscsi/iscsi_target_tpg.c           | 1165 ++++
 drivers/target/iscsi/iscsi_target_tpg.h           |   70 +
 drivers/target/iscsi/iscsi_target_util.c          | 2852 ++++++++++
 drivers/target/iscsi/iscsi_target_util.h          |  128 +
 drivers/target/iscsi/iscsi_thread_queue.c         |  635 +++
 drivers/target/iscsi/iscsi_thread_queue.h         |  102 +
 include/scsi/iscsi_proto.h                        |   30 +-
 48 files changed, 25845 insertions(+), 19 deletions(-)
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

