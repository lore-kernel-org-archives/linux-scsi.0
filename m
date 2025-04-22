Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C1B230BEF
	for <linux-scsi@vger.kernel.org>; Tue, 22 Apr 2025 06:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745304158; cv=none; b=KpdmoSLB8wQjT9tloCPnwNjgmSM5p3bcaGHOpTram4TP8t4hVhj3yKT+9zdlZelAWy8wzePTS9qXLlcod1ZCp2U3uD9M17b2Gh3r4N/c7PFY+e/qQ3Zt09xnWrqnhW00DzendwtaWFszJCW0LAN5jHLkX4T2/pAm/iNa7K5tmKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745304158; c=relaxed/simple;
	bh=oo+ZoitGDPsQ7Jb9Ytf8jouD+tc/X2KETe0ICRoYPy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MIV2Zn3Jplu6suD2rsz99rQTTMA5vQaiCbPyywz/dlDTqBmuLNCCiG9DsKU6C+HL5NkvJTUvkMolTHj+TkOagCYlApJCLctyLecXKoeO3qgY11Cy5lu5suVwhkSRA81MCEUdoV5rHpyDEirXoqKiLTc9naaGAde6XMkPOHUeW8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kC3js/pz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ha/O5/xL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ok+PW1GU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FraabXZ+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kC3js/pz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ha/O5/xL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ok+PW1GU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FraabXZ+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E4BE021248;
	Tue, 22 Apr 2025 06:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1745304155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MeDYtuApbqDNcHPTy4aNnNbJKkUGnuQUst//DHl44NM=;
	b=kC3js/pz6/cs+4+OZwPEo/UfpP1FvxdRJopQwhCFWShcvx/Gq16V4xogRfrzWbJYqcxXco
	K6GA3D5OsVAHR6+djJNxmoS+51Jv5GsamFGU0J8nWSWMG4Vm1fDmOORgpiktukdRFcJ26W
	5SnM6MUkzT9amrFBg6imZRosAcULX24=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1745304155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MeDYtuApbqDNcHPTy4aNnNbJKkUGnuQUst//DHl44NM=;
	b=Ha/O5/xLliLCriYhtHfvMF4zmd6RLPrr8YObby3s/wqlEhSZu6q4iRIvjRnL8q50grpQPb
	YmHrM3D4Igl9IpDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1745304154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MeDYtuApbqDNcHPTy4aNnNbJKkUGnuQUst//DHl44NM=;
	b=Ok+PW1GUtH+h7JOAgtW3Fi2L/qX6qK0sxzOxJ9cGkNXbiOi+jEmsjYO27wvbvSasNjPi8U
	2tq4OU9Oj4jbWoChqHZ42+ajtxkWuBfih68pfVkl424CFcU7Pl5rZxUDyLCwpfODSD6Foh
	46hn3n1gR2YH1vipjPxsNyR8Pp4ZIaE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1745304154;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MeDYtuApbqDNcHPTy4aNnNbJKkUGnuQUst//DHl44NM=;
	b=FraabXZ+7CRsm+7UI37tSHk0lU7dB7QfYMXGPl9ENuQRpyxvKc8RlXbKXZB+aL03Z6tGQ/
	JDzDlaUj/QftQmBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1693F137CF;
	Tue, 22 Apr 2025 06:42:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /dfFA1o6B2hqLAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 22 Apr 2025 06:42:34 +0000
Message-ID: <570edf08-8c17-4616-b524-2bba927eabe1@suse.de>
Date: Tue, 22 Apr 2025 08:42:33 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IRQ
 affinity
To: Sagar.Biradar@microchip.com, john.g.garry@oracle.com,
 jmeneghi@redhat.com, martin.petersen@oracle.com,
 pheidologeton@protonmail.com, kernel@roadkil.net, maokaman@gmail.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
 thenzl@redhat.com, mpatalan@redhat.com, Scott.Benesh@microchip.com,
 Don.Brace@microchip.com, Tom.White@microchip.com,
 Abhinav.Kuchibhotla@microchip.com
References: <20250130173314.608836-1-sagar.biradar@microchip.com>
 <yq1mseqwoaa.fsf@ca-mkp.ca.oracle.com>
 <PH7PR11MB757026166DDB8068830AE420FAFF2@PH7PR11MB7570.namprd11.prod.outlook.com>
 <8433b8b8-bb9a-43e0-a760-d8745d28d0d9@redhat.com>
 <yq1eczsjaaz.fsf@ca-mkp.ca.oracle.com>
 <2eca14e0-3978-440f-a4a4-32c9c61baad4@redhat.com>
 <84a87c16-0738-460d-b83f-55f8181d536e@suse.de>
 <c3f77605-3061-461f-8406-8eb0493c71cd@redhat.com>
 <PH7PR11MB7570A7E66942E50167648A56FAA72@PH7PR11MB7570.namprd11.prod.outlook.com>
 <01aaa273-f068-4013-b4ce-25cab5ad7d4f@oracle.com>
 <PH7PR11MB75700EF6E59755BD99F780A8FABC2@PH7PR11MB7570.namprd11.prod.outlook.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <PH7PR11MB75700EF6E59755BD99F780A8FABC2@PH7PR11MB7570.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[microchip.com,oracle.com,redhat.com,protonmail.com,roadkil.net,gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,protonmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,oracle.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On 4/17/25 18:02, Sagar.Biradar@microchip.com wrote:
> 
> 
>> -----Original Message-----
>> From: John Garry <john.g.garry@oracle.com>
>> Sent: Monday, March 24, 2025 6:55 PM
>> To: Sagar Biradar - C34249 <Sagar.Biradar@microchip.com>;
>> jmeneghi@redhat.com; hare@suse.de; martin.petersen@oracle.com;
>> pheidologeton@protonmail.com; kernel@roadkil.net;
>> maokaman@gmail.com
>> Cc: James.Bottomley@HansenPartnership.com; linux-scsi@vger.kernel.org;
>> thenzl@redhat.com; mpatalan@redhat.com; Scott Benesh - C33703
>> <Scott.Benesh@microchip.com>; Don Brace - C33706
>> <Don.Brace@microchip.com>; Tom White - C33503
>> <Tom.White@microchip.com>; Abhinav Kuchibhotla - C70322
>> <Abhinav.Kuchibhotla@microchip.com>
>> Subject: Re: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IRQ
>> affinity
>>
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know
>> the content is safe
>>
>> On 25/03/2025 00:16, Sagar.Biradar@microchip.com wrote:
>>>>>>
>>>>>> I've added the original authors of Bugzilla 217599[1] to the cc list to
>>>>>> get their attention and review.
>>>>>>
>>> Historically, the aacraid driver relied on the can_queue member of the
>> scsi_host structure to determine the total number of cmds the FW could
>> manage.
>>> With FW supporting 32 queues, each capable of handling 32 commands,
>> the total command capacity was effectively 1024 (32*32).
>>>
>>> This limit is a HW/FW limitation specific to the aacraid controller, which
>> restricts each queue to a maximum of 32 cmds.
>>>
>>> Starting from kernel version 6.4, the introduction of the map queue
>> mechanism treated all queues as having the same capacity as can_queue,
>> inadvertently exceeding the 1024 command limit.
>>> Consequently, relying solely on scsi_host->can_queue became unfeasible.
>>> To address this, the patch introduces logic to dynamically assign can_queue
>> based on the number of available MSIX vectors (i.e., the number of queues)
>> multiplied by 32.
>>
>> I have not read all this thread, but ....
>>
>> in case unknown, if you set shost->host_tagset when setting
>> shost->nr_hw_queues > 1, this means that the total queue depth of the
>> adapter (from block layer PoV) == each HW queue depth == shost-
>>> can_queue
>>
>> If you don't set shost->host_tagset, then total queue depth (from block
>> layer PoV) is shost->can_queue * shost->nr_hw_queues
>>
> 
> Thanks for the clarification and making a valid point.
> I'm currently exploring an approach where shost->host_tagset is explicitly set to 1,
> and shost->can_queue is calculated as the total number of supported cmds across all queues (e.g., num_queues * 32),
> as shown in the initialization logic:
> 
> 	shost->nr_hw_queues = aac->max_msix;
> 	shost->can_queue    = aac->vector_cap; // where vector_cap = max_msix * 32
> 	shost->host_tagset  = 1;
> 
> The goal is to conditionally enable MultiQ support in configurations where CPU offlining is required,
> while maintaining optimal performance in the default case.
> Since host_tagset = 1, blk-mq treats can_queue as the total tagset size, not per-queue.
> This setup ensures we stay within the firmware-imposed 1024-command global limit.
> Tag bounds are checked in aac_fib_alloc_tag(), and reserved FIBs are allocated from a separate range.
> 
> Really appreciate the heads-up — this behavior is being factored in while refining the design.
> 
That is the correct approach; on fact, this is precisely what
  'host_tagset' is designed to cover.
Don't hesitate to reach out if you have further questions.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
