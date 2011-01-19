From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [v3 PATCH 0/6] bnx2fc: Broadcom FCoE offload driver submission
Date: Wed, 19 Jan 2011 14:06:45 -0800
Message-ID: <1295474805.3536.404.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2415 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304Ab1ASWG5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2011 17:06:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: mchan@broadcom.com, michaelc@cs.wisc.edu

This is the initial submission of Broadcom FCoE offload driver(bnx2fc)
to the upstream kernel. This driver is for Broadcom Netxtreme II 57712
chip. The following patches contain the driver sources for bnx2fc driver,
and the libfc/libfcoe changes to enable bnx2fc. bnx2fc is a SCSI low level
driver that interfaces with SCSI midlayer, libfc, libfcoe, cnic modules.
bnx2fc driver uses services of libfc for slow path operations such as FIP and
fabric discovery. The fast path IO perations are performed after offloading
the session information to the underlying FCoE firmware.

v3 patches incorporate the following review comments by Mike Christie, perf 
improvements in IO path
        - Remove unused symbols/functions.
        - Consolidated header files into bnx2fc_constants.h.
        - Use symbols from fc_fcp.h
        - Modify cmd_refcnt with krefs
        - Modify debug logging to include host_no/port_id
        - Modify GFP_ATOMIC to GFP_NOIO whereever possible
        - Bound checks for memcpy
        - Resolve couple of race conditions
        - Include brief desciption of the files in the header
        - Move common function to libfcoe
        - Pass device to scsi_add_host instead of NULL
	- Handle kthread_create failure in mod_init
        - Remove unnecessary returns.
        - Remove unnecessary type casts.
        - Use setup_timer instead of init_timer/add_timer
        - Use fc_block_scsi_eh() instead of fc_remote_port_chkready.
        - Use scsi_dma_map/unmap() instead of pci_map_sg() calls.
        - modify to lockless queuecommand
        - Move common code from bnx2fc and fcoe to libfcoe

Bhanu Prakash Gollapudi (6):
  libfc: introduce LLD event callback
  libfcoe: Move common code from fcoe.c to libfcoe.c
  bnx2fc: Header files
  bnx2fc: Firmware interface and ELS handling
  bnx2fc: SCSI IO handling and session offload
  bnx2fc: Makefile, Kconfig changes and FCoE interfaces

 drivers/scsi/Kconfig                   |    1 +
 drivers/scsi/Makefile                  |    1 +
 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h  | 1080 ++++++++++++++
 drivers/scsi/bnx2fc/Kconfig            |   11 +
 drivers/scsi/bnx2fc/Makefile           |    3 +
 drivers/scsi/bnx2fc/bnx2fc.h           |  520 +++++++
 drivers/scsi/bnx2fc/bnx2fc_constants.h |  206 +++
 drivers/scsi/bnx2fc/bnx2fc_debug.h     |   68 +
 drivers/scsi/bnx2fc/bnx2fc_els.c       |  497 +++++++
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c      | 2549 ++++++++++++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_hwi.c       | 1909 ++++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_io.c        | 1814 +++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_tgt.c       |  833 +++++++++++
 drivers/scsi/fcoe/fcoe.c               |   58 -
 drivers/scsi/fcoe/fcoe_ctlr.c          |   63 +
 drivers/scsi/libfc/fc_npiv.c           |    1 +
 drivers/scsi/libfc/fc_rport.c          |   19 +-
 include/scsi/libfc.h                   |   15 +
 include/scsi/libfcoe.h                 |    2 +
 19 files changed, 9591 insertions(+), 59 deletions(-)
 create mode 100644 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h
 create mode 100644 drivers/scsi/bnx2fc/Kconfig
 create mode 100644 drivers/scsi/bnx2fc/Makefile
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc.h
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_constants.h
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_debug.h
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_els.c
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_fcoe.c
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_hwi.c
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_io.c
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_tgt.c




