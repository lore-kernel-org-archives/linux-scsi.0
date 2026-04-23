Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B15E1EFF8D
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 13:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776952725; cv=none; b=PjLzZDYhwWKVxH7ik8GF5znw9hZuwtg0WApphfA1pe0HF1KEW62osnLWm5esNlpoEEkn1ltw/p1hwA178n5xee+YCrqD7JNt/Zc47UhVZQSb+WrOmTqoiuzfqWly6qRmZwWa5DT0DNKoh5Qjd1gRwtebFQ1VHhNBy402rJn4lUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776952725; c=relaxed/simple;
	bh=wBMKjL5IO+RaT+6IFWHho1RFn6F5glFO6Kp4FzByhpM=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Qv9OpapSC6uJtYfiUG5mozOTzFl0DXsdsdqEDql/EUtaj07h3DAhJ4QXXrol+peV3G8db1/TxYH62zf4ws2N5zaHlvYzexadaHtYt9eFVfdl6fD0FTeG7nW9YcVxTqhPXEWBlSFswRe79JUeJ21z5T+2dWOyyaFrLGIiKdgEjvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=z1BqgJmX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Xn35CMeO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=t6lKtz3J; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FaBL7pwp; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z1BqgJmX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Xn35CMeO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="t6lKtz3J";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FaBL7pwp"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CAA875BD11;
	Thu, 23 Apr 2026 13:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776952722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yZxZWJgZxB9W0Ey8zKBVD9hx7WNPaJBYMBO2nw6D0zk=;
	b=z1BqgJmXTPagDwFLgkOiyvughOCCyLpZpPY+pNDPBcMpesHRBIEC95Va9jDIBavi/uuvD0
	RLNBnA1gjlbVN6FPcZ3uhWd1dqK4LqAIoEsfPjEqBVEYFPFHxKzjovzXQO7SmTaGsGACzg
	otXnKHkmw/Q9tg7rGLkeoKcxwsptAzk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776952722;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yZxZWJgZxB9W0Ey8zKBVD9hx7WNPaJBYMBO2nw6D0zk=;
	b=Xn35CMeOC8RvUg9wive5cdgrzE/Gc9XoNVZGysCYursV8isIY5WgNlZRFxE4r5S9mlnSVV
	rNK8zLIAEx/6vbAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776952721; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yZxZWJgZxB9W0Ey8zKBVD9hx7WNPaJBYMBO2nw6D0zk=;
	b=t6lKtz3JaEUIs4YlRkIJGYB1AP9J+LyLI4FEVm7UyZIRZALP27zTSWFht7eoabaDXzOSyN
	yfXnUDg/clABeBiZvGoYLEfuMuPVjTPwcG4uxBUJi40Au2oqWcRQHiIVyT0O3VawkIWZHs
	oGzu7xBqWzen/iFnAhjHHWCcWeJXGjc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776952721;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yZxZWJgZxB9W0Ey8zKBVD9hx7WNPaJBYMBO2nw6D0zk=;
	b=FaBL7pwp86cdPs/UfKA5bBuJyCQvf14FGavOgcbAQv/9drh/5qrsyNsRgoZ9JFHGStA0gX
	alQ9Utnv1+PkUyCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BAC98593A3;
	Thu, 23 Apr 2026 13:58:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qU0PLZEl6mlXTQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 23 Apr 2026 13:58:41 +0000
Message-ID: <598b1dda-b04c-4983-a52e-78466cef2070@suse.de>
Date: Thu, 23 Apr 2026 15:58:41 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 John Garry <john.g.garry@oracle.com>,
 Mike Christie <michael.christie@oracle.com>
From: Hannes Reinecke <hare@suse.de>
Subject: [LSF/MM/BPF TOPIC] SCSI cmd_per_lun retirement
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

Hi all,

in recent discussion (cf 
https://lore.kernel.org/linux-scsi/20260417230751.117836-1-michael.christie@oracle.com/) 
we
have found that cmd_per_lun really seems to be outdated, and
leads I/O throttling on some devices.
This discussion will center around the various I/O fairness
mechanisms we have to for the SCSI layer (cmd_per_lun, batching,
host_tagset) and see if we can come up with a combined
method here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

