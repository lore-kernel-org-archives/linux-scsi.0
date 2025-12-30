Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2C22DE6FC
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 10:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089766; cv=none; b=lWnXjzWx99Uvsn9LW+I+FCHvawIdaveQw3JzM4kfmNxescV0O7B/LCig05YXOPfbZhVPjozeRrw2Qi97aSaTYcqvRnW6paUefyRp0Xt4SeQ4VnI3hP3e9x1QjsVhymjKy950TqTAfmgIvlOJKSqcdNi73tdbXJ27Lt38Wj78M1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089766; c=relaxed/simple;
	bh=3EF4beueqssYSrJr7jAiyWtRxi/ynmIi31SbgxtAbxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J3+TxGQ4LBTyHDx+1Pmdpctw2Jsnz2KLAej85dHTlodzdOPJfmxwzJPCamMy302pbr/VLixAxjFfdkV2/UkFY7zmREwc8fmpvYfNHnmfKAl/lYMikQEg2+3dG2FJH37O+cFoA+qFK7VRGSojzNSvehHVnd53L30R3ynDDeDnJSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ig5ep5oQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z7FQ8isQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ig5ep5oQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z7FQ8isQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jlkdUJvLxIuG9RkypEQ1odBgc8hsD/vyeqVzWJtThQg=;
	b=Ig5ep5oQfWTSijshrhmphh1kZkOF0/D3T4IO0PkmzcUJ9LMbjzNp+u6jZ10CCW4QVl+zOX
	Tya5yn+N8eUQwS6+O8S7fVAFMqh66YiNsMIbM3BzPQPZVUlRDLR/1xsJMoY6lRsszddlWC
	jG9Ke2bvMqJsbN/EmJMgf0wOxMckYuI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-SZJL9k_7NcKlK8hOgKPNTg-1; Tue, 30 Dec 2025 05:16:01 -0500
X-MC-Unique: SZJL9k_7NcKlK8hOgKPNTg-1
X-Mimecast-MFC-AGG-ID: SZJL9k_7NcKlK8hOgKPNTg_1767089760
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430fc83f58dso5494100f8f.2
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 02:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089760; x=1767694560; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jlkdUJvLxIuG9RkypEQ1odBgc8hsD/vyeqVzWJtThQg=;
        b=Z7FQ8isQq14I1KaSH1zw/UXjxfl4vbX2ZEFt82yb0xF9HrF5cGDa24nsifnCDpFx+d
         ZJVEGcAaQcquK7ruSxLov+mmtNZm6Z1cY1l5h155mMjVQFrApi3LDOd28jAvqGiPFSet
         LdpFwLkIn/ZjyF4pQkW4zmY53q3amnxzSS9IUxJai+v6NViiTMCFUhYnCxRcxm5uZESt
         Aw1V9bQXYW7Fl52Vl/JGM8eclURT8majQKzcf5P/SfKE9+ou1xx5sGSTMLsUXNKdhfjL
         R5z2Dr7EADU/6enDMzGahCI5t7S/9eDh/HfytF8+YyTZ1fvM3mPQmNW/lQt+yUskX7rr
         0rRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089760; x=1767694560;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jlkdUJvLxIuG9RkypEQ1odBgc8hsD/vyeqVzWJtThQg=;
        b=VbL3etAg2RH/Z9Yl67OGO1Rw2X+hlo+PUOl8xjf78ehtA2gicb4ElK1k06a1PeziNN
         SW0+60Gitawoi+knZUhTc5XBh+cQTL7CbnOKqfOjNHGqHbxDfHIWkUF9lyhImeyDHSK1
         fGUupjXL4++XTmZrMVz6yrpielzc23VeEZCoP2wKsF2Uu/S5zz4qWwkUCXtV9wYbSqUu
         goVw66GmCCWQHjkLJJp1YOKEWKP4Eshw3R4QGN3skxiKnVzxyIar7a449+jKXE8bHX0C
         UfjKs0UpRDMwSH/phJA5rZUqckW3kGtaiB0VIrgiZEvZFlQ8uiVMal4reT9nTeJnjv41
         ePIw==
X-Forwarded-Encrypted: i=1; AJvYcCUN16ylr9xUYLTZJnHt3NC7zRST+vjCWqydaNk9gjcrcgeTt7j9yBYF/OexOQYKf2fsbrvazSp+kEmD@vger.kernel.org
X-Gm-Message-State: AOJu0YxRe2YSnQ7NwKZ9hDttJcr+w4T5xzZWJjbgHdIj00KQmT8Ov3op
	WxawtKKPPf5Ly+p0fVM8lLxt5XDzttxgAc+nhxSH1OSekY1WvuxfGqUWVq5voPQIBGaVs06bNF6
	bFTGoj6RjrlnlgkEQMpbbuOXIscpHFueJ3eweBF8KJcsEjcGfn5f/2YtLOMY6r5E=
X-Gm-Gg: AY/fxX6rbeivjQMEAI9NS+jgDkS7OB/asHQo86mEmCElthushcM3J72H8xwIn+A0O09
	pl9FRKrFLH8uITN39sVqTpJESsI4aEtL7nOA3V/8iqlgpi+1nc55GvVjiW9qtdW0nLEIr5JrJmv
	GKMqeA6u5HVZjs21n0SED7CxkqMqfcF5+l0Nzh5dVqXIt1rUdVQxoKDQ5u9eAdzueaycTQYTTUM
	ln/wNIOVu6SbJLLJ5QSVAu7C+xTBI68wjCzS1LVxP6Rq0JLGMBlvFcvf5znzmaaFhkrUwyKnaLI
	v2fzdWMaMr+/sMjyo5nBWElfz8z3/GeN4y1qithH9Eft0sWaCP0MBJx/+T/5y0vyR9xMma4IF8f
	omoHToo7sLOqoqfRzAnQQottIusino2huow==
X-Received: by 2002:a05:6000:2906:b0:430:fd84:3171 with SMTP id ffacd0b85a97d-4324e4c9e98mr39750134f8f.22.1767089760444;
        Tue, 30 Dec 2025 02:16:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHondA4WovcXdLOT45Lj3uVr7rduhIOKgQxT45AJwE7sF5CS5LqWM7ii/WKiPGqmcKK8QLbHQ==
X-Received: by 2002:a05:6000:2906:b0:430:fd84:3171 with SMTP id ffacd0b85a97d-4324e4c9e98mr39750079f8f.22.1767089759925;
        Tue, 30 Dec 2025 02:15:59 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea830fesm68448837f8f.20.2025.12.30.02.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:15:59 -0800 (PST)
Date: Tue, 30 Dec 2025 05:15:56 -0500
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
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH RFC 04/13] docs: dma-api: document DMA_ATTR_CPU_CACHE_CLEAN
Message-ID: <818c7ea78e43b93d1bb3995738a217e5e414e208.1767089672.git.mst@redhat.com>
References: <cover.1767089672.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767089672.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

Document DMA_ATTR_CPU_CACHE_CLEAN as implemented in the
previous patch.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 Documentation/core-api/dma-attributes.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
index 0bdc2be65e57..1d7bfad73b1c 100644
--- a/Documentation/core-api/dma-attributes.rst
+++ b/Documentation/core-api/dma-attributes.rst
@@ -148,3 +148,12 @@ DMA_ATTR_MMIO is appropriate.
 For architectures that require cache flushing for DMA coherence
 DMA_ATTR_MMIO will not perform any cache flushing. The address
 provided must never be mapped cacheable into the CPU.
+
+DMA_ATTR_CPU_CACHE_CLEAN
+------------------------
+
+This attribute indicates the CPU will not dirty any cacheline overlapping this
+DMA_FROM_DEVICE/DMA_BIDIRECTIONAL buffer while it is mapped. This allows
+multiple small buffers to safely share a cacheline without risk of data
+corruption, suppressing DMA debug warnings about overlapping mappings.
+All mappings sharing a cacheline should have this attribute.
-- 
MST

