Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB9714263B
	for <linux-scsi@vger.kernel.org>; Sun, 31 Mar 2024 08:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711874745; cv=none; b=ldMN8gCNm89ZZwwyAZKRCGqeqRPqOPC1kpQmf7AVn9AdEFsfZ6mwU7SHCTT373eiBA0qvM3Ws6PBWOAoAmmrpJDM4c/+7CBDpsZx3D8C3ub65k+wpwSrakTdnExQTdZ7JSvkRzQl6JtOYqa/HZMYIUiFUUxjKClgFnNI0C+xUL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711874745; c=relaxed/simple;
	bh=se3bAL9NWlxdnI0R5l3waFKazObx3hz9jbN0xln52SE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Q7oHVFGvQCvs+vEMLbJn6XGQn6FlvSjzV92IyypmCQCk+96CFT4u7yqDhZLtM9RlzNuTy0VyaqFyj6LntRoYwClgQ3t7qwciPqyTp4nhdN0WZBhGRiCvgdjdx+u76uUFaq7mXBD5qOQbMZAl8NS8o6HYtkumfaATaaXtG8QzpmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eeAaeoy2; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eeAaeoy2"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-341cf28e013so2263187f8f.3
        for <linux-scsi@vger.kernel.org>; Sun, 31 Mar 2024 01:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711874741; x=1712479541; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BCsDfZXw6LzB3XdNG+WbYeCWTW98m3a94TU3WahPKsY=;
        b=eeAaeoy2kPIK5mUUTkEhqCYjuyk8RmeqJlS2PManVXQgECNRCkyjrRYc/Sg9aKUyoT
         4yBR6lCRO71N1u60igfNcsahlSsCerxmuAte6BCwwJpAorx1Il02f6iDJwCzVPXcv/UI
         Wvf7h5nZpcbuP3Ep4Jlv2ln47gkiW/Tiygmt004xCO6sefE87a7d6/OZFuitOtsVgTab
         eV0IYC8rzdECSzT710BbX1KNwgIE9FxQirYUqM4vBzlGM2o1GWz9Bk6O1gZmxx+ILKzX
         inS97OB47B4lw7t5yMqxoy+3fiRIY6B5D7n+hT1h6LIg8MKaTWi/ZKg9+cQKWjNu/9xf
         qxuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711874741; x=1712479541;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BCsDfZXw6LzB3XdNG+WbYeCWTW98m3a94TU3WahPKsY=;
        b=FLEy1k3i1+pHkRMVo+Pz7Ka5rwuoaY7t3Fm9XlOYKQe5YsP7fGTUHpAdnJiwx2vsPt
         WzpEgmUXYvzFQvbLiKEOSN/+XtZhADSoZ+t98fNzzx+4yg1ISdLUlxPsVnOES822vc02
         ZiULyTue4la0hz5emU5OhID/fp0v00tOZgUVHecf5KWI1cAxeKgl42RQFRBlpJh4JpjG
         pMv9kYBzthDSLBTnG/loAhnMiqYHZ/lNC7Uq/kA+wmLeOiynPtIQzJ+V97a47+k6M0h/
         Ntm16VzZxP/EvR0GXACv9KXD7KvDWHnP6tYXUJ1GnOmfh97KNgXNwuLWfD130SolPkYd
         4eFA==
X-Forwarded-Encrypted: i=1; AJvYcCU5GcQM19o0f4MWw/1C98is3wbSV0HJ1SIXbufHwFD0wNqONRP9QGnc5iBVTs9NDK8G9OQ8W8k8zqjofRR9Wb+ox75t5xdCjgB9mg==
X-Gm-Message-State: AOJu0YxWaC7uqMS26dnLqtl3tfyBUSI7pdHbfcyWjzpICEJWXCpGTcio
	HpxxJxi4G4pJD18+gtY6F0GRDCAJNLreTfxlUqYtnYNT/NM5GkFyoorT1OVK1Lg=
X-Google-Smtp-Source: AGHT+IF3ZrUCOMfmBGxr0QtcEyHWRTvBM0iQXjRTcy/YDkzaetKNZ8K3RMX84Tih4bjsekACtKBC5w==
X-Received: by 2002:a05:6000:4027:b0:343:4609:ec27 with SMTP id cp39-20020a056000402700b003434609ec27mr2052015wrb.70.1711874741641;
        Sun, 31 Mar 2024 01:45:41 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.223.16])
        by smtp.gmail.com with ESMTPSA id k17-20020adff5d1000000b00341b7388dafsm8436003wrp.77.2024.03.31.01.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 01:45:41 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Sun, 31 Mar 2024 10:44:03 +0200
Subject: [PATCH v2 16/25] net: caif: virtio: drop owner assignment
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240331-module-owner-virtio-v2-16-98f04bfaf46a@linaro.org>
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
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=759;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=se3bAL9NWlxdnI0R5l3waFKazObx3hz9jbN0xln52SE=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmCSJenCPpEnFAHTEofapxPYFUf4fpJ0gAnwfPB
 1J9/P7me5OJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgkiXgAKCRDBN2bmhouD
 1wIcD/sGSIoIdHj/zYFnEhadRlmmHAAIVdCpD+G+O+AagKBU2I+fBkRPidWKXAPBKfSU3fF6iNx
 uy9LpF6AU9fW2XytaIZDWmq4ZJoJ/yAlIDFZ0Rt4uyhqB0Ggl7wHDrkYT+Ex4M4c8tLxOXPYSsD
 /bGA5wL677fAt50nzo4AT1T2X4LfwWGTL+ocvXlBhxRqPH6BXaXP1TjezXkHSM5HO95HqOW5EPM
 Loavoa3/t1lD1JXa+aAsjLL2Bb2wgcaRACpNZhtjn6Ps/S/rG7bwwek8RGlnaKxRX9GvGmlsjNG
 hBpWfYGDD2+pMIzk9NPKw/4wicHB2nBN1tqGXUwEvj19tJSZqhNt2GJZ+MmMQ0HmnNy74MgtOs6
 W//DnrXgIvSgXQJJunvc1dupJIshYqu36eDdmga1kDj9VYUZQlysCR1S3hyI2ius9goKWJBlYze
 Fu/qHoWTsTdRqlUPbU6IjDsrCWb00dmZ18/kXp0+LAYAYP2wqvZDKPx37pJZuxcFvCgr16gA+BI
 pNFOggLaDpzsFbU5gsdMYxLb9OM3j4nA6499+p8u5iFIEtJOzBSMw5Zm5ulZTlh/ED85nO/CPE3
 Vp5uHW1WKRV+ba2+hA3mDrxUmVM1OcbOXZlFGKll5nBtbAwTXF1bW9up1XBE3MAsu6b+tYKjhJh
 hYegPHr37N5IQTw==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

virtio core already sets the .owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Depends on the first patch.
---
 drivers/net/caif/caif_virtio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index 0b0f234b0b50..99d984851fef 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -782,7 +782,6 @@ static struct virtio_driver caif_virtio_driver = {
 	.feature_table		= features,
 	.feature_table_size	= ARRAY_SIZE(features),
 	.driver.name		= KBUILD_MODNAME,
-	.driver.owner		= THIS_MODULE,
 	.id_table		= id_table,
 	.probe			= cfv_probe,
 	.remove			= cfv_remove,

-- 
2.34.1

