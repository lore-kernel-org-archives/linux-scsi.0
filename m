Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261DD4F5E1C
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 13:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790774212; cv=none; b=leskl8YRQjE0Lp7RGGtyX/scdfNUQt1Gw95bcJj2yqkyblKlAF14Tsa4Yrb4IgSSY0P9fQIdZevNBPN5fZFtC7nlsQoXPPL5e63Cqyhfd3ikuK5qj72gnlk6zBokfZQpy/wfLPPOM95rtw4v9EZLD1maoPrzi5ATaUmrv5tpNAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790774212; c=relaxed/simple;
	bh=skgW2TF+RzkHHbRYpLtW0QQmaIJn4AGjtyfi6y/CqsU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YFeFSmytE97/Nn21ba118nlQodPzjk07WvWHUL3DBw2aHjvAH/P5sIaD3kyRONaVtnPjraVm8mfupzsIENCipv/PdwfmHUmnEIkbQf82B7lbYv133/xVkBhyq/t6jp4KihyDKcSLu39EEn1V4JUbDi16/slrK4CSjsRru+ftRqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sfrQv7lB; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sfrQv7lB"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hvwYJ4Y75zlfddn;
	Wed, 30 Sep 2026 13:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790774194; x=1793366195; bh=pIo2GLg2LMczcA57bLmXH1TE
	tnlMAxiGcDXrwkx0t14=; b=sfrQv7lBAO5ByVWEb46E4fdmJNof/bh3/PZrJgVD
	md17RKNvkCxtaGMEy0y8GsffItAy4btR2rrX6YkhD5zL4oAJYnzdzLEbSj5aGxeE
	2FmG9f7XENMLxzP1gCN8lU7vSmwQQI/UfhkFGjfPwESA5X66RQvSxznoJ4Y6kKzl
	/0UDCeK1u4iGybuckzKgZBI6SE22KH1Ful1OsgjUXE6L0tzFHlz2H/3VEMR6Dko7
	LGxup7by4f27XMxALI28RIqA4xOe9lTwQrSVlANRHSXH4djokubKgiU3ffp0E8/q
	yKmm/knJ0szeFU3ScaO2UB79++xkLaS+UF9oNl3OP0YWYw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jVx7bQQhlaZb; Wed, 30 Sep 2026 13:16:34 +0000 (UTC)
Received: from [192.168.0.215] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hvwYG3NQWzlfvpH;
	Wed, 30 Sep 2026 13:16:33 +0000 (UTC)
Message-ID: <d383363b-f2e6-49a0-9f50-719c0895bf64@acm.org>
Date: Wed, 30 Sep 2026 06:16:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] scsi: scsi_debug: Improve lock context annotations
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <cover.1790723966.git.bvanassche@acm.org>
 <c0546935640ceffd1b0513753dd469833e767c5e.1790723966.git.bvanassche@acm.org>
 <20260929233530.7CD061F000FF@smtp.kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260929233530.7CD061F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/29/26 4:35 PM, sashiko-bot@kernel.org wrote:
>>   static inline void
>>   sdeb_meta_write_lock(struct sdeb_store_info *sip)
>> +	__acquires(&sip->macc_meta_lck)
>> +	__context_unsafe(/*conditional locking*/)
>>   {
>> -	if (sdebug_no_rwlock) {
>> -		if (sip)
>> -			__acquire(&sip->macc_meta_lck);
>> -		else
>> -			__acquire(&sdeb_fake_rw_lck);
>> -	} else {
>> +	if (!sdebug_no_rwlock) {
>>   		if (sip)
>>   			write_lock(&sip->macc_meta_lck);
>>   		else
>>   			write_lock(&sdeb_fake_rw_lck);
> 
> [Severity: Low]
> Does this also omit tracking for the sdeb_fake_rw_lck when sip is NULL?

These Sashiko findings are expected and are an unavoidable side effect
of how locking has been implemented in the scsi_debug kernel driver.

Bart.
