From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v4.13-rc5
Date: Sat, 12 Aug 2017 11:58:47 -0700
Message-ID: <1502564327.24637.9.camel@haakon3.daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the target-pending fixes for v4.13-rc5.  Please go ahead and
pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

The highlights include:

- Fix iscsi-target payload memory leak during ISCSI_FLAG_TEXT_CONTINUE
  (Varun Prakash)
- Fix tcm_qla2xxx incorrect use of tcm_qla2xxx_free_cmd during ABORT
  (Pascal de Bruijn + Himanshu Madhani + nab)
- Fix iscsi-target long-standing issue with parallel delete of a single
  network portal across multiple target instances (Gary Guo + nab)
- Fix target dynamic se_node GPF during uncached shutdown regression
  (Justin Maggard + nab)

Thank you,

--nab

Bryant G. Ly (1):
  tcmu: free old string on reconfig

Nicholas Bellinger (3):
  qla2xxx: Fix incorrect tcm_qla2xxx_free_cmd use during TMR ABORT (v2)
  iscsi-target: Fix iscsi_np reset hung task during parallel delete
  target: Fix node_acl demo-mode + uncached dynamic shutdown regression

Varun Prakash (4):
  cxgbit: add missing __kfree_skb()
  iscsi-target: fix memory leak in iscsit_setup_text_cmd()
  iscsi-target: fix invalid flags in text response
  cxgbit: fix sg_nents calculation

Xiubo Li (1):
  tcmu: Fix possible to/from address overflow when doing the memcpy

 drivers/scsi/qla2xxx/tcm_qla2xxx.c          | 30 -----------------------------
 drivers/target/iscsi/cxgbit/cxgbit_cm.c     | 16 +++++++++++----
 drivers/target/iscsi/cxgbit/cxgbit_target.c | 12 +++++++-----
 drivers/target/iscsi/iscsi_target.c         |  6 ++++--
 drivers/target/iscsi/iscsi_target_login.c   |  7 +++++--
 drivers/target/target_core_tpg.c            |  4 ++--
 drivers/target/target_core_transport.c      |  4 ++--
 drivers/target/target_core_user.c           | 13 +++++++------
 include/target/iscsi/iscsi_target_core.h    |  1 +
 9 files changed, 40 insertions(+), 53 deletions(-)
