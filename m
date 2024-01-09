Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188BF3DB81
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jan 2024 21:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5cde7afa1d7so1623801a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jan 2024 13:34:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704836050; x=1705440850;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gE416TbjEYVis8prf1cXZYaoI5U/2BL23yGsz4kqVcY=;
        b=VJkPZzJ/AzmzzPbg/ZGVI2jJrKVLvVIdJO5vNp3LTXLj1gf2FlPbRREoSXA56YAbWq
         Df8coX8sc2hiFFgn5ZDH5zLuFaD3innuDSJ43QVdLx+X+WgN5ox99b8kfeWn1xw+oIrx
         WJtqZ80bE/TaKQmFnU1h5O+HsQKx/VAEHWGfNyS4hkZkvtGQn9x1XcJ+tAVvVvevmjnl
         m2RN3f3o1nQdSTDcZL5LQVKXRaS/nlX+uPxTkGv9SnwxfSBAdhdku7L8y2cOa9u8GoLQ
         FKTSqlbKZOvLlsglvYA3U1f6dueiV/V4czM0zetPqSmAZe71ndMOlo08LcbM+2B9kTeD
         MsZA==
X-Gm-Message-State: AOJu0YwtsugDWER+CyKtPeM+uozvH1mZ8VxyfzOEO8PjD+D7EKX3pMt3
	9nCXl637d7yUEdZrKaqgFxk=
X-Google-Smtp-Source: AGHT+IG4rBkEvRL39X6PgG0KP4QJbqKwxIRkuTDkYKKNIgR4JAvpmVnPlNU9UihIMnbPAp3cmN2XRQ==
X-Received: by 2002:a17:90b:3d12:b0:28d:950f:a207 with SMTP id pt18-20020a17090b3d1200b0028d950fa207mr1393071pjb.30.1704836050211;
        Tue, 09 Jan 2024 13:34:10 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:b76f:b657:4602:d182? ([2620:0:1000:8411:b76f:b657:4602:d182])
        by smtp.gmail.com with ESMTPSA id d16-20020a17090b005000b0028aea6c24bcsm9010150pjt.53.2024.01.09.13.34.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jan 2024 13:34:09 -0800 (PST)
Message-ID: <53d4c814-0b6a-4328-852c-7dfa2d8466b9@acm.org>
Date: Tue, 9 Jan 2024 13:34:08 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] scsi: core: move auto suspend timer to Scsi_Host
Content-Language: en-US
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com
References: <20240109124015.31359-1-peter.wang@mediatek.com>
 <20240109124015.31359-2-peter.wang@mediatek.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240109124015.31359-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/9/24 04:40, peter.wang@mediatek.com wrote:
> Runtime suspend timer is a const value in scsi_host_template, which
> host cannot modify this value.
> Move it to Scsi_Host for host flexible use.

It would help to mention in the cover letter that the UFSHCI driver is
the only driver that sets .rpm_autosuspend_delay in the SCSI host template
and hence that this patch does not break any SCSI drivers. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
