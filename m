Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AEAE22083;
	Thu, 30 May 2024 19:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717098495; cv=none; b=DJHXbLSLSKui0KTlro+cxU2hF2lUwBZi6rsMlfIXwkc3m8c9hIV6r7duK3xU/bhYy1dj4Enb0V95+whLRobRHeIcYSEEqDn6MpUrqBS2ZxTlVEMSzNww1P2GgWYXK3tSowryBvZeOHDwCfkFBAx9RpVHaNZehG0rwxaehrfum30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717098495; c=relaxed/simple;
	bh=Xz3ogwuxMcT8mseQkd/vkJ3iL45E/fwd3ZDy89sVfz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VAqbaXb9NhNrCu9FFCqCAcEyPJxZcthtyS8p2G0BdRcpgzepkOOmwBT7VbJhigcb4c3S9vbiUk/HQq9YuZSGqPaObv65q5MeFL+rJ+S7EbvJHTIrLSfVH07utMPAH/L/ngjk9fz01cu2dDxl8DwicVSE/Lux9uHyd/zV6uC8ou8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rGDN10KG; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rGDN10KG"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vqxcs6krTz6Cnk9T;
	Thu, 30 May 2024 19:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717098489; x=1719690490; bh=dyGzZSWLsyackA37XVq9nl02
	3b/Svu5aWeAkdF5uPBU=; b=rGDN10KGvDcmbfFgFHYGEoAseaR0fagJcQ3Kgqep
	Lubtq290OW2C91K9XeG9czurQf/wRzgWunDsFsAMxwo9wkZ+qvmKm4R0a1IhEFZs
	mDWx9FVqmwxJ1uh0jSOQryGjPbUDq3am1SqtPcwOYoYJeBhb7NS+0SA896mRwdax
	46is36KI4H8l2gh+0pU4iA/zQI9dYtDmKkBX014QQbhNpPugXqH9dZ3vHZGJc29x
	QNtcdSGsqF3KHp+AUYXr1LTxQON8ZUdXzrzE864yWEALccGzPTaLHZ74IyVMr54h
	4/Z8+E6et0bHB2aWboLglX7RhsaK/9E7/5fftwo1zhVw2w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZPBeIfQpf7PL; Thu, 30 May 2024 19:48:09 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Vqxcl3Zhlz6Cnk9F;
	Thu, 30 May 2024 19:48:07 +0000 (UTC)
Message-ID: <55cbf9eb-a52c-4d1f-aaac-5d426b60d436@acm.org>
Date: Thu, 30 May 2024 12:48:07 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/12] sd: simplify the ZBC case in
 provisioning_mode_store
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Josef Bacik
 <josef@toxicpanda.com>, Ilya Dryomov <idryomov@gmail.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 linux-um@lists.infradead.org, linux-block@vger.kernel.org,
 nbd@other.debian.org, ceph-devel@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
References: <20240529050507.1392041-1-hch@lst.de>
 <20240529050507.1392041-4-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240529050507.1392041-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/24 22:04, Christoph Hellwig wrote:
> Don't reset the discard settings to no-op over and over when a user
> writes to the provisioning attribute as that is already the default
> mode for ZBC devices.  In hindsight we should have made writing to
> the attribute fail for ZBC devices, but the code has probably been
> around for far too long to change this now.

If Damien's feedback gets addressed, feel free to add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

