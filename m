Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0468961FE9
	for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 21:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731273328; cv=none; b=ezB0RVO3twdB7UGcT/F3rdXRXrSyE1mRIntLS0XN1FCHhntjraPQQYdQ8VGwwV/+jN+bJdY3vpQzS4ihea1mBn/BBpgbA+QAOAUkHLFcRc6rPbP5V7ggfPScbA6BXcpiP8+ta0uF6/4KwoPZ///P2sFluDjONX7zWlSHgmM7/fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731273328; c=relaxed/simple;
	bh=bg6dKpvU1bXpiaE++PieSzHhkLAQcIwb05RHveeazj8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LhYRwO6PrdITq/f+f/Bp8zeHA5HbEdZfP5g9H8knd2/FI/5nXQxOqQfH2DpGXOH27ggKaTyexWNryCEaOaZ/OmTEMxYrk/Hj6wKyWeACufws/bQz4HoHu3GFlCp2OLmTm03GZ2JEmCugO1ZpQcwLNw+i6lqV1H03Uy+MHfaOTrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nE1NaS7H; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nE1NaS7H"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xmlnp3GnrzlgMVN;
	Sun, 10 Nov 2024 21:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1731273324; x=1733865325; bh=BQKtDsbVKByznZ+uusZ72tag
	dremYmE+/Mwl11VOf+c=; b=nE1NaS7HPFpJjpXdtvwUhf1dnaS9iKBXiduUrFiO
	jsNBEuAcLx0WPX5BCqU8Yc3y5FiDf3BJoMZvnw4VE/i4Pnn1Sy0uejz/Htm5mLqW
	WFAt0r1hTcSUF48KM33w3qEz2p7sZxL89DxmFmzJxTBhLiG0f8BMJjx8GQvljWw2
	vr5GNata7wrhnqvb351B3D2iiTVS3ubzRupR0GOA2lVDhy1RjJjOjzVuvjjstFvk
	q70JjAqy30K82lrT/0OSdUJK+bwkr6ZvD5DxjbvxPcJJbGsw8jjQQmrFm1qnP+Ho
	wTWfNrTJJke+iNWVF3rnIRBmuLfHcAl2TZefS/Y5XictQg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IQS3fgdenV9M; Sun, 10 Nov 2024 21:15:24 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xmlnk6hRLzlgT1M;
	Sun, 10 Nov 2024 21:15:22 +0000 (UTC)
Message-ID: <3a57d700-8f4d-45b7-a13d-501e82855c0d@acm.org>
Date: Sun, 10 Nov 2024 13:15:20 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 0/8] scsi: Multipath support for scsi disk devices.
To: himanshu.madhani@oracle.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org
References: <20241109044529.992935-1-himanshu.madhani@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241109044529.992935-1-himanshu.madhani@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/8/24 8:45 PM, himanshu.madhani@oracle.com wrote:
> Here is a very early RFC for multipath support in the scsi layer. This patch series
> implements native multipath support for scsi disks devices.
> 
> In this series, I am providing conceptual changes which still needs work. However,
> I wanted to get this RFC out to get community feedback on the direction of changes.
> 
> This RFC follows NVMe multipath implementation closely for SCSI multipath. Currently,
> SCSI multipath only supports disk devices which advertises ALUA (Asymmetric Logical
> Unit Access) capability in the Inquiry response data.

Something very important is missing from the cover letter, namely a
motivation of why this initiative has been started. Why to add native
multipath support to the SCSI core instead of using dm-multipath? Isn't
one of the goals of the Linux kernel not to duplicate functionality that
already exists? How does the new infrastructure compare with
dm-multipath from the point of view of performance and functionality?

Thanks,

Bart.

