From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v1 0/3] Target sense data handling modifications
Date: Sun,  5 Jul 2015 10:31:08 +0300
Message-ID: <1436081471-667-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [193.47.165.129] ([193.47.165.129]:46113 "EHLO mellanox.co.il"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750751AbbGEIbg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Jul 2015 04:31:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

This patch set modifies the target sense data handling.
The main changes are that the sense data handling moved to
translate_sense_reason() and the sense reason switch statement
was converted to a table. In addition the sense buffer construction
is now done with scsi sense helpers which moved to scsi_common.

In addition t10-pi errors wrong sense setting (non-descriptor format)
was fixed.

Changes from v0:
- Added Bart's patches and converted my patch to apply over his
- Moved scsi sense helpers to scsi_common

Bart Van Assche (2):
  target: Inline transport_get_sense_codes()
  target: Split transport_send_check_condition_and_sense()

Sagi Grimberg (1):
  target: Use scsi helpers to build the sense data correctly

 drivers/scsi/scsi_common.c             |  58 +++++
 drivers/scsi/scsi_error.c              |  58 -----
 drivers/target/target_core_spc.c       |  31 +--
 drivers/target/target_core_transport.c | 398 ++++++++++++---------------------
 include/scsi/scsi_common.h             |   3 +
 include/scsi/scsi_eh.h                 |   4 +-
 include/target/target_core_base.h      |   9 +-
 7 files changed, 212 insertions(+), 349 deletions(-)

-- 
1.8.4.3

