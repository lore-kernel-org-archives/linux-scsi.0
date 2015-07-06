From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v2 0/3] Target sense data handling modifications
Date: Mon,  6 Jul 2015 11:02:24 +0300
Message-ID: <1436169747-28834-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

This patch set modifies the target sense data handling.
The main changes are that the sense data handling moved to
translate_sense_reason() and the sense reason switch statement
was converted to a table. In addition the sense buffer construction
is now done with scsi sense helpers which moved to scsi_common.

In addition t10-pi errors wrong sense setting (non-descriptor format)
was fixed.

Changes from v1:
- Added Reviewed-by tags for patches 1,2
- Fixed compilation error after testing patch #3 on scsi/for-next
  branch. Moved scsi_sense_desc_find() to scsi_common as well (dependency)
  and also moved <asm/unaligned.h> include to scsi_common.h

Changes from v0:
- Added Bart's patches and converted my patch to apply over his
- Moved scsi sense helpers to scsi_common

Bart Van Assche (2):
  target: Inline transport_get_sense_codes()
  target: Split transport_send_check_condition_and_sense()

Sagi Grimberg (1):
  target: Use scsi helpers to build the sense data correctly

 drivers/scsi/scsi_common.c             |  98 ++++++++
 drivers/scsi/scsi_error.c              |  99 +-------
 drivers/target/target_core_spc.c       |  31 +--
 drivers/target/target_core_transport.c | 398 ++++++++++++---------------------
 include/scsi/scsi_common.h             |   5 +
 include/scsi/scsi_eh.h                 |   7 +-
 include/target/target_core_base.h      |   9 +-
 7 files changed, 255 insertions(+), 392 deletions(-)

-- 
1.8.4.3
