Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB499463
	for <linux-scsi@vger.kernel.org>; Sat,  2 May 2026 16:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777739880; cv=none; b=GS7cCr0Ol200dedQN92EJPIPemIftnigOfrBt6Y93RAjJinSUyk/4NGfU8fgZU2e3aupqs+Si0YVNTTyvc69RP8w0oFy3BxmvF0TvooTftLSqWkBpGATUB1+ED/vEgiiwusUcUzaRGJ40obdb51xzBD6UC9dIs7/WlNzfSN7zZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777739880; c=relaxed/simple;
	bh=RDlEQ61r56FRa5nBeS2vjKbNUFvoCL1Srbe4Bhyr10o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cQJhqeafzoOwBTe+gK91o6fD+uG/RctZfGJVu5zEDLFqD2T54clZ9LUxrtWIAmnzWqIef4WoTOUDh3sPyTNyRqf+bS2LgVhKWfdL3hWqXYk5caHoafIbVAzydMUrcEkb9SPPYimjTZV/xXJ/MMbxflY9lzZSpOQey4fMqHW5izA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ptv7xl1n; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ptv7xl1n"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g7D9D2tVsz1XM6JY;
	Sat,  2 May 2026 16:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1777739870; x=1780331871; bh=92nFkFOoOHLFLaJq/K4boQsd
	AHcoOOyCPDDeC5Px5NI=; b=ptv7xl1n4fz2kQKpcZsKYqyC1M7or/fmIu8pbGR8
	MWJ3DfMyxolIoodcS99AVnSNra3ifsG6nLsGtovYjCQb/uyQzKfF3BwVaXBYKvTv
	TWG8AwoJEp1vziCbTf3dbMWYuZWSaDWaiyDw8JGz+OrYgmDu5qG9YIQRWHQqLG+K
	eZ9FuUFcX/LGIqg5qw8zxPOCrZCXnfL/nq1z+xTeguaz0PHD7W/PzqOlHGk2Mlfx
	yAxXOUHtMKc7UuK51UIY1EbbQD+HuRCxykHIhKAPbw0N8qpU7BGCQN3mrJEmNe4k
	gn3qvQG5okPuX60siiK5L9Mv792ojGhgKHHaKMVxHu+IMw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SXSqz1Bmf8TQ; Sat,  2 May 2026 16:37:50 +0000 (UTC)
Received: from [10.173.182.157] (unknown [62.245.128.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g7D983N0Cz1XM5kW;
	Sat,  2 May 2026 16:37:47 +0000 (UTC)
Message-ID: <5de0e746-1a90-4a41-a36b-e56a4fcfeee6@acm.org>
Date: Sat, 2 May 2026 18:37:45 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] scsi: Protect INQUIRY sysfs attributes with mutex
To: Brian Bunker <brian@purestorage.com>
Cc: hare@suse.de, linux-scsi@vger.kernel.org, krishna.kant@purestorage.com
References: <cc6d3238-5574-4a0a-ba3a-2660687ec292@acm.org>
 <20260501221153.90440-1-brian@purestorage.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260501221153.90440-1-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/1/26 3:11 PM, Brian Bunker wrote:
>> +	sdev->vendor = (char *)(sdev->inquiry + 8);
>> +	sdev->model = (char *)(sdev->inquiry + 16);
>> +	sdev->rev = (char *)(sdev->inquiry + 32);
>>
>> I really hate these.
>> Can't we replace them with accessor functions and drop the pointers?

Hannes, what type of accessor functions do you have in mind? I don't
like accessor functions that only do half of the job (returning the
start pointer but not the length). Or are you perhaps suggesting to
define accessor functions that return a struct with both the start
pointer and the length, something that is uncommon in the Linux kernel?

Another possibility is to change sdev->vendor, sdev->model and
sdev->rev from pointers to fixed size strings into '\0'-terminated char
arrays.

Thanks,

Bart.
