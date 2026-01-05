Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531D5314A7E
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 08:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601397; cv=none; b=Q8gvuzPR54VaHf4qS8hmhzNMnExc77R/G1Gal+KXITLReX/2o8Z3WJ4Httdx7SnVFcIdlhXRFYgXl9OOrEZvUgbAQXe4S4imBZrUAxIWu/vLuHjlZKf7wxmkIlA6/mZ+TXzleU6tzp0Fpu+Ixgfsdge0JRYcqTEnEaCnFDwUCWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601397; c=relaxed/simple;
	bh=3EF4beueqssYSrJr7jAiyWtRxi/ynmIi31SbgxtAbxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GUJi7xOyKnmmb+9/TjcOfqtJqpwNwcEvdxo8Z+GPed22R08tm47poSEXj6rmcnGrf6lVV1RSPiTYIVVbZeJJmkH5b4TgaJdhpYSFoV0CbcISWQPKJmdtoYrjDs11ASWwKH2lqBF/K8GihlbcZQ6V+4jqV+PG/HHeIVgnocxzFJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fhwpRoog; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FzAXECaK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fhwpRoog";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FzAXECaK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jlkdUJvLxIuG9RkypEQ1odBgc8hsD/vyeqVzWJtThQg=;
	b=fhwpRoogQuWSFbaBh0s8ODmeCly1d8UTg61ZuQq7OyOTmcTSJD6ZFtnsXDmPvd+XhdHCO/
	UKZLrHTnXU9ulOjVahixSqY4GOZvWpV/Ym1gZ7rQwiBfdzqIaKQTI6TfQfPFSXXhEo3/rM
	hDbUSuy6j10aykuRFAXhLkga0ugWaTI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-taoGjPgPOgqpJtqaws6Gvw-1; Mon, 05 Jan 2026 03:23:12 -0500
X-MC-Unique: taoGjPgPOgqpJtqaws6Gvw-1
X-Mimecast-MFC-AGG-ID: taoGjPgPOgqpJtqaws6Gvw_1767601391
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-430ffa9fccaso10786604f8f.1
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 00:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601391; x=1768206191; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jlkdUJvLxIuG9RkypEQ1odBgc8hsD/vyeqVzWJtThQg=;
        b=FzAXECaK9cpyvzSFZy2EhuHAzlJYHYh1Ucgh0W27TOzjOUZxhoOG8f84Akx1O9zwx4
         CC0i5zi+JAF8JUzNa7jRnGOZgifzp6xP185MLdaxTMhpb3BVub6wsldVxzkRMP7sKCTF
         Wh/9qnZIFH/gtILXIgimM1Q5mF9HE/JX85wGVPpWlctAAhY18PWOK37gvJbETMTa+Spt
         42RiCPItEDLPj+tnu4dl2DVDx41dLyN2aEcuuR2R8kpPrI9Bdk9r7F9OUYvygjmLA4ap
         M0wbuEybZHozcmrIpXIOxIo5REsr3F6Y+qMZG2Jrxljck8M9b1jbMaSbfzVjBHILnQ7A
         q+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601391; x=1768206191;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jlkdUJvLxIuG9RkypEQ1odBgc8hsD/vyeqVzWJtThQg=;
        b=iuSxZFHgD1bdLtUAYfjdZn14Vfo5xeUbgngqGQN6IQXdlXfUwVW4oKTbO45SA/2336
         gIN4lFY5h4MucVgxgnYqUgiSJtJSTun9DV0+cgozVyY7LBXYVo985pmufmV223b2XjyI
         RBJFpccQGgeAhOgrjzY8fasXEjjZ7Y33QuBnAfwfHamdCwvgmzRPpKz3aHGWR6wR6wFo
         pC3znFmsw7f5bvlwhvGQjnC/dRNbhE8cmnYuSPp+xoSOdf0wiovwqLp1gTyYEHiQRrm1
         u9Yje+DCqKZbmAKf/JtHipjUsZViH3l9pP3qmY6bfZKyVBGlUJGUNuOtORz796q+Lprp
         BSWQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9mxQUmRj9HGlerst+fvNaUtm/0JYhC+yVgAI6GbDrXF/vhkpR1fRMYljRIvSiAx03bRGuTis9zhgX@vger.kernel.org
X-Gm-Message-State: AOJu0YzoPJhv+JYa4zCDSajsGqtGVgedgjsXPTODur0dO15eNnFzTJ0v
	lEB9Pcdkrj27Gyj6BNVWEBqU43YTQZxDsfX8h2WV66IQ3oySzA6Pk53G6+5HM/kk98Qa7S7TWXn
	BUGaZbefTNogVixjGUZh6Nxi49QJAe68IWoLbc9pihrjmULkloqHTq/0pbmyElGs=
X-Gm-Gg: AY/fxX71ng+kQgfMrM93iWCioUYoszEdki8Y7Ymb4fxhJpignu0VPCz9pBnZAzarxCu
	BQ6+yMOjlNGJoOOtF6HabW3PqtahDBR5B26FZIDzllFdc0CuTINf3+HNaZ2CsxNKTDAWJ0ksBRy
	X3WdSkW/FLgzVnzgNlUrVMlV4GIbvXP2u8Aq6CsT/ERtnbkASYib9pd5izMzxy34QBdnXinh338
	+QNR9HM2NoR1CuCI/TGRCQ7xFi98v6Ozso8E2xJD+ovjBvm5eiKu05uIlTVe1P7ra6V/ZgT4eCZ
	TjYqGw8EAdB+CBol4QJXkiVsGap6odsVHmUNRdMDJYimvCi0u7oWjeyKRqtwnBYQM/JBuTW90OC
	NfmzYCrHpcpWlAZzXfFr+RRCHJz7M1lC2lg==
X-Received: by 2002:a05:6000:2c03:b0:42f:bbc6:edc1 with SMTP id ffacd0b85a97d-4324e4c1230mr54966717f8f.1.1767601390680;
        Mon, 05 Jan 2026 00:23:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEwk1Ttr1N2m9x2GBHG1pWtih6zeyM7Sr9HAGjGkjK9L3/ihsrFeD/P27Wy0cj6YonFT6KolQ==
X-Received: by 2002:a05:6000:2c03:b0:42f:bbc6:edc1 with SMTP id ffacd0b85a97d-4324e4c1230mr54966659f8f.1.1767601390077;
        Mon, 05 Jan 2026 00:23:10 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa64cesm99604028f8f.35.2026.01.05.00.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:09 -0800 (PST)
Date: Mon, 5 Jan 2026 03:23:05 -0500
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
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 04/15] docs: dma-api: document DMA_ATTR_CPU_CACHE_CLEAN
Message-ID: <0720b4be31c1b7a38edca67fd0c97983d2a56936.1767601130.git.mst@redhat.com>
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

