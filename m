From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 18/26] target/iscsi: Allocate session IDs from an IDA
Date: Thu, 26 Jul 2018 12:13:49 -0500
Message-ID: <5B5A014D.9060901@redhat.com>
References: <20180621212835.5636-1-willy@infradead.org>
 <20180621212835.5636-19-willy@infradead.org> <5B59FB56.9090901@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080008070200070801020609"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5B59FB56.9090901@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Kees Cook <keescook@chromium.org>, Varun Prakash <varun@chelsio.com>, Sagi Grimberg <sagi@grimberg.me>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, "David S. Miller" <davem@davemloft.net>, Denys Vlasenko <dvlasenk@redhat.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080008070200070801020609
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 07/26/2018 11:48 AM, Mike Christie wrote:
> So I am not sure what we want to do here for your patch since it is not
> adding any new bugs. Just merge your patch now and I can send a fix for
> the above bug over it?

If we want to fix the bug first, then I made the attached patch and I
can submit it.

--------------080008070200070801020609
Content-Type: text/x-patch;
 name="0001-iscsi-target-fix-session-creation-failure-handling.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-iscsi-target-fix-session-creation-failure-handling.patc";
 filename*1="h"

>From 80c495c3d7f4487c1b6f52f70e8ddc74dcb70794 Mon Sep 17 00:00:00 2001
From: Mike Christie <mchristi@redhat.com>
Date: Thu, 26 Jul 2018 12:06:07 -0500
Subject: [PATCH] iscsi target: fix session creation failure handling

The problem is that iscsi_login_zero_tsih_s1 sets conn->sess early in
iscsi_login_set_conn_values. If the function fails later like when we
alloc the idr it does kfree(sess) and leaves the conn->sess pointer set.
iscsi_login_zero_tsih_s1 then returns -Exyz and we then call
iscsi_target_login_sess_out and access the freed memory.

This patch has iscsi_login_zero_tsih_s1 either completely setup the
session or completely tear it down, so later in
iscsi_target_login_sess_out we can just check for it being set to the
connection.
---
 drivers/target/iscsi/iscsi_target_login.c | 35 ++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 9950178..e20d811 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -348,8 +348,7 @@ static int iscsi_login_zero_tsih_s1(
 		pr_err("idr_alloc() for sess_idr failed\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		kfree(sess);
-		return -ENOMEM;
+		goto free_sess;
 	}
 
 	sess->creation_time = get_jiffies_64();
@@ -365,20 +364,28 @@ static int iscsi_login_zero_tsih_s1(
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
 		pr_err("Unable to allocate memory for"
 				" struct iscsi_sess_ops.\n");
-		kfree(sess);
-		return -ENOMEM;
+		goto remove_idr;
 	}
 
 	sess->se_sess = transport_init_session(TARGET_PROT_NORMAL);
 	if (IS_ERR(sess->se_sess)) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		kfree(sess->sess_ops);
-		kfree(sess);
-		return -ENOMEM;
+		goto free_ops;
 	}
 
 	return 0;
+
+free_ops:
+	kfree(sess->sess_ops);
+remove_idr:
+	spin_lock_bh(&sess_idr_lock);
+	idr_remove(&sess_idr, sess->session_index);
+	spin_unlock_bh(&sess_idr_lock);
+free_sess:
+	kfree(sess);
+	conn->sess = NULL;
+	return -ENOMEM;
 }
 
 static int iscsi_login_zero_tsih_s2(
@@ -1161,13 +1168,13 @@ void iscsi_target_login_sess_out(struct iscsi_conn *conn,
 				   ISCSI_LOGIN_STATUS_INIT_ERR);
 	if (!zero_tsih || !conn->sess)
 		goto old_sess_out;
-	if (conn->sess->se_sess)
-		transport_free_session(conn->sess->se_sess);
-	if (conn->sess->session_index != 0) {
-		spin_lock_bh(&sess_idr_lock);
-		idr_remove(&sess_idr, conn->sess->session_index);
-		spin_unlock_bh(&sess_idr_lock);
-	}
+
+	transport_free_session(conn->sess->se_sess);
+
+	spin_lock_bh(&sess_idr_lock);
+	idr_remove(&sess_idr, conn->sess->session_index);
+	spin_unlock_bh(&sess_idr_lock);
+
 	kfree(conn->sess->sess_ops);
 	kfree(conn->sess);
 	conn->sess = NULL;
-- 
1.8.3.1


--------------080008070200070801020609--
