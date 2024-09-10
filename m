Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1603D187555
	for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 13:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725974751; cv=none; b=hAEZtzNmuBUBRssUOEx8jDJMTLoLxe26D3jPPeepTQT2tbYoM848GgwjbiXubjeOIBqcUScGD1flAH0723ZzdE8+ABH9+M8r7hjvUvdr2U1sXupfg/d9yE953de9DyBQWxkL4FFf9DD1g6wjGkUmwIJVM8WiW5UVMSDulRHHK7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725974751; c=relaxed/simple;
	bh=gHq1RlMcoXW1hM0HdLruEp/LeaSklcUQHsdtB0Ch7DM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LAuQzm9cfPxBAI9pLyE491KS+T1Kc5rDLkDEscPMSbIrJaeE45wu7U29r+FYZdd+1h39lvHaFtQfVhy+Z1X/tINvCQZKnpScytz5p1MOUxpwEGxnLJwuipNSD1XmOiqG6h6TfWr0C5CXVKxW83yobYs/tuOQn3PmGuIRGYJMNvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Gm1SjX7j; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qerpZvtU; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Gm1SjX7j; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qerpZvtU; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Gm1SjX7j";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qerpZvtU";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Gm1SjX7j";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qerpZvtU"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3D3D51F816;
	Tue, 10 Sep 2024 13:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725974748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xdAoXXKK0HOxQQp9i46yTYPa1o3hAejrAElNqk+56nE=;
	b=Gm1SjX7jlE2jGjpyLrC2eKFl/HDlPXpqBkpHAlHT3Cx6+2OLD8UgyMn9hETQMAt/a/Zq4n
	XJ4XMmPsSmZJrH3wM4bzELT6U32AqisMGMxyiqsO1ab0gYrHKBb5yMIu6KnritLCSERa7i
	fU4hrykWBW3likp3tBWv6vO3vUOEWsQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725974748;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xdAoXXKK0HOxQQp9i46yTYPa1o3hAejrAElNqk+56nE=;
	b=qerpZvtUrdjdZafUAJl8hYxL4J/Z6ZOgcR/NXgYrMWvDUIFjOrX2Iqgd2opl2fZFQINee4
	/GUAZ6GEJ9d0yhBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Gm1SjX7j;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qerpZvtU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725974748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xdAoXXKK0HOxQQp9i46yTYPa1o3hAejrAElNqk+56nE=;
	b=Gm1SjX7jlE2jGjpyLrC2eKFl/HDlPXpqBkpHAlHT3Cx6+2OLD8UgyMn9hETQMAt/a/Zq4n
	XJ4XMmPsSmZJrH3wM4bzELT6U32AqisMGMxyiqsO1ab0gYrHKBb5yMIu6KnritLCSERa7i
	fU4hrykWBW3likp3tBWv6vO3vUOEWsQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725974748;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xdAoXXKK0HOxQQp9i46yTYPa1o3hAejrAElNqk+56nE=;
	b=qerpZvtUrdjdZafUAJl8hYxL4J/Z6ZOgcR/NXgYrMWvDUIFjOrX2Iqgd2opl2fZFQINee4
	/GUAZ6GEJ9d0yhBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 05D5313A3A;
	Tue, 10 Sep 2024 13:25:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id m3wBAdxI4GYOHQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 10 Sep 2024 13:25:48 +0000
Message-ID: <65366f3b-8f4d-49f0-9fdd-573f99d5b503@suse.de>
Date: Tue, 10 Sep 2024 15:25:47 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ibmvfc: Add max_sectors module parameter
To: Brian King <brking@linux.ibm.com>, martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
 tyreld@linux.ibm.com, brking@pobox.com
References: <20240730175118.27105-1-brking@linux.ibm.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240730175118.27105-1-brking@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3D3D51F816
X-Spam-Level: 
X-Spamd-Result: default: False [-6.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -6.51
X-Spam-Flag: NO

On 7/30/24 19:51, Brian King wrote:
> There are some scenarios that can occur, such as performing an
> upgrade of the virtual I/O server, where the supported max transfer
> of the backing device for an ibmvfc HBA can change. If the max
> transfer of the backing device decreases, this can cause issues with
> previously discovered LUNs. This patch accomplishes two things.
> First, it changes the default ibmvfc max transfer value to 1MB.
> This is generally supported by all backing devices, which should
> mitigate this issue out of the box. Secondly, it adds a module
> parameter, enabling a user to increase the max transfer value to
> values that are larger than 1MB, as long as they have configured
> these larger values on the virtual I/O server as well.
> 
> Signed-off-by: Brian King <brking@linux.ibm.com>
> ---
>   drivers/scsi/ibmvscsi/ibmvfc.c | 10 +++++++---
>   drivers/scsi/ibmvscsi/ibmvfc.h |  2 +-
>   2 files changed, 8 insertions(+), 4 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

