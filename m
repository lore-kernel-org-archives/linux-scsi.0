Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90A71DF742
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jan 2025 16:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737305977; cv=none; b=ERR5J4CZ1ZZNJ3hC7P9JA+tvqZDl5x1GxlqQRHIgaCPKpRgdc47q+lip4UDnlolTQpvdnO+R7aanE2dpnNC73gh7gpwnK9iLTNPsbDeAP2Sfl3IYpHOineEA1NGhLZXCpkKlnQ4fdabw8Qmy8xtn45O95JGoguyoipVbWvcWKPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737305977; c=relaxed/simple;
	bh=i8jlXieaT8KmwtG6JYMZ97nlaBgdfnq052Onnm3ehjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z0Ng/u5KgLukHvN8+Bi3G1kBMkQLIOH8VXWd/NwwGEQMXOkM8qzHjHTMxpAh1fMsyzL07EnGqCeDiyB8IyZObW+MKh0qgHO2sWia/qfOANf4EmZ+7tobvyHxPgFdExwNJ2XSK79PiYprmNlBT5YzYkEBtjb7InmnrHXsNshKm8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FUChneSB; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FUChneSB"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-386329da1d9so1931429f8f.1
        for <linux-scsi@vger.kernel.org>; Sun, 19 Jan 2025 08:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737305973; x=1737910773; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ryjgud0Cu35z0KcZwYmKJ/fOZn2jkkwEjHOVTa8VYFo=;
        b=FUChneSB8WMSrip1HVHKA0Q561mFMhPSUJA1Z0H6szMZvIUQifM3FatltyLCCl7v6N
         EP10NuSTsSqy2u8I81TlmCIOjVnNUkv1ixHJ3K8Uag42wakz+YDQPbIWbbOV8/YqYPR+
         on0jYC2oD52kJDkBIBieVl06KyCDIn5ld8F6VFf+WaNg39rkZeZv4Q7VHZeVXny7uuwG
         ucrKzLoJKbLePEL5cG0V/vXw40dHqB13c4n5e+Ckk25S7bukpCReW6QA6UCNNnM3feQ5
         lZ5xJhFTl9Bo7C5br7hJFpcOAGO6HhcuQZwrf2OMDQfEkPO+SUe7m509RT0IBJXz1/Hb
         8oqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737305973; x=1737910773;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ryjgud0Cu35z0KcZwYmKJ/fOZn2jkkwEjHOVTa8VYFo=;
        b=MTV+9rNPtk8VK04Xe+rtHeRusZdOinwUQRyK6TYCSb2ZXjbpP6s7QqDFxqOGES3OoK
         KMs+xWTVWU4YNpE9zYw6gLxo/iB24OtzOrKLRd9wGmnhyqL7lS38wUCWCU+D0ClTeB01
         H88I5d015gNoto7x57I2vPRtP0ZTOoeuQdyBWdkfHiV0K3xoVtX6X2XYQuq+1MMtwkzv
         MnTWINbzhj39m+l+lVLfN3esXY+dwOJJJxGlqRl64dIH2vIehVya6BJ/KpBPhbt7SQFa
         M4oDDXLcuu6ZgHVEuemVgIJEh/FqQkJA39bTUccQjVdA1uG49to0etAsNF5Cgd/3+K8l
         hlHA==
X-Forwarded-Encrypted: i=1; AJvYcCWXcT8Ad8y0gkIbQl9LdeL5HUqrDjr8f4Mbo0sUqazTfzhG4r5TFrhy9VBrL6z2ufIlDmI3WrnMlHnQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8Bo64zzz6uir5vlLP3mcY6vADqARtfP0DqHPc0cP0lTrblN36
	lnf2fWHF/VhpIuzgx8WmiIGvkkQwftlE7bz126WeQKtZgU9CRNmEuGh7fxfUW9U=
X-Gm-Gg: ASbGncumrndhlgcjGY/mb5dBm4d16BXLs05VnekiEMWQiaWibNYXD12EAk1PHl84MRp
	gqgeGW4/745odlRN2uEfGUhcbbgZYxUEyUk+varKlFCp5M8/cIxiaapugkKn2hjRqGs7UqfgdqY
	P3I8/544r5BGxcTyoq66PwnbcL3b9usF5vPWkHZRoiNFvxF6DAGZFyFK/9QJpytvlgR4QJNC2KK
	kCn3osXFi0eaT2NRgt/994BlzHJsQNPJlbsgayjHAPsB7DRDxIJRMxUjZm1ommDRQGh
X-Google-Smtp-Source: AGHT+IEHlfbUYzo6uXopuyotVKVif1ubxn0HrljJb34K7NGGjfxPHjuaD8j+8GTb1rrlbJmGX092oA==
X-Received: by 2002:a5d:4568:0:b0:385:decf:52bc with SMTP id ffacd0b85a97d-38bf5671bc4mr6755803f8f.32.1737305973017;
        Sun, 19 Jan 2025 08:59:33 -0800 (PST)
Received: from linaro.org ([86.123.96.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3214df8sm8077337f8f.4.2025.01.19.08.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2025 08:59:32 -0800 (PST)
Date: Sun, 19 Jan 2025 18:59:30 +0200
From: Abel Vesa <abel.vesa@linaro.org>
To: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Eric Biggers <ebiggers@google.com>, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-scsi@vger.kernel.org, andre.draszik@linaro.org,
	peter.griffin@linaro.org, willmcvicker@google.com,
	kernel-team@android.com, stable@vger.kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH v2 3/4] scsi: ufs: qcom: fix dev reference leaked through
 of_qcom_ice_get
Message-ID: <Z40vcpkMg50OWL/u@linaro.org>
References: <20250117-qcom-ice-fix-dev-leak-v2-0-1ffa5b6884cb@linaro.org>
 <20250117-qcom-ice-fix-dev-leak-v2-3-1ffa5b6884cb@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250117-qcom-ice-fix-dev-leak-v2-3-1ffa5b6884cb@linaro.org>

On 25-01-17 14:18:52, Tudor Ambarus wrote:
> The driver leaks the device reference taken with
> of_find_device_by_node(). Fix the leak by using devm_of_qcom_ice_get().
> 
> Fixes: 56541c7c4468 ("scsi: ufs: ufs-qcom: Switch to the new ICE API")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Abel Vesa <abel.vesa@linaro.org>

> ---
>  drivers/ufs/host/ufs-qcom.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 23b9f6efa047..a455a95f65fc 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -125,7 +125,7 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
>  	int err;
>  	int i;
>  
> -	ice = of_qcom_ice_get(dev);
> +	ice = devm_of_qcom_ice_get(dev);
>  	if (ice == ERR_PTR(-EOPNOTSUPP)) {
>  		dev_warn(dev, "Disabling inline encryption support\n");
>  		ice = NULL;
> 
> -- 
> 2.48.0.rc2.279.g1de40edade-goog
> 
