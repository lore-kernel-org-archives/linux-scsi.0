Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3638E3DAAB3
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 09:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791280201; cv=none; b=joQTYycqf3OTckk9Iu+ATZ3DpvanMG3RcGuZJrakawtJ2VMjGSu07eMfs6up4Ns5uFGls2rXuH+dFr5ekZBJhsn98MrfVBuswN0kpi6JQR1PUQgIJNJCdc7ThYIwlXaVw0yNI4cbtTTa2X325uJFJ+IcbfvIZA8idQq1uB6r+Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791280201; c=relaxed/simple;
	bh=N3hn6QbtIdIIFPeRYp8HqA7gKHKr1qmaPyk2pNKf27c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lWJxXpe222ennTwQ/39JL8lG/2PKQVQq2J+3oxr+pUxEToj58WTKJ4msDc3GFfmC/wrXRNVc0DcYTbwDH8bj3l0MdqDoDm/c2EvCt6MSk+GX5DfHRmwndVJvO2FfHQm1cYvxTh/P9YVZeCL3E5MhKCyfb4xVQbZ0E8a1kHdMlmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e2mMm03P; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LHP46Q3G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e2mMm03P";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LHP46Q3G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791280199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kTOEhug/kDsTgsg0MW8NZpuSM30bTStxylqUNCEJaPk=;
	b=e2mMm03PyQj51L9JIjd+0HpqCp6WVWUN7bN3Shx+anUqt8odr+SjRiI7nQ00phPyl3Iwk1
	0gHSmBEzcIcGYKfOrpYQClQlGL31lfu9VYzBWZxpwdcxferjjsEisk2UMAPwK/GMY4kT5k
	0gH8iQFmWK4x7IdYkWhRb2Rr2oiCvfA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-Qa1SLHEBNiawMYGLf4pfRg-1; Tue, 06 Oct 2026 05:49:58 -0400
X-MC-Unique: Qa1SLHEBNiawMYGLf4pfRg-1
X-Mimecast-MFC-AGG-ID: Qa1SLHEBNiawMYGLf4pfRg_1791280197
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a16db51147so14580905e9.3
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 02:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791280197; x=1791884997; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kTOEhug/kDsTgsg0MW8NZpuSM30bTStxylqUNCEJaPk=;
        b=LHP46Q3GZba+pZvsgAcBILkqNvuz8VaPALrqUq/lF07L4tlddpnHWWGSssY8EfX223
         BgpAtRPUInJvaZ2cPQTsjCo8QVZOTkgyraHWqu7+qxLbnb1tUAkeWCFsk/sZ6dI9yc0R
         qrSHEYrIM8kXbJJYUYY6kEvlf/Kfn/C8UNHRKsdCf9YGHP0kOctJPiqxqVQOtoFxt3BY
         i4bsvxl67ahok8KaHPPhtAR90aZQstQj4w2vMpJFFxXxp8bumbvZGZHHO13tR4DCVyzN
         9h9RN1dJyPdzo7SKIESD1h97OxXj6ZYDaBNBS5yp7+5QPEjTKugh+2J67w8p6ACOXlpI
         oRBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791280197; x=1791884997;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kTOEhug/kDsTgsg0MW8NZpuSM30bTStxylqUNCEJaPk=;
        b=0yzE6da/XgqKgbz9wqmoAG+Qm4I1u9pyU0YVRyZtn3Mp4l/NXaIz872ewolOlHh8dQ
         +pPVIIOT7tN/ZkefI38Tu9pMOe4jnF+O78Xl3ZtVi8pGv9ZwA2A7E/XKwtVRRb0nOyVH
         uIeOiLRIyAemIQgtpmQS14f5iN6uvGIaYdyU8rVVkkiSA8GD0klPzDCE8IfsWt/TiZn5
         ZNsMjhKnERQuEK/6da7ddSGJ1536WxHgc8Ko2LUaCaClNoUH8JqIrH1BDc48nQWZasM2
         R7imxoC5BHTCUyJ7uZPzaIzjREhxRIHSSFHflJB5xYmTas8vPMpRXJJ+scxK4g9dEqvJ
         LfEg==
X-Forwarded-Encrypted: i=1; AKwUvByGaBFlkzVwxTeh6yQh4QQnBHDLsRpLgtnBhWzIK69ubAoaPGZc/+bDbbmSL+fxG3zQINZDjD3yOecY@vger.kernel.org
X-Gm-Message-State: AFuF++mX/G0dG5RNXYHOLFGQJs4ujIKzHxD90ao7IqfPtesJOAMoFSXi
	JgBt8l4JfV2r3AXTUCaLmlxBTT+SXoEjE6rk9O5FeOeNE6WgmgD3VXdraOt6J3FIyqSftqbRrrB
	IoMsAOoKqx9ZBSYrpbdVJ5IKcC+MWzoXcc7YEGXmoiP90vgv2zI6tLs7wYpY7jxN0B1KbwOA=
X-Gm-Gg: AYBFou2d0yRo2QSJ96a8naqYaEuyOT81YlK6bn9YP1+pgDwTT0zLqppsWxpZvme8GQ/
	zhnG4JQFn3i433VrqNPfXEt7kakghW97mZnT28FndIuGX7iJZaMTPQIH9uBhO+k1LfyntW6BE3r
	LeqRZ2YzDyR+ceYQtENt7hrdkNX2T8k7XRf/Bf8RCgPVpOAUnQckGyRtXvmtjy7rwAiHBdbziB5
	D7+helGayfgk4Hu2KJr9gNTfx8QdGZM+Qlj2iQGtaxff5IRY5WOjyKqXYs4HJcjnenW9lXjKGdO
	H4rhp/cmYM22d1KTRR6kYll2YFf0S90wOuCQWFojp53bP4o/3e+DL3bCCoEOKVmOhmar8eQ=
X-Received: by 2002:a05:600c:1914:b0:49f:e701:51c8 with SMTP id 5b1f17b1804b1-4a17b52d449mr14318115e9.9.1791280195261;
        Tue, 06 Oct 2026 02:49:55 -0700 (PDT)
X-Received: by 2002:a05:600c:1914:b0:49f:e701:51c8 with SMTP id 5b1f17b1804b1-4a17b52d449mr14317745e9.9.1791280194697;
        Tue, 06 Oct 2026 02:49:54 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:3fd7:5300:3d6b:52a4:a23f:9d0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17bfeb65bsm13352265e9.5.2026.10.06.02.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 02:49:54 -0700 (PDT)
Date: Tue, 6 Oct 2026 05:49:51 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: =?utf-8?B?7ISx67OR7LCs?= <tjdqudcks0424@naver.com>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Jason Wang <jasowangio@gmail.com>, linux-scsi@vger.kernel.org,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: Re: [BUG] scsi: short virtio-scsi VPD response exposes stale heap
 data
Message-ID: <20261006054845-mutt-send-email-mst@kernel.org>
References: <20261006091138.827988-1-tjdqudcks0424@naver.com>
 <20261006052300-mutt-send-email-mst@kernel.org>
 <96622e4086e5fb77b8148631fa6ca16e@cweb003.nm>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <96622e4086e5fb77b8148631fa6ca16e@cweb003.nm>

On Tue, Oct 06, 2026 at 06:40:54PM +0900, 성병찬 wrote:
> Yes, that is a fair summary.
> 
> More precisely, a short successful virtio-scsi response causes the
> guest kernel to cache bytes that were not supplied by the device and
> expose them through the world-readable VPD sysfs attribute.
> 
> The guest-kernel heap disclosure is reproducible. I agree that its
> security classification depends on whether the virtio-scsi
> device/backend is considered trusted in the relevant threat model.
> 
> Would validating and propagating the actual virtqueue used length be
> worthwhile as a robustness fix?
> 
> Regards,
> sungbyeongchan
> 

I think so but please copy all relevant maintainers.

 ./scripts/get_maintainer.pl -f drivers/scsi/virtio_scsi.c
"Michael S. Tsirkin" <mst@redhat.com> (maintainer:VIRTIO BLOCK AND SCSI DRIVERS)
Jason Wang <jasowangio@gmail.com> (maintainer:VIRTIO BLOCK AND SCSI DRIVERS)
Paolo Bonzini <pbonzini@redhat.com> (reviewer:VIRTIO BLOCK AND SCSI DRIVERS)
Stefan Hajnoczi <stefanha@redhat.com> (reviewer:VIRTIO BLOCK AND SCSI DRIVERS)
"Eugenio Pérez" <eperezma@redhat.com> (reviewer:VIRTIO BLOCK AND SCSI DRIVERS)
"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com> (maintainer:SCSI SUBSYSTEM)
"Martin K. Petersen" <mkp@kernel.org> (maintainer:SCSI SUBSYSTEM)
virtualization@lists.linux.dev (open list:VIRTIO BLOCK AND SCSI DRIVERS)
linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM)
linux-kernel@vger.kernel.org (open list)


-- 
MST

