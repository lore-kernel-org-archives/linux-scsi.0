Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E8218A6D7;
	Fri, 14 Mar 2025 13:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741957584; cv=none; b=MgbhYcVyEpO/4QbPNWCCMpZjgf93fC8wZI1N8d11KE4wv/0ujHIQvpZxLrxWgqgbEAiy10VT2lgKjnr0/iQX57hP2HHruWz3pRt0mHHL64WilBBSCWaakK6/hll04aWTA2PSlN3n9l7DRPMVoLSdxckAG+277qOlX5vhvqyphZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741957584; c=relaxed/simple;
	bh=pvKDOhhPmz+nkonLGF4cGCVxtZnaV+RBHXBkesdmSXU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uHN/1FZTtQ4DmQ4swtJr5O/GaspRICadnTIzFhYimH987CWQwwQKCdEQ3AlRK/L9v0Cm0ONNuprUPhv64AQHJs+NjgY8QEUZRkoeBC+XhiGkA5Uha46TSSVFegdrEAf+kCfETA+Jow4C8exmG8IxHcLnmc7cilG3KHHER8A0e+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ePnssBkq; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ePnssBkq"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3913fdd003bso1107743f8f.1;
        Fri, 14 Mar 2025 06:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741957579; x=1742562379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4SFpGYCDodlkPXivSr5gqPpw/Y4gMd19OkUZwBMUB8Y=;
        b=ePnssBkqoGeGqkHbWsGtr5JRHxO6WNwUbXTiC24G298H1qDhkOIBI5oZOtlTWd2Voj
         zl9mCsR/BKfX2uTOBoxiJGsMUbo34rs9COVNUw+HRBYW9S7eTvRA+i1Gs09Aiqf2qK84
         zU7dJdLE/RcdTep9ij7x5DEyu3hlV18BayX3dd0WwmJL4S+bBbnRu9GrsLWP96UI+ngE
         q9v3PJZcRD5mzW+rN0ELPFL2nWE6MwPaKQzEovrUxXOqTbWmdp3n9yl8pQw7roF6B97k
         asg8c7b5cXIAgVMASX0FqckTBt+QBrWRN5iFJJyb8Ygcb495StBmRBWtTJQos3jk9nvv
         U4AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741957579; x=1742562379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4SFpGYCDodlkPXivSr5gqPpw/Y4gMd19OkUZwBMUB8Y=;
        b=vO99RsejxhgbCL0IhEp4DpsErUqA5LjK2aQYPBHRTofLGw2KAAoUuwxr4CLtUQvCSL
         e9+S9BvMpzQcoO/9MqPvIy4aoMFN9bLlwOmhv3h5BH5Tibqd4lTRhC2ftALcWhQeAAU+
         k2IsVMwCnNm1KhVfcb4lr09aB1Tv25Y/5ptOxlS7PEoY9wdBy1l7MWj5LKnPL9EYGC9Y
         hSYQ0N13sjwfXQ9v+UiVyjxziqHvu/Tna8vFSwSF7sBr1R/MyH+FFluBn+P/XETkU2jO
         pa/0GsyfG8cA9xfkmULwniokMoj76O/mrSXUaJgkGHKgXx5xPWxttvvX4jOGFVdm6x3G
         JNTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVH2qYzC5qz/in2CaqiC8OkRjYkElpAFYXO+2AVcRjyn+TWJGnTwnDBJe25MQ9vLfKpyI4fZDQHOGkzPSbndMg=@vger.kernel.org, AJvYcCVaF4+CfMLRZPvhO39o/oodqlQyNzrW6jZJD3T3B5cZsrpgZP2JwhSopjoBY4rM+Ig4Cd14xvmH4zAznlT+@vger.kernel.org, AJvYcCWDyjqfy5ocL3D4NUIIaFPtVs1MUWCpM/6rdek3krY9TEz1v9hda78KuSs4uc+4l+cvkZX5zaNKHObFkA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxStquK4IZtsBA0pr+7TgpDrJj0kX2cizcq9aVMv3LOUTTu+8sQ
	S8YupaMahEgtU2giGyi07XZmjXvnO6dernoZagtgsA2plC+oGzAv
X-Gm-Gg: ASbGncuHx3ZONZ1PUVy4Igx959RTxsUtXRt8JJuVDuL8GFaxKUSO1G+rionyQWIISLM
	1Vmt78iN68JD2qxrqLo64JqLFnTXGvl+voDFYhB+O4f0E/xr0s9ggjy6pcPT0M9InLbfGPRsXX7
	hIJALPiMGKBggIyusrprBEC+3BIZxxgbRQfjTUuEfPS2f55JnHx7kyRa7OR5omh4YSq5zcH32tH
	S3Sql3TMJK43N+O9HCRDjCc4qnLCEhyZdUiI4HftzfJ+ylqdtE+kji9lyp5OB1EIR7EhFT3jeZW
	4Bq2ef7sC97xzyS6O0PO+dajMOaLFimAUBfUrMdWCGGej+wvcyObCMEb47DW31wpGz0oaD4MBE7
	0CB+V5Dg=
X-Google-Smtp-Source: AGHT+IFB9fJVxXR1+YasAAcJ2EjdchnXbaSLip2HmpU3n9g2YMrKc6gqwWkOEaCEXbcelPEursA9xQ==
X-Received: by 2002:a05:6000:1acd:b0:390:dec3:2780 with SMTP id ffacd0b85a97d-3971dae92ddmr3160856f8f.24.1741957579032;
        Fri, 14 Mar 2025 06:06:19 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c7df3506sm5720789f8f.11.2025.03.14.06.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 06:06:18 -0700 (PDT)
Date: Fri, 14 Mar 2025 13:06:14 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Kees Cook <kees@kernel.org>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] scsi: pm80xx: Use C String API for string
 comparisons
Message-ID: <20250314130614.729131f6@pumpkin>
In-Reply-To: <20250312200532.it.808-kees@kernel.org>
References: <20250312200532.it.808-kees@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Mar 2025 13:05:36 -0700
Kees Cook <kees@kernel.org> wrote:

> When a character array without a terminating NUL character has a static
> initializer, GCC 15's -Wunterminated-string-initialization will only
> warn if the array lacks the "nonstring" attribute[1]. There is no reason
> for the command lookup logic to not use strcmp(), so grow the string
> length and update the check to eliminate the warning:
> 
> ../drivers/scsi/pm8001/pm8001_ctl.c:652:7: warning: initializer-string for array of 'unsigned char' truncates NUL terminator but destination lacks 'nonstring' attribute (9 chars into 8 available) [-Wunterminated-string-initialization]
>   652 |      {"set_nvmd",    FLASH_CMD_SET_NVMD},
>       |       ^~~~~~~~~~
> 

Did you look at the code just before it?
It is horrid beyond belief.

The function parameters include 'buf' and 'count'.
There is no real indication buf[] is '\0' terminated, but it does:

	cmd_ptr = kcalloc(count, 2, GFP_KERNEL);
	if (!cmd_ptr) {
		pm8001_ha->fw_status = FAIL_OUT_MEMORY;
		return -ENOMEM;
	}

	filename_ptr = cmd_ptr + count;
	res = sscanf(buf, "%s %s", cmd_ptr, filename_ptr);

The search loop is then using cmd_ptr.
It only needs to find the separating ' ', no need to copy anything.


> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=117178 [1]
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> In taking another look at this, I realize that actually strcmp() should be used,
> so just grow the size of this character array and use strcmp().
>  v1: https://lore.kernel.org/lkml/20250310222553.work.437-kees@kernel.org/
>  v2: Use strcmp()
> ---
> Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 85ff95c6543a..bb8fd5f0f441 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -644,7 +644,7 @@ static DEVICE_ATTR(gsm_log, S_IRUGO, pm8001_ctl_gsm_log_show, NULL);
>  #define FLASH_CMD_SET_NVMD    0x02
>  
>  struct flash_command {
> -     u8      command[8];
> +     u8      command[9];
>       int     code;

'code' can only be 0/1/2 - so could be u8 to remove the padding.

>  };
>  
> @@ -825,8 +825,7 @@ static ssize_t pm8001_store_update_fw(struct device *cdev,
>  	}
>  
>  	for (i = 0; flash_command_table[i].code != FLASH_CMD_NONE; i++) {
> -		if (!memcmp(flash_command_table[i].command,
> -				 cmd_ptr, strlen(cmd_ptr))) {
> +		if (!strcmp(flash_command_table[i].command, cmd_ptr)) {
>  			flash_command = flash_command_table[i].code;

This looks like a API change since an unique initial portion used to
be enough. the strcmp() requires a full match.

	David

>  			break;
>  		}

