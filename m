Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1062178E3;
	Thu, 24 Oct 2024 22:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729807722; cv=none; b=V2wFh4MOIiwNq/bbvulxlJx63haaKPVHOHiUARIQwJNFFV+J+hQ3dh/jlkhmVBAY3ni5BN0tCwcEuIRzQ317GoouDTlEEWSWKsgYjKRibpIzMwU2s8tTL6FaMB5OVvxzAkVdJ1dLDO3HzxMMGtsg2qFVFZd40SX7kmYimbOCX30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729807722; c=relaxed/simple;
	bh=wPCC8waIpNR0bDaRcVMGppxjJm0tLHhBTl6JzRvq7xs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NZrcAinhdpd0FaD0HQN8qHKc6s5ZYdNn/zDvxcS75/KpcHyhH2uyJvzm6LXo0mFMVXcywoaesZuOVpEcCCpWPvP99V0LTHOJnY2/SQXS48/FBZHmEfLiIj4MvzULpdFJvum3VXsxU5ZDK7bJa0Wd26Jot1EeFEuK73od+lOgkX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=R0npGY60; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="R0npGY60"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XZKmy1h22z6ClY8q;
	Thu, 24 Oct 2024 22:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729807712; x=1732399713; bh=wPCC8waIpNR0bDaRcVMGppxj
	Jm0tLHhBTl6JzRvq7xs=; b=R0npGY60lGw1gv8I45g56BEeYfgDbuXyO6lMfgcK
	GopU48sN70vdlQGNJOMxlxXyrB3eCUBNeDtlK7ULcdUnYjUCdYKA24hYsvlKsPjs
	yag8psXPa08DuJTH+vavTSq8SqNrSogCprq3gztY86UqKvkYhJn7pO/3Bm0JQyPi
	QYKwJiu/LUBal9PgvKchPqZN/Cn5yf3TAJzpZtcotp9wsfbL6MScsHVjNxLaDVAh
	sq3nPEVyr0I8OWhpE2Kfs5DdE+/b3zdXjhsjoU6ypDpjWv2qAwaEIAQg79xqHoRe
	UrsK3gn9HTmmbsLq+7gBAe2GVb9fajr/bITIPpMjA7tX0A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FL7kds6d3v1o; Thu, 24 Oct 2024 22:08:32 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XZKmw3qB7z6ClY8p;
	Thu, 24 Oct 2024 22:08:32 +0000 (UTC)
Message-ID: <823ae610-3858-47c4-b658-5c1a3df2d4d5@acm.org>
Date: Thu, 24 Oct 2024 15:08:31 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] scsi: ufs: core: Remove redundant host_lock calls
 around UTMRLDBR.
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241024075033.562562-1-avri.altman@wdc.com>
 <20241024075033.562562-2-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241024075033.562562-2-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/24 12:50 AM, Avri Altman wrote:
> There is no need to serialize single read/write calls to the host
> controller registers. Remove the redundant host_lock calls that protect
> access to the task management doorbell register: UTMRLDBR.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

