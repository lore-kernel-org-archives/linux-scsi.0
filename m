Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F822566D1
	for <linux-scsi@vger.kernel.org>; Mon,  7 Apr 2025 19:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744053546; cv=none; b=SEzcoHKJuBV6ns+2kbYxc52k1NAbJgXLME4xxUjRw/YbYJWKuzSFZNyN5e54YLjxZRRnUQQur8cHHdUpomfQQw+W8qH2y5jo5o22+x+e+eppYsa9OVENGAaehBF9rwRzuSddfgh2ayHFMUiNWX0LH09QAJzSGoAJmxT9NvZQ6RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744053546; c=relaxed/simple;
	bh=cQ2ZUgVjYmrr4WKKRZ8VDoXPgMMrUVALIAQceoVfUEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HrQIXURHjgoequIA5/QOZXw9AVYBdpl1Wyh+4xeOpureH6jMrgYfReOUH17yL+lpz0CaZYVjX15RijbZqhQsCk/RmqAbfQbay0U/SiJd0Sd0ubngS6J2rNaaowPY29DcyeA2cjGuigdAUbp21hfg0uhNNY9QIItpYnXZehWo128=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tXXTI0iA; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tXXTI0iA"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZWfCC0xZWzm0ySk;
	Mon,  7 Apr 2025 19:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1744053542; x=1746645543; bh=Hgt3srkR+l3vbPh2B+ZptR0s
	6465KE08Q/iBbdVR67Y=; b=tXXTI0iAJ4gb5vLcUReVJeB9Lc8D0Ms1b5VAMlj7
	pdKJaIkM/B90IgDzSeE38AvSueEEIxsq9UoSEGp+lENg1xw6uI1EMSN0yM/FPZ4u
	AoTM/ZEpTm/Fjo7x0oyg+VYSbzMRsQYTqdUq/sIEzA1snHN/qcYaaISa/5yLfNMO
	BkGEIVDHm9LmM0nxVW/jrYW2VN0Z93miBWlCDFlrc+OQ/hSQUfq9JnqyQmAUvNu9
	kIzDArb1ZWdzln+iK4ylpXRW8xUuBb2UIN+tLOXEASC5N6dyJYD6RAbqE11nU6Xo
	du7jCr2Qz2TRYiEeHHWSMmeXr8dDvH8N/gMC5Ai5E959Jw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bTJdJ0dPsyip; Mon,  7 Apr 2025 19:19:02 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZWfC83TVhzm0djk;
	Mon,  7 Apr 2025 19:18:59 +0000 (UTC)
Message-ID: <2eb58df6-0985-4901-9494-9ecbe77a0b8e@acm.org>
Date: Mon, 7 Apr 2025 12:18:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Fix a race condition related to
 device commands
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250314225206.1487838-1-bvanassche@acm.org>
 <yq1cyeb9pjp.fsf@ca-mkp.ca.oracle.com>
 <1c08cc57-60dc-4efc-870d-6b9688c85b2d@acm.org>
 <yq1a58rstcs.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <yq1a58rstcs.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/7/25 11:55 AM, Martin K. Petersen wrote:
> Is there a problem with this patch?

Hi Martin,

That patch is fine as far as I know. My question is about timing. Is my
understanding correct that all these patches will be merged during the
6.16 merge window (three months from now)?

Thanks,

Bart.

$ git log --format=oneline origin/master..mkp-scsi/for-next
1b4902f0a4f20aaea14d51a378368fa697467901 scsi: megaraid_sas: Driver 
version update to 07.734.00.00-rc1
aad9945623ab4029ae7789609fb6166c97976c62 scsi: megaraid_sas: Block 
zero-length ATA VPD inquiry
a63b69f05f999acae91b0b50d7c5fe4fb241dbaf scsi: scsi_transport_srp: 
Replace min/max nesting with clamp()
1fd2e77b889761d9bde0c580518689d1d8e83117 scsi: ufs: core: Add device 
level exception support
bdab40480b146e2f37f4c7164cb47f526e77ee6d scsi: ufs: core: Rename 
ufshcd_wb_presrv_usrspc_keep_vcc_on()
a2d5a0072235a69749ceb04c1a26dc75df66a31a scsi: smartpqi: Use 
is_kdump_kernel() to check for kdump
f7b705c238d1483f0a766e2b20010f176e5c0fb7 scsi: pm80xx: Set phy_attached 
to zero when device is gone
8a65b75dc4b235349fa6f3c89d381405956d431f Merge patch series "ufs-exynos 
stability fixes for gs101"
cd4c0025069f16fc666c6ffc56c49c9b1154841f scsi: ufs: exynos: gs101: Put 
UFS device in reset on .suspend()
67e4085015c33bf2fb552af1f171c58b81ef0616 scsi: ufs: exynos: Move phy 
calls to .exit() callback
deac9ad496ec17e1ec06848964ecc635bdaca703 scsi: ufs: exynos: Enable PRDT 
pre-fetching with UFSHCD_CAP_CRYPTO
7f05fd9a3b6fb3a9abc5a748307d11831c03175f scsi: ufs: exynos: Ensure 
consistent phy reference counts
f92bb7436802f8eb7ee72dc911a33c8897fde366 scsi: ufs: exynos: Disable iocc 
if dma-coherent property isn't set
68f5ef7eebf0f41df4d38ea55a54c2462af1e3d6 scsi: ufs: exynos: Move UFS 
shareability value to drvdata
3d101165e72316775947d71321d97194f03dfef3 scsi: ufs: exynos: Ensure 
pre_link() executes before exynos_ufs_phy_init()
72eea84a1092b50a10eeecfeba4b28ac9f1312ab scsi: iscsi: Fix missing 
scsi_host_put() in error path
20b97acc4cafa2be8ac91a777de135110e58a90b scsi: ufs: core: Fix a race 
condition related to device commands
daff37f00c7506ca322ccfce95d342022f06ec58 scsi: hisi_sas: Fix I/O errors 
caused by hardware port ID changes
8aa580cd92843b60d4d6331f3b0a9e8409bb70eb scsi: hisi_sas: Enable force 
phy when SATA disk directly connected

