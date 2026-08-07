Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180C9397958;
	Fri,  7 Aug 2026 15:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116859; cv=none; b=FOaicftNp2Q4khz5oOkkjYzX1f+3QrOSa/k8Nbam+dNWNvlq6+qbv+TW6orgidLFUUOS2/FPurmB3KgI+p+7z/o0/5/umyvKD5tDu0JzF2w2mjxCxmxStRWSC9Zdr2z2jB6uPIKJzyDhldw7C8w8rKFQbgJcd5f4/r1TLvoJTZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116859; c=relaxed/simple;
	bh=o6criyFXz5XNJXKePGEh6FY3/c1PQF3YBAZ6SGKj1gw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FGPTRhAlGhOkz8DQzkrL3Wl+XqBwMHkaIFuzEwOFe+6dnO1breVpmS2RWSwn6ecL754WEreavq7srnawnfneN3Qi7vsaQLahxfkAuD7cZZecGjEn3umtlnPetOcnPwuyFn+FiAkos3Xm92xhJSubeXaONKurWqrVLZvsD3+F9Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ff93ZCqK; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ff93ZCqK"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hGp953PhPzlfpLt;
	Fri,  7 Aug 2026 15:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1786116853; x=1788708854; bh=hZ3qF3FjrIBLYa4HiSl8Imx6
	G+Rc9bHPb9+hoVsyquA=; b=Ff93ZCqKuPGA7uuAp+45nitP0TlB6Z11nztoGrZ4
	SUaPCpq2qzpwyoUTI7d8DpUxPTwK5t9jVpeNHCq0CEzuQdSGytbIkPuJVcm4DuNJ
	eEjWHwAOdWFVKiC7c88Im+YCUB6ajM8rn6LxvXUfFLHBtS+G5jASQ91JYsJU7KiB
	icgVfh0aLIVFgYXoy6SqioZV/iiGaywsB3zW6K0hU+kokqdKGetALNCfluAuSq6R
	7kFib24TExMOxbsHTpGPaktrRznj7a6LzeUQmOalW+G24Z91LdNqRzRHBFqrsTY/
	2APdNsMnTfXCkQubTt9MFAxlyy1wzCfKK+wbn/b6d2XfUg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id G78Nacv49Vz1; Fri,  7 Aug 2026 15:34:13 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hGp8y5ZBLzlfwgT;
	Fri,  7 Aug 2026 15:34:10 +0000 (UTC)
Message-ID: <cf1f02ad-3706-4e90-9f17-94a873be0bef@acm.org>
Date: Fri, 7 Aug 2026 08:34:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] scsi: fill in DMA padding bytes in scsi_alloc_sgtables
To: Petr Vaganov <p.vaganov@ideco.ru>, stable@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Jens Axboe <axboe@kernel.dk>, Tejun Heo <htejun@gmail.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org
References: <20260628185229.37957-1-p.vaganov@ideco.ru>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260628185229.37957-1-p.vaganov@ideco.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/28/26 11:52 AM, Petr Vaganov wrote:
> Extend last_sg->length by pad_len first, then use sg_zero_buffer() to
> zero those pad_len bytes.  sg_zero_buffer() uses sg_miter internally,
> which correctly handles sg entries spanning multiple pages and padding
> that crosses a page boundary.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
