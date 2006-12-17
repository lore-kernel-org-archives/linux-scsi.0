From: michaelc@cs.wisc.edu
Subject: [PATCH 1/5] fix 2.6.19 data digest calculation bug
Date: Sun, 17 Dec 2006 12:10:24 -0600
Message-ID: <1166379028772-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260AbWLQSKr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Dec 2006 13:10:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Arne Redlich <agr@powerkom-dd.de>, Arne Redlich <arne.redlich@xiranet.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Arne Redlich <agr@powerkom-dd.de>

The transition from crypto_digest_*() to  the crypto_hash_*() family
introduced a bug into the data digest calculation: crypto_hash_update() is
called with the number of S/G elements instead of the S/G lists data size.

Signed-off-by: Arne Redlich <arne.redlich@xiranet.com>
-
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index d0b139c..61e3a61 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -749,7 +749,7 @@ static int iscsi_scsi_data_in(struct isc
 				if (!offset)
 					crypto_hash_update(
 							&tcp_conn->rx_hash,
-							&sg[i], 1);
+							&sg[i], sg[i].length);
 				else
 					partial_sg_digest_update(
 							&tcp_conn->rx_hash,
-- 
1.4.1.1

