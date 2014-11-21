From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 00/12] Re-implement am53c974 driver
Date: Fri, 21 Nov 2014 13:41:44 +0100
Message-ID: <1416573716-73890-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756976AbaKUMmC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 07:42:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, "David S. Miller" <davem@davemloft.net>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

having found some issues with the current tmscsim driver
I looked at the code and found is really awkward to clean
up.
Seeing that the am53c974 chip is actually based on the
'ESP' chip design I've re-implemented it based on the
common esp_scsi routines. This new driver
(cunningly named 'am53c974') provides all features
found on the tmscsim driver, with the goal of obsoleting
the old tmscsim driver.
Tested with Tekram DC390 and qemu esp-scsi.

Changes to v1:
- Include suggestions from Paolo Bonzini
- Remove the tmscsim driver
- Update MAINTAINERS file

Hannes Reinecke (11):
  esp_scsi: spellcheck 'driver'
  esp_scsi: make number of tags configurable
  esp_scsi: convert to dev_printk
  esp_scsi: debug event and command
  esp_scsi: read status registers
  esp_scsi: use FIFO for command submission
  scsi: add 'am53c974' driver
  am53c974: BLAST residual handling
  esp: correctly detect am53c974
  esp: enable CONFIG2_FENAB for am53c974
  Replace tmscsim by am53c974

Paolo Bonzini (1):
  esp_scsi: let DMA driver provide a config2 value

 MAINTAINERS             |    7 +-
 drivers/scsi/Kconfig    |    8 +-
 drivers/scsi/Makefile   |    2 +-
 drivers/scsi/am53c974.c |  581 +++++++++++
 drivers/scsi/esp_scsi.c |  411 +++++---
 drivers/scsi/esp_scsi.h |   22 +-
 drivers/scsi/tmscsim.c  | 2626 -----------------------------------------------
 drivers/scsi/tmscsim.h  |  549 ----------
 8 files changed, 854 insertions(+), 3352 deletions(-)
 create mode 100644 drivers/scsi/am53c974.c
 delete mode 100644 drivers/scsi/tmscsim.c
 delete mode 100644 drivers/scsi/tmscsim.h

-- 
1.8.5.2

