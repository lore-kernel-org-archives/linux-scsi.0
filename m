Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5904219E2;
	Sat, 15 Jun 2024 09:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718442440; cv=none; b=Yy8by6+8AkHlNv7bMtxJtyT8NsgAN1BSRFgTbDhwJiL5XV2oNdOHbcurixNVefo3VX0x/mBL4FA+oMSsb0zrd8R36ahuD9Df5C9g1uulH9T6PDZBqgDxhPhKlpRPhuGk7mUUWUDTx5VkzPAYtpJs4RP+4c2UeZ/7cyhjVX6JVb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718442440; c=relaxed/simple;
	bh=n3qmvJNawAZGNbgSnMG0mqAx4X1ZkMJID3Q2AQAWgFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K2q/5suQKRCfI/ZpMJ/tRpHXyCuE6OsEJC33FFXkmQ30RclqipSC7LVH4qr1D0o95hXI/O+a6PJE3rxTWwDeFCCfyC74Yj5XDiFRhPkXRYqgN5YQCMgBeAsr59WBykTsqKCGPN5b3SJOMVsFw9IlpWKpWmtgVof98phPYVxDMkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=I6rW809D; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=M7PsZHrB; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LMuYdLQJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BWB2RMyU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="I6rW809D";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="M7PsZHrB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LMuYdLQJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BWB2RMyU"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C12F1341CB;
	Sat, 15 Jun 2024 09:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718442437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0bSmswmJEWRhH+6M0ZlEq+niVivHF1Xv45YGk3n72w=;
	b=I6rW809Dgt8RspKawt2nm6dxkduhyigs6MC9dAPC7D4x2ZHQxefvmF4ZQNYxDWC8SdWfvH
	XR0wT+mUn48jyTBxS6DotOrelJSeHiwkDcsnTfdVEY9s5KZFb9cVhra6/j3wqwZrjrvk1/
	hETZs+phHYfbRNQz8SUPeGEs+BfxuSk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718442437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0bSmswmJEWRhH+6M0ZlEq+niVivHF1Xv45YGk3n72w=;
	b=M7PsZHrBkrQ1Z9oB0zfnnLU+qpzHAjwYNRNtEKzh1/rfh6Yu1kJR9BlXSGrM3EWM+n7hQ6
	amPFY3yYrSgCikBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LMuYdLQJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BWB2RMyU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718442435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0bSmswmJEWRhH+6M0ZlEq+niVivHF1Xv45YGk3n72w=;
	b=LMuYdLQJ9iuE74OJWhm81uKyvbFBUxPAJ9FVGhKBuV97ADn5BSWL35KRa2SO31nlCLTTzQ
	bgQBWQPZxf79OMeTjK+LAod+voa9/Ne9Pf+2MROxnX6D7CHEck+XMimB6KDngbr6fpx3X2
	Zkiyf8Fh6cMvjEqQteXhnrcVP6D+ALI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718442435;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0bSmswmJEWRhH+6M0ZlEq+niVivHF1Xv45YGk3n72w=;
	b=BWB2RMyUeYMWBjaQBN3tBzqsa0wv6X1KzCLj0zyFY89eLCJblajb7dC1aUf0cisLjSDgIp
	UXvrN6yBT9Pq8rAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 56F5813A7F;
	Sat, 15 Jun 2024 09:07:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5x5uEsNZbWY0YwAAD6G6ig
	(envelope-from <hare@suse.de>); Sat, 15 Jun 2024 09:07:15 +0000
Message-ID: <5d9c3107-5d07-4fe8-9782-cefb8d058ab5@suse.de>
Date: Sat, 15 Jun 2024 11:07:14 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/14] scsi: fnic: Add functionality in fnic to support
 FDLS
Content-Language: en-US
To: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>,
 "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>
Cc: "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>,
 "Dhanraj Jhawar (djhawar)" <djhawar@cisco.com>,
 "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>,
 "Masa Kai (mkai2)" <mkai2@cisco.com>,
 "Satish Kharat (satishkh)" <satishkh@cisco.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240610215100.673158-1-kartilak@cisco.com>
 <20240610215100.673158-9-kartilak@cisco.com>
 <f992c0f2-8f70-4dc0-b679-e522e3fd6101@suse.de>
 <SJ0PR11MB58966D39EFAAD206CAE0A313C3C32@SJ0PR11MB5896.namprd11.prod.outlook.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <SJ0PR11MB58966D39EFAAD206CAE0A313C3C32@SJ0PR11MB5896.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,cisco.com:email]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: C12F1341CB
X-Spam-Flag: NO
X-Spam-Score: -4.50
X-Spam-Level: 

On 6/15/24 05:47, Karan Tilak Kumar (kartilak) wrote:
> On Tuesday, June 11, 2024 11:57 PM, Hannes Reinecke <hare@suse.de> wrote:
>>
>> On 6/10/24 23:50, Karan Tilak Kumar wrote:
>>> Add interfaces in fnic to use FDLS services.
>>> Modify link up and link down functionality to use FDLS.
>>> Replace existing interfaces to handle new functionality provided by
>>> FDLS.
>>> Modify data types of some data members to handle new functionality.
>>> Add processing of tports and handling of tports.
>>>
>>> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
>>> Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
>>> Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
>>> Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
>>> ---
>>>    drivers/scsi/fnic/fdls_disc.c |  74 +++++
>>>    drivers/scsi/fnic/fip.c       |  27 +-
>>>    drivers/scsi/fnic/fnic.h      |  20 +-
>>>    drivers/scsi/fnic/fnic_fcs.c  | 498 ++++++++++++++++++++++++----------
>>>    drivers/scsi/fnic/fnic_main.c |  10 +-
>>>    drivers/scsi/fnic/fnic_scsi.c | 127 +++++++--
>>>    6 files changed, 587 insertions(+), 169 deletions(-)
>>>
>> This seems to not just _add_ the functionality to use FDLS, but rather _replace_ the existing
>> functionality with FDLS.
>> IE it seems that after this change the driver will always do FDLS, causing a possible service
>> interruption with existing setups.
>> Hmm?
> 
> Thanks for your review comments, Hannes.
> As I mentioned in the other patch comments, Cisco has been shipping an async driver based on FDLS
> for the past six years.
> The async driver is backward compatible and supports all the adapters that are supported by the
> existing upstream driver, and more.
> The async driver in fact overrides the upstream driver on our installations.
>
Ah. Good to know. Ever more a reason to have your driver upstreamed, then...


> On Cisco hardware, the best practice out in the field, is to update the driver to the async
> driver during OS installation itself.
> Due to this best practice, we have _not_ received any feedback from customers indicating an
> abnormal service interruption specifically due to the driver update.
> 
Ah. I wasn't aware of that.
So that's fine, then, and you can disregard my comments here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

