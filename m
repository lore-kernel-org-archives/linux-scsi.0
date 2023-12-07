Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C22D53;
	Wed,  6 Dec 2023 16:59:04 -0800 (PST)
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5c68b5cf14bso282533a12.0;
        Wed, 06 Dec 2023 16:59:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701910744; x=1702515544;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v80y2sUM3/Aew+y5MU1sFBYpJUDxD3dm27emB8pydjY=;
        b=cnioQyoYbpVR+7I23iYy2QXncHj8FKBD3xKsq4PEDH3Bc4PnJp8N3+zhyPG9Tlz2EQ
         59vfRU4xhh0B1ENoD1xq4PpB9uGkO5NkSWWirIXqBq2VgYIVulTPG/cmDvY97FUYNEYg
         ey7TaQxkoO/QfCQs99FUBEJBpQaxJP4NSu9qPtclPQkC5CFNWQ5AQADTP/uqmj12H2It
         nrsR4FCoQtaa9uEz1m3mM7EDxgcecDI6vlih8gUFJp/OOZYR5HWRI8eBxTf1RO3SfPzD
         459Fw8hj7x3EutTGUM+BsuAo7wTgy8ASY3YrKhwrnBlYOgH+JCqxfgcm/k9wOQW+QDGq
         Zn4A==
X-Gm-Message-State: AOJu0Yx2VGHr4jCxRxhiQvGWa1dTukWsBaHvUohkNxMOXNfJrpVfGo/1
	SJGdAtesp7KY3iRtCYlKc/M=
X-Google-Smtp-Source: AGHT+IH8UFetPLRIAvLcso421cwQuQZAn7pgl9sZ3zxp9q55QYKzltU+3RGshvuk1uo09chMS8hQtQ==
X-Received: by 2002:a05:6a21:3388:b0:18b:ef96:be44 with SMTP id yy8-20020a056a21338800b0018bef96be44mr1617427pzb.26.1701910744048;
        Wed, 06 Dec 2023 16:59:04 -0800 (PST)
Received: from [172.20.2.177] (rrcs-173-197-90-226.west.biz.rr.com. [173.197.90.226])
        by smtp.gmail.com with ESMTPSA id n20-20020a17090ade9400b00286a275d65asm52005pjv.41.2023.12.06.16.59.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Dec 2023 16:59:03 -0800 (PST)
Message-ID: <b5819922-60e0-4701-84d4-05c76d2ea5ec@acm.org>
Date: Wed, 6 Dec 2023 14:59:00 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] scsi: ufs: core: Add UFS RTC support
Content-Language: en-US
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com,
 alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
 mani@kernel.org, quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
 beanhuo@micron.com, thomas@t-8ch.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 mikebi@micron.com, lporzio@micron.com
References: <20231202160227.766529-1-beanhuo@iokpp.de>
 <20231202160227.766529-3-beanhuo@iokpp.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231202160227.766529-3-beanhuo@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/2/23 06:02, Bean Huo wrote:
> +static int ufshcd_update_rtc(struct ufs_hba *hba)
> +{
> +	int err;
> +	u32 val;
> +	struct timespec64 ts64;
> +
> +	ktime_get_real_ts64(&ts64);
> +	val = ts64.tv_sec - hba->dev_info.rtc_time_baseline;

A 64-bit value is truncated to a 32-bit value. What should happen if the
right hand side is larger than what fits into a 32-bit integer? Should
a comment perhaps be added that uptimes of more than 136 years are not
supported and also for absolute times that the above code fails after
the year 2010 + 136 = 2146?

Thanks,

Bart.
