Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7193837DEAA
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 12:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780662042; cv=none; b=PLPvQJ+zrjCDtocF+isxa/OvxD+sx+i6l7dssST//ychEe2P8EQtvxfgiMie8aR/5mdgpg/Eub0uDkm5zme0/tDeMPHk7Mx0JRNCTY8u6ZY3NPOQLLZYVP44cN+mNVdlMbXg3/lvxUT9ti1j9cYO1Grz6Pg7+Oxl7vdnEAcF9Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780662042; c=relaxed/simple;
	bh=v6ZdSf9P9gwDpWjFtmwBgKhJ5QJgb+EvZBRBx4VZLoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpPHgqiUDcMYlMgLpHTOR5FS7yrkqG1K8C4TGBNwBSOPZfPQ6JuVMWCzZYGiCYPOTqce6VdZRY31cfbTc0up6ZvjfvQjfH8MpvXx3FnF789OVHmtLWJwqblE3hu2mo4S52h7MmALKcirrIXgfMKMIKUdRXLx2DXOUALXHwpZFnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D7DBF75AF9;
	Fri,  5 Jun 2026 12:20:39 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 73EA7779A9;
	Fri,  5 Jun 2026 12:20:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iH67Cxa/Imr3TwAAD6G6ig
	(envelope-from <ddiss@suse.de>); Fri, 05 Jun 2026 12:20:38 +0000
From: David Disseldorp <ddiss@suse.de>
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org,
	David Disseldorp <ddiss@suse.de>
Subject: [PATCH 1/2] scsi: target: fix hexadecimal CHAP_I handling
Date: Fri,  5 Jun 2026 22:16:47 +1000
Message-ID: <20260605122019.24146-2-ddiss@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260605122019.24146-1-ddiss@suse.de>
References: <20260605122019.24146-1-ddiss@suse.de>
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
X-Rspamd-Queue-Id: D7DBF75AF9
X-Rspamd-Action: no action

A mutual CHAP handshake requires target processing of an initiator-sent
CHAP_I identifier. The RFC 3720 specification states:

  11.1.4.  Challenge Handshake Authentication Protocol (CHAP)
  ...
  CHAP_A=<A> CHAP_I=<I> CHAP_C=<C>
  ...
  Where N, (A,A1,A2), I, C, and R are (correspondingly) the Name,
  Algorithm, Identifier, Challenge, and Response as defined in
  [RFC1994], N is a text string, A,A1,A2, and I are numbers

CHAP_I parsing currently calls extract_param(), which returns the
@identifier string (stripped of any 0b/0B or 0x/0X prefix) and a
@type which indicates DECIMAL, HEX or BASE64 encoding (based on any
stripped prefix).

Any HEX encoded CHAP_I string is further processed via:
  ret = kstrtoul(&identifier[2], 0, &id);
This is incorrect for two reasons:
* The @identifier string has already been stripped of the 0x/0X prefix,
  so skipping the first two bytes omits part of the number.
* The kstrtoul() call specifies a base of 0, which will see
  &identifier[2] parsed as a decimal, unless a '0x' or (octal) '0' is
  erroneously present at that offset.

Fix this by passing the (zero-offset) identifier string to kstrtoul()
along with a base=16 parameter. Also add an explicit error handler for
BASE64 encoding.

Hex-encoded CHAP_I handling can be testing using the libiscsi EncodedI
test linked below.

Reported-by: Sashiko (gemini/gemini-3.1-pro-preview)
Link: https://sashiko.dev/#/patchset/20260521151121.808477-1-hossu.alexandru%40gmail.com
Link: https://github.com/sahlberg/libiscsi/pull/473
Fixes: c3fb804c12bad ("scsi: target: fix hexadecimal CHAP_I handling")
Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/iscsi/iscsi_target_auth.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index a3ad2d244dbee..5858cc3089796 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -438,9 +438,11 @@ static int chap_server_compute_hash(
 	}
 
 	if (type == HEX)
-		ret = kstrtoul(&identifier[2], 0, &id);
+		ret = kstrtoul(identifier, 16, &id);
+	else if (type == DECIMAL)
+		ret = kstrtoul(identifier, 10, &id);
 	else
-		ret = kstrtoul(identifier, 0, &id);
+		ret = -EINVAL;
 
 	if (ret < 0) {
 		pr_err("kstrtoul() failed for CHAP identifier: %d\n", ret);
-- 
2.51.0

