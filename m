From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [v2 PATCH 0/5] bnx2fc: Broadcom FCoE offload driver submission
Date: Thu, 23 Dec 2010 22:02:30 -0800
Message-ID: <1293170550.4676.570.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2658 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab0LXGCh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Dec 2010 01:02:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: mchan@broadcom.com, michaelc@cs.wisc.edu

This is the initial submission of Broadcom FCoE offload driver(bnx2fc)
to the upstream kernel. This driver is for Broadcom Netxtreme II 57712
chip. The following patches contain the driver sources for bnx2fc driver,
and the libfc change to enable bnx2fc. bnx2fc is a SCSI low level driver
that interfaces with SCSI midlayer, libfc, libfcoe, cnic modules. bnx2fc
driver uses services of libfc for slow path operations such as FIP and
fabric discovery. The fast path IO perations are performed after offloading
the session information to the underlying FCoE firmware.

v2 patches include the modification of bnx2fc to work with fcoe_transport
layer that is part of libfcoe_transport.

Here is the brief description of patches:
[v2 PATCH 1/5]: Introduces event callback for low level driver.
[v2 PATCH 2/5]: header files used by bnx2fc driver
[v2 PATCH 3/5]: firmware interface and ELS handling
[v2 PATCH 4/5]: IO and session handling
[v2 PATCH 5/5]: libfc/libfcoe interface, and makefile/kconfig files

Bhanu Prakash Gollapudi (5):
  libfc: introduce LLD event callback
  bnx2fc: Broadcom FCoE offload driver submission (header files)
  bnx2fc: Broadcom FCoE Offload driver submission - part 1
  bnx2fc: Broadcom FCoE Offload driver submission - part 2
  bnx2fc: Broadcom FCoE Offload driver submission - part 3

 drivers/scsi/Kconfig                      |    1 +
 drivers/scsi/Makefile                     |    1 +
 drivers/scsi/bnx2fc/57xx_fcoe_constants.h |  261 ++++
 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h     | 1163 ++++++++++++++
 drivers/scsi/bnx2fc/Kconfig               |   11 +
 drivers/scsi/bnx2fc/Makefile              |    3 +
 drivers/scsi/bnx2fc/bnx2fc.h              |  545 +++++++
 drivers/scsi/bnx2fc/bnx2fc_debug.h        |   23 +
 drivers/scsi/bnx2fc/bnx2fc_els.c          |  500 ++++++
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c         | 2423 +++++++++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_hwi.c          | 1939 +++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_io.c           | 1894 ++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_tgt.c          |  875 +++++++++++
 drivers/scsi/bnx2fc/fcoe_constants.h      |   29 +
 drivers/scsi/bnx2fc/microcode_constants.h |  179 +++
 drivers/scsi/libfc/fc_npiv.c              |    1 +
 drivers/scsi/libfc/fc_rport.c             |   19 +-
 include/scsi/libfc.h                      |   15 +
 18 files changed, 9881 insertions(+), 1 deletions(-)
 create mode 100644 drivers/scsi/bnx2fc/57xx_fcoe_constants.h
 create mode 100644 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h
 create mode 100644 drivers/scsi/bnx2fc/Kconfig
 create mode 100644 drivers/scsi/bnx2fc/Makefile
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc.h
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_debug.h
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_els.c
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_fcoe.c
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_hwi.c
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_io.c
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_tgt.c
 create mode 100644 drivers/scsi/bnx2fc/fcoe_constants.h
 create mode 100644 drivers/scsi/bnx2fc/microcode_constants.h




