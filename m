Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494CE528427
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 14:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791988790; cv=none; b=N6czdhzokCbheriRFcBsN0Lflw/CTiFUQhu0Db7JPzDyloO+PJef443BOL5P5s6oOPkaif4OkYzG/qJdtmxMcTAB9JAVFwdgBekrGFkai7u/3CrX+bf9XcS63zpbSaxfg8x/AMb5JvgXJcpdDwilFBxHorEv2ODfGA+hz96fi60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791988790; c=relaxed/simple;
	bh=L8yuWP1um1m10JtCvaDiTG/3gmbW11ND2LJ/f9puSII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Um3KPRKxu9R4HEkrhjnFl+jVQAVH/Wkly29rDfZnY+X4kV0rcwOBTQhPnzFpzLKPNmMuqviryEp17ToZkwxTcMqBDe+QPmH92Dnv9WFBIa1ny3qvlWdYEl0C8UuwZ3z6NCVKuLCxkSEO4UKqZqiZv8hiOOJOze7NHhvhYsF8TIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ewTbwM+X; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ewTbwM+X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791988788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iN4EeWlz+4eRNRQ580UwjDJL/0ZTFH3itUTxdfeRYxg=;
	b=ewTbwM+XVSXrswZehwyHM8FdbGfiaJsLdngrUgWIxqeYGs2h5IurG4E+mV2aYE/btRAho0
	9DMLSobF3RJ8nhz8HZBCIIwDyZ1bxXTmoG1WiOefb1HhFrkpYUW0yM1jWRgKrCATwwbG31
	/I7pd0DFca8gX0d2hpAHjZwazougBfk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-ZuLLoRreNMGjxkpCBCnSCw-1; Wed,
 14 Oct 2026 14:39:44 +0000
X-MC-Unique: ZuLLoRreNMGjxkpCBCnSCw-1
X-Mimecast-MFC-AGG-ID: ZuLLoRreNMGjxkpCBCnSCw_1791988782
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 98F4D19560A2;
	Wed, 14 Oct 2026 14:39:42 +0000 (UTC)
Received: from loberman-thinkpadp1gen5.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7B2AD195608E;
	Wed, 14 Oct 2026 14:39:41 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	mlombard@redhat.com,
	michael.christie@oracle.com,
	linux-kernel@vger.kernel.org,
	Laurence Oberman <loberman@redhat.com>
Subject: [PATCH 2/2] scsi: target: iscsi: Complete an aborted WRITE when a new R2T would be sent
Date: Wed, 14 Oct 2026 10:39:32 -0400
Message-ID: <20261014143932.39453-3-loberman@redhat.com>
In-Reply-To: <20261014143932.39453-1-loberman@redhat.com>
References: <20261014143932.39453-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 127.0.0.2

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

Complete it here instead. Guard on outstanding_r2ts so that with
MaxOutstandingR2T > 1 the completion is still left to the last R2T to
drain in __iscsit_check_dataout_hdr().

Unlike patch 1 of this series, this window was never observed in the
field: instrumented kernels on two hosts recorded no completions at this
site across 300 reset cycles, and the reproducer that triggered the other
one never reached it. It is closed by code inspection, for symmetry with
the other paths that can leave an aborted WRITE_PENDING command stranded.

Assisted-by: Claude LLM
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index aab9237a6776..87b215b18034 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1669,6 +1669,25 @@ iscsit_check_dataout_payload(struct iscsit_cmd *cmd, struct iscsi_data *hdr,
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
+			if (cmd->outstanding_r2ts < 1) {
+				iscsit_stop_dataout_timer(cmd);
+				target_complete_cmd(&cmd->se_cmd,
+						    SAM_STAT_TASK_ABORTED);
+			}
+			return 0;
+		}
+
 		iscsit_set_dataout_sequence_values(cmd);
 		conn->conn_transport->iscsit_get_dataout(conn, cmd, false);
 	} else if (rc == DATAOUT_SEND_TO_TRANSPORT) {
-- 
2.52.0

