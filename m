Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0AA36A01D
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 17:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806016; cv=none; b=U/H146fKdwrng1+ByKAAo8N94U7e4A/HDc+mkDiQhE5W7+9Poz9A3DvhCVcDkO51gReqIOXoUTyHATw1N8Q19++g16hzTUomsEa0CajSf0T1T639QPveH8UBZfdrM3SKRRSPc4nDR15XRpg4NaIYexesOkqBgqtpmaLaeS1kELs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806016; c=relaxed/simple;
	bh=Pj7hb0thnVYklU9lcvNe4Aa44oZvaRsdl6ocpXj7HhA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t+BYO/QSTBYhD0ZAJhH/E7DoU8hTBZ/JDhk7wm0JxLlZp8jBLVcnhSabOM0zowdKK6YSQNkY/o2EpbFhAzqYBFF95pTlH9SI0YSkvtn6qQLQfTzxFoC/A5hoaEZJXp+g2w2t1h+zOIgCHXrR1RYNJoRBDTJk+SfXIF8e+8ghGlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FkXS/Jua; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FkXS/Jua"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dmZPV0rVtzm04kf;
	Wed,  7 Jan 2026 17:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1767806012; x=1770398013; bh=Pj7hb0thnVYklU9lcvNe4Aa4
	4oZvaRsdl6ocpXj7HhA=; b=FkXS/JuaYw8UQhFFWUl6Md23IUBhd9zWrrpHHinC
	YJ057dWOTY/mqUxpXylUGS9QMONqQrzBbGNawIOqhL3SMfgOXXgCWFFbff9MbLDT
	/Tto7UYJxuSloDV0Fu0aeqaLCnETYD/t3AW4UhPNtJnmjiUmxIuS695oQo0fkww0
	yWhvhe6gqwSyRAnGtbHCTcER6v8OOr9fI5WtHbClEK8JjnN1B+UD5kPxc9rqNaV3
	jsB7qehUs7i54ydg/qgJSiws0qmxpx/seTPqiC8C/lB5bW2OlZPulMD9BDRv5ha+
	sZ/zoB96mV6IIICn9KgMS6GqxLv69X9fBxUzz9q+tECGWw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TBBlwgiFHFvQ; Wed,  7 Jan 2026 17:13:32 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dmZPR0Lzszlvwpq;
	Wed,  7 Jan 2026 17:13:30 +0000 (UTC)
Message-ID: <0c81133a-7f76-4478-bd69-837343298c4d@acm.org>
Date: Wed, 7 Jan 2026 09:13:30 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix a regression triggered by
 scsi_host_busy()
To: John Garry <john.g.garry@oracle.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251007214800.1678255-1-bvanassche@acm.org>
 <yq1h5vr4qov.fsf@ca-mkp.ca.oracle.com>
 <fe16b110-300c-4b13-bf2b-56e7f2c6f297@oracle.com>
 <540bad1d-ba01-4044-94e0-4f7b05934779@acm.org>
 <cee0f307-b875-4578-b7ed-43daef2b238e@oracle.com>
 <91e387ed-fba0-4622-b357-53356fd7fee3@acm.org>
 <d2294529-4054-4936-ac76-20c878bc74f5@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d2294529-4054-4936-ac76-20c878bc74f5@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/7/26 5:25 AM, John Garry wrote:
> Any update on this?
Hi John,

Thanks for the reminder. I have been OoO during the past two weeks and
that's why the promised work has not yet resulted in the publication of
a new patch series. Anyway, I plan to do that this week.

Bart.
