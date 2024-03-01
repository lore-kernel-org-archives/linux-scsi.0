Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4344206E
	for <linux-scsi@vger.kernel.org>; Fri,  1 Mar 2024 23:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709334295; cv=none; b=UjMwQj1fdltXTXUlQejuqWBDR9pO3Qj7dzofBAV2mu5Be9fOuidqXQPRI6xWXSvms5liSTGnzqQiZYazj+ZnD99YAxo4Cpu4RF78Sr8aFdvPaQdDS6vEQqVlaHjfbvSQ2XQohGXFIlO3AmTuTzMbod0JtCNzBUIJ8cAVWFC0Zl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709334295; c=relaxed/simple;
	bh=N2cPQ/qamgYKQiZt6F8JxqkMkeMuHMsMrjJV8QIW4+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TRfcq1wmTmqxyAuMSXRpdeZfWaLYonrs4qpNsfrguhZNqeuD+NiCr2l2MWdhT76ilcZxEkubvJ9Rn3kQurOjLAo1fBUOaZtC22DpWgSailRFXMRGZ0tnJbgsLPaUe4TdOa7A1qvvot9eiSv3K4xwTCQlsmja/9lb1Y2c47QOjw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-365b3d92354so15167835ab.1
        for <linux-scsi@vger.kernel.org>; Fri, 01 Mar 2024 15:04:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709334293; x=1709939093;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N2cPQ/qamgYKQiZt6F8JxqkMkeMuHMsMrjJV8QIW4+s=;
        b=UxZ8Ymq6zTdMWwJrsYD7NmJdh94AY10+pYdeOy834GUC7XhxwEeR+lCAYYJRmRmaCA
         y84uQ2qce7vzCGYAAlB8YSCAq2PYjGuxgoLeiTuquJwyVn9+OPoB7MmCn6XfZqA/Vwjh
         xCKeaBnpNlbJZf2ffie0itFb9J/h3wukQRgMv8eKZSM23CC0xAhxnkEaNUk6AQyulIG+
         o88wC8UzFxkw0sbOTGH6dwbjDSUAS4QHbs5+cQRSnlSnJ6jvTNP23b0+cAeqa1MRVYO5
         L8TtA5KbnBtUU00ksq+m7Fk41dwdIAF0RhqOJqpvFMOoZY8mhh5Orn0Ioucx+VeJjvjd
         i8pw==
X-Forwarded-Encrypted: i=1; AJvYcCW5yDaO9N5yF/NR/bJ0W0yS68CfoyfcD85QJ9aDcZQL+0CdxmlL16f3xMxSAxvqmV+dqgap2D4C2TIoRBFxUW/riTK35xzz4sfCpw==
X-Gm-Message-State: AOJu0YxidFKcl0WsHBKWlgs1i75stvxrUERYpVTsCj2HuJx8QzywsRsF
	XJcviDYEiWCnbeYNId4LwYfAAoHe0Jxd/ErbXpEMogDt3XKAyrKV
X-Google-Smtp-Source: AGHT+IGYfruGgWePt93txBq/IzJsO9JFDu0K4CcG1F+Q7Fo5ZePPsJZnArBCEiDtRkSM5H9l8TJ3jQ==
X-Received: by 2002:a05:6e02:b47:b0:365:b485:734c with SMTP id f7-20020a056e020b4700b00365b485734cmr3728724ilu.25.1709334293285;
        Fri, 01 Mar 2024 15:04:53 -0800 (PST)
Received: from ?IPV6:2601:647:4d7e:54f3:667:4981:ffa1:7be1? ([2601:647:4d7e:54f3:667:4981:ffa1:7be1])
        by smtp.gmail.com with ESMTPSA id y6-20020a634b06000000b005ce472f2d0fsm3105554pga.66.2024.03.01.15.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 15:04:52 -0800 (PST)
Message-ID: <967e329a-7114-4857-b79a-01b751be759c@acm.org>
Date: Fri, 1 Mar 2024 15:04:51 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ufs: core: add config_scsi_dev vops comment
Content-Language: en-US
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com
References: <20240301034610.24928-1-peter.wang@mediatek.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240301034610.24928-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/29/24 19:46, peter.wang@mediatek.com wrote:
> Add config_scsi_dev vops comment.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

