From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 19/19] iscsi_tcp: Remove a set-but-not-used variable
Date: Wed, 23 Aug 2017 14:40:09 -0700
Message-ID: <20170823214009.15015-20-bart.vanassche@wdc.com>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:57495 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdHWVoD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 17:44:03 -0400
In-Reply-To: <20170823214009.15015-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Lee Duncan <lduncan@suse.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

This patch avoids that gcc reports the following warning when
building with W=1:

drivers/scsi/iscsi_tcp.c:166:24: warning: variable ?session? set but not used [-Wunused-but-set-variable]

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Lee Duncan <lduncan@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/iscsi_tcp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 4842fc0e809d..4d934d6c3e13 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -163,7 +163,6 @@ static void iscsi_sw_tcp_state_change(struct sock *sk)
 	struct iscsi_tcp_conn *tcp_conn;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn;
 	struct iscsi_conn *conn;
-	struct iscsi_session *session;
 	void (*old_state_change)(struct sock *);
 
 	read_lock_bh(&sk->sk_callback_lock);
@@ -172,7 +171,6 @@ static void iscsi_sw_tcp_state_change(struct sock *sk)
 		read_unlock_bh(&sk->sk_callback_lock);
 		return;
 	}
-	session = conn->session;
 
 	iscsi_sw_sk_state_check(sk);
 
-- 
2.14.0
