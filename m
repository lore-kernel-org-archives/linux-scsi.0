Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6BD54673
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jun 2025 13:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750168701; cv=none; b=GPyiz5VcgDJvDSOKiUYnWg1Z082yMXiSGNYl4m9Da3Kd1zNEeD7uRYOPqYa4eYW7fnUbqV38otHI9007+fNniVp40VB2H8SgWIw7GqIfYSVQ+TcZ0vnOaV5WgeKI1JnfM9adWe4Y7q9vrToTnBBI52XYODRiIi2Xxd0jgG0R2L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750168701; c=relaxed/simple;
	bh=8KOI5xyxym04Su+Y1cshyyjm3OqlNZRmsZPFqtfguek=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EeP7lgJL1KmoPAdMOdenX8PI4ZiSP6a0gcZiqbRDVdo0Bkavuye6PPepATh15wytTv8n0cG73YaVZJvmYs35OWZnGZ5KnaNc118PJ3+i3If6NEoVEPDghuFE4dWkpkmKXIKr5I7L97z+++BsljM1wrjrPZyvisOeCAvZgGu0Dws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iQ+bekuv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iQ+bekuv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750168697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bENOsIRAxg+jMcMN0GOm+0hWN/lXpSKL+NP33siNQU8=;
	b=iQ+bekuvfdZiVbYHZfc4YOc1NtlQRS6+CaFrWCMpyVgov8fsY4aOdeLbR6FjzkAyyrYj8r
	dSuEl8Vj0iMwZqwYPeaDGLFCvx6LuHC6GQU2/V1aiFkfPWP490YaDud1946aduNfYzBTxc
	nV8IomONJFCcDa5zwZwrD42TIeAIiDs=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-RG9lg8fiNqS-doU1RteLDA-1; Tue, 17 Jun 2025 09:58:16 -0400
X-MC-Unique: RG9lg8fiNqS-doU1RteLDA-1
X-Mimecast-MFC-AGG-ID: RG9lg8fiNqS-doU1RteLDA_1750168696
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-70e4269de4fso76263027b3.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jun 2025 06:58:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750168696; x=1750773496;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bENOsIRAxg+jMcMN0GOm+0hWN/lXpSKL+NP33siNQU8=;
        b=Rk0PSFR86sGiQkZk0zXssfkCs2C3alklrco5FxERqEnxlSpNF3QsSK5S6yg07+joFR
         QCV9NgMTCYFnzfw85sUB7UvyEvfud4XrET8hLsYnaVyMQJbOwq/Lrlwfs5HX2D3Tnl/n
         vQaHFhK4v1UK8G9Ylvq/TWZenXUVo/UEo7kJmvbLVALGQA+126l3KQXjU1DH2Xat1KSV
         oFxDab37411Y4A3C9uJdZ84PHaIFsTwMQZUuyt2NOt9EkCY5LLb8Nj7acipNjagi1+BX
         kQgx5hRYl7qQAgS3RctZK5yLrj671Y3CKwy5HkNnDd0X4ibcX5B9f5n349lbbnsekFAL
         hAzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrQ+JltOz1fKvfaXy2ghy2N0iIQ6AEv2lBcpn9H2mFEmIyDQw9XTaoydidZCDw94yF9q2iR6jEBYEk@vger.kernel.org
X-Gm-Message-State: AOJu0YyYnAJaqqotBtcLIlzASoMlQl85bhGdc2Vk0rjNl8dRnEoYJ0ik
	4xoJvw4Ocf0/1mPDIPLuPzBInKCEBtCnSnPOqe4xYALnTJk5CvoZtYhmuokl6g6nRvXzQFoaWF3
	RmCK9VuvO+PF+8yTp3eaGXDHFMe2hzGDEn+Swh/TXEDgzY9r1m6rOKtTnvNzE2Ng=
X-Gm-Gg: ASbGncsFQHI6V0PEp7d5ynzxS3YuiNXWR1ZRiEm7CuWHhA1D8p3s/vy1mEuA4IBV5Dm
	uZhAss9rcONVjfN8Q5xNhUZ0DtW8ZkQEhE7fBBOCPu0AMiBbq6ugt/eItKs7CdhzpGEA+WE+PJv
	EwKELMDEJanjjfCeKmULDSC3AgRb4OKaaH37hUTPcP0zHNtdpJDNmjnEMp2eXTlsaIdM4TuC6yh
	nHxaJbj2oVy1Em6xUNeA9r/3x4wktSZAS4t/C/h6kwD11Z9/U0Hzsa8gQGPe2oRGnmaEadXzaHS
	Jt95QgTMIQJSWnuFuJiZTYLRb5/xfyqcCwCNF6Z42TtmlrhNhHpDnTuNZ1Wwngefif7suyjo
X-Received: by 2002:a05:690c:688f:b0:70f:83af:7db1 with SMTP id 00721157ae682-711754dfc11mr196238417b3.19.1750168696136;
        Tue, 17 Jun 2025 06:58:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8BpLzZz4BKXDeh8JDK9hwMCQUTeKIwgrAeTc5hbfFEez9niTNWRIj2BpaXVbdmcugQvSmfQ==
X-Received: by 2002:a05:690c:688f:b0:70f:83af:7db1 with SMTP id 00721157ae682-711754dfc11mr196238067b3.19.1750168695804;
        Tue, 17 Jun 2025 06:58:15 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a? ([2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7119e3758e6sm5223547b3.101.2025.06.17.06.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 06:58:15 -0700 (PDT)
Message-ID: <aa8e177c053a91452f6dde4b31b876453d481077.camel@redhat.com>
Subject: Re: [PATCH] scsi: storvsc: set max_segment_size as UINT_MAX
 explicitly
From: Laurence Oberman <loberman@redhat.com>
To: Ming Lei <ming.lei@redhat.com>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-block@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Christoph Hellwig <hch@lst.de>, "Ewan D. Milne" <emilne@redhat.com>
Date: Tue, 17 Jun 2025 09:58:13 -0400
In-Reply-To: <20250616160509.52491-1-ming.lei@redhat.com>
References: <20250616160509.52491-1-ming.lei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-06-17 at 00:05 +0800, Ming Lei wrote:
> Set max_segment_size as UINT_MAX explicitly:
>=20
> - storvrc uses virt_boundary to define `segment`
>=20
> - strovrc does not define max_segment_size
>=20
> So define max_segment_size as UINT_MAX, otherwise __blk_rq_map_sg()
> takes
> default 64K max segment size and splits one virtual segment into two
> parts,
> then breaks virt_boundary limit.
>=20
> Before commit ec84ca4025c0 ("scsi: block: Remove now unused queue
> limits helpers"),
> max segment size is set as UINT_MAX in case that virt_boundary is
> defined.
>=20
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Wei Liu <wei.liu@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Laurence Oberman <loberman@redhat.com>
> Fixes: ec84ca4025c0 ("scsi: block: Remove now unused queue limits
> helpers")
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
> =C2=A0drivers/scsi/storvsc_drv.c | 1 +
> =C2=A01 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 2e6b2412d2c9..1e7ad85f4ba3 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1897,6 +1897,7 @@ static struct scsi_host_template scsi_driver =3D
> {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.no_write_same =3D=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.track_queue_depth =3D=C2=
=A0=C2=A0=C2=A0=C2=A01,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.change_queue_depth =3D=
=C2=A0=C2=A0=C2=A0storvsc_change_queue_depth,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.max_segment_size=C2=A0=C2=A0 =
=3D 0xffffffff,
> =C2=A0};
> =C2=A0
> =C2=A0enum {

Hello=20
For what it is worth, I tested Ming's patch in our lab and at our
customers and it fixed a very serious corruption in Oracle REDO logs.

Tested-by: Laurence Oberman  <loberman@redhat.com>

I will test what Christoph share dbut our initial way to deal with this
in RHEL will be the point fix in storvsc as its a critical issue
needing an urgent fix.

Thanks
Laurence

