Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3DC1B4;
	Mon, 27 Nov 2023 11:35:51 -0800 (PST)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6cbe6d514cdso3676523b3a.1;
        Mon, 27 Nov 2023 11:35:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701113750; x=1701718550;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l65xiZa5Zlgpg9GJQ4HILx5uG5sfJyEkxP1hRRGfpG8=;
        b=r5RtZ8vWkhheNrAqc93Y5ialR/WV4Ea7nyddQ+hrpX+aKbdvnnDLYKEEIlr7JuyY75
         KQ2+nuWC9lAb2ioV6US4v3C1di3+oyGWjuBnymBr2Hnl+aJrJu3GeumyYzBKlDtsqKRv
         LpsCYMWWrFcSnkyNfVJx8PCOp9lpkLAaCEk+0rCNjfJ9iYpPav2xvCk5tWFealK+kvWS
         IRjow5zc8qQQMnDzYb1HgOrPXqBZQynZzsJjTlflWmaPFqDU+kJ8Q37ZlErjKpyPK7MC
         ZgfI3DCMYXduj/XOVmfaVSN1C7sWNIHMSw+cp3Kjc0IpZHzbtowrA/fytEiVvLA6LoKg
         5cPg==
X-Gm-Message-State: AOJu0YyxqqS49JkD4c1Anpm6qXBX/y/dnBD+4vTYONYGr1Q38/jw5w4u
	4Gv7A5kmjshPKwPVTCQOBeQ=
X-Google-Smtp-Source: AGHT+IFbSHyTUNE0OorjeJLsHDvy1ugTcNLJdJ/t+hAQimdgdh4kOi+s550JvIZtxMrc/SHoxZZoRA==
X-Received: by 2002:a05:6a00:3988:b0:68e:2f6e:b4c0 with SMTP id fi8-20020a056a00398800b0068e2f6eb4c0mr13409383pfb.28.1701113750302;
        Mon, 27 Nov 2023 11:35:50 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:c7c5:cabf:7030:2d30? ([2620:0:1000:8411:c7c5:cabf:7030:2d30])
        by smtp.gmail.com with ESMTPSA id fh20-20020a056a00391400b006bb5ff51177sm7540123pfb.194.2023.11.27.11.35.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Nov 2023 11:35:49 -0800 (PST)
Message-ID: <a9748872-0608-4ab9-8986-a82eff17ca9f@acm.org>
Date: Mon, 27 Nov 2023 11:35:48 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 00/19] Improve write performance for zoned UFS devices
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>
References: <20231114211804.1449162-1-bvanassche@acm.org>
 <20231127070939.GB27870@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231127070939.GB27870@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/26/23 23:09, Christoph Hellwig wrote:
> I still think it is a very bad idea to add this amount of complexity to
> the SCSI code, for a model that can't work for the general case and
> diverges from the established NVMe model.

Hi Christoph,

Here is some additional background information:
* UFS vendors prefer the SCSI command set because they combine it with the
   M-PHY transport layer. This combination is more power efficient than NVMe
   over PCIe. According to the information I have available power consumption
   in the M-PHY hibernation state is lower than in the PCIe L2 state. I have
   not yet heard about any attempts to combine the NVMe command set with the
   M-PHY transport layer. Even if this would be possible, it would fragment
   the mobile storage market. This would increase the price of mobile storage
   devices which is undesirable.
* I think that the "established NVMe model" in your email refers to the NVMe
   zone append command. As you know there is no zone append in the SCSI ZBC
   standard.
* Using the software implementation of REQ_OP_ZONE_APPEND in drivers/scsi/sd_zbc.c
   is not an option. REQ_OP_ZONE_APPEND commands are serialized by that
   implementation. This serialization is unavoidable because a SCSI device
   may respond with a unit attention condition to any SCSI command. Hence,
   even if REQ_OP_ZONE_APPEND commands are submitted in order, these may be
   executed out-of-order. We do not want any serialization of SCSI commands
   because this has a significant negative performance impact on IOPS for UFS
   devices. The latest UFS devices support more than 300 K IOPS.
* Serialization in the I/O scheduler of zoned writes also reduces IOPS more
   than what is acceptable.

Hence the approach of this patch series to support pipelining of zoned writes
even if no I/O scheduler has been configured.

I think the amount of complexity introduced by this patch series in the SCSI
core is reasonable. No new states are introduced in the SCSI core. A single
call to a function that reorders pending SCSI commands is introduced in the
SCSI error handler (scsi_call_prepare_resubmit()).

Thanks,

Bart.
