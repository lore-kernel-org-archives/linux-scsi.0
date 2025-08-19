Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD852773C1
	for <linux-scsi@vger.kernel.org>; Tue, 19 Aug 2025 19:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755632310; cv=none; b=ITET6xrw0xn4PdO8/qnZUVpWxraSoAhNbvNedPiOFqDStqEHjj6U5I4Tr9Ty+WO+v6QnlawP0i9ax1YwrgX47P1RKVGERGYV5C0rZ4qcutfVMoju+RIFgWP+diNdXhbjFHoznV0xEQl2keSQH9cPjwFplBGrOhHS+OKUOXkvBIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755632310; c=relaxed/simple;
	bh=bVI/ktF/z8ROeS1bmXaZdbpy02tO+BBrWMXw0/moEgs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ffK36VKZl1kkZpWD1jsQ9o1i//XmyvSv2q4r9RY3BerDuWPxZy/C397x5JUJC5ex4EOeAnZiRkAtNiZiE9RnH88HJj2RrJ6KZcCMELxwrAWIrEtPVvmdvPhXUoc+KFhEX02Mqylt/3OskEUlvuorK/bmDTp+Fmi/E1G8vpQ0J3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3uT0nu1c; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3uT0nu1c"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c60Hl4Vl1zm1745;
	Tue, 19 Aug 2025 19:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755632306; x=1758224307; bh=li0Ijy+F4rH4lGi+d4wVMCyS
	eO8ZhsLEX6NLYwyLgek=; b=3uT0nu1c9W4nkqqvPZmZ9NTDT9qegCqDSy4H9lBN
	Q6YJE2xYrtL2uLV4+4lFdTvO9y9jvs9ruj1p1P12+TT/gZ7atKrOfwwLcTi5AcGX
	6XKXvlIFQ+hwMkDMiOPxmNd25XFEpoe87KVIz2/5jRHJZu8WkQavuqEws60m5jmG
	GmzpuPADyadW91XDIQXOHMgzDQiB1Vx0Ipuf+a0Mqy3ykHEYbUEhg9zs5kas4m/I
	tYfK4/k+9dGfS1fl2uaT/yBoWgMIpeuko5epA52iQOwxJuIY2DbgPcDNaMQFtQU0
	3eKjMlBeCCUwwwR1xN7BVpis0vwzFo6uD066iDr9y8CKfw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id va_O8SHGxuhP; Tue, 19 Aug 2025 19:38:26 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c60Hg40zYzm1742;
	Tue, 19 Aug 2025 19:38:22 +0000 (UTC)
Message-ID: <8428d5d1-cc18-4586-aa08-65662955e1fb@acm.org>
Date: Tue, 19 Aug 2025 12:38:21 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/8] scsi: sd: Avoid passing potentially uninitialized
 "sense_valid" to read_capacity_error()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, dlemoal@kernel.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-5-emilne@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250815211525.1524254-5-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/25 2:15 PM, Ewan D. Milne wrote:
> read_capacity_10() sets "sense_valid" in a different conditional statement prior to
> calling read_capacity_error(), and does not use this value otherwise.  Move the call
> to scsi_sense_valid() to read_capacity_error() instead of passing it as a parameter
> from read_capacity_16() and read_capacity_10().
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
