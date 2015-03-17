From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 00/42] hpsa updates
Date: Tue, 17 Mar 2015 15:02:24 -0500
Message-ID: <20150317200139.19856.87982.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:58096 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbbCQUEH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 16:04:07 -0400
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
 - update copyright

---

Don Brace (2):
      hpsa: change driver version
      hpsa: add PMC to copyright

Joe Handzik (3):
      hpsa: use ioaccel2 path to submit IOs to physical drives in HBA mode.
      hpsa: Get queue depth from identify physical bmic for physical disks.
      hpsa: add more ioaccel2 error handling, including underrun statuses.

Robert Elliott (18):
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


 drivers/scsi/hpsa.c     | 2801 ++++++++++++++++++++++++++++++++++-------------
 drivers/scsi/hpsa.h     |   22 
 drivers/scsi/hpsa_cmd.h |   37 +
 3 files changed, 2052 insertions(+), 808 deletions(-)

--
Signature
