From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v4.11-rc7
Date: Tue, 11 Apr 2017 21:47:41 -0700
Message-ID: <1491972461.8231.114.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the outstanding target-pending bug-fixes for v4.11-rc7.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

There has been work in a number of different areas over the last weeks,
including:

  - Fix target-core-user (TCMU) back-end bi-directional handling
    (Xiubo Li + Mike Christie + Ilias Tsitsimpis)
  - Fix iscsi-target TMR reference leak during session shutdown
    (Rob Millner + Chu Yuan Lin)
  - Fix target_core_fabric_configfs.c race between LUN shutdown +
    mapped LUN creation (James Shen)
  - Fix target-core unknown fabric callback queue-full errors
    (Potnuri Bharat Teja)
  - Fix iscsi-target + iser-target queue-full handling in order
    to support iw_cxgb4 RNICs. (Potnuri Bharat Teja + Sagi Grimberg)
  - Fix ALUA transition state race between multiple initiator
    (Mike Christie)
  - Drop work-around for legacy GlobalSAN initiator, to allow
    QLogic 57840S + 579xx offload HBAs to work out-of-the-box
    in MSFT environments. (Martin Svec + Arun Easi)

Note that a number are CC'ed for stable, and although the queue-full
bug-fixes required for iser-target to work with iw_cxgb4 aren't CC'ed
here, they'll be posted to Greg-KH separately.

Thank you,

--nab

Manish Narani (1):
  usb: gadget: Correct usb EP argument for BOT status request

Mike Christie (1):
  target: Fix ALUA transition state race between multiple initiators

Nicholas Bellinger (7):
  tcmu: Allow cmd_time_out to be set to zero (disabled)
  iscsi-target: Fix TMR reference leak during session shutdown
  target: Avoid mappedlun symlink creation during lun shutdown
  target: Fix unknown fabric callback queue-full errors
  iscsi-target: Propigate queue_data_in + queue_status errors
  iser-target: Fix queue-full response handling
  iscsi-target: Drop work-around for legacy GlobalSAN initiator

Sagi Grimberg (1):
  iser-target: avoid posting a recv buffer twice

Xiubo Li (3):
  tcmu: Fix possible overwrite of t_data_sg's last iov[]
  tcmu: Fix wrongly calculating of the base_command_size
  tcmu: Skip Data-Out blocks before gathering Data-In buffer for BIDI
    case

 drivers/infiniband/ulp/isert/ib_isert.c        |  65 ++++++++----
 drivers/infiniband/ulp/isert/ib_isert.h        |   3 +-
 drivers/target/iscsi/iscsi_target.c            |   3 +-
 drivers/target/iscsi/iscsi_target_configfs.c   |  13 +--
 drivers/target/iscsi/iscsi_target_parameters.c |  16 ---
 drivers/target/iscsi/iscsi_target_util.c       |  17 ++--
 drivers/target/iscsi/iscsi_target_util.h       |   2 +-
 drivers/target/target_core_alua.c              | 136 +++++++++----------------
 drivers/target/target_core_configfs.c          |   2 +-
 drivers/target/target_core_fabric_configfs.c   |   5 +
 drivers/target/target_core_tpg.c               |   4 +
 drivers/target/target_core_transport.c         | 102 ++++++++++++-------
 drivers/target/target_core_user.c              |  97 ++++++++++++------
 drivers/usb/gadget/function/f_tcm.c            |   2 +-
 include/target/target_core_base.h              |  10 +-
 15 files changed, 261 insertions(+), 216 deletions(-)
