Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6397E2D1925
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 14:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750774904; cv=none; b=q/m7BcMUF40xCUjDTmfci1mu9pL0WVswqFx81QHsePlLO0MZR3896v+3XzXz5L/4RyWuIURVD0j/TkoxiOt67eXI237pYjkCtj0lP8qt+T/NnbpLjNTgKbSlcPppht762KwLltG80O047+fLCWpEC+jbCvjvv3yvT695x78QA4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750774904; c=relaxed/simple;
	bh=XwnGdWQkYlApWdZit8M7GQi5s2uWr0s+SHL5bLPxKSY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RNb0QSm4lEY6s5AcrHPDM2M9xYebx1F/NvaYzryr+uKN38uiU5lFUDdK9bJ+PcK4tC/lIolnPdHNeXXqemozbrgfWjyvTplisE5mRhJXTJD+U5ZzT6jLRDwNNQw3Xm4pJEjFZ6lh/LMuKATYcCa4q/fKziU0Q86rwWHnZQMXK6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H2SS3SPn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H2SS3SPn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750774901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=14xIxMy2YUHY1lgAeFKa78vWXvA9MuYA/3dz475p8Z8=;
	b=H2SS3SPnutJdbeEVJvjEeC83nwXo5Xonku8dRF970uqkM9MgKlICAGBsHz2lplocZ1dycD
	6DrZIG0ARg9GPBPOdiIqv4J1V6HgEOtMeD9V80XAqcNZzbS8pUzs6QCN01WA/sKejiTEPh
	BimO9kYfgu4nYdSOgkQ+a9hfsVrbGCA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-MzXkzIYHMA-kiaqzg7hoKQ-1; Tue, 24 Jun 2025 10:21:40 -0400
X-MC-Unique: MzXkzIYHMA-kiaqzg7hoKQ-1
X-Mimecast-MFC-AGG-ID: MzXkzIYHMA-kiaqzg7hoKQ_1750774899
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7d0aa9cdecdso433177385a.3
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 07:21:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750774899; x=1751379699;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=14xIxMy2YUHY1lgAeFKa78vWXvA9MuYA/3dz475p8Z8=;
        b=Od3cp0ph2+7s8dHJq6SQGfFfzdAaqKXt4EeSpEgcvDSLNEVdCtvCyCO0dWgNf6Sh2t
         griolf5L2PpCl7QjnfHC82dSf052YMcxooFyHU7NrPUowDXvSjLSZNgL7pDbFR80CXKF
         lj6VKfDRMNBYgZGOjMCTrWKvggfqXFMbWcZBi2DBqpYntAXp1hRr+W3Gs5+w0G3zagqJ
         E+i+6TGqPq/29SRmLZj9V/H3X/zomyhn0EQRc9bAP38NFN8k0Z731sFyiApq8Hij8WR+
         UEVhMRYf5fgDUjUIK5mpmLWHh4sswUth1azCuhpyvX74j/ZaUFKbtaCVljqkvmZQgMZa
         viOA==
X-Forwarded-Encrypted: i=1; AJvYcCVOIg3HU5/EbcRNmMn7trRjgv5W+0TDN0G2Hg6U9Xgif7/SxNv1JyCSSNwTXt937BpsNHsgu2OoUGsX@vger.kernel.org
X-Gm-Message-State: AOJu0YzDjiEsXOs7FElwNVioMGGAbWz4rZLVfngmIZ4wDtmxz/eSEV+c
	hLEf4DKTDoK7wn/A2Ao44sJ/q/pN+3jE+UD663ANiSUYXR0wH+E3tjdYL4ahQYJj+FRDQ7Hs80c
	z/DxPeUM84odV++fT6qlCPfpghDQFPDOa/UqpqpOGou8VebPlGGh58utpZSA2ZRg=
X-Gm-Gg: ASbGnctJ47QSRmtyO3WyNFmuT5PvePRVbq9YlNpzu4XVOoHZUR6QkprIAzjvGNjJ+Kv
	8Kmp7CsDBWHwUeC5fN8uSDWsA4DWwVcYVzUv3wA5ktV0HoWRdvMAG+slzBe6hG0b55aKboMX/oN
	DhpCgwZvNJ9uXA4j8EOOpdY+IEuOPdojY7YpgADN2kWf1cz2Y6KjhQLnzYJyMSZqfWzutGLSxD5
	frztHvq0BfSBaOsK/sxerljIAoEqx/HIyRKXKpcwWRS1JyoQpArmDeXGfmxcNYCOy5LckXIuW86
	gRSfYr/s9q5L+1Isn1jGONYssxwhMPTKg4nscLkMRu7Kz91i0IwqJHEyYbd1dAulZA1o/0kIH76
	2YAwRthenHeWDaUP+
X-Received: by 2002:a05:620a:410f:b0:7d3:c67f:7532 with SMTP id af79cd13be357-7d3f99327ccmr2313483085a.40.1750774899259;
        Tue, 24 Jun 2025 07:21:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFR3cDql3VJLUr0EuiZIXkdr5u/svh4yWrVWPkzjWNmljf9JBpmaP0fofJOKq3rHI7yZwMwag==
X-Received: by 2002:a05:620a:410f:b0:7d3:c67f:7532 with SMTP id af79cd13be357-7d3f99327ccmr2313476085a.40.1750774898607;
        Tue, 24 Jun 2025 07:21:38 -0700 (PDT)
Received: from syn-2600-6c64-4e7f-603b-9b92-b2ac-3267-27e9.biz6.spectrum.com ([2600:6c64:4e7f:603b:9b92:b2ac:3267:27e9])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3f99a6755sm504639885a.32.2025.06.24.07.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 07:21:37 -0700 (PDT)
Message-ID: <a665dead67bf4f3432cf1bddf29d2c573ab71673.camel@redhat.com>
Subject: Re: fix virt_boundary_mask handling in SCSI
From: Laurence Oberman <loberman@redhat.com>
To: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen"
	 <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Ming Lei <ming.lei@redhat.com>, 
	"K. Y. Srinivasan"
	 <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu
	 <wei.liu@kernel.org>, "Ewan D. Milne" <emilne@redhat.com>, 
	linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-block@vger.kernel.org
Date: Tue, 24 Jun 2025 10:21:36 -0400
In-Reply-To: <20250623080326.48714-1-hch@lst.de>
References: <20250623080326.48714-1-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-11.el9) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 2025-06-23 at 10:02 +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series fixes a corruption when drivers using virt_boundary_mask
> set
> a limited max_segment_size by accident, which Red Hat reported as
> causing
> data corruption with storvsc.  I did audit the tree and also found
> that
> this can affect SRP and iSER as well.
> 
> Note that I've dropped the Tested-by from Laurence because the patch
> changed very slightly from the last version.
> 
> Diffstat:
>  infiniband/ulp/srp/ib_srp.c |    5 +++--
>  scsi/hosts.c                |   20 +++++++++++++-------
>  2 files changed, 16 insertions(+), 9 deletions(-)
> 
Grabbing latest and will test tomorrow and reply

