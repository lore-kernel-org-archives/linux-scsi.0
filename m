Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF9238F259
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 22:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776290601; cv=none; b=ryEK0aSKAQdQ8K/5brjUlpwQLb1fQqskX7aOQN9CuPb/49xaqdI//HlOV3E5MH1xgpAl/IxC/+auGStVG9uftqpn8e/jP1VC55ORq9T07tHx47EcsG7+CU40a0hRS2joBPJ9jO8/9odTu7akedFq8x1DSFM4fN9pmZ0T2Qfu1HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776290601; c=relaxed/simple;
	bh=ORkbdONxK9L76mPwqowheafPV0HOAD14A5ZDBDPCPME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jvlCzerHpmmRgWfY45pIXF8LpNURbhW4axtdwKqlDJuGy7i4JJoqCgLghM+R0BOGw37hleojJMLyNvg/hSeOQRzPUQxaP+qMklPog8zgGwVD97SJzBjCn/C1uGsytcSIMba6vqhdUnRwcXd7il+PNhyE4se8MBjb6px/hlySQ5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=imfFx2NP; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="imfFx2NP"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fwwBb2qqHzlfgPY;
	Wed, 15 Apr 2026 22:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1776290597; x=1778882598; bh=ORkbdONxK9L76mPwqowheafP
	V0HOAD14A5ZDBDPCPME=; b=imfFx2NPyuwi+VOvsevRVo4N7DQ/tBjqpo+jPAQY
	YorI4MpUasXh/PMpeVRdz/LzDzVsmIlJlOKBGiYyRYLXVXUIjFD1QYZ5Pt0iiuN7
	B3YW2AxVzcz5pwlVYmrcOsbrJgM6oFHZe4RarIwzvRsrMH4A/lCshLG+UQUkJkgP
	+jjp2obgF/NCYwQJWrDkjytEWx9gnJ2Qain+WTZAqAGwdQubPjaMJUIORg8NEKuu
	pq7ROOD23NQXl5LuWLgIQSksETPAEw3UoJhkkjmdLyZKTEMzzuJvNxKOPw4wJvlY
	qpr8BXg8j/4KISnUo6FDBtjAN3myB4RMTL8oJQ3Ta+lXRA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Dc3Rme7Xg5Pw; Wed, 15 Apr 2026 22:03:17 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fwwBY1gCbzlfwJB;
	Wed, 15 Apr 2026 22:03:16 +0000 (UTC)
Message-ID: <a33d5a3a-3d7e-45a3-8362-a3358493d559@acm.org>
Date: Wed, 15 Apr 2026 15:03:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: smartpqi silence a recursive lock warning
To: Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Cc: Don.Brace@microchip.com
References: <20260414124118.23661-1-thenzl@redhat.com>
 <da1c23ea-5635-4872-b448-33f71219abc0@acm.org>
 <9503cc3e-2764-4e30-a5eb-fc996ff0555d@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <9503cc3e-2764-4e30-a5eb-fc996ff0555d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/15/26 6:00 AM, Tomas Henzl wrote:
> I posted this fix to address the warning and
> for now I'd like to stick with that.

That sounds fair to me.

Thanks,

Bart.
