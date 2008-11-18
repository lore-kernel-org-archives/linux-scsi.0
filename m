From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/3] Open-FCoE Submission
Date: Tue, 18 Nov 2008 14:20:51 -0800
Message-ID: <20081118222051.2289.81361.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24891 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753946AbYKRWU6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2008 17:20:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: jgarzik@redhat.com, james.smart@emulex.com, davem@davemloft.net, michaelc@cs.wisc.edu, jeffrey.t.kirsher@intel.com, jeykholt@cisco.com

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

We've spent a lot of time recently improving stability and creating
different interfaces for potential users. We'd like to be queued for
the 2.6.29 merge window. We're actively developing this stack and
we will continue to have a lot of changes, but I think that the code is
at a good place right now and it's ready for inclusion. Please let me
know what you think.

---

Robert Love (3):
      fcoe: Fibre Channel over Ethernet
      libfc: A modular Fibre Channel library
      FC protocol definition header files


 drivers/scsi/Kconfig                  |   13 
 drivers/scsi/Makefile                 |    2 
 drivers/scsi/fcoe/Makefile            |    8 
 drivers/scsi/fcoe/fc_transport_fcoe.c |  446 +++++++
 drivers/scsi/fcoe/fcoe_sw.c           |  488 ++++++++
 drivers/scsi/fcoe/libfcoe.c           | 1506 +++++++++++++++++++++++
 drivers/scsi/libfc/Makefile           |   12 
 drivers/scsi/libfc/fc_disc.c          |  932 ++++++++++++++
 drivers/scsi/libfc/fc_elsct.c         |   71 +
 drivers/scsi/libfc/fc_exch.c          | 1971 +++++++++++++++++++++++++++++++
 drivers/scsi/libfc/fc_fcp.c           | 2130 +++++++++++++++++++++++++++++++++
 drivers/scsi/libfc/fc_frame.c         |   89 +
 drivers/scsi/libfc/fc_lport.c         | 1525 ++++++++++++++++++++++++
 drivers/scsi/libfc/fc_rport.c         | 1277 ++++++++++++++++++++
 include/scsi/fc/fc_els.h              |  802 ++++++++++++
 include/scsi/fc/fc_encaps.h           |  138 ++
 include/scsi/fc/fc_fc2.h              |  124 ++
 include/scsi/fc/fc_fcoe.h             |  102 ++
 include/scsi/fc/fc_fcp.h              |  199 +++
 include/scsi/fc/fc_fs.h               |  340 +++++
 include/scsi/fc/fc_gs.h               |   93 +
 include/scsi/fc/fc_ns.h               |  159 ++
 include/scsi/fc_encode.h              |  309 +++++
 include/scsi/fc_frame.h               |  239 ++++
 include/scsi/fc_transport_fcoe.h      |   54 +
 include/scsi/libfc.h                  |  917 ++++++++++++++
 include/scsi/libfcoe.h                |  177 +++
 27 files changed, 14123 insertions(+), 0 deletions(-)
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
