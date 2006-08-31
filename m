From: michaelc@cs.wisc.edu
Subject: [PATCH 7/12] iscsi_tcp: update header size during relogin
Date: Thu, 31 Aug 2006 18:09:30 -0400
Message-ID: <1157062184454-git-send-email-michaelc@cs.wisc.edu>
References: <11570621752047-git-send-email-michaelc@cs.wisc.edu> <11570621761945-git-send-email-michaelc@cs.wisc.edu> <11570621781978-git-send-email-michaelc@cs.wisc.edu> <11570621791237-git-send-email-michaelc@cs.wisc.edu> <11570621801879-git-send-email-michaelc@cs.wisc.edu> <11570621821931-git-send-email-michaelc@cs.wisc.edu> <11570621832165-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34950 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932478AbWHaXJ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Aug 2006 19:09:28 -0400
In-Reply-To: <11570621832165-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

When we relogin to a target, we have not yet negotiated digests
so we must reset the hdr_size var.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 79c09ee..f00cf15 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1827,9 +1827,11 @@ static void
 iscsi_tcp_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 
 	iscsi_conn_stop(cls_conn, flag);
 	iscsi_tcp_release_conn(conn);
+	tcp_conn->hdr_size = sizeof(struct iscsi_hdr);
 }
 
 static int
-- 
1.4.1.1

