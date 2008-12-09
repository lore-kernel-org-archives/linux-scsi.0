From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/3] Open-FCoE Submission (round 2)
Date: Tue, 09 Dec 2008 15:10:06 -0800
Message-ID: <20081209231005.17830.92133.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18403 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890AbYLIXKH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Dec 2008 18:10:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: jgarzik@redhat.com, davem@davemloft.net, james.smart@emulex.com, michaelc@cs.wisc.edu, jeykholt@cisco.com, andi@firstfloor.org, jeffrey.t.kirsher@intel.com, robert.w.love@intel.com

The following series adds the following code to the SCSI subsystem.

1) FC and FCoE protocol definitions in header files
        - Files are added in include/scsi/fc/
        - New files are: fc_els.h, fc_encaps.h, fc_fc2.h,
          fc_fcp.h, fc_fs.h, fc_gs.h and fc_ns.h

2) libfc - a FC assist library
        - Composed of 5 sub-components: Exchange Manager, Local Port
          Remote Port, Discovery and SCSI-FCP
        - Uses libfc_function_template for cross-layer calls
        - Uses struct fc_lport as primary object shared by all
	  sub-modules
        - Common code defined in include/scsi/libfc.h

3) fcoe - a FCoE initiator implementation
        - Simple encapsulation and unpacking layer
        - Interacts with netdev
	- Initial support for FCoE offload
        - Uses /sys/module/fcoe/parameters/create and destroy for
          enabling/disabling FCoE connection over a particular Ethernet
          adapter
        - Works on any Ethernet adapter

These patches apply to both the scsi-misc and scsi-rc-fixes trees.

I beleive that we've addressed each of Andi's comments. The largest being
a security review where we mostly focused on input validation from the wire
as well as removing BUG_ON and WARN_ON statements that could be initiated
from an external entity. For a detailed list of recent activity please view
our git log on Open-FCoE. Here is a link to our gitweb site:

http://www.open-fcoe.org/openfc/gitweb/?p=openfc/open-fcoe-initiator.git;a=summary

We did not break the patch-set down any further as it would not be bisect-able.
Our libfc blocks are organized by file, so using splitdiff or diffsplit anyone
should be able to break these patches down into smaller, more review friendly
chunks.

Locking comments are mostly in comment blocks at the tops of some files. The
largest comment block is in drivers/scsi/libfc/fc_lport.c and would be a good
starting point when reviewing the locking.

---

Robert Love (3):
      fcoe: Fibre Channel over Ethernet
      libfc: A modular Fibre Channel library
      FC protocol definition header files


 drivers/scsi/Kconfig                  |   13 
 drivers/scsi/Makefile                 |    2 
 drivers/scsi/fcoe/Makefile            |    8 
 drivers/scsi/fcoe/fc_transport_fcoe.c |  446 +++++++
 drivers/scsi/fcoe/fcoe_sw.c           |  494 ++++++++
 drivers/scsi/fcoe/libfcoe.c           | 1510 +++++++++++++++++++++++
 drivers/scsi/libfc/Makefile           |   12 
 drivers/scsi/libfc/fc_disc.c          |  845 +++++++++++++
 drivers/scsi/libfc/fc_elsct.c         |   71 +
 drivers/scsi/libfc/fc_exch.c          | 1970 +++++++++++++++++++++++++++++++
 drivers/scsi/libfc/fc_fcp.c           | 2130 +++++++++++++++++++++++++++++++++
 drivers/scsi/libfc/fc_frame.c         |   89 +
 drivers/scsi/libfc/fc_lport.c         | 1604 +++++++++++++++++++++++++
 drivers/scsi/libfc/fc_rport.c         | 1291 ++++++++++++++++++++
 include/scsi/fc/fc_els.h              |  816 +++++++++++++
 include/scsi/fc/fc_encaps.h           |  138 ++
 include/scsi/fc/fc_fc2.h              |  124 ++
 include/scsi/fc/fc_fcoe.h             |  114 ++
 include/scsi/fc/fc_fcp.h              |  199 +++
 include/scsi/fc/fc_fs.h               |  340 +++++
 include/scsi/fc/fc_gs.h               |   93 +
 include/scsi/fc/fc_ns.h               |  159 ++
 include/scsi/fc_encode.h              |  309 +++++
 include/scsi/fc_frame.h               |  242 ++++
 include/scsi/fc_transport_fcoe.h      |   54 +
 include/scsi/libfc.h                  |  938 +++++++++++++++
 include/scsi/libfcoe.h                |  176 +++
 27 files changed, 14187 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/fcoe/Makefile
 create mode 100644 drivers/scsi/fcoe/fc_transport_fcoe.c
 create mode 100644 drivers/scsi/fcoe/fcoe_sw.c
 create mode 100644 drivers/scsi/fcoe/libfcoe.c
 create mode 100644 drivers/scsi/libfc/Makefile
 create mode 100644 drivers/scsi/libfc/fc_disc.c
 create mode 100644 drivers/scsi/libfc/fc_elsct.c
 create mode 100644 drivers/scsi/libfc/fc_exch.c
 create mode 100644 drivers/scsi/libfc/fc_fcp.c
 create mode 100644 drivers/scsi/libfc/fc_frame.c
 create mode 100644 drivers/scsi/libfc/fc_lport.c
 create mode 100644 drivers/scsi/libfc/fc_rport.c
 create mode 100644 include/scsi/fc/fc_els.h
 create mode 100644 include/scsi/fc/fc_encaps.h
 create mode 100644 include/scsi/fc/fc_fc2.h
 create mode 100644 include/scsi/fc/fc_fcoe.h
 create mode 100644 include/scsi/fc/fc_fcp.h
 create mode 100644 include/scsi/fc/fc_fs.h
 create mode 100644 include/scsi/fc/fc_gs.h
 create mode 100644 include/scsi/fc/fc_ns.h
 create mode 100644 include/scsi/fc_encode.h
 create mode 100644 include/scsi/fc_frame.h
 create mode 100644 include/scsi/fc_transport_fcoe.h
 create mode 100644 include/scsi/libfc.h
 create mode 100644 include/scsi/libfcoe.h

-- 
//Rob
