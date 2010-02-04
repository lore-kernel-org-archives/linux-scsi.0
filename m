From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 00/30] hpsa: Feb 2010 driver updates
Date: Thu, 04 Feb 2010 08:41:21 -0600
Message-ID: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The biggest changes are:

1) Adding support for Storageworks 1210m.  This RAID controller,
unlike previous Smart Arrays, responds to SCSI_REPORT_LUNs and
consequently the code for device discovery and mapping devices to
bus/target/lun had to change significantly.

2) The 1210m requires the use of so-called "performant mode", which
allow multiple commands to be completed with a single interrupt.  All
Smart Arrays support this mode.

3) Fixed bug in device updating code in which multiple changes at once
caused bad things to happen.

The remaining changes are mostly just cleaning things up.

Don Brace (1):
      hpsa:  Allow multiple command completions per interrupt.

Matt Gates (3):
      hpsa: Return DID_RESET for commands which complete with status of UNSOLICITED ABORT
      hpsa: Retry commands completing with a sense key of ABORTED_COMMAND
      hpsa: Don't return DID_NO_CONNECT when a device is merely not ready

Mike Miller (2):
      hpsa: add pci ids for storageworks 1210m, remove p400, p800, p700m
      hpsa: print all the bytes of the CDB, not just the first one.

Stephen M. Cameron (24):
      hpsa: fix typo in comments
      hpsa: Use kernel integer types, not userland ones
      hpsa: avoid unwanted promotion from unsigned to signed for raid level index
      hpsa:  Use BUG_ON instead of an if statement.
      hpsa: make adjust_hpsa_scsi_table return void.
      hpsa: remove superfluous returns from void functions.
      hpsa: return proper error codes not minus one.
      hpsa: use sizeof() not an inline constant in memset.
      hpsa: use kzalloc not kmalloc plus memset
      hpsa: remove unwanted debug code
      hpsa: eliminate unnecessary memcpys
      hpsa: make tag macros into functions
      hpsa: fix some debug printks to use dev_dbg instead
      hpsa: interrupt pending function should return bool not unsigned long
      hpsa: Fix p1210m LUN assignment.
      hpsa: Add an shost_to_hba helper function.
      hpsa: use scan_start and scan_finished entry points for scanning
      hpsa:  when resetting devices, print out which device
      hpsa: clarify obscure comment in adjust_hpsa_scsi_table
      hpsa: Fix hpsa_find_scsi_entry so that it doesn't try to dereference NULL pointers
      hpsa: fix bug in adjust_hpsa_scsi_table
      hpsa: eliminate lock_kernel in compat_ioctl
      hpsa: Reorder compat ioctl functions to eliminate some forward declarations.
      hpsa: `update driver version to 2.0.1-3


 drivers/scsi/hpsa.c     |  793 ++++++++++++++++++++++++++++++++++-------------
 drivers/scsi/hpsa.h     |  136 +++++++-
 drivers/scsi/hpsa_cmd.h |  204 +++++++-----
 3 files changed, 809 insertions(+), 324 deletions(-)

-- 
  steve
