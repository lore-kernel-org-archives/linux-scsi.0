Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FDE32B996
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 08:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601444; cv=none; b=h5ik0hH+SnrpUAutqCsaT9mPZDruyA9nsP1ScQPxmpB5tXvYEtUVTXmV9dQDDeoSBoo+RaC/rtP56mB1TXs4f9HpsSrBdGioA6sllcQ1Zffeyzh5V3MLmM3RZ+Q9eD4xz489OJV1CuPGiVsB6wlmAu+XJshtLgfm33KE89SioZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601444; c=relaxed/simple;
	bh=jIFi+Zvcrqx5KM1Tn7Vx/X/Ro5vONbP7sNW0Mf3F+ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rTRkDz9+SosMrjn0z+/UbhHSFhRJl9qNU5vv5V0eoNCimlGnF6GwxCP/BKPmBleH9LUNcehjsNwGY9C7n3CYQNsIBDs6NpxkjvSSDK/Zor0oLYsmDyF5/MNIEyefXJZZrn78szHgKQBc6ZW1IgA3dieaCy3MpBxGNXkFcLHkUrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U0EJGw52; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jhuW0fAF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U0EJGw52";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jhuW0fAF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Ko5SEulg/0toBKRpZAMNGsguRweEFK2Nvy+yQ/ftdE=;
	b=U0EJGw525N36TsoWhwIOnHH1npKLZARnTZguj2NX/3prDCcmeRPQbwt+hNfC0WXAQ3xUXf
	72jxF5QIZDsJqNjXDrw/4uv/LyZg03zEUPojJb9o56hhsYdQgPliO9LIbaDzxu0dd7svGC
	fhwmZSYop0+2nnDzQJGqmS6QbD+QSn0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-NvgSaX-pPSq6dwkW7cGoow-1; Mon, 05 Jan 2026 03:23:55 -0500
X-MC-Unique: NvgSaX-pPSq6dwkW7cGoow-1
X-Mimecast-MFC-AGG-ID: NvgSaX-pPSq6dwkW7cGoow_1767601434
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47d3ffa98fcso56798425e9.3
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 00:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601434; x=1768206234; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7Ko5SEulg/0toBKRpZAMNGsguRweEFK2Nvy+yQ/ftdE=;
        b=jhuW0fAFKWout8NvzOE75lr0thW/Bvte4Ikr3Ds2O8GTD5vrsS8ZXy/VT74UzpbAlc
         SkwWcLIGG2nOn2hJ3IOcZWexU19Ly66MFoocUxD3oz4K3yQnN35L6SydRy6k/+YyXyBd
         yPebtVj0mQhCIVAxVWRptftBXMGxBrm45coShq6icSkrazqS6YFoU488FT0ix7EZbdU0
         Tgt3MkO+ClKdAAuJSso08c1qe6N9IhusEsMZYkwbRWP4dwNmx37rNJr4j76KliGNlmwr
         zxVVw3FkCTqRZ/sC1v8j5gVlPYVLiP9gScBNQgEJyJqfnGaU0TgCBqXdJGQXno4Ef1MY
         fWAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601434; x=1768206234;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Ko5SEulg/0toBKRpZAMNGsguRweEFK2Nvy+yQ/ftdE=;
        b=f3uJOozevWOVbDWo+AhaxMkPDJevzc+x2hS4Me1lCvpTP0c3knE9m/mbaiPbYQMMup
         1etd2h6oAjqVfssA77EgNIALogfGIZRHpg10y5fzaJ/YNbhxSGWVSH063lOW54HhOkad
         DzoI5scegT8GAwOpYbmCinCVVl5Cz0FyOMF48extV1cA1xoZ2V1ZXoz1OCZm5idSjB+Q
         gvGIOm2MswlL7Q35IcsO7txG93XfVnWuFQmdUSZRXrsopDpIAGQLlYwvPuvMADUQ40aI
         Coz3INMlG5RKjDYVezO2AjrePu5txWNuXiOs0ak1EHVzYbyZEL9ZS9z4jTouR3goi1n+
         IK3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXmGdXxxK1XXi4JQQkA+ruxcCthDxoAr68zQ8n5wqml6JZA9UtWeDPrBmIyUnyjN7KI81job+creILb@vger.kernel.org
X-Gm-Message-State: AOJu0YxaqLcUAsxuxtS5i5GhTG5hDKlcgOHVWlRvhzhwNSWZAjCjUFcf
	kq/Ecjn7kaANfbTymCMyidMTlsSaq7iub1I4EM72EFeAULRRxeHIN1dF8XpCOUx7TVErB8T0Z1m
	NZUC29WMAdoBzxCjuVkuB4pPbSdF7gSmNETs0B7pBKI2mXT/NNgsKayFdl4trwkA=
X-Gm-Gg: AY/fxX4VOM54lbSGsY4i4UZg+p6iEIZbnWEh6ptkzi3Qnt/4+xuZoUqn3Fghy0HNli/
	O2SMIeNiH+INoRwD21P7YMifYKadTCQEKd6g4CWJR/ejiiahEcP0yWOvy4UZ+HhrjGrrshBubX/
	jI7AhY2k2IOsYFDiQ9cAMxmEuREbjNg1RnYheyFP24qVsnIV4qdBaNa1Wv8UYHTnRi+ZOUEvLU8
	ITwoNU6SpqDssAkZTDpD/j1n1IT73PdB1wza4ny7hTu0EpSjhFARx/PFECY1W27cJV5LbqU9/WS
	BfmxI4+RRuO9PqfX7s2CJS1gY9YQ1kIpY9PNbm6/SansEDqQMl0KrtYrf4CaqpO7dXZ1LAum+co
	Ytx8FpWS5il3tnO7l78GEFodU2jZD/iiAxg==
X-Received: by 2002:a05:600c:4fd4:b0:477:9cdb:e336 with SMTP id 5b1f17b1804b1-47d1957afd8mr619222085e9.21.1767601433872;
        Mon, 05 Jan 2026 00:23:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGMqr5RF3PmeKLntFlggNTcPo2ZIBIezL7tE6/J3AdeaKkIeEvwYa+UmsMabaObW/38gLAvfg==
X-Received: by 2002:a05:600c:4fd4:b0:477:9cdb:e336 with SMTP id 5b1f17b1804b1-47d1957afd8mr619221495e9.21.1767601433387;
        Mon, 05 Jan 2026 00:23:53 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eab2721sm99141541f8f.39.2026.01.05.00.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:52 -0800 (PST)
Date: Mon, 5 Jan 2026 03:23:49 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Enrico Weigelt, metux IT consult" <info@metux.net>,
	Viresh Kumar <vireshk@kernel.org>,
	Linus Walleij <linusw@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH v2 15/15] gpio: virtio: reorder fields to reduce struct
 padding
Message-ID: <f1221bbc120df6adaba9006710a517f1e84a10b2.1767601130.git.mst@redhat.com>
References: <cover.1767601130.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767601130.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

Reorder struct virtio_gpio_line fields to place the DMA buffers
(req/res) last.

This eliminates the padding from aligning struct size on
ARCH_DMA_MINALIGN.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/gpio/gpio-virtio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-virtio.c b/drivers/gpio/gpio-virtio.c
index b70294626770..ed6e0e90fa8a 100644
--- a/drivers/gpio/gpio-virtio.c
+++ b/drivers/gpio/gpio-virtio.c
@@ -26,11 +26,12 @@ struct virtio_gpio_line {
 	struct mutex lock; /* Protects line operation */
 	struct completion completion;
 
+	unsigned int rxlen;
+
 	__dma_from_device_group_begin();
 	struct virtio_gpio_request req;
 	struct virtio_gpio_response res;
 	__dma_from_device_group_end();
-	unsigned int rxlen;
 };
 
 struct vgpio_irq_line {
-- 
MST

