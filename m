Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C8A146D40;
	Thu,  3 Oct 2024 07:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727939269; cv=none; b=f1Tx9JOOw5o+Tar0dTih/4ZKXcJzAXFWbvFIwIL0D1OOeY0/6t3wfD4VZrycdWee2nK7firQssBfcJWe5y8kIAI5Ap7nxNf1SKF428safDLTMsfNU4j8pPiMoc6Ljn6/7YZwe9oq67IglHZosDnqXTnkH4ujAa/SfmUsVLUxfHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727939269; c=relaxed/simple;
	bh=NjDgeMiAupMePVAdiqilnh6D1v72p7JSY46Qoi5G6T0=;
	h=Subject:To:References:Cc:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=l1HeaiTVgpBqWwvGGFezL6RcNSMCyG4YSvMD6rfbo1Wz7AoiIPWmn30mvhy+Z6++gxlUJlV+jFUQzOu0Vehcjd3zhqfx5Zcfv1r0bzRAIk1wYJRtk/tM17fC/q4UG3n0ncwjXTmpvUhI8TeCfp/Xi0/9ILiiO7G8DV8lcBlTceY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ijm8avBh; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ijm8avBh"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-71dae4fc4c9so572652b3a.0;
        Thu, 03 Oct 2024 00:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727939266; x=1728544066; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:cc:references:to:subject:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yj4ZqqssXC1YE4w8/4uTRHTg84LdH7zb4LoZ0xrnsZ8=;
        b=Ijm8avBhl86MxNh1FfGjGh+3/WnnKlWIYzzFqTyvv4TI9H3C7I+AOJoNnfRH+W4icz
         tsLnUiw7y2S1L5FhHeHVXdmtEQ3RTjqRX15cN6C8W24trARKUMgialcr7rQpqA9VpJwO
         +uQ20tl2QL1fxkORmiAZRd8b+sNFEM+Zcqs2ETM0RaJY3j1Zq0aozrW89+9TRGNgXLlL
         ByZStTM9sYWfnNfQrFVDTS6+adY9S5NoWrI5ZApIIk1r/yOiwX5HV5AlLzCV6l8Jk61Y
         W6O4O5ZE1hKxbGcFZhIDNZbsPHXcf3ncRV9KG0PHMnJg90tHSZUdUJuiCZKV2aSxVlQg
         A4fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727939266; x=1728544066;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:cc:references:to:subject:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yj4ZqqssXC1YE4w8/4uTRHTg84LdH7zb4LoZ0xrnsZ8=;
        b=lh0va2+Fo5yeYs6owPFTtSn5vB42OhELbxjfMzhnIFxyxP/taUEisbVvRropPhaJJt
         9e/ORmlvTg0aMNfQj5ya9RT73NfYUWpyUijJldbtbpZubIwmluvA6DKscq45n+P/vD08
         LfcEx69TpzbYd3JkP5AmQCdPkJPeetuY6WAS5QJgkZhGkeYTHFNp9iCKLhTzuX9GbJMB
         mi8pdDB4VBefUClztm7QMeH20mdnM7tdqkz/ywsRM0nd+vnVAeDiCaSw+PYY0THQ+95K
         TMfWuVFy8LMClTApfwQj4UDi+ReDwfcogLUXnleOVDBcXPUe3r+yVGUntE2uNDWYwCcZ
         XNzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYD/00zxbtngUlNSbndKdDkmfrxHQgkYAjXxs9ITOMF3HxKy3LqunHzENsKnREkEhmAuITrGs8mY5xjQ==@vger.kernel.org, AJvYcCXHlYhqlFo5SvBy0xyUAP3t5TKc77KyCMMVSH0qcxYyF7eCwoA0ZZjUnnodMx3tIUadjSBLWH+/vkbtmGw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiaFEBKU8JgKVbL8mTAfEKWjeZQNQ/BLc1RKqzagoe0E1rN+5g
	gFOA4Tb9Qhk7QqV8MLLSoY7QGDP+jGt1Zbl+mpUsWkg+wMy2y83vovBWUQ==
X-Google-Smtp-Source: AGHT+IHpFQhaG+csroL4qOxuAj1B3qoK6C6RbT35mfFGGy11YQN/7CwLISGPGVMsV9cRIsjlwiRGzw==
X-Received: by 2002:a05:6a00:b50:b0:714:2d05:60df with SMTP id d2e1a72fcca58-71dc5c8f21bmr8762855b3a.15.1727939266225;
        Thu, 03 Oct 2024 00:07:46 -0700 (PDT)
Received: from [10.1.1.24] (125-238-248-82-fibre.sparkbb.co.nz. [125.238.248.82])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7e9dcb14096sm114379a12.42.2024.10.03.00.07.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2024 00:07:45 -0700 (PDT)
Subject: Re: [PATCH] scsi: wd33c93: Don't use stale scsi_pointer value
To: Finn Thain <fthain@linux-m68k.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <09e11a0a54e6aa2a88bd214526d305aaf018f523.1727926187.git.fthain@linux-m68k.org>
Cc: Daniel Palmer <daniel@0x0f.com>, stable@kernel.org,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
From: Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <18314bc8-bf29-c1de-d32c-dbc93ded975b@gmail.com>
Date: Thu, 3 Oct 2024 20:07:39 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <09e11a0a54e6aa2a88bd214526d305aaf018f523.1727926187.git.fthain@linux-m68k.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Finn,

looks good to me, so:

Reviewed-by: Michael Schmitz <schmitzmic@gmail.com>

Cheers,

	Michael


Am 03.10.2024 um 16:29 schrieb Finn Thain:
> From: Daniel Palmer <daniel@0x0f.com>
>
> A regression was introduced with commit dbb2da557a6a ("scsi: wd33c93: Move
> the SCSI pointer to private command data") which results in an oops in
> wd33c93_intr(). That commit added the scsi_pointer variable and
> initialized it from hostdata->connected. However, during selection,
> hostdata->connected is not yet valid. Fix this by getting the current
> scsi_pointer from hostdata->selecting.
>
> Cc: Daniel Palmer <daniel@0x0f.com>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Cc: stable@kernel.org
> Fixes: dbb2da557a6a ("scsi: wd33c93: Move the SCSI pointer to private command data")
> Signed-off-by: Daniel Palmer <daniel@0x0f.com>
> Co-developed-by: Finn Thain <fthain@linux-m68k.org>
> Signed-off-by: Finn Thain <fthain@linux-m68k.org>
> ---
>  drivers/scsi/wd33c93.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
> index a44b60c9004a..dd1fef9226f2 100644
> --- a/drivers/scsi/wd33c93.c
> +++ b/drivers/scsi/wd33c93.c
> @@ -831,7 +831,7 @@ wd33c93_intr(struct Scsi_Host *instance)
>  		/* construct an IDENTIFY message with correct disconnect bit */
>
>  		hostdata->outgoing_msg[0] = IDENTIFY(0, cmd->device->lun);
> -		if (scsi_pointer->phase)
> +		if (WD33C93_scsi_pointer(cmd)->phase)
>  			hostdata->outgoing_msg[0] |= 0x40;
>
>  		if (hostdata->sync_stat[cmd->device->id] == SS_FIRST) {
>
