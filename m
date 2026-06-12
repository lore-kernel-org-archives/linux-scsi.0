Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683A735CB87
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262129; cv=none; b=Bg1FlDG0v4+HwHwBim0WWNSTFRAM0E9OnaxgJFJ6c3fegme9HsKEAQ2nbhncIhyBT2cTRtVyUpmPa0x46yXPn9u0cpX1m1lNH6CBmDkBJeRx8zsEaU8mHN7XC+HvNp4lzNzSBzQiFUwgm1cfUQJjoQHeL3vOg2sc87k0f6IEVEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262129; c=relaxed/simple;
	bh=t9oNlkcsXYDZEPPFDhT6MnHIFSjrEh9GbADCQgpoI/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u9Y0NZZTytJY25GpImYQqRrlYsILfGteJoYZ7hwPiOvzUrW4CrVOchYHTkItW59BaMtmiEiHEzy+ahV50/OVCtw0TzRItpYRG7DQXptI76kZNVSw4rYvIZSsTLklIK2kKbcrURTUvRGnGKM6qGqxbGaJeTNQZBajNnKs/NFUXak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dUcrzrpA; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dUcrzrpA"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490be03d47bso8240285e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 04:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781262127; x=1781866927; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VppdT449/ib87RNs3GfyRf+0Sf7iuDiCrplZYw6hkdg=;
        b=dUcrzrpAwWsMyF2IZutQYmZ1MJhiTKTnV1SfoeGAgfSjDJuBV8XtBrbRo/ks31Fcwm
         OeblqQb9Si/XI787iUHRXNGOj9mXMIkLzorVJlk/93O7HuXcHPR4kq7Y6DWGSgOGd0fv
         UsteLSj1afTue1OERF3SGrK00yFOIMPOg4ErK0nyi8xK+xMzIbCCvcYeN3ZnlcZwYznF
         Bp2+kfxB7d7Mt3CuC2BYESFjDiEXBR52QSgcUV9q7Jc+qflQ+QoxLu1VaRpniz5IhANj
         0wsG1ktFkn6emw/O0PSuoW5QQQWlsxuMMfVyDkHlch33Y29F8FtG2CSrT95rAqLGPFjK
         ol+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781262127; x=1781866927;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VppdT449/ib87RNs3GfyRf+0Sf7iuDiCrplZYw6hkdg=;
        b=IDYOPTB/iOYOYHpfXOClGZT8XaGosbjOTVG2Yf+QOKcCIhdwE9Z8A621EJYfE1cXpw
         YMM4Ty8+X0y1HAq47nsSmMRztx6dw5+ha++EpnD/JeWvj1FVCST7PtheHBzAk59bLR34
         nRoluWlnLwsIXo739NY57GxqGJx2GkRqn0omZNn9icPPqT0tRL+zk9OX8i4e7EIlI4P4
         yM148L5kSQOb+kScZS+2Y3yx043SG+OvcjDgtIGMZjjYCwBGNTwTXr3LIhE8flvcNtLy
         utnUNaWd2xFFw3gXhPRHVSCNNkR0X6/ttBh/ZVzbhiTlkCPZd92V03Bpg2ejQ3BQiIR1
         i7sA==
X-Gm-Message-State: AOJu0YxBtBdksq9K+L96E3KWJ/vk1jNlN8iOaaFW0wFZKqJSkzNaMSUA
	s8v6E0vSrz6FzIR6Z6uhPsQFCwcVCZ8ZdEbgCo9gaUPIhKGH6RuhiGY8vfBqRlktC/Cv2hkB0no
	8mYrJ
X-Gm-Gg: Acq92OGyf35oIca5iVIco0MVbEaAagH9sbIud+vWJDl1qG3EdxS3K7RmvDi34+IL862
	/n/BFRWbDiesjG+OmFxpNWcDEbQDnl6Y3Bw4BFoonNE+ipm/8Yq9lYhjfZsnNm8E5teeFQ0gzZQ
	doMoYSLw9+owGINUVtqxpJzch/jPYzMCrJDfjbuHq4fOzEKNgnlOJ/or6LBGL89+G+3ySuP5p/P
	zNUL4dCSAbblOWqj93dNMueD9kmLw4Yrm3updOVnrOlNWaQ61OzzV5D98JFxlRqS0uSxwr+lYMN
	ZnjXfaXTAuPZCHMNjJNGemxq7HXFXYgceJyWclasa5Z/bXBkmQJd5qA2gFyCvyyAqXTFLszWx+5
	Az+91CM4PlEPV2oQmCC0dBun0+LfB7Sb1E7lsHcaqb5EnQLEw8H9poMvYdBJboTddIhAwbf12s2
	M+kUPrViuHqGvOkmmaHektNcUymm/9YRI7WVtrkY5+HvqD0U6a+ld1r67g
X-Received: by 2002:a05:600c:4595:b0:48f:d5b8:5b07 with SMTP id 5b1f17b1804b1-490ec4fb683mr29404865e9.20.1781262126644;
        Fri, 12 Jun 2026 04:02:06 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2c7ea21sm145124185e9.1.2026.06.12.04.02.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 04:02:06 -0700 (PDT)
Message-ID: <ab74e079-1bae-4ef5-907c-ed5f4153cdb8@suse.com>
Date: Fri, 12 Jun 2026 13:02:05 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/60] scsi: qla2xxx: Add extended status continuation
 and marker IOCBs
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-11-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-11-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> From: Anil Gurumurthy <agurumurthy@marvell.com>
> 
> Add the 128-byte sts_cont_entry_ext_t and mrk_entry_ext_t
> structures required by 29xx firmware.  Include the qla_fw29.h
> header from qla_def.h so the new types are available throughout
> the driver.
> 
> Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
