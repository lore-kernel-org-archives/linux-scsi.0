Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8525518D
	for <linux-scsi@vger.kernel.org>; Sat, 21 Jun 2025 00:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750464743; cv=none; b=Oy86hQ/gWJ0+ffDyat1pdM7wuB1aA2skMI8QuXyoHD9W6BDoZk0Lt9eYDEyVXwegR/OIhaS4mIUxZEaYcJaESmhcMfCJN0Rcb63mhumVcP8T+Stn9n/a1Eo8hSYs+EzxnbEoOtA8yW2L+9LuPsFVgmV/PEMru4YtlnMK1ikMxTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750464743; c=relaxed/simple;
	bh=CqT2SNnxBIj3x4HSqPtguLFPwbeprOG1GveLCwU33W8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VlZMAIbZJFhBRdeZH104nYky+VCb5uEDlQA4u/zKgPSE/wc3LqKRRR8yBYGJIB9uzxuK7doIa8CPxHp2PYx19+8KVlrTnOhsn+vRpml7c0oeOxcxcIJBrmT0AgBe2UqOq4ztn7t/u0eFaRxxDKIZGADwgUtyGf13fB1yxO4RYbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h6sp7r9V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h6sp7r9V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750464740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ud8RjfWGNSaD0QBA8zWhPwNXyDJG8YP7ft/4E/heu0=;
	b=h6sp7r9Vi9K2LK+9gC7Sa49BVnP3fhFe89GsEjvLF7fkI3gm9HdBCMLbvIkggJcfAD0MQs
	NtHTFC8pWza5Ni67StTqu9wVhCxKGOyEL8yJcammDBaccTILHwg8wVM3XcvlkqvUjJxVY6
	5cycIihM6uoEwMDwRJaSYibnydzDclc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-czdpH1EOOzSdOs9TJv8Big-1; Fri, 20 Jun 2025 20:12:18 -0400
X-MC-Unique: czdpH1EOOzSdOs9TJv8Big-1
X-Mimecast-MFC-AGG-ID: czdpH1EOOzSdOs9TJv8Big_1750464738
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c5cd0f8961so476139585a.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2025 17:12:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750464738; x=1751069538;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3ud8RjfWGNSaD0QBA8zWhPwNXyDJG8YP7ft/4E/heu0=;
        b=rfF5KLjq4qQ42FwW8PPd9ZBr603A7lPR38WYbLjeh9Nv0B6NFTOsOA2S2Qy0vEkhei
         bvNQ1E2lwOTlfhtfus8Q91fXp6+2FQdgk7MVl1HHklWHRDWWu8K51SiRAVi5FazCKSHr
         5ifvyPHxEKgrIQN/WSHJ+7sSumjh6A0tQ0fJTHv/C8n21hDUCfFeFFqn+BiCMoM4XnP+
         4lZaRPi+ygDgFZ3AWJxiN7R+GshoDAsxJ54IZiHPL/O7bt9tX4jaF3H1Nn5Nx7HB2Fay
         7YU8NyZ+ptDp68cQSLtzToOF82vT1p1ix4kcTiPvctfIS0kgLi+OYFilLg+8k1H1pRLQ
         arSw==
X-Forwarded-Encrypted: i=1; AJvYcCXFg55Y3NfZKv+mwXuLyL9AewS2VQtUl+k5eTZcmpZ4BMF+UnuisE+sYv46XolYoreCM8a2P1i2hkrm@vger.kernel.org
X-Gm-Message-State: AOJu0YzwMyr4iav8zN9mLke14LtNfjBjwRu+mvAYUKJHBuvg1a5OXY0r
	9hKQ2oBZ4sBDGn90/4FnwNc5JnZpB9XW1gle1DS+mKd5Y+TUAmKEvUZIcx3gVk93C+Nf9Wmot2j
	CVTFtk7igUxSkw10oGct+3cl8tei/IoMhtF3apqQXXtWkkj9xSSK0DcaU7ZTaR4s=
X-Gm-Gg: ASbGnctyN7l/8mAmaiicNsQk4klvIWUvAaBLYzfCf1EMhffGmROeretKqcsgqjfyOid
	7P1C/iJpJqZZrS28B0D5BwfPuORr7hpzgD282yuVxcMCOp27Z/0OvCVI/D3Ai6xr28hn9HbVosn
	7nY6K8XSy2fEbE6mGWZJB9d2I8STsBMGutcQacv3/GRlKoQwL3pfFBhVDzEig/LkWLJO6z6NUN4
	K/9kyruLLzpc4dUQ+MfTernwr5AMNpLcTK4opdr5eRyokDEydRQNemP1uUKKjTNbknZQwHlbFBD
	WEFWMFbGpTh7v6yrEWFfQRD86+ty/zeSa9oTZmRO/ox4cUM6b+l5XcAAa3v5K4/Qx5uqgjR4x1t
	ht4O3BiqKhpE4L28Q
X-Received: by 2002:a05:620a:84c8:b0:7d3:9113:78f6 with SMTP id af79cd13be357-7d3f995622bmr806683185a.49.1750464738249;
        Fri, 20 Jun 2025 17:12:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDiGAV6LwHQJTBlNF+heRdcF87AJlNZ8NkAe9KufaDq2/2Ds6tfLhWfwz/EG8PBgTg3byLjw==
X-Received: by 2002:a05:620a:84c8:b0:7d3:9113:78f6 with SMTP id af79cd13be357-7d3f995622bmr806680885a.49.1750464737904;
        Fri, 20 Jun 2025 17:12:17 -0700 (PDT)
Received: from syn-2600-6c64-4e7f-603b-9b92-b2ac-3267-27e9.biz6.spectrum.com ([2600:6c64:4e7f:603b:9b92:b2ac:3267:27e9])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3f99fbdfasm144854585a.85.2025.06.20.17.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 17:12:17 -0700 (PDT)
Message-ID: <d122346c3aea794087da7d9f166a412349517503.camel@redhat.com>
Subject: Re: [PATCH] scsi: storvsc: set max_segment_size as UINT_MAX
 explicitly
From: Laurence Oberman <loberman@redhat.com>
To: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, "K. Y. Srinivasan"
	 <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu
	 <wei.liu@kernel.org>, "Ewan D. Milne" <emilne@redhat.com>
Date: Fri, 20 Jun 2025 20:12:15 -0400
In-Reply-To: <20250617050240.GA2178@lst.de>
References: <20250616160509.52491-1-ming.lei@redhat.com>
	 <20250617050240.GA2178@lst.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-11.el9) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 2025-06-17 at 07:02 +0200, Christoph Hellwig wrote:
> Please try this proper fix instead:
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index e021f1106bea..09f5fb5b2fb1 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -473,7 +473,9 @@ struct Scsi_Host *scsi_host_alloc(const struct
> scsi_host_template *sht, int priv
>         else
>                 shost->max_sectors = SCSI_DEFAULT_MAX_SECTORS;
>  
> -       if (sht->max_segment_size)
> +       if (sht->virt_boundary_mask)
> +               shost->virt_boundary_mask = sht->virt_boundary_mask;
> +       else if (sht->max_segment_size)
>                 shost->max_segment_size = sht->max_segment_size;
>         else
>                 shost->max_segment_size = BLK_MAX_SEGMENT_SIZE;
> @@ -492,9 +494,6 @@ struct Scsi_Host *scsi_host_alloc(const struct
> scsi_host_template *sht, int priv
>         else
>                 shost->dma_boundary = 0xffffffff;
>  
> -       if (sht->virt_boundary_mask)
> -               shost->virt_boundary_mask = sht->virt_boundary_mask;
> -
>         device_initialize(&shost->shost_gendev);
>         dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
>         shost->shost_gendev.bus = &scsi_bus_type;
> 

Hello

Not sure what you folks will decide as the final fix but Christoph's
patch prevents the REDO corruption as well.
Ran it long enough to know its clean from corruption with this patch
above

Tested-by: Laurence Oberman <loberman@redhat.com>

Thanks vey mauch as always folks

Regards
Laurence




