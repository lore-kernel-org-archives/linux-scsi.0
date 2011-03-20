From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v4 00/12] iSCSI target v4.1.0-rc1 series for .39-rc1
Date: Sun, 20 Mar 2011 02:31:25 -0700
Message-ID: <1300613497-2091-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Douglas Gilbert <dgilbert@interlog.com>, Jesper Juhl <jj@chaosbits.net>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This is the forth RFC series of the RisingTide Systems iSCSI target fabric
module compatible with mainline target core v4 -> for-39 target infrastructure.

More information about iscsi_target_mod is available here:

http://linux-iscsi.org/wiki/ISCSI/configFS

This series contains the updated drivers/target/iscsi/ source tree for modern
mainline code based on feedback from Christoph Hellwig that has been recently
pushed into the lio-core-2.6.git/lio-4.1 development branch.  This includes
another round of iSCSI network portal changes to use proper Linux/Net code
w/ IPv6/IPv4 iscsi_np->np_sockaddr, conversion of iSCSI TX thread context
to use schedule_timeout_interruptible(), and the renaming the majority of
functions to use the 'iscsit_*' function prefix based upon hch's feedback.

This series is currently rebased against .38-FINAL using target core v4.0.0-rc7-ml.

The full RFC-v4 series for iscsi-target is available here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-39-iscsi-target-v4

The changes from RFC-v3 -> RFC-v4 include:

*) Make iscsit_[free,stop]_session take conn_tmp reference first
*) Convert NPF_NET_IPV* flags to AF_INET*
*) Add missing unlock for iscsi_get_np
*) Convert iscsi_target_tpg.c to use 'iscsit_' function prefixe
*) Convert iscsi_target_device.c to use 'iscsit_' function pref
*) Convert iscsi_target_seq_pdu_list.c to use 'iscsit_' functio
*) Convert iscsi_target_datain_values.c to use 'iscsit_' functi
*) Convert iscsi_target_tmr.c to use 'iscsit_' function prefixe
*) Convert iscsi_target_nodeattrib.c to use 'iscsit_' function 
*) Convert iscsi_target_erl*.c to use 'iscsit_' function prefix
*) Convert iscsi_target_util.c to use 'iscsit_' function prefix
*) Convert iscsi_target.c to use 'iscsit_' function prefixes
*) Move iscsi_add_nopin into iscsi_target_util.c
*) Move iscsi_ack_from_expstatsn into iscsi_target.c
*) Drop needless iscsi_target_util.c wrappers
*) Move extern target_core_fabric_ops functions into iscsi_targ
*) Add comments for RX/TX nice usage and iscsi_release_commands
*) Convert TX thread to use schedule_timeout_interruptible
*) Fix potential NULL deference in iscsi_[free,stop]_session
*) Fix iscsi_np shutdown race
*) Drop iscsi_np->np_shutdown and ->np_state_lock
*) Remove dead iscsi_tpg_free_network_portals code
*) Remove remaining comment stubs
*) Convert cases to wait_for_completion*_timeout
*) Remove ad-hod debugging code

The changes from RFC-v2 -> RFC-v3 include:

*) Remove dead tpg shutdown code
*) Remove dead struct iscsi_np_ex logic
*) Fix up network portal handling
*) Rename core_* prefixed functions to iscsit_*
*) Convert semaphores to completion and mutex
*) Convert iscsi_global members to global variables
*) Cleanups for iscsi_target_login_thread logic
*) Use SIGINT in iscsi_handle_login_thread_timeout()
*) Cleanups for iscsi_thread_queue.c logic
*) Drop MOD_TIMER and SETUP_TIMER macros
*) Convert iscsi_index_t to use idr.h
*) Remove CONN* and SESS* deference macros
*) Update copyright and vendor
*) Fix up remaining struct semaphore callbacks
*) Renaming renaming non iscsi_target_* source files

The changes from RFC-v1 -> RFC-v2 include:

*) Drop extra crc32c_intel libcrypto magic from iscsi_login_setup_crypto()
*) Fix padded login response payload breakage from initial iscsi_proto.h
   conversion
*) Cleanups for iscsi_target_core.h and conversion a number of definitions
   to enums and inline defs
*) Removal of '__' prefix around u32 and friends
*) Other miscellanous checkpatch.pl cleanups

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
 drivers/target/iscsi/iscsi_target.c               | 5047 +++++++++++++++++++++
 drivers/target/iscsi/iscsi_target.h               |   32 +
 drivers/target/iscsi/iscsi_target_auth.c          |  496 ++
 drivers/target/iscsi/iscsi_target_auth.h          |   32 +
 drivers/target/iscsi/iscsi_target_configfs.c      | 1922 ++++++++
 drivers/target/iscsi/iscsi_target_configfs.h      |    7 +
 drivers/target/iscsi/iscsi_target_core.h          |  882 ++++
 drivers/target/iscsi/iscsi_target_datain_values.c |  532 +++
 drivers/target/iscsi/iscsi_target_datain_values.h |   16 +
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
 drivers/target/iscsi/iscsi_target_parameters.c    | 1910 ++++++++
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
 drivers/target/iscsi/iscsi_target_tq.h            |   90 +
 drivers/target/iscsi/iscsi_target_util.c          | 2526 +++++++++++
 drivers/target/iscsi/iscsi_target_util.h          |  118 +
 include/scsi/iscsi_proto.h                        |   30 +-
 48 files changed, 23718 insertions(+), 19 deletions(-)
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
