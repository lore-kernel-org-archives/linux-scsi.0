From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 00/13] hpsa update
Date: Fri, 14 Nov 2014 17:26:20 -0600
Message-ID: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t2354.austin.hp.com ([15.217.128.53]:37031 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935316AbaKNXYs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 18:24:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, webb.scales@hp.com, james.bottomley@parallels.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

This patch set is based on Linus's tree.
The changes are:
 - correct warnings from sparse
 - updates for some error handling issues
 - general code cleanup
 - performance enhancements based on removing spin_locks

---

Don Brace (1):
      hpsa: Clean up warnings from sparse.

Nicholas Bellinger (1):
      hpsa: Convert SCSI LLD ->queuecommand() for host_lock less operation

Robert Elliott (2):
      hpsa: remove dev_warn prints from RAID-1ADM
      hpsa: always call pci_set_master after pci_enable_device

Stephen M. Cameron (8):
      hpsa: fix a couple pci id table mistakes
      hpsa: remove 'action required' phrasing
      hpsa: fix allocation sizes for CISS_REPORT_LUNs commands
      hpsa: fix endianness issue with scatter gather elements
      hpsa: get rid of type/attribute/direction bit field where possible
      hpsa: use atomics for commands_outstanding
      hpsa: do not be so noisy about check conditions
      hpsa: remove spin lock around command allocation

Webb Scales (1):
      hpsa: correct off-by-one sizing of chained SG block


 drivers/scsi/hpsa.c     |  488 ++++++++++++++++++++---------------------------
 drivers/scsi/hpsa.h     |   33 +--
 drivers/scsi/hpsa_cmd.h |   34 ++-
 3 files changed, 234 insertions(+), 321 deletions(-)

--
Don Brace
don.brace@pmcs.com
