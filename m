Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C588F4DBD7E
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 12:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780662042; cv=none; b=BoDtraYhrJsa5xYsomsoq5Qc/27bH7RzyJDlJ+WcHd+CGcih83cFxxvwI08mFacjPhyS355rur22e3/PergcqheMtzWPwK+b9hG3xQIqJnF4nTuDzcL6uRTDHL1iyR0cTCGGtcGeDg698Z+6LCabCCJHv9xWDoPdYhf0WvyVGtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780662042; c=relaxed/simple;
	bh=s8X7fJfPvizaaVh2vOxC+h8NT8FVP31inxzVhmh4jJc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ve3BSRUZbDzPNN7MLDWUTl68Yo1tSV9VtSv2RUu/UH/ESmJjWpZ+o/X4P1+umOi52c9z1p0ZJdeCWFP+12HSa5DjeNzMaNRJCzYMltnam/k7NvPz17U7T9d4NTljMQcK/sf3XvqD886DDMy8m4zwjhz7ckD4eOEyEXCPkRtw2Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yCehv5LN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wEFuP1Xr; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mh4pn/PK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7vX3p03a; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yCehv5LN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wEFuP1Xr";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mh4pn/PK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7vX3p03a"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E404F6B352;
	Fri,  5 Jun 2026 12:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780662039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tQmlwYZpK/2REB82M47t3qVpY2ASY84RmO8x/TiRH3o=;
	b=yCehv5LN1qr7JfW1xSp+Av5mRYsQZZr/6NlrZCIv9UXv33Wtf57Rbq6M0N+Gl7BDGvOgMO
	e/ymlaInrGe9L9XDLi7hUUOlfSsljjqtLOfgTSW6vuT/pbqAewQRSjYSmr/Q1aQyEXdecM
	nWFI7hqbIehTiRLfjPK3Eny1653u/3U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780662039;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tQmlwYZpK/2REB82M47t3qVpY2ASY84RmO8x/TiRH3o=;
	b=wEFuP1Xr9Vb/xErQKVKdO3UwlFV25gf+eJ1DWIucxkBcPEH2AtnPLz1vqTsyxmho00Jlyy
	D4JUtTvcXmpibACQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780662037; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tQmlwYZpK/2REB82M47t3qVpY2ASY84RmO8x/TiRH3o=;
	b=mh4pn/PKaH7R4T0EQWGmlVEf0cbZXY3ZzRcabqt8REJrwxrxgFWzdqblEWXsxti2aTRHZm
	/JkQCduDwBqjw7YsBjUFOGR5wphdDLmd3lLIjD/27IQVieijc990+5+mom1jwZG2ds7LCq
	mu4OYQT3UWdxV9oJBbkLxxCd/iH1HqM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780662037;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tQmlwYZpK/2REB82M47t3qVpY2ASY84RmO8x/TiRH3o=;
	b=7vX3p03ad+AkMGKZcaOzegppj00KHAxFUoIxJrfmgdEWnsYC5+gY0NpwkfC86hanHkxGji
	MbdZdArA9nnJ2dCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA818779A8;
	Fri,  5 Jun 2026 12:20:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Y0CfHBS/Imr3TwAAD6G6ig
	(envelope-from <ddiss@suse.de>); Fri, 05 Jun 2026 12:20:36 +0000
From: David Disseldorp <ddiss@suse.de>
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH 0/2] scsi: target: minor CHAP fixes
Date: Fri,  5 Jun 2026 22:16:46 +1000
Message-ID: <20260605122019.24146-1-ddiss@suse.de>
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

These patches resolve a couple of other issues pointed out by the
sashiko bot when reviewing a separate CHAP change:
https://sashiko.dev/#/patchset/20260521151121.808477-1-hossu.alexandru%40gmail.com

Hexadecimal CHAP_I handling appears to have been broken for over a
decade, so another option might be to pull out support for such encoded
values.

----------------------------------------------------------------
David Disseldorp (2):
      scsi: target: fix hexadecimal CHAP_I handling
      scsi: target: use constant-time crypto_memneq for CHAP digests

 drivers/target/iscsi/iscsi_target_auth.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)
