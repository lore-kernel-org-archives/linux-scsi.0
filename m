Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDA114D296
	for <linux-scsi@vger.kernel.org>; Wed, 27 Mar 2024 12:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711543538; cv=none; b=dpxftpadONLDZkc1FC+jwG7MAwVWclVVq6UTVzhSiyQF9fIXBsI+TIGu4SfCC8RI7+xCHPwlyMhyyoXEjEEr6j/KJ4aVwnXTrdt1IVjZ+gE28EECg1aKbXBWj8HGv2/sCXhzsntb8+3ev2m5J9nAVB6PUW6UvXC1R0EmfFOcZKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711543538; c=relaxed/simple;
	bh=jCwmMevYkV3Lqd1Wbq1GxwStD6bPo7hGezrcOjB2c0A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=unvFpsB55uho/LFFxcbTkW5jkDkWK4o6FpllvX1ltAdXlpMsxKCXP6GxaasrMs3W2MmG+w8yraeziztGThWZylrU5ofBxSR1PhhSqT4JGVSh2SwG+zyfubpZwQB1Eww30IED7/vs5N70CZMM9jIwFQPUbkuLeutWM2GvviVR6Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UY+nkERF; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UY+nkERF"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-56c36c67deaso1328956a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 27 Mar 2024 05:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711543533; x=1712148333; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=No4VShp4MNQIo4/ZHdyujXMPexV2jpx81+F0aVzAh9c=;
        b=UY+nkERFr/YlW+5xVV53crYMg/3iD1rZgyYlGBroGnN9DKN1IiDs1quLsjbg8TsRLc
         0z7atrPbRb8Y525lo/dgcKuAi91jTeXurTkYbCyXnqbptYbXwdCabn9HAA4rlX+8NiA4
         FoylyfGjlEgDDS8lQ/AD5hI1mMjTelVxIEZTfBuYZVt/mFEtWPebI4gCHIvjoXJS1UIT
         nadzHxn7SEyqo1xiJhu+6XVvgZtKeMC1ldwFOjrLzYOACjoYGGssFUBTO3zyQcoYB/ee
         ZC+7ddY8nx6WkMjsPtkiVputOn7zaBFTh/oAh+cI0DdKU6tACmIjXe9PXybxtOVpjdO7
         ZAOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711543533; x=1712148333;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=No4VShp4MNQIo4/ZHdyujXMPexV2jpx81+F0aVzAh9c=;
        b=jo9liAvtQ8UagPmy1OY3B5yOpT55dQVX29m9oH3uFxKnQvKqgZbljdjRwtT0nhoqAr
         c+jjCT42jRQqWvEoE4QXOv/Uljx1u5QfiUjnG3GW3iS7GTOtrg1FhmgCnysJmaKw7IFi
         aIx3J7vUE4MJ88kncdeVgic7Bv0sMffJeEoAAK7j2ofq7wmB5hOwiS9rAIEpfBAPISYz
         kljEtoBNedwvWn0GhIRAcZlU7rL2ZjuETzWt4NsZSofMOF0pU4RJSttJRImBPgmV5YtZ
         7RANerimiEhIQlu9RpuyA+viUbbgn/pqI6drySQkNyXr7hxUoo5/S1XmHPtdLKFkztqX
         9dDw==
X-Forwarded-Encrypted: i=1; AJvYcCVROJTcSFjFcBd+HpVx0vBy8Lry0m7y/sCG2Zc0ywwDv5oBXLEtbmobVauttHN2iiuO0E21jhAKFI/DEG6SVGQB3mttaYlAnmHBMA==
X-Gm-Message-State: AOJu0YxuX+jXFykzyGQ9ahgy2JVxZUkBcDMrKmVe2HBAwT3ntA216iMr
	J5QA15sHKQnPERqBGfwwMKnxSnEfH/04qgIgHb9X+PcQLE+TztRuFAXJrn4WMCw=
X-Google-Smtp-Source: AGHT+IGcHd2qY7ZBro2wyisxjF8vmsU4S1L2u/P0SqS5KVxX0CKJYhU9jvIT/xpw11DDb5r10WYfVA==
X-Received: by 2002:a17:906:f2d3:b0:a47:35e5:7da0 with SMTP id gz19-20020a170906f2d300b00a4735e57da0mr825525ejb.41.1711543532979;
        Wed, 27 Mar 2024 05:45:32 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.206.205])
        by smtp.gmail.com with ESMTPSA id gx16-20020a170906f1d000b00a4707ec7c34sm5379175ejb.166.2024.03.27.05.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 05:45:32 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Wed, 27 Mar 2024 13:41:04 +0100
Subject: [PATCH 11/22] iommu: virtio: drop owner assignment
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240327-module-owner-virtio-v1-11-0feffab77d99@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=741;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=jCwmMevYkV3Lqd1Wbq1GxwStD6bPo7hGezrcOjB2c0A=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmBBPjcRuWcdv+n/Al0ahdDHsSs8WafHdIUlLGa
 Dnt3fJtJ9GJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgQT4wAKCRDBN2bmhouD
 18avD/9TrqZBBr4oeroLUMQVYofN5TjAKsnyKZWl94vQ0iYfSWHuOlNDOTMSN2Dt08NBk9v0Xs9
 eUeYmPAYKRPRGkVuIDT6wOGW74KIxf5Mzb+3Ds4U2QrJRdXG8f/ICyRsRD1pHENt8cK7rI+E6zd
 umkuE/KYrQKTdXb4i5CHK+4jJ+DeoSIswuO/54AUq+E3pgGpFpdxxhj3208Hfz7tvnh9pgJmVh6
 zMv18OlPg2XfxZF78f5CFbftrBco7QM6ZHNrOk4RVql8QzSC7xQUjkGRYbxSF9HZVWgRUQh2WXF
 xxDK7TkVVSHfRKctSH//72hik+jo9foWddmeNbFaTrbXNjnnfnMRGMsnzz2EPFrHjDeT61LqF0T
 u8SNrNOpi53cLv3XWw09T4PdY+XEqvqtEOvJNJ8yEihBPgdwlfuUFeotY8G4XEtfN9ajZcjpkdP
 F6UV6cNFIDph+aGoj6T5rloUw8mjhJCO8p2f/T4HHgOs9RkcoLnb4zY9lprMxc6PMlT2fC/AaSB
 JwlRKgB9FMrOWfSuB5JVqDAZUUoNi3ycrmnq6XQAxs+QanigRO2orLbBXUxhmwRrcORCAXzAY/m
 L00b+Gn5jqZIFKGhzVfYaO/NbGgHZGtdQ9ZEg14BZW6tIdbpC/y2F8V6vq4H0WyOMH7b1wZ8HiD
 Mj246oViTtDiKNw==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

virtio core already sets the .owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Depends on the first patch.
---
 drivers/iommu/virtio-iommu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index 04048f64a2c0..9ed8958a42bf 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -1261,7 +1261,6 @@ MODULE_DEVICE_TABLE(virtio, id_table);
 
 static struct virtio_driver virtio_iommu_drv = {
 	.driver.name		= KBUILD_MODNAME,
-	.driver.owner		= THIS_MODULE,
 	.id_table		= id_table,
 	.feature_table		= features,
 	.feature_table_size	= ARRAY_SIZE(features),

-- 
2.34.1

