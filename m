Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8ED38F226
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 11:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780401549; cv=none; b=TVT7phz78OO4YxaKUAVm9TEbOpjeMs6FNmCN5AFyVuu4VPo7Ius8/MTzlAxSVnyZDowIWyojlPThfjoJe2FHJ+VFFKtmZ78NSbN4xyyQkIbUTQrjy+29G6l8mVci47k4iO6m2f4uMsVDiSsiyTQoDzJzWlRt3cHLymf7ge75u7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780401549; c=relaxed/simple;
	bh=Pw7j6rikG76+jCwZbryfmOO5D5knUhDkIZv1O24Hn8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZscdTY3Rynfx29v7N3HUXL1wvCGKsjQYAGIE1UmuUwzm3h76ZrdzuOQsKLLaw/2mBrenkbMey10RDVgvltjO5VuceyHKFpGsGyd6llABePox62IGE8mErR70hG3xbzhCM06cJu1gPBmtvC1yUEmkDCzK9rmx9iYBHbM7arSxqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E53686817D;
	Tue,  2 Jun 2026 11:59:00 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 80819779A8;
	Tue,  2 Jun 2026 11:58:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SIHNDoPFHmpvYQAAD6G6ig
	(envelope-from <ddiss@suse.de>); Tue, 02 Jun 2026 11:58:59 +0000
From: David Disseldorp <ddiss@suse.de>
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org,
	David Disseldorp <ddiss@suse.de>
Subject: [PATCH 1/2] scsi: target: add extract_param_str() helper
Date: Tue,  2 Jun 2026 21:43:57 +1000
Message-ID: <20260602115840.26490-2-ddiss@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260602115840.26490-1-ddiss@suse.de>
References: <20260602115840.26490-1-ddiss@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: E53686817D
X-Rspamd-Action: no action

The existing extract_param() helper, detects and strips any hex (0x/0X)
or base64 (0b/0B). This makes sense for some parameters, but not strings
such as CHAP_N.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/iscsi/iscsi_target_nego.c | 37 ++++++++++++++++++++++++
 drivers/target/iscsi/iscsi_target_nego.h |  1 +
 2 files changed, 38 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index b03ed154ca34e..53b17d3cc86c3 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -98,6 +98,43 @@ int extract_param(
 	return 0;
 }
 
+/* same as extract_param() above, but don't interpret any type-prefix */
+int extract_param_str(
+	const char *in_buf,
+	const char *pattern,
+	unsigned int max_length,
+	char *out_buf)
+{
+	char *ptr;
+	int len;
+
+	if (!in_buf || !pattern || !out_buf)
+		return -EINVAL;
+
+	ptr = strstr(in_buf, pattern);
+	if (!ptr)
+		return -ENOENT;
+
+	ptr = strstr(ptr, "=");
+	if (!ptr)
+		return -EINVAL;
+
+	ptr += 1;
+	len = strlen_semi(ptr);
+	if (len < 0)
+		return -EINVAL;
+
+	if (len >= max_length) {
+		pr_err("Length of input: %d exceeds max_length:"
+			" %d\n", len, max_length);
+		return -EINVAL;
+	}
+	memcpy(out_buf, ptr, len);
+	out_buf[len] = '\0';
+
+	return 0;
+}
+
 static struct iscsi_node_auth *iscsi_get_node_auth(struct iscsit_conn *conn)
 {
 	struct iscsi_portal_group *tpg;
diff --git a/drivers/target/iscsi/iscsi_target_nego.h b/drivers/target/iscsi/iscsi_target_nego.h
index e60a46d348352..6b72edd2aef2e 100644
--- a/drivers/target/iscsi/iscsi_target_nego.h
+++ b/drivers/target/iscsi/iscsi_target_nego.h
@@ -13,6 +13,7 @@ struct iscsi_np;
 extern void convert_null_to_semi(char *, int);
 extern int extract_param(const char *, const char *, unsigned int, char *,
 		unsigned char *);
+extern int extract_param_str(const char *, const char *, unsigned int, char *);
 extern int iscsi_target_check_login_request(struct iscsit_conn *,
 		struct iscsi_login *);
 extern int iscsi_target_locate_portal(struct iscsi_np *, struct iscsit_conn *,
-- 
2.51.0

