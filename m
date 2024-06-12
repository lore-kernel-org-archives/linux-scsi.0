Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E8412FB2A;
	Wed, 12 Jun 2024 06:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718174880; cv=none; b=rHKXvHffK/TafBpzSr5cvvtDdWiJ2BltheH4GjmoPUHlna5DsLEbUNatVUEuILdLVYGPtbYmT6+w05TAtpSee+4JcPm0ZWRIbaOdxFZPNTAlaVxCiUzngBbcMUQup5t4hq0scPWBg4x2OHb0mtxnFfoUhZFdMKuOhMMQ1/349lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718174880; c=relaxed/simple;
	bh=oB6Do4kv1w9L09lywIyjWMYWD+ZvNAv0mbAY3LzFliI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jd/VJ16JaCYlp06NpWZmR3pcJA748Sj7EYd9RSOmGqo8eZxZreSnEfC6ZVGSrCtmUHkwqsEvZ2rQKoGseb1pK7PscUzWPK6b2jm/lP8w8/tcnyW79iwJRy9HyvPOM8x9aLH0BuKAmaZjAPBHDIiX1fGioaIZjIUEZoZTVx+CQjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UVk9Gj5n; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2Rsr0FdZ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UVk9Gj5n; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2Rsr0FdZ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UVk9Gj5n";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2Rsr0FdZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UVk9Gj5n";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2Rsr0FdZ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 142C333F93;
	Wed, 12 Jun 2024 06:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718174877; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xSPjDNH15FXrHWs5yQoeykIsoNUfffN6Vbldpf/bajI=;
	b=UVk9Gj5n9xQoJp7IRMXPuzgtUy4Xm3gZz5YwGvaYvb5x+mSMvc7eUSufwWG1yMTMm3PHWi
	9ms/n54ERgyQcnFpIFIqJsEYGqUirN+f00E29GkViQop8rgvyCamEPEx2VwHIntZrSaYQ9
	lq/D9mmTAlYdDlIc2SwLVVZSvsBj/Ws=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718174877;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xSPjDNH15FXrHWs5yQoeykIsoNUfffN6Vbldpf/bajI=;
	b=2Rsr0FdZKWF8u0Ohkt2n4R6HPcDXcJ0MAWGKs1VeI/lFAl3Mmc3ooOTGoqJdp4hlb31YKC
	5fFJKNyHOaSiZuDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UVk9Gj5n;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2Rsr0FdZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718174877; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xSPjDNH15FXrHWs5yQoeykIsoNUfffN6Vbldpf/bajI=;
	b=UVk9Gj5n9xQoJp7IRMXPuzgtUy4Xm3gZz5YwGvaYvb5x+mSMvc7eUSufwWG1yMTMm3PHWi
	9ms/n54ERgyQcnFpIFIqJsEYGqUirN+f00E29GkViQop8rgvyCamEPEx2VwHIntZrSaYQ9
	lq/D9mmTAlYdDlIc2SwLVVZSvsBj/Ws=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718174877;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xSPjDNH15FXrHWs5yQoeykIsoNUfffN6Vbldpf/bajI=;
	b=2Rsr0FdZKWF8u0Ohkt2n4R6HPcDXcJ0MAWGKs1VeI/lFAl3Mmc3ooOTGoqJdp4hlb31YKC
	5fFJKNyHOaSiZuDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8E5A2137DF;
	Wed, 12 Jun 2024 06:47:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TO0LIZxEaWYiPwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 12 Jun 2024 06:47:56 +0000
Message-ID: <43b8bd73-efca-45b0-9526-3c19c8cb3713@suse.de>
Date: Wed, 12 Jun 2024 08:47:56 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/14] scsi: fnic: Add and integrate support for FIP
Content-Language: en-US
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
 mkai2@cisco.com, satishkh@cisco.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240610215100.673158-1-kartilak@cisco.com>
 <20240610215100.673158-8-kartilak@cisco.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240610215100.673158-8-kartilak@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 142C333F93
X-Spam-Score: -6.50
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-6.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On 6/10/24 23:50, Karan Tilak Kumar wrote:
> Add and integrate support for FCoE Initialization
> (protocol) FIP. This protocol will be exercised on
> Cisco UCS rack servers.
> Add support to specifically print FIP related
> debug messages.
> Replace existing definitions to handle new
> data structures.
> Clean up old and obsolete definitions.
> 
Aren't you getting a bit overboard here?

I am _positive_ that the original fnic driver _did_ do FIP.
What happened to that?
Why can't you just use that implementation?

And if you can't use that implementation, shouldn't this rather be
a new driver instead of replacing most if not all functionality of
the original fnic driver?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

