From: michaelc@cs.wisc.edu
Subject: [PATCH 1/7] flush iscsi work before freeing connection
Date: Wed, 28 Feb 2007 17:32:15 -0600
Message-ID: <11727055423762-git-send-email-michaelc@cs.wisc.edu>
References: <1172705541949-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbXB1Xcm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Feb 2007 18:32:42 -0500
In-Reply-To: <1172705541949-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

From: Mike Christie <michaelc@cs.wisc.edu>

It's possible that we call iscsi_xmitworker after iscsi_conn_release
which causes a oops. This patch flushes the workqueue.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 7c75771..6346a91 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1597,6 +1597,9 @@ void iscsi_conn_teardown(struct iscsi_cl
 		wake_up(&conn->ehwait);
 	}
 
+	/* flush queued up work because we free the connection below */
+	scsi_flush_work(session->host);
+
 	spin_lock_bh(&session->lock);
 	kfree(conn->data);
 	kfree(conn->persistent_address);
-- 
1.4.1.1

