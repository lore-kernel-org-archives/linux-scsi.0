From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.16-rc3
Date: Sat, 28 Jun 2014 00:28:05 -0700
Message-ID: <1403940485.24355.31.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>target-devel <target-devel@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the target-pending fixes for v3.16-rc3.  Please go ahead and
pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

Mostly minor fixes this time around.  The highlights include:

  - iscsi-target CHAP authentication fixes to enforce explicit key values
    (Tejas Vaykole + rahul.rane)
  - Fix a long-standing OOPs in target-core when a alua configfs attribute
    is accessed after port symlink has been removed.  (Sebastian Herbszt)
  - Fix a v3.10.y iscsi-target regression causing the login reject status
    class/detail to be ignored (Christoph Vu-Brugier)
  - Fix a v3.10.y iscsi-target regression to avoid rejecting an existing ITT
    during Data-Out when data-direction is wrong (Santosh Kulkarni + Arshad Hussain)
  - Fix a iscsi-target related shutdown deadlock on UP kernels (Mikulas Patocka) 
  - Fix a v3.16-rc1 build issue with vhost-scsi + !CONFIG_NET (MST)

Thank you,

--nab

Michael S. Tsirkin (1):
  iovec: move memcpy_from/toiovecend to lib/iovec.c

Mikulas Patocka (1):
  iscsi-target: fix iscsit_del_np deadlock on unload

Nicholas Bellinger (6):
  iscsi-target: Convert chap_server_compute_md5 to use kstrtoul
  iscsi-target; Enforce 1024 byte maximum for CHAP_C key value
  target: Fix left-over se_lun->lun_sep pointer OOPs
  iscsi-target: Explicily clear login response PDU in exception path
  tcm_loop: Fix memory leak in tcm_loop_submission_work error path
  iscsi-target: Avoid rejecting incorrect ITT for Data-Out

 drivers/target/iscsi/iscsi_target.c       |    2 +-
 drivers/target/iscsi/iscsi_target_auth.c  |   14 ++++++--
 drivers/target/iscsi/iscsi_target_login.c |   13 +++----
 drivers/target/iscsi/iscsi_target_util.c  |    2 ++
 drivers/target/loopback/tcm_loop.c        |    1 +
 drivers/target/target_core_device.c       |    1 +
 include/linux/socket.h                    |    4 ---
 include/linux/uio.h                       |    5 ++-
 lib/iovec.c                               |   55 +++++++++++++++++++++++++++++
 net/core/iovec.c                          |   55 -----------------------------
 10 files changed, 82 insertions(+), 70 deletions(-)
