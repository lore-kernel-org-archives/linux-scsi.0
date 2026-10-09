Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD6C136672
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 01:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791507674; cv=none; b=WiBrt21SDMr0YKY/aLJyUs3cxnSQXVPXT5Fxg4VfhCB42hKnisBU1FJW7pZIOE7KlNqYttPA2guIVc+cpYDvoRx77xF3jIb3grAKTQ/uXWbr16OvFzygkzRb3pD6RFCw4GQodIw0+/oQ3/PfpCBJMfVP+I/B0X3DvYvTPGvzJB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791507674; c=relaxed/simple;
	bh=bj0m0c1iSFU7Thu/rm144aRLD29y5aSW4d3R4TQ5Qns=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=I2NuQnvR9E6ja8980iNsJgPbrR6d1Nopa6jPZ4YR/CudYLStENpUFRtBnz0Z0k9fuM2LnhTdbyleV70TPka6/6GIs0MZfsWks5GTmvmC5V5aZFVmOeRFR/mTIZB+yirpc2akU10+Mybkj11HRqs9E0uqvhRgbLbU9XhecU9Gsc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=ppjLpn3B; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="ppjLpn3B"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bj0m0c1iSFU7Thu/rm144aRLD29y5aSW4d3R4TQ5Qns=;
	b=ppjLpn3ByUXhJkilnxqX+9BZmTP/1/HxcMLyce7Kq7A8YdiRJWM8p7hwr9J93SnDVt8Bqyeng
	V3US7YO1/wmmW16HDBDoZN/j0eYeT+QkwdW/as2rxU24H/jCPov92Tf/K6AwlUxigWz5I1ulZYy
	4e+HyUExuKjQoR4GuR2iMXc=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4j17XR0FhqzRhjW;
	Fri,  9 Oct 2026 08:48:55 +0800 (CST)
Received: from kwepemp100008.china.huawei.com (unknown [7.202.194.221])
	by mail.maildlp.com (Postfix) with ESMTPS id 43E0F40561;
	Fri,  9 Oct 2026 09:01:06 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp100008.china.huawei.com (7.202.194.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 9 Oct 2026 09:01:05 +0800
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 9 Oct 2026 09:01:05 +0800
Message-ID: <3eb013eb-800d-468b-b2a8-2a9fb7db121b@huawei.com>
Date: Fri, 9 Oct 2026 09:01:05 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2 3/4] scsi: hisi_sas: Clear PHY error counts on phyup
Content-Language: en-CA
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-scsi@vger.kernel.org>
References: <20261008032605.2853026-1-yangxingui@huawei.com>
 <20261008032605.2853026-4-yangxingui@huawei.com>
 <sashiko-outbox-163572@kernel.org>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <sashiko-outbox-163572@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemp500015.china.huawei.com (7.202.195.9)



On 2026/10/8 11:41, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] scsi: hisi_sas: incomplete error clearance on phyup leaves software counters stale
> - [Low] scsi: hisi_sas: missing clear of DWS_LOST and RESET_PROB error counts

The suggestion from Sashiko is appropriate, update it in the next version.
