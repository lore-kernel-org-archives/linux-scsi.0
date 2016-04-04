From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/14] libata: SATL update
Date: Mon,  4 Apr 2016 11:43:53 +0200
Message-ID: <1459763047-125551-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939AbcDDJoW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 05:44:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>

Hi all,

here's a patchset to update the SCSI-to-ATA translation layer.
It is a resubmission of an earlier patchset for ATA autosense handling,
which got reverted as Tejun pointed out some issues with libata EH.

This patchset now implements proper autosense handling, where the
retrieved sense code is evaluated to modify libata EH decisions.
Additionally, it implements the control mode page handling to allow
switching between fixed and descriptor sense formats.
Finally I've updated the sense code generation to set the 'information'
field where possible.

This is the first part of a larger patchset for ZAC/ZBC support;
it requires the scsi trace fixes queued for in mkp/4.7/scsi-queue.
The full patchset can be found at:

git.kernel.org/hare/scsi-devel/h/zbc.v3

As usual, comments and reviews are welcome.

Hannes Reinecke (14):
  libata: Implement NCQ autosense
  libata: Implement support for sense data reporting
  libata-scsi: sanitize ata_gen_ata_sense()
  libata: sanitize ata_tf_read_block()
  libata-scsi: use scsi_set_sense_information()
  libata-eh: Set 'information' field for autosense
  libata-scsi: use ata_scsi_set_sense()
  libata: evaluate SCSI sense code
  libata-scsi: generate correct ATA pass-through sense
  libata: Implement control mode page to select sense format
  scsi: add scsi_set_sense_field_pointer()
  libata-scsi: Set field pointer in sense code
  libata-scsi: set bit pointer for sense code information
  libata-scsi: Set information sense field for invalid parameter

 drivers/ata/libata-core.c  |  24 ++-
 drivers/ata/libata-eh.c    | 109 +++++++++--
 drivers/ata/libata-scsi.c  | 458 ++++++++++++++++++++++++++++++++-------------
 drivers/ata/libata.h       |   8 +-
 drivers/scsi/scsi_common.c |  53 ++++++
 drivers/scsi/scsi_error.c  |   3 +-
 include/linux/ata.h        |  18 ++
 include/linux/libata.h     |   1 +
 include/scsi/scsi_common.h |   1 +
 include/scsi/scsi_eh.h     |   1 +
 10 files changed, 531 insertions(+), 145 deletions(-)

-- 
1.8.5.6

