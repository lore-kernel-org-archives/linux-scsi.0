Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9914DC53D
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 12:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780662047; cv=none; b=ecigGmznxZnR7woC4GtR8cO9uOWk9EkybFcjQxu8gsjTpRZeh4NkO/TM5fXMVkhHCsYJ5nw5ub0xYSq9GK+M5Oua33uv9h4up2cFxD+JUFdE0WseE5Sq0qMtreCFC7eq4cE1vEnv0JoD62fV8uvi7ty84VPeKve2KO2yFiL6hjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780662047; c=relaxed/simple;
	bh=ibKNO52YGT6WNEblHTxWIVM60UYi/hMbFlTX1NjpUaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXEH0zPHuiQ8SfiB5RrTbqa98TRCJB4GD19NI9jYGHq6RfmOtUcOQY3l5WW9k4TUpZg5aaefZE47SOcfQlglo2bP0HJKaL+HJ65ugJ229BrcjwG215c8LCTEKlCn1T/8rFEl6C8oyV9JxFR8lNVI5UfQa96J8NUEa8eKID+wgms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XDDERx9H; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Xa/EAFdk; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XDDERx9H; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Xa/EAFdk; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XDDERx9H";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Xa/EAFdk";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XDDERx9H";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Xa/EAFdk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CC6AF6B32D;
	Fri,  5 Jun 2026 12:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780662041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=on5GKOOQpZJuM+ohg7G3v4T9lq9wS2TTONgaTri1Y3Q=;
	b=XDDERx9Huw9V18tzVDWOjRSiSOVJKOeeYrgA1guQJkbhv1gWigSURi4/tiKaO0dNnusCM8
	pORnCQB31xYMLVjSBgiI1NiIDW1trre8X9jvkRXuL6wNvabb//bob3ycO2DrphkHjMnfWT
	gb6oz52Tsrg9pCfuGI9E38TXPoYADBw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780662041;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=on5GKOOQpZJuM+ohg7G3v4T9lq9wS2TTONgaTri1Y3Q=;
	b=Xa/EAFdkUjul/Gww2pjjSC3SenmZ1vQ7QlZ7DeWglp689qzjqRrw6OeGlSEfLyp3ilKbtJ
	eZ6LmjA8dm4z7ZBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780662041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=on5GKOOQpZJuM+ohg7G3v4T9lq9wS2TTONgaTri1Y3Q=;
	b=XDDERx9Huw9V18tzVDWOjRSiSOVJKOeeYrgA1guQJkbhv1gWigSURi4/tiKaO0dNnusCM8
	pORnCQB31xYMLVjSBgiI1NiIDW1trre8X9jvkRXuL6wNvabb//bob3ycO2DrphkHjMnfWT
	gb6oz52Tsrg9pCfuGI9E38TXPoYADBw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780662041;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=on5GKOOQpZJuM+ohg7G3v4T9lq9wS2TTONgaTri1Y3Q=;
	b=Xa/EAFdkUjul/Gww2pjjSC3SenmZ1vQ7QlZ7DeWglp689qzjqRrw6OeGlSEfLyp3ilKbtJ
	eZ6LmjA8dm4z7ZBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 68ED1779A8;
	Fri,  5 Jun 2026 12:20:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6CivCBi/Imr3TwAAD6G6ig
	(envelope-from <ddiss@suse.de>); Fri, 05 Jun 2026 12:20:40 +0000
From: David Disseldorp <ddiss@suse.de>
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org,
	David Disseldorp <ddiss@suse.de>
Subject: [PATCH 2/2] scsi: target: use constant-time crypto_memneq for CHAP digests
Date: Fri,  5 Jun 2026 22:16:48 +1000
Message-ID: <20260605122019.24146-3-ddiss@suse.de>
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
X-Spam-Flag: NO
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -6.80

A constant-time memory comparison is more suitable than plain memcmp()
for authentication digest comparison.
CHAP digests use an authenticator-provided random challenge, so any
timing side-channel shouldn't be easily exploitable.

Reported-by: Sashiko (gemini/gemini-3.1-pro-preview)
Link: https://sashiko.dev/#/patchset/20260521151121.808477-1-hossu.alexandru%40gmail.com
Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/iscsi/iscsi_target_auth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index 5858cc3089796..f3c0cdd318300 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -9,6 +9,7 @@
  ******************************************************************************/
 
 #include <crypto/hash.h>
+#include <crypto/utils.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/err.h>
@@ -408,7 +409,7 @@ static int chap_server_compute_hash(
 	pr_debug("[server] %s Server Digest: %s\n",
 		chap->digest_name, response);
 
-	if (memcmp(server_digest, client_digest, chap->digest_size) != 0) {
+	if (crypto_memneq(server_digest, client_digest, chap->digest_size)) {
 		pr_debug("[server] %s Digests do not match!\n\n",
 			chap->digest_name);
 		goto out;
-- 
2.51.0

