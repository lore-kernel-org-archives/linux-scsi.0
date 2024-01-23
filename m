Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854B45F55B
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 15:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706023409; cv=none; b=dJR0OcqmPkQu9n0YnOlf7xAUr8ZLRUOMXd+4qvTGvTjQGd9Tb7tgh93UCfkNNUmiKo5PbCODGCEt5JxwupsgBod58Y/ad5DL2fab780y+0gG808jInziuldZtw8AT2bq+fYtsqAp/ZhMH8ikF9kBAz+vxADeQb2/0eyCupifyCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706023409; c=relaxed/simple;
	bh=W6W4mHD/1/kj8Pr7kK/pxgY5ZKtR18Y0ABYpb5wltX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D+9zpskztvwwTcFSTC4ywU1pndj/fdwJgDxeM65K6j1b3hOli3+9Aa3wMbNpnWvr7tpzJS45Js6d6j1QYFLh6cLwZbsapKWYhFrFFcdn3NkZTNllHmdBhZhZB65gKrR8oHvU+LG0cuafU8cgGV5/Ew0WGjBG/SnJbnpyHMSOxfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1d74678df08so13062535ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 07:23:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706023408; x=1706628208;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UnyaTg8tEH50r8T+XJJ3ZutZaBHXDpnoAZx0/s3fi2I=;
        b=eWGDVugCfmt+plUMeq6n8qXKUxXpm/sVKuo8Wnt5WBsS9EiwyqBF+GLOONlzIil1QF
         EtUS6efa4uiXrtPnRGaupbaci+cGuNdm4UDQIuR9NAcyg3giWLAh8zfEpsOZx1vh/iX7
         J/EUE5HklBejxG5hZQiQ/G/3PUbOojFCTrP1S7EfVSF2mxB1k8BfuuYLUJKJWWF0PFWR
         Fq536JPRHo04GjT2keW94XLfloHq5CtFoj7BIOLp0ogRlXMU/layo0JeUQ11P2b9k7Mb
         A4ZJ7s6lDzTF/jF4B5l0LR288eOJ38GMqiQdjcHfHnkiyHhkJeJHWpMjHiCC2hhKvI0d
         UbDA==
X-Gm-Message-State: AOJu0Yw3ZwpNxU9uNKkXPR1yEWNJd/NwxO1FQIc4N7ppSCVsiPkBlHyw
	hXNPG+fkrWCT3Us10rqyKMpSH2iD2fqx/B9b0iRfcRK/Wvy5xkT1F8b+gBPM
X-Google-Smtp-Source: AGHT+IGPkcpm5sTg8cDz79wa5JkaytXGpXE4XkEDeFocA8P5ooSClyJShWepyxHbLDbU86T8c3wsVQ==
X-Received: by 2002:a17:902:ab8a:b0:1d5:6f76:95bf with SMTP id f10-20020a170902ab8a00b001d56f7695bfmr3021704plr.112.1706023407827;
        Tue, 23 Jan 2024 07:23:27 -0800 (PST)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id v19-20020a170902d09300b001d6ee62787bsm8995440plv.42.2024.01.23.07.23.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 07:23:27 -0800 (PST)
Message-ID: <9ef3b977-747f-421f-9dee-2b8a5037424f@acm.org>
Date: Tue, 23 Jan 2024 07:23:25 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: move scsi_host_busy() out of host lock for
 waking up EH handler
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: Ewan Milne <emilne@redhat.com>
References: <20240112070000.4161982-1-ming.lei@redhat.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240112070000.4161982-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/11/24 23:00, Ming Lei wrote:
> @@ -87,8 +87,10 @@ void scsi_schedule_eh(struct Scsi_Host *shost)
>   
>   	if (scsi_host_set_state(shost, SHOST_RECOVERY) == 0 ||
>   	    scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY) == 0) {
> +		unsigned int busy = scsi_host_busy(shost);
> +
>   		shost->host_eh_scheduled++;
> -		scsi_eh_wakeup(shost);
> +		scsi_eh_wakeup(shost, busy);
>   	}

No new variable is needed here. If this patch is reposted, please change
the above into the following:

+		scsi_eh_wakeup(shost, scsi_host_busy(shost));

With or without that additional change:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
