Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9C0308F29
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 15:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755273422; cv=none; b=tkIMIHX2WQGkq5GxyDuSW2PP1mKPpfFRO5iFVivOWi3aR53NsqsVIMqIpIpPa6GpyBBFPdvYvNFV2ipoq/PPatzQPz3349UWHAmITfNqQLiz3MUb0d73hN5MUe735mf8t4SNZIT32k0v2t2k0On/c2MlFgzTavzSqS28Jb+gRKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755273422; c=relaxed/simple;
	bh=DKCWxvfx3qZzMJ+ytnjQlR4wkH698x17t827+xbuwBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uhb4D0IZRdgEMske086mZ+CyOcCHfA1oGRicoNiQPlpG6U8UfQDSrwrXqks8TC0HE4QVOOCHVkQWoewC0aItUSnfQ/as5V6kEaS89ksXlAdygUZ1N7mxYUFYLeS/BzHXPeXij+w1nx+SQZ8Z9oFed02ZIa5lIFY594k1/sDsCAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qQFXrZMm; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qQFXrZMm"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c3RZ40C6QzlgqVt;
	Fri, 15 Aug 2025 15:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755273418; x=1757865419; bh=DKCWxvfx3qZzMJ+ytnjQlR4w
	kH698x17t827+xbuwBk=; b=qQFXrZMm6MD0Had9yCZn4E/+cIXVkC5IhhPr2+6R
	pxyE3GOBnvrm04Lg20yjgY3QNbgcpVM0BCptUvCa/TpPAeeMobvoKuZgn9wDYW9P
	qsqrJPcqS/elIwgtCS7kIaaX/3ZPZcfHA9J7SbyW21+8mUUsBvdOfZSTmaTRDZb+
	0YlbKUGBJRCW9X54ejj1hGFGugj0GLl4Ha1ZKJVabqcHuqWGgQDOm9RNvW7+qXLg
	yz2G0PxqysApW/Oi/3i9I3K+sZICmySlp/zUnN0gjqJCXjxIhSljwlpqDlkbzU8h
	4rhTL+qyD9nfcraIe1m/tPchLoDP+q8H/8zaZXHTTbx2QA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nszE9uEwTHTF; Fri, 15 Aug 2025 15:56:58 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c3RZ20GtYzlfnCg;
	Fri, 15 Aug 2025 15:56:57 +0000 (UTC)
Message-ID: <e18b474f-04db-4b4c-823d-7c6003ca85a8@acm.org>
Date: Fri, 15 Aug 2025 08:56:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] UFS driver bug fixes
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250813162253.3358851-1-bvanassche@acm.org>
 <yq1bjohqn97.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <yq1bjohqn97.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/25 8:27 PM, Martin K. Petersen wrote:
> Only the first two patches made it to the list when you sent v2.

Thanks Martin for having reported this. I will repost this series.

Bart.


