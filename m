Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54896318EDD
	for <linux-scsi@vger.kernel.org>; Wed, 18 Feb 2026 08:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771403304; cv=none; b=hKU72mNo3zTmgwEupX3bLRZT0OuUmnhObWm3l69wL4NHJJfslkQp1d3+heuWaVruiVujZOtGZTssrKTcFP9LJIUHRj4EBpVPEQTI9/R0GJYFe8OuHXihK2Aesenx1utjokvjJBNpOaz4wsiIjG363E5q7GIhg5pZ+bfB+IcTZlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771403304; c=relaxed/simple;
	bh=9D3YKSSnS/MgTS3JbFnUjUUzK2tzpkrMHWQInjeEMbo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TNr/ytJsGN0dg93opgUCcgSxH1Xk/nRgeD2mj0SIU4k9MwQnpzZgPai9ojo5lXi7fknxYfiCZi+xkzPu/mmWN5jQueApgVtg14LBYZeIpFpBka4B1gDq6h0YgagmA8O7Ngt4A4NHQoDjDwQ5/Wqi1T3DwdRzv75lutMOwQIoiLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=M01pRlrg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rY8DQz2R; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=M01pRlrg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rY8DQz2R; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="M01pRlrg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rY8DQz2R";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="M01pRlrg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rY8DQz2R"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 880CA5BCC1;
	Wed, 18 Feb 2026 08:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771403301; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8yHtU4ZP4sfXTSihe+4Fe2HyrLow6Ebe4qzrAC0EoJU=;
	b=M01pRlrgmejXInaW5LDHvYqoWFaf439hBlDe+Ib8yJ7togzaPfzZd3FTKylKwIjSW2fE/L
	Wg2hzi7YP2j29lTRKc8bv2ghTojzgQYKPx/vsqLWpSdk5/Aw1YxU1qyqcVIXUwjfwUVTaS
	nVQ7Pm5ucdfzz7fVQvjRtiHsUBgroTM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771403301;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8yHtU4ZP4sfXTSihe+4Fe2HyrLow6Ebe4qzrAC0EoJU=;
	b=rY8DQz2RCE4h7wigxzASfUetbust9vpx2ClCclyNGBfUQqzb4iYIx3N716S8kfuWoIqID1
	TyO2iAhM5wp9CPDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=M01pRlrg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rY8DQz2R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771403301; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8yHtU4ZP4sfXTSihe+4Fe2HyrLow6Ebe4qzrAC0EoJU=;
	b=M01pRlrgmejXInaW5LDHvYqoWFaf439hBlDe+Ib8yJ7togzaPfzZd3FTKylKwIjSW2fE/L
	Wg2hzi7YP2j29lTRKc8bv2ghTojzgQYKPx/vsqLWpSdk5/Aw1YxU1qyqcVIXUwjfwUVTaS
	nVQ7Pm5ucdfzz7fVQvjRtiHsUBgroTM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771403301;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8yHtU4ZP4sfXTSihe+4Fe2HyrLow6Ebe4qzrAC0EoJU=;
	b=rY8DQz2RCE4h7wigxzASfUetbust9vpx2ClCclyNGBfUQqzb4iYIx3N716S8kfuWoIqID1
	TyO2iAhM5wp9CPDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3ABF43EA65;
	Wed, 18 Feb 2026 08:28:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ui5iDCV4lWnlJAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 18 Feb 2026 08:28:21 +0000
Message-ID: <afdcce0f-0f83-4714-a5f0-5ddee28df5b3@suse.de>
Date: Wed, 18 Feb 2026 09:28:20 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: core: Add 'serial' sysfs attribute for SCSI/SATA
To: Igor Pylypiv <ipylypiv@google.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260209212151.342151-1-ipylypiv@google.com>
 <d61a1830-d9d0-4697-b547-80106ce57023@suse.de> <aYtiDLvRotCE0hEt@google.com>
 <aZSeHCH-IOjqw2n3@google.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <aZSeHCH-IOjqw2n3@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 880CA5BCC1

On 2/17/26 17:58, Igor Pylypiv wrote:
> On Tue, Feb 10, 2026 at 08:51:24AM -0800, Igor Pylypiv wrote:
>> On Tue, Feb 10, 2026 at 12:38:51PM +0100, Hannes Reinecke wrote:
>>> On 2/9/26 22:21, Igor Pylypiv wrote:
>>>> Add a 'serial' sysfs attribute for SCSI and SATA devices. This attribute
>>>> exposes the Unit Serial Number, which is derived from the Device
>>>> Identification Vital Product Data (VPD) page 0x80.
>>>>
>>>> Whitespace is stripped from the retrieved serial number to handle
>>>> the different alignment (right-aligned for SCSI, potentially
>>>> left-aligned for SATA). As noted in SAT-5 10.5.3, "Although SPC-5 defines
>>>> the PRODUCT SERIAL NUMBER field as right-aligned, ACS-5 does not require
>>>> its SERIAL NUMBER field to be right-aligned. Therefore, right-alignment
>>>> of the PRODUCT SERIAL NUMBER field for the translation is not assured."
>>>>
>>>> This attribute is used by tools such as lsblk to display the serial
>>>> number of block devices.
>>>>
>>>> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
>>>> ---
>>>>
>>>> v2->v3 changes:
>>>> - Replaced sysfs_emit(buf, "%s\n", buf) with a manual newline placement
>>>>     to avoid undefined behavior of passing the output buffer as an input.
>>>>
>>>> v1->v2 changes:
>>>> - Reordered declarations in scsi_vpd_lun_serial() from longest to shortest.
>>>> - Replaced rcu_read_lock()/rcu_read_unlock() with guard(rcu)().
>>>>
>>>>
>>>>    drivers/scsi/scsi_lib.c    | 47 ++++++++++++++++++++++++++++++++++++++
>>>>    drivers/scsi/scsi_sysfs.c  | 16 +++++++++++++
>>>>    include/scsi/scsi_device.h |  1 +
>>>>    3 files changed, 64 insertions(+)
>>>>
>>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>>> index 4a902c9dfd8b..c17fbe4dd845 100644
>>>> --- a/drivers/scsi/scsi_lib.c
>>>> +++ b/drivers/scsi/scsi_lib.c
>>>> @@ -13,6 +13,7 @@
>>>>    #include <linux/bitops.h>
>>>>    #include <linux/blkdev.h>
>>>>    #include <linux/completion.h>
>>>> +#include <linux/ctype.h>
>>>>    #include <linux/kernel.h>
>>>>    #include <linux/export.h>
>>>>    #include <linux/init.h>
>>>> @@ -3459,6 +3460,52 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
>>>>    }
>>>>    EXPORT_SYMBOL(scsi_vpd_lun_id);
>>>> +/**
>>>> + * scsi_vpd_lun_serial - return a unique device serial number
>>>> + * @sdev: SCSI device
>>>> + * @sn:   buffer for the serial number
>>>> + * @sn_size: size of the buffer
>>>> + *
>>>> + * Copies the device serial number into @sn based on the information in
>>>> + * the VPD page 0x80 of the device. The string will be null terminated
>>>> + * and have leading and trailing whitespace stripped.
>>>> + *
>>>> + * Returns the length of the serial number or error on failure.
>>>> + */
>>>> +int scsi_vpd_lun_serial(struct scsi_device *sdev, char *sn, size_t sn_size)
>>>> +{
>>>> +	const struct scsi_vpd *vpd_pg80;
>>>> +	const unsigned char *d;
>>>> +	int len;
>>>> +
>>>> +	guard(rcu)();
>>>> +	vpd_pg80 = rcu_dereference(sdev->vpd_pg80);
>>>> +	if (!vpd_pg80)
>>>> +		return -ENXIO;
>>>> +
>>>> +	len = vpd_pg80->len - 4;
>>>> +	d = vpd_pg80->data + 4;
>>>> +
>>>> +	/* Skip leading spaces */
>>>> +	while (len > 0 && isspace(*d)) {
>>>> +		len--;
>>>> +		d++;
>>>> +	}
>>>> +
>>>> +	/* Skip trailing spaces */
>>>> +	while (len > 0 && isspace(d[len - 1]))
>>>> +		len--;
>>>> +
>>>
>>> Please use 'strim()' instead.
>>
>> Hi Hannes,
>>
>> Bart pointed this out in V1 as well. I'll copy-paste my reply from V1:
>>
>> "Yes, I considered using strim(). strim() modifies the input buffer by
>> replacing first trailing whitespace with '\0' so we can't use it directly
>> on the vpd_pg80->data. The solution would be to copy the whole vpd page
>> data into the sn buffer and call strim() on the sn buffer. strim() returns
>> a pointer to the first non-whitespace character so we would also need to
>> memmove the serial number to the beginning of the sn buffer. All this extra
>> copying seems to be redundant so I went ahead with a simpler solution
>> that does a single memcpy()."
>>
>> Please let me know your thoughts on this.
> 
> Hi Hannes,
> 
> Ping for a feedback.
> Sending this in case my previous reply fell through the cracks.
> 
Hmm. Okay, sounds reasonable.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
