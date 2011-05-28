From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] iscsi-target: Merge for .40-rc1
Date: Fri, 27 May 2011 19:59:52 -0700
Message-ID: <1306551592.23461.506.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33362 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab1E1DIL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 May 2011 23:08:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Andy Grover <agrover@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hi Linus,

This is a GIT PULL request for the initial merge of the iscsi-target
fabric driver for mainline target core v4.0 infrastructure.

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-40-iscsi-target

This series has been made against the following linux-2.6.git HEAD:

commit dc7acbb2518f250050179c8581a972df3b6a24f1
Merge: f01e1af 4bf0ff2
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu May 26 19:01:15 2011 -0700

    Merge branch 'upstream/tidy-xen-mmu-2.6.39' of git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen

This code has undergone a number of review cycles on linux-scsi over the
last six months by Christoph, Mike and other interested folks.  This has
included a number of cleanups to follow mainline conventions, and
conversion to use mainline include/scsi/iscsi_proto.h RFC definitions.
There has been an good amount of testing feedback on this code so far,
and with the LIO communities help we have been able to resolve the
reported cleanup/conversion regressions, and fix one long-standing
shutdown bug.

Unfortuately James and I have been unable to come to an aggreement on
implementation details wrt to proper kernel/user split ahead of his
final SCSI pull for .40.  I have no interest to take the mainline
iscsi-target development effort in this direction again, so I am
offically committing to you to support iscsi-target in good-faith
together with rtslib community edition moving forward.  I am also
committing to extending iscsi-target to address the non-standard
authentication pieces that James has mentioned, but by the time .40
ships we are still not going to have iSCSI clients that actually support
them.

I believe that Christoph is happy with the current iscsi-target code for
an initial merge now, and am asking for the merge to avoid slipping
(again) for this type of 'mass-market' code that has a large audience,
and poses minimal risk considering the small amount of external changes.

Finally, please note for convience this branch contains the six .40
target core patches in James's most recent SCSI PULL request that need
to be merged ahead of iscsi-target.  There where posted here:

[PATCH 0/6] target: .40 bugfixes+changes (round 1)
http://marc.info/?l=linux-kernel&m=130586157027018&w=2

Please considering merging for .40-rc1, and please let me know if you
have any questions.

Thank you,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  iscsi: Resolve iscsi_proto.h naming conflicts with
    drivers/target/iscsi
  iscsi: Add Serial Number Arithmetic LT and GT into iscsi_proto.h
  iscsi-target: Add iSCSI fabric support for target v4

 drivers/infiniband/ulp/iser/iser_initiator.c      |    2 +-
 drivers/scsi/be2iscsi/be_main.h                   |    4 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                    |    8 +-
 drivers/scsi/libiscsi.c                           |   22 +-
 drivers/target/Kconfig                            |    1 +
 drivers/target/Makefile                           |    1 +
 drivers/target/iscsi/Kconfig                      |   18 +
 drivers/target/iscsi/Makefile                     |   20 +
 drivers/target/iscsi/iscsi_target.c               | 4963 +++++++++++++++++++++
 drivers/target/iscsi/iscsi_target.h               |   42 +
 drivers/target/iscsi/iscsi_target_auth.c          |  496 ++
 drivers/target/iscsi/iscsi_target_auth.h          |   31 +
 drivers/target/iscsi/iscsi_target_configfs.c      | 1925 ++++++++
 drivers/target/iscsi/iscsi_target_configfs.h      |    7 +
 drivers/target/iscsi/iscsi_target_core.h          |  860 ++++
 drivers/target/iscsi/iscsi_target_datain_values.c |  532 +++
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
 drivers/target/iscsi/iscsi_target_tq.h            |   88 +
 drivers/target/iscsi/iscsi_target_util.c          | 1868 ++++++++
 drivers/target/iscsi/iscsi_target_util.h          |   98 +
 include/scsi/iscsi_proto.h                        |   68 +-
 47 files changed, 22860 insertions(+), 34 deletions(-)
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


