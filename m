From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 0/3] Descriptor format sense data
Date: Sun, 12 Jul 2015 13:37:00 +0300
Message-ID: <1436697423-20611-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

This small patchset addresses some issues with descriptor format
sense data.

Patch 1 fixes wrong additional sense length for descriptor format
information field.

Patch 2 protects against buffer overflow in scsi_set_information_sense
(reported by Hannes).

Patch 3 converts the target stack to report descriptor format sense
data to avoid 64bit sector info truncation (reported by hch).

Sagi Grimberg (3):
  scsi: Fix wrong additional sense length in descriptor format
  scsi: Protect against buffer possible overflow in
    scsi_set_sense_information
  target: Return descriptor format sense data

 drivers/ata/libata-scsi.c              |  4 +++-
 drivers/scsi/scsi_common.c             | 15 +++++++++++++--
 drivers/target/target_core_spc.c       | 11 ++++++++---
 drivers/target/target_core_transport.c | 16 ++++++++++++----
 include/scsi/scsi_common.h             |  2 +-
 5 files changed, 37 insertions(+), 11 deletions(-)

-- 
1.8.4.3
