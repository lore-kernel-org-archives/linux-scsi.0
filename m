From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [v5 PATCH 0/4] bnx2fc: Broadcom FCoE offload driver submission
Date: Fri, 28 Jan 2011 18:00:24 -0800
Message-ID: <1296266424.268.49.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1131 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab1A2CAh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 21:00:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, devel@open-fcoe.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, mchan@broadcom.com

This is the v5 submission of Broadcom FCoE offload driver(bnx2fc)
to the upstream kernel. This driver is for Broadcom Netxtreme II 57712
chip. The following patches contain the driver sources for bnx2fc driver,
and the libfc/libfcoe changes to enable bnx2fc. bnx2fc is a SCSI low level
driver that interfaces with SCSI midlayer, libfc, libfcoe, cnic modules.
bnx2fc driver uses services of libfc for slow path operations such as FIP and
fabric discovery. The fast path IO perations are performed after offloading
the session information to the underlying FCoE firmware.

v5 patches have the following changes
	- Modify bnx2fc to access common libfcoe transport code.
	  Pre-requisite for this patch is 
	  http://marc.info/?l=linux-scsi&m=129625954108557&w=2

v4 patches have the following changes
        - libfcoe transport match function implemented for bnx2fc
        - Changed DID_REQUEUE to DID_ERROR

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

Bhanu Prakash Gollapudi (4):
  bnx2fc: Header files
  bnx2fc: Firmware interface and ELS handling
  bnx2fc: SCSI IO handling and session offload
  bnx2fc: Makefile, Kconfig changes and FCoE interfaces

 drivers/scsi/Kconfig                   |    1 +
 drivers/scsi/Makefile                  |    1 +
 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h  | 1080 ++++++++++++++
 drivers/scsi/bnx2fc/Kconfig            |   11 +
 drivers/scsi/bnx2fc/Makefile           |    3 +
 drivers/scsi/bnx2fc/bnx2fc.h           |  506 +++++++
 drivers/scsi/bnx2fc/bnx2fc_constants.h |  206 +++
 drivers/scsi/bnx2fc/bnx2fc_debug.h     |   68 +
 drivers/scsi/bnx2fc/bnx2fc_els.c       |  528 +++++++
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c      | 2537 ++++++++++++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_hwi.c       | 1923 ++++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_io.c        | 1831 +++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_tgt.c       |  844 +++++++++++
 13 files changed, 9539 insertions(+), 0 deletions(-)
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




