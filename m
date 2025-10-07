Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3441D7E41
	for <linux-scsi@vger.kernel.org>; Tue,  7 Oct 2025 21:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759871882; cv=none; b=WhIkY1I4bjJfwdUWYfdR4lFmcNofOjc7GcVY+5JkkoNoa7LGiYJHB+Eq11Mm3If//IRToJtKpk5tnOacWjUvC9Dmi15YiCsYHMLKtWY2c63JLZ3S0twoMKTyzX+V28hDzXVQ34zq6Raia/meIwMFgEFEwS+w0qhtPr/yy4kbpqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759871882; c=relaxed/simple;
	bh=m34tLBwz1PIe/S0WfQ2UYFZwrQXwN9LclHWU15mdFJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hDf2nmEG/7ITib+DOwVbz+WbL0QHnVJG+VOaY/qnwpi5S+tXUWbEpg1P07YSZwP4m/GvuKfxu7hF0glM3xh7dkTRYYpisP9qFRhpusoL1j6VU1davsTo9bGgpDlYfy+WToSpFhmPxfSdHtWehqGlu/xHBZYTEYnyIMH/jAWahqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wo4soBro; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wo4soBro"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-92aee734485so293291139f.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Oct 2025 14:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1759871879; x=1760476679; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4L3v1zXzH1XthRJD+O7BTVEnTPegVXFNbA8wvQbrEuo=;
        b=Wo4soBroleVSXHoR6mY/gZBGGh8s4TnXtyrWBfvv/yuXbUJOi+dfHb2A2S+9bHd9W3
         CWqtj7dO1WrDLGX1NHUOlys4l1ca2dhT3y4sWPju8El5bxtTUsVgahIk8IIeLWMQl0Cc
         wNVMvKnOCzO5TH1hQ4eRHRqrOpRFii0eEozUg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759871879; x=1760476679;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4L3v1zXzH1XthRJD+O7BTVEnTPegVXFNbA8wvQbrEuo=;
        b=wX18/iP4PGdvQX+9DV9Kemcb/W9Wd1BMrHxYddte58BBgvtjP8CvRlPnJfFFnO5y56
         7o1FUt61OUiaXgWTvGpAIiMveK2zJK6ty4I8FWR3TVGcTf9ee0m+hx9Cj6l/BX+YgkRn
         lxYXvT/HDnmSQZOVHY+PDw6GbXXdHM/xJUDw3AgO6fzfOxz++t/JvryWwO2I5/g9kFz7
         qtAPX7+B0wUgFgSz/N+NzbsngQ99/Bv8Xz9pozhuIW7gJHIYTtldYybifmC5M92kWXG2
         f5GzWr2nG61xjU/r+JQ/ROYS7pRe1Vf08W+thO6+ApoRFLhvGs+3ENH9JD4Pt9B6kmRA
         gzYw==
X-Forwarded-Encrypted: i=1; AJvYcCXhBWjk1AX3JSvWbXWE8t84csGAJBBaka1XEeTptjF/DP6Wfd8xOBjlrpnlgZGp/zMV5eF3OPHVVVdH@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb5cDPLXASvfjtomC4rRIzKuWNuij0AlF5DcI4K1xpRAPaLpG2
	oUB2VO2vu1nFv7qBV7NqOUoaw7Ilf23EbqQGcTRl2uMtkayZZHr3XXREDu8f197Cs1w=
X-Gm-Gg: ASbGncs0rmBs9xTijkRSIwXA3N7w6HvN0geU2hLfDWNZ+wOHyWynmudHfKFphby1QWz
	hHD3K5j+tDpQ7e1vgqFdT+JKmtLiVM4UCBH+6D4rMQV4TsM/JHrjN4utzgCxhwy4w9Yx9RBv4xx
	GSAgEk3s8hDwGVpAp1h346GVsjxNTI28FXxf7l0K0OKyB6pguroTAeLJQTsNUVJeUllb9FQ/Cv8
	3jPGm1pM41K0D4qNm8fnRcqwX8KUvHsCEE8iAPDcA6fUg68bjPePoTMBXKNirVnKQJcBwtGs+CE
	3dcwfhpurWRim2Oyxa+c0WYevEQCIgm/6K7+yTIzl2M5Ao3K38U3kYvK5qU385H9V830jyVQSbk
	iaYaN2jyRt4hSVQ6xDmygcpYFhqirWAulAgKKz1H2vEVs3MEVUYVOrvvhH9k=
X-Google-Smtp-Source: AGHT+IFF0GpolSwqbh8qtuQ+qbO+AbH5QO7XIKCSeB2JmlXgRUD9SQ2+4zyonUIurKTJfoYnKHxvJA==
X-Received: by 2002:a05:6602:158c:b0:93b:b891:d6e1 with SMTP id ca18e2360f4ac-93bd17b9cfemr114458539f.5.1759871878936;
        Tue, 07 Oct 2025 14:17:58 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-93a7d81c743sm603525739f.6.2025.10.07.14.17.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 14:17:57 -0700 (PDT)
Message-ID: <3adc91e7-8a96-4ffe-b891-2b9df252d8da@linuxfoundation.org>
Date: Tue, 7 Oct 2025 15:17:56 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] driver/scsi/mpi3mr.h: Fix build warning for
 mpi3mr_start_watchdog
To: Bartlomiej Kubik <kubik.bartlomiej@gmail.com>,
 sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
 sumit.saxena@broadcom.com, sreekanth.reddy@broadcom.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 david.hunter.linux@gmail.com,
 linux-kernel-mentees@lists.linuxfoundation.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250924160635.27359-1-kubik.bartlomiej@gmail.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250924160635.27359-1-kubik.bartlomiej@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/25 10:06, Bartlomiej Kubik wrote:
> Fix watchdog name truncation.
> 
> In function mpi3mr_start_watchdog, watchdog_work_q_name is build
> snprintf(mrioc->watchdog_work_q_name,
> 	sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->name,
> 	mrioc->id);

Include build warning in the commit message

> 
> Signed-off-by: Bartlomiej Kubik <kubik.bartlomiej@gmail.com>
> ---
>   drivers/scsi/mpi3mr/mpi3mr.h | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 8d4ef49e04d1..5307fcdf216f 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -66,6 +66,7 @@ extern atomic64_t event_counter;
> 
>   #define MPI3MR_NAME_LENGTH	64
>   #define IOCNAME			"%s: "
> +#define MPI3MR_WATCHDOG_NAME_LENGTH	(MPI3MR_NAME_LENGTH + 15)

This 15 looks random to me?

> 
>   #define MPI3MR_DEFAULT_MAX_IO_SIZE	(1 * 1024 * 1024)
> 
> @@ -1261,7 +1262,7 @@ struct mpi3mr_ioc {
>   	spinlock_t fwevt_lock;
>   	struct list_head fwevt_list;
> 
> -	char watchdog_work_q_name[50];
> +	char watchdog_work_q_name[MPI3MR_WATCHDOG_NAME_LENGTH];
>   	struct workqueue_struct *watchdog_work_q;
>   	struct delayed_work watchdog_work;
>   	spinlock_t watchdog_lock;
> --
> 2.39.5
> 

You are changing the structure size here? How did you test this
patch? DO you have this scsi card to test and make sure this
change doesn't introduce regressions?

thanks,
-- Shuah

