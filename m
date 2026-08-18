Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E9A43F0B8
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 09:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787046744; cv=none; b=pCOAabWu221WYRjV+AQq9sH4B8QpB7z0YE06XPU5jpFmGRDbD8TE9es2r+NRR0xAuUnHfbDJjZ7HUbr5DwAU14T8uSdVZgW3eyxUS6TVRTX4eyU30Ns+tU3ZqBG1KSkcBiwapK6AdcpH34kgXD2Ax18vhXnKoO3GSoaQHchZud4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787046744; c=relaxed/simple;
	bh=I0KP1IbAbezWkauYtZTJspxTeAjgpXqlUGWgDjtx5PM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=daPFgOKkMbeKAeJ9V2cxkdmTi1DBhwwkJGs8K5dfxDo5Kbpvv/xFqQok8n+VgZqa7uMttfmD0qA5x78iPlQuW9xRYRFXeqblN2HNsVm65XAVFqaKkHnTazWuvvWyizKgYyQz0sgnEGctzaX47oqlcpFGhAUlwjga/v2G0bfdE1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nWbKWcVC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=txPAXiKZ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=O4FFOC95; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7rAb5AmM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nWbKWcVC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="txPAXiKZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="O4FFOC95";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7rAb5AmM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2608A8448E;
	Tue, 18 Aug 2026 09:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787046737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tY9AQhgEP8GwLHSc2bQUzh4WNu0DrIro7po4Tza2WWE=;
	b=nWbKWcVC5O6mkyVccdyvIflBktcoiGRa4UYJtZL+DPGebs1g/JYa67j9Nn0lmZXf9tl28K
	JraoLMpAuBDdkz9Te9xmruGI0udVBlH7xn9HoEzY+raxlm7/R10MHWDTpksCiRu+Ju+f8+
	rbpxqZCNdQu42RLnADYmjbioEXdthg8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787046737;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tY9AQhgEP8GwLHSc2bQUzh4WNu0DrIro7po4Tza2WWE=;
	b=txPAXiKZoBbVkjxX26hCvvJcSpcSjsPcTXZtKTMlG/xBjmXjdx3QyWfkAd733rrleBFwTO
	N5WOFFIPYXlvnzCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787046733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tY9AQhgEP8GwLHSc2bQUzh4WNu0DrIro7po4Tza2WWE=;
	b=O4FFOC95GHTvBi+xIuMfremfNRFiGFGybK9NzcuIpLexloCm26Ch1WqYkK3eJEuJTzniUF
	FLdUzlcqWCL7WGqlv1TjD/1NZWylY4hOfGR7a52P/+CkvRF4AW4wicN5+Xb3hMN3avgXV8
	QqqcOrh2dQ4YCEbRQd0I+xbcAuVK/Tk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787046733;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tY9AQhgEP8GwLHSc2bQUzh4WNu0DrIro7po4Tza2WWE=;
	b=7rAb5AmMbXzDGZN31ULnUxnzmBq9XzP73oyZVtsAR6+QhVgf9sdkji/SaqRqafjoxXt+2P
	IB3+3+Mi0YFndEBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 09D6D22BA;
	Tue, 18 Aug 2026 09:52:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Vtn2AU0rhGoXcAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 18 Aug 2026 09:52:13 +0000
Message-ID: <bed9ae35-00e9-4819-9c35-ab2a905e6220@suse.de>
Date: Tue, 18 Aug 2026 11:52:12 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: leapraid: standardize NCQ priority sysfs
 attributes
To: Dongdong Hao <doubled@leap-io-kernel.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: dlemoal@kernel.org, hare@kernel.org, yjzhang@leap-io-kernel.com,
 kezijie@leap-io-kernel.com, jzzhang@leap-io-kernel.com,
 baikefan@leap-io-kernel.com, linux-scsi@vger.kernel.org
References: <20260814090526.395704-1-doubled@leap-io-kernel.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260814090526.395704-1-doubled@leap-io-kernel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,leap-io-kernel.com:email,imap1.dmz-prg2.suse.org:helo]

On 8/14/26 11:05 AM, Dongdong Hao wrote:
> Replace the earlier LeapRAID ncq_cmd_prio_enable attribute with the
> standard sas_ncq_prio_supported and sas_ncq_prio_enable names documented
> in Documentation/ABI/testing/sysfs-block-device, and rename the
> per-device NCQ priority state to match.
> 
> The earlier ncq_cmd_prio_enable name has not yet been established as part
> of a released userspace ABI, so no compatibility alias is needed.
> 
> For LeapRAID, sas_ncq_prio_enable is backed by the driver's per-device
> NCQ priority state and controls whether RT-class I/O requests are issued
> with command priority on supported SATA devices.
> 
> Update leapraid.rst to describe the standard attribute names and paths,
> and clean up the surrounding RST text for consistency with kernel
> documentation style.
> 
> Also switch the capability check from open-coded VPD page 0x89 parsing to
> sas_ata_ncq_prio_supported(), use kstrtobool() for the enable path, and
> expose the NCQ priority attributes only for SATA devices using LeapRAID's
> target-private SAS device state.
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Dongdong Hao <doubled@leap-io-kernel.com>
> ---
> Changes in v2:
>   - Reflow commit message lines to fit within 75 columns.
>   - No functional change.
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
