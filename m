Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9103905EB
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 09:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779443614; cv=none; b=ommof6i8JIv5Sexarbfke2Gx9gpCgNcCANLGIBbSOUhdDHEV2JyezaM+T/3gky66Rtm/XPv6rTz38bX5X6LDJdT1vozKCJtCINfUajxncYf3J8K9NxTIfHmzftloPJyGJE99IXCfXDWzjpXE+cskv4g1xDYi52b/RiyI/+/WeNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779443614; c=relaxed/simple;
	bh=42l72Eg+avfK4sTP+9vFVvJeXF63mLvoFbk/grDTiwE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=noaKUjwEH0gI8qEVWFvhNNpBC9vvlAg7/gBe9RynL1WT1rs6Zax9LyBJOM1VOAI2utwuIemahVTK9qUMGR4iSBFSqcdWXx++EzK54ghT/JNFZ5XJC87NmcyBBDFIk3xGvIdpCi7uL66+xybKZZ++zvhgBm6zOeY/6AzAmQuMLUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gdoD6v4G; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gdoD6v4G"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5a87edf88b3so7311561e87.0
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 02:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779443611; x=1780048411; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C8V4lykeLs2+AjJKIfeMSaVVh+X6pS5Qv/pXMKfcsgw=;
        b=gdoD6v4GG14wN/yGLcuPTzCpB+Tk3T79ygC7PX9x3x0hpRAkAqR59EtcFVV+e2BBGa
         2Q7ex97IRvOX6KO3Qdsskciv9brzGNu1SJOyXfyQtbY5R/SAcG1aXF4+r2jNRmEqzlXK
         EHUo34x+s5hm0jIF+G2Vz6sH9Qj77UkOfiwJ4AqnFOk/wyLXMn8nrgnRCOkIRBegcZGe
         SwOovYLd9odQDfDWLceyhFHac67uFD9pERGnoOj3irxjo0oF3h31E6+kZvybEIdOajqb
         YS9IvpCjwJj+dLtKFJmPXn9MsvFHtz6aEBVymeiKPS37Mn6Tpw2R4OwoFAhHxPs7WJRX
         zy4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779443611; x=1780048411;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C8V4lykeLs2+AjJKIfeMSaVVh+X6pS5Qv/pXMKfcsgw=;
        b=Mt4AwiH4ZxK44XJ5ml0RmvhDWc5gU26w7Nn4Ku6OM2jLXnwWFCpDFQoZAlgYGQWbxg
         CWk4viIgITAfnxZrfjymeOxw071F6gcj7LIv2VMrPmkEL1f+onErl9TD2dUvR+KCD11h
         TYrUsicpy0Md4+NbrB0s35SpqHvSsDYndw518A6fRC0hhHIljUKfTlzHHyXxZdUZFsMv
         UYdYkFtGZvMhiA8Fsaonhp9gTJRuATPkKUdmt1EVIvyK8xkKTxS6y5NjIHFZYWnIkbqm
         zzHqrh8lGp6Zw5MgxoPsIEUcUKyh3Rqs18V5ZVz8t+jDNk9Krz3gPqkCe5QBc1yE089x
         LYFA==
X-Forwarded-Encrypted: i=1; AFNElJ89ahmFKOlfQyjunyggg7jgWi3ZNJm25sb96ECIyHHYBdeEV08uT3jZeSpF1wGwii+qAVHmYO6iYIuB@vger.kernel.org
X-Gm-Message-State: AOJu0YyOPS/gyeck3aUIKqkEib2WeKPzwe4AliTtY998pcfYrLuQ+P8k
	0gj16Zs5b7/QccCZRg710AHyVzhhd6rApg2eYuBMu3DCWSprWimZXBjehWecowITiCc=
X-Gm-Gg: Acq92OGdITcjZ/6A3EP9xH3NqF/lqIdyqdF5biLgzzhmamtlozJ/MUfS7t95jJpjCGO
	3VOqWkcLrB2caW04EGRLYnNxROz1oxsKUQ+ZJZlWSTRqpAtQhuX8Vwm5gRskGo45HcHxUcWEijq
	nDTJ86o2O4/shvk2dRlZYqTYWVMpi5ephe+cPCcEFhuDKfpJLWpk/8629dY6AqyfKyj9sDMb6wf
	ds8q7Ng2PbxBczp3waTsL9b8Rw7l3xpPm7qdYD/rQJvZ5YfVug6DR1GlhNex0eZSu2Cb9BgP5Ve
	hwI/EZLPvV9pGFN+uvJ1Y7/cENiSLH8CuMA7+6/8Hn9sucMHXGS5maMtk2DwBcfIanhNk7ryFv9
	fLe/ipTAlhn6ODUZN3ZqhZWGnbdJkEtCeyymQ9IOwIoMpotMOvOK8D5ao/C3FuSUVLITFlGtBgl
	ewTZvTsGnjjNLaMWdVVx2iHfLQ0/xWy2IxOF4FphoGiKR0CaWTbeJ9Op6GP13+GNjd/da1RO4vI
	qD15w==
X-Received: by 2002:a05:6512:1444:10b0:5a8:7426:d2da with SMTP id 2adb3069b0e04-5aa3232c532mr597549e87.7.1779443611319;
        Fri, 22 May 2026 02:53:31 -0700 (PDT)
Received: from [100.64.15.206] (h-158-174-93-34.NA.cust.bahnhof.se. [158.174.93.34])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa32cea754sm300619e87.53.2026.05.22.02.53.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 02:53:30 -0700 (PDT)
Message-ID: <b5bdfe69-8e88-41d7-99c9-a57b2c765e1d@suse.com>
Date: Fri, 22 May 2026 11:53:29 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: target: iscsi: validate CHAP_R length before
 base64 decode
To: Alexandru Hossu <hossu.alexandru@gmail.com>, d.bogdanov@yadro.com
Cc: mlombard@arkamax.eu, martin.petersen@oracle.com, bvanassche@acm.org,
 ddiss@suse.de, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
 stable@vger.kernel.org
References: <20260518121811.385350-1-hossu.alexandru@gmail.com>
 <20260518235040.48647-1-hossu.alexandru@gmail.com>
 <DINMKOIB4PRJ.1Y571RHF6NAQJ@arkamax.eu> <20260520180204.GA15940@yadro.com>
 <6a0e553a.010ccaa2.2ab173.fc09@mx.google.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <6a0e553a.010ccaa2.2ab173.fc09@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/21/26 02:43, Alexandru Hossu wrote:
> On Wed, May 20, 2026, Dmitry Bogdanov <d.bogdanov@yadro.com> wrote:
>> Yes, the length of Base64 decoded string is not deterministic.
>> Moreover, length of Base64 encoded string must be divisible by 4. Which
>> is biger that 4/3 of decoded.
>>
>> | MD5_SIGNATURE_SIZE      | 16   | 21,33333 | 22       | 24                   |
>> | SHA256_SIGNATURE_SIZE   | 32   | 42,66667 | 43       | 44                   |
>>
>> So, that formula is not correct and will break all iscsi authentication.
> 
> v3 (sent about an hour before your email) already handles this. Trailing
> '=' are stripped before the comparison, so the check is applied only to
> the data characters:
> 
> 	while (r_len > 0 && chap_r[r_len - 1] == '=')
> 		r_len--;
> 	if (r_len > DIV_ROUND_UP(chap->digest_size * 4, 3)) {
> 
> Using your table as input:
> 
>    MD5 padded:     "data==" -> r_len = 24-2 = 22, 22 <= 22 ✓
>    SHA-256 padded: "data="  -> r_len = 44-1 = 43, 43 <= 43 ✓
> 
>> Alexandru, may be better just to change size of client_diggest variable
>> to match it with chap_r like for initiatorchg and initiatorchg_binhex?
> 
> That also prevents the overflow. The length check is preferred for
> consistency with the HEX branch, which validates input length before
> calling the decoder rather than relying on a larger destination buffer.
> 
I would prefer to use the size of the original string as a buffer;
that will ensure that the buffer is always large enough and avoids
a lot of rather pointless calculation. There really is no point
in trying to be precise on the number of bytes to allocate; at
most we'll be saving 3 bytes which really is not worth the effort.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
