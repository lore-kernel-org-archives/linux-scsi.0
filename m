From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v4 0/5] Target sense data handling modifications
Date: Wed,  8 Jul 2015 17:58:49 +0300
Message-ID: <1436367534-15995-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [193.47.165.129] ([193.47.165.129]:56957 "EHLO mellanox.co.il"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S934811AbbGHO7V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 10:59:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

This patch set modifies the target sense data handling.
First, cleanup transport_send_check_condition_and_sense()
by splitting the sense translation to a separate function.
Second, convert sense reason the switch statement to a table
driven code. Third, Use scsi common helpers to correctly set
the sense buffer. Last, Fix sense key wrong setting of t10-pi
errors.

Changes from v2:
- Removed wrong patch 5/5 for descriptor format sense data
- Added a patch (5/5) that fixes wrong sense key for PI errors
- Incorporate hch's comments
- Added Reviewed-by tags

Changes from v2:
- Pass sense_reason_t to scsi_translate_sense()
- Split patch 3:
  1) move the helpers to scsi_common.c
  2) use helpers in the target code
  3) always use descriptor-type sense data for PI errors

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

Sagi Grimberg (3):
  scsi: Move sense handling routines to scsi_common
  target: Use scsi helpers to build the sense data correctly
  target: Return ABORTED_COMMAND sense key for PI errors

 drivers/scsi/scsi_common.c             |  98 ++++++++
 drivers/scsi/scsi_error.c              |  99 +--------
 drivers/target/target_core_spc.c       |  31 +--
 drivers/target/target_core_transport.c | 396 ++++++++++++---------------------
 include/scsi/scsi_common.h             |   5 +
 include/scsi/scsi_eh.h                 |   7 +-
 6 files changed, 252 insertions(+), 384 deletions(-)

-- 
1.8.4.3

