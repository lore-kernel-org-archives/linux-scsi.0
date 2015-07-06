From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v3 0/5] Target sense data handling modifications
Date: Mon,  6 Jul 2015 16:15:03 +0300
Message-ID: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [193.47.165.129] ([193.47.165.129]:53523 "EHLO mellanox.co.il"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754923AbbGFNPc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2015 09:15:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

This patch set modifies the target sense data handling.
First, cleanup transport_send_check_condition_and_sense()
by splitting the sense translation to a separate function.
Second, convert sense reason the switch statement to a table
driven code. Third, Use scsi common helpers to correctly set
the sense buffer. Last, Fix wrong setting of t10-pi errors
(non descriptor format).

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
  target: Fix wrong setting of sense format for PI errors

 drivers/scsi/scsi_common.c             |  98 ++++++++
 drivers/scsi/scsi_error.c              |  99 +-------
 drivers/target/target_core_spc.c       |  31 +--
 drivers/target/target_core_transport.c | 399 ++++++++++++---------------------
 include/scsi/scsi_common.h             |   5 +
 include/scsi/scsi_eh.h                 |   7 +-
 include/target/target_core_base.h      |   1 +
 7 files changed, 256 insertions(+), 384 deletions(-)

-- 
1.8.4.3

