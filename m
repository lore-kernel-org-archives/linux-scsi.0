Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E0E16F910
	for <linux-scsi@vger.kernel.org>; Thu, 20 Jun 2024 08:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718870831; cv=none; b=mX/4C+cI+WqqcGjaEeIWOAonUZ1RZWkk6qbg9jPWgeEN50p5KHvTA0xxYb/uZuiN+QPxAnDpuNt2Ghd8b1BSCwvLZ0NEIAVb/dfnIvwMCSfTXcSU06kRbBcrV7j61jgVFNRTz+GZANhpbmuJU6bV3lan9idIXcTb9NclwbbMEew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718870831; c=relaxed/simple;
	bh=rDCkbyG1sy30IcrzSECEWLUdBhLZ3/tKxlOeS2zkKeU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IrheO3WFUaXEhzk2YzSjprapUHMlvZitZl9szAttcPR111eFP9i6JK8cjGqbo3f3q3LS24qIuDyUvAB3eB9uvzxp6BnnSN21fMeHFHwTDduimucNZL+Zu02EEDQqVv8z3k1+eltMEIZjLWOc619l092Qo56k1O9cYD8A+vg7yKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UrhQOULt; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UrhQOULt"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7024d571d8eso519152b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jun 2024 01:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718870829; x=1719475629; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zdiqIMbCI4KRz3nU88e6zzl0gqF5CC415T05lnLS5Rc=;
        b=UrhQOULtO8KuvtPo/ikFV6QpWB3jh5AWVd844WTM1fNNh/TWNQHHgxPH2R0VASuz7n
         HMamkqdFg+ea32UHMEU0ICw3aG290OUtdJ8wha9eDryXxLnEeu9gafNeMnEFiJEykOI3
         r9acrydIb1TVw9pDh6A/+6CZcC94e55oDUPpoIuO2m31kmIqc5R5ZC1/Dl1xSW835Tvc
         GwynuAYhU3/+ckWtfAAIHj/O81I32VT7XuFDjPvqb9Xm8BKeESVbBhmPNxybb1CXtOjC
         hTKlhzaOAGtxHbNABQ6qXN559k6Mkz6LWolfXMuRWY2o3zvo7BnMbA1+IYd6xxsl0Q33
         ltWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718870829; x=1719475629;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zdiqIMbCI4KRz3nU88e6zzl0gqF5CC415T05lnLS5Rc=;
        b=t/Wp30CfzutAtUCBsplX96rSSKiPNoOgiqaf7c6XniSfmmafzZGXmgzKxbpkl6ZYl/
         ZURDG5FNIYfU31FiClUlvs564n+Ym97xZhkUstKRFoopJQq2QMlpU9I/Y//5nh994iD9
         +pjy7+Lx5sNlftW0nb9Izzt7KrkR34IQowRsf3PE3P0egfPiCLDgdtpZ5wiVDU3WpR+s
         MxOaegF2Fx7/Iq6zCQ/sj1nvuZvuAGLNMG9QZT1uyOT0TfZda2Wn6qxwS4m/LrOFR0SK
         KubRgG8lj6bY9w/jlH9YfIFURiaqZ/7BtIiyiFN4Q2DMolQaD9JnI1lbg6L0QJK89Fwm
         Tlqw==
X-Forwarded-Encrypted: i=1; AJvYcCWiINm9cQFTVF8B7u+/zCzHyPNW32bZqN5zpiPcxk9CRB9js0uvlSCYBdWgyu6aBvRaV0uWxisPeCuqU1BCrOkwvNQ7dcM9/LeBnw==
X-Gm-Message-State: AOJu0YwnQfONaKCYvl8NDzE5/IY4xnQRQMYXxdsIiQyLSL9B5L1VjiXj
	smnTOwMGqWjMPY1PWsg0Gb8L2JXqIF5eH5SLPA5qFCR/Al9C79BVAuHLv+5VLt4=
X-Google-Smtp-Source: AGHT+IF8Yy+Eb56lnDztrX7r+jplJLJp+8oT5vP7EbWoeIK0ugNcJEYB1nK93tTiAAj1/Hfq1riyhA==
X-Received: by 2002:aa7:9f0f:0:b0:6ed:21c0:986c with SMTP id d2e1a72fcca58-70629cb864cmr5586093b3a.24.1718870828835;
        Thu, 20 Jun 2024 01:07:08 -0700 (PDT)
Received: from [0.0.0.0] (97.64.23.41.16clouds.com. [97.64.23.41])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6fee39bba00sm10603675a12.78.2024.06.20.01.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 01:07:08 -0700 (PDT)
Message-ID: <9f743550-f104-4557-a4f7-18ac054e913b@gmail.com>
Date: Thu, 20 Jun 2024 16:07:04 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: scsi_debug: fix create target debugfs failure
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: Wenchao Hao <haowenchao2@huawei.com>
References: <20240619013803.3008857-1-ming.lei@redhat.com>
From: Wenchao Hao <haowenchao22@gmail.com>
In-Reply-To: <20240619013803.3008857-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/6/19 9:38, Ming Lei wrote:
> Target debugfs entry is removed via async_schedule() which isn't drained
> when adding same name target, so failure of "Directory 'target11:0:0' with
> parent 'scsi_debug' already present!" can be triggered easily.
> 
> Fix it by switching to domain async schedule, and draining it before
> adding new target debugfs entry.
> 

Thank you for the fix, the change is looks good to me.

> Cc: Wenchao Hao <haowenchao2@huawei.com>
> Fixes: f084fe52c640 ("scsi: scsi_debug: Add debugfs interface to fail target reset")
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   drivers/scsi/scsi_debug.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index acf0592d63da..91f022fb8d0c 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -926,6 +926,7 @@ static const int device_qfull_result =
>   static const int condition_met_result = SAM_STAT_CONDITION_MET;
>   
>   static struct dentry *sdebug_debugfs_root;
> +static ASYNC_DOMAIN_EXCLUSIVE(sdebug_async_domain);
>   
>   static void sdebug_err_free(struct rcu_head *head)
>   {
> @@ -1148,6 +1149,8 @@ static int sdebug_target_alloc(struct scsi_target *starget)
>   	if (!targetip)
>   		return -ENOMEM;
>   
> +	async_synchronize_full_domain(&sdebug_async_domain);
> +
>   	targetip->debugfs_entry = debugfs_create_dir(dev_name(&starget->dev),
>   				sdebug_debugfs_root);
>   
> @@ -1174,7 +1177,8 @@ static void sdebug_target_destroy(struct scsi_target *starget)
>   	targetip = (struct sdebug_target_info *)starget->hostdata;
>   	if (targetip) {
>   		starget->hostdata = NULL;
> -		async_schedule(sdebug_tartget_cleanup_async, targetip);
> +		async_schedule_domain(sdebug_tartget_cleanup_async, targetip,
> +				&sdebug_async_domain);
>   	}
>   }
>   

