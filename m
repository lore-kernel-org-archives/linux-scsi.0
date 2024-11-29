Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DA71547FF;
	Fri, 29 Nov 2024 15:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732894358; cv=none; b=lp0sthecJoekjV0rNVYUnZT4w3jtfOdmDEMhwKSwqsr4+Ulo7RbUKWqIZ042NfvdwNwZ8qH6VeT4y5246zy5F40nHMjd2h7Hib6dvW6eMaRZnx4v5W4YfsqnOVVDB3JAMx4Z1qm/0wQNeJBrosZ7FfRXgIDqtGH8ydt4xIeRXtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732894358; c=relaxed/simple;
	bh=VrhFujK3TBWPxvTFib0zPaN4Z/2PEWXxrZvg74n6SVk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y3BEk4qBs5tWniQoZHVk1SVBk8r0c+tgASG96EH+uF0OUFPbSrsPd6HOVaNPc0R5Gz1y3nQOn51KAcB1aIMgyZVITwF/pdub7J8uouzRUzaiqzIKdyRr9hb3rhuxodbNqPZVdkMcDAbGEyV6AiJaGugXk1lD4pV1wBja4RgeYgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=GumbUU1F; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=sfUDoJO5; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="GumbUU1F";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="sfUDoJO5"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 263BAE0002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1732894351; bh=iOkZZihoky5F7+j/6rD91YiYTpiFZSdXLxE6f8NE9oo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=GumbUU1F7NotqFas7Cpiq9jCAtVJcTRyXdjhkzaRoWnSmSkwz3zXhL+aPiX7BMZL4
	 OSGjl2GdbMrqVuxztYOdolx0G/4SKN0mzNO0nmi/+g57xfdeY/DexjjG5yhCO/4RbV
	 omL4f12I4HOCzef4RJxIk8IgUT8olQt0MmlScyz8F2s4G6BVsNxwFdEajer88DUiyC
	 zgysJOk33h165xeDC0rM7RDI3qcd2aMDk523R9bGESdqbtRYCbboKID3hgsC5FTdYx
	 UbmU3P6p00cLGgA39pmi1wCNhXVvHrlPfWEX7aHEiPDymqjr2XGmiwPJKaU7UH8wHd
	 dcOCJju+bPrYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1732894351; bh=iOkZZihoky5F7+j/6rD91YiYTpiFZSdXLxE6f8NE9oo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=sfUDoJO5OaQLBzAtdgpHaIi/limV1mw9yK8nvyAXp5ySV+xXV+iGyNn/SEEXTDukU
	 NmZUUZMFEyyRDnamlxHu21tAmIC19r49Hc0l4n/MsB9ztw7JwksK5VJ76T1z5hNk1g
	 iinzrNySfDBjMlyQgBeDbyW4Hsy+w6QqOp4ZPvNb0ZyamWbPZrkebFvscIDZ7VD69P
	 0L952JXoYGx9u9wV29XQXQH9oPw6del/eHI6OlbdNHEkZLKkidg+tF7tHqxfP32zOS
	 ZqF4j1iF9Zyfcse8g3L8jTthIEd4eFQi3tvkn05K9p2VynmlQyMbHb5vhvavWExTUI
	 bmJzj9ohYcnGw==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <martin.petersen@oracle.com>, <bootc@bootc.net>, <bostroesser@gmail.com>,
	<michael.christie@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
	<linux@yadro.com>
Subject: [PATCH 09/10] target: Use __func__ in logs
Date: Fri, 29 Nov 2024 18:30:55 +0300
Message-ID: <20241129153056.6985-10-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.3
In-Reply-To: <20241129153056.6985-1-a.kovaleva@yadro.com>
References: <20241129153056.6985-1-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-Exch-05.corp.yadro.com (172.17.10.109) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

Replace hardcoded function names in log messages with __func__ macro.

Reviewed-by: Dmitriy Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c |  2 +-
 drivers/target/iscsi/iscsi_target_nego.c     | 24 ++++++++++----------
 drivers/target/iscsi/iscsi_target_util.c     |  2 +-
 drivers/target/sbp/sbp_target.c              | 12 +++++-----
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 14c95c38d002..2a35dbc1a6e3 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1518,7 +1518,7 @@ static void lio_release_cmd(struct se_cmd *se_cmd)
 {
 	struct iscsit_cmd *cmd = container_of(se_cmd, struct iscsit_cmd, se_cmd);
 
-	target_debug("Entering lio_release_cmd for se_cmd: %p\n", se_cmd);
+	target_debug("Entering %s() for se_cmd: %p\n", __func__, se_cmd);
 	iscsit_release_cmd(cmd);
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 2af5ca83ab67..91cd365294df 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -375,7 +375,7 @@ static void iscsi_target_sk_data_ready(struct sock *sk)
 	bool rc;
 
 	trace_sk_data_ready(sk);
-	target_debug("Entering iscsi_target_sk_data_ready: conn: %p\n", conn);
+	target_debug("Entering %s(): conn: %p\n", __func__, conn);
 
 	write_lock_bh(&sk->sk_callback_lock);
 	if (!sk->sk_user_data) {
@@ -403,7 +403,7 @@ static void iscsi_target_sk_data_ready(struct sock *sk)
 
 	rc = schedule_delayed_work(&conn->login_work, 0);
 	if (!rc) {
-		target_debug("iscsi_target_sk_data_ready, schedule_delayed_work got false\n");
+		target_debug("%s(): schedule_delayed_work got false\n", __func__);
 	}
 	write_unlock_bh(&sk->sk_callback_lock);
 }
@@ -418,7 +418,7 @@ static void iscsi_target_set_sock_callbacks(struct iscsit_conn *conn)
 		return;
 
 	sk = conn->sock->sk;
-	target_debug("Entering iscsi_target_set_sock_callbacks: conn: %p\n", conn);
+	target_debug("Entering %s(): conn: %p\n", __func__, conn);
 
 	write_lock_bh(&sk->sk_callback_lock);
 	sk->sk_user_data = conn;
@@ -440,7 +440,7 @@ static void iscsi_target_restore_sock_callbacks(struct iscsit_conn *conn)
 		return;
 
 	sk = conn->sock->sk;
-	target_debug("Entering iscsi_target_restore_sock_callbacks: conn: %p\n", conn);
+	target_debug("Entering %s(): conn: %p\n", __func__, conn);
 
 	write_lock_bh(&sk->sk_callback_lock);
 	if (!sk->sk_user_data) {
@@ -461,7 +461,7 @@ static int iscsi_target_do_login(struct iscsit_conn *, struct iscsi_login *);
 static bool __iscsi_target_sk_check_close(struct sock *sk)
 {
 	if (sk->sk_state == TCP_CLOSE_WAIT || sk->sk_state == TCP_CLOSE) {
-		target_debug("__iscsi_target_sk_check_close: TCP_CLOSE_WAIT|TCP_CLOSE,returning TRUE\n");
+		target_debug("%s(): TCP_CLOSE_WAIT|TCP_CLOSE, returning TRUE\n", __func__);
 		return true;
 	}
 	return false;
@@ -533,7 +533,7 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	int rc, zero_tsih = login->zero_tsih;
 	bool state;
 
-	target_debug("entering iscsi_target_do_login_rx, conn: %p, %s:%d\n", conn, current->comm,
+	target_debug("Entering %s(), conn: %p, %s:%d\n", __func__, conn, current->comm,
 		     current->pid);
 
 	spin_lock(&conn->login_worker_lock);
@@ -559,12 +559,12 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	spin_unlock(&tpg->tpg_state_lock);
 
 	if (!state) {
-		target_debug("iscsi_target_do_login_rx: tpg_state != TPG_STATE_ACTIVE\n");
+		target_debug("%s(): tpg_state != TPG_STATE_ACTIVE\n", __func__);
 		goto err;
 	}
 
 	if (iscsi_target_sk_check_close(conn)) {
-		target_debug("iscsi_target_do_login_rx, TCP state CLOSE\n");
+		target_debug("%s(): TCP state CLOSE\n", __func__);
 		goto err;
 	}
 
@@ -572,7 +572,7 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	rc = iscsit_set_login_timer_kworker(conn, current);
 	if (rc < 0) {
 		/* The login timer has already expired */
-		target_debug("iscsi_target_do_login_rx, login failed\n");
+		target_debug("%s(): login failed\n", __func__);
 		goto err;
 	}
 
@@ -582,7 +582,7 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	if (rc < 0)
 		goto err;
 
-	target_debug("iscsi_target_do_login_rx after rx_login_io, %p, %s:%d\n", conn, current->comm,
+	target_debug("%s(): after rx_login_io, %p, %s:%d\n", __func__, conn, current->comm,
 		     current->pid);
 
 	/*
@@ -646,7 +646,7 @@ static void iscsi_target_sk_state_change(struct sock *sk)
 	void (*orig_state_change)(struct sock *);
 	bool state;
 
-	target_debug("Entering iscsi_target_sk_state_change\n");
+	target_debug("Entering %s()\n", __func__);
 
 	write_lock_bh(&sk->sk_callback_lock);
 	conn = sk->sk_user_data;
@@ -697,7 +697,7 @@ static void iscsi_target_sk_state_change(struct sock *sk)
 	 * the remaining iscsi connection resources.
 	 */
 	if (state) {
-		target_debug("iscsi_target_sk_state_change got failed state\n");
+		target_debug("%s() got failed state\n", __func__);
 		set_bit(LOGIN_FLAGS_CLOSED, &conn->login_flags);
 		state = test_bit(LOGIN_FLAGS_INITIAL_PDU, &conn->login_flags);
 		write_unlock_bh(&sk->sk_callback_lock);
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 01d74ae5fa96..a5ddec6b08f2 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -1031,7 +1031,7 @@ void iscsit_login_timeout(struct timer_list *t)
 	struct iscsit_conn *conn = from_timer(conn, t, login_timer);
 	struct iscsi_login *login = conn->login;
 
-	target_debug("Entering iscsi_target_login_timeout >>>>>>>>>>>>>>>>>>>\n");
+	target_debug("Entering %s() >>>>>>>>>>>>>>>>>>>\n", __func__);
 
 	spin_lock_bh(&conn->login_timer_lock);
 	login->login_failed = 1;
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 868ddda4dcf3..6bd7eced72ac 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1115,7 +1115,7 @@ static int sbp_fetch_command(struct sbp_target_request *req)
 		min_t(int, cmd_len, sizeof(req->orb.command_block)));
 
 	if (cmd_len > sizeof(req->orb.command_block)) {
-		target_debug("sbp_fetch_command: filling in long command\n");
+		target_debug("%s(): filling in long command\n", __func__);
 		copy_len = cmd_len - sizeof(req->orb.command_block);
 
 		ret = sbp_run_request_transaction(req,
@@ -1194,20 +1194,20 @@ static void sbp_handle_command(struct sbp_target_request *req)
 
 	ret = sbp_fetch_command(req);
 	if (ret) {
-		target_debug("sbp_handle_command: fetch command failed: %d\n", ret);
+		target_debug("%s(): fetch command failed: %d\n", __func__, ret);
 		goto err;
 	}
 
 	ret = sbp_fetch_page_table(req);
 	if (ret) {
-		target_debug("sbp_handle_command: fetch page table failed: %d\n", ret);
+		target_debug("%s(): fetch page table failed: %d\n", __func__, ret);
 		goto err;
 	}
 
 	unpacked_lun = req->login->login_lun;
 	sbp_calc_data_length_direction(req, &data_length, &data_dir);
 
-	target_debug("sbp_handle_command ORB:0x%llx unpacked_lun:%d data_len:%d data_dir:%d\n",
+	target_debug("%s(): ORB:0x%llx unpacked_lun:%d data_len:%d data_dir:%d\n", __func__,
 		     req->orb_pointer, unpacked_lun, data_length, data_dir);
 
 	/* only used for printk until we do TMRs */
@@ -1329,12 +1329,12 @@ static int sbp_send_status(struct sbp_target_request *req)
 	rc = sbp_run_request_transaction(req, TCODE_WRITE_BLOCK_REQUEST,
 			login->status_fifo_addr, &req->status, length);
 	if (rc != RCODE_COMPLETE) {
-		target_debug("sbp_send_status: write failed: 0x%x\n", rc);
+		target_debug("%s(): write failed: 0x%x\n", __func__, rc);
 		ret = -EIO;
 		goto put_ref;
 	}
 
-	target_debug("sbp_send_status: status write complete for ORB: 0x%llx\n", req->orb_pointer);
+	target_debug("%s(): status write complete for ORB: 0x%llx\n", __func__, req->orb_pointer);
 	/*
 	 * Drop the extra ACK_KREF reference taken by target_submit_cmd()
 	 * ahead of sbp_check_stop_free() -> transport_generic_free_cmd()
-- 
2.40.3

