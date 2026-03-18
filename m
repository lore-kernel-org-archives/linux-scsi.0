Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800AC3B19B6
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 09:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773825888; cv=none; b=nKDzCDPBx9MSHEPgCn+HjvkyAT5FSeHhV13BZeqaowyfOq5atYthXXGENEeKhnHSO/106X5w4II4pUV+sOfeumYS52LmwT4zoCC4tJv8+qzaIWqXo4DxWW1G6PcnQgHdaSd3iUEF6cFQ1hTgollDi+chhqcsl7MVVgdMdrh3yIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773825888; c=relaxed/simple;
	bh=lQpBe9CcR4XYulE4lNgLbWzUt8xBy4TlZK/UmAmbEXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GqJDyjRrGZgrCxDPV2pkOCGUSUPlaW4fn45B3RI9bNitX4GixlQGY9Fno3nIw6RJAMPNXX5pghsyN8HQAmU7u1aPPsO3i5S5mtWkC+2jQwCO7nudRTitZzbNBf0n9wnAGSyBq1v+AlhTKEIKlL4qHetkH4JypFjajKNVtpNHB4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EqLgkoLe; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EqLgkoLe"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-439b7c2788dso4136902f8f.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 02:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773825886; x=1774430686; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rNKBTzUdX68mACaRpFmDLYY/h6NQejPTpn8KgeZ6DN4=;
        b=EqLgkoLemsCgfeTNsTwHyaTXgt2RPt5NFD0kgKhy33fFk5ZTtjj2PH52o1WvFz2NPx
         xTM88wjxWCER93c0/SywWuZZet8af4GT6yOl5XroDSptNhSrznEbYCTbyiLh1RYXqLC4
         zdTFR9TyI9sLLEOpqEW3EC0LKlam4kHa81BfUEz7y1oTAdypM6x972EPv1awSt7S9Bus
         yIy934chiagspHTJN5HnfVkBGcBT84tZlOosu/es68QuAaKvnuEgyV0WcWdSC5nrsGm7
         3pEly6/+fQXnUNvsQ1GaGbb4mN0JrhELhwZG4fSLlXny9VflO2vsMKEQie8NMj5ruLKA
         PW1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773825886; x=1774430686;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rNKBTzUdX68mACaRpFmDLYY/h6NQejPTpn8KgeZ6DN4=;
        b=On3RN2l66Ef/pr9sRfSlDW6GB9WOsy2r3xkME5M/EK/sgcQIdVSs2fjgV4UWy7IqA1
         KECshav1E0n2c0KYoGH4rkozd80EFpeq/c3ep7mYn9OgnFpDs4cWaDLIPXYBUKLaKNhQ
         D4mLwnF8bVf0lSUau1EgatTmUE3IkLU25eGRsQN/ZejxaIK+Xz2rsESafaZznAz42WgU
         XkT9WiOd2PO5HdnmGDqS1P/GZ9peICd6kgKWG/rloqZE2DP3VPGwm+kdfMVTLKQGfCAX
         LmyOSbHQ4zGXZsgvLoIzvfb63c8JxmAwzyhIcxCaOoktgBX0mp447OOiPUQjDKIybeLj
         T9gQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSWk6926To4iERYBTVaRumGBmzca/vdAtjqa7mayyBisjOxKwF9NcxEcqqXlwYMLm/cdMK7znREJjf@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8kt+Wumw0qg/R3s2NnAcMu/GOf4T5OA1agfOyOubUrk8KopsU
	yr7WuEcfeAFA/d3FB1G9fgxHDMTTlXoddKvi2QP9zhZS0Nwpa+GsvJU4BKqPjr0vE0k=
X-Gm-Gg: ATEYQzwLuTskV4SlDB2nB4+HiLqCYu9UFCfIRN6ylF98CM9MJsudIsf3OAmK3tkL3iO
	oo/y5xUjabZi5BXF6kYb/jrx7MK6WCcJnAPWx6qLbktkzFbQ/2Oe15TYjiVFRflU1/mObg0RuwX
	VvOziijFNsDIgXsOt+zS22aJc4DM/kEaOZo/BGbY3ml/+8Yi8EBNrk+LmOY0QRsdexJaqZ+7DhD
	3fKI5KqimqeywOtGJsKSxDjxrrZ/v5//7qOrcu+aT1E2Z7YV7BO3Ajk4qL11McmXfeek+Q7aNJf
	kc4sNMq3nvm2AeeJpujHhGoZwAvHima9DeFJi8ueGc1WPrEWGBugxwP97Znbmn2tAkKPeAf5D8L
	wjqQ1+RNyenrCJ6usqxPxCG754M4EOjXGU1KRxHkElgMWe+BRRgufwFAh17oaEyNMQfBAME1lU9
	Rt9zTC/JLcYqmmARWsbG14hJmhnGvvOD3u9A43uYOzm3BMNmxyOAFwzzv/
X-Received: by 2002:a05:600c:83c5:b0:480:6bef:63a0 with SMTP id 5b1f17b1804b1-486f4456f1fmr40963985e9.21.1773825885802;
        Wed, 18 Mar 2026 02:24:45 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b51852097sm6495727f8f.9.2026.03.18.02.24.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 02:24:45 -0700 (PDT)
Message-ID: <d149f868-e3ae-4db1-b85b-9d5756d8fa05@suse.com>
Date: Wed, 18 Mar 2026 10:24:44 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/13] scsi: alua: Add scsi_alua_stpg_run()
To: John Garry <john.g.garry@oracle.com>, Hannes Reinecke <hare@suse.de>,
 martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
 michael.christie@oracle.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-8-john.g.garry@oracle.com>
 <1bf4f9c3-7ab9-4be9-9061-0611a41242d3@suse.de>
 <f0625323-655f-49bf-bda8-324c0fa4f520@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <f0625323-655f-49bf-bda8-324c0fa4f520@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/18/26 09:59, John Garry wrote:
> On 18/03/2026 07:57, Hannes Reinecke wrote:
>>> +static inline int scsi_alua_stpg_run(struct scsi_device *sdev, bool 
>>> optimize)
>>> +{
>>> +    return 0;
>>> +}
>>>   static inline int scsi_alua_sdev_init(struct scsi_device *sdev)
>>>   {
>>>       return 0;
>>
>> No. STPG handling should be done in scsi_dh_alua _only_. We really
>> should not attempt this in the scsi core.
> 
> It's not so nice to have the functionality spread out. The way I see it 
> is that drivers/scsi/scsi_alua.c is mostly a library, but also has 
> functionality to "drive" ALUA for native SCSI multipathing.
> 
> Anyway, can you confirm which of the following do you think from this 
> series should be in scsi_dh_alua.c:
> 
> - scsi_alua_stpg_run()
> - scsi_alua_stpg()
> - submit_stpg()
> 
> You already said scsi_alua_stpg_run() should be.
> 
Gnaa. Misread that one (blame lack of coffee).
stpg should be handled in scsi_dh_alua. Arguable
we could move the utility functions (submit_stpg
and maybe scsi_alua_stpg) in the core alua code,
but scsi_alua_stpg_run() should be kept in
scsi_dh_alua.

If that makes sense ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
