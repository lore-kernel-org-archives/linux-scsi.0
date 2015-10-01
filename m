From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 0/5] Modify ida_* users to use ida_simple_*
Date: Thu,  1 Oct 2015 11:59:04 -0700
Message-ID: <cover.1443723136.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Lee Duncan <lduncan@suse.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

The ida index management routines are used in several
driver modules to manage allocation and release of
index values. Reviewing the way in which the
ida routines were called, together with the small
number of such clients, led to the belief that
these users should all be able to share a simple
built-in lock in the ida module by calling the
ida_simple_*() functions instead of the non-simple
versions. This means that ida does all the
required locking so that clients don't have to
manage that.

This will greatly simplify the client calling code,
and if there is any problem with these clients
sharing a "simple" lock, the ida code can be
transparently expanded to allocate a lock per client,
without having to change any of the clients again.

NOTE: this patch series replaces an earlier attempt
to create a new set of ida helper functions titled:

  "Create and use ida and idr helper routines"

Another set will soon be sent out soon to (1) add idr
helper functions, (2) modify clients to use them,
and (3) update SCSI host_no to use them.

Lee Duncan (5):
  SCSI: sd: simplify ida usage
  block: rsxx: core: simplify ida usage
  block: nvme-core: simplify ida usage
  block: mtip32xx: simplify ida usage
  base: soc: siplify ida usage

 drivers/base/soc.c                | 21 +++++----------------
 drivers/block/mtip32xx/mtip32xx.c | 26 ++++++--------------------
 drivers/block/nvme-core.c         | 16 ++++------------
 drivers/block/rsxx/core.c         | 20 ++++----------------
 drivers/scsi/sd.c                 | 22 +++++-----------------
 5 files changed, 24 insertions(+), 81 deletions(-)

-- 
2.1.4
