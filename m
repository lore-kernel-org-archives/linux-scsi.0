From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 0/3] Use sbitmap instead of percpu_ida
Date: Tue, 12 Jun 2018 12:05:42 -0700
Message-ID: <20180612190545.10781-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-usb@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, Juergen Gross <jgross@suse.com>, qla2xxx-upstream@qlogic.com, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <willy@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Removing the percpu_ida code nets over 400 lines of removal.  It's not
as spectacular as deleting an entire architecture, but it's still a
worthy reduction in lines of code.

Untested due to lack of hardware and not understanding how to set up a
target platform.

Changes from v1:
 - Fixed bugs pointed out by Jens in iscsit_wait_for_tag()
 - Abstracted out tag freeing as requested by Bart
 - Made iscsit_wait_for_tag static as pointed out by 0day

Matthew Wilcox (3):
  target: Abstract tag freeing
  Convert target drivers to use sbitmap
  Remove percpu_ida

 drivers/scsi/qla2xxx/qla_target.c        |  14 +-
 drivers/target/iscsi/iscsi_target_util.c |  35 ++-
 drivers/target/sbp/sbp_target.c          |   7 +-
 drivers/target/target_core_transport.c   |   5 +-
 drivers/target/tcm_fc/tfc_cmd.c          |  10 +-
 drivers/usb/gadget/function/f_tcm.c      |   7 +-
 drivers/vhost/scsi.c                     |   8 +-
 drivers/xen/xen-scsiback.c               |   9 +-
 include/linux/percpu_ida.h               |  83 -----
 include/target/iscsi/iscsi_target_core.h |   1 +
 include/target/target_core_base.h        |  10 +-
 lib/Makefile                             |   2 +-
 lib/percpu_ida.c                         | 370 -----------------------
 13 files changed, 73 insertions(+), 488 deletions(-)
 delete mode 100644 include/linux/percpu_ida.h
 delete mode 100644 lib/percpu_ida.c

-- 
2.17.1
