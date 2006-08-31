From: michaelc@cs.wisc.edu
Subject: [PATCH 6/12] iscsi_tcp: fix header resend
Date: Thu, 31 Aug 2006 18:09:29 -0400
Message-ID: <11570621832165-git-send-email-michaelc@cs.wisc.edu>
References: <11570621752047-git-send-email-michaelc@cs.wisc.edu> <11570621761945-git-send-email-michaelc@cs.wisc.edu> <11570621781978-git-send-email-michaelc@cs.wisc.edu> <11570621791237-git-send-email-michaelc@cs.wisc.edu> <11570621801879-git-send-email-michaelc@cs.wisc.edu> <11570621821931-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34438 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932476AbWHaXJ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Aug 2006 19:09:27 -0400
In-Reply-To: <11570621821931-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch built over the last ones fixes a bug in the partial header
resend code, where we add on another 4 bytes to the send length on the resend.
We want just the header plus digest.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 8c9d7b5..79c09ee 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -109,7 +109,7 @@ iscsi_hdr_digest(struct iscsi_conn *conn
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 
 	crypto_digest_digest(tcp_conn->tx_tfm, &buf->sg, 1, crc);
-	buf->sg.length += sizeof(uint32_t);
+	buf->sg.length = tcp_conn->hdr_size;
 }
 
 static inline int
-- 
1.4.1.1

