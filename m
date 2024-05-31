Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB3E1946F;
	Fri, 31 May 2024 20:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717186606; cv=none; b=REcrVEgiJeJGhXgsyo9qmn3oKBLh5udTQnvWnMoYtVtgcUyp9pojOf157Tj+lwlWoCPrvJD0wemT2Xmgwr2ECUnzONYTZD9Vx+lwQlGkMeY5GrQWbdJjtcgGZFBMiG+V24nXl7z49RW3ihiyf/sbai0RC/4TSBGSu9VTAc7w2ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717186606; c=relaxed/simple;
	bh=aeHqw/Umk2phVuHyVlU7L93AehaqbmYNZjg+RgQY0OM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r8qVWJfRs3lbVUaN9J+R9noM+clkLAy2SReF5ynanYjq1iNlXbhT/1R5DGkrp9Sk+oUpi64RliN/VtEcpb23pGblLxfbi5tb/TioGKMxVDZCOu2kZJPQCgZnj/ffyJtk8TEs43yTU5C+lUiJU0QPxftqJs+ZyaJw8+/+A3oXFSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=33+ezNgn; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="33+ezNgn"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VrZCJ1CCrz6Cnk9T;
	Fri, 31 May 2024 20:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717186601; x=1719778602; bh=hocH0ZJDUwrbuh71Y7jtxGSm
	fUyJvr7QLnBhhGjcGcw=; b=33+ezNgnrMNv6DC46lH/UDdykF7WpifGf3PD3SMg
	DccfRVEiZiKMnMoMOe/V3LWO+MytXBL9ZgeN631AzLp9IpDz1qQKwkV4WliEMciL
	93Z6mEjOnPR9TSIwA8yG8W1IwpUjzfA4JGNuR/AMPJ5pS108lzZ7G2iiOoGec5X/
	F+voDrNJgmxOcVGpAVlRqiic/dNoev2i5cdFXmVKU/6r5KfqAE0+jsjcGSHvU5nN
	d2VrjYhEbMkjRUTfvOLV0jSOE64HpxSwZi+5y+kHi2BQW7Ajq2ohevf52VSXFCDA
	A+LvrYHwhPbdZ56VdnZD/wwp7Zp6daNoUGTYOUW3J9xBOA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JWDaw9Vyg5Td; Fri, 31 May 2024 20:16:41 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VrZCD6s5Lz6Cnk9F;
	Fri, 31 May 2024 20:16:40 +0000 (UTC)
Message-ID: <6052a799-88c4-4efa-a59e-d560a091a5a0@acm.org>
Date: Fri, 31 May 2024 13:16:40 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] ufs: pci: Add support MCQ for QEMU-based UFS
To: Minwoo Im <minwoo.im@samsung.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jeuk Kim <jeuk20.kim@samsung.com>
References: <20240531103821.1583934-1-minwoo.im@samsung.com>
 <CGME20240531104947epcas2p30506632eb56025711dfb5768e2f77154@epcas2p3.samsung.com>
 <20240531103821.1583934-3-minwoo.im@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240531103821.1583934-3-minwoo.im@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/31/24 03:38, Minwoo Im wrote:
> +static int ufs_redhat_get_hba_mac(struct ufs_hba *hba)
> +{
> +	return MAX_SUPP_MAC;
> +}

Why the prefix "ufs_redhat" instead of "ufs_qemu"?

Thanks,

Bart.
