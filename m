Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4879F2F25E0
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 19:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761161718; cv=none; b=Y5s2ymU47zrT9QIWbmsKMwNdfQsuieekDp6FUyzwqdCxuoXJJh/EiZoccD9dJliFush9lxkjGkHoJ0umydQH0juXBMhBxuSbxmTKZgicf/N25B9Cv6aLIdFNIlcLnSr8x6SKpn/SLbi6wDhkItmtRx1FTCtQ3sBk5S914XwMUNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761161718; c=relaxed/simple;
	bh=J/1wwhZG84uD+iIR/Z/wa56pBRvyAeSUOODcaLJ4Edo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lkCqDpd+KvzjVJE7yNBN/MqPDaluupH3aXWMCpJ1U70Ie/o6DVz/7fjJ9aGbGUvlgn1Df0GPVfPeJs6C+/8AOIKPn9vl94HGK2gutCFAgMdhXLE/Zk5+h//5qfnf3kvXvM+lgTHnHiS5AqYKgjxq+k/0D5yLwunQy0CCkavITw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JLRrNbKt; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JLRrNbKt"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4csKBW13TRzm16kj;
	Wed, 22 Oct 2025 19:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761161713; x=1763753714; bh=I4KUHEEEl7i+VvAUM+VBastw
	Kqa+O5/D/0ZXJ3CZe8M=; b=JLRrNbKt72Gim57FOAcQKb6z2CT2LcCQHGGrYHUC
	dDWNFp8tlF5i8b88zLjJxJfn/gHz63kU5bOkVMhjJG4E6KK+LRToVEnrtXAAXf8W
	cc0fgkp8CNSGnvcdJUfieNoYnFh6AUCsD4On8iXM8O/Tmhgbc6duNiSfwvXFswnJ
	oe6GUAUZf7QES//FUsW4hO0HNzPwqYakU6WTnbMIv5QdUKx0+VcZLtgaaQIjD8tK
	dcT/IRe2i57T2xABm47oehGsQZw+00YzT4ptHfVTfBAtuXEZHxttR/q8SvekbVzJ
	oRvrIJ6JyW0w8y4rtHwgh+IniHcSbW1ebO69/1Wns5Dv2Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id m-Me72Ey8RlO; Wed, 22 Oct 2025 19:35:13 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4csKBQ6yjxzm0yt8;
	Wed, 22 Oct 2025 19:35:10 +0000 (UTC)
Message-ID: <198e86aa-ceee-4b89-bd50-81fffb1a3d7f@acm.org>
Date: Wed, 22 Oct 2025 12:35:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] scsi: ufs: core: Add a quirk to suppress
 link_startup_again
To: Adrian Hunter <adrian.hunter@intel.com>,
 Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
 Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org
References: <20251022180819.86180-1-adrian.hunter@intel.com>
 <20251022180819.86180-3-adrian.hunter@intel.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251022180819.86180-3-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/25 11:08 AM, Adrian Hunter wrote:
> +	/*
> +	 * This quirk indicates that DME_LINKSTARTUP should not be issued a 2nd
> +	 * time (refer link_startup_again) after the 1st time was successful,
> +	 * because it causes link startup to become unreliable.
> +	 */
> +	UFSHCD_QUIRK_NO_LINK_STARTUP_AGAIN		= 1 << 26,

UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE might be a better name since it
doesn't include a negation.

Thanks,

Bart.

