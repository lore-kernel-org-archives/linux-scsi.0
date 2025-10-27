Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFFC307ACA
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 14:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761574014; cv=none; b=oBJe0F5ZqDziwJvWl/oPoeqg8gBKU6j0tsP8XHihO6Xqe+1Vpdhg7sqJLVaCWZjkBuWMpM2iPRvcQc+xiil1s0MZZ+EpcG0yvXuEUynGr7sz3VXAamxrS/KO/DLgcTnhCAnaxvn2AEp7b9bpOS8608kaeOVsg0gnBaD9kxZjzAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761574014; c=relaxed/simple;
	bh=mGpnJ8Zatagid1o46VtMyYyzDftlYXwZZWFv5gy4pOM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TM0Hlv5CZPZbih1cZXKyuY5sHArDGgt4HHvbKrPb5xArz1+236TDy7paefhOMiq4TAPCNArI53k3t3DA7h/wJlX3E26zNO/Zn0WofYf4aSQthFZmyKfRILvtowHW56fO02AfoW89UnJ5XsTPNIZwELvv4XnsH7TfimxcY6q2vLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XZqC8vx9; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XZqC8vx9"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-3d3ed0c9f49so267799fac.3
        for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 07:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761574011; x=1762178811; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hcHFXH+EoA08X3H5hkxtTOckFH1gy0nI4Gd28dcR1d0=;
        b=XZqC8vx9usz9Og+C2Rbc/LRLAy5ZcPlS36U7hIcH6wPsTih/+VQabij369jNyLnDhZ
         18LBY75IstPmyR5306olVWydddPjDqgBm0gYK1/f2aSuR5zctKKVXODHASBsHnhFs8ec
         ZuURCjQsM70LLByvxZ3XjXyyfl3MV7TGDJR3wDOqz/CPhR5JVQPLvWeksMi76LOGGL/Z
         uOoPmwRHKH6jC9rsSORUnYVOPU9RP8thiY3CSbKmhwBxnjDehWa0Y7GBuHVlAc1A2PfW
         Fh8e0QmLAFNVz7rSixEl+uK79GZ/5krYc5ywooWkKQ6tzwSMez2rn0775w7YIfFc+k4j
         so6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761574011; x=1762178811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hcHFXH+EoA08X3H5hkxtTOckFH1gy0nI4Gd28dcR1d0=;
        b=OfFFkOpq3cBY7l6d/bOuMZXfQMfvu9BSzJYbD+7owchPYOgb0tYvWvjyl0uka6DRNo
         RZhodb1ts36G5gyh5mE3v1PHWs2+w85hA1cVTks8lVS9GmeEE989etGGd4jwc7qmtxp8
         I2ktSaB7RGE08VvY1NuDoQ41cVEUlrPt9EEUx+SJsC5q7fQlPG6TqJGLlzo2RSjupzHS
         PzwmVlUhjJ/F9zuHiXQ4fbBddfp45MUlVdzsgu9oJx7idoaC+3brpYpoJO7m3V4fd0xh
         jvdmRU/uexqUfWrRLNldo6hVqT7cCsv1DQN+0iV+7zBJJaVJHf/IwiGthtCFUoFiqyR5
         fG3w==
X-Forwarded-Encrypted: i=1; AJvYcCVk3pmsH8bjZw3FpoJKiWGdQmPiLzrV/KSGLtYUIHAARecRglqfvzcBqAJ0CS6t5YCTaCFzFEVdNhPu@vger.kernel.org
X-Gm-Message-State: AOJu0Ywm5ttZ/a8T31yXA6OCWGW+RqeauBUPIJlvOeC3yhFB5HV5h0qQ
	nZgoDXejSx53F546vFsSoIvF9iuwbXUh6GQosbnLDjwM8LPqzpKEbudk3JdpGnNdptYbexs8BUi
	MvJw3Jvl+ydVASlT/TxZhe1CXh51/BdfSRDF/9aXpsg==
X-Gm-Gg: ASbGncvg/njohtKCy227i+6vWkWkyONtN61qoTv2iKg3qpKYbN5dHUb+T+MXC4gcAtm
	J+WNHdHiEm0GKikUJ38FGgf0Iwm1n+ea+ZzZ2aSusNf6nReBlRlXMqHMlI85028lLlsstblApoK
	1niW+QgpRJKh4ItT9NQ9yOwiKDgn5AzWw1Yr2vlGatiJffHZ9u5IuKFgSKnulC/ad+hykpjK4zo
	wEI0FGpgUpeHpssHkTMurj+Jnxg5osDHychyD1dwFgHLMyDARwyDLfEAgI=
X-Google-Smtp-Source: AGHT+IGyrwZiHMK+6RM41C47H7rVurhrVEco1pO7jyYc7h2XpfECj2aLp7DXtWtyefG7vr8w57fJWfOso9mUAJM3434=
X-Received: by 2002:a05:6870:b28e:b0:3d3:4338:bbab with SMTP id
 586e51a60fabf-3d3433949e0mr2423049fac.18.1761574010664; Mon, 27 Oct 2025
 07:06:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251026212506.4136610-1-beanhuo@iokpp.de> <20251026212506.4136610-4-beanhuo@iokpp.de>
In-Reply-To: <20251026212506.4136610-4-beanhuo@iokpp.de>
From: Jens Wiklander <jens.wiklander@linaro.org>
Date: Mon, 27 Oct 2025 15:06:38 +0100
X-Gm-Features: AWmQ_bkzmT9YDus5mt0XJ8Oo1d8CuevUOpAXH8Tvi7Nykv4F68B6B_E-6JBqk6U
Message-ID: <CAHUa44ELC59zbQ2xx-NN8bTWACXoZHwD9sviHdTe0ruqYuS6Pg@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver for
 UFS devices
To: Bean Huo <beanhuo@iokpp.de>
Cc: avri.altman@wdc.com, avri.altman@sandisk.com, bvanassche@acm.org, 
	alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com, 
	can.guo@oss.qualcomm.com, ulf.hansson@linaro.org, beanhuo@micron.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 26, 2025 at 10:25=E2=80=AFPM Bean Huo <beanhuo@iokpp.de> wrote:
>
> From: Bean Huo <beanhuo@micron.com>
>
> This patch adds OP-TEE based RPMB support for UFS devices. This enables s=
ecure
> RPMB operations on UFS devices through OP-TEE, providing the same functio=
nality
> available for eMMC devices and extending kernel-based secure storage supp=
ort to
> UFS-based systems.
>
> Benefits of OP-TEE based RPMB implementation:
> - Eliminates dependency on userspace supplicant for RPMB access
> - Enables early boot secure storage access (e.g., fTPM, secure UEFI varia=
bles)
> - Provides kernel-level RPMB access as soon as UFS driver is initialized
> - Removes complex initramfs dependencies and boot ordering requirements
> - Ensures reliable and deterministic secure storage operations
> - Supports both built-in and modular fTPM configurations
>
> Co-developed-by: Can Guo <can.guo@oss.qualcomm.com>
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
> Reviewed-by: Avri Altman <avri.altman@sandisk.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/misc/Kconfig           |   2 +-
>  drivers/ufs/core/Makefile      |   1 +
>  drivers/ufs/core/ufs-rpmb.c    | 254 +++++++++++++++++++++++++++++++++
>  drivers/ufs/core/ufshcd-priv.h |  13 ++
>  drivers/ufs/core/ufshcd.c      |  86 ++++++++++-
>  include/ufs/ufs.h              |   5 +
>  include/ufs/ufshcd.h           |   8 +-
>  7 files changed, 362 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/ufs/core/ufs-rpmb.c

Looks good.

Reviewed-by: Jens Wiklander <jens.wiklander@linaro.org>

Cheers,
Jens
