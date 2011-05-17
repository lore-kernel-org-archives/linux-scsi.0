From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v4 00/14] iscsi-target: initial .40-rc1 drivers/target/iscsi merge
Date: Mon, 16 May 2011 23:39:20 -0700
Message-ID: <1305614374-17953-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Martin Svec <martin.svec@zoner.cz>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James & Co,

Here is an updated v4 mergeable + squashable .40-rc1 series of iscsi-target
against mainline .39-rc7 target core intrastructure containing the latest
lio-core-2.6.git upstream bugfixes.  The includes the following changes
from PATCH-v3:

*) An iscsi_del_np() shutdown race OOPs bugfix patch from Martin Svec
*) Bugfix series to address bogus legacy usage of *pos NULL checks after
   list_for_each_entry() by as reported Arne Redlich
*) Kconfig change allow iscsi-target to be built into the kernel as
   reported by Randy Dunlap

This patch series is made against the following linux-2.6.git commit:

commit 693d92a1bbc9e42681c42ed190bd42b636ca876f
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon May 9 19:33:54 2011 -0700

    Linux 2.6.39-rc7

As before, please merge patch #1 + #2 as seperate libiscsi commits with
Mike's signoff.  Patch #3 is a seperate target_core int_to_scsilun()
conversion patch so we can drop legacy target_core_fabric_ops->pack_lun()
for the initial merge of iscsi-target.  Thanks again to Mike's recommendation
and Martin's target v4.1 bugfix in upstream lio-core-2.6.git on this particular
bit..

>From there please go ahead and squash #4 -> #14 using the commit message of patch #4
for an initial commit for iscsi-target proper.

The complete series is also available directly from git here:

   git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-40-iscsi-target-merge-v2

At this point the outstanding iscsi-target v4.1 regressions have been addressed,
and I think this series looks good as an initial merge candidate for .40-rc1.

James, can you please have a look to get this merged soon so that I can rebase a
set of Andy's upstream LIO v4.1 improvements/cleanups for mainline .40 target
core currently in my queue with the new iscsi-target included..?

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (14):
  iscsi: Resolve iscsi_proto.h naming conflicts with
    drivers/target/iscsi
  iscsi: Add Serial Number Arithmetic LT and GT into iscsi_proto.h
  target: Convert REPORT_LUNs to use int_to_scsilun
  iscsi-target: Add iSCSI fabric support for target v4
  iscsi-target: Add TCM v4 compatiable ConfigFS control plane
  iscsi-target: Add configfs fabric dependent statistics
  iscsi-target: Add TPG and Device logic
  iscsi-target: Add iSCSI Login Negotiation + Parameter logic
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
 drivers/scsi/libiscsi.c                           |   22 +-
 drivers/target/Kconfig                            |    1 +
 drivers/target/Makefile                           |    1 +
 drivers/target/iscsi/Kconfig                      |   18 +
 drivers/target/iscsi/Makefile                     |   20 +
 drivers/target/iscsi/iscsi_target.c               | 4962 +++++++++++++++++++++
 drivers/target/iscsi/iscsi_target.h               |   42 +
 drivers/target/iscsi/iscsi_target_auth.c          |  496 ++
 drivers/target/iscsi/iscsi_target_auth.h          |   31 +
 drivers/target/iscsi/iscsi_target_configfs.c      | 1925 ++++++++
 drivers/target/iscsi/iscsi_target_configfs.h      |    7 +
 drivers/target/iscsi/iscsi_target_core.h          |  859 ++++
 drivers/target/iscsi/iscsi_target_datain_values.c |  533 +++
 drivers/target/iscsi/iscsi_target_datain_values.h |   12 +
 drivers/target/iscsi/iscsi_target_debug.h         |  113 +
 drivers/target/iscsi/iscsi_target_device.c        |   88 +
 drivers/target/iscsi/iscsi_target_device.h        |    9 +
 drivers/target/iscsi/iscsi_target_erl0.c          | 1005 +++++
 drivers/target/iscsi/iscsi_target_erl0.h          |   15 +
 drivers/target/iscsi/iscsi_target_erl1.c          | 1306 ++++++
 drivers/target/iscsi/iscsi_target_erl1.h          |   26 +
 drivers/target/iscsi/iscsi_target_erl2.c          |  483 ++
 drivers/target/iscsi/iscsi_target_erl2.h          |   18 +
 drivers/target/iscsi/iscsi_target_login.c         | 1233 +++++
 drivers/target/iscsi/iscsi_target_login.h         |   12 +
 drivers/target/iscsi/iscsi_target_nego.c          | 1068 +++++
 drivers/target/iscsi/iscsi_target_nego.h          |   17 +
 drivers/target/iscsi/iscsi_target_nodeattrib.c    |  264 ++
 drivers/target/iscsi/iscsi_target_nodeattrib.h    |   14 +
 drivers/target/iscsi/iscsi_target_parameters.c    | 1906 ++++++++
 drivers/target/iscsi/iscsi_target_parameters.h    |  269 ++
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  |  665 +++
 drivers/target/iscsi/iscsi_target_seq_pdu_list.h  |   86 +
 drivers/target/iscsi/iscsi_target_stat.c          |  950 ++++
 drivers/target/iscsi/iscsi_target_stat.h          |   64 +
 drivers/target/iscsi/iscsi_target_tmr.c           |  850 ++++
 drivers/target/iscsi/iscsi_target_tmr.h           |   14 +
 drivers/target/iscsi/iscsi_target_tpg.c           |  760 ++++
 drivers/target/iscsi/iscsi_target_tpg.h           |   41 +
 drivers/target/iscsi/iscsi_target_tq.c            |  552 +++
 drivers/target/iscsi/iscsi_target_tq.h            |   89 +
 drivers/target/iscsi/iscsi_target_util.c          | 1868 ++++++++
 drivers/target/iscsi/iscsi_target_util.h          |   98 +
 drivers/target/target_core_configfs.c             |    4 -
 drivers/target/target_core_device.c               |   25 +-
 include/scsi/iscsi_proto.h                        |   68 +-
 50 files changed, 22866 insertions(+), 59 deletions(-)
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
1.7.5.1
