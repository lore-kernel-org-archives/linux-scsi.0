From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [v7 PATCH 0/4] bnx2fc: Broadcom FCoE offload driver submission
Date: Fri, 4 Feb 2011 12:10:32 -0800
Message-ID: <1296850232.268.908.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3860 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab1BDUKn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2011 15:10:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Michael Chan <mchan@broadcom.com>

This is the v7 submission of Broadcom FCoE offload driver(bnx2fc)
to the upstream kernel. This driver is for Broadcom Netxtreme II 57712
chip. The following patches contain the driver sources for bnx2fc driver,
and the libfc/libfcoe changes to enable bnx2fc. bnx2fc is a SCSI low level
driver that interfaces with SCSI midlayer, libfc, libfcoe, cnic modules.
bnx2fc driver uses services of libfc for slow path operations such as FIP and
fabric discovery. The fast path IO perations are performed after offloading
the session information to the underlying FCoE firmware.

v7 patches have the following review comments by Mike Chrisite
	- Fix kthread_should_stop() bug.
	Pre-requisite for this patch is
	http://marc.info/?l=linux-scsi&m=129678765615282&w=2

v6 patches have the following review comments by Mike Chrisite
	- Uses shost_printk
	- Handle NULL pointer check
	- Avoid unnecessary goto
	- use __fc_fill_fc_hdr from fc_encode.h
	- Donot encapsulate unsol ELS to FCoE format
	Pre-requisite for this patch is
	http://marc.info/?l=linux-scsi&m=129678765615282&w=2

v5 patches have the following changes
	- Modify bnx2fc to access common code libfcoe transport code.
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
 drivers/scsi/bnx2fc/bnx2fc.h           |  511 +++++++
 drivers/scsi/bnx2fc/bnx2fc_constants.h |  206 +++
 drivers/scsi/bnx2fc/bnx2fc_debug.h     |   70 +
 drivers/scsi/bnx2fc/bnx2fc_els.c       |  515 +++++++
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c      | 2535 ++++++++++++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_hwi.c       | 1868 +++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_io.c        | 1833 +++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_tgt.c       |  844 +++++++++++
 13 files changed, 9478 insertions(+), 0 deletions(-)
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




