From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 00/22] Nobody loves the advansys driver
Date: Fri, 24 Apr 2015 10:32:35 +0200
Message-ID: <1429864377-67002-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966349AbbDXIdB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 04:33:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

it has been bugged me for ages that the advansys driver always
reported a compilation warning about not having been converted
to the DMA-API.
And even aggressive waiting hasn't made this warning go away.

So here's a patchset to update the advansys driver to current
standards and use the DMA-API.
Tested on ABP940-U2W and ABP-960-U (Thanks, Doug!)

As usual, reviews and comments are welcome.

Changes to the original version:
- Fixed issue noted by Ondrey Zary
- Tested narrow-scsi support
- Fixed sg list corruption on wide boards
- Even more cleanup

Hannes Reinecke (22):
  advansys: use host_reset
  advansys: use shared host tag map for command lookup
  advansys: use DMA-API for mapping sense buffer
  advansys: Use DMA-API for carrier buffer
  advansys: Use DMA-API for mapping request blocks
  advansys: Use dma_pool for sg elements
  advansys: use 'bool' instead of 'int'
  advansys: use standard data types
  advansys: Remove 'TRUE' and 'FALSE' definitions
  advansys: remove 'ERR' definition
  advansys: Make AscIsrChipHalted() a void function
  advansys: cleanup function return codes
  advansys: scsi_q1->data_addr is little endian
  advansys: Remove ASC_SCSI_REQ_Q
  advansys: Remove CC_VERY_LONG_SG_LIST
  advansys: rename 'ASC_RQ_XX' to 'ADV_RQ_XX'
  advansys: Remove 'a_flag'
  advansys: Remove obsolete virtual memory mapping comment
  advansys: Remove comment around cmd_per_lun
  advansys: Check for DMA mapping errors
  advansys: use spin_lock_irqsave() in interrupt handler
  advansys: Update to version 3.5 and remove compilation warning

 MAINTAINERS             |    1 +
 drivers/scsi/Kconfig    |    2 +-
 drivers/scsi/advansys.c | 1457 ++++++++++++++++-------------------------------
 3 files changed, 508 insertions(+), 952 deletions(-)

-- 
1.8.5.2

