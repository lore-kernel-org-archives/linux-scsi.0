Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B343F2036E4;
	Thu, 13 Feb 2025 19:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739474100; cv=none; b=SXe9VthBv2G3IgPkNAzrK60ff3cfgfIsr/yCSvXzp77cb0DI9HHU/p/hxoY0/og80V1o3vukZNPqQGXNCkdMlG63Hti7hYj2Cu7Z9wxx7RGcPwfBF6y0we7WlrYaZ1lEmaF/04hjrWDvBMOeE2nLISSo/XNdH8JZLt15BYjvLtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739474100; c=relaxed/simple;
	bh=BfauIy3o5axRmOkb37mEeCeeVJpE9AHdl2OZQUI3YvY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ckR59cM4MNs6YDxbKFhBmT+bdhEn+ydmpgljVzfb4e5QbmxseEyLzLN1jwk40vVA2XUZBin0hQ9cZVuaTkRC77shfikYAG85A3XWjeuiO5+YttXXwWDrDwZrhCSJUgSIUAZMS5sa9YNqanYbRMHlmr51clmksO8XlStsaRRTai4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FUqS865W; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FUqS865W"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4395a06cf43so8525275e9.2;
        Thu, 13 Feb 2025 11:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739474097; x=1740078897; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9oYvb+adUifUAMjBHuPFQ7cS+nNgPWz10uBj3ervq5c=;
        b=FUqS865W5V9msf4sIlivRS9z5UZ5vjqAjLI8qJnVKHT8CYlDBB+Zzcd0YWXpYCJX/0
         eWkIYSJha5iS4yk1BiNktWrZHfsqlLYYCQhJwOLY8yQm7c/IIHEo7Ug49ANJ/eGyVUtF
         4Vv9NslUc+xpcXhev7kwSw4K9S1KO9q9qKn2WBpUqNUNdOFrClQ9RfMtfl9uc8+ILrzj
         cfirLy1XfE6ypovEo+zfUYo/FomYbRWnO3WF7RUwJoc0VRt/V/7KXreFNf7cH7jXXinv
         3J8i8VNRPtPP402Jp85tr/byzt7KrsoNWyZt1Cm50T9vqDQCuNbzBzWAya5w8a8eyVts
         Qxmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739474097; x=1740078897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9oYvb+adUifUAMjBHuPFQ7cS+nNgPWz10uBj3ervq5c=;
        b=eaA9F4lXfbxYyRt/4/jy/1GdRkHcLZencNJlmqMr41vfvk+h8yRFhNC+AgYBfY0cKE
         DFkLhTSmUMrl4L72W/km82iMh0IahT2cTOF7rARNBEEuAqPTMekrYuAeTtnoIooM9+Xt
         is+FZtrTQudoEAUgTruaZbsRedHym5Fq+BGPvGFPuRefRC4pGDVgfoGu4ETbQhzHWCF2
         C7I8mlzc7WgqA5yV17N5t09VOwpgAYWyL4m5e82HrjkH4LtsZie6N2rzZH1gDqCXcKpX
         8tQ9k0TQ+bajTZJprYAMK586Bz+CPS9vTabDa3AL27uzsn0tF/NkfC/Z9lNZPvGIkNs0
         Tt5Q==
X-Forwarded-Encrypted: i=1; AJvYcCV62W4DrcPUIfWE7BuW2bIX/4stvfOqHwmWbzmehub3PE0LXYb9mChV2VPBmu4eaTQS6CMCl/57EztVVQ==@vger.kernel.org, AJvYcCVNHqYHWXNM/fCGyJXlrvW1OaXzNa8i/rov2hRl/gOTeiDTGb3I9o3Fe1Wf7PETaMgKbZ3b1Q36NulR4z/nkO4=@vger.kernel.org, AJvYcCVrpZzjSX5Tz822lvwpzBwxo7amqJLpVFrBVdk4hbzPCyDxD01EuRwcLVi4NysdXjSlUKBBoTvXkKhASlmm@vger.kernel.org
X-Gm-Message-State: AOJu0YxZQXuNKoQQWoRdeviro6fAyjqOuwriAJ2q9M+T4lPA3HvuOIjY
	Q0Z5cgXxclMl+Wvt1rfhlid8QbNSgH6E5GiUtjmYcw14k4odhD2b25BvUw==
X-Gm-Gg: ASbGncug3OdPp69sHyQFayVETx3myI3AoyqRPLkQQwCWnqspQUuU5LjEPj4bX4mkmn/
	unWdyhLqHYL1Qkp9osPonZRe86goxl40+lfAe1LdlqhyOX0JUk9RSgEvAmqmr2eI2O0UG2T1D7D
	gt/dd8pY4JFmtAzuMy5LuY4WNzS6VvJov8xJpfHGvMwiCtYaYj6kgDVMLPEdjW+s4mG9nE/oqPD
	AKNX/th0nNTcs8eEtpyg0yhfgY8MJ1G3us0q4k8KLW7GOc+ZjWS7kzE1yJzMu1SGGDqObMT8g2D
	NvloFc5VyabG0D5J4X7zf+vVEzHZCwF44huasyR37GiVuiyK9Artcg==
X-Google-Smtp-Source: AGHT+IGH8lan2Mm3Q8LexytfZbgTjy4KJ17B9w24CGdj1DNizxaautJh0QZgULgHj/3/HPmmZNOnNg==
X-Received: by 2002:a05:600c:46cc:b0:439:31e0:d9a2 with SMTP id 5b1f17b1804b1-43960169738mr55585585e9.3.1739474096674;
        Thu, 13 Feb 2025 11:14:56 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259f771dsm2574678f8f.81.2025.02.13.11.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 11:14:56 -0800 (PST)
Date: Thu, 13 Feb 2025 19:14:55 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Don Brace <don.brace@microchip.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, linux-hardening@vger.kernel.org,
 storagedev@microchip.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: hpsa: Replace deprecated strncpy() with
 strscpy_pad()
Message-ID: <20250213191455.2249104e@pumpkin>
In-Reply-To: <20250212224352.86583-3-thorsten.blum@linux.dev>
References: <20250212224352.86583-3-thorsten.blum@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Feb 2025 23:43:53 +0100
Thorsten Blum <thorsten.blum@linux.dev> wrote:

> strncpy() is deprecated for NUL-terminated destination buffers [1].
> 
> Replace memset() and strncpy() with strscpy_pad() to copy the version
> string and fill the remaining bytes in the destination buffer with NUL
> bytes. This avoids zeroing the memory before copying the string.
> 
> Compile-tested only.
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/scsi/hpsa.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 84d8de07b7ae..1334886b68d0 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -7238,8 +7238,7 @@ static int hpsa_controller_hard_reset(struct pci_dev *pdev,
>  
>  static void init_driver_version(char *driver_version, int len)
>  {
> -	memset(driver_version, 0, len);
> -	strncpy(driver_version, HPSA " " HPSA_DRIVER_VERSION, len - 1);
> +	strscpy_pad(driver_version, HPSA " " HPSA_DRIVER_VERSION, len - 1);

Wrong.
That will truncate maximum length strings.

	David

>  }
>  
>  static int write_driver_ver_to_cfgtable(struct CfgTable __iomem *cfgtable)

