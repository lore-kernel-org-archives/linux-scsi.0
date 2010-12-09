From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [RFC] [PATCH 0/5] bnx2fc: Broadcom FCoE offload driver
 submission
Date: Thu, 9 Dec 2010 10:53:49 -0800
Message-ID: <1291920829.5480.156.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4308 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab0LISyB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2010 13:54:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Michael Chan <mchan@broadcom.com>

This is the initial submission of Broadcom FCoE offload driver(bnx2fc)
to the upstream kernel. This driver is for Broadcom Netxtreme II 57712
chip. The following patches contain the driver sources for bnx2fc driver,
and the libfc change to enable bnx2fc. bnx2fc is a SCSI low level driver
that interfaces with SCSI midlayer, libfc, libfcoe, cnic modules. bnx2fc
driver uses services of libfc for slow path operations such as FIP and
fabric discovery. The fast path IO perations are performed after offloading
the session information to the underlying FCoE firmware.

Here is the brief description of patches:
[PATCH 1/5]: Introduces event callback for low level driver.
[PATCH 2/5]: header files used by bnx2fc driver
[PATCH 3/5]: firmware interface and ELS handling
[PATCH 4/5]: IO and session handling
[PATCH 5/5]: libfc/libfcoe interface, and makefile/kconfig files

Bhanu Prakash Gollapudi (5):
  libfc: introduce LLD event callback
  bnx2fc: Broadcom FCoE offload driver submission (header files)
  bnx2fc: Broadcom FCoE Offload driver submission - part 1
  bnx2fc: Broadcom FCoE Offload driver submission - part 2
  bnx2fc: Broadcom FCoE Offload driver submission - part 3

 drivers/scsi/Kconfig                      |    1 +
 drivers/scsi/Makefile                     |    1 +
 drivers/scsi/bnx2fc/57xx_fcoe_constants.h |  261 ++++
 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h     | 1163 +++++++++++++++
 drivers/scsi/bnx2fc/Kconfig               |   11 +
 drivers/scsi/bnx2fc/Makefile              |    3 +
 drivers/scsi/bnx2fc/bnx2fc.h              |  545 +++++++
 drivers/scsi/bnx2fc/bnx2fc_debug.h        |   23 +
 drivers/scsi/bnx2fc/bnx2fc_els.c          |  500 +++++++
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c         | 2320 +++++++++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_hwi.c          | 1939 ++++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_io.c           | 1894 +++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_tgt.c          |  875 +++++++++++
 drivers/scsi/bnx2fc/fcoe_constants.h      |   29 +
 drivers/scsi/bnx2fc/microcode_constants.h |  179 +++
 drivers/scsi/libfc/fc_npiv.c              |    1 +
 drivers/scsi/libfc/fc_rport.c             |   19 +-
 include/scsi/libfc.h                      |   15 +
 18 files changed, 9778 insertions(+), 1 deletions(-)
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




