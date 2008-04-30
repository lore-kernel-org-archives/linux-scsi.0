From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3/3] iscsi_tcp: Enable any size command
Date: Wed, 30 Apr 2008 11:30:20 +0300
Message-ID: <48182E1C.6020905@panasas.com>
References: <48182A1B.2060102@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:32265 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756687AbYD3Ias (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Apr 2008 04:30:48 -0400
In-Reply-To: <48182A1B.2060102@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>


Let through upto the largest command of 260 defined by the scsi standard.
iscsi core supports this already. Now that the scsi-ml supports it we can
start using large commands.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 72b9b2a..826c97c 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1978,7 +1978,7 @@ static struct iscsi_transport iscsi_tcp_transport = {
 	.host_template		= &iscsi_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
 	.max_conn		= 1,
-	.max_cmd_len		= 16,
+	.max_cmd_len		= SCSI_MAX_VARLEN_CDB_SIZE,
 	/* session management */
 	.create_session		= iscsi_tcp_session_create,
 	.destroy_session	= iscsi_tcp_session_destroy,
-- 
1.5.3.3


