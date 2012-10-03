From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] iscsi-target: Bump defaults for nopin_timeout + nopin_response_timeout values
Date: Wed,  3 Oct 2012 23:38:08 +0000
Message-ID: <1349307488-15629-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53547 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab2JCXna (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2012 19:43:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch increases the default for nopin_timeout to 15 seconds (wait
between sending a new NopIN ping) and nopin_response_timeout to 30 seconds
(wait for NopOUT response before failing the connection) in order to avoid
false positives by iSCSI Initiators who are not always able (under load) to
respond to NopIN echo PING requests within the current 5 second window.

False positives have been observed recently using Open-iSCSI code on v3.3.x
with heavy large-block READ workloads over small MTU 1 Gb/sec ports, and
increasing these values to more reasonable defaults significantly reduces
the possibility of false positive NopIN response timeout events under
this specific workload.

Historically these have been set low to initiate connection recovery as
soon as possible if we don't hear a ping back, but for modern v3.x code
on 1 -> 10 Gb/sec ports these new defaults make alot more sense.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Andy Grover <agrover@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>
Cc: stable@vger.kernel.org
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_core.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index ff3f482..2ba9f9b 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -25,10 +25,10 @@
 #define NA_DATAOUT_TIMEOUT_RETRIES	5
 #define NA_DATAOUT_TIMEOUT_RETRIES_MAX	15
 #define NA_DATAOUT_TIMEOUT_RETRIES_MIN	1
-#define NA_NOPIN_TIMEOUT		5
+#define NA_NOPIN_TIMEOUT		15
 #define NA_NOPIN_TIMEOUT_MAX		60
 #define NA_NOPIN_TIMEOUT_MIN		3
-#define NA_NOPIN_RESPONSE_TIMEOUT	5
+#define NA_NOPIN_RESPONSE_TIMEOUT	30
 #define NA_NOPIN_RESPONSE_TIMEOUT_MAX	60
 #define NA_NOPIN_RESPONSE_TIMEOUT_MIN	3
 #define NA_RANDOM_DATAIN_PDU_OFFSETS	0
-- 
1.7.2.5

