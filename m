Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D572D603;
	Fri, 29 Mar 2024 18:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711738647; cv=none; b=K6Asw4tg6E0rfjTRsLTkmcGCpv7TKAFhJf3oRMy+qGVAaI+HuxEUZPmxsGCsgOhYV3Ef/erC9g2fs/lBv1mw4Xz5pAHAr7/juK+wW1zGNpTuH52PP7QfviKFYseIi5BtsbfQ2gOEBUy3rraXpCuYWw2VqRugafRWujqSYpHlc2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711738647; c=relaxed/simple;
	bh=ORYzLMhYY4I0EtQ8hWoHz5W5Qmaccmx69jCVcFiyjus=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ceSqu5L4mHk/vjgqJK9ZiXtkddOmW10kcuj4gboAWKstzwGfBRkSvHbzKPVsjluUDbxESaLYlXo08pA7DE03oQQ1dsP+lshKbSMViPGnexnmQk+sT0imGlVjmNG76PoYxLOc5Byd0rdcbXo0TUKmv+MA0UT93tNx72x88z2fc44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2Ef14ySE; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2Ef14ySE"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5qQs2LWRzlgTGW;
	Fri, 29 Mar 2024 18:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711738642; x=1714330643; bh=zzP43llTKg7DoHlGhnYSqTEe
	pAlnkQyaYFDOl5YgzqM=; b=2Ef14ySES0oYGSxY8mTnPZZHm5q2wiSA9jvdY7Dz
	7NRmpccfKxLWUcN1wRI+kuYOJr7es7gMtnFpN/dvV5wRqDx15AHr6G88rkUd1S2p
	nx1/f5M39ll7JjrslUTQAodi1C0rGbE36nbImo9pwDbbD391M3PUtnNUkwGkiJwI
	L/qxvyLBprw0iTnmXCh3tedwFsSt9a7NXw3SttzNRZ3+/wKCJgamGwncA3S+Ppmw
	4TYJQf5FPqTDGmk3z8VQ07IFfAgcgNHaCBT+7uWbQd/FrVjAaurZMD3lVdUE26UG
	B7p7ywK1/VbkLVWD8ccgooHZ4ZSZvLTkZsWlRz28/U2Njw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9vmC3TeOYjRz; Fri, 29 Mar 2024 18:57:22 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5qQl4GmdzlgTsK;
	Fri, 29 Mar 2024 18:57:19 +0000 (UTC)
Message-ID: <a690683c-9390-441c-b640-230f4b76cb59@acm.org>
Date: Fri, 29 Mar 2024 11:57:17 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 28/30] block: Remove zone write locking
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-29-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-29-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 5:44 PM, Damien Le Moal wrote:
> Zone write locking is now unused and replaced with zone write plugging.
> Remove all code that was implementing zone write locking, that is, the
> various helper functions controlling request zone write locking and
> the gendisk attached zone bitmaps.
> 
> The "zone_wlock" mq-debugfs entry that was listing zones that are
> write-locked is replaced with the zone_wplugs entry which lists
> the zones that currently have a write plug allocated. The information
> provided is: the zone number, the zone write plug flags, the zone write
> plug write pointer offset and the number of BIOs currently waiting for
> execution in the zone write plug BIO list.

Shouldn't the second paragraph of the description go into patch 27/30?

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

