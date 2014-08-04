From: jgross@suse.com
Subject: [PATCH V3 0/4] Add XEN pvSCSI support
Date: Mon,  4 Aug 2014 10:27:46 +0200
Message-ID: <1407140870-542-1-git-send-email-jgross@suse.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, JBottomley@parallels.com, konrad.wilk@oracle.com, hch@infradead.org, david.vrabel@citrix.com
List-Id: linux-scsi@vger.kernel.org

This series adds XEN pvSCSI support. With pvSCSI it is possible to use physical
SCSI devices from a XEN domain.

The support consists of a backend in the privileged Domain-0 doing the real
I/O and a frontend in the unprivileged domU passing I/O-requests to the backend.

The code is taken (and adapted) from the original pvSCSI implementation done
for Linux 2.6 in 2008 by Fujitsu.

[PATCH V2 1/4] Add XEN pvSCSI protocol description
[PATCH V2 2/4] Introduce xen-scsifront module
[PATCH V2 3/4] Introduce XEN scsiback module
[PATCH V2 4/4] add xen pvscsi maintainer

Changes in V3:
- added some comments to the protocol header file
- removed the CDB emulation from xen-scsiback, handled by core target
  infrastructure
- several changes in xen-scsifront after comments from Christoph Hellwig

Changes in V2:
- use core target infrastructure by backend instead of pure SCSI passthrough
- add support for larger SG lists by putting them in grant page(s)
- add command abort capability
