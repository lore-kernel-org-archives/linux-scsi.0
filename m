From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v3.9-rc1 (round two)
Date: Sat, 02 Mar 2013 10:48:13 -0800
Message-ID: <1362250094.10892.362.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Asias He <asias@redhat.com>, Benjamin ESTRABAUD <be@mpstor.com>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the remaining target-pending patches for v3.9-rc1.  Please go
ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

The most important one here is the immediate queue starvation regression
fix for iscsi-target, which addresses a bug that's effecting v3.5+
kernels under heavy sustained READ only workloads.  Thanks alot to
Benjamin Estrabaud for helping to track this down!

Also included is a pSCSI exception bugfix from Asias, along with a
handful of other minor changes.  Both bugfixes are CC'ed to stable.

Thank you,

--nab

Asias He (4):
  target: Add __exit annotation for module_exit functions
  target/pscsi: Drop unnecessary NULL assignment to bio->bi_next
  target/pscsi: Fix page increment
  target/pscsi: Rename sg_num to nr_vecs in pscsi_get_bio()

Nicholas Bellinger (1):
  iscsi-target: Fix immediate queue starvation regression with DATAIN

 drivers/target/iscsi/iscsi_target.c |   11 +++++++++--
 drivers/target/sbp/sbp_target.c     |    2 +-
 drivers/target/target_core_file.c   |    2 +-
 drivers/target/target_core_iblock.c |    2 +-
 drivers/target/target_core_pscsi.c  |    9 +++------
 5 files changed, 15 insertions(+), 11 deletions(-)
