Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DE278F51;
	Tue, 25 Nov 2025 16:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764089495; cv=none; b=HsOi0xjquQfBFmQ7D3ptCgAN6CAVuOgt6KJFB0Fvp3AtZrUjyDMy9DdbcnjS0r7wEbKZY1FRLrFciTLXGwLZnYtJDsPwGnhPxkYD7pwJidXQn75dBSE464uGiTy928iJ7ix1EWu6dRg0u2StSfBcX0yfK436y3ECM6kwljW+sC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764089495; c=relaxed/simple;
	bh=iCvDzHGyBPoihON4CVPtoS6u4mDRthuD32wQ1iX7urY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Enm+TTo7qp+FTm9jF7baNW8gJFw6E5nKsQMlzf+1N+8PmAiljxJdjYEtoOMt3dUpS7WYEWkAzbHunpgSUyOGZsDb06XHArWYCVY59+ghzmd7rZZT84ac1vgYA6VNG69kLCgaDBr0TAnbaJ5dyvbgIwjqi4vBtJ+Mj34oGjY3kmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=POvdcLN/; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="POvdcLN/"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4dG7xx2yY1zm1CH6;
	Tue, 25 Nov 2025 16:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764089491; x=1766681492; bh=iCvDzHGyBPoihON4CVPtoS6u
	4mDRthuD32wQ1iX7urY=; b=POvdcLN/RbjSsiAvJXqNIEBf73LvkFVRu66vjrTP
	bC47YYJZucrWFn1Y/t/cyyg3Rv6cz0Re4ypdGWbnQbkp2XBXA/1bdDoAdtFjgGHt
	oadaDHc0yjwfpizzxuFsJfviDKyjePvBu1H4A6zv/QK8/mDb1wiotJ6HtmE+9b6T
	Ue75QEfdfSDk0Qa1AWeHqEHyaTg67M9eAVQ3PTShZ13Ol3yw9ArpuJ6++Wopi06/
	kuJ1QFV4NEHCjnOaREyGkr2q77+BkBKl10OFAtXNWFpt8nPHheFDdx1qcj5VG8HB
	DKY6pC8svJm/iZfZTJX/C9nJFF6Y3DjEwO1wiN3+ZzWVww==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ne5YNMqtZlDn; Tue, 25 Nov 2025 16:51:31 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4dG7xp50Fkzm1DHR;
	Tue, 25 Nov 2025 16:51:25 +0000 (UTC)
Message-ID: <88e8ec82-f20f-48d4-b20d-eb2807334654@acm.org>
Date: Tue, 25 Nov 2025 08:51:24 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] Increase SCSI IOPS
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 Hannes Reinecke <hare@suse.de>, hch@lst.de, dlemoal@kernel.org,
 cassel@kernel.org
References: <20251124182201.737160-1-bvanassche@acm.org>
 <28f63d40-f9c8-4c84-ac3a-9d56eb9b4072@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <28f63d40-f9c8-4c84-ac3a-9d56eb9b4072@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/25/25 2:08 AM, John Garry wrote:
> Please provide results from real HW / real scenarios.

These have already been provided before. From
https://lore.kernel.org/linux-scsi/20250910213254.1215318-4-bvanassche@acm.org/:
"On my UFS 4 test setup this patch improves IOPS by 1% and reduces the
time spent in scsi_mq_get_budget() from 0.22% to 0.01%." In that test
I/O was submitted from a single CPU core.

UFS 5 devices are expected to become available soon (2026). UFS 5
devices are expected to support up to one million IOPS. That is the
double of what the fastest UFS 4 devices support. Hence my interest in
improving performance of the SCSI core.

Thanks,

Bart.
