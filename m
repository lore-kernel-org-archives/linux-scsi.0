Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792575381;
	b=sKTtWE4tD2qNUxv+5Y6GdJBQxhDncUiCwz4Kxe/SGdgz/05mU5UzqM045xV23aPQXTIj
	 o+uwHGqlGrtdJwrYwQlXIa+JhfSk26IZDccVksAgL85gP4LhLo6VkHrjvNuIUgTdbJhTL
	 h7JOp45Ddcdiu5kEgiwfg62BVAPjBu1vVD/ORO8dYTtNysE9aK9+74IIYDdYF6Szy62jC
	 9P764dXgt4scblah3m7jmb6PhjtJ1o0hQjiqCDd+QRuqGKmcpHSJpBHL/jPB4mcAmpueu
	 cPrSO3u3kem7AiEY4A78OwF6wEkjd+rV3B76jDM81u+8M+e6JlYfEZn2F6C4NxwTJyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792575381;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Content-Language:To:Cc:From:Subject:Content-Type:
	 Content-Transfer-Encoding:X-Rspamd-Server:X-Rspamd-Queue-Id:
	 X-Rspamd-Action:X-Spam-Level:X-Spamd-Result:X-Spam-Flag:X-Spam-Score;
	bh=WgVyCKVKDgFoGg4+h5dbV4IfdQEf1uDgK4HCWyH1+5s=;
	b=AuGiISN79rT28sXXSdx5LoBZAe+sIRyh0uUH8yrIFWOnQVDMSQT5aL470fWuSMIM4Fj+
	 6SEKquuKvKdoIhOaK+PJ2rWr8T9coDnKcH1f4sXS7qKPLCl1OhR5j1cOiFt230OHrFis1
	 CClL6Tps2GZEQtNd0hxpDQnKRPV/K321p4Wvcx7UW00m2Ns9EIki4kd45fcmTYamWJ8AS
	 CRinPQA1NIVA4cqoc7L14UcxzlAsGzeh8b+f7OOtNGOTa28bRzyi4EdTwad/e/+EVk2vf
	 i2DQ4yr8PfFv4OoC6mudl6sZAcog1J5/yyTbYQ1fWyKKhX34feW3Wx5wA6M+mCfgtbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=hZBgkfcN;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=l4OK01XY;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=hZBgkfcN;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=l4OK01XY;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8807606A32A
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 09:36:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8807606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=hZBgkfcN;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=l4OK01XY;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=hZBgkfcN;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=l4OK01XY
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8455421DCD;
	Wed, 21 Oct 2026 09:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792575377; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WgVyCKVKDgFoGg4+h5dbV4IfdQEf1uDgK4HCWyH1+5s=;
	b=hZBgkfcNnSyD2SqkhhG9K8K/rTo5kpzqsdp6Dl7PucbCOrQELfEyD/YbZFNnO358cQVLmj
	Y+WQL0kKNGmedPidMQseEdJXZRRmrKWit6zUJNtTQnN3YFjp+PfPqS1E9AC1HagAHiWOoZ
	ANOHbsEFV8ZZGaFgHmY3Zkks1ZcsnDw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792575377;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WgVyCKVKDgFoGg4+h5dbV4IfdQEf1uDgK4HCWyH1+5s=;
	b=l4OK01XY7K6ux8lilD9GDrS1kxG0cIHIrk2zHk7Ago8vSsluDsKuKdgFdYP/UxDTuXWI9F
	N9EVJ3eLHCHNHQAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hZBgkfcN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=l4OK01XY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792575377; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WgVyCKVKDgFoGg4+h5dbV4IfdQEf1uDgK4HCWyH1+5s=;
	b=hZBgkfcNnSyD2SqkhhG9K8K/rTo5kpzqsdp6Dl7PucbCOrQELfEyD/YbZFNnO358cQVLmj
	Y+WQL0kKNGmedPidMQseEdJXZRRmrKWit6zUJNtTQnN3YFjp+PfPqS1E9AC1HagAHiWOoZ
	ANOHbsEFV8ZZGaFgHmY3Zkks1ZcsnDw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792575377;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WgVyCKVKDgFoGg4+h5dbV4IfdQEf1uDgK4HCWyH1+5s=;
	b=l4OK01XY7K6ux8lilD9GDrS1kxG0cIHIrk2zHk7Ago8vSsluDsKuKdgFdYP/UxDTuXWI9F
	N9EVJ3eLHCHNHQAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B78E134A5;
	Wed, 21 Oct 2026 09:36:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mNKzCpGH2GoFHAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Wed, 21 Oct 2026 09:36:17 +0000
Message-ID: <aeeb1af3-8672-4f6d-bec8-1a8e29e5414d@suse.de>
Date: Wed, 21 Oct 2026 11:36:16 +0200
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Nilesh Javali <njavali@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
From: Daniel Wagner <dwagner@suse.de>
Subject: upstream bug found during backporting?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 8455421DCD
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUBJECT_ENDS_QUESTION(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-0.998];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -3.50

Hi Nilesh,

JFYI, our internal review bot reported an issue on c449b4198701 ("scsi:
qla2xxx: Use QP lock to search for bsg"). Not sure if it is valid.

Thanks,
Daniel


commit 0c7674d3d65a1b2b178e8f66495e79b048aee834
Author: Daniel Wagner <dwagner@suse.de>
Committer: Daniel Wagner <dwagner@suse.de>

scsi: qla2xxx: Use QP lock to search for bsg

distro-commit: 0a579d00004251aaa0344329b5f12478b5bc473f
Git-commit: c449b4198701d828e40d60a2abd30970b74a1d75
Backport-upstream: c449b4198701
Backport-status: clean

Re-verified: 1 confirmed issue. The type check for SRB_FXIOCB_BCMD was 
inadvertently omitted when refactoring qla24xx_bsg_timeout() into 
qla_bsg_found(). If a BSG job of type QL_VND_FX00_MGMT_CMD times out, it 
is not matched in qla_bsg_found(), so it is never aborted or cleaned up 
from req->outstanding_cmds[], leading to a resource leak and potential 
use-after-free when the command completes or times out. This bug was 
introduced in upstream commit c449b4198701 and remains unfixed in 
origin/SLE15-SP7.

Review-model: qwen3.8-27b
Review-time: 562.49 seconds
Input-tokens: 33795
Output-tokens: 11633
Total-tokens: 45428

=== Findings ===

=== Finding 1 ===
Category: CHANGE-4
Type: resource-leak
Severity: medium
Confidence: 0.95

Message:
SRB_FXIOCB_BCMD was removed from the type-check in qla_bsg_found(). If a bsg
job's associated SRB has type SRB_FXIOCB_BCMD, it will no longer be found
during timeout. The function will fall through to the 'SRB not found' path
returning -ENXIO, but the SRB remains in req->outstanding_cmds[] and is 
never
removed or aborted by this path. The command will only be cleaned up when
firmware eventually times it out via the normal completion path. This is a
behavioral regression if such commands can exist.

Evidence:
Old check:
   sp->type == SRB_CT_CMD ||
   sp->type == SRB_ELS_CMD_HST ||
   sp->type == SRB_ELS_CMD_HST_NOLOGIN ||
   sp->type == SRB_FXIOCB_BCMD

New check (SRB_FXIOCB_BCMD removed):
   sp->type == SRB_CT_CMD ||
   sp->type == SRB_ELS_CMD_HST ||
   sp->type == SRB_ELS_CMD_HST_NOLOGIN
