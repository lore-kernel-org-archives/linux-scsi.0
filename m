Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37099330D35
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2026 18:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782930713; cv=none; b=leFq9B46R+W821QgEmw7pw5VPtNQTfqiHWr+BrvGaxx4hkbfjyU5FWBRuw/2bp3K344OOIKnUiQUnIBIrVwbWhXJbNxMdONwIN2dvgXe59fkPBwZ0BU0nCJ8DwR8mCDkBwkIZZpn7NNqyDnft8j0sHsVau0QkvSO8V5fSYfQ2cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782930713; c=relaxed/simple;
	bh=I73QlQZ6etcC/ViEpSvUp6ckys3J8IQRQDqUtgE2hwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hIQoP0pC9/2X4s+H50EnZEEHO6onCUtOOv7QZmi8z7SW4gBvGTqlkJeV4q9wMYExrR9k79jJlss2qcJktJeAD+jbuABUzUwtfWW03aP3Q4tWU1VphOodIWYELzQYhfYa0B45dH4mJiYPl0XmadjW+Wvac+SMOa4Rk0TID7k4Xw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Q5phPdva; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=v3LeSbuA; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Q5phPdva; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=v3LeSbuA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Q5phPdva";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="v3LeSbuA";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Q5phPdva";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="v3LeSbuA"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 60F0E7598B;
	Wed,  1 Jul 2026 18:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782930709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+jvuKD9/ufkG7smd9/XxhKa2emtCEznJyOQ+7FmXR40=;
	b=Q5phPdvaZ65YgcA+6aJWcH4nVd3EMgfVLxmJJ9zKZudlOHnuw1OeePkN7nZcXRyhJW8AfC
	omYeFQzLJuc35AgvqciJx2IUii3SaphxNWFbF0oQnRG28MObc/OH5/yzDVgGwwivLBwKtk
	um6AsPQ1Ksv/LVSIqfD9jcvK61O+N/c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782930709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+jvuKD9/ufkG7smd9/XxhKa2emtCEznJyOQ+7FmXR40=;
	b=v3LeSbuArnIqsmM/iXYO8sdahlnEa8IERUQvcPndtg9qeuhNHSB23OUMM6pmkXVAR9uh76
	oisNHwe+gZ8elTAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Q5phPdva;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=v3LeSbuA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782930709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+jvuKD9/ufkG7smd9/XxhKa2emtCEznJyOQ+7FmXR40=;
	b=Q5phPdvaZ65YgcA+6aJWcH4nVd3EMgfVLxmJJ9zKZudlOHnuw1OeePkN7nZcXRyhJW8AfC
	omYeFQzLJuc35AgvqciJx2IUii3SaphxNWFbF0oQnRG28MObc/OH5/yzDVgGwwivLBwKtk
	um6AsPQ1Ksv/LVSIqfD9jcvK61O+N/c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782930709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+jvuKD9/ufkG7smd9/XxhKa2emtCEznJyOQ+7FmXR40=;
	b=v3LeSbuArnIqsmM/iXYO8sdahlnEa8IERUQvcPndtg9qeuhNHSB23OUMM6pmkXVAR9uh76
	oisNHwe+gZ8elTAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 36E93779AD;
	Wed,  1 Jul 2026 18:31:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HJHlCxVdRWrmMQAAD6G6ig
	(envelope-from <ddiss@suse.de>); Wed, 01 Jul 2026 18:31:49 +0000
Date: Thu, 2 Jul 2026 04:31:26 +1000
From: David Disseldorp <ddiss@suse.de>
To: John Garry <john.g.garry@oracle.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K.
 Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] scsi: target: fix CHAP_N handling
Message-ID: <20260702043126.37fe9855.ddiss@suse.de>
In-Reply-To: <8a1ba462-50ac-45b2-9d38-4a2671f7a1f9@oracle.com>
References: <20260602115840.26490-1-ddiss@suse.de>
	<d8126fb0-85ac-4b1f-b6e0-b4e206ec90c3@oracle.com>
	<20260603091924.0892d415.ddiss@suse.de>
	<8a1ba462-50ac-45b2-9d38-4a2671f7a1f9@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REDIRECTOR_URL(0.00)[urldefense.com];
	RCPT_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[urldefense.com:url,oracle.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 60F0E7598B
X-Spam-Score: -3.51

Bumping this, as I still think it's worth addressing...

On Wed, 3 Jun 2026 09:24:19 +0100, John Garry wrote:

> On 03/06/2026 00:19, David Disseldorp wrote:
> > On Tue, 2 Jun 2026 17:42:57 +0100, John Garry wrote:
> >   
> >> On 02/06/2026 12:43, David Disseldorp wrote:  
> >>> The sashiko bot pointed out issues with CHAP_N handling recently, when
> >>> reviewing a patch for a separate issue:
> >>> https://urldefense.com/v3/__https://sashiko.dev/*/patchset/20260521151121.808477-1-hossu.alexandru*40gmail.com__;IyU!!ACWV5N9M2RV99hQ!MNesZJ3IsH9Mv0iZxHUcVmbC_3uwDkJgMhAX8i1TelyqqZD_dAq1cwIy6RtYI8D3boJh5iFeGhtTvfTX$
> >>>     Since extract_param() unconditionally strips '0x' or '0b' prefixes and
> >>>     alters the returned type, wouldn't a valid user with a name like '0xalice' or
> >>>     '0bob' have their username mutated to 'alice' or 'ob'?  
> >>
> >> is there a real world case or vulnerability being fixed here?  
> > 
> > No vulnerability -  the "real world case" is as above: CHAP
> > authentication currently fails if the CHAP username begins with 0x, 0b
> > or the upper case variants. The bug is trivial to reproduce.
> >   
> Understood.
> 
> To me, this is a fix for a problem which does not exist. And even if the 
> spec says it's possible, it does not mean that we need to support it. If 
> 0x prefix is part of the username, I think that problems should be expected.

IMO it's a real problem, e.g.: 'I changed my username from "bob" to
"0bob" and now I can't access my data.'

> Anyway, the code itself looks ok, so:
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 
> But the maintainer can make the judgement to take this obviously.

Thanks for the review.
