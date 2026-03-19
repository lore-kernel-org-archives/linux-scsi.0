Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AC73ACA6F
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 14:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773931387; cv=none; b=OJ/qPk2E+TTBWJfKlCadTGrFLglspjiWSiek+g82EauxDRxLHraZVg+YozqlxY1nm8cx6YADrSaq7r7uuG8RDcB8GV4kpqjL8Mye0Ps56tShv8arzr9scssM8F97h3v0Ekuno4+jp5LXgjAG+AurC8Swe3Yz4NM1x31X78IW5+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773931387; c=relaxed/simple;
	bh=LqO95S2oX1JKV3VA16abIl+G54sj1NrGBzMiboxj1sU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yw5GOS/zM1mk8mY+ovJGL9ftNBt6RyfBVMfEfxOawvkF7Lv2Q3mrNeLCDMoR8M+V7+WOu01elBeRkJ75W9OvkFix7gu3AlnAjU2ExvUd1plu5ZPTRvUjy64/G0ue5IpExXmQvXDC8llzXovQG1moKLe4bTAFhNkM3SuI3chM53Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TYUGN5Ub; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TYUGN5Ub"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2aecefc7503so5681805ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 07:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773931385; x=1774536185; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+CE8wXgkuBaP9Z+pEoEhpUGW+wfFybV/tf8cLOkrCEM=;
        b=TYUGN5UbaZFSs8MEvDpVk+9X8iA7LbCt375+PITcRNOYhBNVzMBiqqpJnJdiHRhxXV
         V76TgAz+rASV+ojU+McCrEJPoII3E/4qm9pKTVkD1u9k6sWNH4FgPaj21JrNipYe2Y7m
         qTbj75oXGzqg0i2lj1BOXQ9YZXQPVTLBR9nXx722UxOwUQObR2k/7jTnUo1RuMlLT1nV
         Kn8F5VREx01l7rvfZi1fn4yV6uNTvNLiqmG1tI/ktnwbogSVjiIlbs4NjBBYdcFpX2P4
         pA1uqNAQvS9SvnAir2Wcmf9ndqLTJ4r65llWGgKyIU9YBNieGreE2vrBwTo1c5aL+Gkn
         84Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773931385; x=1774536185;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+CE8wXgkuBaP9Z+pEoEhpUGW+wfFybV/tf8cLOkrCEM=;
        b=o/msdTJGQD6SDBhgEWaQzcMd62q8lzKdhNLyDjMHpF9KcEiUCRhVVZyz0DSvhQ1Pes
         FuXBzKONRg+7+JRLZZ2szroeSlg4W4mwk2JPCorVKRbnQXhLFYHpspqB8dd1qWdX5Ozj
         sHW4tQ6v2nmmHORGUn24gWEzRIrvq65Xsp2iUP4BFStK6+43Zykbpb/xoHumwvN5pYkX
         Bhe9I5GchPLS4QKebPcGpltERj/Z31U1kFDHZbp+CQX97fCXJuQje72BtTVFt9ymSPbc
         MrsJEg28zO2fHK2Bn3XzHNxnYoAG844Ue8+XbpwLrAzpLMacCFIkmRTRl4/9vxqQbBKW
         6UBg==
X-Forwarded-Encrypted: i=1; AJvYcCVnzZ5YrcM6kD9a8gu5qpqgkOHWT/n/XRdSsk8OCliSdjGtoFE6YALbBdJLsR6oXCbuekfEVB7ILiG+@vger.kernel.org
X-Gm-Message-State: AOJu0Yy539jQbf5G8yBjXxVVJdMVVm262IUwA7cmM57aUCK3IJObHBOb
	ypfAUXTpIKSKPS9Sa8BwFMC7wXk7yKp7OIwJCU+IfylAbCUSrXTpoLyy
X-Gm-Gg: ATEYQzwLdurx6VLaKO2UnWrNguzp4ZEtIUEOELpA+cwpjyB7nJkqn5G2rL294xLvgZF
	gXiza6xwhQeaX+KvfXSn8i4pd7wOtnbXX5rySYqTH5GmdnLsGvHFm2p1ehJtlm2EI2QGGBGHVKd
	ff/QjrH/scjRtsgGPHhU1pzfcIAjv3vjqk0qTJubKQHyIQ5uF5nQumR+5Qqxa6d5aZWQwyIVPwt
	Bo3ybyHdGgsSuvA5Y7zzmLFn+k758Q71WXgDYQJQPQgJgZWGwcmVS3IhCdIadV1osIanLl2cVWV
	Qa4g1401ospr1dskCI02c4eYX2HnXiBSPOJfyi8sNHw6z2NX/Hzf46oxL5Hhz1PNtT9vx2oRGL4
	DV9rfxS7ORi8F/FTRZhSnHsXX7qFUSqOi4kn0QNRshsu65f1m/DMYnWuPyu6d6CtrMAKyzsR8k+
	V0USqRPpLRRiNeLzbgcvIejUC1lrTUcEI=
X-Received: by 2002:a17:902:ecd0:b0:2ae:54b2:27c7 with SMTP id d9443c01a7336-2b06e418908mr77693525ad.39.1773931384943;
        Thu, 19 Mar 2026 07:43:04 -0700 (PDT)
Received: from [192.168.0.106] ([103.216.213.160])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e5f0f25sm60516775ad.42.2026.03.19.07.43.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2026 07:43:04 -0700 (PDT)
Message-ID: <44b1f4b2-69d8-423a-8ab2-8de7b2fa84ee@gmail.com>
Date: Thu, 19 Mar 2026 20:13:00 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: buslogic: replace strcpy() with strscpy()
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
 Khalid Aziz <khalid@gonehiking.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org
References: <20260314-strcpy-v1-1-0b38691fe11e@gmail.com>
Content-Language: en-US
From: Atharv Dubey <atharvd440@gmail.com>
In-Reply-To: <20260314-strcpy-v1-1-0b38691fe11e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

A Gentle Reminder for reviewing the patch.

Thanks,
Atharv

On 3/14/26 01:58, Atharv Dubey wrote:
> strcpy() is deprecated as it does not perform bounds checking[1].
> Using it can risk buffer overflows if the source string exceeds
> the destination.
>
> Replace occurrences of strcpy() with the safer strscpy() where
> the size of buffer is being checked.
>
> Compile tested.
>
> [1] Documentation/process/deprecated.rst
>
> Signed-off-by: Atharv Dubey <atharvd440@gmail.com>
> ---
>   drivers/scsi/BusLogic.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index da6599ae3d0d..c070f3b8197e 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -1262,7 +1262,7 @@ static bool __init blogic_rdconfig(struct blogic_adapter *adapter)
>   		for (i = 0; i < sizeof(fpinfo->model); i++)
>   			*tgt++ = fpinfo->model[i];
>   		*tgt++ = '\0';
> -		strcpy(adapter->fw_ver, FLASHPOINT_FW_VER);
> +		strscpy(adapter->fw_ver, FLASHPOINT_FW_VER);
>   		adapter->scsi_id = fpinfo->scsi_id;
>   		adapter->ext_trans_enable = fpinfo->ext_trans_enable;
>   		adapter->parity = fpinfo->parity;
> @@ -3451,12 +3451,12 @@ static void blogic_msg(enum blogic_msglevel msglevel, char *fmt,
>   	va_end(args);
>   	if (msglevel == BLOGIC_ANNOUNCE_LEVEL) {
>   		static int msglines = 0;
> -		strcpy(&adapter->msgbuf[adapter->msgbuflen], buf);
> +		strscpy(&adapter->msgbuf[adapter->msgbuflen], buf);
>   		adapter->msgbuflen += len;
>   		if (++msglines <= 2)
>   			printk("%sscsi: %s", blogic_msglevelmap[msglevel], buf);
>   	} else if (msglevel == BLOGIC_INFO_LEVEL) {
> -		strcpy(&adapter->msgbuf[adapter->msgbuflen], buf);
> +		strscpy(&adapter->msgbuf[adapter->msgbuflen], buf);
>   		adapter->msgbuflen += len;
>   		if (begin) {
>   			if (buf[0] != '\n' || len > 1)
>
> ---
> base-commit: 173b959a8bb814f55660f7c34ddedd4e75c203d2
> change-id: 20260314-strcpy-da7093836551
>
> Best regards,
