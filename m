Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02083A5E7F;
	Thu,  5 Mar 2026 13:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772718874; cv=none; b=DhgB3ULLT8upq07t5Dk28nXZQKf8vq4yMnMUpU1aDwwfXEd9/uVUx6PrJyWoYXBsud9M8kwQuv0HgMMbXOehESvPHRlBbJHms1JmbxhhmmwdkK1v3A4nBDWsHBr7Bxx0vS0a9ATWvf91bL8VpYBpanUJ9kM6sVb9OlGFw/55fKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772718874; c=relaxed/simple;
	bh=/hKt5BDhyW9yM588yoTUagXA5FfNFstWtYDs5omLlwk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YghKvxWdP9YyLYHVWfv24DbPdhQfjpTNrDD02SnDkEy6GNMTVhK2VLcqSOnYuuWNbV985BJgVMsbUZQUdmWv2VUlfScuIlnmK5RavKRfESm64sJfDFH8KNbjAxDNvSwLXYDDA/d5v9tBtogrIjhqzPVCMIt2ky9qvRS1kUQEw5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EFzj3HnW; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EFzj3HnW"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fRWHY1bNtz1XM0pg;
	Thu,  5 Mar 2026 13:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772718868; x=1775310869; bh=/hKt5BDhyW9yM588yoTUagXA
	5FfNFstWtYDs5omLlwk=; b=EFzj3HnWvXhbUj3B3jC4Hb0An2q3FTP/D339jvGI
	o8EtthBrfP3mBni8yaP09QCRAHjDeqOaWp92hJ/Ji2xzptHqJYE6xnZ/8kzawZeP
	o0PuCiiGejHjKK+wU1+i6ESIVUYOJNQIqFgvZkGINFp749JZYlzD0hxQpDVkXGbO
	rkBxbTHT/aSQgjpu5JyeZrVNcYFY5k6Fy1DefW1i6TkR6s9b0EMAY5j6AcpyBBbC
	rSFro1FNZTDkTtEsBycCLi1arTGgTXyMviMA1kx4JfxilXaKASjvwIeoZQ05o3xQ
	DLaQjEKyEm8NY9BNctUuLS+mkXzkOAiuY8v1hU1NJLTAug==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ym1e3RrmrHOh; Thu,  5 Mar 2026 13:54:28 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fRWHP1wnbz1XM5kD;
	Thu,  5 Mar 2026 13:54:24 +0000 (UTC)
Message-ID: <6be71e9b-f26d-4c50-a5f5-1f34f01f02ef@acm.org>
Date: Thu, 5 Mar 2026 07:54:23 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/11] scsi: ufs: core: Pass force_pmc to
 ufshcd_config_pwr_mode() as a parameter
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Adrian Hunter
 <adrian.hunter@intel.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Archana Patni <archana.patni@intel.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
 <20260304135313.413688-3-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260304135313.413688-3-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/26 7:53 AM, Can Guo wrote:
> Currently, callers must manually toggle hba->force_pmc before and after
> calling ufshcd_config_pwr_mode() to force a Power Mode change. Refactor
> ufshcd_config_pwr_mode() to accept force_pmc as a parameter.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

