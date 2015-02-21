From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 00/43] hpsa updates
Date: Sat, 21 Feb 2015 16:17:29 -0600
Message-ID: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:57217 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbbBUWSt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:18:49 -0500
Received: from g2t2353.austin.hp.com (g2t2353.austin.hp.com [15.217.128.52])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id C373260172
	for <linux-scsi@vger.kernel.org>; Sat, 21 Feb 2015 22:18:48 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

The changes are:
 - make function names consistent
 - refactor functions
 - cleanup driver messages
 - cleanup error handling
 - clean up abort management
 - enhance sense data reporting
 - enhance ioaccel command support
 - add in block layer tag support
 - clean up resets

---

Don Brace (2):
      hpsa: cleanup initialization code.
      hpsa: change driver version

Joe Handzik (3):
      hpsa: use ioaccel2 path to submit IOs to physical drives in HBA mode.
      hpsa: Get queue depth from identify physical bmic for physical disks.
      hpsa: add more ioaccel2 error handling, including underrun statuses.

Robert Elliott (19):
      hpsa: make function names consistent
      hpsa: print accurate SSD Smart Path Enabled status
      hpsa: break hpsa_free_irqs_and_disable_msix into two functions
      hpsa: clean up error handling
      hpsa: refactor freeing of resources into more logical functions
      hpsa: do not check cmd_alloc return value - it cannnot return NULL
      hpsa: correct return values from driver functions.
      hpsa: clean up driver init
      hpsa: clean up some error reporting output in abort handler
      hpsa: do not print ioaccel2 warning messages about unusual completions.
      hpsa: call pci_release_regions after pci_disable_device
      hpsa: skip free_irq calls if irqs are not allocated
      hpsa: cleanup for init_one step 2 in kdump
      hpsa: fix try_soft_reset error handling
      hpsa: create workqueue after the driver is ready for use
      hpsa: add interrupt number to /proc/interrupts interrupt name
      hpsa: clean up new block layer tag error handling
      hpsa: use scsi host_no as hpsa controller number
      hpsa: propagate the error code in hpsa_kdump_soft_reset

Stephen Cameron (9):
      hpsa: add masked physical devices into h->dev[] array
      hpsa: clean up aborts
      hpsa: decrement h->commands_outstanding in fail_all_outstanding_cmds
      hpsa: hpsa decode sense data for io and tmf
      hpsa: allow lockup detected to be viewed via sysfs
      hpsa: factor out hpsa_init_cmd function
      hpsa: do not ignore return value of hpsa_register_scsi
      hpsa: try resubmitting down raid path on task set full
      hpsa: add support sending aborts to physical devices via the ioaccel2 path

Webb Scales (10):
      hpsa: clean up host, channel, target, lun prints
      hpsa: rework controller command submission
      hpsa: factor out hpsa_ioaccel_submit function
      hpsa: add ioaccel sg chaining for the ioaccel2 path
      hpsa: use helper routines for finishing commands
      hpsa: don't return abort request until target is complete
      hpsa: refactor and rework support for sending TEST_UNIT_READY
      hpsa: performance tweak for hpsa_scatter_gather()
      hpsa: use block layer tag for command allocation
      hpsa: cleanup reset


 drivers/scsi/hpsa.c     | 2798 +++++++++++++++++++++++++++++++++--------------
 drivers/scsi/hpsa.h     |   20 
 drivers/scsi/hpsa_cmd.h |   34 +
 3 files changed, 2043 insertions(+), 809 deletions(-)

--
Signature
