From: michaelc@cs.wisc.edu
Subject: [PATCH 4/5] IPv6 and Linux iSCSI initiator
Date: Sun, 17 Dec 2006 12:10:27 -0600
Message-ID: <1166379031350-git-send-email-michaelc@cs.wisc.edu>
References: <1166379028772-git-send-email-michaelc@cs.wisc.edu> <11663790303684-git-send-email-michaelc@cs.wisc.edu> <11663790313961-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247AbWLQSKo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Dec 2006 13:10:44 -0500
In-Reply-To: <11663790313961-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

By the way, here's a minor patch to simplify IP address print.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 8889686..4376840 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2044,13 +2044,11 @@ iscsi_tcp_conn_get_param(struct iscsi_cl
 		sk = tcp_conn->sock->sk;
 		if (sk->sk_family == PF_INET) {
 			inet = inet_sk(sk);
-			len = sprintf(buf, "%u.%u.%u.%u\n",
+			len = sprintf(buf, NIPQUAD_FMT "\n",
 				      NIPQUAD(inet->daddr));
 		} else {
 			np = inet6_sk(sk);
-			len = sprintf(buf,
-				"%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x\n",
-				NIP6(np->daddr));
+			len = sprintf(buf, NIP6_FMT "\n", NIP6(np->daddr));
 		}
 		mutex_unlock(&conn->xmitmutex);
 		break;
-- 
1.4.1.1

