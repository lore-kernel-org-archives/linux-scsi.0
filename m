Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670523939B5
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 11:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780401555; cv=none; b=nNuA4kQ965hyzjL+yny7qkz4PP8Gk19+P/9EQJJ+QEjwb5T/fkGYZnQgI7IpPti57m15x6/LxqzxwHRJ8TcclJJyi58/bSE1xqrJSej/ccG79FF266WBlXa3OD2DRkc262rZ/noXItHj9lfWA1foDgwC1TifEs6Ypho0Mc9nwZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780401555; c=relaxed/simple;
	bh=C7lEKonZqbiEDVIdl7sDT2ZH2NvVLwiQU1Gl++RI2Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYwMa+gdijd/mnrgjeOsmhaQhpY1aUSwF7+9EhjwTBQm3lwEjZN1eYdok37iryG+WAGVDhnHzPgExqqiwiVps/UFJDOpBKFXerw5Yf/vIwTPPlgUPsC8Aebp66bf+5KFlpIRqb9a2A1BXSeAf4VKRqG3VSOqvuXUWmnCIF0N5cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DB62E68A5F;
	Tue,  2 Jun 2026 11:59:02 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 75B57779A7;
	Tue,  2 Jun 2026 11:59:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oF4TDIXFHmpvYQAAD6G6ig
	(envelope-from <ddiss@suse.de>); Tue, 02 Jun 2026 11:59:01 +0000
From: David Disseldorp <ddiss@suse.de>
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org,
	David Disseldorp <ddiss@suse.de>
Subject: [PATCH 2/2] scsi: target: fix auth when CHAP_N carries a hex/b64 prefix
Date: Tue,  2 Jun 2026 21:43:58 +1000
Message-ID: <20260602115840.26490-3-ddiss@suse.de>
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
X-Rspamd-Queue-Id: DB62E68A5F
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]

Attempting to authenticate using a CHAP username with a '0x' or '0b'
prefix currently fails. This is due to extract_param()'s behaviour of
stripping these prefixes, and the subsequent (type == HEX) error-path.
I believe this behaviour is contrary to the RFC 3720 specification,
which states:

  5.1.  Text Format
  ...
  text-value: A string of zero or more characters that consist of
  letters, digits, dot, minus, plus, commercial at, underscore,
  slash, left bracket, right bracket, or colon.

  11.1.4.  Challenge Handshake Authentication Protocol (CHAP)
  ...
    CHAP_A=<A> CHAP_I=<I> CHAP_C=<C>

   Where A is one of A1,A2... that were proposed by the initiator.

   In the third step, the initiator MUST continue with:

      CHAP_N=<N> CHAP_R=<R>
   ...
   Where N, (A,A1,A2), I, C, and R are (correspondingly) the Name,
   Algorithm, Identifier, Challenge, and Response as defined in
   [RFC1994], N is a text string, A,A1,A2, and I are numbers, and C and
   R are large-binary-values ...

"N is a text string" implies that any hex or base64 encoding prefix
should not be interpreted or stripped. Fix this by using the new
extract_param_str() helper function to obtain the CHAP_N value as-is.

Reported-by: Sashiko (gemini/gemini-3.1-pro-preview)
Link: https://sashiko.dev/#/patchset/20260521151121.808477-1-hossu.alexandru%40gmail.com
Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/iscsi/iscsi_target_auth.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index a3ad2d244dbee..6f21075e58416 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -303,12 +303,8 @@ static int chap_server_compute_hash(
 	/*
 	 * Extract CHAP_N.
 	 */
-	if (extract_param(nr_in_ptr, "CHAP_N", MAX_CHAP_N_SIZE, chap_n,
-				&type) < 0) {
-		pr_err("Could not find CHAP_N.\n");
-		goto out;
-	}
-	if (type == HEX) {
+	ret = extract_param_str(nr_in_ptr, "CHAP_N", MAX_CHAP_N_SIZE, chap_n);
+	if (ret < 0) {
 		pr_err("Could not find CHAP_N.\n");
 		goto out;
 	}
-- 
2.51.0

