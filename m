Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC52A378D74
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 11:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780401544; cv=none; b=iQjX3viWYFZoBdpEbLPOIDtIKpYm4rv2G4ss5Kr/3WpW7OqC8bywkarFwtu6weRwA3djNLb6P2lp3dvbGutqkdIWegVHQJ7wL8LTTyGGOpdKQ43cDpm8THvYmKTag7qxhpy3zWNmJ2YLZRTp+rQIzZN2rB8qR57gRhQwL9wmp5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780401544; c=relaxed/simple;
	bh=MM2qSn9gpWfxRLXOEVLvuOaUdZ7iwZYANO1cAWdPEoI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B2uUgjmLNLjenZQO4y9y1FuXDrMKGtgnejInZ8rMYfpm9TnyQQY8T3jldoGtCSs8KHwtzuGNVARBBrmkD4ZhfOV4BU8bgOdJs1yCT89eccdw93tY6F9IZGlAcffqOWfREAj36uuXg9y8U3g42eaO68XRd3HRaGquTxtcpwiGbuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=X89mYCAy; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8bUhL/MX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EvLfPknn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3Ts8eAl7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="X89mYCAy";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8bUhL/MX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EvLfPknn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3Ts8eAl7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F12636814D;
	Tue,  2 Jun 2026 11:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780401540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=AvUNf0GpbjtAaTVlupRs1LvbrUSj1uvZ3+UYsgsO3SQ=;
	b=X89mYCAyX9APqTCCHdtwfc2Zw/lKjhA0sBjdLWPJbkRNaRURBz9+jeVh5MjINw0H9G9cuW
	cOuuegqxQkgkTHaL+H499Hzzvc3/P/6/dkyrQdvntsICottHziYe1roC7WB/k0NJZ16C4r
	0afCTxKFC+EC+HuxuE5Xe/G8Esn/QXo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780401540;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=AvUNf0GpbjtAaTVlupRs1LvbrUSj1uvZ3+UYsgsO3SQ=;
	b=8bUhL/MXMotoMXZumSkG0kHdtBXsmPGwFmx80le66MYl/gpjJoRZzEW2k4xws4KT2yaZ/o
	5WeNOn6RK3ceMLBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780401538; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=AvUNf0GpbjtAaTVlupRs1LvbrUSj1uvZ3+UYsgsO3SQ=;
	b=EvLfPknnIoWm1yFLrNQNPKcFmwpqGUOcXCRh/Onol3U9GuJPHbK2aKJea8jCsS2yXSzQvy
	lXoZnkmJMBCE8kt8StFMvFNpoI/EM4nse2RWwQF7mgZYDH0uvIq7Te4dfBINPnsD9qBoL2
	IraRvYuLk0oeRvFO6HOfW5tbKac0TOw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780401538;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=AvUNf0GpbjtAaTVlupRs1LvbrUSj1uvZ3+UYsgsO3SQ=;
	b=3Ts8eAl72kumm5BPzllnlKwWb1Vapgd8CmEHsdeK/iHok4i1YqUNcLgtgpohq28QWkFnkZ
	4zR8XH/iab7cMhCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CF260779A7;
	Tue,  2 Jun 2026 11:58:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gdfoIYHFHmpvYQAAD6G6ig
	(envelope-from <ddiss@suse.de>); Tue, 02 Jun 2026 11:58:57 +0000
From: David Disseldorp <ddiss@suse.de>
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH 0/2] scsi: target: fix CHAP_N handling
Date: Tue,  2 Jun 2026 21:43:56 +1000
Message-ID: <20260602115840.26490-1-ddiss@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,sashiko.dev:url,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

The sashiko bot pointed out issues with CHAP_N handling recently, when
reviewing a patch for a separate issue:
https://sashiko.dev/#/patchset/20260521151121.808477-1-hossu.alexandru%40gmail.com
  Since extract_param() unconditionally strips '0x' or '0b' prefixes and
  alters the returned type, wouldn't a valid user with a name like '0xalice' or
  '0bob' have their username mutated to 'alice' or 'ob'?

I believe this behaviour is contrary to the iSCSI spec. I added some simple
libiscsi tests to cover prefix stripping:
https://github.com/sahlberg/libiscsi/pull/472

These patches attempt to fix CHAP_N handling.

----------------------------------------------------------------
David Disseldorp (2):
      scsi: target: add extract_param_str() helper
      scsi: target: fix auth when CHAP_N carries a hex/b64 prefix

 drivers/target/iscsi/iscsi_target_auth.c |  8 ++---
 drivers/target/iscsi/iscsi_target_nego.c | 37 ++++++++++++++++++++++++
 drivers/target/iscsi/iscsi_target_nego.h |  1 +
 3 files changed, 40 insertions(+), 6 deletions(-)

