From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] lio-target: Enable crc32c_x86_offload=1 by default
Date: Thu, 16 Sep 2010 13:22:59 -0700
Message-ID: <1284668579-10260-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp102.sbc.mail.ne1.yahoo.com ([98.138.84.213]:27588 "HELO
	smtp102.sbc.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753907Ab0IPUXE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2010 16:23:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes
Cc: James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Douglas Gilbert <dgilbert@interlog.com>, Joe Eykholt <jeykholt@cisco.com>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This patch enables the default usage of the SSE v4.2 CRC32C instruction
for iSCSI target HeaderDigests and DataDigests offload using libcrypto and
the crc32c-intel.ko module on Nehalem systems.  This was originally disabled
by default in commit 047eeb75ee8f0 due to some issues with HeaderDigests=CRC32C
that where encountered with the Open-iSCSI initiator shipping with RHEL 6 B1.
This has now been identified as initiator side breakage, so we go ahead and
enable crc32c_x86_offload=1 by default when available.

Many thanks again to Mike Christie for verifying the Open-iSCSI side issue!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/lio-target/iscsi_target_core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/lio-target/iscsi_target_core.h b/drivers/target/lio-target/iscsi_target_core.h
index de962c8..882bd52 100644
--- a/drivers/target/lio-target/iscsi_target_core.h
+++ b/drivers/target/lio-target/iscsi_target_core.h
@@ -84,7 +84,7 @@
 /* Disabled by default in production mode w/ explict ACLs */
 #define TA_PROD_MODE_WRITE_PROTECT	0
 /* Disabled by default for the moment for testing... */
-#define TA_CRC32C_X86_OFFLOAD		0
+#define TA_CRC32C_X86_OFFLOAD		1
 #define TA_CACHE_CORE_NPS		0
 
 /* struct iscsi_data_count->type */
-- 
1.5.6.5

