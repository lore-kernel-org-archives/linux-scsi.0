Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4B176C89
	for <linux-scsi@vger.kernel.org>; Tue, 20 Feb 2024 17:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708449484; cv=none; b=S1W97nUTOAgsdON3IkyDaQAOmXr3WP7Ko4WXphN/QZOHUWdpgkdVDPntj2xG2KVN/Rjby1JRVJMGmdSo8Y8c8rJfhXBPBo82kYmW9ywhDIn9n7lwgs69Yf7bwhUnXxgbnDQkEAoGkLb7Tfvq+OwD26baiHB5TqFUKDbCwGTQPdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708449484; c=relaxed/simple;
	bh=3NJZKXzZcH9Fr2S2jBYAuQSNfFUMMJ+GOJF9NxToya4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dLU7U7nHppq25H0C5wWlRXWVpJXIdmora12Ffm1qUyrRxQiwABKdjEPsLKRXFvGyUeJKtkQdoZTGJL9DZSVHzIwJvpfXYRsXHW8b46DWWzx8KkYiDjOpaS6ehqtCnkmMO1tFABUhwYXXCzK21ZbmqMxV5yfT8in9zJrMFLUIpmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e46b5e7c43so1143145b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 20 Feb 2024 09:18:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708449482; x=1709054282;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3NJZKXzZcH9Fr2S2jBYAuQSNfFUMMJ+GOJF9NxToya4=;
        b=nd9WTybvWHHNP5fJ3fq/727+VrHtFlenDvaFEdqD+M/5WNxjWv6KH3TyEZof3mYfVt
         HAuYoLt6XvyWMCIYQWBW7Zslq9XN3TjifjZ54WuriKi/oPdbYmviPkn4owZfamY3QPI6
         NxZ3Z7jdyx6zVK0k9R2//sPt2uV9uySmgz3JUrEOxBqQRZKkhjc3+Te+NCEXZwKvC8Wc
         3K8axvSOmo/7HqlTdObNa8LvrXnByNKvKME2SslNGIHYwr9Hqiav8KKG997A9PrFB1cz
         1ZmzEgHdR7HMPWLC4/ymtvIpQV8dyvqYAyboQfZWYyjuulULde+1swmXzxR0ekyI7VfT
         3LUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWY2g8a6YfipG3aQA40jOXqM9WrlXYO7cPK8QakJfZjDW7eIfiiOwVf/KzhqF1OwMmhoL1ei+04WaIy6zu7rBEHiM4QXiEVSbTdCg==
X-Gm-Message-State: AOJu0Yy0IBtq7lLeeUlQtE0Ixjkv+BUbq+VvNKavp29nXmz1aWVvYPaW
	ROumkCEXbIqUVsX2lBSqcH+WnkTIU84WdRU6zeIxph96kK/OYAxN
X-Google-Smtp-Source: AGHT+IEGX9I6dAr4XwDddzjtJJ7E4l/4z8mM80OwXNh/ZK/KcMZPyyc6Pi5EOXeHtBy2uNcNbBboGw==
X-Received: by 2002:a05:6a21:9101:b0:19e:ccb2:fd80 with SMTP id tn1-20020a056a21910100b0019eccb2fd80mr14979835pzb.8.1708449481848;
        Tue, 20 Feb 2024 09:18:01 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:455a:b76d:46a7:7189? ([2620:0:1000:8411:455a:b76d:46a7:7189])
        by smtp.gmail.com with ESMTPSA id t20-20020a632254000000b005cfbf96c733sm6890557pgm.30.2024.02.20.09.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 09:18:01 -0800 (PST)
Message-ID: <46d0c5b7-7158-405d-ba38-cece4030e2bd@acm.org>
Date: Tue, 20 Feb 2024 09:17:59 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: adjust config_scsi_dev usage
Content-Language: en-US
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com
References: <20240220094211.20678-1-peter.wang@mediatek.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240220094211.20678-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/20/24 01:42, peter.wang@mediatek.com wrote:
> Adjust the usage of config_scis_dev to mach the existing usage of
> other vops in ufs driver.

I'm not sure the above is sufficient as motivation to make this change.
Why to introduce the helper function ufshcd_vops_config_scsi_dev() since it
only has one caller? Is this patch really an improvement of the UFS driver
code base?

Thanks,

Bart.
