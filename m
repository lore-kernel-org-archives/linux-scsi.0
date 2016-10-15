From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] target: Bug-fixes for v4.9-rc1
Date: Sat, 15 Oct 2016 05:34:29 +0000
Message-ID: <1476509672-27182-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Vaibhav Tandon <vst@datera.io>, Dinesh Israni <ddi@datera.io>, Nixon Vincent <nixon.vincent@calsoftinc.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

Here are three outstanding target bug-fixes encountered during
failure and longevity testing with v4.1.y code.

The patch #1 is a v4.1+ regression where the missing upstream
assignment of SCF_ACK_KREF results in se_cmd->cmd_kref leakage
during TMR ABORT_TASK + LUN_RESET with concurrent session
reinstatement. v4.0 and earlier code is not effected.

The latter two address long-standing EXTENDED_COPY status bugs,
that can result in ESX hosts failing VAAI BlockCopy operations.

Patch #2 adds COPY TARGET DEVICE NOT REACHABLE during 0xe4
target descriptor NAA IEEE 0x83 /sys/kernel/config/target/core/
device lookup failure, in order to signal local copy fallback
to host.

Patch #3 propigates up correct local copy I/O SCSI status
(eg: RESERVATION_CONFLICT) to host.

Please review.

--nab

Dinesh Israni (1):
  target: Don't override EXTENDED_COPY xcopy_pt_cmd SCSI status code

Nicholas Bellinger (2):
  target: Re-add missing SCF_ACK_KREF assignment in v4.1.y
  target: Make EXTENDED_COPY 0xe4 failure return COPY TARGET DEVICE NOT
    REACHABLE

 drivers/target/target_core_transport.c | 11 ++++++++++-
 drivers/target/target_core_xcopy.c     | 34 ++++++++++++++++++++++++++--------
 include/target/target_core_base.h      |  1 +
 3 files changed, 37 insertions(+), 9 deletions(-)

-- 
1.9.1
