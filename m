Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E098641848;
	Wed, 20 Dec 2023 16:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d3536cd414so46314445ad.2;
        Wed, 20 Dec 2023 08:36:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703090190; x=1703694990;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HCyxxy4SYrjcmXtgPm7/qvcDAyUwTKceXcjFFqyWHC4=;
        b=K++J1svXyQ7Ag1n4UsJtsXAdNhtkQMtAW/+g11F1BVnfppRe+Gu7f0MSDN5w4fdPFO
         /x1lrZvQB8YONimZg9cv3jGHcJMAy8UxB8Yf1Bzk24YqrWFKkGvpk7sajlBa1O49KZTF
         HAmhsWCfaLfhr4cuJZgheWvd7EuolISZlbYIebAiswcnZp1xCFGA53NRiPUCHHlGhO1D
         jrxS6Uug3MjqugCwv8dZ+AucXYR9NzcGQeiS92xGCNd3gMhCWOUtxcWf7Og3hFmerNqt
         O100Z5tOUcmRspxEwV4B3u9olemU2tZf50SZV88F8KSo4v2nyxKC3NiGrn3om88AVA7W
         6ftg==
X-Gm-Message-State: AOJu0YxfYlrjNko3LMV4MEWm57FPw3sFIqhyrFr9zNeAGLBCUgZvX9GJ
	7Cx0a24jvgFd481ecri6WxNShrzvsCI=
X-Google-Smtp-Source: AGHT+IFcpIZeqK3zz4tunxGlVwsObz7gLBP6vRYrW+YtGNmboWthk9yxvcxFG2yYoZyaNa6pQatW2w==
X-Received: by 2002:a17:902:e54b:b0:1d0:b3f5:c318 with SMTP id n11-20020a170902e54b00b001d0b3f5c318mr23239906plf.106.1703090190143;
        Wed, 20 Dec 2023 08:36:30 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:b2aa:4964:8bfa:71c? ([2620:0:1000:8411:b2aa:4964:8bfa:71c])
        by smtp.gmail.com with ESMTPSA id y16-20020a17090322d000b001d09c5424d4sm23163822plg.297.2023.12.20.08.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Dec 2023 08:36:29 -0800 (PST)
Message-ID: <19c10384-8b08-4f9d-af74-7f09737b02a6@acm.org>
Date: Wed, 20 Dec 2023 08:36:28 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: ufs: Simplify power management during async
 scan
Content-Language: en-US
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, stable@vger.kernel.org,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Stanley Jhu <chu.stanley@gmail.com>, Can Guo <quic_cang@quicinc.com>,
 Asutosh Das <quic_asutoshd@quicinc.com>, Bean Huo <beanhuo@micron.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20231218225229.2542156-1-bvanassche@acm.org>
 <20231218225229.2542156-2-bvanassche@acm.org>
 <20231220144241.GG3544@thinkpad>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231220144241.GG3544@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/20/23 06:42, Manivannan Sadhasivam wrote:
> On Mon, Dec 18, 2023 at 02:52:14PM -0800, Bart Van Assche wrote:
>> ufshcd_init() calls pm_runtime_get_sync() before it calls
>> async_schedule(). ufshcd_async_scan() calls pm_runtime_put_sync()
>> directly or indirectly from ufshcd_add_lus(). Simplify
>> ufshcd_async_scan() by always calling pm_runtime_put_sync() from
>> ufshcd_async_scan().
>>
>> Cc: stable@vger.kernel.org
> 
> No fixes tag?

There is no Fixes: tag because this patch does not change the behavior of
the UFS driver. The Cc: stable tag is present because the next patch in this
series has a Fixes: tag and depends on this patch.

Thanks,

Bart.
