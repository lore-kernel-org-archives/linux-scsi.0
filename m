From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 00/17] Create and use ida and idr helper routines [RESEND]
Date: Wed, 16 Sep 2015 10:50:18 -0700
Message-ID: <cover.1442263513.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, hare@suse.com, jthumshirn@suse.de, hch@infradead.org, Lee Duncan <lduncan@suse.com>, Kai.Makisara@kolumbus.fi, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Ulf Hansson <ulf.hansson@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, Samuel Ortiz <sameo@linux.intel.com>, Alex Dubov <oakad@yahoo.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Matthew Wilcox <willy@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

[Apologies if you see this twice. I had to resend it.]

The idr index management library supplies two sets of routines
for managing monotonically increasing index numbers. The "ida"
set of routines manage allocating and freeing simple index
numbers. The "idr" set of routines add the ability to save
an arbitrary pointer with each index.

Both sets of routines are used throughout the kernel, and it
was noted that many of them use the same or similar calling
sequences, making a helper function a useful addition.

This set of patches adds some helper functions, defined
as inline in <linux/idr.h>. In addition, any of the clients
of these idr library functions that could benefit from
using these helper functions where modified to use them.

In addition to cleaning up the code in the clients of these
functions, the SCSI hosts module, which used to use a simple
atomic integer for index management is converted to using
the idr set of routines to manage its index values as
well as to simplify and speed up host number to instance
lookups.

I have functionally tested the SCSI host indexing change,
and I have compile tested all of the other changes. The
maintainers of each driver are cc-ed on the patch series,
where available.

Note: I did not mark this patch series as "v2" since
the scope of the patch set has grown considerably
since my first submissions.

Summary: There is one patch that adds helper functions, 11
patches that use the new "idr" helper functions, and 5 that
use the new "ida" helper functions.

Lee Duncan (17):
   1. Add ida and idr helper routines.
   2. Update scsi hosts to use idr for host number mgmt
   3. Update the st driver to use idr helper functions.
   4. Update the ch driver to use idr helper functions.
   5. Update the md driver to use idr helper functions.
   6. Update the infiniband uverbs driver to use idr helper functions.
   7. Update the memstick driver to use idr helper functions.
   8. Update the mmc driver to use idr helper functions.
   9. Update the virtgpu driver to use idr helper functions.
  10. Update the DCA DMA driver to use idr helper functions.
  11. Update the rtsx multifunction driver to use idr helper functions.
  12. Update the TI Flash Media driver to use idr helper functions.
  13. Update the SCSI disk driver to use ida helper functions.
  14. Update the rsxx flash adapter driver to use ida helper functions.
  15. Update the NVMe SSD driver to use ida helper functions.
  16. Update the Micron PCIe SSD driver to use ida helper functions.
  17. Update the ARM soc base driver to use ida helper functions.

 drivers/base/soc.c                   |  17 ++----
 drivers/block/mtip32xx/mtip32xx.c    |  22 ++------
 drivers/block/nvme-core.c            |  14 +----
 drivers/block/rsxx/core.c            |  16 +-----
 drivers/dca/dca-sysfs.c              |  19 ++-----
 drivers/gpu/drm/virtio/virtgpu_vq.c  |  15 ++----
 drivers/infiniband/core/uverbs_cmd.c |  12 +----
 drivers/md/dm.c                      |  22 ++------
 drivers/memstick/core/memstick.c     |  19 ++-----
 drivers/mfd/rtsx_pcr.c               |  13 ++---
 drivers/misc/tifm_core.c             |  17 ++----
 drivers/mmc/core/host.c              |  14 ++---
 drivers/scsi/ch.c                    |  14 ++---
 drivers/scsi/hosts.c                 |  59 ++++++++++----------
 drivers/scsi/sd.c                    |  20 ++-----
 drivers/scsi/st.c                    |  15 ++----
 include/linux/idr.h                  | 102 +++++++++++++++++++++++++++++++++++
 17 files changed, 182 insertions(+), 228 deletions(-)

-- 
2.1.4
