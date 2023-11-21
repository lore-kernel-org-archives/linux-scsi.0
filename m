Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3C8191;
	Tue, 21 Nov 2023 11:25:11 -0800 (PST)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6b5af4662b7so5167337b3a.3;
        Tue, 21 Nov 2023 11:25:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700594710; x=1701199510;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uZePSAf4gB3HJVFYgvE8pgutUfhEL/9fpKJ6kU7Zk9A=;
        b=ayDB9OyFXd6EByrmA3JMXItpdXP9ku9OoTNLWLYowzB+UL6LhukP28Ql4eSSWMN8Wa
         mnHolTihVwuxG250oeDB/g85cOfpYigJYEISHyV5c7dsaz5H0TjUMf9gRPrZ20jyqRBO
         El/5Jt5zGirNNdqMeCsS4w3kuhC9e4doaP8L+2YuRgnN2TjaHL9+/fpyp1ST3+ia0Qch
         7wd5nmJ+zEk4rlnbCHlg/XefQsH4y02mmx1hrAe0ezwX30/yIREF0oyvx9vZuOUHYSEj
         EXi/emIfpp75N3Y8IFujILGQoE5wGfRDSZUJcktx9Dh67K/FmYkmPmGaLUTiNoznXGMZ
         sIUQ==
X-Gm-Message-State: AOJu0YykfJpoPXdHWkQZIiG9D8kXJ5gQOSbPIgcqYqEuAeibrL2EemTH
	XDn/bVU2Tc8hdZoSCt894rY=
X-Google-Smtp-Source: AGHT+IFI100FsQEpaJWSYYNA6hlH4gwVhXQuyf2qoYXVM8Fdktvc31OC1thY5EFTtcOY/Q9ytPLjdQ==
X-Received: by 2002:a05:6a00:2a03:b0:68e:41e9:10be with SMTP id ce3-20020a056a002a0300b0068e41e910bemr136084pfb.20.1700594710338;
        Tue, 21 Nov 2023 11:25:10 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:bb61:2ac8:4d61:2b3d? ([2620:0:1000:8411:bb61:2ac8:4d61:2b3d])
        by smtp.gmail.com with ESMTPSA id fa17-20020a056a002d1100b006cb907e8059sm4463208pfb.9.2023.11.21.11.25.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Nov 2023 11:25:09 -0800 (PST)
Message-ID: <9abebf27-a3db-42bb-b0e5-fb4ff6689c14@acm.org>
Date: Tue, 21 Nov 2023 11:25:08 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 15/15] scsi_debug: Maintain write statistics per group
 number
Content-Language: en-US
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Daejun Park <daejun7.park@samsung.com>,
 Kanchan Joshi <joshi.k@samsung.com>, Douglas Gilbert
 <dgilbert@interlog.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20231114214132.1486867-1-bvanassche@acm.org>
 <20231114214132.1486867-16-bvanassche@acm.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231114214132.1486867-16-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/23 13:41, Bart Van Assche wrote:
> +static ssize_t group_number_stats_store(struct device_driver *ddp,
> +					const char *buf,
> +				  size_t count)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(writes_by_group_number); i++)
> +		atomic_long_set(&writes_by_group_number[i], 0);
> +
> +	return 0;
> +}

There is a bug in this patch: "return 0" above should be changed into
"return count". I will repost this patch series.

Bart.

