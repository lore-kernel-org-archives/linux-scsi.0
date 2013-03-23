From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.9-rc4
Date: Sat, 23 Mar 2013 16:50:18 -0700
Message-ID: <1364082618.30339.312.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Asias He <asias@redhat.com>, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Linus!

Here is the current set of target-pending/master fixes for v3.9-rc4.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

These are mostly minor fixes this time around.  The iscsi-target CHAP
big-endian bugfix and bump FD_MAX_SECTORS=2048 default patch to allow
1MB sized I/Os for FILEIO backends on >= v3.5 code are both CC'ed to
stable.

Also, there is a persistent reservations regression that has recently
been reported for >= v3.8.x code, that is currently being tracked down
for v3.9.

Thank you,

--nab

Andy Grover (1):
  target/iscsi: Fix mutual CHAP auth on big-endian arches

Asias He (3):
  tcm_vhost: Add missed lock in vhost_scsi_clear_endpoint()
  tcm_vhost: Flush vhost_work in vhost_scsi_flush()
  target/pscsi: Reject cross page boundary case in pscsi_map_sg

Hannes Reinecke (1):
  target_core_sbc: use noop for SYNCHRONIZE_CACHE

Nicholas Bellinger (1):
  target/file: Bump FD_MAX_SECTORS to 2048 to handle 1M sized I/Os

Wei Yongjun (1):
  target: fix possible memory leak in core_tpg_register()

 drivers/target/iscsi/iscsi_target_auth.c |    5 ++++-
 drivers/target/target_core_file.h        |    2 +-
 drivers/target/target_core_pscsi.c       |   11 ++++++++---
 drivers/target/target_core_sbc.c         |    7 +++++--
 drivers/target/target_core_tpg.c         |    3 ++-
 drivers/vhost/tcm_vhost.c                |   13 +++++++++----
 6 files changed, 29 insertions(+), 12 deletions(-)
