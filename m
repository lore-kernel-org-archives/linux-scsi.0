From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/11] qla2xxx: updates/fixes for 2.6.24 [8.02.00-k8].
Date: Thu, 31 Jan 2008 12:32:16 -0800
Message-ID: <20080131203216.GB19014@plap3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:8033 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833AbYAaUc2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 15:32:28 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

Here's a batch of fixes for 2.6.24.

Changes include:

- Correct resource_size_t usages.
- Add MODULE_FIRMWARE hint for ISP25XX firmware.
- Cleanup any outstanding SRB resources during shutdown.
- Clear EFT buffer before firmware reinitialization.
- Cleanse memory allocation logic during probe.
- Consolidate RISC-parity enablement codes.
- Move RISC-interrupt-register modifications to qla2x00_request_irqs().
- Correct issue where vport-state was not updated during an
  ISP_ABORT_NEEDED requst.
- Access the proper 'physical' port in FC-transport callbacks.
- Correct issue where incorrect init-fw mailbox command was used on
  non-NPIV capable ISPs.
- Update version number to 8.02.00-k8.

Diffstat:

 drivers/scsi/qla2xxx/qla_attr.c    |   24 ++-
 drivers/scsi/qla2xxx/qla_def.h     |    2 -
 drivers/scsi/qla2xxx/qla_gbl.h     |    1 +
 drivers/scsi/qla2xxx/qla_init.c    |   87 +++------
 drivers/scsi/qla2xxx/qla_inline.h  |    7 +
 drivers/scsi/qla2xxx/qla_isr.c     |   27 ++-
 drivers/scsi/qla2xxx/qla_mbx.c     |    2 +-
 drivers/scsi/qla2xxx/qla_os.c      |  404 +++++++++++++-----------------------
 drivers/scsi/qla2xxx/qla_sup.c     |   36 ++--
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 10 files changed, 233 insertions(+), 359 deletions(-)

Regards,
Andrew Vasquez
QLogic Corporation
