From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v1 0/4] Descriptor format sense data
Date: Wed, 15 Jul 2015 10:55:35 +0300
Message-ID: <1436946939-19415-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

This small patchset addresses some issues with descriptor format
sense data.

Patch 1 fixes wrong additional sense length for descriptor format
information field.

Patch 2 protects against buffer overflow in scsi_set_information_sense
(reported by Hannes).

Patch 3 converts the target stack to report descriptor format sense
data to for LUs that spans 64bit sectors in order to avoid info
truncation (reported by hch).

Patch 4 is a nit, it was included in this to avoid dependencies
(patch 2/4)

Changes from v0:
- Added patch 4/4 to avoid dependencies
- Modified patch 3/4 to use descriptor format only for LUs that
  span 64bit sectors.
- Added reviwed-by tags.

Sagi Grimberg (4):
  scsi: Fix wrong additional sense length in descriptor format
  scsi: Protect against buffer possible overflow in
    scsi_set_sense_information
  target: Return descriptor format sense data in case the LU spans 64bit
    sectors
  libiscsi: Use scsi helper to set information descriptor

 drivers/ata/libata-scsi.c              |  4 +++-
 drivers/scsi/libiscsi.c                |  9 +++------
 drivers/scsi/scsi_common.c             | 15 +++++++++++++--
 drivers/target/target_core_hba.c       |  5 +++++
 drivers/target/target_core_spc.c       | 12 +++++++++---
 drivers/target/target_core_transport.c | 17 +++++++++++++----
 include/scsi/scsi_common.h             |  2 +-
 include/target/target_core_backend.h   |  2 ++
 8 files changed, 49 insertions(+), 17 deletions(-)

-- 
1.8.4.3
