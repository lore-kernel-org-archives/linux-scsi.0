From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 00/21] hpsa updates
Date: Sat, 24 Oct 2015 14:52:26 -0500
Message-ID: <20151024193306.17127.7819.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:51169 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752185AbbJXT4I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Oct 2015 15:56:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

The changes are:
 - corrected quirky issue with dev_printk
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
 - add in SAS transport class for HBA devices
 - add in physical target resets
 - eliminate fake lun0 enclosures
 - add polling for PT RAID devices
 - disable report lun data caching
 - bumped driver version to match in-box driver

---

Don Brace (10):
      hpsa: correct calls to dev_printk
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

Scott Teel (5):
      hpsa: fix physical target reset
      External array LUNs must use target and lun numbers assigned by the
      hpsa: eliminate fake lun0 enclosures
      hpsa: add discovery polling for PT RAID devices.
      hpsa: disable report lun data caching


 drivers/block/cciss.h   |    1 
 drivers/scsi/hpsa.c     | 1237 +++++++++++++++++++++++++++++++++++++++--------
 drivers/scsi/hpsa.h     |   45 ++
 drivers/scsi/hpsa_cmd.h |   30 +
 4 files changed, 1088 insertions(+), 225 deletions(-)

--
Signature
