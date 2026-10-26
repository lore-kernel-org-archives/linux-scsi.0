Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793027248;
	b=GzIu9dj422vftgG4SlSsh4EFmsZlzBg3An9sW1S3IZpFwOysuFT4UeIogXfO3Gv+E9zu
	 Z1qYN1LZPc2Y4MVF7/0R76msSLiTmlKzNIQQPmcIfuq4i/f4tuzgCkXcBH5HEbn8pamah
	 8Og7dw4qy9wHXzzdPFya0k07hsrj0lpQljPPD6djBGZWyM0jjS79U3khoWyIeIHKngFxz
	 t4kLGApj1aZ4XtcVEepB7vI+cMmqnaxSPg4p+JPdgTrX3tSXBOx5lwFgZ7w/yT7DoHOJu
	 miNdGyo+TyRfRkPms5NKBTIziO1DoeF8O7EovFq7Ft9mizpg2gaVMz9N6++YZr+RiyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793027248;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=REua7KH6IzqESw+dc1GH0ozo9MSXSLf0MZPuygQgD+o=;
	b=zUkl4fv/rOpstvRfoBf3YdBBUQQh3THmkLMCjUzAM7wpF52iGuKA3hhlNoRdqgeESOwO
	 vRicf+NqydWE0KXrJ5L0vfnWu1+x21UkHMlrSwIn4Dzdi2BsDf7am7uHii2SoHpuxKNbK
	 2pYX5u9Qp0g6NNk/kqwwlmG3jSw0EbF1eHmF4NesSzQsIazmTm252yniRgQAsSgWnEEiZ
	 TDR13uTvnGK2lYyct1Iozjn9EGEcCEM3sKRn4ZvUJ0OWA6WMYUAUbyIPrN9DL50yNJbgw
	 7rcByE17DcNT226CbiLWOJuzoz5XlGqiwM+5llDcHTY5B1S4NstSEUzirSzYK8hRa/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AOl4TA5V;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78DF606A31E
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 15:07:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B78DF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AOl4TA5V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793027246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=REua7KH6IzqESw+dc1GH0ozo9MSXSLf0MZPuygQgD+o=;
	b=AOl4TA5V3WCbV9pdbMHSxYqmVzVv2RSBWwkG02m16DRl3//FqavFYOx9Wom2ktMHxObkac
	aZSDTfAcXY/V/4hRtNks8knq7niKtvjK7uknqz6EtvahhXJhXFJSP26LUKJ9Kce8yfVJO9
	ZNX3pZxvzew+TgpX4mBtfhfGq0nfhco=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-177-rEc73xqDM2mbStcMOOazzg-1; Mon,
 26 Oct 2026 11:07:23 -0400
X-MC-Unique: rEc73xqDM2mbStcMOOazzg-1
X-Mimecast-MFC-AGG-ID: rEc73xqDM2mbStcMOOazzg_1793027242
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 218501801329;
	Mon, 26 Oct 2026 15:07:22 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D7EA30000E7;
	Mon, 26 Oct 2026 15:07:20 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	mlombard@redhat.com,
	michael.christie@oracle.com,
	bvanassche@acm.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/3] scsi: target: iscsi: Claim the completion on the DataOut submit path
Date: Mon, 26 Oct 2026 11:07:10 -0400
Message-ID: <20261026150710.1063511-4-loberman@redhat.com>
In-Reply-To: <20261026150710.1063511-1-loberman@redhat.com>
References: <20261026150710.1063511-1-loberman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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
    rather it sat in mainline for a cycle first.
    
    The review of v3 noted that CMD_T_ABORTED can still be set between this
    check and target_cmd_interrupted() inside target_execute_cmd(), leaving the
    completion unclaimed.  That is true, and it is the pre-existing behaviour
    for every aborted command on this path today; this patch narrows the window
    rather than closing it.  Closing it properly needs the one-shot guard to
    live in target_cmd_interrupted() under t_state_lock, which is the same lock
    __target_check_io_state() sets CMD_T_ABORTED under.  See the cover letter.
    
    Happy to drop this patch if you would prefer the series to stop at patch 2.

 drivers/target/iscsi/iscsi_target.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 1db6051..9341565 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1683,6 +1683,16 @@ iscsit_check_dataout_payload(struct iscsit_cmd *cmd, struct iscsi_data *hdr,
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

