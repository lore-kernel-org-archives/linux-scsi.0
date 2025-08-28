Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9538338F4D
	for <linux-scsi@vger.kernel.org>; Thu, 28 Aug 2025 18:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756407186; cv=none; b=GBFTb8CIngizIeheZBPZub2jxm2I0uRSePpb9NxsZ2A4b0+BH4uJRzOaOfCXY4dqbCMPutGgWxeFlmJbrWQd6HlrpzvkzMsZrZNV0p58G5h/V44ITzuPmxYOTIGZbnAXHSqYCL2ynCIVwpQHwdpYAsZVGEw0CZUbtXirkuACdfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756407186; c=relaxed/simple;
	bh=CgULwvBoKBpoCxSt14lLKe61Fel/Z9Jurl+x1vHCKzw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JXyfzpjEBCgljXo/c1b+InB+tZemUAQhtdNYnv0wtooVdSk9YS4BdiEzXmBE8sS2NggLLQmRBe62dximRtNYCRRzoMK+PBxmUSN+2T/VWMMD+GJm5f/K29WbXZOQFRCK+vSkVIUqgv2g7YPG1mfgl/istW2gU/IbyoL6t7RLknw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gy6ZHyGG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gy6ZHyGG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756407183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ox+fdqHLvqvHkCQcV7jSITHMPKa6EWT2tpRcTnamaBA=;
	b=gy6ZHyGGo9GVawUP8ySaLtGYTPtuLwen1YSYJHjF5sEU6YtEvZKziHagBPiu9yBMGxkyuu
	e+pqkewfGQ8IKM8RT60+T040Q0cX/EW+O6Z6Jq5rN/XL1BWuBSqf+FU4L/mODA4ui2lTlV
	AZPD3guumDnn8nOoYnBk0jm77JmD9kw=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225-JvYVli1oMmypf_exBhRIIg-1; Thu, 28 Aug 2025 14:52:57 -0400
X-MC-Unique: JvYVli1oMmypf_exBhRIIg-1
X-Mimecast-MFC-AGG-ID: JvYVli1oMmypf_exBhRIIg_1756407176
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3ebd3ca6902so3309615ab.3
        for <linux-scsi@vger.kernel.org>; Thu, 28 Aug 2025 11:52:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756407176; x=1757011976;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ox+fdqHLvqvHkCQcV7jSITHMPKa6EWT2tpRcTnamaBA=;
        b=ZCD5z6LCUyYhzkPx4EQgioIlVjDIwFMEk47wUDrDX6ocQVQ4ltZ40u1Ksttn4sIRu2
         4ovf22uu/xLHABJyHBjrUdkLWoZNxpGhMKhuJKUR5joMG7N+UpsJYPofGpFum/QlfVgX
         Q9uCLCxV1O57VyMAo9j0Tt0DKhOEynjcEsT2dOScGfHW32+aNgH1Xg7V5aTDYLRfiNZU
         ANOWgB+YZVhVmKLW/ESl30frJ1JdMpEm7TfIxukL2juxCiNHC5QBj4RHRUDbI04YoZFB
         GRHYSq9nf8h2x65+DJ6mHn3+eGV+WF30zW6xdgPqsVFl32Kobvw4dYWk0cXMDdEUCTdP
         iqcw==
X-Forwarded-Encrypted: i=1; AJvYcCWcKYs0Vwh0GYc8ZQaVdb7p1OIJRIBz5wDO1WINAJ3IAIwKzOEbemGAPbTKKqfGYX+Skm+arGlweyN2@vger.kernel.org
X-Gm-Message-State: AOJu0YzGkC/12r+S2ZNPpHPnycVPK5QdnsJqhRMHIkGeH7JFeYZGYgxm
	/AJk1eYb+mCvJk1T9CobeBln1isAe14fsRUHpUMQR6hf+bPV5RPmAAiB6dgMVfylxwkN4g23EeS
	YPuBdxNAF+sRiafkV4Uxs6IYM1sxc3xB/bp+7A8FF4MpjD95NGLDPvrmAidh9yQA=
X-Gm-Gg: ASbGnctRQocr5EdxnZJDBCQ2kPX7CeHlfRJ5B6Nbe86b027iOtBY6msru/pLKa3orOa
	Nivm23OA2TjIoRuZoaAOfeUPfCQCKSJQCcIcb3d0F5n7ntg64boqYeHi38F6Tq1KJ3NZf+TOHDF
	4XowxAe3i4tmcDebzv2kpalLvUcaWopDRrTaNg+B913cw/pbcK/2hwX05pLtwUCwLKgoED00xW4
	RRsMJ6TWxonNrs+DzPMYbpA/pTiAK//z+ofNCyUE8c/M0hjEqrF2Y+y7JKs0DrnFtAxPwJP+w9S
	LWAZ83PbY5RJceYCfwNgUiFBl3wvxfdhBWPQxlUCfIk=
X-Received: by 2002:a05:6e02:1a86:b0:3ee:cb14:e90f with SMTP id e9e14a558f8ab-3eecb14ea03mr61888705ab.7.1756407176407;
        Thu, 28 Aug 2025 11:52:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEP6X5C8fKyFwSWmjzqPdfkbd7PprjZnYQm1xQXLb3Ss2KjE+y/MhfTqxlaUhO3jzRNfBiTrg==
X-Received: by 2002:a05:6e02:1a86:b0:3ee:cb14:e90f with SMTP id e9e14a558f8ab-3eecb14ea03mr61888495ab.7.1756407175934;
        Thu, 28 Aug 2025 11:52:55 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50d78c67b4dsm47783173.7.2025.08.28.11.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 11:52:54 -0700 (PDT)
Date: Thu, 28 Aug 2025 12:52:51 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Brett Creeley <brett.creeley@amd.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Shameer
 Kolothum <shameerali.kolothum.thodi@huawei.com>, Kevin Tian
 <kevin.tian@intel.com>, Alexander Potapenko <glider@google.com>, Andrew
 Morton <akpm@linux-foundation.org>, Brendan Jackman <jackmanb@google.com>,
 Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, Dmitry
 Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
 io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe
 <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, John Hubbard
 <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Linus Torvalds
 <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski
 <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, Peter Xu
 <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>, Suren
 Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 31/36] vfio/pci: drop nth_page() usage within SG
 entry
Message-ID: <20250828125251.08e4a429.alex.williamson@redhat.com>
In-Reply-To: <20250827220141.262669-32-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
	<20250827220141.262669-32-david@redhat.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 28 Aug 2025 00:01:35 +0200
David Hildenbrand <david@redhat.com> wrote:

> It's no longer required to use nth_page() when iterating pages within a
> single SG entry, so let's drop the nth_page() usage.
> 
> Cc: Brett Creeley <brett.creeley@amd.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Yishai Hadas <yishaih@nvidia.com>
> Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  drivers/vfio/pci/pds/lm.c         | 3 +--
>  drivers/vfio/pci/virtio/migrate.c | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
> index f2673d395236a..4d70c833fa32e 100644
> --- a/drivers/vfio/pci/pds/lm.c
> +++ b/drivers/vfio/pci/pds/lm.c
> @@ -151,8 +151,7 @@ static struct page *pds_vfio_get_file_page(struct pds_vfio_lm_file *lm_file,
>  			lm_file->last_offset_sg = sg;
>  			lm_file->sg_last_entry += i;
>  			lm_file->last_offset = cur_offset;
> -			return nth_page(sg_page(sg),
> -					(offset - cur_offset) / PAGE_SIZE);
> +			return sg_page(sg) + (offset - cur_offset) / PAGE_SIZE;
>  		}
>  		cur_offset += sg->length;
>  	}
> diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
> index ba92bb4e9af94..7dd0ac866461d 100644
> --- a/drivers/vfio/pci/virtio/migrate.c
> +++ b/drivers/vfio/pci/virtio/migrate.c
> @@ -53,8 +53,7 @@ virtiovf_get_migration_page(struct virtiovf_data_buffer *buf,
>  			buf->last_offset_sg = sg;
>  			buf->sg_last_entry += i;
>  			buf->last_offset = cur_offset;
> -			return nth_page(sg_page(sg),
> -					(offset - cur_offset) / PAGE_SIZE);
> +			return sg_page(sg) + (offset - cur_offset) / PAGE_SIZE;
>  		}
>  		cur_offset += sg->length;
>  	}

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

