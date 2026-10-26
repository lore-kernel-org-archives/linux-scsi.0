Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793018647;
	b=izOHyV89+3GPl+Y01qwxJJwIgnMZwgxBb9Ev+X97Gz60R+fhNsIYt9yQu8IsfTs7jBpH
	 giY/CUjFPQW8kEgd88Qxa3QnaPDnyeBEa0AmWKbz7bzgSolLHkwTO/GFg9bTqXG1hzzSp
	 fh789HtodOHWicVuyOcFlCJfHgep/PL9ExAqccSTKH16mwfgQcypykdrBIpkCd10cj9nn
	 wClp3EbFyifIlRshs555+I2o1SqlyMiJv2f4iXESPh6hwBLS392JtFMDoQmKby/IQBeNy
	 5kFn1BeMyG/sygdLUBxKXqCXMcD8f6QXLPn1Lad8gfDt0Y+tmHaMcczGUXwQTC2m/HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793018647;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=NKq4NJIGwERUx0tblSeZZ3ok5k1LIY0k7hdmMw/ozco=;
	b=ug3793+qqb4RmuoEbX/u+Fh+garAARk16wz1L/kd3r/4uXQyCDbABVBXeOYjsiq93JWJ
	 K1qBT0N4i8ItbMm7XtfCkZ2zOI+Aor6QzZyg5uo5hJPrqiD7W74Pqmcy6TNhe0QQt8WFi
	 H+VeKfPFlXq+hUnmfSN6+rM0h1VXfyO7RcR8q06S8ofwk+FVM4la2408kCTK/ZOeOEpq9
	 5bqAiMiYyCfegGjlNmyf4rflzvo8xMlZT7qUS+0VdUUooh3iVbfU3hysi/HUVnyXdc6BV
	 nW6UdXMXFQZq1x0V76Ao8Ep7S7TRWE5rIPjbPgS6Ks0pANzD6jU4NodO6bz7u8wzb8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Ivpgr2Nv;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE8A60A2622
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 12:44:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5CE8A60A2622
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Ivpgr2Nv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793018646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NKq4NJIGwERUx0tblSeZZ3ok5k1LIY0k7hdmMw/ozco=;
	b=Ivpgr2NvqysZ15YGJlPhHU6D45T6qNJzUT28U8PN6Bm6IV2lefjiInY2fku69yaKpMoxNY
	sY3hHNjRPIHDqIwDlEdyAe3RwxaYjTbbGrlhmDwYnJ1t6IFiEP8bwUce3tQZ+OQTZeLvvF
	j1sPaQ3E3cXBRaQsCql3gjnrKm7l+vA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-441-AgNl_qhjMEarIF6sfNvxrw-1; Mon,
 26 Oct 2026 08:44:03 -0400
X-MC-Unique: AgNl_qhjMEarIF6sfNvxrw-1
X-Mimecast-MFC-AGG-ID: AgNl_qhjMEarIF6sfNvxrw_1793018642
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9273195FCD9;
	Mon, 26 Oct 2026 12:44:01 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C9A481956088;
	Mon, 26 Oct 2026 12:44:00 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	mlombard@redhat.com,
	michael.christie@oracle.com,
	bvanassche@acm.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] scsi: target: iscsi: Claim the completion on the DataOut submit path
Date: Mon, 26 Oct 2026 08:43:44 -0400
Message-ID: <20261026124344.745124-5-loberman@redhat.com>
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

When the final DataOut PDU for a WRITE has been received,
iscsit_check_dataout_payload() submits the command with
target_execute_cmd(). For a command that has already been aborted,
target_execute_cmd() calls target_cmd_interrupted() before it touches
t_state, so it queues target_abort_work and returns with the command still
in TRANSPORT_WRITE_PENDING and still on conn_cmd_list, recording nothing to
say that a completion has been started.

A connection drop before target_abort_work reaches iscsit_aborted_task()
then lets iscsit_release_commands_from_conn() complete the command a second
time.

Complete aborted commands through iscsit_complete_aborted_cmd() rather than
handing them to target_execute_cmd(). Both reach target_cmd_interrupted()
and queue target_abort_work; the work target_execute_cmd() does after that
test is not reached for an aborted command either way. The dataout timer
has already been stopped a few lines above, so the helper's call to
iscsit_stop_dataout_timer() is a no-op here.

Fixes: ea87981a0ee8 ("scsi: target: iscsi: Handle abort for WRITE_PENDING cmds")
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---

Notes:
    Not observed in the field; closed by inspection after the review of v2
    pointed out that this site has the same shape as the one in
    __iscsit_check_dataout_hdr().  I have deliberately left Cc: stable off,
    since the window predates d5869dae5080 and has never been seen -- I would
    rather it sat in mainline for a cycle first.  Happy to drop this patch if
    you would prefer the series to stop at patch 3.

 drivers/target/iscsi/iscsi_target.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 83184de..e6113a5 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1699,6 +1699,16 @@ iscsit_check_dataout_payload(struct iscsit_cmd *cmd, struct iscsi_data *hdr,
 		iscsit_stop_dataout_timer(cmd);
 		if (ooo_cmdsn)
 			return 0;
+		/*
+		 * target_execute_cmd() tests CMD_T_ABORTED before it touches
+		 * t_state, so for an aborted command it would queue
+		 * target_abort_work and return with the command still in
+		 * TRANSPORT_WRITE_PENDING and the completion unclaimed.
+		 */
+		if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
+			iscsit_complete_aborted_cmd(cmd);
+			return 0;
+		}
 		target_execute_cmd(&cmd->se_cmd);
 		return 0;
 	} else /* DATAOUT_CANNOT_RECOVER */
-- 
2.43.0

