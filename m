Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3350525229C;
	Tue, 19 Aug 2025 19:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755631592; cv=none; b=D+yVcqhvncZJpN1qdTfuf8vw4f7yfHyd8FLKniORmKWOy3kuJbTQh3gnqVQOS4RML6HdV/0qzp77JOB8t1e9HiJnAdwpswVoI8ydOA9d7lVola5zxUiOYEWzXZ8ESEmdw9I1Xmv7RYDiQrQuzS8tqZu6N1G7SszaecMrXlGkT+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755631592; c=relaxed/simple;
	bh=g/B9mTSY/+UICJqMryQGfX+yQjeoKc3Ak/00kTWxqvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jTWt62CQiOlzX1wz6ZTltWwMbGI0+dI5IFB9/8vlwn1G5pudWyZUQASMSD+7WvKmQerRI78IjuHm0DJ8e8mu+Eh77BVpS5KFHNRvUsPWxUXGTo+7iQVead/dGFxNkdx8RA64Ys/d+wIvZAXQhN/vi9NtA+GQqerIEYKJSiYp8dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4Pno7lCV; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4Pno7lCV"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c601y1TtPzlgqVs;
	Tue, 19 Aug 2025 19:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755631588; x=1758223589; bh=Yq5Aj08KW1djtAlM0LGorNvs
	4Qbc56CZobz9HEueZEM=; b=4Pno7lCVFtoBrbaTV+Bh8U9FenHUp9QJJYE+1X5b
	gEtH+/ML+FeO66NeOBY9h9U7Xg10Ut0Zw6m7kXLHOthU5KIb1C4RxRxaUjCMa1G1
	+VBdpJjw6Be9ZtdkqrD7bWgg9U6FvVQau8hZt3qZETSyh1Tn3tyKntv3VD80yEOo
	K7FgrL8YHdkk0HnlUNutCsVA12Yy4wfoS9S5MnmEwLWkeRSgcTgfenkIOF33yJvR
	i1woIIzmvNyNpiPsZ6Jm46Ap+SM33Oj3LsUS7P4sz1tGv1ylO9G5UXGOpRUE4+Wr
	XYDfkkdglXOWu7X6VlXmWS+0QiC3KcXSlXTdPQengSZKsg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2uxluotg-br0; Tue, 19 Aug 2025 19:26:28 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c601s5cByzlgqTq;
	Tue, 19 Aug 2025 19:26:24 +0000 (UTC)
Message-ID: <240eec29-860d-437c-8e46-9c7af3e4a0fc@acm.org>
Date: Tue, 19 Aug 2025 12:26:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/2] scsi: sd: Fix build warning in
 sd_revalidate_disk()
To: Abinash Singh <abinashsinghlalotra@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250816205329.404116-1-abinashsinghlalotra@gmail.com>
 <20250816205329.404116-2-abinashsinghlalotra@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250816205329.404116-2-abinashsinghlalotra@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/16/25 1:53 PM, Abinash Singh wrote:
> +	kfree(lim);
> +	kfree(buffer);

The traditional order for kfree() statements is the opposite order of
the corresponding kmalloc() calls. With or without this change:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
