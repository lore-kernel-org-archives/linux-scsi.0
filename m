Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52F7306D3F
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 09:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780391979; cv=none; b=URUExojKYY6hG+NDhuFrhL0QjwRNuyFhaTSaA+4WCeJ1sk3sCKNR9Z4e0XCYHn/aJZAJdhsKfAKVlJFeLzSUYNxMP+AngqFFysEvHZ0FvezNiHCiBcWkHiE9e+7+S2uT7bjIqZj/sfT90aUg/ezT40JT+R1jGJuYLFH8/EcS/38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780391979; c=relaxed/simple;
	bh=d03mYFvoxL3+WQaLZXioFHnsTsH0x9U2TJg6HAckIas=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lOg7oJxUu8Lb+fF9XWa7r1IKHn/fdq7ytzyJoGR2K6Q72vRFNLlj8Wo6kAemSpAbgPHKKzLuG6KzKRZ9h9Dp8AKakiuySe+ZxAEyGSf6IxnHlFin8CcZaTBj2oIemCpaWrMf86omQIwdZgCjvFwjev6dBCjIZdNdx9ykDAkasb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mIcvbB5J; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mIcvbB5J"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-45ee6d32402so2737438f8f.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 Jun 2026 02:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780391976; x=1780996776; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d3TkRk0TsArI0r3PB/TbMDepMy+Yfhi44vkADQg5LtQ=;
        b=mIcvbB5J9gDR6uvQCVCsxOdj8vJUJsJxkjOqmZROk5ZLpdV51Fr75aNXOUAFyC2Rux
         /vyOXPPAW67uXQ7DlsnyQfsSo0ApN71qeJNM4v494nzi4mH1pfBiPOTX56PdcZ1LZADJ
         dSUMcc716QBVgSl9uCnfc7KrQY5ECALopkxqIKnxLSvb2FHX3kOirbkTBZce6M06vfhY
         KU9qz/gdYVLuj/DPO07elVzZcp1f2wAbdyg33APOVWnuLsHQ9gpWWGe/NnarRTsj6BG3
         IJ7Bg6JUwJ3lv6GvQz7sRfwkGF37RGkaOdsif9X3/u9mB5Li2btL2o0X/jdwPTJVInJT
         4Rgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780391976; x=1780996776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d3TkRk0TsArI0r3PB/TbMDepMy+Yfhi44vkADQg5LtQ=;
        b=sAdY5jiOQdvvf1UkG0uvHkgrfe2Ulq2EDrkaktK5MqbvJDmtI9TkamzeRwT94L2uWi
         LRomYwQPeZnS8YKWqT3lFzEhRmolIt4Latyy1AdFJ5B4S0gkXkhfbu1faUcr+XRGvNRk
         GeblRYwjg2a2DjB48sEB6LVehce2EsSxBOPdSjgMi2Ax4LZSwneSeUgS1+8WbONBSaWR
         5kZQJJ+4wtjUXxwcFzr8DR+aW92jkTVLXBIBmeOVlX0gdQafkrzjZP0kZ+p7ud1ZTBAv
         QlP21pwxYgTLeXGy/BNtBWgPza2nHe61AqG40s8bh2Dvz4Ydd1xthBhIRiOy1SwRS8R5
         nK4A==
X-Forwarded-Encrypted: i=1; AFNElJ/wyFcThwztFAtXdMmsD9KOpptaf5f0hSgMoA0Ffk8u+ML/z3aVmciD8f0fF2wp2RHR0JPFeK5g4OAd@vger.kernel.org
X-Gm-Message-State: AOJu0YwhBVcHvEoWYoQ7fOrNyQgrRxnu2wprhnR4MWyza/seR+9j/9ol
	FYdywyLdeykF96Yo9Xy/lO2TbnsOxhcsqmKaIHhJgK1ztU3cpjoNw80vbe5kR5ut
X-Gm-Gg: Acq92OHrVbzdBzB7wwhtr0B5163/RhBEq75DugKKzFxfVpDWF2V/GfWbsA/jOPEy5Yv
	fOVUyNCFf9hTcfs9jUfIOE2YAXd8+UMF5sTvYmQkrp3+2ejUpD+CuLQ9A5p08OiyeXsMXasUbwY
	ejJdW6AkiD4wJcUQnICeO8LXs1QynFcB1T+AKjF1Kth+qi96aFxQrrNXTZvypMJBYI0Hue2vE38
	XENzx3921re+sDw/0yN/eXGNgveqzkOPSUheiLH3dFMzZus6HhXgxYz+k88UjFr18KmHHwinqM4
	evT6t2KYMeXeuefW9MeAekqOp3zr0Qez2G9gMugY9fCcGrb8aFlqcn8t5oz3krbhSKbXp47amA9
	44oox4klfaiV0yk4HJ/afXAaO8+DuYLUGsgiGd6d9Akp51LpdBBbiBYsflejl5aiPHKGM3IKlZk
	rCyaNArhyqBg7jpV0Keay8cTLo/c1eDrNIvPBkbA87CQuCiCOiEDJiVkblPfBonmU9+NR6mi8=
X-Received: by 2002:a05:6000:2b0b:b0:452:8286:86bf with SMTP id ffacd0b85a97d-45ef6b02006mr19559422f8f.1.1780391975934;
        Tue, 02 Jun 2026 02:19:35 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef34bd896sm30592063f8f.14.2026.06.02.02.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 02:19:35 -0700 (PDT)
Date: Tue, 2 Jun 2026 10:19:34 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin
 K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] scsi: scsi_ioctl: use strnlen in
 scsi_ioctl_get_pci
Message-ID: <20260602101934.57687164@pumpkin>
In-Reply-To: <20260517171546.2304-2-thorsten.blum@linux.dev>
References: <20260517171546.2304-2-thorsten.blum@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 17 May 2026 19:15:47 +0200
Thorsten Blum <thorsten.blum@linux.dev> wrote:

> Use strnlen() to limit string scanning to 20 characters.

Should that code write the trailing '\0'?
Looks like it has been broken since 2.6.29.
Prior to that it always wrote 20 bytes (changing from 8 bytes in 2.5.0)

I think it needs:
	char buf[20];
	int len = strscpy(buf, name);
	if (copy_to_user(arg, buf, len < 0 ? sizeof (buf) : len + 1))
		return -EFAULT;

-- David


> 
> Reformat the code and use tabs instead of spaces while at it.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/scsi/scsi_ioctl.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
> index 0ddc95bafc71..d98c2f19b1e9 100644
> --- a/drivers/scsi/scsi_ioctl.c
> +++ b/drivers/scsi/scsi_ioctl.c
> @@ -176,10 +176,11 @@ static int scsi_ioctl_get_pci(struct scsi_device *sdev, void __user *arg)
>  
>  	name = dev_name(dev);
>  
> -	/* compatibility with old ioctl which only returned
> -	 * 20 characters */
> -        return copy_to_user(arg, name, min(strlen(name), (size_t)20))
> -		? -EFAULT: 0;
> +	/* compatibility with old ioctl which only returned 20 characters */
> +	if (copy_to_user(arg, name, strnlen(name, 20)))
> +		return -EFAULT;
> +
> +	return 0;
>  }
>  
>  static int sg_get_version(int __user *p)
> 

