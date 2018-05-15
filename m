From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 0/2] Use sbitmap instead of percpu_ida
Date: Tue, 15 May 2018 09:00:41 -0700
Message-ID: <20180515160043.27044-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux1394-devel>,
 <mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
 <mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-usb@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, Juergen Gross <jgross@suse.com>, qla2xxx-upstream@qlogic.com, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

This is a pretty rough-and-ready conversion of the target drivers
from using percpu_ida to sbitmap.  It compiles; I don't have a target
setup, so it's completely untested.  I haven't tried to do anything
particularly clever here, so it's possible that, for example, the wait
queue in iscsi_target_util could be more clever, like the block layer
uses multiple wait queues to avoid pingpongs.  Or maybe we could figure
out a way to not store the CPU that the ID was allocated on, or perhaps
the options I specified to sbitmap_queue_init() are suboptimal.

Patch 2 isn't interesting; it just deletes the implementation.  Patch 1
will be where all the action is.

Matthew Wilcox (2):
  Convert target drivers to use sbitmap
  Remove percpu_ida

 drivers/scsi/qla2xxx/qla_target.c        |  16 +-
 drivers/target/iscsi/iscsi_target_util.c |  34 +-
 drivers/target/sbp/sbp_target.c          |   8 +-
 drivers/target/target_core_transport.c   |   5 +-
 drivers/target/tcm_fc/tfc_cmd.c          |  11 +-
 drivers/usb/gadget/function/f_tcm.c      |   8 +-
 drivers/vhost/scsi.c                     |   9 +-
 drivers/xen/xen-scsiback.c               |   8 +-
 include/linux/percpu_ida.h               |  83 -----
 include/target/iscsi/iscsi_target_core.h |   1 +
 include/target/target_core_base.h        |   5 +-
 lib/Makefile                             |   2 +-
 lib/percpu_ida.c                         | 391 -----------------------
 13 files changed, 74 insertions(+), 507 deletions(-)
 delete mode 100644 include/linux/percpu_ida.h
 delete mode 100644 lib/percpu_ida.c

-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
