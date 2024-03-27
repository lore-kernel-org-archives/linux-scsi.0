Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719DA14BFAF
	for <linux-scsi@vger.kernel.org>; Wed, 27 Mar 2024 12:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711543532; cv=none; b=pmAlEHj8XPXKJL1jlo2pmXLL6UJFog/IxFvFIkJ7vWacLzUhdoWh6yZA0X4kIrVZl7P4hJHxlxMM3xLervVTtk9QZ7sEcRTPX5FeNjmTAjtET08L8FM73kUdET1lJPhLTU6DV8j4No/Go5SGB+RiSuZtxEu3sNQgsxfjDURe+dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711543532; c=relaxed/simple;
	bh=nkRw+hEyffQkd47xH6yhTGRY43bQKFbnoktzkBjZ19w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=J9UNGJK4WotYvGY0tAvTK2wV4jTp6udt7tz5Q4uk6bOMRIA7FlxEcBQohkl0lt1YL+lcTEA5hmGTGQwDDU/K1IgVbID3oec9d3rVtIi6oO0oF6T+4Kh7kDzX61p+M9CUYrfzKdZ4sv4Xfog9DJnVHu4mwiLhYBKPGcrV13l9g+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Zewv84jW; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Zewv84jW"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-51381021af1so10248321e87.0
        for <linux-scsi@vger.kernel.org>; Wed, 27 Mar 2024 05:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711543527; x=1712148327; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OIGX0zkEWaN83RrWauYFLuhRKQU73+opfJC/SaE++k0=;
        b=Zewv84jWv9XQyskb+Yk6bMl2QJoKX3FQucqAzrtksAOYr5XMy5y/pfw7p3sPMCZEBz
         GTb8hjtG/DIPKmkE1Q0RZx0Gb5uECeYLGk4eknHKjIjbuwBGzsfTNSad5ZO52baa5SNG
         AIA8YcBX+y2SdwKuvkB5yf5FpuLxyUbFfAIuFX0FoKTpxQ8SBXbWtx61/tCC4M/HUYag
         LF/PdApzmapb4+0VX9OIlt3SSqMDSuyj+c+z7c3y4V3pJMoVbWPRiyF7mULNNyFCZjNX
         16jR8nT38BDa3hM4pgnOAZN+FCoSwb9+VMGsgtu+Rk+N+IrSxDRyJrwsH3TIG6xfunAO
         Hwig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711543527; x=1712148327;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OIGX0zkEWaN83RrWauYFLuhRKQU73+opfJC/SaE++k0=;
        b=XH2UiP3LoNaa3j6z3m9f6kRFCH05EJeUWT9zM+UgRwnrFmpshfOq5edL9FRjvfFlcR
         lNkcRglyxbgdZmm9rO1JY0M8GGpv+604MsAMoNt13D5+2mZ62iXX7s/0ZG+LlfJwZ1lG
         +EK8QGf6KGH8y8ldrR2GilqOdj/L5Ms7Z5vu3LNAQ7vkQ8Ba4himcB3AHUwQa/w6YXBj
         o1wO/7d5cnGdH55tMlmBku7JOJH/eko3AZtlICpcCXu5qet/4faXuVCQk0pjTICQMAMZ
         VvT2eJnOmIa9iifTpkPaQenNTMR3Hlvl9Hxd+TCQkUYYmpFwsxbDQDwjqFK6nLZp2p1L
         N9kA==
X-Forwarded-Encrypted: i=1; AJvYcCUgMVHSu8hUelqkBvUsBuOvJJDgkQ+0prlnzea8WeJqmEprPu66hb963Sn5oCw4Ikp4N538jKjxlafPZE1fqCSvKObi8SIa2BvZjg==
X-Gm-Message-State: AOJu0Yz7MOQxxJ8IqvqU3fol91caSJfEh3u2Q/Kssn8V/elaYKiWlOQv
	NddD2qiuyUWrldqqwUTo+gMsOM2w7tzDfnZxuIYmBmeyo8dOZPbXzP7v6voJPUE=
X-Google-Smtp-Source: AGHT+IFTe6KK5NzzAQw6DLzrYupzSMTGssF+U7deLYZAVBSrCE4A0Uj/ENe1tzZVoUoWNlZVC8fZZg==
X-Received: by 2002:a19:5e10:0:b0:513:e14d:15e1 with SMTP id s16-20020a195e10000000b00513e14d15e1mr2258015lfb.57.1711543526649;
        Wed, 27 Mar 2024 05:45:26 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.206.205])
        by smtp.gmail.com with ESMTPSA id gx16-20020a170906f1d000b00a4707ec7c34sm5379175ejb.166.2024.03.27.05.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 05:45:25 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Wed, 27 Mar 2024 13:41:03 +0100
Subject: [PATCH 10/22] drm/virtio: drop owner assignment
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240327-module-owner-virtio-v1-10-0feffab77d99@linaro.org>
References: <20240327-module-owner-virtio-v1-0-0feffab77d99@linaro.org>
In-Reply-To: <20240327-module-owner-virtio-v1-0-0feffab77d99@linaro.org>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Richard Weinberger <richard@nod.at>, 
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
 Viresh Kumar <vireshk@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, 
 Bartosz Golaszewski <brgl@bgdev.pl>, David Airlie <airlied@redhat.com>, 
 Gerd Hoffmann <kraxel@redhat.com>, 
 Gurchetan Singh <gurchetansingh@chromium.org>, 
 Chia-I Wu <olvaffe@gmail.com>, 
 Jean-Philippe Brucker <jean-philippe@linaro.org>, 
 Joerg Roedel <joro@8bytes.org>, Alexander Graf <graf@amazon.com>, 
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
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=794;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=nkRw+hEyffQkd47xH6yhTGRY43bQKFbnoktzkBjZ19w=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmBBPi5ln/NE6yYKe/g2hSdNaOWNown5itxMAzc
 cWpPjO510+JAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgQT4gAKCRDBN2bmhouD
 11JMD/9Dt0RXRxFqSwBoM243YFGwfb5rVSQTy5OQh673qccdjX4eVM7SH9KlmSEgdTRMu4skrvI
 TfWq6TFqSZmtEnLc+eNLQkIfdFU+wIY2BonQcKxwqaCVqKm5g0IFaZ07Cdol7LLV4bzHyqatim9
 YT9oVJlOnK6xwmVsULUXLNqldmTbnAjwDv/8saYEC/2HwNY6MdGJxwZuMEdCfTtd4S7BIs1Igp3
 Kd1gVLGKaUTYSbKGotlfnWBfXe+leesFc8cG2JNru47NKJ9dPuIOzgc6BpoGvAZPvD/cGGCmJR1
 V7mEZK1DEES84YfWjv7MUh3LAH4N2q+eelTKo7zg/E3uZx35ujWPAfSWc4M2LoAFVKs6yBPBdV3
 G7sGHXO3ijYLapANaowLjkLX2F+idzDM0PHiKDJzKg4vHGd0DKxKtEU+556d8L4FRriH6NHgtRO
 f2CiZT8Lxy97gIjC+CP4ASmNGWXNHrSNcw5kJ3xBkIf4EIaZOZfym/vTS9bZdLBHt7vcnAnjnsv
 YvU49CRKoalhEetDEz31X9vW2OpnC4ihmhy6KNGzG3Q85EQX7G0ltCu8IlYsqkGB25rpP79kdG3
 h6bMp4fQteqgCj4rtFzlGJkrOXJ/U9k9jcDUnvZtNzm/kvSDib52qqN37X7Asb5pv/RYggWh6DE
 bcqvemCVVipRGCg==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

virtio core already sets the .owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Depends on the first patch.
---
 drivers/gpu/drm/virtio/virtgpu_drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.c b/drivers/gpu/drm/virtio/virtgpu_drv.c
index 9539aa28937f..188e126383c2 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.c
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.c
@@ -154,7 +154,6 @@ static struct virtio_driver virtio_gpu_driver = {
 	.feature_table = features,
 	.feature_table_size = ARRAY_SIZE(features),
 	.driver.name = KBUILD_MODNAME,
-	.driver.owner = THIS_MODULE,
 	.id_table = id_table,
 	.probe = virtio_gpu_probe,
 	.remove = virtio_gpu_remove,

-- 
2.34.1

