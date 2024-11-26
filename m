Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93608EBE
	for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2024 04:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732596734; cv=none; b=loCZb5hb4Vg/kiN3nUn6g9vVjhsZwrsEZdCnAlSvZjZnhYd8AsQwJ9J8qKuLVDrMSkCGUEAboD2ehJgufgTopuellBso/EgssKVLLopYbIKzL7Z3jAPW9H/XSLq9n74Z+csDsNvdzd45MosFvNyNiVyeFX1tc/dC83rNfwgY7U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732596734; c=relaxed/simple;
	bh=UMaGgDkF1T2aYUdiWAaQKUuv145YTS1tpH7aMLKiQmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=enzm5E6OROWCQxkOT5TrgxyTLypuWItTMbvWhIAeg1XXH9NEVsmXJwVj9X3LGQCWk/ISw5j+43ZH1/3UPfyENCW2I2ddblsXEtUNSJ+AEwqvtuRZHk8b5nQ9EYbzVgeI5J1wszhnPBLzuETR58UQQmKP7DnNt8V+EyiV0v+CqGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=H01l5V74; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H01l5V74"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7ae3d7222d4so4285370a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2024 20:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732596732; x=1733201532; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Rem8LGZXdVnZ/PI5gsaQii+kftUkAG4f3mUtkM8OBis=;
        b=H01l5V742yTAVdomk5Oc2AXbgCIGX8hmkHGgtDtxdFR3qig/sVzN8Dye5uD9TGoCt6
         xsWI6DGv5o6vgr6HsZjLS3X5MxTj5OB1VPL3taGiYoa2XY0HLu7UNbzH/bxHlRTb57M4
         8Qj0ee6yX8WmH/tDcbov0Bnp7PwHpIBnNUIDkd9aKOK7R0ECC0QNboRJSHXlyQdU1twH
         VOM2EYD+0AV1dckpnpTubuI21OrL1cO6K3jLhAjzO7hzvFD4ZBXYM8sCIZhQz1DqrJgv
         I6bf9GUkfxEaDcyUHMlEmeMP+tQXFgS6K29tOh0z5hDWd1Hn3hEPgOVgrwZ+SXYwlGAm
         C1IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732596732; x=1733201532;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rem8LGZXdVnZ/PI5gsaQii+kftUkAG4f3mUtkM8OBis=;
        b=rx2REiS5jZhqbMYdhFhUqE9j/lGZdR0Scx6w9QbUIpGspoqDHwSfJxD0lZLFs2pBZS
         SBCO3Ziu22iYfgSqQeOQsKX89k+7dBFS1Z+rgarkEtznQjvK27XejKUAzhJquKPsaYIC
         8Qwoc6o2ktzw1BSopMJWsQIs7NiYv0LOZYy/VSbyPy1eTQ/JZx8ZBZdaDyxdYJ3CVcgn
         jKIb7HYrq/FgqCT65dconnwl6NlUSB4R4F+aMV95PSru07gv3LBruMRtb4Rajog49HiO
         TqJ4/HU8l5hBuzyosbGo4PObbLvru5VlKZglJys7myWXHy+k6nJnOkBhU9XkhjW064oS
         03uw==
X-Forwarded-Encrypted: i=1; AJvYcCWUFZMhZTAXRi3eeivVivqKMq8/oSnu2pIUW5Km+8kfyTRrNwO6qx2acJ4Yy/P9HtDNOH/RxzepckUp@vger.kernel.org
X-Gm-Message-State: AOJu0YwrgvGa6LA2ZMqbjaOZ8ovVrKsUTaQ6Huoyc9erStkDlHU2bH8n
	MWMZmD+h45itzUUPUT3cjA64N83/7H15AR2Qi8O87G5o8jMDLxQJZ6eNo6iQ6A==
X-Gm-Gg: ASbGncvlypPURTsS2TXAA7ya2pJNb2CN/fNv89oJU0bhQKZCPmgFQfd15aYSW/QgHAP
	vHgIAlwXOO3PzOdLbYRKduzwR2gPjCCc3TnucE/gcIBwssfYv3YEdFCiJJiiqOBZPjV/3lBWfmX
	KEsmrqHEzg9DCx8lB21TPZOmn1oedXdROC4kAyLgrxnFN11suW6Ljm0rZKNa7F0ct1LvA5X3dRC
	pcvGy6XZz9lkqHdrOn01mxF0EC9LlMWGmMQKmM7CNr3PjeoYxLnzb8L1mUkajA=
X-Google-Smtp-Source: AGHT+IFLS2CiMe6uFsk3VjOrgamDEQHKYFhaEEUWVyLY/IZqdSO4oF/zkuEQngAEkYwNRZrt7cVwfA==
X-Received: by 2002:a05:6a21:3389:b0:1db:dfe4:daa4 with SMTP id adf61e73a8af0-1e09e40644fmr23624442637.9.1732596731951;
        Mon, 25 Nov 2024 20:52:11 -0800 (PST)
Received: from thinkpad ([220.158.156.172])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2129dc2c5fcsm72746705ad.280.2024.11.25.20.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 20:52:11 -0800 (PST)
Date: Tue, 26 Nov 2024 10:22:06 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Vamshi Gajjela <vamshigajjela@google.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: core: Fix link_startup_again on success
Message-ID: <20241126045206.v64iypeiyt22lcei@thinkpad>
References: <20241125125338.905146-1-vamshigajjela@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241125125338.905146-1-vamshigajjela@google.com>

On Mon, Nov 25, 2024 at 06:23:37PM +0530, Vamshi Gajjela wrote:
> Set link_startup_again to false after a successful
> ufshcd_dme_link_startup operation and confirmation of device presence.
> Prevents unnecessary link startup attempts when the previous operation
> has succeeded.
> 
> Signed-off-by: Vamshi Gajjela <vamshigajjela@google.com>
> Fixes: 7caf489b99a4 ("scsi: ufs: issue link starup 2 times if device isn't active")
> Cc: stable@vger.kernel.org
> ---
>  drivers/ufs/core/ufshcd.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index abbe7135a977..cc1d15002ab5 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4994,6 +4994,10 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
>  			goto out;
>  		}
>  
> +		/* link_startup success and device is present */
> +		if (!ret && ufshcd_is_device_present(hba))
> +			link_startup_again = false;
> +

Using 'link_startup_again' flag looks messy. Can't we just check the device
state after first link startup and if it is still not active, then try link
startup one more time? (Assuming that the device state won't be active after
first link startup).

Also, we should move the link startup and its associated check to a helper
function and call them instead of (ab)using the goto label.

Like,

	ret = __ufshcd_link_startup()
	if (ret)
		goto fail

	/* try link startup one more time if the device is not active */
	if (!ufshcd_is_ufs_dev_active()) {
		ret = __ufshcd_link_startup()
		if (ret)
			goto fail
	}

- Mani

>  		/*
>  		 * DME link lost indication is only received when link is up,
>  		 * but we can't be sure if the link is up until link startup
> -- 
> 2.47.0.371.ga323438b13-goog
> 

-- 
மணிவண்ணன் சதாசிவம்
