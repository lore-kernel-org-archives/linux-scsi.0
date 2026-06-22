Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E331DA60D
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2026 08:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782117788; cv=none; b=cT3wHsrtferuX1HwYJR60CriZ7kjoxvPjmwnE/ZU69T+amo5OlpQwn4NbjGDPUMMO2kM1vzdyjnLPjd761eIFLbRTn7ljpKvw2kvqqYp0TrRBVJFnO4uRa6UaWaNAse2G1cRGPWrZMxcz5sZzafs8fpvZsq/5tLGEqifwcl/Jf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782117788; c=relaxed/simple;
	bh=qf8qMcD/GnPP7Ua6yt+EU7wi1GFYIkY9uJ+yOZ5sjus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JAuK+3Nl1yUOi8ZH31tf9KbSjNmkrCNUByjY/SGAG79Q9qhXj5m5MQ0OJLiaRpFpt2VvzsLwS3cjFx/Ya2RHvArPMWZ9thdSjaxHooUCm4bpDaF1kL/7G8k4ijfqEtSE9TdXfs306VcmXW89aFWBNbChID4mRTO9ybOUIMneDho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kk8HxdPG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iSCD3x1h; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kk8HxdPG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iSCD3x1h; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kk8HxdPG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iSCD3x1h";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kk8HxdPG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iSCD3x1h"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 619C66B64A;
	Mon, 22 Jun 2026 08:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782117785; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qf8qMcD/GnPP7Ua6yt+EU7wi1GFYIkY9uJ+yOZ5sjus=;
	b=kk8HxdPGoxHbFz3WW+wp/qFpGeO6L80Zfel68jv5LFsqPUMBw72Vwq62rR06Q52OtOwlwV
	XO0QCqf/JQbsYYZoNvUPQgXtnA9n3ftb2DXsRhwvppTQ1FpF3K2My4bzCg6XwmRstqPFYI
	vq5uNpS4ysk/7tbghOJFivDuXRocWe4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782117785;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qf8qMcD/GnPP7Ua6yt+EU7wi1GFYIkY9uJ+yOZ5sjus=;
	b=iSCD3x1hS+QM4QYbpMNKSMO2/bB7WXBYAvYNJ249n0ItbSLR/RL7yk9aaQYeH+nTaxhSuK
	6MQZlECGP5oebOCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782117785; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qf8qMcD/GnPP7Ua6yt+EU7wi1GFYIkY9uJ+yOZ5sjus=;
	b=kk8HxdPGoxHbFz3WW+wp/qFpGeO6L80Zfel68jv5LFsqPUMBw72Vwq62rR06Q52OtOwlwV
	XO0QCqf/JQbsYYZoNvUPQgXtnA9n3ftb2DXsRhwvppTQ1FpF3K2My4bzCg6XwmRstqPFYI
	vq5uNpS4ysk/7tbghOJFivDuXRocWe4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782117785;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qf8qMcD/GnPP7Ua6yt+EU7wi1GFYIkY9uJ+yOZ5sjus=;
	b=iSCD3x1hS+QM4QYbpMNKSMO2/bB7WXBYAvYNJ249n0ItbSLR/RL7yk9aaQYeH+nTaxhSuK
	6MQZlECGP5oebOCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 44CF3779A8;
	Mon, 22 Jun 2026 08:43:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FAnvDpn1OGqgCgAAD6G6ig
	(envelope-from <dwagner@suse.de>); Mon, 22 Jun 2026 08:43:05 +0000
Date: Mon, 22 Jun 2026 10:43:04 +0200
From: Daniel Wagner <dwagner@suse.de>
To: sashiko-reviews@lists.linux.dev
Cc: Haoxiang Li <haoxiang_li2024@163.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: efct: Fix IO leak on unsupported additional
 CDB
Message-ID: <947fd1e6-cbf0-4b2e-a0c7-9d4bda439ff2@flourine.local>
References: <20260622075844.832871-1-haoxiang_li2024@163.com>
 <20260622081220.9D0B71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622081220.9D0B71F000E9@smtp.kernel.org>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-2.71)[98.71%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[163.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[163.com,vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,flourine.local:mid]
X-Spam-Level: 
X-Spam-Score: -4.01

Indeed, the callsite needs to handle the error code return by
efct_dispatch_fcp_cmd and not just blindly enqueue the io.
