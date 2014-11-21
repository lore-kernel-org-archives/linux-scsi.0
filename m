From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/10] Re-implement am53c974 driver
Date: Fri, 21 Nov 2014 10:27:47 +0100
Message-ID: <1416562077-105715-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205AbaKUJ2F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 04:28:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

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

Hannes Reinecke (10):
  esp_scsi: spellcheck 'driver'
  esp_scsi: make number of tags configurable
  esp_scsi: convert to dev_printk
  esp_scsi: debug event and command
  esp_scsi: read status registers
  scsi: add 'am53c974' driver
  esp: Use FIFO for command submission
  am53c974: BLAST residual handling
  esp: correctly detect am53c974
  esp: enable CONFIG2_FENAB for am53c974

 drivers/scsi/Kconfig    |  18 ++
 drivers/scsi/Makefile   |   1 +
 drivers/scsi/am53c974.c | 562 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/esp_scsi.c | 378 ++++++++++++++++++++------------
 drivers/scsi/esp_scsi.h |  22 +-
 5 files changed, 843 insertions(+), 138 deletions(-)
 create mode 100644 drivers/scsi/am53c974.c

-- 
1.8.5.2

