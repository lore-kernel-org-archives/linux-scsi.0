From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/6] target: Reenable buffered FILEIO + add iscsi-target MXDSL logic
Date: Sun, 30 Sep 2012 05:58:10 +0000
Message-ID: <1348984696-30992-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This following series is destined for v3.7-rc1 code, and re-adds support for
buffered FILEIO + emulate_write_cache=1 emulation removed in v3.5, as well as
fixing up a long standing issue wrt to MaxRecvDataSegmentLength handling within
iscsi-target code.

The latter bit is the bulk of the series that involves adding a proper
configurable MaxXmitDataSegmentLength TPG parameter configfs attr, and converts
iscsi-target login logic, incoming PDU payload checks, TMR TASK_REASSIGN ops, and
non contigious sequence+pdu operation to now honor MXDSL.

Open-iSCSI + Linux-iSCSI folks please review the MXDSL bits, and please let us
know if you have any concerns.

Thank you!

--nab

Nicholas Bellinger (6):
  target/file: Re-enable optional fd_buffered_io=1 operation
  iscsi-target: Add base MaxXmitDataSegmentLength code
  iscsi-target: Enable MaxXmitDataSegmentLength operation in login path
  iscsi-target: Convert incoming PDU payload checks to
    MaxXmitDataSegmentLength
  iscsi-target: Add MaxXmitDataSegmentLength connection recovery check
  iscsi-target: Change iscsi_target_seq_pdu_list.c to honor
    MaxXmitDataSegmentLength

 drivers/target/iscsi/iscsi_target.c              |   24 ++++----
 drivers/target/iscsi/iscsi_target_configfs.c     |    4 +
 drivers/target/iscsi/iscsi_target_core.h         |    2 +
 drivers/target/iscsi/iscsi_target_erl2.c         |    1 +
 drivers/target/iscsi/iscsi_target_nego.c         |    4 +-
 drivers/target/iscsi/iscsi_target_parameters.c   |   71 +++++++++++++++++++---
 drivers/target/iscsi/iscsi_target_parameters.h   |    7 ++-
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c |   61 ++++++++++---------
 drivers/target/iscsi/iscsi_target_tmr.c          |    9 +++-
 drivers/target/target_core_file.c                |   36 ++++++++++-
 drivers/target/target_core_file.h                |    1 +
 11 files changed, 162 insertions(+), 58 deletions(-)

-- 
1.7.2.5
