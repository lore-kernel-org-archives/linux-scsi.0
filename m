Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9AB13C9AF
	for <linux-scsi@vger.kernel.org>; Sun, 31 Mar 2024 08:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711874728; cv=none; b=eBq5QUf+J0zAImED7XsnB0JhMvrsez1LO1FaVNs+1fls43ImEFtqLVoCeYQk8W0MkZsUwvvS6yUEdTLi415DSQtVNdZhWiEs3l7ImX7ItIZjLzBxhdAtBlhm+wcw7d8ugsQwWl3Wmh3CSNhNFkZVhgtZTkXIrWLF5n1CSvPFxYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711874728; c=relaxed/simple;
	bh=7ATpdlO8BYGbOLrnCMWqDxc1uHoHJQazrkrXVJkp5JU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ho5QWpDVdp57/wj8S0hyPqAbVscWZeIzwMg6fLNpFKxTbKz27AHTprZhX0KkItCMfQilXZ/WR5t3xSE+96rHU86QeGdaKsmHtgxsNy58Soffxt/ZT2rrTAzH+AXGxBjCr0cV2Vv9SvRpoyeszH5/g1WzF5gDpoE5lOzaJpWOyOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hX+RQBDM; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hX+RQBDM"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-341cce3e5f0so2901714f8f.1
        for <linux-scsi@vger.kernel.org>; Sun, 31 Mar 2024 01:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711874723; x=1712479523; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CZFUNXXbpZmBD2n9gbGYcEp/TwGJ3Hv0RpgMtmxvpLM=;
        b=hX+RQBDM2Lr6ZR8MdNP3Qqzo6EN22R7yhEdgZhU66gobbIY4x+fOhWS1Y0fNEDUrvu
         ZGtNc4yqZp5066iObsqcyA38h9M3lUhxx8rbWPddoSsjf4B/AbMKxa3dfGt8BHdXoDEO
         ++C3QCBi9LisFQeNSDmZgtDKZfOktbKG6haJFDSHxWD9KLKoVgnE5pSKa+8krjfYHkoq
         PW+6eNjzUUdgjV2VjNUK0Z2wenZD6MWHkw4TCqW1GOklr9GE3bqSsIZohgIxfiCR4HI3
         yXP84JjedCMFOq6BbtmGT84KFwM1aAWnjtSTuCY6SROnjNaZmfSouOIXBoYSUXEycy8/
         TolA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711874723; x=1712479523;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CZFUNXXbpZmBD2n9gbGYcEp/TwGJ3Hv0RpgMtmxvpLM=;
        b=aGManpbeuxalpJh/1710Q97EaJzMODxseCHOd1lr95iiNvFMxVvzSPgrSDrnB8hixD
         FSt3ShGuDKKb+6wMsa1K/J1CZM7fLkyzxy4mEQsWtmiQYssZkQHEv8R9BKKqEcdN8QNq
         AzySoTc/NdO83VNjF+NpGFRCIUjyJHmEEdB1+zDGy9cwXw7ZJ55EOqSN0X4TAMdtPnua
         T8YOfR5+C3FtXnJnBzZidkkQHUpManYUjw54NHlsrRtHapJLhZynpfCPc8l23YXQdIq3
         Uk98oVO12VFcR1VrF7OWqEjX97b1Q4XvyzUiXkRBZ4/doZ/d4fYDKdlVF4HHIHxj7Ryu
         zdMQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6lntSR0gFfYuVtIXoMgEsGMSdG4nWQq9dp8m1rKg+6S8JwoB3PTA9bMdV4kkCwVNdeaxxJUv0zj0Zhhtdr2yfzgfFqDJ77bYY/A==
X-Gm-Message-State: AOJu0YwSPXyItEF0mFa3U59As7/6wofk+GQMxxsTEFM1j15Ov0cLuO9I
	8KbWSZ8/iY5zLPIotwSnrYHgP+FBhOFuCc0qizGGe8XMCv5xZgJ+yZjJ4aeaMUU=
X-Google-Smtp-Source: AGHT+IFT9Xndc3vArUEuzjF8xW5suoqKxJOLE6RmYb1KEXV+XsRmQufSb5b/666jF06f9FzSKT/nKQ==
X-Received: by 2002:adf:ed90:0:b0:341:cfd6:42b1 with SMTP id c16-20020adfed90000000b00341cfd642b1mr4846497wro.11.1711874723376;
        Sun, 31 Mar 2024 01:45:23 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.223.16])
        by smtp.gmail.com with ESMTPSA id k17-20020adff5d1000000b00341b7388dafsm8436003wrp.77.2024.03.31.01.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 01:45:22 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Sun, 31 Mar 2024 10:43:59 +0200
Subject: [PATCH v2 12/25] gpio: virtio: drop owner assignment
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240331-module-owner-virtio-v2-12-98f04bfaf46a@linaro.org>
References: <20240331-module-owner-virtio-v2-0-98f04bfaf46a@linaro.org>
In-Reply-To: <20240331-module-owner-virtio-v2-0-98f04bfaf46a@linaro.org>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jonathan Corbet <corbet@lwn.net>, 
 David Hildenbrand <david@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, 
 Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
 Jens Axboe <axboe@kernel.dk>, Marcel Holtmann <marcel@holtmann.org>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Amit Shah <amit@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Gonglei <arei.gonglei@huawei.com>, "David S. Miller" <davem@davemloft.net>, 
 Sudeep Holla <sudeep.holla@arm.com>, 
 Cristian Marussi <cristian.marussi@arm.com>, 
 Viresh Kumar <vireshk@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, 
 Bartosz Golaszewski <brgl@bgdev.pl>, David Airlie <airlied@redhat.com>, 
 Gurchetan Singh <gurchetansingh@chromium.org>, 
 Chia-I Wu <olvaffe@gmail.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Daniel Vetter <daniel@ffwll.ch>, 
 Jean-Philippe Brucker <jean-philippe@linaro.org>, 
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
 Robin Murphy <robin.murphy@arm.com>, Alexander Graf <graf@amazon.com>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Eric Van Hensbergen <ericvh@kernel.org>, 
 Latchesar Ionkov <lucho@ionkov.net>, 
 Dominique Martinet <asmadeus@codewreck.org>, 
 Christian Schoenebeck <linux_oss@crudebyte.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, Kalle Valo <kvalo@kernel.org>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Ira Weiny <ira.weiny@intel.com>, 
 Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, 
 "James E.J. Bottomley" <jejb@linux.ibm.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Anton Yakovlev <anton.yakovlev@opensynergy.com>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc: virtualization@lists.linux.dev, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-um@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 iommu@lists.linux.dev, netdev@vger.kernel.org, v9fs@lists.linux.dev, 
 kvm@vger.kernel.org, linux-wireless@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-remoteproc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, alsa-devel@alsa-project.org, 
 linux-sound@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=790;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=7ATpdlO8BYGbOLrnCMWqDxc1uHoHJQazrkrXVJkp5JU=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmCSJaAzho/jBWSuYg+NEHOi9AGwx72tt9rOkys
 LAoejTXyNyJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgkiWgAKCRDBN2bmhouD
 1wvdEACYn5Lbx2GgrvuVXHg5Yw79n2Nb+2yP1csu2h/aVc+cXq5zKT6El9meUz9gMzQgQnmFpjr
 ISWhKJFcCyudV9zgab9Sw9i5sdKwfC/Nvz+ft7AQNbXVebdqAh3exF/QFrL1T77SVx9sDwrNJxg
 9eJOsPJbdkxmxMDXFHaa43fTTFJIAwlHqMJTjwTmwcgQMXKFgZaq9EMJG4034dO8UM7X9aDyDU5
 +VFG/jakA08eTSz5TQWsMA9+3fWcGztdePCoG+mpJg424e4+T13JnKMjTBDdzua2bXHsVyBx7Wo
 fpMf1ySj6cEuhdJvmHf62el6EnshfgD01zQvJxoCXvnE2fj6p7ROdK19jsawLcK9X7bJdA8N/RY
 P8USeFtyZH4wWrxuPHRu88805FvkdvWzEJs8LlBlJOVWj6iGkKr8c4YrMi3vXEn5AsyIToa9hY5
 vwEF0W+IFhk3v0TBtbizJvmSuRhxexwlGmpR3DuWSLnnZZwq1ezEunoMyH6FH8F8aLDd4M9bjYF
 nm56t55IGGxpY3M/zOSUYcQk0NBkCs5aYW4R6A5H9/BTB2NBk2DOwNt9WqPKoa5hbkrRxLCvlzs
 cpAgY6obfGuKCghfT1tGqJ2yAzBTVXc/y65OTsBcSMRdnN3iPgkNIOi29oykR+Srre3zyIsqgqy
 6B7VuNcyEoTWC6w==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

virtio core already sets the .owner, so driver does not need to.

Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---

Depends on the first patch.
---
 drivers/gpio/gpio-virtio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpio/gpio-virtio.c b/drivers/gpio/gpio-virtio.c
index fcc5e8c08973..9fae8e396c58 100644
--- a/drivers/gpio/gpio-virtio.c
+++ b/drivers/gpio/gpio-virtio.c
@@ -653,7 +653,6 @@ static struct virtio_driver virtio_gpio_driver = {
 	.remove			= virtio_gpio_remove,
 	.driver			= {
 		.name		= KBUILD_MODNAME,
-		.owner		= THIS_MODULE,
 	},
 };
 module_virtio_driver(virtio_gpio_driver);

-- 
2.34.1

