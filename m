Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793018645;
	b=U5pOftlzvYzPXtr7pGfOBN//GrZOPFzEK5Sig0YAue+uOqPzJNhf4M03KHLb+OdIx/Dj
	 xL3d6Dkvi8OD30lSc518MXdW1DU9fKVla04Q99/yKB2GsHpgXbR6fjMgX3wCJLRsN/3UM
	 YeM8nCfykb2xuvC/BII6mxkhl6KRxoT7aGdRu735lofRoo2cp9udBvcrw3Sk3aD2Bz9Dm
	 rBQY5hw+WNBueP8uhxovm0TF/fRT3M+lJ5uA4WpEb43yJKAYtn0VbvHuyb/EAfzOdAAq0
	 zRRebcTUCb7d16SIPwi3SNa7ApY3+cfXuQWgyXU908QMA1so6PZSKoy8MRnttowkx3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793018645;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=elI1N0EXlsXg/Z1aYrnpFW75kl66V6BwjpkweJofPjk=;
	b=5j18mQ2Y+hzCYJcu/TpnGxxAa/JMlgx7UEUUIRjT8GerXt0jBqratzVeqQK/x+Gimfnv
	 d88plQBrDC+g0Evc5HxSZY7COF7RJPHgvV41i9AnS4SIddVcCYPld6spgBDBnK5lrAu5T
	 a6Tg4bpvS632BzGw5JQNbCn6cfqJ5OdZhquV0klebybehYdUSn20THgFhmYwP8nEom2Z5
	 S6Djjck2pGhK1GO99GkU23JY6P/4Yc7Qdyf8t03oaYwBUHsAwtiefMrv4LAbpKvpJYrMM
	 6B4K1zyVQtl5GiD9BOvKMRhwLdDstNiUgdZPSeAODytKOwGEEXRMwKXltTWifOkE0Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=EWzBKPtY;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AF6606A32D
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 12:44:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89AF6606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=EWzBKPtY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793018643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=elI1N0EXlsXg/Z1aYrnpFW75kl66V6BwjpkweJofPjk=;
	b=EWzBKPtYGIb901s/QD0c7LbKNe2Up3ZIzIK+Vt6iQplv92WOnZ036mxQiGjhf0531vlRyq
	IFfU2UJkeujPQEsDgjpi2aXr3nJqLPxsEgIOWKr5hPE1CQ6DdZfNt0bCaXyUbaZfqrkpkl
	0rsLAo1Xf1vcHcgdTwsBe5UXoRmDzAo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-dWbtLQTSPoCJgaiveJKDmw-1; Mon,
 26 Oct 2026 08:43:58 -0400
X-MC-Unique: dWbtLQTSPoCJgaiveJKDmw-1
X-Mimecast-MFC-AGG-ID: dWbtLQTSPoCJgaiveJKDmw_1793018637
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 638B419560BE;
	Mon, 26 Oct 2026 12:43:57 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B0B41956088;
	Mon, 26 Oct 2026 12:43:56 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	mlombard@redhat.com,
	michael.christie@oracle.com,
	bvanassche@acm.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] scsi: target: iscsi: Complete an aborted WRITE when a new R2T would be sent
Date: Mon, 26 Oct 2026 08:43:42 -0400
Message-ID: <20261026124344.745124-3-loberman@redhat.com>
In-Reply-To: <20261026124344.745124-1-loberman@redhat.com>
References: <20261026124344.745124-1-loberman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

iscsit_check_dataout_payload() hands a command to iscsit_get_dataout() to
request the next burst whenever iscsit_check_post_dataout() returns
DATAOUT_SEND_R2T, without checking CMD_T_ABORTED first.

If a TMR aborted the command while the burst that just finished was in
flight, no further DataOut will arrive: the initiator is about to be told
the command was aborted. The CMD_T_ABORTED handling in
__iscsit_check_dataout_hdr() does not cover this, because it only runs
for DataOut PDUs belonging to R2Ts that were already issued, and
outstanding_r2ts has already been decremented to zero for the burst that
completed. The command is left in TRANSPORT_WRITE_PENDING with nothing to
complete it.

Complete it here instead, through iscsit_complete_aborted_cmd() so that
the completion is claimed. target_complete_cmd() on a command that
already has CMD_T_ABORTED set goes to target_cmd_interrupted(), which
queues target_abort_work and returns without setting CMD_T_COMPLETE or
changing t_state. The command therefore stays in TRANSPORT_WRITE_PENDING
and on conn_cmd_list until target_abort_work reaches
iscsit_aborted_task(), and a connection drop in that window would let
iscsit_release_commands_from_conn() complete it a second time. Guard on
outstanding_r2ts so that with MaxOutstandingR2T > 1 the completion is
still left to the last R2T to drain in __iscsit_check_dataout_hdr().

Signed-off-by: Laurence Oberman <loberman@redhat.com>
---

Notes:
    This window was never observed in the field: instrumented kernels on two
    hosts recorded no completions at this site across 300 reset cycles, and
    the reproducer that triggered patch 1 never reached it.  It is closed by
    code inspection, for symmetry with the other paths that can leave an
    aborted WRITE_PENDING command stranded.

 drivers/target/iscsi/iscsi_target.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index aab9237..3dad7f6 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1669,6 +1669,22 @@ iscsit_check_dataout_payload(struct iscsit_cmd *cmd, struct iscsi_data *hdr,
 	if ((rc == DATAOUT_NORMAL) || (rc == DATAOUT_WITHIN_COMMAND_RECOVERY))
 		return 0;
 	else if (rc == DATAOUT_SEND_R2T) {
+		/*
+		 * A new R2T would never be answered for an aborted command.
+		 * The CMD_T_ABORTED handling in __iscsit_check_dataout_hdr()
+		 * does not cover this: it only runs for DataOut PDUs
+		 * belonging to R2Ts that were already issued, and
+		 * iscsit_dataout_update_r2t() has already decremented
+		 * outstanding_r2ts for the burst that just finished.  Guard
+		 * on outstanding_r2ts so that with MaxOutstandingR2T > 1 the
+		 * completion is still left to the last R2T to drain.
+		 */
+		if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
+			if (cmd->outstanding_r2ts < 1)
+				iscsit_complete_aborted_cmd(cmd);
+			return 0;
+		}
+
 		iscsit_set_dataout_sequence_values(cmd);
 		conn->conn_transport->iscsit_get_dataout(conn, cmd, false);
 	} else if (rc == DATAOUT_SEND_TO_TRANSPORT) {
-- 
2.43.0

