From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 00/48] hpsa driver updates
Date: Fri, 23 Jan 2015 16:41:04 -0600
Message-ID: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:34007 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbbAWWmD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:42:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

This patch set is based on Linus's tree.

The changes are:
 - correct sparse warnings
 - correct memory leaks
 - correct kdump issues
 - correct queue depth updates
 - cleanup function return values
 - cleanup and enhance messages
 - cleanup and enhance error handling
 - minor code refactoring
 - performance enhancements.
 - removal of command queueing in driver
 - elimination of race conditions around aborts
 - change to internal driver workqueues

---

Don Brace (12):
      hpsa: correct endian sparse warnings
      hpsa: change how SA controllers are reset
      hpsa: correct change_queue_depth
      hpsa: do not queue commands internally in driver
      hpsa: use workqueue to resubmit failed ioaccel commands
      hpsa: honor queue depth of physical devices
      hpsa: count passthru cmds with atomics, not a spin locked int
      hpsa: slightly optimize SA5_performant_completed
      hpsa: return failed from device reset/abort handlers
      hpsa: add in gen9 controller model names
      hpsa: add in P840ar controller model name
      hpsa: Use local workqueues instead of system workqueues

Fabian Frederick (1):
      hpsa: Fix -Wunused-but-set-variable warning

Robert Elliott (16):
      hpsa: adjust RAID-1, RAID-1ADM, and RAID-6 names
      hpsa: rename free_irqs to hpsa_free_irqs
      hpsa: notice all request_irq errors
      hpsa: remove 0x from queue depth print which is in decimal
      hpsa: propagate hard_reset failures in reset_devices mode
      hpsa: propagate return value from board ID lookup
      hpsa: downgrade the Waiting for no-op print to dev_info
      hpsa: report failure to ioremap config table
      hpsa: rename hpsa_request_irq to hpsa_request_irqs
      hpsa: pass error from pci_set_consistent_dma_mask from hpsa_message
      hpsa: report allocation failures while allocating SG chain blocks
      hpsa: fix memory leak in hpsa_alloc_cmd_pool
      hpsa: avoid unneccesary calls to resource freeing functions
      hpsa: optimize cmd_alloc function by remembering last allocation
      hpsa: shorten the wait for the CISS doorbell mode change ack
      hpsa: detect and report failures changing controller transport modes

Stephen Cameron (13):
      hpsa: trivial message and comment clean ups
      hpsa: reserve some commands for use by driver
      hpsa: get rid of cmd_special_alloc and cmd_special_free
      hpsa: do not request device rescan on every ioaccel path error
      hpsa: factor out hpsa_ciss_submit function
      hpsa: do not check for msi(x) in interrupt_pending
      hpsa: remove incorrect BUG_ONs checking for raid offload enable
      hpsa: do not ack controller events on controllers that do not support it
      hpsa: guard against overflowing raid map array
      hpsa: check for ctlr lockup after command allocation in main io path
      hpsa: do not use a void pointer for scsi_cmd field of struct CommandList
      hpsa: print CDBs instead of kernel virtual addresses for uncommon errors
      hpsa: do not use function pointers in fast path command submission

Tomas Henzl (2):
      hpsa: fix memory leak in kdump hard reset
      hpsa: turn off interrupts when kdump starts

Webb Scales (4):
      hpsa: refactor hpsa_find_board_params() to encapsulate legacy test
      hpsa: fix race between abort handler and main i/o path
      hpsa: move SG descriptor set-up out of hpsa_scatter_gather()
      hpsa: refactor duplicated scan completion code into a new routine


 drivers/scsi/hpsa.c     | 1858 ++++++++++++++++++++++++-----------------------
 drivers/scsi/hpsa.h     |   61 +-
 drivers/scsi/hpsa_cmd.h |  334 ++++++--
 3 files changed, 1203 insertions(+), 1050 deletions(-)

--
Signature
