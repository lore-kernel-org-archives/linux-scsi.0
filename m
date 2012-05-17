From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target urgent updates for v3.4-final
Date: Thu, 17 May 2012 13:12:00 -0700
Message-ID: <1337285520.32217.269.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bernhard Kohl <bernhard.kohl@nsn.com>, Christoph Hellwig <hch@lst.de>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are two more target-core urgent updates for v3.4-final.  Please go
ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git 3.4-urgent

The first patch addresses a SPC-2 reservations RELEASE bug in a special
(iscsi specific) multi-ISID setup case that was allowing the same
initiator to be able to incorrect release it's own reservation on a
different SCSI path with enforce_pr_isid=1 operation.  This bug was
caught by Bernhard Kohl.

The second patch is to address a bug with FILEIO backends where the
incorrect number of blocks for READ_CAPACITY was being reported after an
underlying device-mapper block_device size change.  This patch uses now
i_size_read() in fd_get_blocks() for FILEIO backends with an underlying
block_device, instead of trying to determine this value at setup time
during fd_create_virtdevice(). (hch CC'ed)

Both are CC'ed to stable.

Thank you,

--nab

Bernhard Kohl (1):
  target: Fix SPC-2 RELEASE bug for multi-session iSCSI client setups

Nicholas Bellinger (1):
  target: Fix bug in handling of FILEIO + block_device resize ops

 drivers/target/target_core_file.c |   22 ++++++++++++++++------
 drivers/target/target_core_pr.c   |    3 +++
 2 files changed, 19 insertions(+), 6 deletions(-)
