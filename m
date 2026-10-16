Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5A459B680
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 17:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792173247; cv=none; b=HRUxyw+2RVyizvhexT/q2zIiaJEb6gOcV1beDGB6jyZu1RLSreTcVuQ2TJAzMQQ6gAxjTyQXWLsgWCY7xXwtu9TC5/kuhm3SUd243DuF6/Q+/v9c6p4DvDL+MCV4NmZh9UZ55BPAqJl0xEHtuiWnUsSui1cH4kcn+rhDcVijkqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792173247; c=relaxed/simple;
	bh=sHCYLZ9xSWBkQr8pzpR13/VT/tve1OJw7QUbTZd0epU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IatEfH24f9Orw02fViB2zkhewHk0aibkPgIYtHlfD2FKA7dCrCsoxuO3aow0457AYaLvBFJ0Mqdu0dxAEajvSC19GSrSOQ/Oo1LfjnaTPvjtprNX9kVH3b+B3rLsnstjQIYaQ+1i73iV2OC0ETaejKcH0XiBqsWQ35T4MpPsN1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=USy9NRyU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="USy9NRyU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792173245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0lXIRMscvUJxsAZizeQ/QDc99J746n3E9R59eq54yNw=;
	b=USy9NRyUh8ZVdR8EtLkZUjD2eeajTKVdzahJtw7Yjes76Ync6Z3OkrtXHZeJPIQ15pc9tn
	/Wsgb3rpWd2VyzmKmjW3ICHRpepzlZwZP8OAoQdntlJO1X0dfJsARO7iE1UUGIrbbIy5w1
	TeuH4NfV23nK+55spKg/Xcvq2sCm7Go=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-592-Ad8lKG5IP_Oz_A_jwI7iLQ-1; Fri,
 16 Oct 2026 17:54:01 +0000
X-MC-Unique: Ad8lKG5IP_Oz_A_jwI7iLQ-1
X-Mimecast-MFC-AGG-ID: Ad8lKG5IP_Oz_A_jwI7iLQ_1792173240
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 945711800473;
	Fri, 16 Oct 2026 17:54:00 +0000 (UTC)
Received: from loberman-thinkpadp1gen5.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6CC821800257;
	Fri, 16 Oct 2026 17:53:59 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	mlombard@redhat.com,
	michael.christie@oracle.com,
	linux-kernel@vger.kernel.org,
	Laurence Oberman <loberman@redhat.com>
Subject: [PATCH v2 2/2] scsi: target: iscsi: Complete an aborted WRITE when a new R2T would be sent
Date: Fri, 16 Oct 2026 13:53:35 -0400
Message-ID: <20261016175351.126373-3-loberman@redhat.com>
In-Reply-To: <20261016175351.126373-1-loberman@redhat.com>
References: <20261016175351.126373-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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

Unlike patch 1 of this series, this window was never observed in the
field: instrumented kernels on two hosts recorded no completions at this
site across 300 reset cycles, and the reproducer that triggered the other
one never reached it. It is closed by code inspection, for symmetry with
the other paths that can leave an aborted WRITE_PENDING command stranded.

Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index aab9237a6776..3dad7f69f3ba 100644
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
2.52.0

