From: Juergen Gross <jgross@suse.com>
Subject: [PATCH V6 0/5] Add XEN pvSCSI support
Date: Thu, 28 Aug 2014 06:44:08 +0200
Message-ID: <1409201053-6223-1-git-send-email-jgross@suse.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com, nab@linux-iscsi.org, konrad.wilk@oracle.com
Cc: Juergen Gross <jgross@suse.com>
List-Id: linux-scsi@vger.kernel.org

This series adds XEN pvSCSI support. With pvSCSI it is possible to use physical
SCSI devices from a XEN domain.

The support consists of a backend in the privileged Domain-0 doing the real
I/O and a frontend in the unprivileged domU passing I/O-requests to the backend.

The code is taken (and adapted) from the original pvSCSI implementation done
for Linux 2.6 in 2008 by Fujitsu.

Changes in V6:
- changes in scsifront module after comments from Konrad Wilk
- remove double kfree in scsiback
- comments in vscsiif.h adapted after comments from Jan Beulich and
  David Vrabel in xen-devel
- added linux-scsi@vger.kernel.org to MAINTANERS entry

Changes in V5:
- Added patch to support threaded irqs for interdomain event channels
- several changes in xen-scsifront after comments from Christoph Hellwig
- several changes in xen-scsiback after comments from Christoph Hellwig
- several changes in xen-scsiback after comments from James Bottomley
- several changes in xen-scsiback after comments from Nicholas Bellinger

Changes in V4:
- Re-add define for VSCSIIF_ACT_SCSI_SG_PRESET to vscsiif.h to indicate this
  action value should not be used in future enhancements

Changes in V3:
- added some comments to the protocol header file
- removed the CDB emulation from xen-scsiback, handled by core target
  infrastructure
- several changes in xen-scsifront after comments from Christoph Hellwig

Changes in V2:
- use core target infrastructure by backend instead of pure SCSI passthrough
- add support for larger SG lists by putting them in grant page(s)
- add command abort capability


Juergen Gross (5):
  xen/events: support threaded irqs for interdomain event channels
  Add XEN pvSCSI protocol description
  Introduce xen-scsifront module
  Introduce XEN scsiback module
  add xen pvscsi maintainer

 MAINTAINERS                        |    9 +
 drivers/scsi/Kconfig               |    9 +
 drivers/scsi/Makefile              |    1 +
 drivers/scsi/xen-scsifront.c       | 1024 +++++++++++++++++
 drivers/xen/Kconfig                |    9 +
 drivers/xen/Makefile               |    1 +
 drivers/xen/events/events_base.c   |    5 +-
 drivers/xen/xen-scsiback.c         | 2124 ++++++++++++++++++++++++++++++++++++
 include/xen/events.h               |    2 +
 include/xen/interface/io/vscsiif.h |  229 ++++
 10 files changed, 3411 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/xen-scsifront.c
 create mode 100644 drivers/xen/xen-scsiback.c
 create mode 100644 include/xen/interface/io/vscsiif.h

-- 
1.8.4.5
