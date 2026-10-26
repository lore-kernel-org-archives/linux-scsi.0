Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793042937;
	b=4RuFzAVLfw6yfQ+DezhM4jmZYysLeoNqh9DMU6vST+Mv9AM/mzXM11NEnUQQHncwSdvV
	 BcsDRJ6Qn5POr0Qpl8tcLGD64sPeF4lMtPgIKy7LCZmOtZhO7jCvvCq6R2UnE/QStGcz8
	 y9y3sbhfojS7gb+4hOHaGe2cZIOQl7sH/ikXLs5eoKPjhdFTUoSM0hOTaCE/WNZ3BFw29
	 epStbtx2FLBM/GLeNB4EYiPpe4YP89VcNk/sS5CEk4rWAh/b+uatRwcBkjXcfeykajggN
	 32yKs6BAIAXPD8N1B3OJ3GBsHhEvv8cAbvEhMvF2oiXe0qNoPBd4aRZ3uENKNsXT6Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793042937;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=v1XQGX54Fnq7sFTrzhJXTUypoJnsjPzpUwFKuGYYgsY=;
	b=MqpcADpKDEaOMgqWoo5A1vvw/eJbcKyUidBvSLoxXMb1Je9H33C2WFNegnwxfjsfMj61
	 DrwpmWF8IG2u2ckSle2/FhPHK00GQ26KaP4MjApaZTaXlRHkVUa1+bH1no/BZWwYZCZFy
	 ZSzmizBbb6aAJZ4rI19oJ7/WqpbfH8/7JbC32nTtkw6GM5TprbRQRMr9iWkQ+9cTZZX5H
	 ojwUY/SCh1gW0NKY3J/x5ZC5fcMWaZfUFgeycEJSnXFmlmVZTVfm/GsVL+ArCTmnFHnp1
	 1I8YfxQherDAAU8LGUv56bOjmUqhoG5Fxep3A3mRAB3WQVsmwEs/6y+kbXq2MuY5+5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ciUeD4ad;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679A4606A322
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 19:28:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 679A4606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ciUeD4ad
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793042936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v1XQGX54Fnq7sFTrzhJXTUypoJnsjPzpUwFKuGYYgsY=;
	b=ciUeD4ad/kGL+IJ+ZSYmy7yNA3I9HUt1rDhzZ2/qHyuN9HrFISt0wqUQH7evyk3MgtVPkF
	wdpHQQ3xx1jgOUKT54BiTCIS+zz+jwtiWo7MoDf1LAWpB4xiugaFQzJddDKBmkwyuZNJhI
	lNaVchSFVtRCFVuWKr9xUmErzv2/1xY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-608-6XCWhfBMM2qgPCI_x5Lgfw-1; Mon,
 26 Oct 2026 15:28:52 -0400
X-MC-Unique: 6XCWhfBMM2qgPCI_x5Lgfw-1
X-Mimecast-MFC-AGG-ID: 6XCWhfBMM2qgPCI_x5Lgfw_1793042931
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 190FF19560B7;
	Mon, 26 Oct 2026 19:28:51 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C6D13767;
	Mon, 26 Oct 2026 19:28:49 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	bvanassche@acm.org,
	michael.christie@oracle.com,
	mlombard@redhat.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v5 2/2] scsi: target: iscsi: Complete an aborted WRITE stuck before the first R2T
Date: Mon, 26 Oct 2026 15:28:35 -0400
Message-ID: <20261026192835.1431767-3-loberman@redhat.com>
In-Reply-To: <20261026192835.1431767-1-loberman@redhat.com>
References: <20261026192835.1431767-1-loberman@redhat.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

A WRITE that arrives with immediate data, and whose data length exceeds
FirstBurstLength, is left in TRANSPORT_WRITE_PENDING by
iscsit_execute_cmd() until the first R2T is built. If a LUN_RESET or
ABORT_TASK from another session sets CMD_T_ABORTED in that window,
iscsit_execute_cmd() returns without sending the R2T.

Nothing then completes the command. No R2T has been sent, so the initiator
cannot legally send more data; no DataOut timer was armed, so the ERL=0
timeout cannot fire either. The command stays in TRANSPORT_WRITE_PENDING
with CMD_T_ABORTED set, and core_tmr_drain_state_list() blocks in
target_put_cmd_and_wait() on it for as long as the connection stays up:

  INFO: task kworker/5:2 blocked for more than 46 seconds.
   target_put_cmd_and_wait+0x6d/0xb0 [target_core_mod]
   core_tmr_drain_state_list+0x2dc/0x380 [target_core_mod]
   core_tmr_lun_reset+0x93/0x1a0 [target_core_mod]

Commit aaa00cc93c1d ("scsi: target/core: Fix TAS handling for aborted
commands") is what left this site with nothing to complete the command.
Before it, transport_check_aborted_status() sent the delayed TASK_ABORTED
status here; that commit replaced the call with a bare CMD_T_ABORTED test
and a return, on the basis that the target core would send TASK_ABORTED
from the ABORT TMF context instead. It became a hang once ABORT and LUN
RESET handling was made synchronous, because the abort path then waits in
target_put_cmd_and_wait() for a fabric completion that no longer comes.

Complete the command here instead. No DataOut path can race with this:
without an R2T the initiator cannot send further data for the command, and
the branch is only reached when no unsolicited DataOut is expected either.
If the connection drops before target_abort_work has run,
iscsit_release_commands_from_conn() will complete the same command again,
which the one-shot guard added in the previous patch makes a no-op.

This was reported against an Oracle RAC cluster on two-session iSCSI LIO
targets, where one node's LUN_RESET aborts WRITEs belonging to the other
node's session. It was not reproducible in a lab, so the diagnosis came
from instrumented kernels in the reporter's environment. Across two hosts,
every stalled command had the same signature: DMA_TO_DEVICE,
TRANSPORT_WRITE_PENDING, CMD_T_ABORTED | CMD_T_TAS, outstanding_r2ts == 0,
write_data_done == first_burst_len, and an empty cmd_r2t_list. 217 of 222
LUN_RESET drains completed in under a second; the rest took 46 to 54
seconds, which is where the hung-task panics came from. One 53.7 second
stall recovered on its own and the host ran for a further 19 hours. The
stall only ever ended when the initiator gave up and dropped the
connection, which let iscsit_release_commands_from_conn() complete the
command.

Fixes: 2c9fa49e100f ("scsi: target/core: Make ABORT and LUN RESET handling synchronous")
Cc: stable@vger.kernel.org
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/target/iscsi/iscsi_target_erl1.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index d8ca06e..c78f312 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <scsi/iscsi_proto.h>
 #include <target/target_core_base.h>
+#include <target/target_core_backend.h>
 #include <target/target_core_fabric.h>
 #include <target/iscsi/iscsi_transport.h>
 
@@ -927,8 +928,18 @@ int iscsit_execute_cmd(struct iscsit_cmd *cmd, int ooo)
 
 			if (!(cmd->cmd_flags &
 					ICF_NON_IMMEDIATE_UNSOLICITED_DATA)) {
-				if (cmd->se_cmd.transport_state & CMD_T_ABORTED)
+				/*
+				 * No R2T has been sent for this command yet,
+				 * so returning here leaves the initiator with
+				 * nothing to send and no DataOut timer armed.
+				 * Complete it, or nothing ever will.
+				 */
+				if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
+					iscsit_stop_dataout_timer(cmd);
+					target_complete_cmd(&cmd->se_cmd,
+							    SAM_STAT_TASK_ABORTED);
 					return 0;
+				}
 
 				iscsit_set_dataout_sequence_values(cmd);
 				conn->conn_transport->iscsit_get_dataout(conn, cmd, false);
-- 
2.43.0

