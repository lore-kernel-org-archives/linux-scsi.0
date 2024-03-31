Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB04144311
	for <linux-scsi@vger.kernel.org>; Sun, 31 Mar 2024 11:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711884043; cv=none; b=Td0K0Dc/AxPxcBBdsLpPXs5HGNhaURwqiaVXk6bHq721pJ1ixTh7Z4aYDvfUWcu1fIzveS0opSGUJZ/k44TPsqD0xp0oLoHgs/mMfr57+j7lRjcyioWN2NgUAccONttmjlkEKI9K8I6r/J1Io1MvG56PkNu7/iRKhqNJtOu4uQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711884043; c=relaxed/simple;
	bh=HA92dRzVt3vZdgr5pQJY02em2UTWtsR+GLFyMiGbHw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m1tBTK3Lp+mpwrC8OOTmBGpOqYaaLZDufWoBamCm4oesnba6zWPc8z3Ti5ZywYCr3EeYXp8nMnHFVj6Qx4t0+McvJJCZu6fPQmL62bcbOLzlHuSTMHrjl2AiRIzPWDlbl2ygcNJW0ME2nkcQAt7zIYPipG90yF0RpAExJqOLbzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O9hNEPm9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O9hNEPm9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711884040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZAFJ+0SeTqdsqNS6GC0N4AccV7yeFgGXHpRB2cwbNo4=;
	b=O9hNEPm9d0O69v2SYtEVIAv/U2/DkfMVnqoT3sS3hw97Pwv3xLSYQMy3hz8OAtCRArUzk4
	POezS0OrrZtR9aqD1bN9s6JF162Hg0s7ZbHhe3NUriXHopxotUal9HkHvj149BMkZNsWX8
	dTvicyJ42irvCew2m05QMhtYhYfYtqI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-Q8myaGoBOaCNgaBntFQPYQ-1; Sun, 31 Mar 2024 07:20:35 -0400
X-MC-Unique: Q8myaGoBOaCNgaBntFQPYQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-41485831b2dso21073335e9.3
        for <linux-scsi@vger.kernel.org>; Sun, 31 Mar 2024 04:20:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711884034; x=1712488834;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZAFJ+0SeTqdsqNS6GC0N4AccV7yeFgGXHpRB2cwbNo4=;
        b=bA8lSZEvv+8QsD1nYP4p/q0UfrxJOgj9Kh5NfVxztqnlENz0fnNcTilcceZZySSnsn
         UVj9RtlE7VEWB82hwNIAi4YfSISnzS2Mz4fSWbrenHfueCi1eRR+qAV9/muuD0eQOHzA
         OaGiLjLnzNLsJYN43paXpTD30ej9wOirqO9aG4ojad5uh0nATZWLlAW2Y4Sx+8ZUWVNR
         17JlTTv1tOQr5lhJjyC7YmkYICjU1NNZuhj1atSsMBwIWVbiSVAucsw1QR48rC6FkQCA
         3FEO3KgeYRrIO1uY5gm/K/nCHCEvTMbZcIY2IP9bonMJUIL9ZjM7nHT5JEAruuzKBW9x
         M+rQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/UDhe3wWgc2A+8Z8Y2gDwMvNHm4TjSaAC8DD76b29Jmq1a3kHQ20YoDBiFtMLtJeC8DTEtasu1qzIO3fnBMsBCJ7TG+MuYcnHNw==
X-Gm-Message-State: AOJu0Yz+1gOOnkjdAMhR4+Q8f2HExoFrW1NRA7oFMM7qgQ8ZNAKAzoXs
	Bb2ERu1fg0PD980Q9FpteBG8h8gLy8u2dofo62C2IgIYk7wOgsj1H4BikcJLqQsYhptnv1wxFAf
	C3BdAaUNsHtTryM6x0lKOFVaqqRT419ELjnayyf7rMPbGYJ85LEaGJTpTsgU=
X-Received: by 2002:a05:600c:220f:b0:413:e19:337f with SMTP id z15-20020a05600c220f00b004130e19337fmr6115870wml.22.1711884034573;
        Sun, 31 Mar 2024 04:20:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhoN6xvj4jps7JZJhPCGbovoaf04BQIV4BBUP7925nSfWx1HPIV5PQzN7Ku2MIo02ql2sOQw==
X-Received: by 2002:a05:600c:220f:b0:413:e19:337f with SMTP id z15-20020a05600c220f00b004130e19337fmr6115845wml.22.1711884033951;
        Sun, 31 Mar 2024 04:20:33 -0700 (PDT)
Received: from redhat.com ([2a02:14f:173:c52c:ce6f:ec9c:ca7c:7200])
        by smtp.gmail.com with ESMTPSA id u22-20020a05600c139600b004148d7b889asm14465567wmf.8.2024.03.31.04.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 04:20:33 -0700 (PDT)
Date: Sun, 31 Mar 2024 07:20:24 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: virtualization@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-um@lists.infradead.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev, netdev@vger.kernel.org, v9fs@lists.linux.dev,
	kvm@vger.kernel.org, linux-wireless@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-remoteproc@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-sound@vger.kernel.org
Subject: Re: [PATCH 01/22] virtio: store owner from modules with
 register_virtio_driver()
Message-ID: <20240331071546-mutt-send-email-mst@kernel.org>
References: <20240327-module-owner-virtio-v1-0-0feffab77d99@linaro.org>
 <20240327-module-owner-virtio-v1-1-0feffab77d99@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327-module-owner-virtio-v1-1-0feffab77d99@linaro.org>

On Wed, Mar 27, 2024 at 01:40:54PM +0100, Krzysztof Kozlowski wrote:
> Modules registering driver with register_virtio_driver() might forget to
> set .owner field.  i2c-virtio.c for example has it missing.  The field
> is used by some of other kernel parts for reference counting
> (try_module_get()), so it is expected that drivers will set it.
> 
> Solve the problem by moving this task away from the drivers to the core
> amba bus code, just like we did for platform_driver in
> commit 9447057eaff8 ("platform_device: use a macro instead of
> platform_driver_register").
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>



This makes sense. So this will be:

Fixes: 3cfc88380413 ("i2c: virtio: add a virtio i2c frontend driver")
Cc: "Jie Deng" <jie.deng@intel.com>

and I think I will pick this patch for this cycle to fix
the bug. The cleanups can go in the next cycle.


> ---
>  Documentation/driver-api/virtio/writing_virtio_drivers.rst | 1 -
>  drivers/virtio/virtio.c                                    | 6 ++++--
>  include/linux/virtio.h                                     | 7 +++++--
>  3 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/driver-api/virtio/writing_virtio_drivers.rst b/Documentation/driver-api/virtio/writing_virtio_drivers.rst
> index e14c58796d25..e5de6f5d061a 100644
> --- a/Documentation/driver-api/virtio/writing_virtio_drivers.rst
> +++ b/Documentation/driver-api/virtio/writing_virtio_drivers.rst
> @@ -97,7 +97,6 @@ like this::
>  
>  	static struct virtio_driver virtio_dummy_driver = {
>  		.driver.name =  KBUILD_MODNAME,
> -		.driver.owner = THIS_MODULE,
>  		.id_table =     id_table,
>  		.probe =        virtio_dummy_probe,
>  		.remove =       virtio_dummy_remove,
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index f173587893cb..9510c551dce8 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -362,14 +362,16 @@ static const struct bus_type virtio_bus = {
>  	.remove = virtio_dev_remove,
>  };
>  
> -int register_virtio_driver(struct virtio_driver *driver)
> +int __register_virtio_driver(struct virtio_driver *driver, struct module *owner)
>  {
>  	/* Catch this early. */
>  	BUG_ON(driver->feature_table_size && !driver->feature_table);
>  	driver->driver.bus = &virtio_bus;
> +	driver->driver.owner = owner;
> +
>  	return driver_register(&driver->driver);
>  }
> -EXPORT_SYMBOL_GPL(register_virtio_driver);
> +EXPORT_SYMBOL_GPL(__register_virtio_driver);
>  
>  void unregister_virtio_driver(struct virtio_driver *driver)
>  {
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index b0201747a263..26c4325aa373 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -170,7 +170,7 @@ size_t virtio_max_dma_size(const struct virtio_device *vdev);
>  
>  /**
>   * struct virtio_driver - operations for a virtio I/O driver
> - * @driver: underlying device driver (populate name and owner).
> + * @driver: underlying device driver (populate name).
>   * @id_table: the ids serviced by this driver.
>   * @feature_table: an array of feature numbers supported by this driver.
>   * @feature_table_size: number of entries in the feature table array.
> @@ -208,7 +208,10 @@ static inline struct virtio_driver *drv_to_virtio(struct device_driver *drv)
>  	return container_of(drv, struct virtio_driver, driver);
>  }
>  
> -int register_virtio_driver(struct virtio_driver *drv);
> +/* use a macro to avoid include chaining to get THIS_MODULE */
> +#define register_virtio_driver(drv) \
> +	__register_virtio_driver(drv, THIS_MODULE)
> +int __register_virtio_driver(struct virtio_driver *drv, struct module *owner);
>  void unregister_virtio_driver(struct virtio_driver *drv);
>  
>  /* module_virtio_driver() - Helper macro for drivers that don't do
> 
> -- 
> 2.34.1

