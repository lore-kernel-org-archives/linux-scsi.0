From: Chris Leech <cleech@redhat.com>
Subject: [PATCH RESEND] iscsi_tcp: consider session state in iscsi_sw_sk_state_check
Date: Thu, 26 Sep 2013 09:09:44 -0700
Message-ID: <1380211784-17306-1-git-send-email-cleech@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033Ab3IZQKB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Sep 2013 12:10:01 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8QGA0CR030498
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2013 12:10:01 -0400
Received: from straylight.hirudinean.org (ovpn-113-134.phx2.redhat.com [10.3.113.134])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r8QG9xco016541
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2013 12:10:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

It seems some iSCSI targets (including the Linux kernel target) close
the TCP connection from the target side immediately after processing a
session logout.

When a TCP FIN comes in right after the iSCSI logout response,
iscsi_sw_sk_state_check sees the local socket as not yet being in
CLOSE_WAIT or CLOSE and logs an error.  But the initiator would close
the connection right after processing the logout response anyway, and
the error is confusing to admins who just requested that the session be
shut down.

This adds a check of the session state, and suppresses the error if we
are in the process of logging out.

Signed-off-by: Chris Leech <cleech@redhat.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 9e2588a..add6d15 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -116,6 +116,7 @@ static inline int iscsi_sw_sk_state_check(struct sock *sk)
 	struct iscsi_conn *conn = sk->sk_user_data;
 
 	if ((sk->sk_state == TCP_CLOSE_WAIT || sk->sk_state == TCP_CLOSE) &&
+	    (conn->session->state != ISCSI_STATE_LOGGING_OUT) &&
 	    !atomic_read(&sk->sk_rmem_alloc)) {
 		ISCSI_SW_TCP_DBG(conn, "TCP_CLOSE|TCP_CLOSE_WAIT\n");
 		iscsi_conn_failure(conn, ISCSI_ERR_TCP_CONN_CLOSE);
-- 
1.8.3.1

