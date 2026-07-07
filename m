Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC8241D4E7;
	Tue,  7 Jul 2026 17:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783443942; cv=none; b=RtrNgRwEAW/FiW1WRDdryLz9CDQhHeCUd03dypkVt8Ltu3SzDPoLbNTDzaEN85AoYEAMrjSb/70vEbyjIPNfGf8t9Wbn6ETYHWTCOrbDJU9KnzGgsBkeLz3qVhmtEKP/0bpDgWY7PhcjgOYfx0mKm8byoe+AiAK86i6/DKpCMZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783443942; c=relaxed/simple;
	bh=d332qBq04WD1sRchjoRDKLTOSHajl7HeBLRHQJBz8jE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D4meMsokr/PE8BoZijF/Hfd0FlOhqRwB1Ic4/kh4x2+dYtqw1cndgqhTefBZ2a/i9BpXL1Bw8YCnm7o4BbZCobFsVKTwjjsjaDJ2/Nbpmi6lH6ozTCUIM0Vk8N2P5sOaK+dwNBroY1j3XKEFx0DnEfb0SztJmoD0bgIcOq2zDIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NxQc4YhH; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NxQc4YhH"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gvnfs0cRrzlfdfc;
	Tue,  7 Jul 2026 17:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1783443937; x=1786035938; bh=6Bwsi57HcmkEQKr+5HfdxeTI
	5zyxyfuPidkZy/XE8uM=; b=NxQc4YhHCxHEyedflmy0r99xwkIXHp1fsvhTdym0
	DFvVOFIZNE97suKgDESLkfPowfX9aG6bCKW3OyXOK7ULgy0Vej4Bw5PoffPDQOK3
	cwDoRPuNbokzpP6b948alUCw7B/IZLS9DH6Sa0je8Z97+JNR425UiO3JFH0844tE
	CIVCfg60Noue9cg+5LBVvfQKdhyHHOuYTJx8/z+BsnVHJmgnz/QLxvZE/ITcElGW
	gp2In/q3mi8iboYmJpQv5tnKJZXH+Rp32zWNL7bFa2m7ilZnBAsHT+9hoWWtu3bd
	JpAlql3Fsii3KKErxiVu399HEKEql0ZaNOHa2CNfnJ1b/g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fPS3BN8YRRSU; Tue,  7 Jul 2026 17:05:37 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gvnfk4k3Qzlgqw4;
	Tue,  7 Jul 2026 17:05:34 +0000 (UTC)
Message-ID: <71349dae-11ae-4014-90f5-ccd68779d687@acm.org>
Date: Tue, 7 Jul 2026 10:05:33 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv3] scsi: st: use kzalloc_array()
To: Rosen Penev <rosenp@gmail.com>, linux-scsi@vger.kernel.org
Cc: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 open list <linux-kernel@vger.kernel.org>,
 open "list:KERNEL" HARDENING "(not" covered by other
 "areas):Keyword:b__counted_by(_le|_be|_ptr)?b"
 <linux-hardening@vger.kernel.org>
References: <20260706233029.814601-1-rosenp@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260706233029.814601-1-rosenp@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/6/26 4:30 PM, Rosen Penev wrote:
>   static const char *st_formats[] = {
>   	"",  "r", "k", "s", "l", "t", "o", "u",
> -	"m", "v", "p", "x", "a", "y", "q", "z"};
> +	"m", "v", "p", "x", "a", "y", "q", "z"};

The above change removes trailing whitespace. Please either
leave this change out or describe it in the patch description.

Otherwise this patch looks good to me.

Thanks,

Bart.
