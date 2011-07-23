From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] iscsi-target merge for v3.1-rc1
Date: Sat, 23 Jul 2011 16:16:15 -0700
Message-ID: <1311462975.31450.356.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Boaz Harrosh <openosd@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

So in the spirit of timely pull requests ahead of your upcoming summer
vacation, here is the long awaited and much debated initial merge commit
for v3.1-rc1 of drivers/target/iscsi to sync with latest bleeding edge
LIO v4.1 codebase.

As with the v3.0 merge canidate this spring, this commit contains a
fully functional in-kernel iscsi-target that uses the mainline target
infrastructure for a native configfs control plane, and is compatiable
with rtslib v2.x python object library.

Please go ahead and pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/nab/target-pending.git for-linus-merge

This tree is also available from kernel.org mirrors at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-linus-merge

I'll be tracking fixes from the merge canidate posted this morning, and
considering the amount of changes from Andy and Christoph over the last
months, this code will certainly require alot more testing throughout
the duration of v3.1 development cycle to get all the bugs shaken out.

Again, I would like to thank Andy and Christoph for pushing forward v4.1
development.  Also big thanks to all the folks over the numerous
releases who have helped to review and make incremental improvements to
the codebase, all those folks who reported bugs and in some cases, drove
the efforts to rentlessly to verify the proper fixes.

Please let us know if you have any immediate concerns,

Thank you!

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andy Grover <agrover@redhat.com>
Acked-by: Roland Dreier <roland@kernel.org>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  iscsi: Resolve iscsi_proto.h naming conflicts with
    drivers/target/iscsi
  iscsi: Add Serial Number Arithmetic LT and GT into iscsi_proto.h
  iscsi-target: Add iSCSI fabric support for target v4.1

 drivers/infiniband/ulp/iser/iser_initiator.c      |    2 +-
 drivers/scsi/be2iscsi/be_main.h                   |    4 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                    |    8 +-
 drivers/scsi/libiscsi.c                           |   22 +-
 drivers/target/Kconfig                            |    1 +
 drivers/target/Makefile                           |    2 +-
 drivers/target/iscsi/Kconfig                      |    8 +
 drivers/target/iscsi/Makefile                     |   20 +
 drivers/target/iscsi/iscsi_target.c               | 4559 +++++++++++++++++++++
 drivers/target/iscsi/iscsi_target.h               |   42 +
 drivers/target/iscsi/iscsi_target_auth.c          |  490 +++
 drivers/target/iscsi/iscsi_target_auth.h          |   31 +
 drivers/target/iscsi/iscsi_target_configfs.c      | 1882 +++++++++
 drivers/target/iscsi/iscsi_target_configfs.h      |    7 +
 drivers/target/iscsi/iscsi_target_core.h          |  859 ++++
 drivers/target/iscsi/iscsi_target_datain_values.c |  531 +++
 drivers/target/iscsi/iscsi_target_datain_values.h |   12 +
 drivers/target/iscsi/iscsi_target_device.c        |   87 +
 drivers/target/iscsi/iscsi_target_device.h        |    9 +
 drivers/target/iscsi/iscsi_target_erl0.c          | 1004 +++++
 drivers/target/iscsi/iscsi_target_erl0.h          |   15 +
 drivers/target/iscsi/iscsi_target_erl1.c          | 1299 ++++++
 drivers/target/iscsi/iscsi_target_erl1.h          |   26 +
 drivers/target/iscsi/iscsi_target_erl2.c          |  474 +++
 drivers/target/iscsi/iscsi_target_erl2.h          |   18 +
 drivers/target/iscsi/iscsi_target_login.c         | 1232 ++++++
 drivers/target/iscsi/iscsi_target_login.h         |   12 +
 drivers/target/iscsi/iscsi_target_nego.c          | 1067 +++++
 drivers/target/iscsi/iscsi_target_nego.h          |   17 +
 drivers/target/iscsi/iscsi_target_nodeattrib.c    |  263 ++
 drivers/target/iscsi/iscsi_target_nodeattrib.h    |   14 +
 drivers/target/iscsi/iscsi_target_parameters.c    | 1905 +++++++++
 drivers/target/iscsi/iscsi_target_parameters.h    |  269 ++
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  |  664 +++
 drivers/target/iscsi/iscsi_target_seq_pdu_list.h  |   86 +
 drivers/target/iscsi/iscsi_target_stat.c          |  950 +++++
 drivers/target/iscsi/iscsi_target_stat.h          |   64 +
 drivers/target/iscsi/iscsi_target_tmr.c           |  849 ++++
 drivers/target/iscsi/iscsi_target_tmr.h           |   14 +
 drivers/target/iscsi/iscsi_target_tpg.c           |  759 ++++
 drivers/target/iscsi/iscsi_target_tpg.h           |   41 +
 drivers/target/iscsi/iscsi_target_tq.c            |  551 +++
 drivers/target/iscsi/iscsi_target_tq.h            |   88 +
 drivers/target/iscsi/iscsi_target_util.c          | 1819 ++++++++
 drivers/target/iscsi/iscsi_target_util.h          |   60 +
 include/scsi/iscsi_proto.h                        |   60 +-
 46 files changed, 22161 insertions(+), 35 deletions(-)
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
