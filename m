Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811ED149DFB;
	Thu, 16 May 2024 14:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715869704; cv=none; b=dy+jncNsW2Oh2dnN90BNjoXTQTxCeTlK+nh8t9ELM2PTYQ+dxLJMskinDqXWe9X4PWyW2jto7N5EMM4oLXKPdTX4cOhy70dDi5eJBCgi0+D6C/yQ9lXuE0GIFlLnOo6Ntv2HFF8vqUO5bh4yl01TzxIuLa7VfcPiNU3S0G+8ixM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715869704; c=relaxed/simple;
	bh=UtwM1AaCv/Q84rlWqpbrUUhXCJ+gDNCjlNXvblAvb24=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L9xNR5udHR5AAsKH7EWINmvlyGBoMKKPSE1N1kDbtYc6zV6/rUh4okl7RRz72IuO/pLfxP1I1rxEw545B/Q0FejQJ9rPBtHsA+wk4lVKz+eI1Yv7OjsNgtEIzfQwp6ohaJt2ADSxETwGuZkRM6Y0/k5O/Y/7UNGUKnJRB0CZX+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Li4K1RqE; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Li4K1RqE"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VgCBG6pNRz6Cnk90;
	Thu, 16 May 2024 14:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1715869700; x=1718461701; bh=1ZWKwegtnmatTNMl1Q7jftnZ
	el8hG+2rMuLUAeJoCXA=; b=Li4K1RqEZhj1CuLLNvlp/77rh4WSmdSLYRQReCZA
	R1drGkROsBilJQMfPBfMBb5GBi/sKu/DOFuGQ2i4MxdF43ZjUmNQ8OgdwD3MtpHH
	0XNrBbvV7DU6t8WqUiffhj/3NC34dg92+YChfe6KCKenEpuJPWVPQa9dBlAnzQDU
	fLf0OyrCp3nhwyt73UbzjkLrqqY/xlTL7FuVCSMNWehNjZBusKOU24XlFm9nXyEO
	oJE+lRUXAXgNgByk4hoBBR/B5HFfkI0XOjnojesmbZwI9QZOKNnZE/0nfjBA17LB
	UrkLimTQuiTSzZWJQmT/jQHRIcz2HWjarfo0SzgITotnbA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 32nPqzYKbRFB; Thu, 16 May 2024 14:28:20 +0000 (UTC)
Received: from [172.20.0.79] (unknown [8.9.45.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VgCBD0mfJz6Cnk8s;
	Thu, 16 May 2024 14:28:19 +0000 (UTC)
Message-ID: <91e9322b-9304-4cb7-a1be-1f43208800e8@acm.org>
Date: Thu, 16 May 2024 08:28:18 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] scsi: ufs: Allow RTT negotiation
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240516055124.24490-1-avri.altman@wdc.com>
 <20240516055124.24490-2-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240516055124.24490-2-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/24 23:51, Avri Altman wrote:
>   void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
>   			     const struct ufs_dev_quirk *fixups)
>   {
> @@ -8278,6 +8312,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>   	if (hba->ext_iid_sup)
>   		ufshcd_ext_iid_probe(hba, desc_buf);
>   
> +	ufshcd_rtt_set(hba, desc_buf);
> +

Why does this call occur in ufs_get_device_desc()? ufshcd_rtt_set() sets
a device parameter. Shouldn't this call be moved one level up into
ufshcd_device_params_init()?

Otherwise this patch looks good to me.

Thanks,

Bart.
