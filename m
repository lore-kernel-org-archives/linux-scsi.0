Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794140619;
	b=HdNPqGtXIWbKIz/kqnZb1Px0IvlekyajbSmRvDYuKaqde5cbKHSWxGMkGlLFOg4PKiTH
	 rZlxBWKNnQxkZ34ISxrrBF5m6BFTxvWZk6oGx40dEaAuV3h+tMnTkpOV1dDsBDPFsRSTq
	 FIg4xPwzs8FXNG5Uuaz1kg0oLWr2U+WkGhDNgIgJwAw1/eH3AYOPfvGyXTIOwmUH2iGaV
	 LpeUtNAN/+Xo280rA40c5Mscg0JPm55n2CeAJD4DLLEbKmzPvpXDCU/YIWxaWIsily56g
	 kGpDOCXqMbUFAzOUYVRMInWbux8kMCnxHB17oqJ0jxGRp+/GxNZmrOb4CDiHj5ZbeWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794140619;
	h=DMARC-Filter:Received:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Date:Message-ID:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=wMWfc48sTUNJRn/nNYZ9jY2KnhRGW3QJ4wa2Hej3SaE=;
	b=U+fzyYlxz1Fj2RILZbZdlqIV1ORaXqmSw/3yM8/XZRQ+wMRLGkxZnN5D2PlaDlxgenNm
	 y3Jk7/FMdwYeVX1jtl5IgX8dPd32AXMZj9yDF4y7qiY604s0/UOCis8gC4oaBlRRlVF0f
	 uOLRA1U/gWwLfHyrFqK92nak4ilgbS2k6wIfuLO7GjkKaN1ihTMojWbJw9KPqpv6ZsX/c
	 nkcYYAvo3v8z1NrqQ+yjaplOLgnHStWdGB5kPpjzzsIHVosfPcf6yF0zbl2riWzspCp2i
	 PBG8x44fy4Yv3lGMWUCp7s+/hlMr83j4/9AeslVKaH86mdZUwf+xuH4TlS3CY8JMbdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.25
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37EC606A31C;
	Sun,  8 Nov 2026 12:23:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D37EC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [172.100.0.8] (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowAAnwrfCafBqcz6bAA--.39862S2;
	Sun, 08 Nov 2026 20:23:30 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: John Garry <john.garry@linux.dev>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
 Dan Williams <djbw@kernel.org>,
 Martin K. Petersen <martin.petersen@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 vulab@iscas.ac.cn
Subject: Re: [PATCH] scsi: libsas: Fix use-after-free in sas_suspend_devices()
In-Reply-To: <b0e2de23-7421-4217-bd37-e98e59bef873@linux.dev>
References: <20260917143800.2157286-1-vulab@iscas.ac.cn>
 <b0e2de23-7421-4217-bd37-e98e59bef873@linux.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Date: Sun, 08 Nov 2026 11:40:40 +0000
Message-ID: <20261108114040.216100-vulab@iscas.ac.cn>
X-CM-TRANSID:zQCowAAnwrfCafBqcz6bAA--.39862S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYS7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1q6rW5McIj6I8E87Iv67AKxVWxJr0_GcWlOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrwCF
	04k20xvE74AGY7Cv6cx26r48ZrWUJr1UMxAqzxv26xkF7I0En4kS14v26r126r1DMxC20s
	026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_
	JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14
	v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xva
	j40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr
	0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JjUgAwUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwUFA2rv42DS9AAAsk

Hi John,

Sorry for the very late reply.

You are right: the reference held while the device sits on port->dev_list
keeps it alive, and an LLD never owns such a reference, so
list_for_each_entry_safe() would not fix anything. Please drop this patch;
I am withdrawing it and will not send a v2.

The candidate came from a static-analysis run audited with DeepSeek and
GPT-6.1 Sol, and it is a false positive on our side.

Thanks for taking the time to review the patch,
Wentao

