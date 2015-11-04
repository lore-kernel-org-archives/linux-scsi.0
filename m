From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 00/27] hpsa updates
Date: Wed, 04 Nov 2015 15:49:55 -0600
Message-ID: <20151104214910.15472.23179.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:60638 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965397AbbKDVxs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:53:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

The changes are:
 - removed unused parameter hostno
 - corrected zeroing out reset_cmds_out during a rescan
 - removed unused function
 - corrected issue with dev_printk
 - add driver requested rescans
 - stop rescans on memory allocation failures and
   skip over unresponsive devices
 - correct 0 byte READ(6)/WRITE(6) transfers
 - correct issues when looking at CISS_REPORT_PHYS data
 - correct mapping of ioaccel2 chain blocks
 - make hpsa_get_device_id more generic
 - add more information to messages
 - simplify device exposure checks
 - simplify hpsa_update_scsi_device
 - add function is_logical_device
 - simplify hpsa_figure_bus_target_lun
 - split out scsi_add_device scsi_remove_device calls
 - correct issues with path_info
 - add in sas transport class for HBA devices
 - add in physical target resets
 - eliminate fake lun0 enclosures
 - add polling for PT RAID devices
 - disable report lu data caching

Changes from initial upload:
 - changed hpsa_scsi_dev_t.devtype to unsigned
 - changed driver initiated rescan messages
 - changed atomic_t to int from ctlr_info.reset_in_progress
 - changed version comment - Tomas Henzl
 - added hpsa-stop-zeroing-reset-cmds-out-during-rescan
 - added hpsa-remove-unused-function
 - added hpsa-fix-multiple-issues-in-path_info_show
   authored by Rasmus Villemoes
 - added hpsa-remove-unused-parameter-hostno

Changes from v1:
 - added hpsa-remove-unused-parameter-hostno
 - updated hpsa-remove-unused-function per Manoj Kumar's review
 - updated hpsa-fix-null-device-issues per Tomas Henzl's and
   Hannes Reinecke's reviews
 - updated hpsa-correct-dev_printk_calls per Hannes's review
 - updated hpsa-abandon-rescan-on-memory-failures per Hannes's review
 - updated hpsa-fix-adjust-hpsa-scsi-table per Hannes's and Tomas's reviews.
 - updated hpsa-simplify-update-scsi-devices per Matthew R. Och's review.
 - updated hpsa-enhance-get_device_id per Hannes's review
 - updated hpsa-bump-version per Tomas's review
 - updated hpsa-add-sas-transport-class to check return code from
   hpsa_add_sas_host

---

Don Brace (15):
      hpsa: remove unused parameter hostno
      hpsa: stop zeroing reset_cmds_out and ioaccel_cmds_out during rescan
      hpsa: remove unused hpsa_tag_discard_error_bits
      hpsa: change devtype to unsigned
      hpsa: check for null arguments to dev_printk
      hpsa: fix null device issues
      hpsa: allow driver requested rescans
      hpsa: abandon rescans on memory alloaction failures.
      hpsa: correct transfer length for 6 byte read/write commands
      hpsa: fix hpsa_adjust_hpsa_scsi_table
      hpsa: correct check for non-disk devices
      hpsa: correct ioaccel2 sg chain len
      hpsa: enhance hpsa_get_device_id
      hpsa: enhance device messages
      hpsa: bump the driver version

Kevin Barnett (6):
      hpsa: simplify check for device exposure
      hpsa: simplify update scsi devices
      hpsa: add function is_logical_device
      hpsa: refactor hpsa_figure_bus_target_lun
      hpsa: move scsi_add_device and scsi_remove_device calls to new function
      hpsa: add in sas transport class

Rasmus Villemoes (1):
      hpsa: fix multiple issues in path_info_show

Scott Teel (5):
      hpsa: fix physical target reset
      hpsa: generalize external arrays
      hpsa: eliminate fake lun0 enclosures
      hpsa: add discovery polling for PT RAID devices.
      hpsa: disable report lun data caching


 drivers/scsi/hpsa.c     | 1338 ++++++++++++++++++++++++++++++++++++++---------
 drivers/scsi/hpsa.h     |   47 +-
 drivers/scsi/hpsa_cmd.h |   30 +
 3 files changed, 1147 insertions(+), 268 deletions(-)

--
Signature
